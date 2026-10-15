# Database Design

## Engine and isolation
Cloudflare D1 (SQLite). Use numbered SQL migrations, foreign keys, UTC ISO-8601 timestamps, opaque UUID/ULID IDs. Every customer-owned record carries workspace_id and every repository query enforces workspace scope.

## Tables
- workspaces: tenant and status.
- api_keys: key hash, label, scopes, status, expiry, last use.
- discovery_jobs: request, state, idempotency, budget limit/reservation/actual, counters.
- provider_runs: provider/Actor, run and dataset IDs, status, usage, errors.
- source_records: provider IDs, source URL, observed/collected times, content fingerprint, normalized payload.
- demand_signals: type, summary, confidence, urgency, intent strength, extraction version.
- signal_evidence: link signals to source records with supporting/counter/context stance.
- signal_clusters and cluster_members: cluster labels/version and membership.
- opportunities: hypothesis, score, score breakdown/version, confidence, status, next action.
- opportunity_evidence: supporting/counter/context records.
- reviews: human decision, rationale, reviewer and timestamp.
- usage_ledger: estimated and actual cost events.
- audit_events: actor, action, target, request ID, redacted metadata.

## Lifecycle
Default to URLs and limited normalized excerpts; avoid sensitive personal data. Raw payloads in private R2 are optional and require retention policy. Never store plaintext API keys. Index workspace + created_at/status for list queries; enforce uniqueness for idempotency and provider fingerprints.

Never conflate a source record with a demand signal, or a demand signal with a validated opportunity. Add migrations rather than editing applied production migrations.