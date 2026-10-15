PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS workspaces (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active','suspended','deleted')),
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS api_keys (
  id TEXT PRIMARY KEY,
  workspace_id TEXT NOT NULL REFERENCES workspaces(id),
  label TEXT NOT NULL,
  key_hash TEXT NOT NULL UNIQUE,
  scopes_json TEXT NOT NULL DEFAULT '[]',
  status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active','revoked','expired')),
  expires_at TEXT,
  last_used_at TEXT,
  created_at TEXT NOT NULL,
  revoked_at TEXT
);
CREATE INDEX IF NOT EXISTS idx_api_keys_workspace_status ON api_keys(workspace_id, status);

CREATE TABLE IF NOT EXISTS discovery_jobs (
  id TEXT PRIMARY KEY,
  workspace_id TEXT NOT NULL REFERENCES workspaces(id),
  source TEXT NOT NULL,
  query_text TEXT NOT NULL,
  request_json TEXT NOT NULL,
  status TEXT NOT NULL CHECK (status IN ('queued','validating','running','normalizing','completed','partial','failed','cancelled')),
  idempotency_key TEXT NOT NULL,
  budget_limit REAL NOT NULL CHECK (budget_limit >= 0),
  budget_reserved REAL NOT NULL DEFAULT 0 CHECK (budget_reserved >= 0),
  budget_actual REAL,
  result_count INTEGER NOT NULL DEFAULT 0,
  error_code TEXT,
  created_at TEXT NOT NULL,
  started_at TEXT,
  finished_at TEXT,
  UNIQUE(workspace_id, idempotency_key)
);
CREATE INDEX IF NOT EXISTS idx_jobs_workspace_created ON discovery_jobs(workspace_id, created_at);
CREATE INDEX IF NOT EXISTS idx_jobs_workspace_status ON discovery_jobs(workspace_id, status);

CREATE TABLE IF NOT EXISTS provider_runs (
  id TEXT PRIMARY KEY,
  workspace_id TEXT NOT NULL REFERENCES workspaces(id),
  job_id TEXT NOT NULL REFERENCES discovery_jobs(id),
  provider TEXT NOT NULL,
  actor_key TEXT,
  provider_run_id TEXT,
  dataset_id TEXT,
  status TEXT NOT NULL,
  usage_estimate REAL,
  usage_actual REAL,
  result_count INTEGER NOT NULL DEFAULT 0,
  started_at TEXT,
  finished_at TEXT,
  error_code TEXT,
  created_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_provider_runs_job ON provider_runs(workspace_id, job_id);

CREATE TABLE IF NOT EXISTS source_records (
  id TEXT PRIMARY KEY,
  workspace_id TEXT NOT NULL REFERENCES workspaces(id),
  provider TEXT NOT NULL,
  source_type TEXT NOT NULL,
  source_record_id TEXT,
  source_url TEXT,
  canonical_url TEXT,
  observed_at TEXT,
  collected_at TEXT NOT NULL,
  content_fingerprint TEXT NOT NULL,
  normalized_payload_json TEXT NOT NULL,
  job_id TEXT REFERENCES discovery_jobs(id),
  created_at TEXT NOT NULL,
  UNIQUE(workspace_id, provider, content_fingerprint)
);
CREATE INDEX IF NOT EXISTS idx_source_records_workspace_collected ON source_records(workspace_id, collected_at);

CREATE TABLE IF NOT EXISTS demand_signals (
  id TEXT PRIMARY KEY,
  workspace_id TEXT NOT NULL REFERENCES workspaces(id),
  signal_type TEXT NOT NULL CHECK (signal_type IN ('pain','question','workaround','buying_intent','dissatisfaction','trend')),
  summary TEXT NOT NULL,
  confidence REAL CHECK (confidence IS NULL OR (confidence >= 0 AND confidence <= 1)),
  urgency REAL CHECK (urgency IS NULL OR (urgency >= 0 AND urgency <= 1)),
  intent_strength REAL CHECK (intent_strength IS NULL OR (intent_strength >= 0 AND intent_strength <= 1)),
  extraction_version TEXT NOT NULL,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_signals_workspace_created ON demand_signals(workspace_id, created_at);
CREATE TABLE IF NOT EXISTS signal_evidence (
  workspace_id TEXT NOT NULL REFERENCES workspaces(id),
  signal_id TEXT NOT NULL REFERENCES demand_signals(id) ON DELETE CASCADE,
  source_record_id TEXT NOT NULL REFERENCES source_records(id) ON DELETE CASCADE,
  stance TEXT NOT NULL DEFAULT 'supporting' CHECK (stance IN ('supporting','counter','context')),
  created_at TEXT NOT NULL,
  PRIMARY KEY(signal_id, source_record_id)
);

CREATE TABLE IF NOT EXISTS signal_clusters (
  id TEXT PRIMARY KEY,
  workspace_id TEXT NOT NULL REFERENCES workspaces(id),
  label TEXT NOT NULL,
  summary TEXT NOT NULL,
  clustering_version TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'candidate',
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS cluster_members (
  workspace_id TEXT NOT NULL REFERENCES workspaces(id),
  cluster_id TEXT NOT NULL REFERENCES signal_clusters(id) ON DELETE CASCADE,
  signal_id TEXT NOT NULL REFERENCES demand_signals(id) ON DELETE CASCADE,
  created_at TEXT NOT NULL,
  PRIMARY KEY(cluster_id, signal_id)
);

CREATE TABLE IF NOT EXISTS opportunities (
  id TEXT PRIMARY KEY,
  workspace_id TEXT NOT NULL REFERENCES workspaces(id),
  title TEXT NOT NULL,
  hypothesis TEXT NOT NULL,
  summary TEXT NOT NULL,
  score INTEGER NOT NULL CHECK (score >= 0 AND score <= 100),
  score_breakdown_json TEXT NOT NULL,
  score_version TEXT NOT NULL,
  confidence REAL CHECK (confidence IS NULL OR (confidence >= 0 AND confidence <= 1)),
  status TEXT NOT NULL DEFAULT 'draft' CHECK (status IN ('draft','needs_review','validated','rejected','archived')),
  next_validation_action TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_opportunities_workspace_status ON opportunities(workspace_id, status, score);

CREATE TABLE IF NOT EXISTS opportunity_evidence (
  workspace_id TEXT NOT NULL REFERENCES workspaces(id),
  opportunity_id TEXT NOT NULL REFERENCES opportunities(id) ON DELETE CASCADE,
  source_record_id TEXT NOT NULL REFERENCES source_records(id) ON DELETE CASCADE,
  stance TEXT NOT NULL CHECK (stance IN ('supporting','counter','context')),
  created_at TEXT NOT NULL,
  PRIMARY KEY(opportunity_id, source_record_id)
);

CREATE TABLE IF NOT EXISTS reviews (
  id TEXT PRIMARY KEY,
  workspace_id TEXT NOT NULL REFERENCES workspaces(id),
  opportunity_id TEXT NOT NULL REFERENCES opportunities(id) ON DELETE CASCADE,
  decision TEXT NOT NULL CHECK (decision IN ('validate','reject','needs_more_evidence')),
  rationale TEXT NOT NULL,
  reviewer_key_id TEXT REFERENCES api_keys(id),
  created_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_reviews_opportunity ON reviews(workspace_id, opportunity_id, created_at);

CREATE TABLE IF NOT EXISTS usage_ledger (
  id TEXT PRIMARY KEY,
  workspace_id TEXT NOT NULL REFERENCES workspaces(id),
  job_id TEXT REFERENCES discovery_jobs(id),
  provider TEXT NOT NULL,
  event_type TEXT NOT NULL,
  amount_estimate REAL NOT NULL DEFAULT 0,
  amount_actual REAL,
  currency TEXT NOT NULL DEFAULT 'USD',
  external_reference TEXT,
  metadata_json TEXT NOT NULL DEFAULT '{}',
  created_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_usage_workspace_created ON usage_ledger(workspace_id, created_at);

CREATE TABLE IF NOT EXISTS audit_events (
  id TEXT PRIMARY KEY,
  workspace_id TEXT NOT NULL REFERENCES workspaces(id),
  actor_type TEXT NOT NULL,
  actor_id TEXT,
  action TEXT NOT NULL,
  target_type TEXT,
  target_id TEXT,
  request_id TEXT,
  metadata_json TEXT NOT NULL DEFAULT '{}',
  created_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_audit_workspace_created ON audit_events(workspace_id, created_at);
