# Data Privacy & Compliance — Enterprise

## Required
- Classify and inventory all sensitive/PII data domains.
- Do not log PII in logs, traces, metrics, or AI prompts unless explicitly allowed by policy.
- Define retention and deletion policy for operational, audit, and analytics stores.
- Enforce role-based and tenant-scoped access for sensitive records.

## Tenant and Regulatory Posture
- Ensure tenant data isolation for primary, cache, search, and AI/vector stores.
- Support data subject deletion/anonymization workflows where required.
- Record auditable access/change events for regulated entities.

## Data Sharing Controls
- Validate third-party processors and cross-border data transfer constraints.
- Minimize data shared with AI providers; apply redaction where possible.

## Forbid
- Cross-tenant data exposure in telemetry, exports, or AI context.
- Unbounded retention of sensitive records without legal basis.
