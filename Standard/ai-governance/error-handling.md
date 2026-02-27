# Error Handling — Standard

## Principles
- Business and validation failures are explicit, predictable, and testable.
- Unexpected failures are exceptions mapped to ProblemDetails.
- Error responses are stable contracts.

## Required
- Use `Result<T>` (or equivalent) for domain/application failures.
- Keep exception throwing for unexpected infrastructure/runtime failures.
- Map known exceptions to typed ProblemDetails.
- Log with structured fields and correlation metadata.

## Classification
- Validation/business errors: 4xx, deterministic messages.
- Unauthorized/forbidden: 401/403 with no internal detail.
- Unexpected runtime failures: 500 with generic message.

## Application Boundary
- Handlers return explicit outcomes.
- API layer maps outcomes to HTTP responses.
- Do not leak internal exception or SQL/provider messages.

## Forbid
- Using exceptions for normal branching.
- Swallowing exceptions without telemetry.
- Logging PII or secrets.
