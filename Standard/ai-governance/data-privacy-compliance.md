# Data Privacy & Compliance — Standard

## Required
- Classify data fields by sensitivity (public/internal/confidential/PII).
- Do not log PII or sensitive payload data.
- Define retention periods for business data, logs, and telemetry.
- Enforce role-based access to sensitive records.

## Data Lifecycle
- Define deletion/anonymization process for eligible records.
- Track data lineage for critical reporting paths.

## Compliance Posture
- Keep auditable record of policy-impacting state changes.
- Validate third-party processors meet contractual/privacy requirements.

## Forbid
- PII in debug logs, trace attributes, or exception payloads.
- Unbounded retention of sensitive data.
