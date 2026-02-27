#!/usr/bin/env pwsh
<#
.SYNOPSIS
    AI Governance Templates Setup Script
.DESCRIPTION
    Interactive script to install AI governance templates into your project.
    Prompts for tier (Lite/Standard/Enterprise) and tool (Copilot/Gemini/Claude),
    then downloads and installs governance files.
.PARAMETER Tier
    Governance tier: Lite, Standard, or Enterprise
.PARAMETER Tool
    AI tool: copilot, gemini, or claude
.PARAMETER TargetPath
    Target project directory (defaults to current directory)
.PARAMETER TemplateRepo
    GitHub repository URL (defaults to ai-governance-templates)
.EXAMPLE
    .\setup-governance.ps1
    Interactive mode with prompts
.EXAMPLE
    .\setup-governance.ps1 -Tier Standard -Tool copilot
    Non-interactive mode
#>

param(
    [ValidateSet('Lite', 'Standard', 'Enterprise')]
    [string]$Tier,
    
    [ValidateSet('copilot', 'gemini', 'claude')]
    [string]$Tool,
    
    [string]$TargetPath = $PWD,
    
    [string]$TemplateRepo = 'https://github.com/samdman/ai-governance-templates.git'
)

$ErrorActionPreference = 'Stop'

# Helper functions
function Write-SuccessMsg {
    param([string]$Msg)
    Write-Host "[OK] $Msg" -ForegroundColor Green
}

function Write-InfoMsg {
    param([string]$Msg)
    Write-Host "[INFO] $Msg" -ForegroundColor Cyan
}

function Write-WarnMsg {
    param([string]$Msg)
    Write-Host "[WARN] $Msg" -ForegroundColor Yellow
}

function Write-ErrMsg {
    param([string]$Msg)
    Write-Host "[ERROR] $Msg" -ForegroundColor Red
}

# Banner
Write-Host ""
Write-Host "===================================================" -ForegroundColor Cyan
Write-Host "  AI Governance Templates Setup" -ForegroundColor Cyan
Write-Host "===================================================" -ForegroundColor Cyan
Write-Host ""

# Interactive tier selection if not provided
if (-not $Tier) {
    Write-InfoMsg "Select governance tier:"
    Write-Host "  1) Lite      - Lean production-safe baseline"
    Write-Host "  2) Standard  - Modular monolith + AI-ready defaults"
    Write-Host "  3) Enterprise - SaaS-safe + AI workload governance"
    Write-Host ""
    
    $tierChoice = Read-Host "Enter choice (1-3)"
    $Tier = switch ($tierChoice) {
        '1' { 'Lite' }
        '2' { 'Standard' }
        '3' { 'Enterprise' }
        default { 
            Write-ErrMsg "Invalid choice. Exiting."
            exit 1
        }
    }
}

# Interactive tool selection if not provided
if (-not $Tool) {
    Write-Host ""
    Write-InfoMsg "Select AI tool:"
    Write-Host "  1) Copilot - GitHub Copilot"
    Write-Host "  2) Gemini  - Google Gemini"
    Write-Host "  3) Claude  - Anthropic Claude"
    Write-Host ""
    
    $toolChoice = Read-Host "Enter choice (1-3)"
    $Tool = switch ($toolChoice) {
        '1' { 'copilot' }
        '2' { 'gemini' }
        '3' { 'claude' }
        default { 
            Write-ErrMsg "Invalid choice. Exiting."
            exit 1
        }
    }
}

Write-Host ""
Write-SuccessMsg "Configuration: Tier=$Tier, Tool=$Tool"
Write-InfoMsg "Target directory: $TargetPath"
Write-Host ""

# Ensure target directory exists
if (-not (Test-Path $TargetPath)) {
    New-Item -ItemType Directory -Path $TargetPath -Force | Out-Null
}

# Create temporary directory for template download
$tempDir = Join-Path $env:TEMP "ai-governance-$(Get-Random)"
New-Item -ItemType Directory -Path $tempDir -Force | Out-Null

try {
    # Download templates
    Write-InfoMsg "Downloading governance templates..."
    
    # Try git clone first
    $gitAvailable = Get-Command git -ErrorAction SilentlyContinue
    if ($gitAvailable) {
        try {
            git clone --depth 1 --quiet $TemplateRepo $tempDir 2>$null
            Write-SuccessMsg "Templates downloaded via git"
        }
        catch {
            Write-WarnMsg "Git clone failed, trying zip download..."
            $gitAvailable = $null
        }
    }
    
    # Fallback to zip download if git not available or failed
    if (-not $gitAvailable) {
        $zipUrl = $TemplateRepo -replace '\.git$', '' -replace 'github\.com', 'github.com'
        $zipUrl = "$zipUrl/archive/refs/heads/main.zip"
        $zipPath = Join-Path $env:TEMP "ai-governance.zip"
        
        try {
            Invoke-WebRequest -Uri $zipUrl -OutFile $zipPath -UseBasicParsing
            Expand-Archive -Path $zipPath -DestinationPath $tempDir -Force
            
            # Move contents from extracted folder to temp root
            $extractedFolder = Get-ChildItem $tempDir -Directory | Select-Object -First 1
            Get-ChildItem $extractedFolder.FullName | Move-Item -Destination $tempDir -Force
            Remove-Item $extractedFolder.FullName -Force
            Remove-Item $zipPath -Force
            
            Write-SuccessMsg "Templates downloaded via zip"
        }
        catch {
            Write-ErrMsg "Failed to download templates: $_"
            exit 1
        }
    }
    
    # Verify template structure
    $canonicalFile = Join-Path $tempDir "AI-GOVERNANCE.md"
    $tierFolder = Join-Path $tempDir "$Tier\ai-governance"
    $toolAdapter = Join-Path $tempDir "$($Tool.ToUpper()).md"
    
    if (-not (Test-Path $canonicalFile)) {
        Write-ErrMsg "Template validation failed: AI-GOVERNANCE.md not found"
        exit 1
    }
    if (-not (Test-Path $tierFolder)) {
        Write-ErrMsg "Template validation failed: $Tier tier folder not found"
        exit 1
    }
    
    Write-SuccessMsg "Template structure validated"
    Write-Host ""
    
    # Function to copy file with conflict handling
    function Copy-WithPrompt {
        param(
            [string]$Source,
            [string]$Destination,
            [string]$Description
        )
        
        if (Test-Path $Destination) {
            Write-WarnMsg "File already exists: $Description"
            $overwrite = Read-Host "Overwrite? (y/N)"
            if ($overwrite -ne 'y' -and $overwrite -ne 'Y') {
                Write-InfoMsg "Skipped: $Description"
                return $false
            }
        }
        
        $destDir = Split-Path $Destination -Parent
        if (-not (Test-Path $destDir)) {
            New-Item -ItemType Directory -Path $destDir -Force | Out-Null
        }
        
        Copy-Item -Path $Source -Destination $Destination -Force
        Write-SuccessMsg "Copied: $Description"
        return $true
    }
    
    # Copy canonical policy
    Write-InfoMsg "Installing governance files..."
    $canonicalDest = Join-Path $TargetPath "AI-GOVERNANCE.md"
    Copy-WithPrompt -Source $canonicalFile -Destination $canonicalDest -Description "AI-GOVERNANCE.md" | Out-Null
    
    # Copy tier governance folder
    $tierDest = Join-Path $TargetPath "ai-governance"
    if (-not (Test-Path $tierDest)) {
        New-Item -ItemType Directory -Path $tierDest -Force | Out-Null
    }
    
    $tierFiles = Get-ChildItem $tierFolder -File
    foreach ($file in $tierFiles) {
        $destFile = Join-Path $tierDest $file.Name
        Copy-WithPrompt -Source $file.FullName -Destination $destFile -Description "ai-governance/$($file.Name)" | Out-Null
    }
    
    # Copy tool adapter
    $toolAdapterName = "$($Tool.ToUpper()).md"
    $toolAdapterDest = Join-Path $TargetPath $toolAdapterName
    if (Test-Path $toolAdapter) {
        Copy-WithPrompt -Source $toolAdapter -Destination $toolAdapterDest -Description $toolAdapterName | Out-Null
    }
    
    Write-Host ""
    
    # Create Copilot-specific integration file
    if ($Tool -eq 'copilot') {
        Write-InfoMsg "Creating GitHub Copilot integration..."
        $copilotInstructionsPath = Join-Path $TargetPath ".github\copilot-instructions.md"
        $copilotContent = @"
# GitHub Copilot Instructions

This project uses AI governance templates to ensure code quality and consistency.

## Governance Files
Always reference these files when generating code:

1. **Canonical Policy**: ``AI-GOVERNANCE.md``
   - Source of truth for all governance rules
   - Defines tier selection and policy precedence

2. **Tier-Specific Governance**: ``ai-governance/``
   - Implementation rules for this project
   - Tier: **$Tier**

3. **Tool Adapter**: ``COPILOT.md``
   - Copilot-specific workflow instructions
   - Output format requirements

## Usage
When implementing features, always:
- Follow the governance files above
- Include implementation plan in responses
- Document module impact
- Validate against architectural rules
- Consider security, performance, and testing requirements

## Policy Precedence
If there are conflicts:
1. ``AI-GOVERNANCE.md`` (highest priority)
2. ``ai-governance/*`` tier docs
3. ``COPILOT.md`` (lowest priority)
"@
        
        $copilotDir = Split-Path $copilotInstructionsPath -Parent
        if (-not (Test-Path $copilotDir)) {
            New-Item -ItemType Directory -Path $copilotDir -Force | Out-Null
        }
        Set-Content -Path $copilotInstructionsPath -Value $copilotContent -Force -Encoding UTF8
        Write-SuccessMsg "Created .github/copilot-instructions.md"
    }
    
    # Success summary
    Write-Host ""
    Write-Host "===================================================" -ForegroundColor Green
    Write-Host "  Installation Complete!" -ForegroundColor Green
    Write-Host "===================================================" -ForegroundColor Green
    Write-Host ""
    
    Write-SuccessMsg "Governance tier: $Tier"
    Write-SuccessMsg "AI tool: $Tool"
    Write-Host ""
    
    Write-InfoMsg "Files installed:"
    Write-Host "  - AI-GOVERNANCE.md (canonical policy)"
    Write-Host "  - ai-governance/* ($Tier tier rules)"
    Write-Host "  - $toolAdapterName (tool adapter)"
    if ($Tool -eq 'copilot') {
        Write-Host "  - .github/copilot-instructions.md (Copilot integration)"
    }
    Write-Host ""
    
    # Tool-specific next steps
    Write-InfoMsg "Next steps:"
    switch ($Tool) {
        'copilot' {
            Write-Host "  1. GitHub Copilot will automatically discover .github/copilot-instructions.md"
            Write-Host "  2. The instructions reference AI-GOVERNANCE.md and ai-governance/ folder"
            Write-Host "  3. Copilot will apply governance rules in all code suggestions"
        }
        'gemini' {
            Write-Host "  1. Open Gemini and start a new conversation"
            Write-Host "  2. Upload these files to the conversation:"
            Write-Host "     - AI-GOVERNANCE.md"
            Write-Host "     - GEMINI.md"
            Write-Host "     - All files from ai-governance/ folder"
            Write-Host "  3. Reference them when requesting code generation"
        }
        'claude' {
            Write-Host "  1. Open Claude and start a new conversation"
            Write-Host "  2. Upload these files to the conversation:"
            Write-Host "     - AI-GOVERNANCE.md"
            Write-Host "     - CLAUDE.md"
            Write-Host "     - All files from ai-governance/ folder"
            Write-Host "  3. Reference them when requesting code generation"
        }
    }
    
    Write-Host ""
    Write-InfoMsg "Verification checklist:"
    Write-Host "  [ ] Review AI-GOVERNANCE.md to understand policy precedence"
    Write-Host "  [ ] Review ai-governance/ tier files for your tech stack"
    Write-Host "  [ ] Customize governance rules if needed (edit tier files)"
    Write-Host "  [ ] Commit governance files to version control"
    Write-Host ""
}
finally {
    # Cleanup temporary directory
    if (Test-Path $tempDir) {
        Remove-Item $tempDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}
