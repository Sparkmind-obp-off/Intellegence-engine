# Documentation Index

## Product and architecture
- product-and-domains.md — Demand, Discovery, Opportunity domains and state machines.
- architecture.md — layers, request flow, deployment topology, reliability.
- repository-map.md — target source tree and dependency direction.
- stack-decisions.md — Cloudflare, Apify, database, and LLM provider decisions.
- roadmap.md — phases and acceptance criteria.

## Implementation contracts
- backend.md — API middleware, endpoint intent, authentication, authorization, limits.
- api-guidelines.md — versioning, scoring transparency, pagination, error behavior.
- database.md — D1 entities, isolation, lifecycle, migrations.
- integrations.md — Apify adapter, LLM port, provider policy and failure semantics.
- security-and-privacy.md — secrets, privacy, prompt injection, cost and incident controls.
- operations-and-testing.md — environment strategy, tests, observability, release and rollback.

## Source artifacts
- ../openapi/openapi.yaml — draft OpenAPI 3.1 contract.
- ../migrations/0001_initial_schema.sql — initial D1 schema.
- ../wrangler.example.toml — placeholder Cloudflare Worker/D1 configuration.
- ../examples/ — example discovery request and curl invocation.

## Status vocabulary
- **Documented:** architecture or contract exists in this repository.
- **Implemented:** source code exists.
- **Tested:** a relevant test has actually run and passed.
- **Deployed:** live deployment has been verified.

Do not treat these statuses as interchangeable. At this stage, the repository is a documentation and runtime foundation; Apify execution, most business endpoints, production auth/key issuance, and deployment remain to be implemented and verified.
