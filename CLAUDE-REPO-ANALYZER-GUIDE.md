# 🔍 Claude Repository Analyzer - Guía Completa

**Sistema R.A.D.A.R.** para análisis profundo de repositorios desconocidos.

---

## 🎯 **¿QUÉ ES R.A.D.A.R.?**

**R.A.D.A.R.** es una metodología sistemática para analizar repositorios desconocidos:

- **🔍 RECONOCER**: Estructura, propósito, stack tecnológico
- **🧐 ANALIZAR**: Arquitectura, patrones, flujos de datos
- **📝 DOCUMENTAR**: Generar documentación técnica completa
- **🏗️ ARQUITECTURAR**: Mapear componentes y dependencias
- **📊 REPORTAR**: Resumen ejecutivo y recomendaciones

---

## 🚀 **COMANDOS PRINCIPALES**

### 📊 **Análisis Completo (Recomendado)**
```bash
# Análisis completo del repositorio actual
./tools/claude/claude-repo-analyzer.sh analyze

# Análisis de un repositorio específico
./tools/claude/claude-repo-analyzer.sh analyze /path/to/repository
```

### 🔍 **Análisis por Fases**
```bash
# Fase 1: Reconocimiento inicial
./tools/claude/claude-repo-analyzer.sh discover

# Fase 2: Análisis arquitectónico
./tools/claude/claude-repo-analyzer.sh examine

# Fase 3: Generación de documentación
./tools/claude/claude-repo-analyzer.sh document

# Fase 4: Mapeo de componentes
./tools/claude/claude-repo-analyzer.sh guide

# Fase 5: Reporte ejecutivo
./tools/claude/claude-repo-analyzer.sh report
```

---

## 📁 **ESTRUCTURA DE SALIDA**

El sistema genera una estructura organizada en `analysis/`:

```
analysis/
├── architecture/           # Mapas y diagramas técnicos
│   ├── [YYYYMMDD]-02-analisis-arquitectura.md
│   └── [YYYYMMDD]-component-map.md
├── data-models/            # Documentación de modelos de datos
│   └── DATA-MODEL.md
├── onboarding/             # Guías para desarrolladores
│   ├── ARCHITECTURE.md
│   ├── GETTING-STARTED.md
│   └── DEVELOPER-GUIDE.md
├── reports/                # Reportes ejecutivos
│   ├── [YYYYMMDD]-01-reconocimiento.md
│   └── [YYYYMMDD]-executive-summary.md
└── workflows/              # Flujos de usuario y datos
    └── [YYYYMMDD]-user-flows.md
```

---

## 🎯 **CASOS DE USO**

### 💼 **Caso 1: Nuevo Desarrollador en Equipo**
```bash
# Ejecutar análisis completo del proyecto
./tools/claude/claude-repo-analyzer.sh analyze

# Revisar archivos generados:
# 1. analysis/onboarding/GETTING-STARTED.md    → Setup inicial
# 2. analysis/onboarding/DEVELOPER-GUIDE.md    → Convenciones y patrones
# 3. analysis/reports/*-executive-summary.md   → Resumen general
```

### 🔄 **Caso 2: Audit Técnico de Proyecto**
```bash
# Análisis completo con focus en arquitectura
./tools/claude/claude-repo-analyzer.sh analyze

# Archivos clave para audit:
# 1. analysis/architecture/*-02-analisis-arquitectura.md
# 2. analysis/reports/*-executive-summary.md
# 3. analysis/architecture/*-component-map.md
```

### 📚 **Caso 3: Documentación de Legacy Code**
```bash
# Generar documentación técnica desde código existente
./tools/claude/claude-repo-analyzer.sh document

# Documenta automáticamente:
# - Arquitectura del sistema
# - Modelo de datos
# - APIs y endpoints
# - Patrones de desarrollo
```

### 🎯 **Caso 4: Onboarding Automatizado**
```bash
# Generar guías de onboarding completas
./tools/claude/claude-repo-analyzer.sh analyze

# Entrega lista para usar:
# - Plan de 30-60-90 días
# - Setup instructions específicas
# - Recursos de aprendizaje personalizados
```

---

## 📊 **OUTPUTS ESPECÍFICOS**

### 🔍 **Fase 1: Reconocimiento**
**Archivo**: `analysis/reports/[timestamp]-01-reconocimiento.md`

✅ **Qué incluye**:
- Stack tecnológico completo
- Propósito y dominio del proyecto
- Estructura de directorios explicada
- Configuraciones críticas
- Métricas de proyecto (tamaño, complejidad)

### 🧐 **Fase 2: Análisis Arquitectónico**
**Archivo**: `analysis/architecture/[timestamp]-02-analisis-arquitectura.md`

✅ **Qué incluye**:
- Patrones arquitectónicos identificados
- Flujos de datos mapeados
- Modelo de datos documentado
- Integraciones externas
- Puntos críticos del sistema

### 📝 **Fase 3: Documentación Técnica**
**Archivos**: `analysis/onboarding/*.md`

✅ **Qué incluye**:
- `ARCHITECTURE.md`: Documentación técnica completa
- `GETTING-STARTED.md`: Setup y comandos específicos
- `DEVELOPER-GUIDE.md`: Convenciones y mejores prácticas
- `DATA-MODEL.md`: Esquemas y relaciones

### 🏗️ **Fase 4: Mapeo Arquitectónico**
**Archivos**: `analysis/architecture/[YYYYMMDD]-component-map.md`, `analysis/workflows/[YYYYMMDD]-user-flows.md`

✅ **Qué incluye**:
- Diagramas ASCII de componentes
- Mapas de dependencias
- Flujos de usuario críticos
- Integraciones visualizadas

### 📊 **Fase 5: Reporte Ejecutivo**
**Archivo**: `analysis/reports/[YYYYMMDD]-executive-summary.md`

✅ **Qué incluye**:
- Executive summary (3 párrafos)
- Scorecard técnico (puntuaciones 1-10)
- Top 3 fortalezas y áreas de mejora
- Roadmap priorizado (corto/medio/largo plazo)
- Plan de onboarding 30-60-90 días

---

## ⚙️ **REQUISITOS DEL SISTEMA**

### 📋 **Obligatorios**
- ✅ **Claude Code** instalado y autenticado
- ✅ **Git repository** válido con historial
- ✅ Ejecutar desde la raíz del proyecto

### 🔧 **Instalación Claude Code**
```bash
# Si no tienes Claude Code instalado
curl -sSL https://claude.ai/install | sh

# Verificar instalación
claude --version
```

### 📁 **Verificar Estructura**
```bash
# El comando validará automáticamente:
# - Que estés en un repositorio Git
# - Que tengas permisos de escritura
# - Que Claude Code esté disponible
```

---

## 🎯 **FLUJO RECOMENDADO**

### 🚀 **Para Proyectos Nuevos (Primeros 30 minutos)**
```bash
# 1. Análisis completo
./tools/claude/claude-repo-analyzer.sh analyze

# 2. Revisar resumen ejecutivo
cat analysis/reports/*-executive-summary.md

# 3. Seguir getting started
cat analysis/onboarding/GETTING-STARTED.md

# 4. Configurar entorno según guía
# (siguiendo los comandos específicos generados)
```

### 📚 **Para Auditorías Técnicas**
```bash
# 1. Análisis completo
./tools/claude/claude-repo-analyzer.sh analyze

# 2. Focus en arquitectura
cat analysis/architecture/*-02-analisis-arquitectura.md

# 3. Revisar scorecard técnico
grep -A 20 "SCORECARD TÉCNICO" analysis/reports/*-executive-summary.md

# 4. Implementar recomendaciones
grep -A 10 "ROADMAP RECOMENDADO" analysis/reports/*-executive-summary.md
```

---

## 🚨 **TROUBLESHOOTING**

### ❌ **Error: "Claude Code not found"**
```bash
# Instalar Claude Code
curl -sSL https://claude.ai/install | sh
source ~/.bashrc  # o restart terminal
```

### ❌ **Error: "Not a Git repository"**
```bash
# Inicializar Git si es necesario
git init
git add .
git commit -m "Initial commit"
```

### ❌ **Error: "Permission denied"**
```bash
# Hacer ejecutable el script
chmod +x tools/claude/claude-repo-analyzer.sh
```

### ❌ **Análisis incompleto**
```bash
# Ejecutar fases individuales si falla el análisis completo
./tools/claude/claude-repo-analyzer.sh discover
./tools/claude/claude-repo-analyzer.sh examine
# etc.
```

---

## 💡 **TIPS DE PRODUCTIVIDAD**

### ⚡ **Análisis Rápido (5 minutos)**
```bash
# Solo reconocimiento inicial
./tools/claude/claude-repo-analyzer.sh discover
```

### 📊 **Solo Documentación**
```bash
# Si ya conoces el proyecto pero necesitas docs
./tools/claude/claude-repo-analyzer.sh document
```

### 🎯 **Re-análisis Específico**
```bash
# Re-generar solo el reporte ejecutivo
./tools/claude/claude-repo-analyzer.sh report
```

### 📋 **Comparar Versiones**
```bash
# Los timestamps permiten comparar análisis históricos
ls -la analysis/reports/*-executive-summary.md
```

---

## 🏆 **BENEFICIOS CLAVE**

### ⚡ **Productividad**
- **80% reducción** en tiempo de onboarding
- **90% menos preguntas** "¿Cómo funciona esto?"
- **100% documentación** actualizada automáticamente

### 🎯 **Calidad**
- **Análisis sistemático** vs explorativo manual
- **Documentación consistente** en todos los proyectos
- **Mejores decisiones** basadas en evidencia

### 👥 **Equipo**
- **Onboarding estandarizado** para nuevos miembros
- **Auditorías técnicas** consistentes
- **Knowledge transfer** automatizado

---

## 🔄 **INTEGRACIÓN CON WORKFLOW**

### 🎯 **En Proyectos Existentes**
1. Ejecutar análisis R.A.D.A.R.
2. Revisar recomendaciones del reporte ejecutivo
3. Implementar mejoras priorizadas
4. Re-ejecutar análisis para medir progreso

### 🚀 **En Proyectos Nuevos**
1. Clonar/acceder al repositorio
2. Ejecutar análisis completo
3. Seguir getting-started guide generado
4. Usar developer-guide para desarrollo

### 📊 **Para Management**
- Usar executive summaries para reportes de estado
- Scorecards técnicos para comparar proyectos
- Roadmaps para planificación de recursos

---

## 📈 **MÉTRICAS DE ÉXITO**

### 🎯 **KPIs Esperados**
- **Tiempo de setup**: De 2-4 horas → 30 minutos
- **Preguntas de onboarding**: Reducción del 90%
- **Documentación outdated**: 0% (siempre actualizada)
- **Decisiones técnicas**: Basadas en evidencia vs intuición

---

**🎯 ¡Tu nueva arma secreta para dominar cualquier repositorio en minutos, no días!**

Ejecuta `./tools/claude/claude-repo-analyzer.sh analyze` y convierte lo desconocido en familiar instantáneamente.