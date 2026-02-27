# CLAUDE.md — .NET Lite AI Development Template

## 🎯 Purpose
Guide AI assistants to generate clean, production-quality backend code without over-engineering.

Stack (typical):
- .NET 9
- Minimal APIs
- EF Core
- Record-based DTOs

---

# 🧠 AI Workflow Contract
When generating code, ALWAYS:
1. Provide a short implementation plan (3–5 steps).
2. Keep endpoints thin (no business logic).
3. Avoid unnecessary abstractions.
4. Use async/await.
5. Use CancellationToken for I/O.
6. Prefer clarity over cleverness.

---

# 🏗️ Architecture Rules
- No business logic in API endpoints.
- Domain contains core invariants (if a Domain layer exists).
- Infrastructure holds persistence/external integrations.
- Do NOT create interfaces unless multiple implementations are expected.
- Avoid CQRS split unless clearly needed.

---

# 🗄️ Data Access
- EF Core for CRUD.
- Use AsNoTracking for read queries.
- Avoid SELECT *.
- Paginate list endpoints.

---

# 🧪 Testing
- xUnit + FluentAssertions.
- Unit tests for business logic only.
- Integration tests optional for Lite.

---

# 🚫 Anti-Patterns
- Blocking calls (.Result/.Wait)
- Fat endpoints/controllers
- Static/global state
