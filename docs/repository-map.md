# Repository Map

~~~text
apps/api/                 Worker entry point and route registration
src/domain/               Entities, policies, deterministic scoring
src/application/           Use cases, orchestration, ports
src/infrastructure/db/     D1 repositories
src/infrastructure/queue/  Queue producers and consumers
src/integrations/apify/    Apify client, Actor allowlist, dataset adapter
src/integrations/llm/      Provider-neutral model interface/adapters
src/integrations/sources/  Future source connectors
openapi/openapi.yaml       OpenAPI 3.1 contract
migrations/                D1 schema migrations
docs/                      Architecture, backend, security, operations
examples/                  Requests and client examples
tests/unit/                Domain unit tests
tests/contract/            Provider contract tests
tests/integration/         API and database integration tests
~~~

Dependency direction: apps -> application -> domain. Infrastructure and integration adapters implement application ports. Domain code must not import Cloudflare, D1, Apify SDK, LLM SDK, or HTTP framework types.