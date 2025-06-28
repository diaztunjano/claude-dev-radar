#!/usr/bin/env bash

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Validate inputs
if [ $# -eq 0 ]; then
    log_error "Usage: $0 <issue_number> [project_area]"
    echo "  issue_number: GitHub issue number to work on"
    echo "  project_area: frontend|backend|database|docs (optional, default: frontend)"
    exit 1
fi

issue=$1
project_area=${2:-"frontend"}

log_info "Starting Claude Code workflow for issue #$issue in $project_area area"

# Validate we're in the correct directory with .claude/ structure
if [[ ! -d ".git" ]]; then
    log_error "Please run this script from a git repository root directory"
    exit 1
fi

if [[ ! -d ".claude" ]]; then
    log_error "No .claude/ structure found. Please initialize first."
    log_info "Run: claude-setup init"
    exit 1
fi

# Check if Claude Code is available
if ! command -v claude &> /dev/null; then
    log_error "Claude Code not found. Please install Claude Code first."
    log_info "Install with: curl -sSL https://claude.ai/install | sh"
    exit 1
fi

# Read project context from .claude/ files
read_claude_context() {
    local project_state=""
    local active_epic=""
    local next_session=""
    
    if [[ -f ".claude/current/project-state.md" ]]; then
        project_state=$(cat ".claude/current/project-state.md")
    fi
    
    if [[ -f ".claude/current/active-epic.md" ]]; then
        active_epic=$(cat ".claude/current/active-epic.md")
    fi
    
    if [[ -f ".claude/current/next-session.md" ]]; then
        next_session=$(cat ".claude/current/next-session.md")
    fi
    
    # Export for use in Claude prompts
    export CLAUDE_PROJECT_STATE="$project_state"
    export CLAUDE_ACTIVE_EPIC="$active_epic"  
    export CLAUDE_NEXT_SESSION="$next_session"
}

# Update session file with progress
update_session_file() {
    local session_description="$1"
    local changes_made="$2"
    
    # Find the most recent session file for this issue
    local current_month=$(date +%Y-%m)
    local session_dir=".claude/sessions/$current_month"
    
    if [[ -d "$session_dir" ]]; then
        # Look for session file containing this issue number
        local session_file=$(find "$session_dir" -name "*work-issue-$issue*" -type f | head -1)
        
        if [[ -n "$session_file" && -f "$session_file" ]]; then
            # Update the session file with progress
            local temp_file=$(mktemp)
            local in_changes_section=false
            
            while IFS= read -r line; do
                echo "$line" >> "$temp_file"
                
                # Add changes after "### Files Modified" line
                if [[ "$line" == "### Files Modified" ]]; then
                    echo "$changes_made" >> "$temp_file"
                    in_changes_section=true
                elif [[ "$line" == "### New Files Created" ]]; then
                    in_changes_section=false
                fi
            done < "$session_file"
            
            mv "$temp_file" "$session_file"
            log_success "Updated session file: $session_file"
        fi
    fi
}

log_success "Environment validated. Reading .claude/ context..."

# Read current project context
read_claude_context

log_success "Starting Claude Code session with context..."

claude \
  "Working on software development issue #$issue - Project Area: $project_area

## CURRENT PROJECT CONTEXT (.claude/ files)
Use this context to understand the current project state:

### PROJECT STATE:
$CLAUDE_PROJECT_STATE

### ACTIVE EPIC:
$CLAUDE_ACTIVE_EPIC

### NEXT SESSION PLAN:
$CLAUDE_NEXT_SESSION

## C.I.D.E.R. DEVELOPMENT PROTOCOL
Follow this protocol throughout the session:
- **C**ontextualize: Understand current state and requirements
- **I**terate: Plan and break down work into manageable steps
- **D**ocument: Record decisions and progress in .claude/ files
- **E**xecute: Implement with testing and validation
- **R**eflect: Update project state and plan next steps

## PHASE 1: CONTEXTUALIZATION
- Read issue #$issue details and requirements carefully
- Understand how this issue fits within the current active epic
- Verify that issue #$issue exists and is actionable (not blocked/duplicate)
- Check git status: \`git status --porcelain\` should be clean
- Identify complexity: [SIMPLE|MEDIUM|COMPLEX] and estimate effort
- Document dependencies: other issues, critical files, current epic status
- Comment on the issue with your analysis and work plan

## PHASE 2: IMPACT ANALYSIS
- Verify project builds: \`npm run build\` to establish baseline
- If project_area='backend': run backend tests and build checks
- If project_area='database': review database schema and migration files
- Identify affected systems and potential breaking changes
- If COMPLEX: create detailed plan in issue and request review
- PRIORITY: Simple, efficient, and agile code - avoid over-engineering

## PHASE 3: INCREMENTAL IMPLEMENTATION
### For project_area='frontend':
- Verify builds: \`npm run build\` after significant changes
- Verify types: \`npm run type-check\` to ensure TypeScript correctness
- Optional linting: \`npm run lint\` if time permits
- PRIORITY: Working functionality + correct types
### For project_area='backend':
- REQUIRED: Tests after each change: \`npm test\`
- REQUIRED: Build check: \`npm run build\`
- REQUIRED: Types: \`npx tsc --noEmit\` (if TypeScript)
- Backend is critical - tests are mandatory
### For project_area='database':
- Apply changes in order: migration → functions → testing
- Document database changes appropriately

- Incremental commits: 'WIP: #$issue - [clear description]'
- Update issue every 2-3 commits with real progress
- If blocked: document in issue and reconsider approach
- FOCUS: Simple solutions that work, not perfect ones

## PHASE 4: VALIDATION & CLEANUP
### Complete validation:
- FRONTEND: \`npm run build\` must pass + \`npm run type-check\` without TypeScript errors
- BACKEND: If modified, REQUIRED: \`npm test && npm run build\` must pass 100%
- Test functionality in browser if applicable
- Verify that external integrations still work

### Cleanup and simplicity:
- Remove obsolete/unused code - keep codebase clean
- Simplify where possible - LESS is MORE
- Verify no breaking changes in critical APIs
- Self-review: read ALL changes with fresh, pragmatic perspective
- GOAL: Code that works, not perfect code

## PHASE 5: DOCUMENTATION & REFLECTION (C.I.D.E.R.)
### Update .claude/ files:
- Update .claude/current/active-epic.md with progress made
- Update session file in .claude/sessions/ with:
  * Files modified
  * Decisions made
  * Problems encountered and solutions
  * Time spent and complexity
- Update .claude/current/next-session.md with next steps
- If epic is completed, update .claude/epics/epics-roadmap.md

### If existing PR:
- Update with summary of changes
- Reference issue: Closes #$issue
- Force push if necessary: \`git push origin --force-with-lease\`

### If new PR:
- Create with template including:
  * Closes #$issue
  * Epic context and progress
  * Testing performed
  * Breaking changes (if applicable)
  * Screenshots/demos for UI changes
  * .claude/ files updated

### Documentation:
- REQUIRED: Update relevant documentation files
- If new functions/endpoints: document appropriately
- Follow project documentation standards

## ERROR HANDLING & LIMITS
- If any phase fails: STOP, document in issue, ask for guidance
- If build fails: fix immediately or rollback to last working state
- If backend tests fail: REQUIRED to fix before continuing
- If complexity exceeds estimation: update issue and consider splitting
- Maximum 90 minutes of work (ask for continuation if needed)
- NEVER commit code that breaks the build
- NEVER commit backend changes without passing tests

## PROJECT-SPECIFIC TOOLS
- Database: apply migrations in correct order, test thoroughly
- Backend services: deploy only after complete testing - CRITICAL
- Frontend: use existing patterns, follow established conventions, SIMPLICITY
- Documentation: keep project docs updated according to standards
- PRs: review recent merged/closed PRs to understand current code context

## DEVELOPMENT PHILOSOPHY
- SIMPLICITY over complexity
- FUNCTIONALITY over perfection
- AGILITY over excessive documentation
- WORKING CODE over elegant code
- Tests where they are critical (backend/APIs)

## SESSION COMPLETION
- When finished, provide a clear summary of work completed
- Confirm all .claude/ files are updated
- Confirm issue #$issue is resolved or appropriately updated
- Document any remaining work or next steps

Ready to begin C.I.D.E.R. development session for issue #$issue!" \
  --allowedTools "Read" "Write" "Edit" "MultiEdit" \
  "Bash(git:*)" "Bash(npm:*)" "Bash(npx:*)" "Bash(yarn:*)" \
  "Bash(gh:*)" "Bash(find:*)" "Bash(ls:*)" "Bash(grep:*)" "Bash(rg:*)" \
  "Bash(curl:*)" "Bash(cd:*)" "Bash(pwd:*)" "Bash(echo:*)" \
  "Bash(cat:*)" "Bash(head:*)" "Bash(tail:*)"

# Capture result and update session documentation
result=$?
if [ $result -eq 0 ]; then
    log_success "Claude Code session completed for issue #$issue"
    update_session_file "Issue #$issue work session" "Session completed successfully"
    log_info "Check the issue comments and any new PR for results"
    log_info "Session documented in .claude/sessions/"
else
    log_error "Claude Code session failed for issue #$issue"
    update_session_file "Issue #$issue work session" "Session failed with exit code $result"
fi

exit $result