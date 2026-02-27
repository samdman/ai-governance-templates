# Data Migrations — Standard

## Goal
Support safe schema evolution for modular monolith deployments.

## Required
- All schema changes must be migration-driven.
- Migrations must be reviewed for backward compatibility.
- CI should validate migration generation/apply for the module.

## Backward Compatibility Rules
- Prefer additive schema changes first.
- Use nullable-first strategy, backfill, then enforce non-null.
- Version API/contracts before removing persisted fields.

## Module Safety
- Keep migrations scoped to module DbContext.
- Avoid hidden cross-module data dependencies.
- Coordinate breaking changes through explicit rollout plans.

## Deployment
- Validate migrations in staging-like environment.
- Include rollback or forward-fix plan.

## Forbid
- Destructive drops in single-step rollout.
- Renames without compatibility strategy.
