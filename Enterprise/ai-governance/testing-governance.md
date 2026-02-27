# Testing Governance — Enterprise

## Goal
Protect multi-tenant correctness, integration reliability, and release safety.

## Required
- Unit tests per module for domain and application rules.
- Integration tests for API, persistence, messaging, and outbox flows.
- Tenant isolation tests for all critical query and mutation paths.
- CI must fail on any test regression.

## Tenant Isolation Testing
- Validate every critical query enforces TenantId.
- Include negative tests for cross-tenant access attempts.
- Validate tenant-scoped background jobs and event consumers.

## Messaging & Outbox Testing
- Verify outbox write and publish after commit.
- Verify consumer idempotency under duplicate delivery.
- Verify correlation and tenant metadata propagation.

## AI-Related Testing
- Validate AI fallback/timeout behavior.
- Validate AI output guardrails before persistence.
- Cover deterministic core paths when AI is unavailable.

## Forbid
- Shared test data that can hide tenant leaks.
- Skipping idempotency tests for event consumers.
- Relying on manual-only validation for migration-critical paths.
