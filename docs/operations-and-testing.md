# Operations and Testing

## Environments
Local with mocks/local D1; preview with isolated database and provider disabled; production with separate resources/secrets and explicitly approved bounded live tests.

## Required tests
- Unit: normalization, deduplication, scoring, state transitions, budget arithmetic.
- API: authentication, scopes, validation, pagination, rate limits, error envelope.
- Database: fresh migration and upgrade path.
- Apify: mocked contract tests; no paid Actor in routine tests.
- LLM: mocked response, schema violation, timeout, quota.
- Security: cross-workspace denial, secret redaction, prompt-injection fixture, oversized body.
- Smoke: health and OpenAPI after deployment.

## Observability
Structured logs with requestId, jobId, opaque workspace ID, provider, duration, state and counts. Redact tokens, auth headers, personal records and raw scraped text. Track success/partial/failure, latency, estimated/actual cost, retries and rate limits.

## Release checklist
Review dependencies; run tests/typecheck; migrate staging; verify bindings without printing secrets; review Actor allowlist and budget; run mock smoke tests; only with approval run one bounded live test; reconcile usage; deploy; verify auth boundaries and rollback.

## Rollback
Disable provider dispatch first. Prefer backward-compatible Worker releases and additive migrations; do not drop production tables as a first response.