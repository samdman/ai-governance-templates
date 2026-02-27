# 🧠 AI Skills Registry

This registry defines reusable AI governance skills for this project template.
Skills activate based on context and enforce standards.

Tier usage for this file:
- Active by default: Lite skills
- Reference only unless explicitly enabled: Standard and Enterprise skills

Each skill includes:
- Activation triggers (when to use)
- Validations (what to ensure)
- Forbids (what to avoid)

---

# 🟢 LITE TIER SKILLS

## 1) Endpoint Discipline Skill

### Activate When
- Creating or modifying Minimal API endpoints

### Validate
- Endpoint is thin (no business logic)
- Uses async/await
- Accepts CancellationToken for I/O
- Delegates to handler/service

### Forbid
- Direct DbContext usage in endpoints
- Blocking calls (.Result / .Wait)

---

# 🔵 STANDARD TIER SKILLS

## 2) Clean Architecture & Module Boundary Skill

### Activate When
- Adding modules, handlers, or cross-module interactions

### Validate
- Domain has no framework references
- API delegates to MediatR only
- No cross-module DbContext usage
- Infrastructure only implements Application abstractions

### Forbid
- Domain depending on Infrastructure
- Static service locators
- Cross-module Infrastructure references

## 3) EF Core Query Optimizer Skill

### Activate When
- Writing or changing EF Core queries

### Validate
- AsNoTracking used for read models
- Pagination for list endpoints
- No deep Include chains
- Index-friendly predicates

### Forbid
- SELECT *
- Unbounded ToListAsync()

## 4) Observability Enforcement Skill

### Activate When
- Writing handlers, workflows, or critical business logic

### Validate
- ActivitySource spans for critical flows
- Structured logging (no string interpolation)
- Errors set Activity status
- CorrelationId included in logs

### Forbid
- Logging PII
- String interpolation logging for structured fields

## 5) AI Integration Readiness Skill (DEFAULT)

### Activate When
- Designing new feature/services
- Creating new entities
- Adding analytics/reporting
- Writing new Application handlers/services

### Validate
- Business logic encapsulated in Application layer
- Commands represent clear business intent
- Raw semantic input preserved where relevant
- Events are business-semantic (not technical)
- Design is augmentable by AI later (no UI-coupled logic)

### Forbid
- Hidden business logic in endpoints/controllers
- Loss of user-provided semantic context
- Tight coupling to UI flows

---

# 🟣 ENTERPRISE TIER SKILLS

## 6) Multi-Tenancy Isolation Skill (CRITICAL)

### Activate When
- Writing queries
- Publishing/consuming events
- Creating background jobs
- Implementing tenant provisioning or configuration

### Validate
- TenantId present in aggregates
- Queries filter by TenantId (global query filters required)
- Events include TenantId
- Background jobs run in tenant scope

### Forbid
- Cross-tenant queries
- Global DbContext access without tenant filter
- Static tenant storage

## 7) Outbox & Messaging Safety Skill

### Activate When
- Publishing integration events
- Implementing event consumers

### Validate
- Outbox pattern used for integration events
- Publish after DB commit
- Consumers idempotent
- Events immutable records

### Forbid
- Publish before transaction commit
- Request/response over bus inside same monolith

## 8) SaaS Performance Guard Skill

### Activate When
- Writing list endpoints, bulk operations, analytics queries

### Validate
- Pagination enforced (always)
- Rate limiting at API layer
- Batching for bulk operations
- Index-aware SQL for heavy queries

### Forbid
- Queries returning > 1000 rows without paging
- Unbounded background processing

## 9) Migration Safety Skill

### Activate When
- Creating EF migrations or altering schema

### Validate
- Backward compatible migrations
- Nullable-first strategy (add nullable, backfill, then enforce)
- Zero-downtime deployment safe

### Forbid
- Destructive drops without deprecation cycle
- Breaking contract changes in a single release

## 10) Subscription & Feature Gating Skill

### Activate When
- Adding premium features, quotas, usage limits

### Validate
- Feature checks in Application layer
- Quota checked before expensive work
- Flags/subscriptions are tenant-aware

### Forbid
- Feature gating in controllers
- Boolean flags scattered throughout code

## 11) AI Workload Governance Skill (DEFAULT)

### Activate When
- Integrating LLMs/embeddings
- Creating enrichment background jobs
- Adding AI classification/summarization

### Validate
- AI calls isolated in Infrastructure behind IAIService
- Timeouts configured
- Circuit breaker / retry strategy applied
- Long-running AI work moved to background
- AI output validated before persistence
- AI traced and measured

### Forbid
- Domain depending on AI
- Blocking synchronous endpoints on long AI calls
- Silent AI mutation of financial/compliance state

---

# ✅ GLOBAL SELF-CHECK (ALL TIERS)

Before final answer, AI must verify:
- No blocking calls
- No static global state
- Boundaries respected
- Async patterns correct
- Logging is structured
- No unnecessary abstractions
