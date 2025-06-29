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
const scriptPath = path.join(packageDir, '.sh');

// Debug logging function
function debugLog(message, data = null) {
  if (process.env.CLAUDE_RADAR_DEBUG === 'true') {
    console.log(chalk.gray(`[DEBUG] ${new Date().toISOString()} - ${message}`));
    if (data) console.log(chalk.gray(JSON.stringify(data, null, 2)));
  }
}

function checkPrerequisites() {
  debugLog('Starting prerequisites check');
  const spinner = ora('Checking prerequisites...').start();

  try {
    // Check if we're in a Git repository
    debugLog('Checking Git repository');
    execSync('git rev-parse --git-dir', { stdio: 'pipe' });
    debugLog('Git repository check passed');

    // Check if Claude Code is available
    debugLog('Checking Claude Code availability');
    execSync('claude --version', { stdio: 'pipe' });
    debugLog('Claude Code check passed');

    // Validate script path exists
    debugLog('Checking script path', { scriptPath });
    if (!fs.existsSync(scriptPath)) {
      throw new Error(`RADAR script not found at: ${scriptPath}`);
    }
    debugLog('Script path validation passed');

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
  debugLog('Starting RADAR command', { command, repoPath });
  
  if (!checkPrerequisites()) {
    process.exit(1);
  }

  const spinner = ora(`Running R.A.D.A.R. ${command}...`).start();
  let progressInterval;
  
  // Show progress updates every 10 seconds
  let elapsed = 0;
  progressInterval = setInterval(() => {
    elapsed += 10;
    spinner.text = `Running R.A.D.A.R. ${command}... (${elapsed}s elapsed)`;
    debugLog(`Progress update: ${elapsed}s elapsed for ${command}`);
  }, 10000);

  try {
    const fullCommand = `bash "${scriptPath}" ${command} "${repoPath}"`;
    debugLog('Executing command', { fullCommand, cwd: process.cwd() });
    
    const result = execSync(fullCommand, {
      stdio: 'pipe',
      encoding: 'utf8',
      cwd: process.cwd(),
      timeout: 900000 // 15 minutes timeout
    });
    
    clearInterval(progressInterval);
    debugLog('Command completed successfully', { outputLength: result.length });

    spinner.succeed(`R.A.D.A.R. ${command} completed ✅`);
    console.log(result);

    // Show generated files
    if (fs.existsSync('./analysis')) {
      console.log(chalk.cyan('\n📄 Generated files:'));
      const files = execSync('find ./analysis -name "*.md" | sort', { encoding: 'utf8' }).split('\n').filter(Boolean);
      files.forEach(file => console.log(chalk.green(`  ✅ ${file}`)));
    }

  } catch (error) {
    clearInterval(progressInterval);
    spinner.fail(`R.A.D.A.R. ${command} failed ❌`);
    
    debugLog('Command failed', { 
      error: error.message, 
      code: error.status,
      signal: error.signal,
      stdout: error.stdout,
      stderr: error.stderr
    });
    
    // Provide helpful error messages
    if (error.signal === 'SIGTERM' || error.code === null) {
      console.error(chalk.red('❌ Command timed out after 15 minutes'));
      console.error(chalk.yellow('💡 Try running individual phases: claude-radar discover, claude-radar examine, etc.'));
    } else if (error.message.includes('ENOENT')) {
      console.error(chalk.red('❌ Script file not found'));
      console.error(chalk.yellow(`💡 Expected script at: ${scriptPath}`));
    } else {
      console.error(chalk.red(`❌ ${error.message}`));
      if (error.stderr) {
        console.error(chalk.red('Standard Error:'));
        console.error(error.stderr);
      }
    }
    
    console.log(chalk.gray('\n🐛 For debugging, run with: CLAUDE_RADAR_DEBUG=true claude-radar ' + command));
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