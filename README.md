# 🤖 Claudio - AI-Powered Development Assistant

**Setup once, develop with AI everywhere.**

Claudio transforms any repository into an AI-powered development environment with **R.A.D.A.R. analysis** and **C.I.D.E.R. atomic issues** for Claude IDE.

## 🚀 Quick Start

```bash
# 1. Install globally
npm i -g claudio

# 2. Setup in any project
cd your-project
claudio init

# 3. Start developing with AI
claude
# Then use: /radar:analyze, /cider:generate, /cider:work
```

## ✨ What You Get

### 🎯 **Smart Project Setup**
- **One command setup**: `claudio init` configures everything
- **Smart detection**: Automatically detects your tech stack
- **Claude IDE integration**: Native slash commands ready to use

### 🔍 **R.A.D.A.R. Analysis**
- **R**econocimiento: Codebase structure and architecture
- **A**nálisis: Code quality, patterns, dependencies
- **D**ocumentación: Missing docs, outdated content
- **A**rquitectura: Design decisions and improvements
- **R**ecomendaciones: Actionable improvement suggestions

### 🎯 **C.I.D.E.R. Atomic Issues**
- **C**ontextualizar: Understand current project state
- **I**terar: Plan approach and break into tasks
- **D**ocumentar: Create specifications and requirements
- **E**jecutar: Define implementation steps
- **R**eflexionar: Plan testing and validation

## 📋 Usage

### **Setup (One Time)**
```bash
npm i -g claudio
cd your-project
claudio init                 # Creates .claude/ structure + slash commands
```

### **Daily Development**
```bash
claudio status              # Check project status
claude                      # Open Claude IDE

# Inside Claude IDE:
/radar:analyze              # Complete project analysis
/radar:quick               # Quick project overview
/cider:generate EPIC-API "implement auth"  # Generate atomic issues
/cider:work 123            # Work on specific issue
/cider:status              # Project status overview
/cider:list-epics          # Show available epics
```

### **Quick Commands**
```bash
claudio                    # Show status + next steps
claudio open              # Open Claude IDE
claudio analyze           # Quick analysis without Claude IDE
claudio check             # Verify configuration
```

## 🏗️ Project Structure Created

```
your-project/
├── .claude/
│   ├── commands/          # Native slash commands
│   │   ├── radar/         # Analysis commands
│   │   └── cider/         # Issue management commands
│   ├── current/           # Active project state
│   │   ├── project-state.md
│   │   ├── active-epic.md
│   │   └── next-session.md
│   ├── epics/             # Epic management
│   │   └── epics-roadmap.md
│   ├── sessions/          # Session history
│   ├── guides/            # Development methodology
│   └── templates/         # Reusable templates
└── analysis/              # Generated analysis reports
```

## 🎯 Workflow

### **1. Project Initialization**
```bash
claudio init
# ✅ Creates .claude/ structure
# ✅ Detects tech stack
# ✅ Creates suggested epics
# ✅ Sets up development methodology
```

### **2. Analysis & Understanding**
```bash
claude                     # Open Claude IDE
/radar:analyze            # Complete analysis
# ✅ Architecture analysis
# ✅ Code quality assessment
# ✅ Improvement recommendations
# ✅ Epic suggestions
```

### **3. Issue Generation**
```bash
/cider:generate EPIC-FRONTEND "implement responsive design"
# ✅ Creates atomic issue (2-6 hours)
# ✅ Defines acceptance criteria
# ✅ Plans implementation approach
# ✅ Sets up C.I.D.E.R. workflow
```

### **4. Development Execution**
```bash
/cider:work 123
# ✅ Loads issue context
# ✅ Plans work approach
# ✅ Tracks progress
# ✅ Updates project state
```

## 🔧 Available Slash Commands

| Command | Description |
|---------|-------------|
| `/radar:analyze` | Complete project analysis with recommendations |
| `/radar:quick` | Quick project overview and status |
| `/cider:generate EPIC "desc"` | Generate atomic development issue |
| `/cider:work ISSUE_NUMBER` | Work on specific issue with guidance |
| `/cider:status` | Show project and epic status |
| `/cider:list-epics` | List all available epics |

## 🎨 Example Epic Types

Claudio automatically suggests epics based on your tech stack:

- **EPIC-FRONTEND**: User interface development
- **EPIC-BACKEND**: Server-side development
- **EPIC-DATABASE**: Data management
- **EPIC-API**: API development
- **EPIC-TESTING**: Quality assurance
- **EPIC-DEPLOYMENT**: DevOps & infrastructure
- **EPIC-PERFORMANCE**: Optimization
- **EPIC-SECURITY**: Security implementation
- **EPIC-DOCS**: Documentation

## 🔍 Example Analysis Output

```bash
/radar:analyze
```

Generates comprehensive reports:

- **Executive Summary**: Key findings and priorities
- **Architecture Analysis**: Structure and design patterns
- **Code Quality**: Issues and improvements
- **Dependency Analysis**: Package management and updates
- **Documentation Review**: Missing or outdated docs
- **Security Assessment**: Potential vulnerabilities
- **Performance Analysis**: Optimization opportunities

## 🎯 Atomic Issue Example

```bash
/cider:generate EPIC-API "implement user authentication"
```

Creates issue with:

- ✅ **Clear objectives** and acceptance criteria
- ✅ **Task breakdown** (2-6 hour target)
- ✅ **Implementation approach** and technical requirements
- ✅ **Testing strategy** and validation steps
- ✅ **Files to modify** and integration points
- ✅ **C.I.D.E.R. workflow** tracking

## 🚀 Benefits

### **For Individual Developers**
- ✅ **Instant project understanding** with R.A.D.A.R. analysis
- ✅ **Structured development** with C.I.D.E.R. methodology
- ✅ **Clear work breakdown** into atomic issues
- ✅ **Progress tracking** and session management

### **For Teams**
- ✅ **Consistent methodology** across projects
- ✅ **Knowledge sharing** through documentation
- ✅ **Quality standards** with built-in best practices
- ✅ **Project visibility** with status tracking

### **For Freelancers/Consultants**
- ✅ **Quick client onboarding** with instant analysis
- ✅ **Professional reporting** with detailed insights
- ✅ **Structured proposals** based on epic breakdown
- ✅ **Progress transparency** for clients

## 🛠️ Requirements

- **Node.js** 14+
- **Claude IDE** ([Download here](https://claude.ai/download))
- **Git** (recommended)

## 📦 Installation

### Global Installation (Recommended)
```bash
npm i -g claudio
```

### Local Installation
```bash
cd your-project
npm i claudio
npx claudio init
```

## 🆘 Support

Having issues? Check common solutions:

### **"claude command not found"**
Install Claude IDE: https://claude.ai/download

### **"Project not setup"**
```bash
claudio init
```

### **"No slash commands available"**
```bash
claudio check          # Verify setup
claudio init           # Re-initialize if needed
```

### **Debug Mode**
```bash
CLAUDIO_DEBUG=true claudio init
```

## 🎯 Perfect For

- ✅ **New project onboarding** - Understand any codebase instantly
- ✅ **Legacy code analysis** - Get insights into old projects
- ✅ **Freelance work** - Professional analysis and structured development
- ✅ **Team collaboration** - Consistent methodology and documentation
- ✅ **Code reviews** - Structured analysis and improvement suggestions
- ✅ **Technical debt** - Identify and plan improvements systematically

## 🤝 Contributing

This project is designed to work seamlessly with Claude IDE and AI-powered development workflows.

## 📄 License

MIT - Build amazing things with AI assistance!

---

**🤖 Claudio - Making every developer an AI-powered expert**
