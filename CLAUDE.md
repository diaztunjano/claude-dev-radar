# 🤖 CLAUDE DEVELOPMENT GUIDE
## Panel Administrativo Janome Chile - Instrucciones para IA

## **CONTEXTO DE NEGOCIO:**
**Janome Chile** es una empresa especializada en la **venta de máquinas de coser** que ofrece **cursos y talleres educativos** a sus clientes para maximizar el aprovechamiento de sus productos.

### **🎯 PROPÓSITO DE LA APLICACIÓN**
Esta aplicación es un **Panel Administrativo centralizado** que permite:
- **Gestionar talleres**: Crear, editar, programar y organizar talleres de costura
- **Gestionar inscripciones**: Inscribir personas, controlar cupos y estados de participación
- **Automatización WhatsApp**: Sistema de recordatorios automáticos para optimizar asistencia
- **Control de asistencia**: Seguimiento de confirmados, asistentes y cancelados en tiempo real

### **📊 VALOR DE NEGOCIO**
- **Eficiencia operativa**: Reducción significativa del tiempo de gestión manual
- **Mayor control**: Centralización de toda la información de talleres en un solo lugar
- **Métricas informadas**: Generación de estadísticas de impacto para toma de decisiones
- **Optimización de recursos**: Mejor planificación basada en datos históricos de asistencia

### **🚀 ESTADO DEL PROYECTO**
- **Versión actual**: v1.0 entregada y operativa en producción
- **Estrategia de desarrollo**: Releases graduales con nuevas funcionalidades
- **Metodología**: Desarrollo iterativo basado en feedback del cliente
- **Objetivo**: Evolución continua del sistema con mejoras incrementales

---

## 🚨 **PROTOCOLO OBLIGATORIO ANTES DE CUALQUIER TAREA**

### **1. CONTEXTUALIZACIÓN INMEDIATA**
```bash
# SIEMPRE leer primero estos archivos en este orden:
1. specs/00_SYSTEM/_MANIFEST.md          # Estado global del sistema
2. specs/03_DATABASE/_DATABASE_OVERVIEW.md   # Estado de la base de datos
3. El archivo específico de la tarea en specs/01_FEATURES/
```

### **2. VERIFICACIÓN DE ESTADO**
- ✅ **Sistema en PRODUCCIÓN**: Todos los componentes funcionando
- ✅ **Base de Datos**: 22 funciones sincronizadas en Supabase
- ✅ **Worker Cloudflare**: Sistema recordatorios WhatsApp operativo
- ✅ **Frontend React**: Panel administrativo completo

---

## 🗂️ **ESTRUCTURA DE DOCUMENTACIÓN - NAVEGACIÓN RÁPIDA**

### **📁 specs/00_SYSTEM/** - Configuración del sistema
- `_MANIFEST.md` → **PUNTO DE ENTRADA PRINCIPAL**
- `executive-summary.md` → Resumen ejecutivo
- `desarrollo-aplicacion.md` → Guías de desarrollo

### **📁 specs/01_FEATURES/** - Tareas y funcionalidades
- `[FEAT]-(dd-mm-YYYY)-*.md` → Nuevas funcionalidades
- `[FIX]-(dd-mm-YYYY)-*.md` → Correcciones y fixes
- `[PLAN]-(dd-mm-YYYY)-*.md` → Planes de implementación

### **📁 specs/03_DATABASE/** - ⭐ **FUNCIONES REALES DE SUPABASE**
- `_DATABASE_OVERVIEW.md` → **ÍNDICE COMPLETO DE LA BD**
- `talleres-functions.sql` → 6 funciones de talleres
- `asistentes-functions.sql` → 3 funciones de asistentes
- `recordatorios-functions.sql` → 5 funciones WhatsApp
- `users-whatsapp-functions.sql` → 2 funciones IA
- `triggers-functions.sql` → 5 funciones de validación

---

## 🎯 **INSTRUCCIONES ESPECÍFICAS POR TIPO DE TAREA**

### **🔧 DESARROLLO DE FUNCIONALIDADES**
```bash
1. Leer specs/01_FEATURES/[FEAT]-nombre-tarea.md
2. Verificar funciones de BD en specs/03_DATABASE/
3. Consultar Supabase MCP si necesitas confirmación
4. Implementar siguiendo arquitectura existente
5. Actualizar documentación correspondiente
```

### **🐛 DEBUGGING Y FIXES**
```bash
1. Consultar specs/03_DATABASE/_DATABASE_OVERVIEW.md
2. Usar MCP para verificar estado real en Supabase
3. Revisar logs del Worker si es tema de recordatorios
4. Aplicar fix y documentar en specs/02_LOGS/
```

### **📊 CONSULTAS DE BASE DE DATOS**
```bash
1. NUNCA asumir funciones - consultar specs/03_DATABASE/
2. Usar MCP de Supabase para verificar datos reales
3. Todas las fechas en timezone America/Santiago
4. Funciones críticas usan SECURITY DEFINER
```

---

## 🚀 **STACK TECNOLÓGICO ACTUAL**

### **Frontend** (src/)
- **React 19** + TypeScript + Vite
- **Tailwind CSS** + Radix UI + shadcn/ui
- **Supabase Client** para BD y Auth
- **React Router** para navegación

### **Backend** (Supabase)
- **PostgreSQL 15.8.1.093** en us-east-1
- **22 funciones SQL** organizadas por temática
- **9 triggers activos** para validaciones
- **RLS policies** para seguridad

### **Worker** (worker/)
- **Cloudflare Worker** desplegado en producción
- **Sistema de recordatorios** WhatsApp automático
- **Cron jobs** (3 días, 1 día, 2 horas)
- **Bulk endpoint** para envío masivo

---

## 🔗 **INTEGRACIÓN SUPABASE MCP**

### **Comandos Disponibles**
```bash
# Ejecutar SQL directo
mcp_supabase_execute_sql(project_id, query)

# Listar funciones
mcp_supabase_list_functions()

# Obtener estadísticas
mcp_supabase_get_advisors(project_id, type)

# Aplicar migraciones
mcp_supabase_apply_migration(project_id, name, query)
```

### **Proyecto Supabase**
- **ID**: `rqholbdnefyfokrozkih`
- **URL**: `https://rqholbdnefyfokrozkih.supabase.co`
- **Región**: us-east-1

---

## ⚡ **COMANDOS DE DESARROLLO RÁPIDO**

### **Desarrollo Local**
```bash
npm install          # Instalar dependencias
npm run dev         # Servidor desarrollo (localhost:5173)
npm run build       # Build producción
npm run lint        # Linter
```

### **Testing Worker**
```bash
# Health check completo
curl https://janome-whatsapp-reminders-production.oficina-c3f.workers.dev/health

```


---

## 🚨 **REGLAS CRÍTICAS PARA CLAUDE**

### **❌ NO HACER NUNCA**
- No asumir funciones de BD sin consultar specs/03_DATABASE/
- No crear archivos en src/db/ (usar specs/03_DATABASE/)
- No ignorar timezone America/Santiago en fechas

### **✅ HACER SIEMPRE**
- Leer _MANIFEST.md antes de cualquier tarea
- Verificar funciones reales en Supabase via MCP
- Documentar cambios en specs/ apropiados
- Testear en browser si hay cambios de UI
- Seguir convención de nombres [FEAT], [FIX], [LOG]
- Crear archivos de documentacion utilizando formato [FEAT/FIX/PLAN]-(dd-mm-YYYY)-documentation_name.md
-  **ALWAYS find and fix the root cause** of issues instead of creating workarounds
- When debugging issues, focus on fixing the existing implementation, not replacing it
- When something doesn't work, debug and fix it - don't start over with a simple version

### **🔄 FLUJO DE TRABAJO**
1. **Contextualizar** → Leer documentación relevante
2. **Iterar** → Proponer solución y discutir
3. **Documentar** → Actualizar specs apropiados
4. **Ejecutar** → Implementar código limpio
5. **Reflexionar** → Crear LOG si es tarea mayor

---

## 📋 **ESTADO ACTUAL DEL SISTEMA**

### **✅ COMPLETAMENTE FUNCIONAL**
- 🤖 **Sistema Recordatorios WhatsApp**: Worker + BD + Frontend
- 👥 **Gestión Usuarios**: Auth + Roles + Estados
- 🎯 **Gestión Talleres**: CRUD + Validaciones + Estados
- 🔧 **Triggers BD**: Cupos + Validaciones + Timestamps

### **🔄 EN OPERACIÓN**
- 📱 **Panel Admin**: React app en localhost:5173
- 🗃️ **Base Datos**: PostgreSQL con 22 funciones
- 🤖 **WhatsApp IA**: Integración n8n funcional

### **💡 WORKFLOW BEST PRACTICES**
- Al trabajar una github issue, debemos empezar analizando que se realizará y luego escribiendo el plan en la carpeta /specs siguiendo la nomenclatura.