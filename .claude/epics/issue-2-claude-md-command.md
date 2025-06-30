# Issue #2: Crear comando personalizado para CLAUDE.md con metodología completa

**Epic**: EPIC-CLI  
**Created**: 2025-06-29  
**Estimated Time**: 4-6 hours  
**Status**: ✅ COMPLETED  
**GitHub**: https://github.com/diaztunjano/claude-dev-radar/issues/2  
**PR**: https://github.com/diaztunjano/claude-dev-radar/pull/3  
**Completed**: 2025-06-29  

---

## 📝 DESCRIPTION
Crear un comando personalizado para asegurarse que el CLAUDE.md no pierda detalles claves de la metodología de trabajo. Actualmente, cuando se usa `claudio init` en un proyecto y luego `claude init` (Claude IDE), el CLAUDE.md generado no incluye la metodología git ni los workflows establecidos en `.claude/guides/`.

## 🎯 OBJECTIVES
- [x] Crear comando `/init:claude` que genere CLAUDE.md completo
- [x] Incluir metodología git workflow en CLAUDE.md generado
- [x] Incluir metodología C.I.D.E.R. en CLAUDE.md generado
- [x] Asegurar que CLAUDE.md sea autosuficiente para desarrollo

## 📋 TASKS BREAKDOWN
### Phase 1: Investigación y Análisis (1 hour)
- [x] Analizar estructura actual de `.claude/guides/`
- [x] Revisar CLAUDE.md generados por Claude IDE nativo
- [x] Identificar elementos faltantes en CLAUDE.md estándar
- [x] Documentar requisitos para CLAUDE.md completo

### Phase 2: Diseño del Comando (1 hour)
- [x] Diseñar estructura del comando `/init:claude`
- [x] Crear template de CLAUDE.md con metodología completa
- [x] Planificar integración con estructura existente de `.claude/`
- [x] Definir parámetros y opciones del comando

### Phase 3: Implementación (2-3 hours)
- [x] Crear archivo de comando slash en `templates/commands/init/claude.template.md`
- [x] Implementar lógica de generación de CLAUDE.md
- [x] Integrar metodología git workflow
- [x] Integrar metodología C.I.D.E.R.
- [x] Incluir información de epics y estructura del proyecto

### Phase 4: Testing y Validación (1 hour)
- [x] Probar comando en proyecto de prueba
- [x] Validar que CLAUDE.md incluye toda la metodología
- [x] Verificar compatibilidad con Claude IDE
- [x] Ajustes y refinamientos

## 🧪 ACCEPTANCE CRITERIA
- **Criterio 1**: El comando `/init:claude` genera un CLAUDE.md completo con metodología git
- **Criterio 2**: CLAUDE.md incluye workflow de C.I.D.E.R. detallado
- **Criterio 3**: CLAUDE.md es autosuficiente para entender el proyecto y metodología
- **Criterio 4**: El comando funciona en cualquier proyecto con estructura `.claude/`

## 🛠️ TECHNICAL REQUIREMENTS
- **Environment**: Proyecto con estructura `.claude/` ya inicializada
- **Dependencies**: Acceso a archivos en `.claude/guides/`
- **Integration Points**: Claude IDE slash command system

## 📁 FILES TO MODIFY/CREATE
- [x] `templates/commands/init/claude.template.md` - Nuevo comando slash template
- [x] `.claude/guides/claude-init-guide.md` - Documentación del nuevo comando
- [x] `bin/claude-setup.js` - Integración con setup script
- [x] `README.md` - Documentación actualizada

## 🧭 IMPLEMENTATION APPROACH

### 1. Crear Template Base
```markdown
# CLAUDE.md Template Structure
- Project Overview
- Technology Stack
- Development Methodology (C.I.D.E.R.)
- Git Workflow
- Epic Management
- File Structure
- Available Commands
```

### 2. Comando Slash Implementation
```bash
# Structure for .claude/commands/init/claude.md
- Read existing .claude/guides/
- Merge git-workflow.md content
- Merge development-methodology.md content
- Include epic roadmap summary
- Generate comprehensive CLAUDE.md
```

### 3. Content Integration Strategy
- **Git Workflow**: Incluir branch strategy, commit format, commands
- **C.I.D.E.R.**: Incluir protocolo completo de desarrollo
- **Project Context**: Incluir epics activos y estructura
- **Commands**: Incluir todos los slash commands disponibles

## 🔄 C.I.D.E.R. WORKFLOW
### Contextualizar
- [X] Issue created with full context
- [ ] Analizar estructura actual de `.claude/guides/`
- [ ] Revisar CLAUDE.md existentes

### Iterar  
- [ ] Diseñar estructura del comando
- [ ] Planificar template de CLAUDE.md
- [ ] Definir integración con archivos existentes

### Documentar
- [ ] Template de CLAUDE.md documentado
- [ ] Comando slash documentado
- [ ] Guía de uso del comando

### Ejecutar
- [ ] Implementar comando `/init:claude`
- [ ] Crear template completo
- [ ] Integrar metodologías existentes

### Reflexionar
- [ ] Validar que CLAUDE.md es completo
- [ ] Confirmar que no se pierden detalles
- [ ] Optimizar para uso en otros proyectos

## 🚀 GETTING STARTED
To work on this issue, run:
```bash
/cider:work 9751 cli
```

## 📊 DEFINITION OF DONE
- [ ] Comando `/init:claude` funcional y documentado
- [ ] CLAUDE.md generado incluye metodología git completa
- [ ] CLAUDE.md generado incluye metodología C.I.D.E.R. completa  
- [ ] Template es reutilizable para otros proyectos
- [ ] Documentación actualizada con el nuevo comando
- [ ] Testing realizado en proyecto de prueba

## 🎯 BUSINESS VALUE
Este comando asegura que HeyClaudio sea el "asistente perfecto" para trabajar en repos, garantizando que toda la metodología de trabajo se preserve en el CLAUDE.md y esté disponible para Claude IDE nativo.

## 🔗 RELATED FILES
- `.claude/guides/git-workflow.md` - Metodología git a incluir
- `.claude/guides/development-methodology.md` - Metodología C.I.D.E.R. a incluir
- `.claude/epics/epics-roadmap.md` - Información de epics del proyecto

---
*Generated by Claude C.I.D.E.R. system*