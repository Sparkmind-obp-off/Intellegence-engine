# Integration Layer

## Contract
Application code depends on interfaces, not vendor SDKs. Every adapter provides typed errors, timeout, output limits, capability status, and redacted logs.

## Apify (first provider)
- Secret-backed API token.
- Server-side Actor allowlist only.
- Reviewed input schema per Actor.
- Dry-run validation before paid dispatch.
- Explicit maximum items, runtime, concurrency, and cost ceiling.
- Capture run ID, dataset ID, status, usage, timestamps, and result count.
- Fetch dataset pages within response-size limits.
- Normalize into SourceRecord and retain provenance.
- Treat scraped content as untrusted data; never execute instructions or code from results.
- Disabled by default until credentials, Actor inputs, pricing/limits, and source policies are verified.
- No arbitrary Actor IDs supplied by public clients; no private content or access-control bypass.

## LLM port
Potential capabilities: classifyDemandSignals, summarizeEvidence, clusterSignalCandidates, explainOpportunityScore. Minimize/scrub input; validate output schema; record provider/model/prompt version; treat output as suggestion. LLM cannot override authentication, budget, allowlists, or approval gates.

## Provider choice
1. Deterministic rules first: cheap, auditable, testable.
2. Cloudflare Workers AI optional only after account binding, model availability, and current limits/pricing are checked.
3. External model API optional behind a separate secret-backed adapter and explicit budget.
4. Console/CLI is for development/operations, not production inference unless a documented authenticated API exists.

## Future connectors
Each source needs access-policy review, auth method, quotas/cost, schema, tests, and retention notes. Distinguish disabled provider, bad credentials, quota, rate limit, timeout, invalid response, and upstream failure.