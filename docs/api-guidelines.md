# API Guidelines

- Version endpoints under /v1 and publish OpenAPI for every release.
- Return stable JSON error codes and requestId; do not expose stack traces or internals.
- Discovery job input includes source key, query, optional niche/language/region, resultLimit, maxCost and Idempotency-Key.
- Source/provider keys must map to a server-side allowlist; callers never choose arbitrary Actor IDs.
- Scores must include factors, weights/version, confidence, freshness, unknown dimensions, and counter-evidence.
- Use cursor pagination with server-enforced maximum page size.
- Avoid breaking published schemas; version breaking changes and document deprecation.