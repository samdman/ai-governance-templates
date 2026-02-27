# Architecture Enforcement — Enterprise

## Scope
Applies to all modules and cross-module flows. Violations block merge.

## Module Enforcement
- Modules must not reference each other’s Infrastructure.
- API/endpoints must not reference Infrastructure directly.
- Events must be immutable records.
- Domain entities encapsulate invariants.
- Tenant-aware boundaries are mandatory for data and integration flows.

## MediatR Usage
- Commands mutate state.
- Queries do not mutate state.
- Handlers are thin orchestration layers.

## Layer Contract
- Domain has no framework references.
- Application depends on Domain only.
- Infrastructure implements Application abstractions.
- API delegates to MediatR only.

## Data Boundary Rules
- One DbContext per module boundary.
- No cross-module DbContext usage.
- Shared data access across modules must happen via Application contracts.
- Query filters for TenantId are required.

## MassTransit Usage
- Publish integration events only.
- No request/response over bus inside same monolith.
- All integration events include TenantId.

## Outbox and Consistency
- Integration events must be written to Outbox in same transaction as state change.
- Consumers must be idempotent.
- No publish before transaction commit.

## Examples
- Allowed: `Subscriptions.Application` emits `SubscriptionUpgraded` via Outbox after commit.
- Allowed: `Provisioning.Consumer` uses idempotency key for repeated delivery.
- Forbidden: `Orders.Application` queries `BillingDbContext` directly.
- Forbidden: synchronous request/response over bus for in-process module calls.
