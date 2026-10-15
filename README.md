# Intelligence Engine

API-first intelligence platform that discovers public demand signals, normalizes evidence, and ranks business opportunities.

> Current stage: architecture and documentation foundation. No production deployment, live Apify run, or AI inference is implied by this repository yet.

## Product domains

1. **Demand Intelligence** — identify recurring needs, complaints, questions, workarounds, and buying-intent signals.
2. **Discovery Intelligence** — acquire evidence from permitted public sources through provider adapters. Apify is the first acquisition integration.
3. **Opportunity Intelligence** — cluster signals, evaluate evidence quality, score opportunities, and propose human-reviewable next actions.

## Architecture

~~~text
Clients / UI / external tools
          |
     API Gateway (Cloudflare Workers)
          |
 Auth / rate limits / validation / audit
          |
  Application use cases & domain services
     |            |              |
 Demand         Discovery     Opportunity
     |            |
     |       Integration Layer
     |       ├── Apify (first)
     |       ├── LLM providers (optional)
     |       └── future sources
     |
 Storage adapters
 ├── Cloudflare D1 (structured records)
 ├── R2 (optional raw artifacts; private)
 └── Queues / scheduled jobs (when needed)
~~~

See docs/architecture.md, docs/backend.md, docs/database.md, docs/integrations.md, and docs/roadmap.md.

## Initial stack decision

- **Runtime/API:** TypeScript on Cloudflare Workers; Hono is an optional thin routing layer.
- **Database:** Cloudflare D1 / SQLite-compatible migrations.
- **Large private artifacts:** Cloudflare R2 only when justified.
- **Async jobs:** Cloudflare Queues or scheduled Workers in a later stage.
- **Discovery provider:** Apify API + selected Actors, initially disabled until credentials, Actor input schema, usage limits, and permissions are verified.
- **LLM:** provider-neutral adapter. Start deterministic and rules-based; add Cloudflare Workers AI or a separately configured model API only behind a capability interface. No model provider is required for health, ingestion validation, or baseline scoring.
- **API contract:** OpenAPI 3.1 YAML.
- **Tests:** unit tests for domain logic, contract tests for provider adapters, and integration tests against isolated test storage.
- **Secrets:** Worker secrets, never committed to Git.

## Core principles

- Evidence before conclusions: every signal should retain source URL, observed time, collection time, provider/Actor metadata, and provenance.
- Human review before expensive collection, publishing, outreach, or other external side effects.
- Budget caps and allowlists for every external provider.
- No credentials, private user data, or raw sensitive datasets in public docs or Git.
- Respect source terms, access controls, privacy requirements, and provider policies.
- Scores are prioritization aids, not proof of market demand.
- Provider integrations are replaceable; domain logic must not depend on Apify or a specific LLM.

## Repository map

~~~text
apps/api/                 Worker entry point and API routes
src/domain/               Domain entities, policies, scoring
src/application/           Use cases and orchestration
src/infrastructure/        D1, queue, clock, logging adapters
src/integrations/apify/    Apify client and Actor adapters
src/integrations/llm/      Provider-neutral LLM interface/adapters
src/integrations/sources/  Future source connectors
openapi/openapi.yaml       Public API contract
migrations/                D1 schema migrations
docs/                      Architecture, security, API, operations
examples/                  Requests and integration examples
tests/                     Unit, contract, integration tests
~~~

## Local setup (planned implementation)

1. Install a supported Node.js LTS and npm.
2. Copy .dev.vars.example to .dev.vars and use test-only credentials.
3. Install dependencies with npm install.
4. Apply local D1 migrations and run npm run dev.
5. Run npm test and npm run typecheck before deployment.

The runnable scripts and exact environment bindings will be finalized as implementation files are added.

## API design direction

- GET /health — liveness, no secret values.
- GET /v1/capabilities — enabled providers and supported features, without exposing credentials.
- POST /v1/discovery/jobs — validate and request a bounded discovery job.
- GET /v1/discovery/jobs/{jobId} — inspect job state.
- GET /v1/signals — query normalized demand signals.
- GET /v1/opportunities — retrieve scored opportunities and evidence summaries.
- POST /v1/opportunities/{id}/reviews — record human review.

Exact schemas and authentication requirements belong in the OpenAPI contract. Endpoints remain unavailable until implemented and tested.

## Status

This repository starts with the architecture and documentation foundation. Treat every feature as **planned** until implemented, tested, and verified. Deployment and live provider calls require a separate validation step.
