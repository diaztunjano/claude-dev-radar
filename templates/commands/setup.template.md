---
allowed-tools: Bash(find:*), Bash(git:*), Bash(ls:*), Bash(cat:*), Bash(echo:*), Bash(grep:*), Bash(touch:*), Read, Write, Edit
description: Setup project with HeyClaudio development tools
---

# 🚀 Project Setup - HeyClaudio

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

### Next Session Plan
!cat > .claude/current/next-session.md << 'EOF'
# Next Session Plan

## Session Objectives
- [ ] Review project structure and technology stack
- [ ] Choose first epic to work on
- [ ] Generate first atomic issues
- [ ] Set up development workflow

## Preparation Checklist
- [ ] Review .claude/current/project-state.md
- [ ] Review .claude/epics/epics-roadmap.md
- [ ] Ensure development environment is ready
- [ ] Choose priority epic from roadmap

## Planned Activities
1. **Project Analysis**: Understand current codebase structure
2. **Epic Selection**: Choose highest priority epic
3. **Issue Generation**: Create 2-3 atomic issues for selected epic
4. **Development Setup**: Configure any needed development tools

## Expected Outcomes
- Active epic selected and documented
- First issues created and ready for development
- Clear plan for subsequent development sessions

## Notes
This is the initial planning session. Focus on understanding and organizing rather than coding.
EOF

### Active Epic Placeholder
!cat > .claude/current/active-epic.md << 'EOF'
# Active Epic: [To Be Selected]

## Current Status
🔄 **No active epic yet**

## Selection Criteria
Choose an epic based on:
- Project priorities
- Dependencies
- Complexity (start with simpler epics)
- Business value

## When Epic is Selected
This file will be updated with:
- Epic details and objectives
- Current progress
- Active issues
- Next steps

## Commands to Get Started
```bash
# List available epics
/project:cider:list-epics

# Generate issue for chosen epic
/project:cider:generate EPIC-NAME "issue description"

# Work on generated issue
/project:cider:work <issue-number> <scope>
```
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

Your project is now equipped with HeyClaudio tools!

### 🚀 Next Steps:

1. **Run analysis**: `/project:radar:analyze` - Complete project analysis (5 min)
2. **Quick overview**: `/project:radar:quick` - Fast project overview (2 min)
3. **Generate issues**: `/project:cider:generate EPIC-DOCS "improve README"`
4. **Start working**: `/project:cider:work <issue-number> <scope>`

### 📁 Files Created:
- `.claude/current/project-state.md` - Project overview
- `.claude/epics/epics-roadmap.md` - Development roadmap
- `.claude/current/next-session.md` - Session planning
- `.claude/current/active-epic.md` - Epic tracking

### 🎯 Recommended Workflow:
1. **Understand**: `/project:radar:analyze` to get complete project overview
2. **Plan**: Review generated roadmap and choose first epic
3. **Execute**: Use `/project:cider:generate` and `/project:cider:work` for structured development
4. **Iterate**: Regular analysis to track progress

---

**🤖 Your project is now ready for AI-powered development with Claude Code!**