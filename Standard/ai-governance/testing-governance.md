# Testing Governance — Standard

## Goal
Enforce confidence at module boundaries and critical integration paths.

## Required
- Unit tests per module for business rules and handlers.
- Integration tests for critical persistence and API flows.
- CI must fail on test failures.

## Test Structure
- Organize by module and test type (`Unit`, `Integration`).
- Name tests by behavior (Given/When/Then or equivalent).
- Keep fixtures isolated per test class.

## Integration Scope
- Use TestContainers for DB and external dependencies where practical.
- Cover at least one happy path and one failure path per critical use case.
- Verify module boundary behavior (not internal private details).

## Forbid
- Cross-module test coupling through internals.
- Mocking domain behavior that should be asserted directly.
- Non-deterministic tests in CI.
