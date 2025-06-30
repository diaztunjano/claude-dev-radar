# Guide: Using /init:claude Command

## Purpose
The `/init:claude` command generates a comprehensive CLAUDE.md file that includes all your development methodologies, ensuring that when you run `claude init` in Claude IDE, it has access to your complete workflow.

## Problem It Solves
When using HeyClaudio:
1. You run `claudio init` to set up project structure
2. You run `claude init` in Claude IDE to create CLAUDE.md
3. **Problem**: The generated CLAUDE.md doesn't include your git workflow or C.I.D.E.R. methodology

## Solution
The `/init:claude` command creates a CLAUDE.md that includes:
- Complete git workflow from `.claude/guides/git-workflow.md`
- Full C.I.D.E.R. methodology from `.claude/guides/development-methodology.md`
- Project structure and organization
- All available commands
- Quality standards and best practices

## Usage

### In Claude IDE:
```
/init:claude
```

This will:
1. Check that `.claude/` structure exists
2. Read all methodology files
3. Generate comprehensive CLAUDE.md in project root
4. Include all workflows and standards

### Result
A complete CLAUDE.md file that serves as the single source of truth for:
- How to work with git in this project
- How to follow C.I.D.E.R. methodology
- What commands are available
- How to manage epics and issues
- Quality standards to maintain

## When to Use
- After running `claudio init` in a new project
- When you want to ensure methodology is preserved
- Before running `claude init` in Claude IDE
- When onboarding new team members

## Benefits
- **No Lost Information**: All methodologies are preserved
- **Single Source of Truth**: One file with everything
- **AI Context**: Claude IDE has full understanding of your workflow
- **Team Alignment**: Everyone follows same methodology

## Example Workflow
1. `npm i -g hey-claudio` - Install HeyClaudio
2. `claudio init` - Set up project structure
3. Open Claude IDE
4. `/init:claude` - Generate complete CLAUDE.md
5. Work with full methodology support!