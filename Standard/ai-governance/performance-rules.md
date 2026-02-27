# Performance Rules — Standard

## EF Core
- Always profile heavy queries.
- Use compiled queries for proven hot paths.
- Avoid tracking for read models (AsNoTracking).

## Dapper
- Index-aware SQL only.
- Avoid SELECT *.
- Return minimal columns.

## Guardrails
- All list endpoints paginated.
- No query > 1000 rows without paging.
