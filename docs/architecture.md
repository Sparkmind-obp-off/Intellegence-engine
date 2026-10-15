# Architecture

## Layers
1. Edge/API: Cloudflare Worker, request ID, auth, CORS allowlist, rate limits, validation.
2. Application: use cases, orchestration, transaction boundaries.
3. Domain: entities, state transitions, normalization, deterministic scoring; no vendor SDK imports.
4. Ports: discovery provider, LLM, storage, clock, queue.
5. Adapters: Apify REST, D1, optional R2, optional Workers AI or external model API.
6. Operations: logs, metrics, usage ledger, audit, migrations, deployment config.

## Flow
Client -> Worker middleware -> workspace authentication -> request validation -> use case -> budget/policy check -> provider or database -> normalization -> persistence -> response.

Long-running collection should be asynchronous. A discovery endpoint should enqueue a bounded job and return 202; until queue execution exists, expose dry-run validation only.

## Cloudflare topology
Workers for API; D1 for structured records; optional private R2 for raw artifacts; Queues for async jobs when implemented; Workers AI optional after model/account capabilities are verified.

## Reliability
Idempotency keys; explicit job states; bounded retries/backoff; response size caps; terminal failures; explicit partial status. Separate local, preview and production resources/secrets.

## Decisions
ADR-001 TypeScript + Workers. ADR-002 D1. ADR-003 Apify behind provider port and Actor allowlist. ADR-004 deterministic baseline scoring first. ADR-005 OpenAPI 3.1 contract. ADR-006 no autonomous outbound actions in MVP.