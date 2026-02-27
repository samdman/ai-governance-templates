# AI Governance Templates (Lite / Standard / Enterprise)

This bundle provides reusable governance docs for AI-assisted backend development.

## Quick Start

The fastest way to install governance templates into your project:

### Option 1: Automated Setup (Recommended)

**Windows (PowerShell):**
```powershell
# Download and run setup script
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/samdman/ai-governance-templates/main/setup-governance.ps1" -OutFile "setup-governance.ps1"
.\setup-governance.ps1
```

**Linux/Mac (Bash):**
```bash
# Download and run setup script
curl -o setup-governance.sh https://raw.githubusercontent.com/samdman/ai-governance-templates/main/setup-governance.sh
chmod +x setup-governance.sh
./setup-governance.sh
```

The script will:
1. Prompt you to select a tier (Lite/Standard/Enterprise)
2. Prompt you to select your AI tool (Copilot/Gemini/Claude)
3. Download governance templates
4. Install files to your project
5. Set up tool-specific integration (e.g., `.github/copilot-instructions.md` for Copilot)

**Non-interactive mode:**
```powershell
# PowerShell
.\setup-governance.ps1 -Tier Standard -Tool copilot

# Bash
./setup-governance.sh Standard copilot
```

### Option 2: Manual Setup

1. Clone this repository
2. Copy one tier folder into your project
3. Copy `AI-GOVERNANCE.md` to your project root
4. Copy the appropriate tool adapter (`COPILOT.md`, `GEMINI.md`, or `CLAUDE.md`)
5. For Copilot: Create `.github/copilot-instructions.md` referencing the governance files

## Governance model
- Canonical policy entrypoint: `AI-GOVERNANCE.md` (tool-neutral source of truth).
- Tier docs remain authoritative for implementation rules:
	- `Lite/ai-governance/*`
	- `Standard/ai-governance/*`
	- `Enterprise/ai-governance/*`
- Tool adapters are non-authoritative helpers:
	- `COPILOT.md`
	- `GEMINI.md`
	- `CLAUDE.md`

## Structure
Each tier contains an `ai-governance/` folder with:
- performance-rules.md
- observability-rules.md
- cicd-rules.md
- testing-governance.md
- error-handling.md
- data-migrations.md
- security-secrets.md
- concurrency-consistency.md
- data-privacy-compliance.md
- skills-registry.md
- architecture-enforcement.md (Standard/Enterprise)
- ai-readiness.md (Standard/Enterprise)
- saas-enforcement.md (Enterprise)
- ai-workload-governance.md (Enterprise)

## Usage by tool

### 1) Choose your governance tier
Pick one folder based on system complexity:
- Lite
- Standard
- Enterprise

Copy that tier into your project root (or merge into `/ai-governance`).

### 2) Load canonical policy first (required)
Always provide `AI-GOVERNANCE.md` to your AI tool as the policy entrypoint.

Then specify the chosen tier path, for example:
- `Lite/ai-governance`
- `Standard/ai-governance`
- `Enterprise/ai-governance`

### 3) Apply tool-specific adapter
- GitHub Copilot: use `COPILOT.md`
- Gemini: use `GEMINI.md`
- Claude: use `CLAUDE.md`

Adapters define interaction format and workflow hints only.
If any adapter conflicts with canonical/tier policy, canonical + tier docs win.

## Enforcement pattern
- Source of truth order:
	1. `AI-GOVERNANCE.md`
	2. Selected tier governance docs
	3. Tool adapter file (`COPILOT.md` / `GEMINI.md` / `CLAUDE.md`)
- Do not duplicate detailed policy text in adapters.
- Keep policy changes in tier docs and canonical entrypoint.
