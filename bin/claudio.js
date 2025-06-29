#!/usr/bin/env node

const { Command } = require('commander');
const chalk = require('chalk');
const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

const program = new Command();

// ASCII Art para HeyClaudio
function showWelcome() {
  console.log(chalk.cyan(`
   ████████╗██╗      █████╗ ██╗   ██╗██████╗ ██╗ ██████╗
  ██╔════██║██║     ██╔══██╗██║   ██║██╔══██╗██║██╔═══██╗
  ██║     ██║██║     ███████║██║   ██║██║  ██║██║██║   ██║
  ██║     ██║██║     ██╔══██║██║   ██║██║  ██║██║██║   ██║
  ╚██████╗██║███████╗██║  ██║╚██████╔╝██████╔╝██║╚██████╔╝
   ╚═════╝╚═╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚═╝ ╚═════╝
  `));
  console.log(chalk.gray('    🤖 AI-Powered Development Assistant\n'));
}

function checkClaude() {
  try {
    execSync('claude --version', { stdio: 'pipe' });
    return true;
  } catch {
    return false;
  }
}

function isProjectSetup() {
  return fs.existsSync('./.claude') &&
         fs.existsSync('./.claude/commands') &&
         fs.existsSync('./.claude/current/project-state.md');
}

function showStatus() {
  console.log(chalk.blue.bold('📊 PROJECT STATUS\n'));

  // Check setup
  const setupOk = isProjectSetup();
  console.log(setupOk
    ? chalk.green('✅ Project setup complete')
    : chalk.red('❌ Project not setup - run: claudio init')
  );

  // Check Claude IDE
  const claudeOk = checkClaude();
  console.log(claudeOk
    ? chalk.green('✅ Claude IDE available')
    : chalk.yellow('⚠️  Claude IDE not found - install from https://claude.ai/download')
  );

  if (setupOk) {
    // Show current epic
    const activeEpicPath = './.claude/current/active-epic.md';
    if (fs.existsSync(activeEpicPath)) {
      const content = fs.readFileSync(activeEpicPath, 'utf8');
      const epicMatch = content.match(/# Active Epic: (.+)/);
      if (epicMatch) {
        console.log(chalk.cyan(`🎯 Active Epic: ${epicMatch[1]}`));
      }
    }

    // Show recent activity
    const projectStatePath = './.claude/current/project-state.md';
    if (fs.existsSync(projectStatePath)) {
      const content = fs.readFileSync(projectStatePath, 'utf8');
      const activityMatch = content.match(/## Recent Activity\n([\s\S]*?)(?=\n##|$)/);
      if (activityMatch) {
        console.log(chalk.gray('📝 Recent Activity:'));
        const activities = activityMatch[1].split('\n').filter(line => line.trim().startsWith('-')).slice(0, 3);
        activities.forEach(activity => {
          console.log(chalk.gray(`  ${activity.trim()}`));
        });
      }
    }
  }

  console.log(chalk.blue('\n🚀 NEXT STEPS:'));

  if (!setupOk) {
    console.log(chalk.white('  1. claudio init          # Setup project'));
    console.log(chalk.white('  2. claude                # Open Claude IDE'));
    console.log(chalk.white('  3. /project:radar:analyze        # Run analysis'));
  } else if (!claudeOk) {
    console.log(chalk.white('  1. Install Claude IDE    # https://claude.ai/download'));
    console.log(chalk.white('  2. claude                # Open Claude IDE'));
    console.log(chalk.white('  3. /project:radar:analyze        # Run analysis'));
  } else {
    console.log(chalk.white('  1. claude                # Open Claude IDE'));
    console.log(chalk.white('  2. /project:radar:analyze        # Run analysis'));
    console.log(chalk.white('  3. /project:cider:generate       # Create issues'));
    console.log(chalk.white('  4. /project:cider:work           # Start development'));
  }
}

function showCommands() {
  console.log(chalk.blue.bold('🎯 AVAILABLE COMMANDS\n'));

  console.log(chalk.cyan('📋 Setup & Status:'));
  console.log(chalk.white('  claudio init             # Initialize project'));
  console.log(chalk.white('  claudio status           # Show project status'));
  console.log(chalk.white('  claudio check            # Check configuration'));

  console.log(chalk.cyan('\n🔍 Quick Actions:'));
  console.log(chalk.white('  claudio open             # Open Claude IDE'));
  console.log(chalk.white('  claudio analyze          # Run quick analysis'));

  console.log(chalk.cyan('\n⚡ Claude IDE Commands (use inside Claude):'));
  console.log(chalk.white('  /project:radar:analyze           # Complete project analysis'));
  console.log(chalk.white('  /project:radar:quick             # Quick project overview'));
  console.log(chalk.white('  /project:cider:generate          # Generate atomic issues'));
  console.log(chalk.white('  /project:cider:work              # Work on specific issue'));
  console.log(chalk.white('  /project:cider:status            # Project status'));
  console.log(chalk.white('  /project:cider:list-epics        # List available epics'));

  console.log(chalk.yellow('\n💡 Workflow:'));
  console.log(chalk.gray('  1. claudio init          # One-time setup'));
  console.log(chalk.gray('  2. claude                # Open Claude IDE'));
  console.log(chalk.gray('  3. /project:radar:analyze        # Understand project'));
  console.log(chalk.gray('  4. /project:cider:generate       # Create work items'));
  console.log(chalk.gray('  5. /project:cider:work           # Start coding'));
}

// Commands
program
  .name('claudio')
  .description('🤖 AI-Powered Development Assistant')
  .version('1.0.0')
  .action(() => {
    showWelcome();
    showStatus();
  });

program
  .command('init')
  .description('🚀 Initialize project with HeyClaudio')
  .action(() => {
    console.log(chalk.blue.bold('🚀 INITIALIZING PROJECT\n'));

    // Run setup
    const setupScript = path.join(__dirname, 'claude-setup.js');
    try {
      console.log(chalk.cyan('Setting up project structure...'));
      execSync(`node "${setupScript}" init`, { stdio: 'inherit' });

      console.log(chalk.green.bold('\n🎉 PROJECT READY!'));
      console.log(chalk.cyan('\n🚀 What\'s next?'));
      console.log(chalk.white('  1. Open Claude IDE: ' + chalk.bold('claude')));
      console.log(chalk.white('  2. Run analysis: ' + chalk.bold('/project:radar:analyze')));
      console.log(chalk.white('  3. Start coding: ' + chalk.bold('/project:cider:generate')));

    } catch (error) {
      console.error(chalk.red('❌ Setup failed:'), error.message);
      process.exit(1);
    }
  });

program
  .command('status')
  .description('📊 Show project status')
  .action(showStatus);

program
  .command('check')
  .description('🔍 Check configuration')
  .action(() => {
    const setupScript = path.join(__dirname, 'claude-setup.js');
    try {
      execSync(`node "${setupScript}" check`, { stdio: 'inherit' });
    } catch (error) {
      console.error(chalk.red('❌ Check failed:'), error.message);
    }
  });

program
  .command('open')
  .alias('claude')
  .description('🚀 Open Claude IDE')
  .action(() => {
    if (!checkClaude()) {
      console.log(chalk.red('❌ Claude IDE not found'));
      console.log(chalk.yellow('💡 Install from: https://claude.ai/download'));
      return;
    }

    console.log(chalk.cyan('🚀 Opening Claude IDE...'));
    try {
      execSync('claude', { stdio: 'inherit' });
    } catch (error) {
      console.error(chalk.red('❌ Failed to open Claude IDE:'), error.message);
    }
  });

program
  .command('analyze')
  .description('🔍 Guide to run project analysis')
  .action(() => {
    if (!isProjectSetup()) {
      console.log(chalk.red('❌ Project not setup'));
      console.log(chalk.yellow('💡 Run: claudio init'));
      return;
    }

    console.log(chalk.cyan('🔍 Analysis is now integrated into Claude IDE'));
    console.log(chalk.white('\n📋 To analyze your project:'));
    console.log(chalk.green('  1. Open Claude Code: ' + chalk.bold('claude')));
    console.log(chalk.green('  2. Run quick analysis: ' + chalk.bold('/project:radar:quick')));
    console.log(chalk.green('  3. Run full analysis: ' + chalk.bold('/project:radar:analyze')));

    console.log(chalk.yellow('\n💡 This provides better integration and user experience'));
    console.log(chalk.gray('   Native slash commands work directly in Claude IDE'));
  });

program
  .command('help-commands')
  .description('📋 Show all available commands')
  .action(showCommands);

// Help override
program.configureHelp({
  afterAll: () => {
    return `
${chalk.cyan('🎯 Quick Start:')}
  ${chalk.white('claudio init')}             # Initialize project
  ${chalk.white('claude')}                   # Open Claude IDE
  ${chalk.white('/project:radar:analyze')}           # Run analysis

${chalk.cyan('💡 Need help?')}
  ${chalk.white('claudio help-commands')}    # Show all commands
  ${chalk.white('claudio status')}           # Check project status

${chalk.gray('🚀 Built for AI-powered development')}
`;
  }
});

program.parse();