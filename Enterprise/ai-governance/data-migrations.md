# Data Migrations — Enterprise

## Goal
Guarantee backward-compatible, tenant-safe schema evolution with zero-downtime posture.

## Required
- All schema changes must be migration-driven and reviewed.
- Backward compatibility is mandatory.
- Migration checks must run in CI before merge.

## Zero-Downtime Rules
- Use nullable-first strategy (add nullable, backfill, then enforce).
- Deploy code that tolerates both old/new schema during transition.
- Avoid lock-heavy operations in peak windows.

## Tenant Safety
- Preserve TenantId semantics in every schema change.
- Validate tenant-partitioned indexes when adding heavy query paths.
- Test migration effects on tenant-scoped queries.

## Release Strategy
- Use expand/contract for breaking schema evolution.
- Defer destructive drops until deprecation cycle completes.
- Keep a rollback/forward-fix plan for every high-risk migration.

## Forbid
- Destructive drops in single release.
- Contract-breaking migrations without staged rollout.
