# Error Handling — Enterprise

## Principles
- Business failures are explicit (`Result<T>`), not exception-driven.
- Unexpected failures are mapped to ProblemDetails with safe messages.
- Error handling must preserve tenant and trace context.

## Required
- Use `Result<T>` (or equivalent) for domain/application outcomes.
- Map unhandled exceptions to ProblemDetails centrally.
- Include CorrelationId and TenantId in telemetry context.
- Prevent internal details, provider errors, and secrets from responses.

## Classification
- Business/validation/subscription/quota failures: deterministic 4xx.
- Authorization/tenant boundary failures: 401/403 with no leak of tenancy internals.
- Unexpected failures: 500 with generic message.

## SaaS Safety
- Feature-gating and quota failures are handled in Application layer.
- Cross-tenant access attempts return safe forbidden responses.
- Audit critical failure decisions where required by policy.

## Forbid
- Exceptions for normal branching.
- Silent failure paths in background consumers.
- Logging PII or sensitive payloads.
