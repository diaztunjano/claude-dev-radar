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
    echo "🎯 JANOME ISSUE GENERATOR - GitHub Integration"
    echo "============================================="
    echo ""
    echo "Creates atomic issues directly in GitHub following C.I.D.E.R. protocol"
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
    echo "  📁 Run from Janome project root directory"
    echo ""
    echo "GENERATE OPTIONS:"
    echo "  epic: EPIC-TALLERES, EPIC-ASISTENTES, EPIC-EQUIPOS, EPIC-RECORDATORIOS,"
    echo "        EPIC-USUARIOS, EPIC-IA-WHATSAPP, EPIC-DASHBOARD, EPIC-PERFORMANCE, EPIC-DOCS"
    echo "  feature: Brief description of the feature"
    echo ""
    echo "VALIDATE OPTIONS:"
    echo "  input: GitHub issue number (e.g., 123) or local file path"
    echo ""
    echo "EXAMPLES:"
    echo "  $0 analyze \"Implementar sistema de evaluaciones post-taller\""
    echo "  $0 generate EPIC-TALLERES \"widget confirmacion asistencia\""
    echo "  $0 validate 123  # Validates GitHub issue #123"
    echo "  $0 validate specs/01_FEATURES/[FEAT]-nueva-funcionalidad.md"
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

# Validate we're in the correct directory
check_project_structure() {
    if [[ ! -f "package.json" ]] || [[ ! -d "src" ]] || [[ ! -d "specs" ]]; then
        log_error "Please run this script from the Janome project root directory"
        log_info "Expected structure: package.json, src/, specs/"
        exit 1
    fi
}

# List available epics
list_epics() {
    log_epic "ÉPICAS DISPONIBLES EN JANOME"
    echo ""
    echo "🎯 EPIC-TALLERES - Gestión de Talleres"
    echo "   └── Programación, Confirmaciones, Estados, Reportes"
    echo ""
    echo "👥 EPIC-ASISTENTES - Gestión de Participantes"
    echo "   └── Perfiles, Equipos, Inscripciones, Historial"
    echo ""
    echo "🔧 EPIC-EQUIPOS - Catálogo de Máquinas"
    echo "   └── Catálogo, Tipos, Compatibilidad, Asignaciones"
    echo ""
    echo "📱 EPIC-RECORDATORIOS - Sistema WhatsApp"
    echo "   └── Cron Jobs, Templates, Estadísticas, Bulk"
    echo ""
    echo "👤 EPIC-USUARIOS - Autenticación y Roles"
    echo "   └── Auth, Roles, Estados, Aprobaciones"
    echo ""
    echo "🤖 EPIC-IA-WHATSAPP - Integración IA"
    echo "   └── Chatbot, Escalamiento, Contexto, Análisis"
    echo ""
    echo "📊 EPIC-DASHBOARD - Métricas y Reportes"
    echo "   └── Widgets, Gráficos, Exportes, Alertas"
    echo ""
    echo "🔧 EPIC-PERFORMANCE - Optimizaciones"
    echo "   └── BD, Frontend, Worker, Monitoring"
    echo ""
    echo "🔧 EPIC-DOCS - Documentación"
    echo "   └── Creación de documentos .md como bitácora del proyecto."
}

# Analyze requirement and suggest structure
analyze_requirement() {
    local requirement="$1"

    log_info "Analizando requerimiento para estructura de issues..."

    claude "MODO: ANÁLISIS DE REQUERIMIENTO JANOME

Analiza este requerimiento y propón la estructura de issues:

REQUERIMIENTO: $requirement

## CONTEXTO DEL PROYECTO JANOME
Este es el Panel Administrativo Janome - un sistema de gestión de talleres, asistentes y equipos industriales.
Stack: React + TypeScript + Vite + Supabase + Cloudflare Workers
Protocolo: C.I.D.E.R. (Contextualizar, Iterar, Documentar, Ejecutar, Reflexionar)

Tienes acceso a la documentación completa en:
- specs/00_SYSTEM/_MANIFEST.md (estado global)
- specs/03_DATABASE/_DATABASE_OVERVIEW.md (funciones BD)
- CLAUDE.md (contexto de desarrollo)

## ÉPICAS DISPONIBLES:
🎯 EPIC-TALLERES - Gestión de Talleres
👥 EPIC-ASISTENTES - Gestión de Participantes
🔧 EPIC-EQUIPOS - Catálogo de Máquinas
📱 EPIC-RECORDATORIOS - Sistema WhatsApp
👤 EPIC-USUARIOS - Autenticación y Roles
🤖 EPIC-IA-WHATSAPP - Integración IA
📊 EPIC-DASHBOARD - Métricas y Reportes
🔧 EPIC-PERFORMANCE - Optimizaciones
🔧 EPIC-DOCS - Documentación

## TAREAS REQUERIDAS:
1. 🎯 Identifica la ÉPICA principal (y secundarias si aplican)
2. 📋 Desglosa en issues atómicas (cada una independiente)
3. 🔗 Establece dependencias entre issues
4. ⏱️ Estima complejidad: SIMPLE(15min-2h) | MEDIUM(2h-6h) | COMPLEX(6h-24h)
5. 📅 Propón orden lógico de desarrollo
6. ⚠️ Identifica riesgos o blockers potenciales
7. 🏗️ Sugiere si requiere investigación previa o pruebas de concepto

## FORMATO DE SALIDA ESPERADO:
### ÉPICA PRINCIPAL: [nombre]
### ISSUES ATÓMICAS SUGERIDAS:
1. [TIPO]-(fecha)-[nombre] - COMPLEJIDAD: [nivel] - AREA: [area]
   Descripción: [qué hace específicamente]
   Dependencias: [issues relacionadas]

2. [continuar...]

### ORDEN DE DESARROLLO:
1. Issue #1 (prerequisito)
2. Issue #2 (puede ir en paralelo)
...

### RIESGOS IDENTIFICADOS:
- [riesgo 1]: [mitigación sugerida]
- [riesgo 2]: [mitigación sugerida]

Sé específico y práctico. Cada issue debe ser implementable independientemente." \
        --allowedTools "Read" "Write" \
        "Bash(gh:*)" "Bash(rg:*)" "Bash(find:*)" "Bash(ls:*)" "Bash(grep:*)" \
        "Bash(npm:*)" "Bash(git:*)" "Bash(cd:*)" "Bash(npx:*)" \
        "mcp_supabase_*" "fetch_pull_request"

    log_success "Análisis completado. Revisa la propuesta y genera las issues específicas."
}

# Generate atomic issue and create it in GitHub via Claude Code
generate_issue() {
    local epic="$1"
    local feature="$2"

    log_generate "Generando y creando issue atómica para $epic: $feature"

    # Validate epic
    case $epic in
        EPIC-TALLERES|EPIC-ASISTENTES|EPIC-EQUIPOS|EPIC-RECORDATORIOS|EPIC-USUARIOS|EPIC-IA-WHATSAPP|EPIC-DASHBOARD|EPIC-PERFORMANCE|EPIC-DOCS)
            ;;
        *)
            log_error "Épica no válida: $epic"
            log_info "Usa: list-epics para ver épicas disponibles"
            exit 1
            ;;
    esac

    # Map epic to GitHub label
    local epic_label
    case $epic in
        EPIC-TALLERES) epic_label="epic:talleres" ;;
        EPIC-ASISTENTES) epic_label="epic:asistentes" ;;
        EPIC-EQUIPOS) epic_label="epic:equipos" ;;
        EPIC-RECORDATORIOS) epic_label="epic:recordatorios" ;;
        EPIC-USUARIOS) epic_label="epic:usuarios" ;;
        EPIC-IA-WHATSAPP) epic_label="epic:ia-whatsapp" ;;
        EPIC-DASHBOARD) epic_label="epic:dashboard" ;;
        EPIC-PERFORMANCE) epic_label="epic:performance" ;;
        EPIC-DOCS) epic_label="epic:docs" ;;
    esac

    # Determine suggested area automatically
    local suggested_area="frontend"
    if echo "$feature" | grep -qi "worker\|cron\|whatsapp\|reminder"; then
        suggested_area="worker"
    elif echo "$feature" | grep -qi "database\|function\|migration\|table"; then
        suggested_area="database"
    elif echo "$feature" | grep -qi "doc\|spec\|readme\|plan\|staging\|production\|deploy"; then
        suggested_area="docs"
    fi

    # Generate date for title
    local date=$(date +%d-%m-%Y)
    local title="[FEAT]-($date)-[...]"

    log_info "Ejecutando Claude Code para generar y crear la issue..."
    log_info "Título sugerido: $title"
    log_info "Labels sugeridos: $epic_label"
    log_info "Área sugerida: $suggested_area"

    # Execute Claude Code with direct GitHub issue creation
    claude "MODO: GENERADOR DE ISSUE JANOME + CREACIÓN EN GITHUB

## CONFIGURACIÓN DE LA ISSUE
ÉPICA: $epic
FUNCIONALIDAD: $feature
TÍTULO SUGERIDO: $title
LABELS SUGERIDOS: $epic_label,ÁREA SUGERIDA: $suggested_area

## TU TAREA COMPLETA:
1. 📖 Lee OBLIGATORIAMENTE estos archivos para contextualizar:
   - CLAUDE.md (reglas y protocolo de desarrollo)
   - specs/00_SYSTEM/_MANIFEST.md (estado global del sistema)
   - specs/03_DATABASE/_DATABASE_OVERVIEW.md (funciones BD disponibles)

2. 📝 Genera el contenido completo de la issue siguiendo protocolo C.I.D.E.R.:

## 🎯 **ÉPICA PADRE**: $epic
## 🔧 **ÁREA DE TRABAJO**: $suggested_area (o ajusta según análisis)
## ⏱️ **COMPLEJIDAD**: [SIMPLE|MEDIUM|COMPLEX] - [15min-2h|2h-6h|6h-24h]

---

## 📋 **CONTEXTUALIZACIÓN (C.I.D.E.R.)**

### **🎯 Objetivo de la Issue**
[Descripción clara y específica de qué se va a implementar]

### **🔗 Dependencias**
- **Archivos críticos**: [Lista de archivos que se van a modificar]
- **Funciones BD**: [Funciones de Supabase involucradas si aplica]
- **Issues relacionadas**: [Si aplica]

### **📊 Contexto de Negocio**
- **Valor para el usuario**: [Cómo impacta la experiencia del usuario]
- **Casos de uso**: [Escenarios específicos donde se usa]

---

## 🔄 **ITERACIÓN Y PLANIFICACIÓN (C.I.D.E.R.)**

### **📋 Análisis de Impacto**
- [ ] **Frontend**: [Componentes que se van a modificar/crear]
- [ ] **Backend/BD**: [Funciones/tablas que se van a modificar]
- [ ] **Worker**: [Scripts o endpoints que se van a tocar]
- [ ] **Documentación**: [Archivos de specs que se van a actualizar]

### **🎯 Definición de \"Terminado\"**
- [ ] **Funcionalidad**: [Criterios específicos de funcionalidad]
- [ ] **Testing**: [Qué se debe probar y cómo]
- [ ] **Documentación**: [Qué documentos se deben actualizar]
- [ ] **Build**: [npm run build exitoso + type-check]

---

## ⚡ **EJECUCIÓN TÉCNICA (C.I.D.E.R.)**

### **🛠️ Plan de Implementación**

#### **FASE 1: Preparación**
- [ ] Leer specs relevantes
- [ ] Verificar funciones BD con Supabase MCP (si aplica)
- [ ] Confirmar estado del build: \`npm run build\`

#### **FASE 2: Desarrollo**
- [ ] **[Paso específico 1]**: [Descripción detallada]
- [ ] **[Paso específico 2]**: [Descripción detallada]
- [ ] **Testing incremental**: [Después de cada paso crítico]

#### **FASE 3: Validación**
- [ ] **Build check**: \`npm run build\` exitoso
- [ ] **Type check**: \`npm run type-check\` sin errores
- [ ] **Testing manual**: [Funcionalidad en browser si aplica]

---

## 🔍 **REFLEXIÓN Y VERIFICACIÓN (C.I.D.E.R.)**

### **✅ Criterios de Aceptación**
- [ ] **Funcional**: [La funcionalidad trabaja según especificación]
- [ ] **Técnico**: [Build exitoso + tipos correctos]
- [ ] **UX**: [Interfaz intuitiva y responsive si aplica]

### **🚨 Consideraciones Críticas Janome**
- **Timezone**: Todas las fechas en \`America/Santiago\` (si aplica)
- **BD Functions**: Consultar estado real con Supabase MCP (si aplica)
- **Worker**: Si se modifica, testing obligatorio

---

## 📝 **Para Ejecutar Esta Issue**
\`\`\`bash
./claude-issue-worker.sh [NUMERO-ISSUE] $suggested_area
\`\`\`

3. 🚀 CREAR LA ISSUE EN GITHUB:
   Usa la herramienta gh para crear la issue con:
   - Título: $title
   - Contenido: el body generado arriba
   - Labels: $epic_label
   - Asignado a: @me

4. 📊 REPORTAR ÉXITO:
   Al final, reporta el número de issue creada y el comando para ejecutarla.

INSTRUCCIONES ESPECÍFICAS:
- Estima complejidad realista basada en la funcionalidad
- Identifica archivos exactos que se van a modificar
- Consulta funciones BD reales si es relevante
- Sé específico en criterios de aceptación
- Incluye consideraciones del timezone America/Santiago cuando corresponda

¡Procede a generar y crear la issue!" \
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
    local template_file="specs/01_FEATURES/[FEAT]-($date)-nueva-funcionalidad.md"

    log_generate "Generando template vacío en: $template_file"

    cat > "$template_file" << 'EOF'
# [FEAT]-(DD-MM-YYYY)-[NOMBRE-FUNCIONALIDAD]

## 🎯 **ÉPICA PADRE**: [EPIC-NOMBRE]
## 🔧 **ÁREA DE TRABAJO**: [frontend|worker|database|docs|full-stack]
## ⏱️ **COMPLEJIDAD**: [SIMPLE|MEDIUM|COMPLEX] - [15min-2h|2h-6h|6h-24h]

---

## 📋 **CONTEXTUALIZACIÓN (C.I.D.E.R.)**

### **🎯 Objetivo de la Issue**
[Descripción clara y específica de qué se va a implementar]

### **🔗 Dependencias**
- **Archivos críticos**: [Lista de archivos que se van a modificar]
- **Funciones BD**: [Funciones de Supabase involucradas]
- **Issues relacionadas**: #[numero] #[numero]
- **Épicas dependientes**: [Si aplica]

### **📊 Contexto de Negocio**
- **Valor para el usuario**: [Cómo impacta la experiencia del usuario]
- **Casos de uso**: [Escenarios específicos donde se usa]
- **Métricas de éxito**: [Cómo medir que funciona correctamente]

---

## 🔄 **ITERACIÓN Y PLANIFICACIÓN (C.I.D.E.R.)**

### **📋 Análisis de Impacto**
- [ ] **Frontend**: [Componentes que se van a modificar/crear]
- [ ] **Backend/BD**: [Funciones/tablas que se van a modificar]
- [ ] **Worker**: [Scripts o endpoints que se van a tocar]
- [ ] **Documentación**: [Archivos de specs que se van a actualizar]

### **🎯 Definición de "Terminado"**
- [ ] **Funcionalidad**: [Criterios específicos de funcionalidad]
- [ ] **Testing**: [Qué se debe probar y cómo]
- [ ] **Documentación**: [Qué documentos se deben actualizar]
- [ ] **Build**: [npm run build exitoso + type-check]

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