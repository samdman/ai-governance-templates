# Security & Secrets — Enterprise

## Required
- Secrets must be stored in managed secret systems; no plaintext in source or static config.
- Enforce strong authentication/authorization for all non-public APIs.
- Apply least-privilege for database, message broker, cache, and AI provider credentials.
- Include SAST/dependency scanning in CI and release gates.

## Tenant-Safe Security
- Authorization checks must enforce tenant scope.
- Service-to-service calls must propagate authenticated tenant context.
- Security telemetry must preserve CorrelationId and TenantId.

## Rotation and Governance
- Define key rotation policy, owner, and emergency revocation process.
- Audit secret access and privileged operations.

## Forbid
- Hard-coded credentials, tokens, or signing keys.
- Sensitive secrets in logs, traces, or ProblemDetails responses.
