# 🔧 C.I.D.E.R. Issue Execution

**Work on specific issue following C.I.D.E.R. methodology**

**Usage**: `/cider:work ISSUE_NUMBER SCOPE`

**Arguments**: `$ARGUMENTS`

---

## What This Command Does

Executes development work on a **specific atomic issue** using structured C.I.D.E.R. methodology:

- **C**ontextualizar: Load issue context and current state
- **I**terar: Plan work approach and break into steps
- **D**ocumentar: Record decisions and progress
- **E**jecutar: Implement with testing and validation
- **R**eflexionar: Update status and plan next steps

---

## 📋 Parsing Work Arguments

!echo "🔧 C.I.D.E.R. Issue Execution"
!echo "Arguments: $ARGUMENTS"

!ISSUE_NUMBER=$(echo "$ARGUMENTS" | cut -d' ' -f1)
!SCOPE=${2:-"full"}

!echo "🎯 **Issue**: #$ISSUE_NUMBER"
!echo "📖 **Scope**: $SCOPE"

---

## 🔍 CONTEXTUALIZAR (Load Issue Context)

### Load Issue Details
!ISSUE_FILE=$(find .claude/epics/ -name "issue-$ISSUE_NUMBER-*.md" | head -1)
!if [ -f "$ISSUE_FILE" ]; then
    echo "✅ Found issue file: $ISSUE_FILE"
    echo "📋 **Issue Details**:"
else
    echo "❌ Issue #$ISSUE_NUMBER not found"
    echo "💡 Available issues:"
    find .claude/epics/ -name "issue-*.md" | head -5
    exit 1
fi

### Issue Content
@$ISSUE_FILE

### Current Project State
@.claude/current/project-state.md

### Active Epic Status
@.claude/current/active-epic.md

---

## 🎯 ITERAR (Plan Work Approach)

Based on the issue details above, let me plan the work approach:

### Issue Analysis
- **Complexity**: [Simple/Medium/Complex based on issue content]
- **Estimated Time**: [From issue file]
- **Dependencies**: [Any blocking requirements]
- **Files Affected**: [From issue specification]

### Work Plan
!echo "📋 **Work Plan for Issue #$ISSUE_NUMBER**:"

!if [ "$SCOPE" = "quick" ]; then
    echo "⚡ **QUICK MODE**: Focus on core functionality only"
    echo "1. Minimal viable implementation"
    echo "2. Basic testing"
    echo "3. Essential documentation"
elif [ "$SCOPE" = "full" ]; then
    echo "🎯 **FULL MODE**: Complete implementation"
    echo "1. Complete feature implementation"
    echo "2. Comprehensive testing"
    echo "3. Full documentation"
    echo "4. Code review preparation"
else
    echo "🔧 **CUSTOM SCOPE**: $SCOPE"
    echo "Work tailored to specified scope"
fi

### Environment Validation
!echo "🔍 **Environment Check**:"
!git status --porcelain || echo "⚠️ Git not available"
!if [ -f "package.json" ]; then
    echo "📦 Node.js project detected"
    npm --version || echo "⚠️ npm not available"
fi

---

## 📝 DOCUMENTAR (Session Tracking)

### Create Session File
!SESSION_FILE=".claude/sessions/$(date +%Y-%m)/$(date +%Y%m%d_%H%M)_issue-$ISSUE_NUMBER.md"
!mkdir -p "$(dirname "$SESSION_FILE")"

!cat > "$SESSION_FILE" << EOF
# Session: Issue #$ISSUE_NUMBER - $(date +%Y-%m-%d)

## Session Info
- **Issue**: #$ISSUE_NUMBER
- **Scope**: $SCOPE
- **Started**: $(date +%H:%M:%S)
- **Status**: 🔄 IN_PROGRESS

## Issue Summary
[From $ISSUE_FILE]

## Work Plan
[Approach planned above]

## Progress Log
- $(date +%H:%M) - Session started
- [ ] Phase 1: Setup and validation
- [ ] Phase 2: Core implementation
- [ ] Phase 3: Testing and validation
- [ ] Phase 4: Documentation and cleanup

## Files Modified
[To be updated during work]

## Important Decisions
[Document key decisions made during implementation]

## Challenges & Solutions
[Record any obstacles and how they were solved]

## Next Steps
[To be updated at session end]
EOF

!echo "📝 Session file created: $SESSION_FILE"

---

## 🚀 EJECUTAR (Implementation Phase)

### Pre-Implementation Checklist
!echo "✅ **Pre-Implementation Checklist**:"
!echo "- [x] Issue loaded and understood"
!echo "- [x] Work plan created"
!echo "- [x] Session tracking started"
!echo "- [ ] Environment validated"
!echo "- [ ] Dependencies checked"

### Implementation Focus

Based on the issue requirements, I'll now focus on:

1. **Understanding Requirements**: What exactly needs to be built?
2. **Current State Analysis**: What exists already?
3. **Implementation Strategy**: What's the best approach?
4. **Testing Strategy**: How will we validate success?

Let me start the implementation:

### Phase 1: Setup & Analysis
[Implementation steps will be guided by the specific issue requirements]

### Phase 2: Core Development
[Focus on the main deliverables specified in the issue]

### Phase 3: Testing & Validation
[Ensure acceptance criteria are met]

---

## 🔄 REFLEXIONAR (Progress Update)

### Update Issue Status
!sed -i 's/Status.*TODO/Status: 🔄 IN_PROGRESS/' "$ISSUE_FILE" 2>/dev/null || echo "Could not update issue status"

### Update Active Epic
!cat > .claude/current/active-epic.md << EOF
# Active Epic: [Epic Name]

## Current Status
🔄 **ACTIVE** - Working on Issue #$ISSUE_NUMBER

## Current Issue
- **Issue #$ISSUE_NUMBER**: Currently in development
- **Started**: $(date +%Y-%m-%d %H:%M)
- **Scope**: $SCOPE
- **Session**: $SESSION_FILE

## Progress
- [x] Issue analysis completed
- [x] Work plan created
- [ ] Implementation in progress
- [ ] Testing phase
- [ ] Completion and review

## Next Steps
Continue implementation following C.I.D.E.R. methodology

EOF

---

## 🎯 Work Session Active!

### Current Focus
**Issue #$ISSUE_NUMBER** is now the active development focus.

### Available Actions
- Continue implementation following the issue requirements
- Update progress in session file: `$SESSION_FILE`
- Test and validate work against acceptance criteria
- Use `/cider:status` to check overall progress

### Session Management
- **Session File**: `$SESSION_FILE`
- **Issue File**: `$ISSUE_FILE`
- **Current Status**: 🔄 IN_PROGRESS

---

**🔧 Ready to implement! Follow the issue requirements and update progress as you work.**