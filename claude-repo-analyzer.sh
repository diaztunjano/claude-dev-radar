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

log_radar() {
    echo -e "${PURPLE}[R.A.D.A.R.]${NC} $1"
}

log_phase() {
    echo -e "${CYAN}[PHASE]${NC} $1"
}

# Display usage
show_usage() {
    echo "🔍 CLAUDE REPOSITORY ANALYZER - R.A.D.A.R. System"
    echo "=================================================="
    echo ""
    echo "Deep analysis of unknown repositories using R.A.D.A.R. methodology:"
    echo "🔍 Reconocer - 🧐 Analizar - 📝 Documentar - 🏗️ Arquitecturar - 📊 Reportar"
    echo ""
    echo "Usage: $0 <command> [repo-path]"
    echo ""
    echo "COMMANDS:"
    echo "  analyze [path]    - Full R.A.D.A.R. analysis of repository"
    echo "  discover [path]   - Phase 1: Recognize structure and purpose"
    echo "  examine [path]    - Phase 2: Analyze architecture and patterns"
    echo "  document [path]   - Phase 3: Generate comprehensive documentation"
    echo "  guide [path]      - Phase 4: Create developer onboarding guides"
    echo "  report [path]     - Phase 5: Executive summary and next steps"
    echo ""
    echo "OUTPUT STRUCTURE:"
    echo "  📁 analysis/              - Analysis reports and documentation"
    echo "  📁 analysis/architecture/ - Architecture diagrams and maps"
    echo "  📁 analysis/onboarding/   - Developer guides and setup docs"
    echo "  📁 analysis/reports/      - Executive summaries and findings"
    echo ""
    echo "METHODOLOGY R.A.D.A.R.:"
    echo "  🔍 RECONOCER: Identify purpose, stack, structure"
    echo "  🧐 ANALIZAR: Deep dive into patterns, flows, data models"
    echo "  📝 DOCUMENTAR: Generate technical documentation"
    echo "  🏗️ ARQUITECTURAR: Map components, dependencies, integrations"
    echo "  📊 REPORTAR: Executive summary, recommendations, roadmap"
    echo ""
    echo "REQUIREMENTS:"
    echo "  📋 Claude Code installed and authenticated"
    echo "  📁 Run from target repository root (or specify path)"
    echo "  🔍 Git repository with commit history"
    echo ""
    echo "EXAMPLES:"
    echo "  $0 analyze                           # Analyze current directory"
    echo "  $0 analyze /path/to/repo            # Analyze specific repository"
    echo "  $0 discover                         # Quick structure overview"
    echo "  $0 document                         # Generate docs only"
    echo ""
    echo "WORKFLOW:"
    echo "  1. 🔍 Full analysis: $0 analyze [path]"
    echo "  2. 📚 Review generated docs in analysis/"
    echo "  3. 🚀 Use onboarding guides for team setup"
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

# Check if we're in a valid repository
check_repository_structure() {
    local repo_path="${1:-.}"

    if [[ ! -d "$repo_path/.git" ]]; then
        log_error "Not a Git repository: $repo_path"
        log_info "Please run from a Git repository root or specify a valid path"
        exit 1
    fi

    log_success "Valid Git repository detected: $repo_path"
}

# Create analysis directory structure
setup_analysis_directories() {
    local repo_path="${1:-.}"
    local analysis_dir="$repo_path/analysis"

    log_info "Setting up analysis directory structure..."

    mkdir -p "$analysis_dir"/{architecture,onboarding,reports,data-models,workflows}

    log_success "Analysis directories created in: $analysis_dir"
}

# Phase 1: Reconocer - Identify structure and purpose
phase_reconocer() {
    local repo_path="${1:-.}"
    local timestamp=$(date +%Y%m%d)

    log_phase "🔍 FASE 1: RECONOCER - Estructura y Propósito"

    claude "MODO: RECONOCIMIENTO DE REPOSITORIO (R.A.D.A.R. FASE 1)

REPOSITORIO A ANALIZAR: $repo_path

## 🎯 TU MISIÓN: RECONOCIMIENTO PROFUNDO

Eres un detective de código experto. Tu trabajo es reconocer y entender completamente este repositorio desconocido.

## 📋 TAREAS OBLIGATORIAS:

### 1. 🔍 RECONOCIMIENTO INICIAL
- Lee README.md, package.json, y archivos de configuración principales
- Identifica el PROPÓSITO central del proyecto
- Determina el STACK tecnológico completo
- Establece el TIPO de aplicación (web, API, CLI, mobile, etc.)

### 2. 📁 ANÁLISIS DE ESTRUCTURA
- Mapea la estructura de directorios completa
- Identifica patrones de organización
- Detecta convenciones de naming
- Encuentra archivos de configuración críticos

### 3. 🔧 STACK Y DEPENDENCIAS
- Analiza package.json, requirements.txt, Gemfile, etc.
- Identifica frameworks principales
- Determina herramientas de build/deploy
- Mapea integraciones externas

### 4. 🎯 PROPÓSITO Y CONTEXTO
- ¿Qué problema resuelve este proyecto?
- ¿Cuál es el dominio de negocio?
- ¿Quiénes son los usuarios objetivo?
- ¿Qué valor proporciona?

## 📊 FORMATO DE SALIDA REQUERIDO:

Genera un archivo \`analysis/reports/$timestamp-01-reconocimiento.md\` con:

\`\`\`markdown
# 🔍 RECONOCIMIENTO DE REPOSITORIO

**Proyecto**: [Nombre]
**Fecha**: [Fecha actual]
**Analista**: Claude R.A.D.A.R.

## 🎯 RESUMEN EJECUTIVO
[3-4 líneas describiendo qué es y qué hace]

## 🏗️ STACK TECNOLÓGICO
- **Frontend**: [Framework/librerías]
- **Backend**: [Lenguaje/framework]
- **Base de datos**: [Tipo/motor]
- **Deploy**: [Plataforma/herramientas]
- **Testing**: [Frameworks de testing]

## 📁 ESTRUCTURA DEL PROYECTO
\`\`\`
src/
├── components/     # [Descripción]
├── services/       # [Descripción]
└── utils/         # [Descripción]
\`\`\`

## 🎯 PROPÓSITO Y DOMINIO
- **Problema que resuelve**: [Descripción]
- **Usuarios objetivo**: [Descripción]
- **Valor de negocio**: [Descripción]

## 🔧 CONFIGURACIONES CRÍTICAS
- **Build**: [Herramientas y comandos]
- **Deploy**: [Proceso y plataformas]
- **Environment**: [Variables y configuración]

## 📊 MÉTRICAS DE PROYECTO
- **Tamaño**: [Líneas de código aproximadas]
- **Complejidad**: [SIMPLE|MEDIUM|COMPLEX]
- **Actividad**: [Frecuencia de commits]
- **Equipo**: [Tamaño estimado del equipo]

## 🚨 OBSERVACIONES IMPORTANTES
- [Cualquier cosa notable o preocupante]
- [Configuraciones especiales]
- [Dependencias críticas]

## 🔄 PRÓXIMOS PASOS ANÁLISIS
1. Análisis de arquitectura y patrones
2. Mapeo de flujos de datos
3. Revisión de código y estándares
4. Generación de documentación técnica
\`\`\`

## 🎯 INSTRUCCIONES ESPECÍFICAS:
- SÉ ESPECÍFICO: No uses generalidades
- SÉ TÉCNICO: Incluye detalles exactos de configuración
- SÉ PRÁCTICO: Enfócate en información accionable
- USA HERRAMIENTAS: Lee archivos, busca patrones, analiza dependencias

¡Comienza el reconocimiento completo!" \
        --allowedTools "Read" "Write" \
        "Bash(find:*)" "Bash(ls:*)" "Bash(grep:*)" "Bash(cat:*)" \
        "Bash(head:*)" "Bash(tail:*)" "Bash(wc:*)" \
        "Bash(git:*)" "Bash(npm:*)" "Bash(yarn:*)" \
        "sequential-thinking"

    log_success "Fase 1 (Reconocer) completada"
}

# Phase 2: Analizar - Deep dive into architecture
phase_analizar() {
    local repo_path="${1:-.}"
    local timestamp=$(date +%Y%m%d)

    log_phase "🧐 FASE 2: ANALIZAR - Arquitectura y Patrones"

    claude "MODO: ANÁLISIS ARQUITECTÓNICO (R.A.D.A.R. FASE 2)

REPOSITORIO: $repo_path

## 🎯 TU MISIÓN: ANÁLISIS ARQUITECTÓNICO PROFUNDO

Ahora que conoces la estructura básica, analiza la arquitectura, patrones y flujos del sistema.

## 📋 TAREAS OBLIGATORIAS:

### 1. 🏗️ ARQUITECTURA DE CÓDIGO
- Identifica patrones arquitectónicos (MVC, Redux, Clean Architecture, etc.)
- Mapea la separación de responsabilidades
- Analiza la estructura de módulos/componentes
- Detecta abstracciones y capas

### 2. 🔄 FLUJOS DE DATOS
- Mapea cómo fluyen los datos por la aplicación
- Identifica puntos de entrada y salida
- Analiza gestión de estado
- Detecta APIs y comunicación externa

### 3. 🗄️ MODELO DE DATOS
- Encuentra esquemas de base de datos
- Identifica entidades principales
- Mapea relaciones entre datos
- Analiza validaciones y constraints

### 4. 🔌 INTEGRACIONES
- APIs externas consumidas
- Servicios de terceros
- Webhooks y callbacks
- Autenticación y autorización

### 5. 📊 PATRONES DE CÓDIGO
- Convenciones de naming
- Patrones de diseño utilizados
- Estándares de código
- Testing patterns

## 📊 FORMATO DE SALIDA REQUERIDO:

Genera archivo \`analysis/architecture/$timestamp-02-analisis-arquitectura.md\`:

\`\`\`markdown
# 🧐 ANÁLISIS ARQUITECTÓNICO

## 🏗️ PATRONES ARQUITECTÓNICOS
- **Patrón principal**: [MVC/Redux/Clean/etc.]
- **Organización**: [Por features/capas/dominios]
- **Separación**: [Como se separan responsabilidades]

## 🔄 FLUJO DE DATOS

### Frontend → Backend
1. [Descripción del flujo]
2. [Middlewares/interceptors]
3. [Validaciones]

### Estado Global
- **Gestión**: [Redux/Context/Zustand/etc.]
- **Persistencia**: [LocalStorage/SessionStorage/etc.]
- **Sincronización**: [Como se mantiene consistente]

## 🗄️ MODELO DE DATOS

### Entidades Principales
1. **[Entidad]**: [Descripción y campos]
2. **[Entidad]**: [Descripción y campos]

### Relaciones
- [Entidad A] → [Entidad B]: [Tipo de relación]

## 🔌 INTEGRACIONES EXTERNAS
- **APIs**: [Lista de APIs consumidas]
- **Auth**: [Método de autenticación]
- **Pagos**: [Si aplica]
- **Analytics**: [Herramientas de tracking]

## 📊 PATRONES DE CÓDIGO
- **Components**: [Como se estructuran]
- **Services**: [Patrón de servicios]
- **Utils**: [Organización de utilities]
- **Testing**: [Estrategia de testing]

## 🔧 HERRAMIENTAS Y CONFIGURACIÓN
- **Build**: [Webpack/Vite/etc.]
- **Linting**: [ESLint/Prettier/etc.]
- **Types**: [TypeScript configuration]
- **Deploy**: [CI/CD pipeline]

## 🚨 PUNTOS CRÍTICOS
- [Componentes críticos del sistema]
- [Posibles cuellos de botella]
- [Dependencias frágiles]

## 💡 OBSERVACIONES TÉCNICAS
- [Fortalezas de la arquitectura]
- [Debilidades identificadas]
- [Sugerencias de mejora]
\`\`\`

## 🎯 ANÁLISIS ESPECÍFICOS:
- Lee componentes principales y sus dependencias
- Revisa configuraciones de build y deploy
- Analiza tests para entender comportamientos esperados
- Busca documentación técnica existente

¡Procede con el análisis arquitectónico profundo!" \
        --allowedTools "Read" "Write" \
        "Bash(find:*)" "Bash(ls:*)" "Bash(grep:*)" "Bash(cat:*)" \
        "Bash(rg:*)" "Bash(tree:*)" \
        "Bash(git:*)" "Bash(npm:*)" "Bash(yarn:*)" \
        "sequential-thinking"

    log_success "Fase 2 (Analizar) completada"
}

# Phase 3: Documentar - Generate comprehensive documentation
phase_documentar() {
    local repo_path="${1:-.}"
    local timestamp=$(date +%Y%m%d)

    log_phase "📝 FASE 3: DOCUMENTAR - Documentación Técnica"

    claude "MODO: GENERACIÓN DE DOCUMENTACIÓN (R.A.D.A.R. FASE 3)

REPOSITORIO: $repo_path

## 🎯 TU MISIÓN: DOCUMENTACIÓN TÉCNICA COMPLETA

Genera documentación técnica comprensiva basada en tu análisis previo.

## 📋 DOCUMENTOS A GENERAR:

### 1. 📚 ARCHITECTURE.md
Documentación técnica completa de la arquitectura del sistema

### 2. 🚀 GETTING-STARTED.md
Guía de setup y primeros pasos para desarrolladores

### 3. 🔧 DEVELOPER-GUIDE.md
Guía de desarrollo con patrones y convenciones

### 4. 📊 API-DOCUMENTATION.md
Documentación de APIs y endpoints (si aplica)

### 5. 🗄️ DATA-MODEL.md
Documentación del modelo de datos

## 📊 FORMATO ESPECÍFICO:

### analysis/onboarding/ARCHITECTURE.md:
\`\`\`markdown
# 🏗️ ARQUITECTURA DEL SISTEMA

## 🎯 Overview
[Descripción general de la arquitectura]

## 📁 Estructura de Directorios
[Explicación detallada de cada directorio]

## 🔄 Flujo de Datos
[Diagramas en texto de como fluyen los datos]

## 🔌 Integraciones
[APIs externas y servicios conectados]

## 🛠️ Stack Tecnológico
[Tecnologías utilizadas y justificación]

## 📊 Patrones de Diseño
[Patrones utilizados en el código]
\`\`\`

### analysis/onboarding/GETTING-STARTED.md:
\`\`\`markdown
# 🚀 GETTING STARTED

## ⚙️ Prerequisites
[Requisitos del sistema y herramientas]

## 📦 Installation
\`\`\`bash
# Comandos específicos de instalación
\`\`\`

## 🔧 Development Setup
[Configuración del entorno de desarrollo]

## 🏃 Running the Project
[Como ejecutar el proyecto localmente]

## 🧪 Testing
[Como ejecutar tests]

## 🚀 Deployment
[Proceso de deploy si está documentado]
\`\`\`

### analysis/onboarding/DEVELOPER-GUIDE.md:
\`\`\`markdown
# 🔧 DEVELOPER GUIDE

## 📋 Code Standards
[Estándares de código y convenciones]

## 🏗️ Project Structure
[Como organizar el código nuevo]

## 🔄 Development Workflow
[Proceso de desarrollo recomendado]

## 🧪 Testing Guidelines
[Como escribir y organizar tests]

## 🎯 Best Practices
[Mejores prácticas específicas del proyecto]

## 🚨 Common Pitfalls
[Errores comunes y como evitarlos]
\`\`\`

### analysis/data-models/DATA-MODEL.md:
\`\`\`markdown
# 🗄️ MODELO DE DATOS

## 📊 Entities Overview
[Resumen de entidades principales]

## 🔗 Relationships
[Relaciones entre entidades]

## 📋 Schema Details
[Detalles de esquemas y validaciones]

## 🔄 Data Flow
[Como se mueven y transforman los datos]
\`\`\`

## 🎯 INSTRUCCIONES ESPECÍFICAS:
- Usa información de las fases anteriores
- Sé específico con comandos y configuraciones
- Incluye ejemplos de código donde sea relevante
- Genera documentación que un desarrollador nuevo pueda seguir
- Revisa archivos de configuración para detalles exactos

¡Genera la documentación técnica completa!" \
        --allowedTools "Read" "Write" \
        "Bash(find:*)" "Bash(ls:*)" "Bash(grep:*)" "Bash(cat:*)" \
        "Bash(rg:*)" \
        "sequential-thinking"

    log_success "Fase 3 (Documentar) completada"
}

# Phase 4: Arquitecturar - Map components and dependencies
phase_arquitecturar() {
    local repo_path="${1:-.}"
    local timestamp=$(date +%Y%m%d)

    log_phase "🏗️ FASE 4: ARQUITECTURAR - Mapeo de Componentes"

    claude "MODO: MAPEO ARQUITECTÓNICO (R.A.D.A.R. FASE 4)

REPOSITORIO: $repo_path

## 🎯 TU MISIÓN: MAPEO VISUAL Y ESTRUCTURAL

Crea mapas visuales y estructurales del sistema para facilitar la comprensión.

## 📋 TAREAS OBLIGATORIAS:

### 1. 🗺️ MAPA DE COMPONENTES
- Crea diagrama textual de componentes principales
- Mapea dependencias entre módulos
- Identifica componentes reutilizables
- Detecta acoplamientos fuertes

### 2. 🔄 MAPA DE FLUJOS
- Diagrama de flujo de usuarios
- Flujo de datos críticos
- Procesos de negocio principales
- Ciclo de vida de entidades

### 3. 🏗️ MAPA DE CAPAS
- Capas de la aplicación
- Separación de responsabilidades
- Interfaces entre capas
- Dependencias direccionales

### 4. 🔌 MAPA DE INTEGRACIONES
- Sistemas externos conectados
- APIs consumidas y expuestas
- Flujo de autenticación
- Puntos de integración críticos

## 📊 FORMATO DE SALIDA:

### analysis/architecture/$timestamp-component-map.md:
\`\`\`markdown
# 🗺️ MAPA DE COMPONENTES

## 🏗️ Arquitectura General
\`\`\`
┌─────────────────┐    ┌─────────────────┐
│    Frontend     │◄──►│     Backend     │
│                 │    │                 │
│ ┌─────────────┐ │    │ ┌─────────────┐ │
│ │ Components  │ │    │ │ Controllers │ │
│ └─────────────┘ │    │ └─────────────┘ │
│ ┌─────────────┐ │    │ ┌─────────────┐ │
│ │  Services   │ │    │ │  Services   │ │
│ └─────────────┘ │    │ └─────────────┘ │
└─────────────────┘    └─────────────────┘
         │                       │
         └───────────┬───────────┘
                     │
           ┌─────────────────┐
           │    Database     │
           └─────────────────┘
\`\`\`

## 📦 Componentes Principales
1. **[Componente]**: [Responsabilidad]
   - Dependencias: [Lista]
   - Expone: [APIs/interfaces]

## 🔄 Flujos Críticos
1. **[Proceso]**: [Descripción]
   - Input: [Datos de entrada]
   - Process: [Pasos del procesamiento]
   - Output: [Resultado]
\`\`\`

### analysis/workflows/$timestamp-user-flows.md:
\`\`\`markdown
# 🔄 FLUJOS DE USUARIO

## 👤 Flujos Principales
1. **[Acción de Usuario]**:
   \`\`\`
   Usuario → Component A → Service B → API C → Database
           ← Response  ← Process ← Data ← Query
   \`\`\`

## 📊 Flujos de Datos
\`\`\`
Data Source → Validation → Processing → Storage → Presentation
\`\`\`
\`\`\`

## 🎯 VISUALIZACIONES ESPECÍFICAS:
- Usa ASCII art para diagramas
- Crea mapas de dependencias
- Identifica puntos de fallo únicos
- Mapea flujos de autenticación
- Documenta ciclos de vida de datos

¡Crea mapas arquitectónicos visuales!" \
        --allowedTools "Read" "Write" \
        "Bash(find:*)" "Bash(ls:*)" "Bash(grep:*)" "Bash(cat:*)" \
        "Bash(rg:*)" \
        "sequential-thinking"

    log_success "Fase 4 (Arquitecturar) completada"
}

# Phase 5: Reportar - Executive summary and recommendations
phase_reportar() {
    local repo_path="${1:-.}"
    local timestamp=$(date +%Y%m%d)

    log_phase "📊 FASE 5: REPORTAR - Resumen Ejecutivo"

    claude "MODO: REPORTE EJECUTIVO (R.A.D.A.R. FASE 5)

REPOSITORIO: $repo_path

## 🎯 TU MISIÓN: REPORTE EJECUTIVO Y RECOMENDACIONES

Sintetiza todo el análisis en un reporte ejecutivo con recomendaciones accionables.

## 📋 CONTENIDO DEL REPORTE:

### 1. 🎯 EXECUTIVE SUMMARY
- Resumen en 3 párrafos de qué es el proyecto
- Fortalezas principales identificadas
- Challenges principales encontrados
- Evaluación general de calidad

### 2. 📊 EVALUACIÓN TÉCNICA
- Puntuación de arquitectura (1-10)
- Puntuación de código (1-10)
- Puntuación de documentación (1-10)
- Puntuación de testing (1-10)

### 3. 💡 RECOMENDACIONES
- Top 3 mejoras técnicas
- Top 3 mejoras de proceso
- Roadmap sugerido (corto/medio/largo plazo)

### 4. 🚀 ONBOARDING PLAN
- Plan de 30-60-90 días para nuevo desarrollador
- Recursos de aprendizaje recomendados
- Mentoring suggestions

## 📊 FORMATO DE SALIDA:

### analysis/reports/$timestamp-executive-summary.md:
\`\`\`markdown
# 📊 REPORTE EJECUTIVO - ANÁLISIS R.A.D.A.R.

**Proyecto**: [Nombre del proyecto]
**Análisis completado**: [Fecha]
**Metodología**: R.A.D.A.R. (Reconocer, Analizar, Documentar, Arquitecturar, Reportar)

## 🎯 EXECUTIVE SUMMARY

### Propósito del Proyecto
[Descripción en 2-3 líneas del propósito central]

### Evaluación General
[Evaluación holística del estado del proyecto]

### Recomendación General
**VEREDICTO**: [EXCELENTE|BUENO|REGULAR|NECESITA MEJORAS|CRÍTICO]

## 📊 SCORECARD TÉCNICO

| Aspecto | Puntuación | Comentario |
|---------|------------|------------|
| **Arquitectura** | X/10 | [Comentario breve] |
| **Calidad de Código** | X/10 | [Comentario breve] |
| **Documentación** | X/10 | [Comentario breve] |
| **Testing** | X/10 | [Comentario breve] |
| **Configuración** | X/10 | [Comentario breve] |
| **Mantenibilidad** | X/10 | [Comentario breve] |

**PUNTUACIÓN TOTAL**: X/60

## 💪 FORTALEZAS IDENTIFICADAS
1. **[Fortaleza]**: [Explicación]
2. **[Fortaleza]**: [Explicación]
3. **[Fortaleza]**: [Explicación]

## ⚠️ AREAS DE MEJORA
1. **[Area]**: [Problema] → [Solución sugerida]
2. **[Area]**: [Problema] → [Solución sugerida]
3. **[Area]**: [Problema] → [Solución sugerida]

## 🚨 RIESGOS IDENTIFICADOS
- **[Riesgo]**: [Impacto] - [Mitigación]
- **[Riesgo]**: [Impacto] - [Mitigación]

## 🎯 ROADMAP RECOMENDADO

### 🔥 CORTO PLAZO (1-4 semanas)
- [ ] [Acción específica]
- [ ] [Acción específica]

### 📈 MEDIO PLAZO (1-3 meses)
- [ ] [Acción específica]
- [ ] [Acción específica]

### 🚀 LARGO PLAZO (3-6 meses)
- [ ] [Acción específica]
- [ ] [Acción específica]

## 👥 PLAN DE ONBOARDING

### 👶 PRIMEROS 30 DÍAS
- Semana 1: [Objetivos]
- Semana 2: [Objetivos]
- Semana 3-4: [Objetivos]

### 🏃 SIGUIENTES 30 DÍAS (60 días total)
- [Objetivos y metas]

### 🎯 SIGUIENTES 30 DÍAS (90 días total)
- [Objetivos y contribuciones esperadas]

## 📚 RECURSOS RECOMENDADOS
- **Documentación**: [Enlaces a docs críticas]
- **Learning Path**: [Recursos de aprendizaje]
- **Tools**: [Herramientas recomendadas]

## 🤝 SIGUIENTE PASO INMEDIATO
**ACCIÓN RECOMENDADA**: [Qué hacer primero]
\`\`\`

## 🎯 INSTRUCCIONES ESPECÍFICAS:
- Basa las evaluaciones en evidencia concreta del análisis
- Sé específico en las recomendaciones (no generalidades)
- Prioriza por impacto vs esfuerzo
- Incluye timelines realistas
- Considera el contexto del equipo y recursos

¡Genera el reporte ejecutivo definitivo!" \
        --allowedTools "Read" "Write" \
        "Bash(find:*)" "Bash(ls:*)" "Bash(grep:*)" "Bash(cat:*)" \
        "sequential-thinking"

    log_success "Fase 5 (Reportar) completada"
}

# Full R.A.D.A.R. analysis
full_analysis() {
    local repo_path="${1:-.}"

    log_radar "🎯 INICIANDO ANÁLISIS COMPLETO R.A.D.A.R."
    log_info "Repositorio: $(realpath "$repo_path")"

    setup_analysis_directories "$repo_path"

    log_radar "Ejecutando todas las fases secuencialmente..."

    phase_reconocer "$repo_path"
    phase_analizar "$repo_path"
    phase_documentar "$repo_path"
    phase_arquitecturar "$repo_path"
    phase_reportar "$repo_path"

    log_radar "✅ ANÁLISIS R.A.D.A.R. COMPLETADO"
    log_info "Revisa los resultados en: $(realpath "$repo_path")/analysis/"

    # Show summary of generated files
    log_info "Archivos generados:"
    find "$repo_path/analysis" -type f -name "*.md" 2>/dev/null | sort | while read -r file; do
        log_success "📄 $file"
    done
}

# Main script logic
main() {
    if [ $# -eq 0 ]; then
        show_usage
        exit 1
    fi

    local command="$1"
    local repo_path="${2:-.}"

    # Check prerequisites
    check_claude_availability
    check_repository_structure "$repo_path"

    case $command in
        "analyze")
            full_analysis "$repo_path"
            ;;
        "discover")
            setup_analysis_directories "$repo_path"
            phase_reconocer "$repo_path"
            ;;
        "examine")
            setup_analysis_directories "$repo_path"
            phase_analizar "$repo_path"
            ;;
        "document")
            setup_analysis_directories "$repo_path"
            phase_documentar "$repo_path"
            ;;
        "guide")
            setup_analysis_directories "$repo_path"
            phase_arquitecturar "$repo_path"
            ;;
        "report")
            setup_analysis_directories "$repo_path"
            phase_reportar "$repo_path"
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