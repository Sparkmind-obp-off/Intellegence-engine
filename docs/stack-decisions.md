# Stack and Provider Decisions

| Layer | Baseline | Rationale |
|---|---|---|
| Language | TypeScript | Shared types and Worker ecosystem |
| Runtime | Cloudflare Workers | Low-ops API runtime |
| Router | Hono optional | Thin routing only |
| Database | Cloudflare D1 | Relational MVP storage |
| Object storage | R2 optional | Private raw artifacts only if needed |
| Async jobs | Queues later | Keep long-running work out of HTTP requests |
| Discovery | Apify API | First source acquisition provider |
| AI | Provider-neutral adapter | Avoid vendor lock-in |
| Contract | OpenAPI 3.1 | Portable API documentation |
| Tests | Vitest-compatible setup | Unit and contract tests |

## AI selection
Start deterministic and rules-based. Add Cloudflare Workers AI only if the chosen model/task is available to this account and current quotas/pricing fit. Otherwise add an external model API behind the same interface. Verify current provider capabilities before implementation.

A console or CLI is not itself a production inference endpoint. Production code must use a documented authenticated API or supported Cloudflare binding. Never embed interactive console credentials in a Worker.

## Cost policy
No paid calls by default. Track Apify and LLM budgets separately. Bound results, runtime, concurrency and per-workspace usage. Treat costs as estimates until provider usage is reconciled.