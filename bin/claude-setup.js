#!/usr/bin/env node

const { Command } = require('commander');
const chalk = require('chalk');
const ora = require('ora');
const inquirer = require('inquirer');
const { execSync } = require('child_process');
const path = require('path');
const fs = require('fs');

const program = new Command();

// Debug logging function
function debugLog(message, data = null) {
  if (process.env.CLAUDE_SETUP_DEBUG === 'true') {
    console.log(chalk.gray(`[DEBUG] ${new Date().toISOString()} - ${message}`));
    if (data) console.log(chalk.gray(JSON.stringify(data, null, 2)));
  }
}

function createGitignoreEntry() {
  const gitignorePath = './.gitignore';
  const entries = [
    '',
    '# Claude Development Files',
    '.claude/sessions/',
    '.claude-context.json',
    'analysis/',
    ''
  ].join('\n');

  if (fs.existsSync(gitignorePath)) {
    const content = fs.readFileSync(gitignorePath, 'utf8');
    if (!content.includes('.claude/sessions/')) {
      fs.appendFileSync(gitignorePath, entries);
      console.log(chalk.green('✅ Added .claude/sessions/ to .gitignore'));
    }
  } else {
    fs.writeFileSync(gitignorePath, entries);
    console.log(chalk.green('✅ Created .gitignore with Claude entries'));
  }
}

function detectProjectType() {
  const files = fs.readdirSync('./');
  const packageJson = fs.existsSync('./package.json') ? JSON.parse(fs.readFileSync('./package.json', 'utf8')) : null;

  // Detect technology stack
  const tech = {
    frontend: false,
    backend: false,
    database: false,
    api: false,
    testing: false,
    deployment: false
  };

  if (packageJson) {
    const deps = { ...packageJson.dependencies, ...packageJson.devDependencies };
    tech.frontend = !!deps.react || !!deps.vue || !!deps.angular || !!deps.svelte;
    tech.backend = !!deps.express || !!deps.fastify || !!deps.koa || !!deps.nestjs;
    tech.database = !!deps.mongoose || !!deps.prisma || !!deps.typeorm || !!deps.sequelize;
    tech.api = !!deps.axios || !!deps.graphql || !!deps['@apollo/client'];
    tech.testing = !!deps.jest || !!deps.cypress || !!deps.vitest || !!deps.playwright;
    tech.deployment = !!deps.docker || files.includes('Dockerfile') || files.includes('docker-compose.yml');
  }

  // Additional file-based detection
  if (files.includes('Cargo.toml')) tech.backend = true;
  if (files.includes('requirements.txt') || files.includes('setup.py')) tech.backend = true;
  if (files.includes('go.mod')) tech.backend = true;
  if (files.includes('.github') || files.includes('.gitlab-ci.yml')) tech.deployment = true;

  return tech;
}

function createClaudeStructure() {
  const spinner = ora('Creating .claude/ structure...').start();

  try {
    // Create directory structure
    const dirs = [
      '.claude',
      '.claude/current',
      '.claude/epics',
      '.claude/sessions',
      '.claude/guides',
      '.claude/templates',
      '.claude/commands',
      '.claude/commands/radar',
      '.claude/commands/cider'
    ];

    dirs.forEach(dir => {
      if (!fs.existsSync(dir)) {
        fs.mkdirSync(dir, { recursive: true });
      }
    });

    // Detect project context
    const projectTech = detectProjectType();
    const date = new Date().toISOString().split('T')[0];
    const yearMonth = date.substring(0, 7);

    // Create sessions directory for current month
    const sessionsDir = `.claude/sessions/${yearMonth}`;
    if (!fs.existsSync(sessionsDir)) {
      fs.mkdirSync(sessionsDir, { recursive: true });
    }

        // Generate suggested epics based on detected technology
    const suggestedEpics = [];
    if (projectTech.frontend) suggestedEpics.push('EPIC-FRONTEND: User Interface Development');
    if (projectTech.backend) suggestedEpics.push('EPIC-BACKEND: Server-side Development');
    if (projectTech.database) suggestedEpics.push('EPIC-DATABASE: Data Management');
    if (projectTech.api) suggestedEpics.push('EPIC-API: API Development');
    if (projectTech.testing) suggestedEpics.push('EPIC-TESTING: Quality Assurance');
    if (projectTech.deployment) suggestedEpics.push('EPIC-DEPLOYMENT: DevOps & Infrastructure');

    // Always include these
    suggestedEpics.push('EPIC-PERFORMANCE: Optimization');
    suggestedEpics.push('EPIC-SECURITY: Security Implementation');
    suggestedEpics.push('EPIC-DOCS: Documentation');

    // Create initial files
    createInitialClaudeFiles(suggestedEpics, projectTech);

    // Copy slash command templates
    copySlashCommandTemplates(projectTech);

    spinner.succeed('.claude/ structure created ✅');
    return true;
  } catch (error) {
    spinner.fail('Failed to create .claude/ structure ❌');
    console.error(chalk.red(error.message));
    return false;
  }
}

function copySlashCommandTemplates(projectTech) {
  debugLog('Copying slash command templates', { projectTech });

  try {
    // Get the directory where this package is installed
    const packageDir = path.dirname(path.dirname(__filename));
    const templatesDir = path.join(packageDir, 'templates', 'commands');

    debugLog('Templates directory', { templatesDir, exists: fs.existsSync(templatesDir) });

    if (!fs.existsSync(templatesDir)) {
      console.log(chalk.yellow('⚠️ Templates directory not found, skipping slash commands'));
      return;
    }

    // Define template files to copy
    const templateFiles = [
      { src: 'setup.template.md', dest: '.claude/commands/setup.md' },
      { src: 'radar/analyze.template.md', dest: '.claude/commands/radar/analyze.md' },
      { src: 'radar/quick.template.md', dest: '.claude/commands/radar/quick.md' },
      { src: 'cider/generate.template.md', dest: '.claude/commands/cider/generate.md' },
      { src: 'cider/work.template.md', dest: '.claude/commands/cider/work.md' },
      { src: 'cider/status.template.md', dest: '.claude/commands/cider/status.md' },
      { src: 'cider/list-epics.template.md', dest: '.claude/commands/cider/list-epics.md' }
    ];

    templateFiles.forEach(({ src, dest }) => {
      const srcPath = path.join(templatesDir, src);
      const destPath = dest;

      if (fs.existsSync(srcPath)) {
        let content = fs.readFileSync(srcPath, 'utf8');

        // Basic template variable replacement
        const projectName = path.basename(process.cwd());
        const packageJson = fs.existsSync('./package.json') ? JSON.parse(fs.readFileSync('./package.json', 'utf8')) : {};

        content = content
          .replace(/\{\{PROJECT_NAME\}\}/g, projectName)
          .replace(/\{\{FRAMEWORK\}\}/g, detectFramework(packageJson) || 'Unknown')
          .replace(/\{\{VERSION\}\}/g, packageJson.version || '1.0.0')
          .replace(/\{\{PACKAGE_MANAGER\}\}/g, fs.existsSync('./package-lock.json') ? 'npm' : fs.existsSync('./yarn.lock') ? 'yarn' : 'npm');

        fs.writeFileSync(destPath, content);
        debugLog(`Copied template: ${src} -> ${dest}`);
      } else {
        debugLog(`Template not found: ${srcPath}`);
      }
    });

    console.log(chalk.green('✅ Slash commands created and ready to use'));

  } catch (error) {
    debugLog('Error copying slash command templates', { error: error.message });
    console.log(chalk.yellow('⚠️ Could not copy slash command templates'));
  }
}

function detectFramework(packageJson) {
  if (!packageJson || !packageJson.dependencies) return null;

  const deps = { ...packageJson.dependencies, ...packageJson.devDependencies };

  if (deps.react) return 'React';
  if (deps.vue) return 'Vue';
  if (deps.angular) return 'Angular';
  if (deps.svelte) return 'Svelte';
  if (deps.express) return 'Express';
  if (deps.fastify) return 'Fastify';
  if (deps.nestjs) return 'NestJS';

  return 'Node.js';
}

function createInitialClaudeFiles(suggestedEpics, projectTech) {
  // 1. project-state.md
  const projectState = `# Project State

## Overview
Repository initialized with Claude development tools on ${new Date().toISOString().split('T')[0]}.

## Technology Stack Detected
${Object.entries(projectTech)
  .filter(([_, detected]) => detected)
  .map(([tech, _]) => `- ✅ ${tech.charAt(0).toUpperCase() + tech.slice(1)}`)
  .join('\n')}

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
`;

  fs.writeFileSync('.claude/current/project-state.md', projectState);

  // 2. epics-roadmap.md
  const epicsRoadmap = `# Epics Roadmap

## Suggested Epics (Based on Detected Technology)

${suggestedEpics.map((epic, index) => `${index + 1}. **${epic}**`).join('\n')}

## Epic Priority Order
[Reorder these based on project needs]

1. **EPIC-DOCS**: Documentation (Good starting point)
2. **EPIC-TESTING**: Quality Assurance (Establish testing foundation)
${suggestedEpics.filter(e => !e.includes('DOCS') && !e.includes('TESTING')).map((epic, index) => `${index + 3}. **${epic}`).join('\n')}

## Epic Status
- 📋 **TODO**: All epics
- 🔄 **IN_PROGRESS**: None
- ✅ **COMPLETED**: None

## Notes
Each epic should be broken down into smaller, atomic issues following C.I.D.E.R. methodology.
`;

  fs.writeFileSync('.claude/epics/epics-roadmap.md', epicsRoadmap);

  // 3. next-session.md
  const nextSession = `# Next Session Plan

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
`;

  fs.writeFileSync('.claude/current/next-session.md', nextSession);

  // 4. active-epic.md (placeholder)
  const activeEpic = `# Active Epic: [To Be Selected]

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
Open Claude IDE and use:
\`\`\`
/cider:list-epics
/cider:generate EPIC-NAME "issue description"
/cider:work ISSUE_NUMBER
\`\`\`
`;

  fs.writeFileSync('.claude/current/active-epic.md', activeEpic);

  // 5. Create templates
  createClaudeTemplates();

  // 6. Create guides
  createClaudeGuides();
}

function createClaudeTemplates() {
  // Epic template
  const epicTemplate = `# Epic XXX: [Name]

## Description
[Detailed description of the epic and its purpose]

## Objectives
- [ ] Objective 1
- [ ] Objective 2
- [ ] Objective 3

## Criteria de Aceptación
- Criterion 1: [Specific, measurable criterion]
- Criterion 2: [Specific, measurable criterion]

## Tasks
- [ ] Task 1: [Specific task description]
- [ ] Task 2: [Specific task description]
- [ ] Task 3: [Specific task description]

## Estado: [TODO/IN_PROGRESS/DONE]

## Technical Notes
[Important technical considerations, constraints, or dependencies]

## Business Value
[How this epic provides value to users/business]

## Definition of Done
- [ ] All objectives completed
- [ ] Acceptance criteria met
- [ ] Code reviewed and tested
- [ ] Documentation updated
`;

  fs.writeFileSync('.claude/templates/epic-template.md', epicTemplate);

  // Session template
  const sessionTemplate = `# Session: [Description] - [Date]

## Session Objectives
- Objective 1
- Objective 2

## Changes Made
### Files Modified
- \`file1.js\`: Description of changes
- \`file2.py\`: Description of changes

### New Files Created
- \`new_file.js\`: Purpose and functionality

## Decisions Made
1. **Decision 1**: Reasoning and alternatives considered
2. **Decision 2**: Reasoning and alternatives considered

## Problems Encountered
- Problem 1: How it was resolved
- Problem 2: Still pending resolution

## Next Steps
- [ ] Step 1
- [ ] Step 2
- [ ] Step 3

## Active Epic Progress
[Update on current epic development progress]

## Session Duration
Start: [HH:MM]
End: [HH:MM]
Total: [Duration]
`;

  fs.writeFileSync('.claude/templates/session-template.md', sessionTemplate);

  // Decision template
  const decisionTemplate = `# Decision: [Decision Title]

## Date
[YYYY-MM-DD]

## Context
[What is the situation that requires a decision?]

## Decision
[What was decided?]

## Rationale
[Why was this decision made?]

## Alternatives Considered
1. **Alternative 1**: [Description and why it wasn't chosen]
2. **Alternative 2**: [Description and why it wasn't chosen]

## Consequences
### Positive
- [Positive consequence 1]
- [Positive consequence 2]

### Negative
- [Negative consequence 1]
- [Negative consequence 2]

## Implementation
[How will this decision be implemented?]

## Review Date
[When should this decision be reviewed?]
`;

  fs.writeFileSync('.claude/templates/decision-template.md', decisionTemplate);
}

function createClaudeGuides() {
  // Git workflow
  const gitWorkflow = `# Git Workflow Guide

## Branch Strategy
- \`main\`: Production-ready code
- \`develop\`: Integration branch for features
- \`feature/epic-xxx-description\`: Feature branches for epics
- \`fix/issue-xxx-description\`: Bug fix branches

## Commit Message Format
\`\`\`
[TYPE](scope): description

Epic: #epic-number
Issue: #issue-number
\`\`\`

### Types
- \`feat\`: New feature
- \`fix\`: Bug fix
- \`docs\`: Documentation changes
- \`refactor\`: Code refactoring
- \`test\`: Adding tests
- \`chore\`: Maintenance tasks

## Workflow
1. Create feature branch from develop
2. Work on epic/issue
3. Commit regularly with descriptive messages
4. Push branch and create pull request
5. Code review and merge

## Commands
\`\`\`bash
# Start new epic
git checkout develop
git pull origin develop
git checkout -b feature/epic-001-authentication

# Work and commit
git add .
git commit -m "feat(auth): implement user login component

Epic: #1
Issue: #123"

# Push and create PR
git push origin feature/epic-001-authentication
\`\`\`
`;

  fs.writeFileSync('.claude/guides/git-workflow.md', gitWorkflow);

  // Development methodology
  const methodology = `# Development Methodology with Claude

## C.I.D.E.R. Protocol
Every development session follows this protocol:

### 1. **C**ontextualizar (Contextualize)
- Read \`.claude/current/active-epic.md\`
- Read \`.claude/current/project-state.md\`
- Review \`.claude/current/next-session.md\`
- Understand current state and objectives

### 2. **I**terar (Iterate)
- Plan specific tasks for this session
- Break down work into small, manageable steps
- Set clear session objectives

### 3. **D**ocumentar (Document)
- Create session file in \`.claude/sessions/YYYY-MM/\`
- Document decisions and changes as they happen
- Update relevant epic and project state files

### 4. **E**jecutar (Execute)
- Implement planned changes
- Test incrementally
- Commit regularly with descriptive messages

### 5. **R**eflexionar (Reflect)
- Update \`.claude/current/project-state.md\`
- Update epic progress in \`.claude/current/active-epic.md\`
- Plan next session in \`.claude/current/next-session.md\`
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
  - \`.claude/current/project-state.md\`
  - \`.claude/current/active-epic.md\`

- **Create new** for each session:
  - \`.claude/sessions/YYYY-MM/YYYYMMDD_HHMM_description.md\`

- **Update as needed**:
  - \`.claude/current/next-session.md\`
  - \`.claude/epics/epic-xxx-name.md\`

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
`;

  fs.writeFileSync('.claude/guides/development-methodology.md', methodology);
}

async function setupProject() {
  console.log(chalk.blue.bold('🚀 CLAUDE DEV SETUP'));
  console.log(chalk.gray('Setting up Claude automation tools for this project\n'));

  const answers = await inquirer.prompt([
    {
      type: 'confirm',
      name: 'createClaudeStructure',
      message: 'Create .claude/ development structure?',
      default: true
    },
    {
      type: 'confirm',
      name: 'setupGitignore',
      message: 'Add Claude development files to .gitignore?',
      default: true
    }
  ]);

  // Setup gitignore
  if (answers.setupGitignore) {
    createGitignoreEntry();
  }

  // Create .claude/ structure
  if (answers.createClaudeStructure) {
    const success = createClaudeStructure();
    if (!success) {
      console.log(chalk.yellow('💡 .claude/ structure setup failed, but continuing...'));
    }
  }

  // Initialize Git if needed
  if (!fs.existsSync('./.git')) {
    const spinner = ora('Initializing Git repository...').start();
    try {
      execSync('git init', { stdio: 'pipe' });
      execSync('git add .', { stdio: 'pipe' });
      execSync('git commit -m "Initial commit with Claude setup"', { stdio: 'pipe' });
      spinner.succeed('Git repository initialized ✅');
    } catch (error) {
      spinner.warn('Git initialization skipped (may already exist)');
    }
  }


  console.log(chalk.green.bold('\n🎉 PROJECT SETUP COMPLETE!'));
  console.log(chalk.cyan('\n📁 Created structure:'));
  console.log(chalk.white('  ✅ .claude/current/ - Project state tracking'));
  console.log(chalk.white('  ✅ .claude/epics/ - Epic management'));
  console.log(chalk.white('  ✅ .claude/commands/ - Native slash commands'));
  console.log(chalk.white('  ✅ .claude/sessions/ - Session history'));
  console.log(chalk.white('  ✅ .claude/guides/ - Development methodology'));

  console.log(chalk.cyan('\n🚀 Next steps:'));
  console.log(chalk.white('  1. Open Claude Code: claude'));
  console.log(chalk.white('  2. Initialize project: /project:setup'));
  console.log(chalk.white('  3. Run analysis: /project:radar:analyze'));
  console.log(chalk.white('  4. Generate issues: /project:cider:generate EPIC-DOCS "improve README"'));

  console.log(chalk.cyan('\n📚 Available slash commands:'));
  console.log(chalk.white('  /project:setup - Project initialization'));
  console.log(chalk.white('  /project:radar:analyze - Full project analysis'));
  console.log(chalk.white('  /project:radar:quick - Quick project overview'));
  console.log(chalk.white('  /project:cider:generate - Create atomic issues'));
  console.log(chalk.white('  /project:cider:work - Work on specific issue'));
  console.log(chalk.white('  /project:cider:status - Project status overview'));
  console.log(chalk.white('  /project:cider:list-epics - Show available epics'));

  console.log(chalk.yellow('\n💡 Pro tip: Open Claude Code and run /project:setup to get started!'));
}

async function quickStart() {
  console.log(chalk.yellow.bold('⚡ CLAUDE QUICK START'));

  const spinner = ora('Setting up minimal configuration...').start();

  try {
    createGitignoreEntry();
    createClaudeStructure();

    if (!fs.existsSync('./.git')) {
      execSync('git init', { stdio: 'pipe' });
      execSync('git add .', { stdio: 'pipe' });
      execSync('git commit -m "Initial commit with Claude structure"', { stdio: 'pipe' });
    }

    spinner.succeed('Quick setup completed ✅');

    console.log(chalk.green('\n⚡ Ready to go! Try:'));
    console.log(chalk.white('  claude                 # Open Claude IDE'));
    console.log(chalk.white('  /project:radar:quick           # Quick analysis'));
    console.log(chalk.white('  /project:radar:analyze         # Full analysis'));
    console.log(chalk.white('  /project:cider:generate        # Generate issues'));

  } catch (error) {
    spinner.fail('Quick setup failed ❌');
    console.error(chalk.red(error.message));
  }
}

program
  .name('claude-setup')
  .description('🚀 Setup Claude automation tools in current project')
  .version('1.0.0');

program
  .command('init')
  .description('🚀 Interactive project setup')
  .action(setupProject);

program
  .command('quick')
  .description('⚡ Quick setup with minimal configuration')
  .action(quickStart);

program
  .command('check')
  .description('🔍 Check if Claude tools are properly configured')
  .action(() => {
    console.log(chalk.blue.bold('🔍 CONFIGURATION CHECK'));

    const checks = [
      { name: 'Git repository', check: () => fs.existsSync('./.git') },
      { name: 'Claude Code installed', check: () => {
        try { execSync('claude --version', { stdio: 'pipe' }); return true; } catch { return false; }
      }},
      { name: '.gitignore configured', check: () => {
        if (!fs.existsSync('./.gitignore')) return false;
        const content = fs.readFileSync('./.gitignore', 'utf8');
        return content.includes('.claude/sessions/');
      }},
            { name: '.claude/ structure', check: () => fs.existsSync('./.claude') },
      { name: 'Slash commands installed', check: () =>
        fs.existsSync('./.claude/commands/setup.md') &&
        fs.existsSync('./.claude/commands/radar/analyze.md') &&
        fs.existsSync('./.claude/commands/cider/generate.md')
      },
      { name: 'Current state files', check: () =>
        fs.existsSync('./.claude/current/project-state.md') &&
        fs.existsSync('./.claude/current/active-epic.md')
      },
      { name: 'Epic management', check: () => fs.existsSync('./.claude/epics/epics-roadmap.md') },
      { name: 'Templates available', check: () => fs.existsSync('./.claude/templates') },
      { name: 'Development guides', check: () => fs.existsSync('./.claude/guides') }
    ];

    checks.forEach(({ name, check }) => {
      const result = check();
      console.log(result
        ? chalk.green(`✅ ${name}`)
        : chalk.red(`❌ ${name}`)
      );
    });

    const passedChecks = checks.filter(({ check }) => check()).length;
    console.log(chalk.cyan(`\n📊 Score: ${passedChecks}/${checks.length}`));

    if (passedChecks < checks.length) {
      console.log(chalk.yellow('\n💡 Run: claude-setup init'));
    } else {
      console.log(chalk.green('\n🎉 All checks passed! Ready to use Claude tools.'));
    }
  });

// Default action
program.action(() => {
  console.log(chalk.blue.bold('🚀 CLAUDE DEV SETUP'));
  console.log(chalk.gray('Choose a setup option:\n'));

  console.log(chalk.white('  claude-setup init    # Interactive setup'));
  console.log(chalk.white('  claude-setup quick   # Quick minimal setup'));
  console.log(chalk.white('  claude-setup check   # Check configuration'));
  console.log(chalk.white('\nOr run with --help for more options'));
});

program.parse();