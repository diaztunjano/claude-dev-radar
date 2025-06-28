#!/usr/bin/env bash

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Helper functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_epic() {
    echo -e "${PURPLE}[EPIC]${NC} $1"
}

log_generate() {
    echo -e "${CYAN}[GENERATE]${NC} $1"
}

# Display usage
show_usage() {
    echo "🎯 CLAUDE DEV RADAR - GitHub Issue Generator"
    echo "============================================="
    echo ""
    echo "Creates atomic issues directly in GitHub following development best practices"
    echo ""
    echo "Usage: $0 <command> [options]"
    echo ""
    echo "COMMANDS:"
    echo "  analyze <requirement>     - Analyze requirement and suggest epic structure"
    echo "  generate <epic> <feature> - Generate & create atomic issue in GitHub"
    echo "  validate <input>          - Validate GitHub issue or local file"
    echo "  list-epics               - Show available epics and their modules"
    echo "  template                 - Generate empty issue template (local file)"
    echo ""
    echo "REQUIREMENTS:"
    echo "  📋 Claude Code installed and authenticated"
    echo "  🐙 GitHub CLI (gh) installed and authenticated: gh auth login"
    echo "  📁 Run from any git repository root directory"
    echo ""
    echo "GENERATE OPTIONS:"
    echo "  epic: EPIC-FRONTEND, EPIC-BACKEND, EPIC-API, EPIC-DATABASE,"
    echo "        EPIC-TESTING, EPIC-DOCS, EPIC-DEPLOYMENT, EPIC-PERFORMANCE, EPIC-SECURITY"
    echo "  feature: Brief description of the feature"
    echo ""
    echo "VALIDATE OPTIONS:"
    echo "  input: GitHub issue number (e.g., 123) or local file path"
    echo ""
    echo "EXAMPLES:"
    echo "  $0 analyze \"Implement user authentication system\""
    echo "  $0 generate EPIC-FRONTEND \"responsive navigation component\""
    echo "  $0 validate 123  # Validates GitHub issue #123"
    echo "  $0 validate docs/features/new-feature.md"
    echo "  $0 list-epics"
    echo ""
    echo "WORKFLOW:"
    echo "  1. 🎯 Generate issue: $0 generate EPIC-X \"feature\""
    echo "  2. 🔧 Execute issue: ./claude-issue-worker.sh [issue#] [area]"
    echo "  3. ✅ Validate work: $0 validate [issue#]"
    echo ""
}

# Check if Claude Code is available
check_claude_availability() {
    if ! command -v claude &> /dev/null; then
        log_error "Claude Code not found. Please install Claude Code first."
        log_info "Install with: curl -sSL https://claude.ai/install | sh"
        exit 1
    fi
}

# Check if GitHub CLI is available and authenticated
check_github_cli() {
    if ! command -v gh &> /dev/null; then
        log_error "GitHub CLI not found. Please install gh first."
        log_info "Install with: brew install gh (macOS) or visit https://cli.github.com/"
        exit 1
    fi

    if ! gh auth status &> /dev/null; then
        log_error "GitHub CLI not authenticated. Please login first."
        log_info "Run: gh auth login"
        exit 1
    fi

    log_success "GitHub CLI authenticated and ready"
}

# Validate we're in a git repository with .claude/ structure
check_project_structure() {
    if [[ ! -d ".git" ]]; then
        log_error "Please run this script from a git repository root directory"
        log_info "Initialize with: git init"
        exit 1
    fi
    
    if [[ ! -d ".claude" ]]; then
        log_error "No .claude/ structure found. Please initialize first."
        log_info "Run: claude-setup init"
        exit 1
    fi
    
    # Check essential .claude/ files
    if [[ ! -f ".claude/current/project-state.md" ]] || [[ ! -f ".claude/epics/epics-roadmap.md" ]]; then
        log_warning ".claude/ structure incomplete, but proceeding..."
    fi
}

# Read project context from .claude/ files
read_claude_context() {
    local project_state=""
    local active_epic=""
    local epics_roadmap=""
    
    if [[ -f ".claude/current/project-state.md" ]]; then
        project_state=$(cat ".claude/current/project-state.md")
    fi
    
    if [[ -f ".claude/current/active-epic.md" ]]; then
        active_epic=$(cat ".claude/current/active-epic.md")
    fi
    
    if [[ -f ".claude/epics/epics-roadmap.md" ]]; then
        epics_roadmap=$(cat ".claude/epics/epics-roadmap.md")
    fi
    
    # Export for use in Claude prompts
    export CLAUDE_PROJECT_STATE="$project_state"
    export CLAUDE_ACTIVE_EPIC="$active_epic"  
    export CLAUDE_EPICS_ROADMAP="$epics_roadmap"
}

# List available epics from .claude/epics-roadmap.md if available, otherwise show defaults
list_epics() {
    if [[ -f ".claude/epics/epics-roadmap.md" ]]; then
        log_epic "PROJECT EPICS (from .claude/epics/epics-roadmap.md)"
        echo ""
        
        # Extract epics from roadmap file
        grep -E "^\*\*EPIC-.*\*\*" ".claude/epics/epics-roadmap.md" | head -10 || {
            log_warning "Could not read epics from roadmap file, showing defaults"
            show_default_epics
        }
    else
        show_default_epics
    fi
}

# Show default epic structure
show_default_epics() {
    log_epic "AVAILABLE EPICS FOR SOFTWARE DEVELOPMENT"
    echo ""
    echo "🎯 EPIC-FRONTEND - User Interface Development"
    echo "   └── Components, Layouts, Styles, Interactions"
    echo ""
    echo "🔧 EPIC-BACKEND - Server-side Development"
    echo "   └── APIs, Services, Business Logic, Architecture"
    echo ""
    echo "🗄️ EPIC-DATABASE - Data Management"
    echo "   └── Schema, Migrations, Queries, Optimization"
    echo ""
    echo "🔗 EPIC-API - API Development"
    echo "   └── Endpoints, Documentation, Versioning, Integration"
    echo ""
    echo "🧪 EPIC-TESTING - Quality Assurance"
    echo "   └── Unit Tests, Integration Tests, E2E, Coverage"
    echo ""
    echo "🚀 EPIC-DEPLOYMENT - DevOps & Infrastructure"
    echo "   └── CI/CD, Containerization, Monitoring, Scaling"
    echo ""
    echo "📊 EPIC-PERFORMANCE - Optimization"
    echo "   └── Speed, Memory, Bundle Size, Caching"
    echo ""
    echo "🔒 EPIC-SECURITY - Security Implementation"
    echo "   └── Authentication, Authorization, Encryption, Auditing"
    echo ""
    echo "📚 EPIC-DOCS - Documentation"
    echo "   └── Code docs, User guides, API docs, Architecture"
}

# Analyze requirement and suggest structure
analyze_requirement() {
    local requirement="$1"

    log_info "Analyzing requirement for issue structure..."
    
    # Read current .claude/ context
    read_claude_context

    claude "MODO: REQUIREMENT ANALYSIS WITH CLAUDE CONTEXT

Analyze this requirement and propose an issue structure:

REQUIREMENT: $requirement

## CURRENT PROJECT CONTEXT
Read the current project state from .claude/ files:

### PROJECT STATE:
$CLAUDE_PROJECT_STATE

### ACTIVE EPIC:
$CLAUDE_ACTIVE_EPIC

### EPICS ROADMAP:
$CLAUDE_EPICS_ROADMAP

## DEVELOPMENT PROTOCOL: C.I.D.E.R.
- **C**ontextualize: Understand current state and requirements
- **I**terate: Plan and break down into manageable tasks  
- **D**ocument: Record decisions and progress
- **E**xecute: Implement with testing and validation
- **R**eflect: Review outcomes and plan next steps

## ANALYSIS TASKS:
1. 🎯 Identify primary EPIC (and secondary if applicable)
2. 📋 Break down into atomic issues (each independent)
3. 🔗 Establish dependencies between issues
4. ⏱️ Estimate complexity: SIMPLE(15min-2h) | MEDIUM(2h-6h) | COMPLEX(6h-24h)
5. 📅 Propose logical development order
6. ⚠️ Identify potential risks or blockers
7. 🏗️ Suggest if prior research or proof-of-concept needed

## EXPECTED OUTPUT FORMAT:
### PRIMARY EPIC: [name]
### SUGGESTED ATOMIC ISSUES:
1. [TYPE]-(date)-[name] - COMPLEXITY: [level] - AREA: [area]
   Description: [what it specifically does]
   Dependencies: [related issues]

2. [continue...]

### DEVELOPMENT ORDER:
1. Issue #1 (prerequisite)
2. Issue #2 (can run in parallel)
...

### IDENTIFIED RISKS:
- [risk 1]: [suggested mitigation]
- [risk 2]: [suggested mitigation]

### RECOMMENDATIONS:
- Based on current project state
- Considering active epic context
- Aligned with existing epics roadmap

Be specific and practical. Each issue should be independently implementable." \
        --allowedTools "Read" "Write" \
        "Bash(gh:*)" "Bash(rg:*)" "Bash(find:*)" "Bash(ls:*)" "Bash(grep:*)" \
        "Bash(npm:*)" "Bash(git:*)" "Bash(cd:*)" "Bash(npx:*)"

    log_success "Analysis completed. Review the proposal and generate specific issues."
}

# Generate atomic issue and create it in GitHub via Claude Code
generate_issue() {
    local epic="$1"
    local feature="$2"

    log_generate "Generating atomic issue for $epic: $feature"
    
    # Read current .claude/ context
    read_claude_context

    # Validate epic
    case $epic in
        EPIC-FRONTEND|EPIC-BACKEND|EPIC-DATABASE|EPIC-API|EPIC-TESTING|EPIC-DEPLOYMENT|EPIC-PERFORMANCE|EPIC-SECURITY|EPIC-DOCS)
            ;;
        *)
            log_error "Invalid epic: $epic"
            log_info "Use: list-epics to see available epics"
            exit 1
            ;;
    esac

    # Map epic to GitHub label
    local epic_label
    case $epic in
        EPIC-FRONTEND) epic_label="epic:frontend" ;;
        EPIC-BACKEND) epic_label="epic:backend" ;;
        EPIC-DATABASE) epic_label="epic:database" ;;
        EPIC-API) epic_label="epic:api" ;;
        EPIC-TESTING) epic_label="epic:testing" ;;
        EPIC-DEPLOYMENT) epic_label="epic:deployment" ;;
        EPIC-PERFORMANCE) epic_label="epic:performance" ;;
        EPIC-SECURITY) epic_label="epic:security" ;;
        EPIC-DOCS) epic_label="epic:docs" ;;
    esac

    # Determine suggested area automatically
    local suggested_area="frontend"
    if echo "$feature" | grep -qi "server\|api\|service\|controller"; then
        suggested_area="backend"
    elif echo "$feature" | grep -qi "database\|migration\|schema\|query"; then
        suggested_area="database"
    elif echo "$feature" | grep -qi "test\|spec\|coverage\|unit\|integration"; then
        suggested_area="testing"
    elif echo "$feature" | grep -qi "deploy\|ci\|cd\|docker\|kubernetes"; then
        suggested_area="deployment"
    elif echo "$feature" | grep -qi "doc\|readme\|guide\|manual"; then
        suggested_area="docs"
    fi

    # Generate date for title
    local date=$(date +%d-%m-%Y)
    local title="[FEAT]-($date)-[...]"

    log_info "Executing Claude Code to generate and create issue..."
    log_info "Suggested title: $title"
    log_info "Suggested labels: $epic_label"
    log_info "Suggested area: $suggested_area"

    # Execute Claude Code with direct GitHub issue creation
    claude "MODE: CLAUDE ISSUE GENERATOR + GITHUB CREATION

## ISSUE CONFIGURATION
EPIC: $epic
FUNCTIONALITY: $feature
SUGGESTED TITLE: $title
SUGGESTED LABELS: $epic_label
SUGGESTED AREA: $suggested_area

## CURRENT PROJECT CONTEXT
Use the current project state from .claude/ files:

### PROJECT STATE:
$CLAUDE_PROJECT_STATE

### ACTIVE EPIC:
$CLAUDE_ACTIVE_EPIC

### EPICS ROADMAP:
$CLAUDE_EPICS_ROADMAP

## YOUR COMPLETE TASK:
1. 📖 Read project context from the above .claude/ files content
2. 📝 Generate complete issue content following C.I.D.E.R. protocol:

## 🎯 **PARENT EPIC**: $epic
## 🔧 **WORK AREA**: $suggested_area (adjust based on analysis)
## ⏱️ **COMPLEXITY**: [SIMPLE|MEDIUM|COMPLEX] - [15min-2h|2h-6h|6h-24h]

---

## 📋 **CONTEXTUALIZATION (C.I.D.E.R.)**

### **🎯 Issue Objective**
[Clear and specific description of what will be implemented]

### **🔗 Dependencies**
- **Critical files**: [List of files to be modified]
- **Related issues**: [If applicable]
- **Epic dependencies**: [Based on current active epic]

### **📊 Business Context**
- **User value**: [How it impacts user experience]
- **Use cases**: [Specific scenarios where it's used]

---

## 🔄 **ITERATION AND PLANNING (C.I.D.E.R.)**

### **📋 Impact Analysis**
- [ ] **Frontend**: [Components to be modified/created]
- [ ] **Backend**: [Services/APIs to be modified]
- [ ] **Database**: [Schema/queries to be modified]
- [ ] **Documentation**: [.claude/ files to be updated]

### **🎯 Definition of \"Done\"**
- [ ] **Functionality**: [Specific functionality criteria]
- [ ] **Testing**: [What should be tested and how]
- [ ] **Documentation**: [Which documents should be updated]
- [ ] **Build**: [Successful build + type-check]

---

## ⚡ **TECHNICAL EXECUTION (C.I.D.E.R.)**

### **🛠️ Implementation Plan**

#### **PHASE 1: Preparation**
- [ ] Read relevant .claude/ documentation
- [ ] Verify current project state
- [ ] Confirm build status

#### **PHASE 2: Development**
- [ ] **[Specific step 1]**: [Detailed description]
- [ ] **[Specific step 2]**: [Detailed description]
- [ ] **Incremental testing**: [After each critical step]

#### **PHASE 3: Validation**
- [ ] **Build check**: Successful build
- [ ] **Type check**: No type errors
- [ ] **Manual testing**: [Browser functionality if applicable]

---

## 🔍 **REFLECTION AND VERIFICATION (C.I.D.E.R.)**

### **✅ Acceptance Criteria**
- [ ] **Functional**: [Functionality works as specified]
- [ ] **Technical**: [Successful build + correct types]
- [ ] **UX**: [Intuitive and responsive interface if applicable]

### **📝 Session Documentation**
- [ ] Update .claude/current/active-epic.md with progress
- [ ] Update session file with changes made
- [ ] Plan next steps in .claude/current/next-session.md

---

## 📝 **To Execute This Issue**
\`\`\`bash
claude-cider work [ISSUE-NUMBER] $suggested_area
\`\`\`

3. 🚀 CREATE ISSUE IN GITHUB:
   Use gh tool to create the issue with:
   - Title: $title
   - Content: the body generated above
   - Labels: $epic_label
   - Assigned to: @me

4. 📊 REPORT SUCCESS:
   At the end, report the created issue number and command to execute it.

SPECIFIC INSTRUCTIONS:
- Estimate realistic complexity based on functionality
- Identify exact files that will be modified
- Be specific in acceptance criteria
- Consider current project context from .claude/ files
- Align with active epic and roadmap

Generate and create the issue!" \
        --allowedTools "Read" "Write" \
        "Bash(gh:*)" "Bash(rg:*)" "Bash(find:*)" "Bash(ls:*)" "Bash(grep:*)" \
        "Bash(npm:*)" "Bash(git:*)" "Bash(cd:*)" "Bash(npx:*)" \
        "mcp_supabase_*" "fetch_pull_request"

    if [ $? -eq 0 ]; then
        log_success "Claude Code ejecutado exitosamente"
        log_info "La issue debería estar creada en GitHub"
        log_info "Revisa la salida de Claude Code arriba para obtener el número de issue"
    else
        log_error "Error al ejecutar Claude Code"
        exit 1
    fi
}

# Validate existing issue (GitHub issue number or local file)
validate_issue() {
    local input="$1"
    local issue_content

    # Check if input is a GitHub issue number or URL
    if [[ "$input" =~ ^[0-9]+$ ]] || [[ "$input" =~ github\.com.*issues/[0-9]+ ]]; then
        log_info "Obteniendo contenido de GitHub issue: $input"

        # Extract issue number if it's a URL
        local issue_number="$input"
        if [[ "$input" =~ github\.com.*issues/([0-9]+) ]]; then
            issue_number="${BASH_REMATCH[1]}"
        fi

        # Get issue content from GitHub
        issue_content=$(gh issue view "$issue_number" --json body --jq '.body' 2>/dev/null)
        if [ $? -ne 0 ]; then
            log_error "No se pudo obtener la issue #$issue_number de GitHub"
            exit 1
        fi

        log_info "Validando GitHub issue #$issue_number"
    else
        # Treat as local file
        if [[ ! -f "$input" ]]; then
            log_error "Archivo no encontrado: $input"
            exit 1
        fi

        issue_content=$(cat "$input")
        log_info "Validando archivo local: $input"
    fi

    claude "MODO: VALIDACIÓN DE ISSUES JANOME

Analiza este contenido de issue y valida que cumple con los estándares de JANOME-ISSUE-TEMPLATE:

CONTENIDO DE LA ISSUE:
$issue_content

## CRITERIOS DE VALIDACIÓN:

### 1. ESTRUCTURA Y FORMATO ✅❌
- [ ] Título sigue formato: [TIPO]-(DD-MM-YYYY)-[NOMBRE-FUNCIONALIDAD]
- [ ] Contiene sección ÉPICA PADRE
- [ ] Contiene sección ÁREA DE TRABAJO
- [ ] Contiene sección COMPLEJIDAD con estimación

### 2. CONTEXTUALIZACIÓN (C.I.D.E.R.) ✅❌
- [ ] Objetivo claro y específico
- [ ] Dependencias bien identificadas
- [ ] Contexto de negocio explicado
- [ ] Casos de uso específicos

### 3. PLANIFICACIÓN (C.I.D.E.R.) ✅❌
- [ ] Análisis de impacto por área (Frontend/Backend/Worker/Docs)
- [ ] Definición clara de \"Terminado\"
- [ ] Criterios de aceptación específicos y medibles

### 4. DOCUMENTACIÓN (C.I.D.E.R.) ✅❌
- [ ] Referencias correctas a specs/
- [ ] Funciones BD relevantes identificadas
- [ ] Archivos técnicos específicos mencionados

### 5. EJECUCIÓN (C.I.D.E.R.) ✅❌
- [ ] Plan de implementación en fases
- [ ] Pasos específicos y accionables
- [ ] Consideraciones de testing incluidas

### 6. REFLEXIÓN (C.I.D.E.R.) ✅❌
- [ ] Criterios de aceptación claros
- [ ] Métricas de calidad definidas
- [ ] Consideraciones críticas de Janome incluidas

### 7. ATOMICIDAD Y EJECUTABILIDAD ✅❌
- [ ] Issue es independiente (sin dependencias bloqueantes)
- [ ] Scope apropiado para la complejidad estimada
- [ ] Ejecutable por una persona en el tiempo estimado

## SALIDA REQUERIDA:
1. 📊 Puntuación general: X/10
2. ✅ Elementos que cumple
3. ❌ Elementos que faltan o están mal
4. 💡 Sugerencias específicas de mejora
5. 🎯 Recomendación: APROBAR / REVISAR / RECHAZAR

Lee el contenido completo y provee feedback constructivo." \
        --allowedTools "Read" "Write" \
        "Bash(gh:*)" "Bash(rg:*)" "Bash(find:*)" "Bash(ls:*)" "Bash(grep:*)" \
        "Bash(npm:*)" "Bash(git:*)" "Bash(cd:*)" "Bash(npx:*)" \
        "mcp_supabase_*" "fetch_pull_request"

    log_success "Validación completada. Revisa el feedback para mejorar la issue."
}

# Generate empty template
generate_template() {
    local date=$(date +%d-%m-%Y)
    local template_file=".claude/templates/issue-template-custom.md"

    log_generate "Generating empty template at: $template_file"
    
    # Ensure templates directory exists
    mkdir -p ".claude/templates"

    cat > "$template_file" << 'EOF'
# [FEAT]-(DD-MM-YYYY)-[FEATURE-NAME]

## 🎯 **PARENT EPIC**: [EPIC-NAME]
## 🔧 **WORK AREA**: [frontend|backend|database|docs|full-stack]
## ⏱️ **COMPLEXITY**: [SIMPLE|MEDIUM|COMPLEX] - [15min-2h|2h-6h|6h-24h]

---

## 📋 **CONTEXTUALIZATION (C.I.D.E.R.)**

### **🎯 Issue Objective**
[Clear and specific description of what will be implemented]

### **🔗 Dependencies**
- **Critical files**: [List of files to be modified]
- **Related issues**: #[number] #[number]
- **Epic dependencies**: [If applicable]

### **📊 Business Context**
- **User value**: [How it impacts user experience]
- **Use cases**: [Specific scenarios where it's used]
- **Success metrics**: [How to measure it works correctly]

---

## 🔄 **ITERATION AND PLANNING (C.I.D.E.R.)**

### **📋 Impact Analysis**
- [ ] **Frontend**: [Components to be modified/created]
- [ ] **Backend**: [Services/APIs to be modified]
- [ ] **Database**: [Schema/queries to be modified]
- [ ] **Documentation**: [.claude/ files to be updated]

### **🎯 Definition of "Done"**
- [ ] **Functionality**: [Specific functionality criteria]
- [ ] **Testing**: [What should be tested and how]
- [ ] **Documentation**: [Which documents should be updated]
- [ ] **Build**: [Successful build + type-check]

---

## 📚 **DOCUMENTACIÓN REQUERIDA (C.I.D.E.R.)**

### **📝 Archivos de Especificación**
- [ ] **Spec Principal**: `specs/01_FEATURES/[FEAT]-[nombre].md`
- [ ] **BD Updates**: `specs/03_DATABASE/[archivo-relevante].sql` (si aplica)
- [ ] **Log de Trabajo**: `specs/02_LOGS/[LOG]-[nombre].md`

### **🔗 Referencias Técnicas**
- **Funciones BD relevantes**: [Lista específica de funciones]
- **Componentes afectados**: [Lista de componentes React]
- **Tipos TypeScript**: [Interfaces/tipos que se modifican]

---

## ⚡ **EJECUCIÓN TÉCNICA (C.I.D.E.R.)**

### **🛠️ Plan de Implementación**

#### **FASE 1: Preparación**
- [ ] Leer specs/00_SYSTEM/_MANIFEST.md
- [ ] Revisar specs/03_DATABASE/_DATABASE_OVERVIEW.md
- [ ] Verificar funciones BD relevantes con Supabase MCP
- [ ] Confirmar estado actual del build: `npm run build`

#### **FASE 2: Desarrollo**
- [ ] **[Paso específico 1]**: [Descripción detallada]
- [ ] **[Paso específico 2]**: [Descripción detallada]
- [ ] **[Paso específico 3]**: [Descripción detallada]
- [ ] **Testing incremental**: [Después de cada paso crítico]

#### **FASE 3: Validación**
- [ ] **Build check**: `npm run build` exitoso
- [ ] **Type check**: `npm run type-check` sin errores
- [ ] **Testing manual**: [Funcionalidad en http://localhost:5173/]
- [ ] **Worker testing**: [Si aplica] `cd worker && npm test`

---

## 🔍 **REFLEXIÓN Y VERIFICACIÓN (C.I.D.E.R.)**

### **✅ Criterios de Aceptación**
- [ ] **Funcional**: [La funcionalidad trabaja según especificación]
- [ ] **Técnico**: [Build exitoso + tipos correctos]
- [ ] **UX**: [Interfaz intuitiva y responsive]
- [ ] **Performance**: [No degradación notable]

### **📊 Métricas de Calidad**
- [ ] **Sin errores TypeScript**: `npm run type-check`
- [ ] **Sin errores de build**: `npm run build`
- [ ] **Testing manual exitoso**: Browser testing
- [ ] **Documentación actualizada**: Specs relevantes

---

## 🚨 **CONSIDERACIONES CRÍTICAS JANOME**

### **⚠️ Reglas Obligatorias**
- **Timezone**: Todas las fechas en `America/Santiago`
- **BD Functions**: Consultar estado real con Supabase MCP
- **Worker**: Si se modifica, testing obligatorio
- **Build**: Nunca commitear código que rompa el build

### **🔗 Recursos de Desarrollo**
- **Supabase Project**: `rqholbdnefyfokrozkih`
- **Worker URL**: `https://janome-whatsapp-reminders-production.oficina-c3f.workers.dev/`
- **Local Dev**: `http://localhost:5173/`

---

## 📅 **INFORMACIÓN DE TRACKING**

**Creado**: [DD/MM/YYYY]
**Asignado**: [@username]
**Epic**: [EPIC-NOMBRE]
**Estimación**: [tiempo estimado]
**Prioridad**: [ALTA|MEDIA|BAJA]

EOF

    log_success "Template generado en: $template_file"
    log_info "Edita el archivo y completa los campos marcados con [brackets]"
}

# Main script logic
main() {
    if [ $# -eq 0 ]; then
        show_usage
        exit 1
    fi

    local command="$1"
    shift

    case $command in
        "analyze")
            # Check prerequisites for commands that need Claude Code
            check_claude_availability
            check_project_structure

            if [ $# -eq 0 ]; then
                log_error "Requirement description required for analyze command"
                echo "Usage: $0 analyze \"<requirement description>\""
                exit 1
            fi
            analyze_requirement "$*"
            ;;
        "generate")
            # Check prerequisites for commands that need Claude Code and GitHub CLI
            check_claude_availability
            check_github_cli
            check_project_structure

            if [ $# -lt 2 ]; then
                log_error "Epic and feature required for generate command"
                echo "Usage: $0 generate <epic> <feature>"
                exit 1
            fi
            generate_issue "$1" "${*:2}"
            ;;
        "validate")
            # Check prerequisites for commands that need Claude Code and possibly GitHub CLI
            check_claude_availability
            check_project_structure

            # Only check GitHub CLI if input looks like an issue number or GitHub URL
            if [[ "$1" =~ ^[0-9]+$ ]] || [[ "$1" =~ github\.com.*issues/[0-9]+ ]]; then
                check_github_cli
            fi

            if [ $# -eq 0 ]; then
                log_error "Issue number, GitHub URL, or local file required for validate command"
                echo "Usage: $0 validate <issue_number|github_url|local_file>"
                exit 1
            fi
            validate_issue "$1"
            ;;
        "list-epics")
            # This command doesn't need Claude Code
            list_epics
            ;;
        "template")
            # This command doesn't need Claude Code but needs project structure
            check_project_structure
            generate_template
            ;;
        *)
            log_error "Unknown command: $command"
            show_usage
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"