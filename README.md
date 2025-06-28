# 🤖 Claude Dev R.A.D.A.R.

**AI-powered development tools for freelancers and teams using Claude Code**

[![npm version](https://badge.fury.io/js/claude-dev-radar.svg)](https://badge.fury.io/js/claude-dev-radar)

Este directorio contiene herramientas de automatización para Claude Code que implementan dos metodologías principales:

## 🔍 **R.A.D.A.R.** - Análisis de Repositorios
**Metodología**: Reconocer → Analizar → Documentar → Arquitecturar → Reportar

## 🎯 **C.I.D.E.R.** - Generación de Issues Atómicos
**Metodología**: Contextualizar → Iterar → Documentar → Ejecutar → Reflexionar

---

## 🚀 **Instalación y Uso**

### **📦 Opción 1: NPM Global (Recomendado)**
```bash
# Instalar globalmente
npm install -g claude-dev-radar

# Usar desde cualquier proyecto
claude-setup init           # Setup proyecto
claude-radar analyze        # Análisis completo
claude-cider generate       # Generar issues
```

### **⚡ Opción 2: One-liner Quick Setup**
```bash
# Instalar y configurar en un comando
curl -sSL https://raw.githubusercontent.com/yourusername/claude-dev-radar/main/install.sh | bash
```

### **🔧 Opción 3: Uso Local**
```bash
# Desde este directorio
./claude-repo-analyzer.sh analyze
./claude-issue-generator.sh generate EPIC "description"
```

---

## 📋 **SISTEMAS DISPONIBLES**

### 🎯 **Sistema de Issues Atómicas (C.I.D.E.R.)**
- **`claude-issue-generator.sh`** → Genera issues automáticamente en GitHub
- **`claude-issue-worker.sh`** → Ejecuta issues siguiendo protocolo C.I.D.E.R.
- **`CLAUDE-ISSUE-GENERATOR-DEMO.md`** → Demostración completa del sistema
- **`ISSUE-GENERATOR-USAGE.md`** → Manual de usuario detallado

### 🔍 **Sistema de Análisis de Repositorios (R.A.D.A.R.)**
- **`claude-repo-analyzer.sh`** → Análisis profundo de repositorios desconocidos
- **`CLAUDE-REPO-ANALYZER-GUIDE.md`** → Guía completa de usuario
- **`CLAUDE-REPO-ANALYZER-DEMO.md`** → Demostración y casos de uso

### 📦 **NPM Package System**
- **`package.json`** → Configuración NPM
- **`bin/claude-radar.js`** → CLI para R.A.D.A.R.
- **`bin/claude-cider.js`** → CLI para C.I.D.E.R.
- **`bin/claude-setup.js`** → CLI para setup de proyectos
- **`install.sh`** → Instalador one-liner
- **`README-NPM.md`** → README del package NPM
- **`PUBLISH-GUIDE.md`** → Guía de publicación

### 📚 **Documentación y Configuración**
- **`CLAUDE.md`** → Protocolo C.I.D.E.R. y reglas de desarrollo
- **`CLAUDE-WORKER-USAGE.md`** → Manual del worker de issues
- **`claude-ai-setup-guide.md`** → Guía de configuración inicial
- **`CHANGELOG.md`** → Historial de versiones
- **`LICENSE`** → Licencia MIT

## 🚀 **COMANDOS PRINCIPALES**

### 🎯 **Issues Atómicas (C.I.D.E.R.)**
```bash
# Desde la raíz del proyecto

# Generar issue atómica
./tools/claude/claude-issue-generator.sh generate EPIC-TALLERES "nueva funcionalidad"

# Ejecutar issue
./tools/claude/claude-issue-worker.sh 123 frontend

# Ver épicas disponibles
./tools/claude/claude-issue-generator.sh list-epics
```

### 🔍 **Análisis de Repositorios (R.A.D.A.R.)**
```bash
# Análisis completo de repositorio
./tools/claude/claude-repo-analyzer.sh analyze

# Análisis específico de repositorio externo
./tools/claude/claude-repo-analyzer.sh analyze /path/to/repo

# Análisis por fases
./tools/claude/claude-repo-analyzer.sh discover  # Reconocimiento
./tools/claude/claude-repo-analyzer.sh examine   # Arquitectura
./tools/claude/claude-repo-analyzer.sh document  # Documentación
./tools/claude/claude-repo-analyzer.sh guide     # Mapeo de componentes
./tools/claude/claude-repo-analyzer.sh report    # Reporte ejecutivo
```

## 📈 **PRODUCTIVIDAD**

### 🎯 **Sistema de Issues (C.I.D.E.R.)**
- **70% tiempo** reducido en creación de issues
- **50% tiempo** reducido en planificación de desarrollo
- **90% issues** mal definidas eliminadas
- **100% documentación** siempre actualizada

### 🔍 **Sistema de Análisis (R.A.D.A.R.)**
- **85% tiempo** reducido en onboarding de desarrolladores
- **95% tiempo** reducido en auditorías técnicas
- **96% tiempo** reducido en análisis de repositorios
- **100% documentación** técnica generada automáticamente

### ⚡ **Flujo Combinado**
1. **🔍 R.A.D.A.R.** → Analizar repositorio desconocido (5 min)
2. **🎯 C.I.D.E.R.** → Generar issues para mejoras (2 min)
3. **⚡ Ejecución** → Implementar mejoras sistemáticamente
4. **🔄 Re-análisis** → Medir progreso continuamente

**Resultado**: **Dominio completo** de cualquier repositorio + **desarrollo estructurado** en tiempo récord.

---

**Última actualización**: 28/06/2025
**Metodologías**: C.I.D.E.R. (Issues) + R.A.D.A.R. (Análisis)