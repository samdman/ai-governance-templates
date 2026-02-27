# Observability Rules — Standard (OpenTelemetry)

- Every HTTP request traced.
- Custom spans for critical flows.
- Errors must set Activity status.
- Propagate correlation/trace headers through async boundaries.
- Structured logging only (no string interpolation).
- Do not log PII.
- Use consistent log levels (Info, Warning, Error) with structured properties.
- Define sampling strategy for high-volume traces to control cost.
- Define trace/log retention policy by environment.
