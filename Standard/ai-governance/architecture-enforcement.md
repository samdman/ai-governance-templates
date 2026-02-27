# Architecture Enforcement — Standard

## Scope
Applies to all modules in this tier. Violations block merge.

## Module Enforcement
- Modules must not reference each other’s Infrastructure.
- API/endpoints must not reference Infrastructure directly.
- Domain entities and value objects must encapsulate invariants.
- Cross-module contracts must be explicit (commands, queries, integration contracts).

## MediatR Usage
- Commands mutate state.
- Queries do not mutate state.
- Handlers must be thin orchestration layers.

## Layer Contract
- Domain has no framework references.
- Application depends on Domain only.
- Infrastructure implements Application abstractions.
- API delegates to MediatR only.

## Data Boundary Rules
- One DbContext per module boundary.
- No cross-module DbContext usage.
- Shared data access across modules must happen via Application contracts.

## Event and Contract Rules
- Domain events are immutable.
- Integration events are immutable records.
- Events describe business meaning (not table mutations).

## Examples
- Allowed: `Billing.Api -> IMediator -> Billing.Application -> Billing.Domain`.
- Allowed: `Billing.Application` publishes `InvoiceIssued` integration event for `Ledger`.
- Forbidden: `Billing.Api` calls `Billing.Infrastructure.BillingDbContext` directly.
- Forbidden: `Orders.Application` reads `InventoryDbContext` directly.
