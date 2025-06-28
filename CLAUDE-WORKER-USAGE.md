# 🤖 Claude Issue Worker

Automatización para trabajar en issues con Claude Code siguiendo el protocolo C.I.D.E.R. del proyecto Janome.

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
npm run build         # Build check (criterio principal)
npm run type-check    # Validación TypeScript (obligatorio)
npm run lint          # ESLint (opcional)
```

### Worker
```bash
cd worker && npm test        # Tests del worker
cd worker && npm run build   # Build check
cd worker && npx tsc --noEmit # Type checking
```

### Database
- Revisa `specs/03_DATABASE/` para migraciones
- Aplica cambios en orden: migration → functions → testing

## ⚠️ Características de Seguridad

- **Tiempo límite**: 90 minutos máximo
- **Build obligatorio**: No permite commits que rompan el build
- **Worker tests críticos**: Tests obligatorios solo para worker (crítico)
- **Rollback automático**: Si algo falla, vuelve al estado anterior
- **Validación pragmática**: Build + tipos para frontend, tests completos para worker

## 🇨🇱 Consideraciones Especiales Janome

- **Timezone**: Siempre usa `America/Santiago` para fechas
- **Protocolo C.I.D.E.R.**: Documentación obligatoria en `specs/`
- **Supabase**: Aplica migraciones en orden correcto
- **Workers**: Deploy solo después de testing completo

## 🚀 Filosofía de Desarrollo Janome

- **SIMPLICIDAD** sobre complejidad
- **FUNCIONALIDAD** sobre perfección
- **AGILIDAD** sobre documentación excesiva
- **WORKING CODE** sobre código elegante
- **Tests SOLO** donde son críticos (worker)
- **Contexto REAL**: Lee PRs recientes para entender el código actual

## 📝 Ejemplo de Uso

```bash
# Issue simple de frontend
./claude-issue-worker.sh 456 frontend

# Issue complejo de base de datos
./claude-issue-worker.sh 789 database

# Bug en el worker
./claude-issue-worker.sh 321 worker
```

## 🚨 Troubleshooting

**Error: Claude Code not found**
```bash
# Instalar Claude Code primero
curl -sSL https://example.com/install-claude | bash
```

**Error: Not in project root**
```bash
# Navegar al directorio correcto
cd /path/to/janome-agent-dashboard
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

**Tip**: Este script está optimizado para el flujo de trabajo específico de Janome. Sigue el protocolo C.I.D.E.R. automáticamente y prioriza código simple y funcional sobre perfección teórica. Lee automáticamente CLAUDE.md y PRs recientes para mejor contexto.