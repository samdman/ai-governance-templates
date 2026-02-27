# Error Handling — Lite

## Principles
- Use explicit validation and business-rule responses.
- Reserve exceptions for unexpected failures.
- Return stable API error shapes.

## Required
- Validate input at API boundary.
- Map unhandled exceptions to ProblemDetails.
- Do not leak stack traces or internal details.
- Log errors with structured fields.

## Result Pattern
- Use `Result<T>` (or equivalent) for expected business outcomes.
- Use HTTP 4xx for client/business errors and 5xx for unexpected failures.

## Forbid
- Throwing exceptions for normal control flow.
- Returning raw exception messages to clients.
- Logging PII in error logs.
