# Security & Secrets — Standard

## Required
- Use secret manager or environment-injected secrets (no source-controlled secrets).
- Enforce authentication and authorization at API boundaries.
- Apply least-privilege access for DB, queues, and external providers.
- Include dependency and vulnerability checks in CI.

## API & Boundary Rules
- Restrict CORS per environment.
- Validate and sanitize external input.
- Do not trust client-provided authorization context without verification.

## Rotation & Access
- Define key rotation schedule and ownership.
- Audit access to high-value secrets.

## Forbid
- Hard-coded credentials or connection strings.
- Secret values in logs, traces, or exception messages.
