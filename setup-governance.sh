#!/usr/bin/env bash
#
# AI Governance Templates Setup Script
# 
# Interactive script to install AI governance templates into your project.
# Prompts for tier (Lite/Standard/Enterprise) and tool (Copilot/Gemini/Claude),
# then downloads and installs governance files.
#
# Usage:
#   ./setup-governance.sh                    # Interactive mode
#   ./setup-governance.sh Standard copilot   # Non-interactive mode

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Output functions
print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_info() { echo -e "${CYAN}ℹ${NC} $1"; }
print_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }

# Configuration
TIER="${1:-}"
TOOL="${2:-}"
TARGET_PATH="${3:-.}"
TEMPLATE_REPO="${TEMPLATE_REPO:-https://github.com/samdman/ai-governance-templates.git}"

# Banner
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════${NC}"
echo -e "${CYAN}  AI Governance Templates Setup${NC}"
echo -e "${CYAN}═══════════════════════════════════════════════════${NC}"
echo ""

# Interactive tier selection if not provided
if [ -z "$TIER" ]; then
    print_info "Select governance tier:"
    echo "  1) Lite      - Lean production-safe baseline"
    echo "  2) Standard  - Modular monolith + AI-ready defaults"
    echo "  3) Enterprise - SaaS-safe + AI workload governance"
    echo ""
    read -p "Enter choice (1-3): " tier_choice
    
    case $tier_choice in
        1) TIER="Lite" ;;
        2) TIER="Standard" ;;
        3) TIER="Enterprise" ;;
        *)
            print_error "Invalid choice. Exiting."
            exit 1
            ;;
    esac
fi

# Interactive tool selection if not provided
if [ -z "$TOOL" ]; then
    echo ""
    print_info "Select AI tool:"
    echo "  1) copilot - GitHub Copilot"
    echo "  2) gemini  - Google Gemini"
    echo "  3) claude  - Anthropic Claude"
    echo ""
    read -p "Enter choice (1-3): " tool_choice
    
    case $tool_choice in
        1) TOOL="copilot" ;;
        2) TOOL="gemini" ;;
        3) TOOL="claude" ;;
        *)
            print_error "Invalid choice. Exiting."
            exit 1
            ;;
    esac
fi

# Validate inputs
case $TIER in
    Lite|Standard|Enterprise) ;;
    *)
        print_error "Invalid tier: $TIER (must be Lite, Standard, or Enterprise)"
        exit 1
        ;;
esac

case $TOOL in
    copilot|gemini|claude) ;;
    *)
        print_error "Invalid tool: $TOOL (must be copilot, gemini, or claude)"
        exit 1
        ;;
esac

echo ""
print_success "Configuration: Tier=$TIER, Tool=$TOOL"
print_info "Target directory: $TARGET_PATH"
echo ""

# Ensure target directory exists
mkdir -p "$TARGET_PATH"

# Create temporary directory
TEMP_DIR=$(mktemp -d -t ai-governance-XXXXXX)
trap "rm -rf '$TEMP_DIR'" EXIT

# Download templates
print_info "Downloading governance templates..."

# Try git clone first
if command -v git &> /dev/null; then
    if git clone --depth 1 --quiet "$TEMPLATE_REPO" "$TEMP_DIR" 2>/dev/null; then
        print_success "Templates downloaded via git"
    else
        print_warning "Git clone failed, trying zip download..."
        rm -rf "$TEMP_DIR"
        mkdir -p "$TEMP_DIR"
        
        # Fallback to curl/wget
        ZIP_URL="${TEMPLATE_REPO%.git}/archive/refs/heads/main.zip"
        if command -v curl &> /dev/null; then
            curl -sL "$ZIP_URL" -o "$TEMP_DIR/repo.zip"
        elif command -v wget &> /dev/null; then
            wget -q "$ZIP_URL" -O "$TEMP_DIR/repo.zip"
        else
            print_error "Neither git, curl, nor wget found. Cannot download templates."
            exit 1
        fi
        
        unzip -q "$TEMP_DIR/repo.zip" -d "$TEMP_DIR"
        # Move contents from extracted folder to temp root
        EXTRACTED_FOLDER=$(find "$TEMP_DIR" -mindepth 1 -maxdepth 1 -type d | head -n 1)
        mv "$EXTRACTED_FOLDER"/* "$TEMP_DIR/"
        rm -rf "$EXTRACTED_FOLDER"
        rm "$TEMP_DIR/repo.zip"
        
        print_success "Templates downloaded via zip"
    fi
else
    print_error "Git not found. Please install git or download templates manually."
    exit 1
fi

# Verify template structure
CANONICAL_FILE="$TEMP_DIR/AI-GOVERNANCE.md"
TIER_FOLDER="$TEMP_DIR/$TIER/ai-governance"
TOOL_ADAPTER="$TEMP_DIR/$(echo $TOOL | tr '[:lower:]' '[:upper:]').md"

if [ ! -f "$CANONICAL_FILE" ]; then
    print_error "Template validation failed: AI-GOVERNANCE.md not found"
    exit 1
fi

if [ ! -d "$TIER_FOLDER" ]; then
    print_error "Template validation failed: $TIER tier folder not found"
    exit 1
fi

print_success "Template structure validated"
echo ""

# Function to copy file with conflict handling
copy_with_prompt() {
    local source="$1"
    local destination="$2"
    local description="$3"
    
    if [ -f "$destination" ]; then
        print_warning "File already exists: $description"
        read -p "Overwrite? (y/N): " overwrite
        if [ "$overwrite" != "y" ] && [ "$overwrite" != "Y" ]; then
            print_info "Skipped: $description"
            return 1
        fi
    fi
    
    mkdir -p "$(dirname "$destination")"
    cp "$source" "$destination"
    print_success "Copied: $description"
    return 0
}

# Install governance files
print_info "Installing governance files..."

# Copy canonical policy
copy_with_prompt "$CANONICAL_FILE" "$TARGET_PATH/AI-GOVERNANCE.md" "AI-GOVERNANCE.md"

# Copy tier governance folder
mkdir -p "$TARGET_PATH/ai-governance"
for file in "$TIER_FOLDER"/*; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        copy_with_prompt "$file" "$TARGET_PATH/ai-governance/$filename" "ai-governance/$filename"
    fi
done

# Copy tool adapter
TOOL_ADAPTER_NAME="$(echo $TOOL | tr '[:lower:]' '[:upper:]').md"
if [ -f "$TOOL_ADAPTER" ]; then
    copy_with_prompt "$TOOL_ADAPTER" "$TARGET_PATH/$TOOL_ADAPTER_NAME" "$TOOL_ADAPTER_NAME"
fi

echo ""

# Create Copilot-specific integration file
if [ "$TOOL" = "copilot" ]; then
    print_info "Creating GitHub Copilot integration..."
    COPILOT_INSTRUCTIONS="$TARGET_PATH/.github/copilot-instructions.md"
    
    cat > "$COPILOT_INSTRUCTIONS" << EOF
# GitHub Copilot Instructions

This project uses AI governance templates to ensure code quality and consistency.

## Governance Files
Always reference these files when generating code:

1. **Canonical Policy**: \`AI-GOVERNANCE.md\`
   - Source of truth for all governance rules
   - Defines tier selection and policy precedence

2. **Tier-Specific Governance**: \`ai-governance/\`
   - Implementation rules for this project
   - Tier: **$TIER**

3. **Tool Adapter**: \`COPILOT.md\`
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
1. \`AI-GOVERNANCE.md\` (highest priority)
2. \`ai-governance/*\` tier docs
3. \`COPILOT.md\` (lowest priority)
EOF
    
    print_success "Created .github/copilot-instructions.md"
fi

# Success summary
echo ""
echo -e "${GREEN}═══════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  Installation Complete!${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════${NC}"
echo ""

print_success "Governance tier: $TIER"
print_success "AI tool: $TOOL"
echo ""

print_info "Files installed:"
echo "  • AI-GOVERNANCE.md (canonical policy)"
echo "  • ai-governance/* ($TIER tier rules)"
echo "  • $TOOL_ADAPTER_NAME (tool adapter)"
if [ "$TOOL" = "copilot" ]; then
    echo "  • .github/copilot-instructions.md (Copilot integration)"
fi
echo ""

# Tool-specific next steps
print_info "Next steps:"
case $TOOL in
    copilot)
        echo "  1. GitHub Copilot will automatically discover .github/copilot-instructions.md"
        echo "  2. The instructions reference AI-GOVERNANCE.md and ai-governance/ folder"
        echo "  3. Copilot will apply governance rules in all code suggestions"
        ;;
    gemini)
        echo "  1. Open Gemini and start a new conversation"
        echo "  2. Upload these files to the conversation:"
        echo "     - AI-GOVERNANCE.md"
        echo "     - GEMINI.md"
        echo "     - All files from ai-governance/ folder"
        echo "  3. Reference them when requesting code generation"
        ;;
    claude)
        echo "  1. Open Claude and start a new conversation"
        echo "  2. Upload these files to the conversation:"
        echo "     - AI-GOVERNANCE.md"
        echo "     - CLAUDE.md"
        echo "     - All files from ai-governance/ folder"
        echo "  3. Reference them when requesting code generation"
        ;;
esac

echo ""
print_info "Verification checklist:"
echo "  ☐ Review AI-GOVERNANCE.md to understand policy precedence"
echo "  ☐ Review ai-governance/ tier files for your tech stack"
echo "  ☐ Customize governance rules if needed (edit tier files)"
echo "  ☐ Commit governance files to version control"
echo ""
