# Security & Secrets — Lite

## Required
- Store secrets in environment variables or secret manager, never in source code.
- Rotate API keys and credentials on a regular schedule.
- Enforce authentication and authorization for non-public endpoints.

## Recommended
- Restrict CORS origins explicitly.
- Use least-privilege credentials for database and external APIs.

## Forbid
- Hard-coded secrets in code, config, or tests.
- Committing `.env` files with real credentials.
