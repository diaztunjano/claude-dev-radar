#!/bin/bash
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
GRAY='\033[0;37m'
NC='\033[0m' # No Color

# Safe spinner characters (ASCII compatible)
SPINNER_CHARS="/-\|"

# Animation function
animate_loading() {
    local duration=$1
    local msg=$2
    local i=0

    while [ $i -lt $duration ]; do
        printf "\r${BLUE}[%s]${NC} %s" "${SPINNER_CHARS:$((i % ${#SPINNER_CHARS})):1}" "$msg"
        sleep 0.1
        i=$((i + 1))
    done
    printf "\r${GREEN}[+]${NC} %s\n" "$msg"
}

# Logo
show_logo() {
    echo -e "${BLUE}"
    cat << 'EOF'
   ______ __      ___    __  ______  ____   __________    ____  ___    ____
  / ____// /     /   |  / / / / __ \/ __ \ / ____/ __ \  / __ \/   |  / __ \
 / /    / /     / /| | / / / / / / / /_/ // __/ / /_/ / / /_/ / /| | / /_/ /
/ /___ / /___  / ___ |/ /_/ / /_/ / __/  / /___/ _, _/ / _, _/ ___ |/ _, _/
\____//_____/ /_/  |_|\____/_____/_/    /_____/_/ |_| /_/ |_/_/  |_/_/ |_|

EOF
    echo -e "${NC}"
    echo -e "${CYAN}>> AI-Powered Development Tools for Claude Code${NC}"
    echo -e "${GRAY}Installing R.A.D.A.R. + C.I.D.E.R. systems with slash commands...${NC}"
    echo ""
}

# Check prerequisites
check_prerequisites() {
    echo -e "${YELLOW}>> Checking prerequisites...${NC}"

    # Check Claude Code (essential)
    if ! command -v claude &> /dev/null; then
        echo -e "${RED}[X] Claude Code not found - REQUIRED for slash commands${NC}"
        echo -e "${YELLOW}[>] Install with: curl -sSL https://claude.ai/install | sh${NC}"
        exit 1
    fi

    # Check Git
    if ! command -v git &> /dev/null; then
        echo -e "${RED}[X] Git not found${NC}"
        exit 1
    fi

    # Check Node.js (optional, for CLI tools)
    if command -v node &> /dev/null && command -v npm &> /dev/null; then
        echo -e "${GREEN}[+] Node.js detected - CLI tools available${NC}"
        CLI_AVAILABLE=true
    else
        echo -e "${YELLOW}[!] Node.js not found - slash commands only${NC}"
        CLI_AVAILABLE=false
    fi

    echo -e "${GREEN}[+] Prerequisites check passed${NC}"
    echo ""
}

# Install package (if available)
install_package() {
    if [ "$CLI_AVAILABLE" = true ]; then
        echo -e "${BLUE}>> Installing claude-dev-radar globally...${NC}"

        # Try to install from NPM, fallback to local install
        if npm list -g claude-dev-radar &> /dev/null; then
            echo -e "${YELLOW}[>] claude-dev-radar already installed, updating...${NC}"
            npm update -g claude-dev-radar
        elif npm view claude-dev-radar &> /dev/null; then
            npm install -g claude-dev-radar
        else
            echo -e "${YELLOW}[!] NPM package not available, using local installation...${NC}"
            # Local installation logic would go here
            CLI_AVAILABLE=false
        fi

        animate_loading 20 "Setting up CLI tools"
    else
        echo -e "${BLUE}>> Slash commands mode - no CLI installation needed${NC}"
        animate_loading 10 "Configuring slash commands"
    fi
    echo ""
}

# Setup current project
setup_project() {
    echo -e "${PURPLE}>> Setting up current project...${NC}"

    # Check if we're in a Git repository
    if [ ! -d ".git" ]; then
        echo -e "${YELLOW}[>] Initializing Git repository...${NC}"
        git init
        git add .
        git commit -m "Initial commit with Claude Dev R.A.D.A.R. setup" || true
    fi

    # Create .claude structure
    echo -e "${BLUE}[>] Creating .claude/ development structure...${NC}"
    mkdir -p .claude/commands/{radar,cider} .claude/current .claude/epics .claude/sessions .claude/guides .claude/templates

    # Create slash commands (core functionality)
    echo -e "${BLUE}[>] Installing slash commands...${NC}"

    # Setup command
    cat > .claude/commands/setup.md << 'EOF'
# 🚀 Project Setup - Claude Dev R.A.D.A.R.

**Setup your project with AI-powered development tools**

---

## What this command does:

1. **🎯 Detects technology stack** - Analyzes your project automatically
2. **📋 Generates epic roadmap** - Based on detected technologies
3. **📝 Creates project files** - State tracking and session planning
4. **🚀 Ready for development** - Sets up for `/radar:analyze` and `/cider:*` commands

---

## Project Analysis

Let me analyze your project structure to create a customized setup:

### Technology Stack Detection
!find . -name "package.json" -o -name "requirements.txt" -o -name "Cargo.toml" -o -name "go.mod" -o -name "Gemfile" -o -name "composer.json" -type f | head -10

### Directory Structure Overview
!ls -la | head -20

### Repository Basics
!echo "Repository: $(basename $(pwd))"
!git rev-parse --git-dir 2>/dev/null && echo "Branch: $(git branch --show-current 2>/dev/null)" || echo "No Git repository detected"
!git rev-list --count HEAD 2>/dev/null && echo "Commits: $(git rev-list --count HEAD)" || echo "No commits yet"

---

## Creating Configuration Files

### Project State File
!cat > .claude/current/project-state.md << 'EOF'
# Project State

## Overview
Repository initialized with Claude development tools on $(date +%Y-%m-%d).

## Technology Stack Detected
[To be populated by analysis]

## Architecture
[To be documented as development progresses]

## Current Status
- 🚀 Project initialized
- 📋 Epics roadmap created
- 🔧 Development tools configured

## Important Decisions
[Document major architectural and technical decisions here]

## Next Session Priority
- Review epics roadmap
- Choose first epic to develop
- Set up development environment if needed
EOF

### Epics Roadmap
!cat > .claude/epics/epics-roadmap.md << 'EOF'
# Epics Roadmap

## Suggested Epics (Based on Project Analysis)

1. **EPIC-DOCS**: Documentation improvements
2. **EPIC-TESTING**: Quality assurance and testing
3. **EPIC-PERFORMANCE**: Performance optimization
4. **EPIC-SECURITY**: Security implementation
5. **EPIC-FRONTEND**: User interface development (if applicable)
6. **EPIC-BACKEND**: Server-side development (if applicable)
7. **EPIC-DATABASE**: Data management (if applicable)
8. **EPIC-API**: API development (if applicable)
9. **EPIC-DEPLOYMENT**: DevOps & infrastructure

## Epic Priority Order
[Reorder these based on project needs]

## Epic Status
- 📋 **TODO**: All epics
- 🔄 **IN_PROGRESS**: None
- ✅ **COMPLETED**: None

## Notes
Each epic should be broken down into smaller, atomic issues following C.I.D.E.R. methodology.
EOF

!echo "✅ Created project configuration files"

---

## GitIgnore Setup

!echo "" >> .gitignore 2>/dev/null || touch .gitignore
!grep -q "Claude Development Files" .gitignore || {
    echo "" >> .gitignore
    echo "# Claude Development Files" >> .gitignore
    echo ".claude/sessions/" >> .gitignore
    echo ".claude-context.json" >> .gitignore
    echo "analysis/" >> .gitignore
}
!echo "✅ Updated .gitignore with Claude development files"

---

## 🎉 Setup Complete!

Your project is now equipped with Claude Dev R.A.D.A.R. tools!

### 🚀 Next Steps:

1. **Run analysis**: `/radar:analyze` - Complete project analysis (5 min)
2. **Quick overview**: `/radar:quick` - Fast project overview (2 min)
3. **Generate issues**: `/cider:generate EPIC-DOCS "improve README"`
4. **Start working**: `/cider:work <issue-number> <scope>`

### 📁 Files Created:
- `.claude/current/project-state.md` - Project overview
- `.claude/epics/epics-roadmap.md` - Development roadmap
- `.claude/current/next-session.md` - Session planning
- `.claude/current/active-epic.md` - Epic tracking

### 🎯 Recommended Workflow:
1. **Understand**: `/radar:analyze` to get complete project overview
2. **Plan**: Review generated roadmap and choose first epic
3. **Execute**: Use `/cider:generate` and `/cider:work` for structured development
4. **Iterate**: Regular analysis to track progress

---

**🤖 Your project is now ready for AI-powered development with Claude Code!**
EOF

    # Quick radar command
    cat > .claude/commands/radar/quick.md << 'EOF'
# ⚡ R.A.D.A.R. Quick Analysis

**Fast project overview in 2 minutes**

---

## 🔍 Quick Analysis

!echo "⚡ Running R.A.D.A.R. Quick Analysis..."
!echo "📅 Analysis Date: $(date)"
!echo "📁 Repository: $(basename $(pwd))"

### Technology Stack Detection
!echo "🔍 **Technology Stack:**"
!find . -name "package.json" -o -name "requirements.txt" -o -name "Cargo.toml" -o -name "go.mod" -o -name "Gemfile" -o -name "composer.json" -type f | head -5

### Directory Structure
!echo "📁 **Directory Structure:**"
!ls -la | head -10

### Repository Status
!echo "📊 **Repository Status:**"
!git rev-parse --git-dir 2>/dev/null && echo "✅ Git repository" || echo "❌ No Git repository"
!echo "📝 Files: $(find . -type f | wc -l)"
!echo "📂 Directories: $(find . -type d | wc -l)"

---

## 📋 Quick Summary

**Project Overview**: [One sentence summary]
**Main Technology**: [Primary tech stack]
**Development Status**: [Assessment of current state]
**Recommended Next Step**: [Specific actionable recommendation]

---

## 🚀 Next Steps

1. **Full Analysis**: Use `/radar:analyze` for comprehensive analysis
2. **Epic Planning**: Review `/cider:list-epics` for development roadmap
3. **Issue Generation**: Use `/cider:generate` to start structured development

**⚡ Quick analysis complete! For comprehensive analysis, use `/radar:analyze`**
EOF

    # Basic cider generate command
    cat > .claude/commands/cider/generate.md << 'EOF'
# 🎯 C.I.D.E.R. Issue Generation

**Generate atomic development issues following C.I.D.E.R. methodology**

---

Usage: `/cider:generate EPIC-NAME "Issue description"`

Example: `/cider:generate EPIC-FRONTEND "implement user authentication form"`

---

## 📋 Available Epics

@.claude/epics/epics-roadmap.md

---

## 🎯 C.I.D.E.R. Issue Generation

Please provide:
1. **Epic Name** (e.g., EPIC-FRONTEND, EPIC-BACKEND, EPIC-DOCS)
2. **Issue Description** (specific feature or improvement)

I'll generate a structured issue following C.I.D.E.R. methodology:
- **🎯 Contextualizar**: Understand the problem and requirements
- **🔄 Iterar**: Plan the approach and break into tasks
- **📝 Documentar**: Create specifications and documentation
- **⚡ Ejecutar**: Implement with testing and validation
- **🔍 Reflexionar**: Review outcomes and plan next steps

**Ready to generate your issue!**
EOF

    # Run claude-setup if available
    if [ "$CLI_AVAILABLE" = true ] && command -v claude-setup &> /dev/null; then
        echo -e "${BLUE}[>] Running claude-setup quick...${NC}"
        claude-setup quick
    fi

    # Create .gitignore entries
    if [ ! -f ".gitignore" ]; then
        echo -e "\n# Claude Development Files\n.claude/sessions/\n.claude-context.json\nanalysis/" > .gitignore
    else
        if ! grep -q "Claude Development Files" .gitignore; then
            echo -e "\n# Claude Development Files\n.claude/sessions/\n.claude-context.json\nanalysis/" >> .gitignore
        fi
    fi

    echo -e "${GREEN}[+] Project setup completed${NC}"
    echo ""
}

# Show success message
show_success() {
    echo ""
    echo -e "${GREEN}================================================================${NC}"
    echo -e "${GREEN}                    INSTALLATION COMPLETE!                     ${NC}"
    echo -e "${GREEN}================================================================${NC}"
    echo ""
    echo -e "${CYAN}>> 🚀 Slash Commands (Primary - Use in Claude Code):${NC}"
    echo -e "  ${WHITE}/setup${NC}                    # Initialize project"
    echo -e "  ${WHITE}/radar:analyze${NC}           # Full project analysis"
    echo -e "  ${WHITE}/radar:quick${NC}             # Quick 2-minute overview"
    echo -e "  ${WHITE}/cider:generate${NC}          # Generate atomic issues"
    echo ""

    if [ "$CLI_AVAILABLE" = true ]; then
        echo -e "${CYAN}>> 🛠️ CLI Commands (Secondary - Use in terminal):${NC}"
        echo -e "  ${WHITE}claude-radar analyze${NC}     # Full repository analysis"
        echo -e "  ${WHITE}claude-cider generate${NC}    # Generate issues"
        echo -e "  ${WHITE}claude-setup init${NC}        # Setup new projects"
        echo ""
    fi

    echo -e "${CYAN}>> 📋 Next steps:${NC}"
    echo -e "  ${WHITE}1.${NC} Open Claude Code: ${BLUE}claude${NC}"
    echo -e "  ${WHITE}2.${NC} Run setup: ${BLUE}/setup${NC}"
    echo -e "  ${WHITE}3.${NC} Analyze project: ${BLUE}/radar:analyze${NC}"
    echo -e "  ${WHITE}4.${NC} Generate first issue: ${BLUE}/cider:generate EPIC-DOCS \"improve README\"${NC}"
    echo ""
    echo -e "${PURPLE}[*] You're now equipped with AI-powered development tools!${NC}"
    echo -e "${PURPLE}[*] Primary workflow: Claude Code + Slash Commands${NC}"
    echo -e "${GRAY}Documentation: https://github.com/yourusername/claude-dev-radar${NC}"
    echo ""
}

# Main installation flow
main() {
    show_logo
    check_prerequisites
    install_package
    setup_project
    show_success
}

# Error handling
trap 'echo -e "\n${RED}[X] Installation failed. Check the error above.${NC}"; exit 1' ERR

# Run main function
main