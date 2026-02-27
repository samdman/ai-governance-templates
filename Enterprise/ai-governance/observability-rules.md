# Observability Rules — Enterprise (OpenTelemetry)

- Every HTTP request traced.
- EF Core + messaging instrumentation enabled.
- Custom spans for critical flows.
- Errors must set Activity status.
- Propagate trace headers across events.
- All logs must include TenantId + CorrelationId.
- Traces/metrics must be partitionable by tenant.
- No PII in logs.
- Trace AI calls separately (span + latency + token/cost where available).
- Use environment-specific sampling with stricter controls for high-traffic workloads.
- Define retention and archival policy for traces, metrics, and audit-adjacent logs.
- Alert on telemetry ingestion anomalies and sustained cardinality spikes.
