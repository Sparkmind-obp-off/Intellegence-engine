# Product Domains and Intelligence Model

## Demand Intelligence
Identify recurring needs, complaints, questions, workarounds, urgency, and explicit buying-intent signals. Preserve evidence links and distinguish facts from inferred intent.

## Discovery Intelligence
Create bounded discovery jobs, choose approved sources, validate provider input, enforce budget/result/runtime caps, collect provider metadata, normalize records, deduplicate evidence, and retain provenance. Apify is the first provider; arbitrary Actor execution is disabled.

## Opportunity Intelligence
Cluster related signals, evaluate evidence quality, score candidates using transparent versioned factors, show counter-evidence and uncertainty, and recommend a human-reviewable next validation action.

## Core objects
Workspace, DiscoveryJob, ProviderRun, SourceRecord, DemandSignal, SignalCluster, Opportunity, Evidence, Review, UsageLedger, AuditEvent.

## State machines
Job: queued -> validating -> running -> normalizing -> completed | partial | failed | cancelled.
Opportunity: draft -> needs_review -> validated | rejected | archived.

## Non-goals
No autonomous posting, messaging, cold outreach, unbounded crawling, arbitrary Actor runs, or claims that a score proves revenue.