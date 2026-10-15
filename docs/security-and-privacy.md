# Security and Privacy

- Store provider/API secrets as Worker secrets; local credentials in ignored .dev.vars. Commit placeholders only.
- Use high-entropy API keys, store hashes, scope/revoke them, and never accept query-string credentials.
- CORS is not authentication; restrict browser origins.
- Enforce workspace isolation in repository methods.
- Collect only permitted, relevant public business signals; minimize personal identifiers.
- Keep raw R2 artifacts private and time-limited if enabled.
- Treat scraped content and model output as untrusted; protect against prompt injection and validate structured outputs.
- LLMs cannot access secrets, approve spend, expand Actor allowlists, or trigger outbound communications.
- Require budget ceilings, Actor allowlist, result/runtime limits, usage ledger, and fail-closed behavior.
- Incident response: revoke keys, rotate provider secrets, disable integration/queue, preserve audit logs, restore from verified backup.
- Run secret scanning before public release.