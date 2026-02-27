# Observability Rules — Lite
- Structured logging for errors and key business events.
- Do not log PII.
- Include CorrelationId where feasible.
- Use log levels consistently (Info for business milestones, Warning for recoverable issues, Error for failures).
- Keep telemetry volume controlled (sample high-frequency debug traces if enabled).
