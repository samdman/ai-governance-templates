# Architecture Enforcement — Enterprise

## Module Enforcement
- Modules must not reference each other’s Infrastructure.
- Events must be immutable records.
- Domain entities encapsulate invariants.

## MediatR Usage
- Commands mutate state.
- Queries do not mutate state.
- Handlers are thin orchestration layers.

## MassTransit Usage
- Publish integration events only.
- No request/response over bus inside same monolith.
- All integration events include TenantId.
