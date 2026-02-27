# AI Workload Governance — Enterprise

## Scope
Mandatory for all LLM, embedding, classification, summarization, and AI-enrichment workloads.

## 1) Architecture Boundary
- AI providers are accessed only in Infrastructure behind abstractions (`IAIService`, `IEmbeddingService`, etc.).
- Domain and Application policies remain deterministic.
- AI must not directly mutate financial, compliance, or entitlement state.

## 2) Tenant Isolation
- Every AI request must carry TenantId context.
- Embeddings/vector stores must be tenant-partitioned.
- Prompt/context assembly must avoid cross-tenant data mixing.
- AI traces/logs/metrics must be filterable by TenantId.

## 3) Cost and Budget Controls
- Capture token usage and cost per request where provider supports it.
- Enforce per-tenant and global budget thresholds.
- Define fail-open/fail-closed behavior per use case.
- Alert on cost anomalies and sustained budget overruns.

## 4) Reliability and Fallback
- Timeouts are required for every AI call.
- Retry with bounded attempts and jitter only for transient failures.
- Circuit breaker required for degraded providers.
- Define deterministic fallback behavior for each AI-assisted feature.

## 5) Output Safety and Validation
- Validate AI output schema before persistence or downstream actions.
- Guard against malformed, empty, or policy-violating output.
- Human review/approval is required for high-risk recommendations.

## 6) Model Lifecycle and Versioning
- Track model name/version in telemetry and persisted AI decisions.
- Version prompts/templates used in production workflows.
- Test and approve model/prompt changes before rollout.
- Maintain rollback strategy for regressions.

## 7) Observability and Audit
- Emit dedicated spans for AI calls (latency, tokens, cost, provider, model version).
- Include CorrelationId and TenantId in AI telemetry.
- Audit AI-influenced decisions when required by domain policy.

## Forbid
- Cross-tenant prompt context contamination.
- Unbounded synchronous AI calls in request/response path.
- Silent AI-driven state changes to regulated or financial entities.
