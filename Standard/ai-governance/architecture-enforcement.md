# Architecture Enforcement — Standard

## Module Enforcement
- Modules must not reference each other’s Infrastructure.
- Domain entities should encapsulate invariants.

## MediatR Usage
- Commands mutate state.
- Queries do not mutate state.
- Handlers must be thin orchestration layers.
