# Concurrency & Consistency — Lite

## Required
- Use optimistic concurrency for entities with frequent updates.
- Keep write operations idempotent when practical.
- Validate stale-write scenarios in critical handlers.

## Recommended
- Use retry for transient conflicts with bounded attempts.
- Keep transactions short and focused.

## Forbid
- Long-running transactions for simple CRUD paths.
- Silent overwrite of concurrent updates.
