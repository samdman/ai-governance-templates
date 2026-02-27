# AI Governance Canonical Policy

This file is the neutral governance entrypoint for AI coding assistants.

## Scope
- Applies to all tools (Copilot, Gemini, Claude, and others).
- Defines policy precedence and usage contract.
- Points to tier-specific governance docs as authoritative implementation rules.

## Policy precedence (mandatory)
1. Project configuration (`PROJECT.md`) — project-specific tech stack & architectural preferences
2. This file (`AI-GOVERNANCE.md`) — canonical governance rules
3. Selected tier docs under `*/ai-governance/` — tier-specific implementation rules
4. Tool adapter files (`COPILOT.md`, `GEMINI.md`, `CLAUDE.md`) — tool formatting only

If any lower-priority file conflicts with a higher-priority file, follow the higher-priority file.

## Tier selection
Choose exactly one tier for a project:

- Lite: lean production-safe baseline.
- Standard: modular monolith + AI-ready defaults.
- Enterprise: SaaS-safe + AI workload governance.

Use the corresponding folder as the active policy set:
- `Lite/ai-governance/`
- `Standard/ai-governance/`
- `Enterprise/ai-governance/`

## Tier documents (authoritative)
Core docs (all tiers):
- `cicd-rules.md`
- `concurrency-consistency.md`
- `data-migrations.md`
- `data-privacy-compliance.md`
- `error-handling.md`
- `observability-rules.md`
- `performance-rules.md`
- `security-secrets.md`
- `skills-registry.md`
- `testing-governance.md`

Additional docs by tier:
- Standard + Enterprise: `architecture-enforcement.md`, `ai-readiness.md`
- Enterprise only: `saas-enforcement.md`, `ai-workload-governance.md`

## Adapter contract
Tool adapters must remain thin and non-authoritative.

Allowed in adapters:
- Prompt/session formatting expectations.
- How to attach/reference canonical + tier docs in each tool.
- Output structure preferences (plan/module impact/validation sections).

Not allowed in adapters:
- Re-defining architecture, security, privacy, migration, or testing policy.
- Copying full policy blocks that can drift from tier docs.

## Minimum enforcement workflow
For any AI-assisted implementation:
1. Select one tier.
2. Load this canonical file.
3. Load the selected tier docs.
4. Apply one tool adapter.
5. Validate output against tier docs before merge.
