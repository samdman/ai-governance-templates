# Concurrency & Consistency — Enterprise

## Required
- Use optimistic concurrency tokens on contention-prone aggregates.
- Define idempotency keys/strategy for commands and consumers.
- Validate conflict and duplicate-delivery paths in automated tests.

## SaaS Consistency Rules
- Concurrency controls must preserve tenant isolation.
- Cross-module consistency must use outbox + event-driven contracts.
- Background jobs must be tenant-scoped and idempotent.

## Reliability Controls
- Use bounded retries with jitter for transient conflicts.
- Keep transactions short and avoid long lock windows.

## Forbid
- Silent last-write-wins on financial/compliance-critical entities.
- Non-idempotent consumers for at-least-once delivery.
