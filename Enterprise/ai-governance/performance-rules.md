# Performance Rules — Enterprise

## EF Core
- Profile heavy queries.
- Use compiled queries for proven hot paths.
- AsNoTracking for read models.

## Dapper
- Index-aware SQL only.
- Avoid SELECT *.
- Return minimal columns.

## SaaS Guardrails
- All list endpoints paginated.
- Rate limiting enabled.
- Per-tenant throttling for heavy endpoints/jobs.
- Bulk operations must be batched.
