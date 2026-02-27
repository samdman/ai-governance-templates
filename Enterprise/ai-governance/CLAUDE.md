# CLAUDE.md — Enterprise SaaS Template (AI-Native by Default)

## 🎯 Purpose
Guide AI coding assistants to generate enterprise-grade, SaaS-safe, AI-ready code for a modular monolith.
Enforces multi-tenancy, messaging safety, migrations, observability, and AI workload governance.

Stack:
- .NET 9
- Modular Monolith
- Minimal APIs
- MediatR
- MassTransit
- EF Core + Dapper
- OpenTelemetry
- Redis (optional)
- .NET Aspire (optional)
- Central Package Management + Global Usings

---

# 🧾 REQUIRED AI OUTPUT FORMAT (MANDATORY)

## 1) Implementation Plan (3–8 steps)

## 2) Module Impact
- Affected module(s):
- New files:
- Modified files:

## 3) Architectural Validation
- Boundaries respected?
- No cross-module DbContext access?
- Tenant isolation enforced?
- Outbox/messaging safety respected?
- Async/await + CancellationToken?
- Observability + audit impact?
- AI readiness + AI workload governance considered?

## 4) Code

## 5) Risks / Improvements

## 6) SaaS + AI Validation (MANDATORY)
- TenantId enforced end-to-end?
- Feature gating/quota (if relevant) enforced in Application layer?
- No unbounded queries?
- AI calls isolated behind abstractions, timeouts, tracing?
- Migration changes backward compatible?

---

# 🏛️ Architecture

## Modular Monolith Rules
- Each module contains Domain, Application, Infrastructure.
- No cross-module DbContext usage.
- Shared contracts only in Shared project/package.
- Cross-module sync → MediatR.
- Cross-module async → MassTransit integration events.

## Clean Boundaries
- Domain: no framework references.
- Application: depends only on Domain.
- Infrastructure: implements Application interfaces.
- API: endpoints delegate to MediatR only.

---

# 🏢 SaaS Enforcement (MANDATORY)
See ai-governance/saas-enforcement.md (authoritative).

---

# 🤖 AI-NATIVE ARCHITECTURE (DEFAULT + MANDATORY)
This project must remain AI-augmentable and AI-integratable at scale.
See ai-governance/ai-readiness.md (authoritative).

---

# 🔭 Observability (OpenTelemetry)
- HTTP, EF, and messaging traces enabled.
- TenantId included in logs/traces/metrics.
- Errors set Activity status.
- Propagate trace headers through events.

---

# ⚡ Performance & Isolation
- Paginate all list endpoints.
- Rate limit API endpoints.
- Per-tenant throttling for heavy workloads.
- Bulk operations must be batched.

---

# 🔐 Error Handling + Security
- Result<T> for domain/application errors.
- Exceptions mapped to ProblemDetails.
- Do not leak internal exception details.
- No PII in logs.

---

# 🧪 Testing
- Unit tests per module.
- Integration tests via TestContainers.
- Contract tests for key APIs/events (recommended).

---

# 🚀 CI/CD
Standard pipeline + security scanning and zero-downtime migration checks.
