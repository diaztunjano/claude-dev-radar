#!/usr/bin/env node

const { Command } = require('commander');
const chalk = require('chalk');
const ora = require('ora');
const inquirer = require('inquirer');
const path = require('path');
const fs = require('fs');
const { execSync } = require('child_process');

const program = new Command();

// Debug logging function
function debugLog(message, data = null) {
  if (process.env.CLAUDE_UPDATE_DEBUG === 'true') {
    console.log(chalk.gray(`[DEBUG] ${new Date().toISOString()} - ${message}`));
    if (data) console.log(chalk.gray(JSON.stringify(data, null, 2)));
  }
}

function getInstalledVersion() {
  try {
    const versionFile = '.claude/.version.json';
    if (fs.existsSync(versionFile)) {
      const data = JSON.parse(fs.readFileSync(versionFile, 'utf8'));
      return data.version || '0.0.0';
    }
    return '0.0.0'; // No version file means initial installation
  } catch (error) {
    debugLog('Error reading version file', { error: error.message });
    return '0.0.0';
  }
}

function saveInstalledVersion(version) {
  try {
    const versionFile = '.claude/.version.json';
    const data = {
      version: version,
      lastUpdated: new Date().toISOString(),
      templates: getTemplateManifest()
    };
    fs.writeFileSync(versionFile, JSON.stringify(data, null, 2));
  } catch (error) {
    debugLog('Error saving version file', { error: error.message });
  }
}

function getTemplateManifest() {
  const templates = [];
  const packageDir = path.dirname(path.dirname(__filename));
  const templatesDir = path.join(packageDir, 'templates', 'commands');
  
  function scanDir(dir, basePath = '') {
    if (!fs.existsSync(dir)) return;
    
    const files = fs.readdirSync(dir);
    files.forEach(file => {
      const fullPath = path.join(dir, file);
      const relativePath = path.join(basePath, file);
      
      if (fs.statSync(fullPath).isDirectory()) {
        scanDir(fullPath, relativePath);
      } else if (file.endsWith('.template.md')) {
        templates.push({
          path: relativePath,
          name: file.replace('.template.md', ''),
          modified: fs.statSync(fullPath).mtime
        });
      }
    });
  }
  
  scanDir(templatesDir);
  return templates;
}

function checkForUpdates() {
  const currentVersion = getInstalledVersion();
  const packageJson = JSON.parse(fs.readFileSync(path.join(path.dirname(path.dirname(__filename)), 'package.json'), 'utf8'));
  const latestVersion = packageJson.version;
  
  debugLog('Version check', { current: currentVersion, latest: latestVersion });
  
  return {
    hasUpdate: currentVersion !== latestVersion,
    currentVersion,
    latestVersion
  };
}

function getAvailableUpdates() {
  const updates = {
    newCommands: [],
    updatedCommands: [],
    newGuides: [],
    updatedGuides: [],
    newTemplates: [],
    updatedTemplates: []
  };
  
  const packageDir = path.dirname(path.dirname(__filename));
  
  // Check slash commands
  const commandsDir = path.join(packageDir, 'templates', 'commands');
  const localCommandsDir = '.claude/commands';
  
  function compareCommands(sourceDir, targetDir, basePath = '') {
    if (!fs.existsSync(sourceDir)) return;
    
    const files = fs.readdirSync(sourceDir);
    files.forEach(file => {
      const sourcePath = path.join(sourceDir, file);
      const targetPath = path.join(targetDir, basePath, file.replace('.template.md', '.md'));
      const relativePath = path.join(basePath, file);
      
      if (fs.statSync(sourcePath).isDirectory()) {
        compareCommands(sourcePath, targetDir, path.join(basePath, file));
      } else if (file.endsWith('.template.md')) {
        if (!fs.existsSync(targetPath)) {
          updates.newCommands.push({
            name: file.replace('.template.md', ''),
            path: relativePath,
            targetPath: targetPath
          });
        } else {
          // Check if content is different (simple check - could be improved)
          const sourceContent = fs.readFileSync(sourcePath, 'utf8');
          const targetContent = fs.readFileSync(targetPath, 'utf8');
          if (sourceContent !== targetContent) {
            updates.updatedCommands.push({
              name: file.replace('.template.md', ''),
              path: relativePath,
              targetPath: targetPath
            });
          }
        }
      }
    });
  }
  
  compareCommands(commandsDir, localCommandsDir);
  
  // Check guides - for now just check if they exist
  const guidesSource = path.join(packageDir, 'templates', 'guides');
  const guidesTarget = '.claude/guides';
  
  if (fs.existsSync(guidesSource)) {
    fs.readdirSync(guidesSource).forEach(file => {
      const targetPath = path.join(guidesTarget, file);
      if (!fs.existsSync(targetPath)) {
        updates.newGuides.push({ name: file, path: file });
      }
    });
  }
  
  return updates;
}

function backupFile(filePath) {
  if (fs.existsSync(filePath)) {
    const backupPath = `${filePath}.backup.${Date.now()}`;
    fs.copyFileSync(filePath, backupPath);
    return backupPath;
  }
  return null;
}

async function performUpdate(updates, options = {}) {
  const spinner = ora('Updating Claude templates...').start();
  const results = {
    success: [],
    failed: [],
    skipped: []
  };
  
  try {
    const packageDir = path.dirname(path.dirname(__filename));
    
    // Update commands
    if (options.updateCommands !== false) {
      // New commands
      for (const command of updates.newCommands) {
        try {
          const sourcePath = path.join(packageDir, 'templates', 'commands', command.path);
          const content = fs.readFileSync(sourcePath, 'utf8');
          
          // Ensure directory exists
          const targetDir = path.dirname(command.targetPath);
          if (!fs.existsSync(targetDir)) {
            fs.mkdirSync(targetDir, { recursive: true });
          }
          
          // Apply template replacements
          const processedContent = applyTemplateReplacements(content);
          fs.writeFileSync(command.targetPath, processedContent);
          
          results.success.push(`✅ Added new command: /${command.name}`);
        } catch (error) {
          results.failed.push(`❌ Failed to add command /${command.name}: ${error.message}`);
        }
      }
      
      // Updated commands (only if user wants to overwrite)
      if (options.overwriteExisting) {
        for (const command of updates.updatedCommands) {
          try {
            // Backup existing file
            const backupPath = backupFile(command.targetPath);
            if (backupPath) {
              debugLog(`Backed up ${command.targetPath} to ${backupPath}`);
            }
            
            const sourcePath = path.join(packageDir, 'templates', 'commands', command.path);
            const content = fs.readFileSync(sourcePath, 'utf8');
            const processedContent = applyTemplateReplacements(content);
            fs.writeFileSync(command.targetPath, processedContent);
            
            results.success.push(`✅ Updated command: /${command.name}`);
          } catch (error) {
            results.failed.push(`❌ Failed to update command /${command.name}: ${error.message}`);
          }
        }
      } else {
        updates.updatedCommands.forEach(command => {
          results.skipped.push(`⏭️  Skipped existing command: /${command.name}`);
        });
      }
    }
    
    // Update guides
    if (options.updateGuides !== false) {
      for (const guide of updates.newGuides) {
        try {
          const sourcePath = path.join(packageDir, 'templates', 'guides', guide.path);
          const targetPath = path.join('.claude/guides', guide.path);
          
          if (fs.existsSync(sourcePath)) {
            fs.copyFileSync(sourcePath, targetPath);
            results.success.push(`✅ Added new guide: ${guide.name}`);
          }
        } catch (error) {
          results.failed.push(`❌ Failed to add guide ${guide.name}: ${error.message}`);
        }
      }
    }
    
    // Save updated version
    const packageJson = JSON.parse(fs.readFileSync(path.join(packageDir, 'package.json'), 'utf8'));
    saveInstalledVersion(packageJson.version);
    
    spinner.succeed('Update completed!');
    
    // Show results
    console.log(chalk.cyan('\n📊 Update Results:'));
    results.success.forEach(msg => console.log(chalk.green(msg)));
    results.skipped.forEach(msg => console.log(chalk.yellow(msg)));
    results.failed.forEach(msg => console.log(chalk.red(msg)));
    
    if (results.success.length > 0) {
      console.log(chalk.green(`\n✨ Successfully updated ${results.success.length} items!`));
    }
    
    return results;
    
  } catch (error) {
    spinner.fail('Update failed!');
    console.error(chalk.red(error.message));
    return results;
  }
}

function applyTemplateReplacements(content) {
  const projectName = path.basename(process.cwd());
  const packageJson = fs.existsSync('./package.json') ? JSON.parse(fs.readFileSync('./package.json', 'utf8')) : {};
  
  return content
    .replace(/\{\{PROJECT_NAME\}\}/g, projectName)
    .replace(/\{\{FRAMEWORK\}\}/g, detectFramework(packageJson) || 'Unknown')
    .replace(/\{\{VERSION\}\}/g, packageJson.version || '1.0.0')
    .replace(/\{\{PACKAGE_MANAGER\}\}/g, fs.existsSync('./package-lock.json') ? 'npm' : fs.existsSync('./yarn.lock') ? 'yarn' : 'npm');
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

async function interactiveUpdate() {
  console.log(chalk.blue.bold('🔄 CLAUDE UPDATE'));
  console.log(chalk.gray('Checking for available updates...\n'));
  
  // Check if .claude exists
  if (!fs.existsSync('.claude')) {
    console.log(chalk.red('❌ No .claude directory found!'));
    console.log(chalk.yellow('💡 Run "claudio init" first to set up your project'));
    return;
  }
  
  // Check for updates
  const versionInfo = checkForUpdates();
  const updates = getAvailableUpdates();
  
  console.log(chalk.cyan('📦 Version Information:'));
  console.log(`  Current: ${versionInfo.currentVersion}`);
  console.log(`  Latest:  ${versionInfo.latestVersion}`);
  
  // Count total updates
  const totalUpdates = 
    updates.newCommands.length + 
    updates.updatedCommands.length + 
    updates.newGuides.length +
    updates.updatedGuides.length;
  
  if (totalUpdates === 0) {
    console.log(chalk.green('\n✅ Everything is up to date!'));
    return;
  }
  
  // Show available updates
  console.log(chalk.cyan('\n📋 Available Updates:'));
  
  if (updates.newCommands.length > 0) {
    console.log(chalk.green(`\n✨ New Commands (${updates.newCommands.length}):`));
    updates.newCommands.forEach(cmd => {
      console.log(`  - /${cmd.name}`);
    });
  }
  
  if (updates.updatedCommands.length > 0) {
    console.log(chalk.yellow(`\n🔄 Updated Commands (${updates.updatedCommands.length}):`));
    updates.updatedCommands.forEach(cmd => {
      console.log(`  - /${cmd.name}`);
    });
  }
  
  if (updates.newGuides.length > 0) {
    console.log(chalk.green(`\n📚 New Guides (${updates.newGuides.length}):`));
    updates.newGuides.forEach(guide => {
      console.log(`  - ${guide.name}`);
    });
  }
  
  // Ask user what to do
  const answers = await inquirer.prompt([
    {
      type: 'confirm',
      name: 'proceed',
      message: 'Do you want to proceed with the update?',
      default: true
    },
    {
      type: 'checkbox',
      name: 'updateTypes',
      message: 'What would you like to update?',
      choices: [
        { name: 'New commands', value: 'newCommands', checked: true },
        { name: 'Updated commands (will backup existing)', value: 'updatedCommands', checked: false },
        { name: 'New guides', value: 'newGuides', checked: true }
      ],
      when: (answers) => answers.proceed
    },
    {
      type: 'confirm',
      name: 'createBackup',
      message: 'Create backup of existing files before updating?',
      default: true,
      when: (answers) => answers.proceed && answers.updateTypes.includes('updatedCommands')
    }
  ]);
  
  if (!answers.proceed) {
    console.log(chalk.yellow('\n⏭️  Update cancelled'));
    return;
  }
  
  // Perform update
  const updateOptions = {
    updateCommands: answers.updateTypes.includes('newCommands') || answers.updateTypes.includes('updatedCommands'),
    overwriteExisting: answers.updateTypes.includes('updatedCommands'),
    updateGuides: answers.updateTypes.includes('newGuides'),
    createBackup: answers.createBackup
  };
  
  await performUpdate(updates, updateOptions);
}

async function forceUpdate() {
  console.log(chalk.yellow.bold('⚠️  FORCE UPDATE'));
  console.log(chalk.red('This will overwrite all existing templates!\n'));
  
  const answers = await inquirer.prompt([
    {
      type: 'confirm',
      name: 'confirm',
      message: 'Are you sure you want to force update all templates?',
      default: false
    },
    {
      type: 'input',
      name: 'confirmText',
      message: 'Type "UPDATE" to confirm:',
      when: (answers) => answers.confirm,
      validate: (input) => input === 'UPDATE' || 'Please type UPDATE to confirm'
    }
  ]);
  
  if (!answers.confirm || answers.confirmText !== 'UPDATE') {
    console.log(chalk.yellow('\n⏭️  Force update cancelled'));
    return;
  }
  
  const updates = getAvailableUpdates();
  await performUpdate(updates, {
    updateCommands: true,
    overwriteExisting: true,
    updateGuides: true,
    createBackup: true
  });
}

// CLI setup
program
  .name('claude-update')
  .description('🔄 Update Claude templates and commands')
  .version('1.0.0');

program
  .action(interactiveUpdate);

program
  .command('check')
  .description('🔍 Check for available updates without installing')
  .action(() => {
    console.log(chalk.blue.bold('🔍 UPDATE CHECK'));
    
    const versionInfo = checkForUpdates();
    const updates = getAvailableUpdates();
    
    console.log(chalk.cyan('\n📦 Version Information:'));
    console.log(`  Current: ${versionInfo.currentVersion}`);
    console.log(`  Latest:  ${versionInfo.latestVersion}`);
    
    const totalUpdates = 
      updates.newCommands.length + 
      updates.updatedCommands.length + 
      updates.newGuides.length;
    
    if (totalUpdates === 0) {
      console.log(chalk.green('\n✅ Everything is up to date!'));
    } else {
      console.log(chalk.yellow(`\n📋 ${totalUpdates} updates available`));
      console.log(chalk.gray('\nRun "claudio update" to install updates'));
    }
  });

program
  .command('force')
  .description('⚠️  Force update all templates (overwrites existing files)')
  .action(forceUpdate);

program.parse();