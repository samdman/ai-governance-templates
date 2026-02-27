# Testing Governance — Lite

## Goal
Keep testing focused, fast, and proportional to Lite scope.

## Required
- Unit tests for business logic and validation rules.
- Endpoint smoke tests for critical API paths.
- Build and tests must pass before merge.

## Recommended
- Use xUnit + FluentAssertions.
- Use clear arrange/act/assert structure.
- Prefer deterministic tests (no sleep-based timing checks).

## Optional
- Integration tests for high-risk flows (payments, notifications, imports).

## Forbid
- Testing persistence internals in unit tests.
- Flaky tests relying on shared global state.
- Blocking calls in test code when async APIs exist.
