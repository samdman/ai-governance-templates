# Concurrency & Consistency — Standard

## Required
- Use optimistic concurrency tokens for contention-prone aggregates.
- Define idempotency strategy for command handlers.
- Validate concurrency conflict paths in tests.

## Module Boundary
- Keep transactional boundaries inside module ownership.
- Cross-module consistency should use explicit contracts/events.

## Recommended
- Use bounded retry for transient conflicts.
- Keep transactions short; avoid lock escalation where possible.

## Forbid
- Silent last-write-wins on critical entities.
- Distributed transaction assumptions across modules.
