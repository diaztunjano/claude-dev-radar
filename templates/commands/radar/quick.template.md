---
allowed-tools: Bash(find:*), Bash(git:*), Bash(ls:*), Bash(echo:*), Bash(wc:*), Read, Grep, Glob
description: Fast project overview in 2 minutes
---

# ⚡ R.A.D.A.R. Quick Analysis

**Fast project overview in 2 minutes**

**Get essential insights without deep analysis**

---

## What This Command Does

Provides a **fast overview** of the project including:
- **Technology stack detection**
- **Basic structure analysis**
- **Key files identification**
- **Quick recommendations**

**Time required**: ~2 minutes

---

## 🔍 Quick Project Recognition

!echo "⚡ R.A.D.A.R. Quick Analysis Started..."
!echo "📅 Date: $(date)"
!echo "📁 Repository: $(basename $(pwd))"

### Technology Stack Detection
!find . -name "package.json" -o -name "requirements.txt" -o -name "Cargo.toml" -o -name "go.mod" -o -name "Gemfile" -type f | head -5

### Project Structure Overview
!ls -la | head -15

### Key Configuration Files
!find . -maxdepth 2 -name "*.json" -o -name "*.yml" -o -name "*.yaml" -o -name "Dockerfile" | grep -v node_modules | head -10

---

## 📊 Quick Analysis

### Main Project File
@package.json

### Documentation
@README.md

### Basic Repository Stats
!echo "📊 **Repository Statistics**:"
!echo "- **Files**: $(find . -type f | wc -l) total files"
!echo "- **Directories**: $(find . -type d | wc -l) directories"
!echo "- **Git commits**: $(git rev-list --count HEAD 2>/dev/null || echo 'N/A')"
!echo "- **Branch**: $(git branch --show-current 2>/dev/null || echo 'No Git')"

---

## 🎯 Quick Insights

Based on the files analyzed above, here's what I can tell you about this project:

### Technology Stack
[Analysis based on detected files and dependencies]

### Project Type
[Categorization: Frontend, Backend, Full-stack, CLI tool, Library, etc.]

### Architecture Pattern
[Basic architectural pattern identified]

### Key Observations
[3-5 key insights about the project structure and setup]

---

## 🚀 Quick Recommendations

### Immediate Actions
1. **Next Analysis**: For deeper insights, run `/project:radar:analyze`
2. **Issue Generation**: Use `/project:cider:generate` to start structured development
3. **Epic Management**: Use `/project:cider:list-epics` to see available epics

### Priority Areas
[Based on quick analysis, suggest 2-3 priority areas for improvement]

---

## 📋 Quick Summary

**Project Overview**: [One sentence summary]
**Main Technology**: [Primary tech stack]
**Development Status**: [Assessment of current state]
**Recommended Next Step**: [Specific actionable recommendation]

---

**⚡ Quick analysis complete! For comprehensive analysis, use `/project:radar:analyze`**