---
allowed-tools: Bash(echo:*), Bash(grep:*), Bash(find:*), Bash(wc:*), Bash(head:*), Bash(sed:*), Read
description: List all available epics and their current status
---

# 📋 C.I.D.E.R. Epic List

**List all available epics and their current status**

---

## What This Command Does

Displays a **comprehensive overview** of all project epics:
- **Available epics** from the roadmap
- **Current status** of each epic
- **Associated issues** for each epic
- **Progress tracking** and recommendations

---

## 📊 Epic Overview

### Project Epics Roadmap
@.claude/epics/epics-roadmap.md

### Current Active Epic
@.claude/current/active-epic.md

---

## 📋 Available Epics

Let me analyze the current epic structure:

### Epics from Roadmap
!echo "📋 **Project Epics**:"
!grep -E "^\*\*EPIC-.*\*\*|^[0-9]+\. \*\*EPIC-" .claude/epics/epics-roadmap.md 2>/dev/null || echo "No epics found in roadmap"

### Epic Categories
!echo ""
!echo "🎯 **Epic Categories Available**:"
!echo "- **EPIC-FRONTEND**: User interface development"
!echo "- **EPIC-BACKEND**: Server-side development"
!echo "- **EPIC-DATABASE**: Data management"
!echo "- **EPIC-API**: API development"
!echo "- **EPIC-TESTING**: Quality assurance"
!echo "- **EPIC-DEPLOYMENT**: DevOps & infrastructure"
!echo "- **EPIC-PERFORMANCE**: Optimization"
!echo "- **EPIC-SECURITY**: Security implementation"
!echo "- **EPIC-DOCS**: Documentation"

---

## 🔍 Epic Status Analysis

### Issues by Epic
!echo "📊 **Issues Distribution by Epic**:"

!for epic in FRONTEND BACKEND DATABASE API TESTING DEPLOYMENT PERFORMANCE SECURITY DOCS; do
    count=$(find .claude/epics/ -name "issue-*.md" -exec grep -l "EPIC-$epic" {} \; 2>/dev/null | wc -l)
    if [ "$count" -gt 0 ]; then
        echo "- **EPIC-$epic**: $count issues"

        # Show issue details for this epic
        find .claude/epics/ -name "issue-*.md" -exec grep -l "EPIC-$epic" {} \; 2>/dev/null | head -3 | while read file; do
            title=$(head -1 "$file" | sed 's/# //')
            status=$(grep -E "Status.*:" "$file" | head -1 | sed 's/.*Status.*: //')
            echo "  - $title [$status]"
        done
    fi
done

### Epic Progress Summary
!TODO_ISSUES=$(find .claude/epics/ -name "issue-*.md" -exec grep -l "Status.*TODO" {} \; 2>/dev/null | wc -l)
!ACTIVE_ISSUES=$(find .claude/epics/ -name "issue-*.md" -exec grep -l "Status.*IN_PROGRESS\|Status.*ACTIVE" {} \; 2>/dev/null | wc -l)
!DONE_ISSUES=$(find .claude/epics/ -name "issue-*.md" -exec grep -l "Status.*DONE\|Status.*COMPLETED" {} \; 2>/dev/null | wc -l)

!echo ""
!echo "📈 **Overall Progress**:"
!echo "- 📋 **Planned**: $TODO_ISSUES issues"
!echo "- 🔄 **Active**: $ACTIVE_ISSUES issues"
!echo "- ✅ **Completed**: $DONE_ISSUES issues"
!echo "- **Total**: $((TODO_ISSUES + ACTIVE_ISSUES + DONE_ISSUES)) issues across all epics"

---

## 🎯 Epic Recommendations

### Priority Suggestions
Based on current project state:

!if [ "$TODO_ISSUES" -eq 0 ] && [ "$ACTIVE_ISSUES" -eq 0 ] && [ "$DONE_ISSUES" -eq 0 ]; then
    echo "🚀 **Getting Started Recommendations**:"
    echo "1. **EPIC-DOCS**: Start with documentation to understand project"
    echo "2. **EPIC-TESTING**: Establish testing foundation"
    echo "3. **EPIC-FRONTEND**: Begin with user-facing features"
    echo ""
    echo "💡 **Next Step**: Use `/project:cider:generate EPIC-DOCS \"improve README\"` to create first issue"
elif [ "$ACTIVE_ISSUES" -gt 0 ]; then
    echo "⚡ **Continue Active Work**:"
    echo "Focus on completing current active issues before starting new epics"
    echo ""
    echo "💡 **Next Step**: Use `/project:cider:work <issue-number>` to continue active work"
else
    echo "📋 **Development Recommendations**:"
    echo "1. **Complete Current Epic**: Focus on finishing started epics"
    echo "2. **Balance Work**: Don't start too many epics simultaneously"
    echo "3. **Document Progress**: Update epic status as work progresses"
fi

### Epic Selection Guide
!echo ""
!echo "🎯 **Epic Selection Guidelines**:"
!echo ""
!echo "**For New Projects**:"
!echo "1. Start with **EPIC-DOCS** - Document and understand"
!echo "2. Move to **EPIC-TESTING** - Establish quality foundation"
!echo "3. Choose core feature epic - **EPIC-FRONTEND** or **EPIC-BACKEND**"
!echo ""
!echo "**For Existing Projects**:"
!echo "1. Review current codebase with **EPIC-PERFORMANCE** or **EPIC-SECURITY**"
!echo "2. Extend functionality with feature-specific epics"
!echo "3. Improve operations with **EPIC-DEPLOYMENT**"

---

## 📊 Epic Management Commands

### Working with Epics
```bash
# Generate issue for specific epic
/project:cider:generate EPIC-FRONTEND "responsive navigation"
/project:cider:generate EPIC-BACKEND "user authentication API"
/project:cider:generate EPIC-DOCS "API documentation"

# Work on generated issues
/project:cider:work 1234 full
/project:cider:work 1235 quick

# Check progress
/project:cider:status
```

### Epic Organization
!echo ""
!echo "🗂️ **Epic File Structure**:"
!echo "- **Roadmap**: `.claude/epics/epics-roadmap.md`"
!echo "- **Active Epic**: `.claude/current/active-epic.md`"
!echo "- **Issues**: `.claude/epics/issue-*.md`"
!echo "- **Sessions**: `.claude/sessions/YYYY-MM/`"

---

## 🎭 Epic Templates

### Common Epic Patterns
!echo "📝 **Epic Generation Examples**:"
!echo ""
!echo "**Frontend Development**:"
!echo "- \`/project:cider:generate EPIC-FRONTEND \"user dashboard component\"\`"
!echo "- \`/project:cider:generate EPIC-FRONTEND \"responsive mobile layout\"\`"
!echo ""
!echo "**Backend Development**:"
!echo "- \`/project:cider:generate EPIC-BACKEND \"REST API endpoints\"\`"
!echo "- \`/project:cider:generate EPIC-BACKEND \"database integration\"\`"
!echo ""
!echo "**Quality & Operations**:"
!echo "- \`/project:cider:generate EPIC-TESTING \"unit test coverage\"\`"
!echo "- \`/project:cider:generate EPIC-DEPLOYMENT \"CI/CD pipeline\"\`"

---

## 📈 Next Steps

### Based on Current State
!if [ -f ".claude/current/active-epic.md" ]; then
    echo "✅ **Active Epic Detected**: Continue with current epic work"
    echo "📋 **Recommendation**: Complete active issues before starting new epics"
else
    echo "🚀 **No Active Epic**: Ready to start new epic work"
    echo "📋 **Recommendation**: Choose an epic and generate first issue"
fi

### Quick Actions
!echo ""
!echo "⚡ **Quick Start Options**:"
!echo "1. **Documentation**: \`/project:cider:generate EPIC-DOCS \"project overview\"\`"
!echo "2. **Testing Setup**: \`/project:cider:generate EPIC-TESTING \"test framework setup\"\`"
!echo "3. **Feature Development**: \`/project:cider:generate EPIC-FRONTEND \"main component\"\`"

---

**📋 Epic overview complete! Choose an epic and start structured development with `/project:cider:generate`**