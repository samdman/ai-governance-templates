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
