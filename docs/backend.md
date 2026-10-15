# Backend Specification

## Runtime
TypeScript on Cloudflare Workers. Hono may be used as a thin router; domain logic must not depend on it.

## Middleware order
Request ID; CORS preflight; security headers and body-size limits; route/method; authentication; rate/concurrency limits; schema validation; use case; redacted structured logs; stable JSON response.

## Error envelope
{"error":{"code":"VALIDATION_ERROR","message":"Human-readable summary","requestId":"..."}}

Use stable status codes: 400 malformed input, 401 invalid credentials, 403 scope denied, 404 unknown resource, 409 state/idempotency conflict, 413 oversized body, 429 rate/budget limit, 502 provider failure, 503 disabled capability, 500 unexpected error. Never expose stack traces, tokens, SQL, or raw upstream error bodies.

## Target endpoints
- GET /health — liveness only.
- GET /v1/capabilities — non-sensitive enabled capabilities.
- POST /v1/discovery/jobs — validate and create bounded job; return 202.
- GET /v1/discovery/jobs/{jobId} — workspace-scoped job status.
- GET /v1/signals — paginated signals and evidence refs.
- GET /v1/opportunities — paginated candidates and score breakdown.
- GET /v1/opportunities/{id} — candidate details and counter-evidence.
- POST /v1/opportunities/{id}/reviews — human decision and rationale.
- GET /v1/usage — workspace usage ledger.

These are target contracts, not claims that the endpoints are implemented.

## Auth and authorization
Use high-entropy API keys, store only a one-way hash, support scopes/revocation, send in Authorization: Bearer header, never query string. Every read/write must be scoped to the authenticated workspace; never trust client-supplied workspace IDs alone.

## Idempotency and limits
Discovery job creation requires an idempotency key. Bound page size, text length, results, Actor input, runtime, concurrency, and budget. Do not accept arbitrary Actor IDs from clients.

## Cost safety
Reserve estimated cost before provider dispatch and reconcile after completion. External side effects require separate approval. Every state-changing action writes an audit event.