# Development Methodology with Claude

## C.I.D.E.R. Protocol
Every development session follows this protocol:

### 1. **C**ontextualizar (Contextualize)
- Read `.claude/current/active-epic.md`
- Read `.claude/current/project-state.md`
- Review `.claude/current/next-session.md`
- Understand current state and objectives

### 2. **I**terar (Iterate)
- Plan specific tasks for this session
- Break down work into small, manageable steps
- Set clear session objectives

### 3. **D**ocumentar (Document)
- Create session file in `.claude/sessions/YYYY-MM/`
- Document decisions and changes as they happen
- Update relevant epic and project state files

### 4. **E**jecutar (Execute)
- Implement planned changes
- Test incrementally
- Commit regularly with descriptive messages

### 5. **R**eflexionar (Reflect)
- Update `.claude/current/project-state.md`
- Update epic progress in `.claude/current/active-epic.md`
- Plan next session in `.claude/current/next-session.md`
- Create session summary

## Session Workflow
1. **Session Start** (5 min)
   - Read current documentation
   - Set session objectives
   - Create session file

2. **Development** (30-90 min)
   - Implement planned features
   - Document decisions and changes
   - Test incrementally

3. **Session End** (10 min)
   - Update all relevant documentation
   - Plan next session
   - Commit and push changes

## File Update Rules
- **Always update** after significant changes:
  - `.claude/current/project-state.md`
  - `.claude/current/active-epic.md`

- **Create new** for each session:
  - `.claude/sessions/YYYY-MM/YYYYMMDD_HHMM_description.md`

- **Update as needed**:
  - `.claude/current/next-session.md`
  - `.claude/epics/epic-xxx-name.md`

## Epic Management
- Choose epics based on priority and dependencies
- Break epics into atomic issues (2-8 hours each)
- Update epic status regularly
- Document completion criteria clearly

## Quality Standards
- All code changes must pass tests
- Document architectural decisions
- Maintain consistent code style
- Update relevant documentation
