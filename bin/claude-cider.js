#!/usr/bin/env node

const { Command } = require('commander');
const chalk = require('chalk');
const ora = require('ora');
const { execSync } = require('child_process');
const path = require('path');

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
    runCommand(generatorScript, ['generate', epic, description]);
  });

program
  .command('work <issueNumber> <scope>')
  .description('⚡ Execute issue following C.I.D.E.R. protocol')
  .action((issueNumber, scope) => {
    console.log(chalk.blue.bold('⚡ C.I.D.E.R. WORKER'));
    console.log(chalk.gray(`Working on issue #${issueNumber} - ${scope}\n`));
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

program.parse();