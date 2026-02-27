# Data Migrations — Lite

## Goal
Keep schema changes safe and reversible for small deployments.

## Required
- Every schema change must be delivered via migration.
- Review generated migration SQL before merge.
- Keep migrations small and focused.

## Safe Change Rules
- Prefer additive changes (new nullable columns, new tables).
- Backfill data before enforcing new constraints.
- Avoid dropping columns/tables in the same release as replacement.

## Deployment
- Run migrations in controlled environments before production.
- Ensure rollback plan exists for risky changes.

## Forbid
- Destructive schema changes without deprecation window.
- Mixed unrelated changes in one migration.
