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
const scriptPath = path.join(packageDir, 'claude-repo-analyzer.sh');

function checkPrerequisites() {
  const spinner = ora('Checking prerequisites...').start();

  try {
    // Check if we're in a Git repository
    execSync('git rev-parse --git-dir', { stdio: 'pipe' });

    // Check if Claude Code is available
    execSync('claude --version', { stdio: 'pipe' });

    spinner.succeed('Prerequisites verified ✅');
    return true;
  } catch (error) {
    spinner.fail('Prerequisites check failed ❌');

    if (error.message.includes('git rev-parse')) {
      console.log(chalk.red('❌ Not a Git repository. Please run from a Git repository root.'));
      console.log(chalk.yellow('💡 Initialize with: git init && git add . && git commit -m "Initial commit"'));
    }

    if (error.message.includes('claude')) {
      console.log(chalk.red('❌ Claude Code not found.'));
      console.log(chalk.yellow('💡 Install with: curl -sSL https://claude.ai/install | sh'));
    }

    return false;
  }
}

function runRadarCommand(command, repoPath = '.') {
  if (!checkPrerequisites()) {
    process.exit(1);
  }

  const spinner = ora(`Running R.A.D.A.R. ${command}...`).start();

  try {
    const result = execSync(`bash "${scriptPath}" ${command} "${repoPath}"`, {
      stdio: 'pipe',
      encoding: 'utf8',
      cwd: process.cwd()
    });

    spinner.succeed(`R.A.D.A.R. ${command} completed ✅`);
    console.log(result);

    // Show generated files
    if (fs.existsSync('./analysis')) {
      console.log(chalk.cyan('\n📄 Generated files:'));
      const files = execSync('find ./analysis -name "*.md" | sort', { encoding: 'utf8' }).split('\n').filter(Boolean);
      files.forEach(file => console.log(chalk.green(`  ✅ ${file}`)));
    }

  } catch (error) {
    spinner.fail(`R.A.D.A.R. ${command} failed ❌`);
    console.error(chalk.red(error.message));
    process.exit(1);
  }
}

program
  .name('claude-radar')
  .description('🔍 R.A.D.A.R. - Deep repository analysis for Claude Code')
  .version('1.0.0');

program
  .command('analyze [path]')
  .description('🎯 Full R.A.D.A.R. analysis (all 5 phases)')
  .action((repoPath) => {
    console.log(chalk.blue.bold('🔍 R.A.D.A.R. REPOSITORY ANALYZER'));
    console.log(chalk.gray('Reconocer → Analizar → Documentar → Arquitecturar → Reportar\n'));
    runRadarCommand('analyze', repoPath);
  });

program
  .command('discover [path]')
  .description('🔍 Phase 1: Recognize structure and purpose')
  .action((repoPath) => {
    console.log(chalk.blue.bold('🔍 R.A.D.A.R. Phase 1: RECONOCER'));
    runRadarCommand('discover', repoPath);
  });

program
  .command('examine [path]')
  .description('🧐 Phase 2: Analyze architecture and patterns')
  .action((repoPath) => {
    console.log(chalk.blue.bold('🧐 R.A.D.A.R. Phase 2: ANALIZAR'));
    runRadarCommand('examine', repoPath);
  });

program
  .command('document [path]')
  .description('📝 Phase 3: Generate comprehensive documentation')
  .action((repoPath) => {
    console.log(chalk.blue.bold('📝 R.A.D.A.R. Phase 3: DOCUMENTAR'));
    runRadarCommand('document', repoPath);
  });

program
  .command('guide [path]')
  .description('🏗️ Phase 4: Map components and dependencies')
  .action((repoPath) => {
    console.log(chalk.blue.bold('🏗️ R.A.D.A.R. Phase 4: ARQUITECTURAR'));
    runRadarCommand('guide', repoPath);
  });

program
  .command('report [path]')
  .description('📊 Phase 5: Executive summary and recommendations')
  .action((repoPath) => {
    console.log(chalk.blue.bold('📊 R.A.D.A.R. Phase 5: REPORTAR'));
    runRadarCommand('report', repoPath);
  });

program
  .command('quick')
  .description('⚡ Quick analysis (discover + report only)')
  .action(() => {
    console.log(chalk.yellow.bold('⚡ R.A.D.A.R. QUICK ANALYSIS'));
    runRadarCommand('discover');
    runRadarCommand('report');
  });

program.parse();