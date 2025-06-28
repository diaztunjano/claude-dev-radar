# 🤖 Claude Issue Worker

Automation for working on GitHub issues with Claude Code following structured development practices.

## 🚀 Uso Básico

```bash
# Trabajar en un issue del frontend (por defecto)
./claude-issue-worker.sh 123

# Especificar área del proyecto
./claude-issue-worker.sh 123 frontend
./claude-issue-worker.sh 123 worker
./claude-issue-worker.sh 123 database
./claude-issue-worker.sh 123 docs
```

## 📋 Requisitos Previos

1. **Claude Code instalado**: El script busca `~/.claude/local/claude`
2. **Repositorio limpio**: Sin cambios uncommitted (`git status` limpio)
3. **Desde raíz del proyecto**: Ejecutar desde el directorio principal de Janome

## 🎯 Lo Que Hace el Script

### ✅ Validaciones Automáticas
- Verifica que el issue existe
- Confirma que estás en el directorio correcto
- Valida que Claude Code está disponible
- Establece estado baseline con tests

### 🔄 Flujo de Trabajo Estructurado

**Fase 1: Contextualización**
- Lee `_MANIFEST.md` y documentación relacionada
- Analiza complejidad del issue
- Documenta plan en el issue

**Fase 2: Análisis de Impacto**
- Ejecuta tests baseline
- Identifica sistemas afectados
- Planifica cambios

**Fase 3: Implementación**
- Desarrollo incremental con tests continuos
- Commits frecuentes con progreso documentado
- Validación específica por área de proyecto

**Fase 4: Validación**
- Suite completa de tests
- Lint y type checking
- Pruebas en browser (Autobrowser MCP)

**Fase 5: Entrega**
- Crear/actualizar PR
- Actualizar documentación en `specs/`
- Seguir protocolo C.I.D.E.R.

## 🛠️ Herramientas Específicas por Área

### Frontend
```bash
npm run build         # Build check (primary criterion)
npm run type-check    # TypeScript validation (required)
npm run lint          # ESLint (optional)
```

### Backend
```bash
npm test             # Backend tests
npm run build        # Build check
npx tsc --noEmit     # Type checking (if TypeScript)
```

### Database
- Review database migration files
- Apply changes in order: migration → functions → testing

## ⚠️ Safety Features

- **Time limit**: 90 minutes maximum
- **Build required**: Does not allow commits that break the build
- **Backend tests critical**: Tests mandatory only for backend (critical)
- **Automatic rollback**: If something fails, returns to previous state
- **Pragmatic validation**: Build + types for frontend, complete tests for backend

## 🔧 Project-Specific Considerations

- **Timezone**: Configure appropriate timezone for date handling
- **Documentation**: Maintain project documentation standards
- **Database**: Apply migrations in correct order
- **Services**: Deploy only after complete testing

## 🚀 Development Philosophy

- **SIMPLICITY** over complexity
- **FUNCTIONALITY** over perfection
- **AGILITY** over excessive documentation
- **WORKING CODE** over elegant code
- **Tests ONLY** where they are critical (backend/APIs)
- **REAL CONTEXT**: Read recent PRs to understand current code

## 📝 Ejemplo de Uso

```bash
# Simple frontend issue
./claude-issue-worker.sh 456 frontend

# Complex database issue
./claude-issue-worker.sh 789 database

# Backend bug
./claude-issue-worker.sh 321 backend
```

## 🚨 Troubleshooting

**Error: Claude Code not found**
```bash
# Instalar Claude Code primero
curl -sSL https://example.com/install-claude | bash
```

**Error: Not in project root**
```bash
# Navigate to correct directory
cd /path/to/your-project
./claude-issue-worker.sh 123
```

**Error: Repository not clean**
```bash
# Limpiar cambios pendientes
git stash
# o
git add . && git commit -m "WIP: save current work"
```

## 🎨 Output Colorizado

El script usa colores para facilitar la lectura:
- 🔵 **AZUL**: Información general
- 🟢 **VERDE**: Éxito/completado
- 🟡 **AMARILLO**: Advertencias
- 🔴 **ROJO**: Errores

---

**Tip**: This script is optimized for structured development workflows. It automatically follows development best practices and prioritizes simple, functional code over theoretical perfection. It automatically reads project documentation and recent PRs for better context.