#!/usr/bin/env bash

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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

# Validate inputs
if [ $# -eq 0 ]; then
    log_error "Usage: $0 <issue_number> [project_area]"
    echo "  issue_number: GitHub issue number to work on"
    echo "  project_area: frontend|worker|database|docs (optional, default: frontend)"
    exit 1
fi

issue=$1
project_area=${2:-"frontend"}

log_info "Starting Claude Code workflow for issue #$issue in $project_area area"

# Validate we're in the correct directory
if [[ ! -f "package.json" ]] || [[ ! -d "src" ]]; then
    log_error "Please run this script from the Janome project root directory"
    exit 1
fi

# Check if Claude Code is available
if ! command -v claude &> /dev/null; then
    log_error "Claude Code not found. Please install Claude Code first."
    log_info "Install with: curl -sSL https://claude.ai/install | sh"
    exit 1
fi

log_success "Environment validated. Starting Claude Code session..."

claude \
  "Working on Janome Agent Dashboard issue #$issue - Project Area: $project_area

## CONTEXTO DEL PROYECTO JANOME
Este es el Panel Administrativo Janome - un sistema de gestión de talleres, asistentes y equipos industriales.
Stack: React + TypeScript + Vite + Supabase + Cloudflare Workers
Protocolo: C.I.D.E.R. (Contextualizar, Iterar, Documentar, Ejecutar, Reflexionar)

## FASE 1: CONTEXTUALIZACIÓN & VALIDACIÓN
- OBLIGATORIO PRIMERO: Lee CLAUDE.md para entender las reglas y estado actual del sistema
- OBLIGATORIO SEGUNDO: Lee _MANIFEST.md y specs/03_DATABASE/_DATABASE_OVERVIEW.md
- OBLIGATORIO TERCERO: Revisa PRs recientemente cerradas/merged para entender el contexto del código actual
- Lee el archivo [FEAT]/[FIX] específico relacionado con issue #$issue en specs/01_FEATURES/
- Verifica que issue #$issue existe y es ejecutable (no bloqueado/duplicado)
- Revisa git status: \`git status --porcelain\` debe estar limpio
- Identifica complejidad: [SIMPLE|MEDIUM|COMPLEX] y estima esfuerzo
- Documenta dependencias: otros issues, archivos críticos, base de datos
- ANTES de continuar: comenta en el issue tu análisis y plan de trabajo

## FASE 2: ANÁLISIS DE IMPACTO
- Verifica que el proyecto compila: \`npm run build\` para establecer estado inicial
- Si project_area='worker': ejecuta tests del worker: \`cd worker && npm test\` y \`npm run build\`
- Si project_area='database': revisa specs/03_DATABASE/ para cambios de schema
- Identifica sistemas afectados y posibles breaking changes
- Si COMPLEX: crea plan detallado en issue y solicita revisión
- Usa context7 para docs de arquitectura y cambios recientes relacionados
- PRIORIDAD: Código simple, eficiente y ágil - evita over-engineering

## FASE 3: IMPLEMENTACIÓN INCREMENTAL
### Para project_area='frontend':
- Verificar que compila: \`npm run build\` después de cambios significativos
- Verificar tipos: \`npm run type-check\` para asegurar TypeScript correcto
- Linting opcional: \`npm run lint\` solo si hay tiempo
- PRIORIDAD: Funcionalidad working + tipos correctos
### Para project_area='worker':
- OBLIGATORIO: Tests después de cada cambio: \`cd worker && npm test\`
- OBLIGATORIO: Build check: \`cd worker && npm run build\`
- OBLIGATORIO: Tipos: \`cd worker && npx tsc --noEmit\`
- Worker es crítico - tests son obligatorios aquí
### Para project_area='database':
- Aplicar cambios en orden: migration → functions → testing con Supabase MCP
- Documentar en specs/03_DATABASE/

- Commits incrementales: 'WIP: #$issue - [descripción clara]'
- Actualizar issue cada 2-3 commits con progreso real
- Si bloqueado: documentar en issue y reconsiderar enfoque
- ENFOQUE: Soluciones simples que funcionen, no perfectas

## FASE 4: VALIDACIÓN & LIMPIEZA
### Validación completa:
- FRONTEND: \`npm run build\` debe pasar + \`npm run type-check\` sin errores TypeScript
- WORKER: Si modificado, OBLIGATORIO: \`cd worker && npm test && npm run build\` debe pasar 100%
- Probar funcionalidad en browser: http://localhost:5173/ usando Autobrowser MCP
- Verificar que las funciones de Supabase siguen funcionando (usar MCP si es necesario)

### Limpieza y simplicidad:
- Remover código obsoleto/no usado - mantener codebase limpio
- Simplificar donde sea posible - MENOS es MÁS
- Verificar que no hay breaking changes en APIs críticas
- Self-review: leer TODOS los cambios con perspectiva fresca y pragmática
- OBJETIVO: Código que funciona, no código perfecto

## FASE 5: ENTREGA & DOCUMENTACIÓN
### Si PR existente:
- Actualizar con resumen de cambios
- Forzar push si es necesario: \`git push origin --force-with-lease\`

### Si PR nuevo:
- Crear con template incluyendo:
  * Closes #$issue
  * Testing realizado
  * Breaking changes (si aplica)
  * Screenshots/demos para cambios UI
  * Actualización de documentación requerida

### Documentación:
- OBLIGATORIO: Actualizar archivo [LOG] correspondiente en specs/02_LOGS/
- Si nuevas funciones/endpoints: documentar en specs/ apropiado
- Seguir protocolo C.I.D.E.R. para documentación

## MANEJO DE ERRORES & LÍMITES
- Si cualquier fase falla: PARAR, documentar en issue, pedir orientación
- Si build falla: arreglar inmediatamente o rollback a último estado funcional
- Si worker tests fallan: OBLIGATORIO arreglar antes de continuar
- Si complejidad excede estimación: actualizar issue y considerar división
- Máximo 90 minutos de trabajo (pedir continuación si es necesario)
- NUNCA commitear código que rompa el build
- NUNCA commitear cambios de worker sin tests pasando

## HERRAMIENTAS ESPECÍFICAS JANOME
- Base de datos: usar Supabase MCP, aplicar migraciones en orden
- Workers: deployar solo después de testing completo - CRÍTICO
- Frontend: usar hooks existentes, seguir patrones establecidos, SIMPLICIDAD
- Documentación: mantener specs/ actualizado según protocolo C.I.D.E.R.
- PRs: revisar PRs recientes merged/closed para entender el contexto del código actual

## FILOSOFÍA DE DESARROLLO JANOME
- SIMPLICIDAD sobre complejidad
- FUNCIONALIDAD sobre perfección
- AGILIDAD sobre documentación excesiva
- WORKING CODE sobre código elegante
- Tests SOLO donde son críticos (worker)

## TIMEZONE IMPORTANTE
- SIEMPRE usar timezone America/Santiago para fechas
- Verificar conversiones UTC ↔ Chile en código de fechas

¡Procede siguiendo este protocolo estrictamente!" \
  --allowedTools "Edit" "Write" "Read" \
  "Bash(gh:*)" "Bash(rg:*)" "Bash(find:*)" "Bash(ls:*)" "Bash(grep:*)" "context7:*" \
  "Bash(npm:*)" "Bash(git:*)" "Bash(cd:*)" "Bash(npx:*)" \
  "mcp_browsermcp_browser_*"  "fetch_pull_request" \
  "sequential-thinking"

# Log completion
if [ $? -eq 0 ]; then
    log_success "Claude Code session completed for issue #$issue"
    log_info "Check the issue comments and any new PR for results"
else
    log_error "Claude Code session failed for issue #$issue"
    exit 1
fi