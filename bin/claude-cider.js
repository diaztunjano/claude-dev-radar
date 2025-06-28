#!/usr/bin/env node

const { Command } = require('commander');
const chalk = require('chalk');
const ora = require('ora');
const { execSync } = require('child_process');
const path = require('path');
const fs = require('fs');

const program = new Command();

// Get the directory where this script is installed
const packageDir = path.dirname(path.dirname(__filename));
const generatorScript = path.join(packageDir, 'claude-issue-generator.sh');
const workerScript = path.join(packageDir, 'claude-issue-worker.sh');

function checkPrerequisites() {
  const spinner = ora('Checking prerequisites...').start();

  try {
    // Check if we're in a Git repository
    execSync('git rev-parse --git-dir', { stdio: 'pipe' });

    // Check if Claude Code is available
    execSync('claude --version', { stdio: 'pipe' });

    // Check if .claude/ structure exists
    if (!fs.existsSync('./.claude')) {
      spinner.fail('Prerequisites check failed ❌');
      console.log(chalk.red('❌ .claude/ structure not found.'));
      console.log(chalk.yellow('💡 Run: claude-setup init'));
      return false;
    }

    spinner.succeed('Prerequisites verified ✅');
    return true;
  } catch (error) {
    spinner.fail('Prerequisites check failed ❌');

    if (error.message.includes('git rev-parse')) {
      console.log(chalk.red('❌ Not a Git repository.'));
    }

    if (error.message.includes('claude')) {
      console.log(chalk.red('❌ Claude Code not found.'));
    }

    return false;
  }
}

function readClaudeState() {
  try {
    const projectState = fs.existsSync('./.claude/current/project-state.md') 
      ? fs.readFileSync('./.claude/current/project-state.md', 'utf8')
      : 'No project state found';
    
    const activeEpic = fs.existsSync('./.claude/current/active-epic.md')
      ? fs.readFileSync('./.claude/current/active-epic.md', 'utf8') 
      : 'No active epic found';
    
    const nextSession = fs.existsSync('./.claude/current/next-session.md')
      ? fs.readFileSync('./.claude/current/next-session.md', 'utf8')
      : 'No next session plan found';

    return { projectState, activeEpic, nextSession };
  } catch (error) {
    console.log(chalk.yellow('⚠️ Could not read .claude/ state files'));
    return { projectState: '', activeEpic: '', nextSession: '' };
  }
}

function createSessionFile(description, issueNumber = null) {
  try {
    const now = new Date();
    const date = now.toISOString().split('T')[0].replace(/-/g, '');
    const time = now.toTimeString().slice(0, 5).replace(':', '');
    const yearMonth = now.toISOString().substring(0, 7);
    
    // Ensure sessions directory exists
    const sessionsDir = `.claude/sessions/${yearMonth}`;
    if (!fs.existsSync(sessionsDir)) {
      fs.mkdirSync(sessionsDir, { recursive: true });
    }
    
    const sessionFile = `${sessionsDir}/${date}_${time}_${description.replace(/\s+/g, '-').toLowerCase()}.md`;
    
    const sessionContent = `# Session: ${description} - ${now.toISOString().split('T')[0]}

## Session Objectives
${issueNumber ? `- Work on issue #${issueNumber}` : '- [To be defined]'}
- [Additional objectives]

## Session Start
**Time**: ${now.toTimeString().slice(0, 8)}
**Issue**: ${issueNumber ? `#${issueNumber}` : 'N/A'}

## Changes Made
### Files Modified
[To be updated during session]

### New Files Created
[To be updated during session]

## Decisions Made
[Document decisions as they are made]

## Problems Encountered
[Document any issues and their resolutions]

## Next Steps
- [ ] [Step 1]
- [ ] [Step 2]

## Active Epic Progress
[Update epic progress]

## Session End
**Time**: [To be filled at end]
**Duration**: [To be calculated]
`;

    fs.writeFileSync(sessionFile, sessionContent);
    console.log(chalk.green(`📝 Session file created: ${sessionFile}`));
    return sessionFile;
  } catch (error) {
    console.log(chalk.yellow(`⚠️ Could not create session file: ${error.message}`));
    return null;
  }
}

function updateActiveEpic(epicName, issueNumber = null) {
  try {
    const activeEpicPath = './.claude/current/active-epic.md';
    let content = '';
    
    if (fs.existsSync(activeEpicPath)) {
      content = fs.readFileSync(activeEpicPath, 'utf8');
    }
    
    // If this is a new epic, update the content
    if (!content.includes(epicName)) {
      const updatedContent = `# Active Epic: ${epicName}

## Current Status
🔄 **IN_PROGRESS** - Currently working on this epic

## Current Issue
${issueNumber ? `**Issue #${issueNumber}**: Currently being developed` : 'No specific issue active'}

## Epic Progress
- [ ] Planning completed
- [ ] Development started
- [ ] Testing phase
- [ ] Documentation updated
- [ ] Epic completed

## Recent Activity
- ${new Date().toISOString().split('T')[0]}: Epic activated${issueNumber ? ` with issue #${issueNumber}` : ''}

## Next Steps
- Continue with current development
- Update progress as tasks are completed

## Epic Details
[Reference the specific epic file in .claude/epics/ for full details]
`;
      
      fs.writeFileSync(activeEpicPath, updatedContent);
      console.log(chalk.green(`📋 Updated active epic: ${epicName}`));
    }
  } catch (error) {
    console.log(chalk.yellow(`⚠️ Could not update active epic: ${error.message}`));
  }
}

function runCommand(scriptPath, args) {
  if (!checkPrerequisites()) {
    process.exit(1);
  }

  const command = `bash "${scriptPath}" ${args.join(' ')}`;
  const spinner = ora('Running C.I.D.E.R. command...').start();

  try {
    const result = execSync(command, {
      stdio: 'pipe',
      encoding: 'utf8',
      cwd: process.cwd()
    });

    spinner.succeed('C.I.D.E.R. command completed ✅');
    console.log(result);

  } catch (error) {
    spinner.fail('C.I.D.E.R. command failed ❌');
    console.error(chalk.red(error.message));
    process.exit(1);
  }
}

program
  .name('claude-cider')
  .description('🎯 C.I.D.E.R. - Atomic issues generation and execution')
  .version('1.0.0');

program
  .command('generate <epic> <description>')
  .description('🎯 Generate atomic issue for epic')
  .action((epic, description) => {
    console.log(chalk.green.bold('🎯 C.I.D.E.R. ISSUE GENERATOR'));
    console.log(chalk.gray('Contextualizar → Iterar → Documentar → Ejecutar → Reflexionar\n'));
    
    // Read current .claude/ state for context
    const claudeState = readClaudeState();
    console.log(chalk.cyan('📖 Reading current project state...'));
    
    // Create session for issue generation
    const sessionFile = createSessionFile(`generate-issue-${epic.toLowerCase()}`, null);
    
    // Update active epic
    updateActiveEpic(epic, null);
    
    runCommand(generatorScript, ['generate', epic, description]);
  });

program
  .command('work <issueNumber> <scope>')
  .description('⚡ Execute issue following C.I.D.E.R. protocol')
  .action((issueNumber, scope) => {
    console.log(chalk.blue.bold('⚡ C.I.D.E.R. WORKER'));
    console.log(chalk.gray(`Working on issue #${issueNumber} - ${scope}\n`));
    
    // Read current .claude/ state for context
    const claudeState = readClaudeState();
    console.log(chalk.cyan('📖 Reading current project context...'));
    
    // Create session for development work
    const sessionFile = createSessionFile(`work-issue-${issueNumber}`, issueNumber);
    
    // Update active epic with issue number
    const epicMatch = claudeState.activeEpic.match(/# Active Epic: ([^\n]+)/);
    if (epicMatch) {
      updateActiveEpic(epicMatch[1], issueNumber);
    }
    
    runCommand(workerScript, [issueNumber, scope]);
  });

program
  .command('list-epics')
  .description('📋 List available epics')
  .action(() => {
    console.log(chalk.cyan.bold('📋 Available Epics'));
    runCommand(generatorScript, ['list-epics']);
  });

program
  .command('demo')
  .description('🎮 Show demo and usage examples')
  .action(() => {
    console.log(chalk.magenta.bold('🎮 C.I.D.E.R. DEMO'));
    runCommand(generatorScript, ['demo']);
  });

program
  .command('analyze <query>')
  .description('🔍 Analyze repository for issue opportunities')
  .action((query) => {
    console.log(chalk.yellow.bold('🔍 C.I.D.E.R. ANALYZER'));
    runCommand(generatorScript, ['analyze', query]);
  });

program
  .command('status')
  .description('📊 Show current project status from .claude/ files')
  .action(() => {
    console.log(chalk.blue.bold('📊 PROJECT STATUS'));
    
    if (!fs.existsSync('./.claude')) {
      console.log(chalk.red('❌ .claude/ structure not found'));
      console.log(chalk.yellow('💡 Run: claude-setup init'));
      return;
    }
    
    const claudeState = readClaudeState();
    
    // Show active epic
    console.log(chalk.cyan('\n🎯 Active Epic:'));
    const epicMatch = claudeState.activeEpic.match(/# Active Epic: ([^\n]+)/);
    if (epicMatch) {
      console.log(chalk.green(`  ${epicMatch[1]}`));
    } else {
      console.log(chalk.yellow('  No active epic'));
    }
    
    // Show project state summary
    console.log(chalk.cyan('\n📋 Project State:'));
    const techMatch = claudeState.projectState.match(/## Technology Stack Detected\n([\s\S]*?)##/);
    if (techMatch) {
      const techLines = techMatch[1].trim().split('\n').filter(line => line.trim());
      techLines.forEach(line => console.log(chalk.green(`  ${line.trim()}`)));
    }
    
    // Show next session plan
    console.log(chalk.cyan('\n📅 Next Session Plan:'));
    const objectivesMatch = claudeState.nextSession.match(/## Session Objectives\n([\s\S]*?)##/);
    if (objectivesMatch) {
      const objectives = objectivesMatch[1].trim().split('\n').filter(line => line.trim()).slice(0, 3);
      objectives.forEach(obj => console.log(chalk.white(`  ${obj.trim()}`)));
    }
    
    // Show recent sessions
    console.log(chalk.cyan('\n📝 Recent Sessions:'));
    try {
      const now = new Date();
      const currentMonth = `.claude/sessions/${now.toISOString().substring(0, 7)}`;
      if (fs.existsSync(currentMonth)) {
        const sessions = fs.readdirSync(currentMonth)
          .filter(file => file.endsWith('.md'))
          .sort()
          .reverse()
          .slice(0, 3);
        
        if (sessions.length > 0) {
          sessions.forEach(session => {
            const sessionName = session.replace(/^\d{8}_\d{4}_/, '').replace('.md', '').replace(/-/g, ' ');
            console.log(chalk.green(`  📄 ${sessionName}`));
          });
        } else {
          console.log(chalk.yellow('  No sessions yet'));
        }
      } else {
        console.log(chalk.yellow('  No sessions yet'));
      }
    } catch (error) {
      console.log(chalk.yellow('  Could not read sessions'));
    }
    
    console.log(chalk.cyan('\n🚀 Quick Commands:'));
    console.log(chalk.white('  claude-cider generate EPIC-NAME "description"'));
    console.log(chalk.white('  claude-cider work <issue-number> <scope>'));
    console.log(chalk.white('  claude-setup check'));
  });

program.parse();