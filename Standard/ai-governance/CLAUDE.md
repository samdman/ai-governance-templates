# CLAUDE.md — Standard Production Template (AI-Ready by Default)

## 🎯 Purpose
Guide AI coding assistants to generate production-ready code that follows modular monolith boundaries
without over-engineering, while keeping the system AI-augmentable by design.

Stack:
- .NET 9
- Modular Monolith
- Minimal APIs
- MediatR
- EF Core + Dapper
- OpenTelemetry
- Central Package Management (recommended)
- Global Usings (recommended)
- Record-based models (DTOs/commands)

---

# 🧾 REQUIRED AI OUTPUT FORMAT (MANDATORY)

## 1) Implementation Plan (3–6 steps)

## 2) Module Impact
- Affected module(s):
- New files:
- Modified files:

## 3) Architectural Validation
- Boundaries respected?
- No cross-module DbContext access?
- Async/await + CancellationToken for I/O?
- No unnecessary abstractions?
- AI-readiness considered? (see AI-Ready section)

## 4) Code

## 5) Risks / Improvements

---

# 🏛️ Architecture

## Modular Monolith Rules
- Each module contains Domain, Application, Infrastructure.
- No cross-module DbContext usage.
- Shared contracts only in Shared project/package.
- Cross-module sync → MediatR (within monolith).
- Cross-module async → integration events (MassTransit optional for Standard).

## Clean Boundaries
- Domain: no framework references.
- Application: depends only on Domain.
- Infrastructure: implements Application interfaces.
- API: endpoints delegate to MediatR only (no EF calls, no business logic).

---

# 🗄️ Data Access

## EF Core
- Use for aggregates and CRUD.
- AsNoTracking for reads.
- Avoid deep Include chains.
- DbContext per module.

## Dapper
- For heavy read models.
- Parameterized SQL only.
- Avoid SELECT *.
- Return minimal columns.

---

# 🔭 Observability (OpenTelemetry)
- Every HTTP request traced.
- Custom spans for critical flows.
- Errors must set Activity status.
- Structured logging only.
- CorrelationId included in logs.

---

# ⚡ Performance
- All list endpoints paginated.
- No query returning > 1000 rows without paging.
- Avoid unbounded background operations.
- Compiled queries for hot paths (when proven hot).

---

# 🔐 Error Handling
- Domain errors return Result<T> (or equivalent).
- Exceptions only for unexpected failures.
- Map exceptions to ProblemDetails.
- Never expose internal exception messages.

---

# 🧪 Testing
- xUnit + FluentAssertions.
- Unit tests per module for business logic.
- Integration tests via TestContainers for critical flows.
- Include edge case scenarios.

---

# 🚀 CI/CD Contract
Stages (minimum):
1. Restore
2. Build
3. Test
4. Format / Analyzer checks
5. Publish
6. Container build (if applicable)
7. Push

Fail fast on violations.

---

# 🤖 AI-READY ARCHITECTURE (DEFAULT + MANDATORY)
This project must remain AI-augmentable by design.
See ai-governance/ai-readiness.md (authoritative).
