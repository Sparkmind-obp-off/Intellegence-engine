# Roadmap and Acceptance Criteria

## P0 Foundation
Architecture, API contract, initial D1 schema, security/cost policies. Acceptance: docs agree on domain names, data boundaries, auth, and provider behavior.

## P1 API and persistence
Worker routes, request validation, D1 repositories, workspace/API-key auth. Acceptance: local tests pass and cross-workspace access is denied.

## P2 Apify discovery
Actor allowlist, schemas, dry-run, bounded dispatch, job lifecycle, dataset normalization, usage ledger. Acceptance: mocks pass; unknown Actor and over-budget jobs are rejected.

## P3 Demand Intelligence
Rule-based signal extraction, evidence links, deduplication, freshness, cluster candidates. Acceptance: every signal traces to evidence and deduplication preserves provenance.

## P4 Opportunity Intelligence
Versioned transparent scoring, counter-evidence, review workflow. Acceptance: score is reproducible and human decisions are audited.

## P5 Optional LLM
Provider-neutral adapter, one provider, schema validation and prompt-injection tests. Acceptance: system works when AI is disabled and budgets are enforced.

## P6 UI and validation
Build a review console only after the API workflow works; validate with real users before adding more providers.

Out of scope until approved: autonomous posting/DM, arbitrary Actor execution, expensive always-on inference, and production launch claims before live verification.