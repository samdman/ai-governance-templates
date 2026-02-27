# SaaS Enforcement (Enterprise)

## Multi-Tenancy Contract
- Every aggregate must contain TenantId.
- Global query filters required for TenantId.
- All queries must filter by TenantId.
- No cross-tenant queries allowed.
- Background jobs must execute in tenant scope.

## Tenant Resolution
- TenantId resolved from JWT/header.
- TenantContext injected per request.
- No HttpContext access in Application layer.
- No static tenant storage.

## Subscription & Feature Gating
- Premium features must validate subscription tier.
- Usage-based features must check quota before execution.
- Feature gating occurs in Application layer (not controllers).
- Feature flags must be tenant-aware.

## Messaging & Outbox
- Integration events must use Outbox pattern.
- No publish before DB commit.
- Consumers must be idempotent.
- All events include TenantId and CorrelationId.

## Migration Safety
- Backward compatible migrations.
- No destructive drops in a single release.
- Nullable-first strategy for schema evolution.

## Audit Logging
- All state mutations produce immutable audit records:
  - TenantId, UserId/Actor, Timestamp, Action, EntityId
