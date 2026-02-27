# Copilot Adapter

Use this file with `AI-GOVERNANCE.md` and one selected tier folder.

## Required inputs to Copilot
1. `AI-GOVERNANCE.md`
2. Exactly one tier policy set:
   - `Lite/ai-governance/`
   - `Standard/ai-governance/`
   - `Enterprise/ai-governance/`

## Response contract
When generating implementation output, include:
1. Implementation plan (3-8 steps)
2. Module impact (affected modules, new files, modified files)
3. Architectural validation checklist against selected tier docs
4. Code or patch
5. Risks/improvements

## Non-authoritative adapter rule
If this file conflicts with `AI-GOVERNANCE.md` or tier docs, follow canonical/tier policy.
