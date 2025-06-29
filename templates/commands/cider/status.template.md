---
allowed-tools: Bash(echo:*), Bash(date:*), Bash(basename:*), Bash(git:*), Bash(find:*), Bash(grep:*), Bash(wc:*), Bash(head:*), Bash(sed:*), Bash(sort:*), Read
description: View current project status, active epics, and issue progress
---

# 📊 C.I.D.E.R. Project Status

**View current project status, active epics, and issue progress**

---

## 🎯 Current Project Overview

### Project Information
!echo "📅 **Date**: $(date +%Y-%m-%d %H:%M)"
!echo "📁 **Repository**: $(basename $(pwd))"
!echo "🌿 **Branch**: $(git branch --show-current 2>/dev/null || echo 'No Git')"
!echo "📝 **Last Commit**: $(git log -1 --pretty=format:'%h - %s (%cr)' 2>/dev/null || echo 'No commits')"

---

## 📋 Active Epic Status

### Current Active Epic
@.claude/current/active-epic.md

### Epic Roadmap Overview
@.claude/epics/epics-roadmap.md

---

## 🔄 Recent Issues & Activity

### Generated Issues
!echo "### All Issues:"
!find .claude/epics/ -name "issue-*.md" -type f | sort -V | while read file; do
    if [ -f "$file" ]; then
        echo "- $(basename "$file"): $(head -1 "$file" | sed 's/# //')"
    fi
done

### Issue Status Summary
!TODO_COUNT=$(find .claude/epics/ -name "issue-*.md" -exec grep -l "Status.*TODO" {} \; | wc -l)
!PROGRESS_COUNT=$(find .claude/epics/ -name "issue-*.md" -exec grep -l "Status.*IN_PROGRESS\|Status.*ACTIVE" {} \; | wc -l)  
!DONE_COUNT=$(find .claude/epics/ -name "issue-*.md" -exec grep -l "Status.*DONE\|Status.*COMPLETED" {} \; | wc -l)

!echo "📊 **Issue Statistics**:"
!echo "- 📋 TODO: $TODO_COUNT issues"
!echo "- 🔄 IN PROGRESS: $PROGRESS_COUNT issues"  
!echo "- ✅ COMPLETED: $DONE_COUNT issues"
!echo "- **Total**: $((TODO_COUNT + PROGRESS_COUNT + DONE_COUNT)) issues"

---

## 📈 Project Health Metrics

### Repository Analysis Status
!if [ -d "analysis" ]; then
    echo "✅ **Analysis**: Complete"
    echo "📁 **Reports**: $(find analysis/reports/ -name "*.md" | wc -l) files"
    echo "🏗️ **Architecture**: $(find analysis/architecture/ -name "*.md" | wc -l) files"
    echo "📚 **Documentation**: $(find analysis/onboarding/ -name "*.md" | wc -l) files"
else
    echo "⚠️ **Analysis**: Not run yet"
    echo "💡 **Recommendation**: Run `/project:radar:analyze` for complete project overview"
fi

### Development Structure
!echo "### .claude/ Structure:"
!find .claude/ -type f -name "*.md" | sort | while read file; do
    echo "- $file"
done

### Git Status
!echo "### Repository Status:"
!git status --porcelain 2>/dev/null | head -10 || echo "No Git repository or no changes"

---

## 🎯 Current Session Planning

### Next Session Objectives
@.claude/current/next-session.md

### Session History
!echo "### Recent Sessions:"
!find .claude/sessions/ -name "*.md" -type f 2>/dev/null | sort -r | head -5 | while read file; do
    echo "- $(basename "$file" .md)"
done || echo "No session history yet"

---

## 🚀 Quick Actions

### Available Commands
```bash
# Analysis Commands
/project:radar:analyze          # Complete project analysis (5 min)
/project:radar:quick           # Fast overview (2 min)

# Issue Management  
/project:cider:generate EPIC "description"  # Create new atomic issue
/project:cider:work <issue-number> <scope>  # Start working on issue
/project:cider:list-epics                   # Show all available epics

# Project Setup
/project:setup                 # Initialize or reconfigure project
```

### Recommended Next Steps
Based on current project state:

!if [ ! -d "analysis" ]; then
    echo "1. **🔍 Run Analysis**: `/project:radar:analyze` to understand your codebase"
    echo "2. **📋 Review Epics**: Check generated roadmap for priorities"
    echo "3. **🎯 Generate Issues**: Use `/project:cider:generate` to create work items"
elif [ "$TODO_COUNT" -eq 0 ]; then
    echo "1. **🎯 Generate Issues**: Use `/project:cider:generate EPIC \"description\"` to create work"
    echo "2. **📋 Review Roadmap**: Update epic priorities in `.claude/epics/epics-roadmap.md`"
    echo "3. **🔄 Start Development**: Begin structured work with atomic issues"
elif [ "$PROGRESS_COUNT" -gt 0 ]; then
    echo "1. **⚡ Continue Work**: Resume active issues with `/project:cider:work`"
    echo "2. **📊 Track Progress**: Update issue status and document decisions"
    echo "3. **🔄 Review & Iterate**: Complete current work before starting new issues"
else
    echo "1. **🚀 Start Work**: Use `/project:cider:work <issue-number> <scope>` to begin"
    echo "2. **📝 Document Progress**: Follow C.I.D.E.R. methodology"
    echo "3. **🔄 Iterate**: Regular reviews and continuous improvement"
fi

---

## 📊 Project Health Score

!HEALTH_SCORE=0

!# Analysis completion (+20 points)
!if [ -d "analysis" ]; then
    HEALTH_SCORE=$((HEALTH_SCORE + 20))
    echo "✅ **Analysis Complete**: +20 points"
else
    echo "❌ **No Analysis**: 0 points (run /project:radar:analyze)"
fi

!# Issue management (+20 points)
!TOTAL_ISSUES=$((TODO_COUNT + PROGRESS_COUNT + DONE_COUNT))
!if [ "$TOTAL_ISSUES" -gt 0 ]; then
    HEALTH_SCORE=$((HEALTH_SCORE + 20))
    echo "✅ **Issues Created**: +20 points ($TOTAL_ISSUES total)"
else
    echo "❌ **No Issues**: 0 points (run /project:cider:generate)"
fi

!# Active development (+20 points)
!if [ "$PROGRESS_COUNT" -gt 0 ] || [ "$DONE_COUNT" -gt 0 ]; then
    HEALTH_SCORE=$((HEALTH_SCORE + 20))
    echo "✅ **Active Development**: +20 points"
else
    echo "❌ **No Active Work**: 0 points (start working on issues)"
fi

!# Documentation structure (+20 points)
!if [ -f ".claude/current/project-state.md" ] && [ -f ".claude/epics/epics-roadmap.md" ]; then
    HEALTH_SCORE=$((HEALTH_SCORE + 20))
    echo "✅ **Documentation Structure**: +20 points"
else
    echo "❌ **Incomplete Documentation**: 0 points (run /project:setup)"
fi

!# Recent activity (+20 points)
!if [ -n "$(find .claude/ -name "*.md" -mtime -7 2>/dev/null)" ]; then
    HEALTH_SCORE=$((HEALTH_SCORE + 20))
    echo "✅ **Recent Activity**: +20 points"
else
    echo "❌ **No Recent Activity**: 0 points"
fi

### Overall Health Score
!echo ""
!echo "🎯 **PROJECT HEALTH SCORE**: $HEALTH_SCORE/100"

!if [ "$HEALTH_SCORE" -ge 80 ]; then
    echo "🟢 **Status**: Excellent - Project is well-structured and active"
elif [ "$HEALTH_SCORE" -ge 60 ]; then
    echo "🟡 **Status**: Good - Minor improvements needed"
elif [ "$HEALTH_SCORE" -ge 40 ]; then
    echo "🟠 **Status**: Fair - Needs attention in key areas"
else
    echo "🔴 **Status**: Poor - Significant setup needed"
fi

---

## 💡 Tips for Improvement

### If Health Score < 40:
- Run `/project:setup` to initialize project structure
- Execute `/project:radar:analyze` for comprehensive analysis
- Create first issues with `/project:cider:generate`

### If Health Score 40-60:
- Complete any missing analysis phases
- Generate more atomic issues for structured development
- Start active development work

### If Health Score 60-80:
- Maintain regular development activity
- Document decisions and progress consistently
- Review and update epic priorities

### If Health Score 80+:
- Continue excellent development practices
- Consider advanced analysis features
- Share your structured approach with team

---

**Your project status overview is complete!**