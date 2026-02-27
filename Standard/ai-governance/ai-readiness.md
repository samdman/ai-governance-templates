# 🤖 AI Readiness Contract (DEFAULT for Standard + Enterprise)

This project must remain AI-augmentable without architectural refactor.

AI-readiness means:
- Services are composable at Application boundaries
- Data preserves semantic context for enrichment
- Events are business-semantic
- AI integrations can be added safely behind abstractions
- AI workloads are observable (and isolatable in Enterprise)

---

# 1) Service Design for AI Compatibility

## Rules
- Business logic must be encapsulated in the Application layer.
- Endpoints/controllers are thin orchestration only.
- Commands represent clear business intent (not UI flow).
- Query models must be projection-friendly and composable.

---

# 2) Data Must Be Enrichment-Ready

## Rules
- Preserve raw user input where it provides semantic value.
- Avoid premature normalization that removes context.
- Prefer extensibility for metadata (e.g., JSON metadata fields) where appropriate.
- Avoid overly rigid enums when future classification/category growth is expected.

---

# 3) Events Must Be Business-Semantic

## Rules
- Events describe business meaning, not technical changes.
- Names reflect intent (e.g., ClaimApproved, OrderPlaced).
- Include CorrelationId, Timestamp, and Actor/User when applicable.
- Include TenantId in Enterprise tier.

---

# 4) AI Integration Boundary

## Rules
- AI calls must be isolated in Infrastructure.
- Application depends on an abstraction (IAIService / IEmbeddingService).
- Domain must never depend on AI.
- AI failures must degrade gracefully (fallbacks/timeouts).

---

# 5) Deterministic Core, Probabilistic Edge

## Rules
- Core financial/compliance/state mutation logic must remain deterministic.
- AI may suggest/classify/summarize/recommend.
- AI must not silently mutate critical state.

---

# 6) Observability for AI Workloads

## Rules
- Trace AI calls separately with span names.
- Record latency.
- Record token usage/cost if available.
- Tag AI-augmented flows in traces/logs.
