#!/bin/bash

# Script para renombrar archivos en /specs con formato YYYYMMDD-HHmm-[nombre]

echo "🔄 Iniciando renombrado de archivos en /specs..."
echo "Formato: YYYYMMDD-HHmm-[nombre_original]"
echo "---"

# Contador de archivos procesados
count=0
errors=0

# Función para procesar archivos
process_file() {
    local file="$1"
    local dir=$(dirname "$file")
    local basename=$(basename "$file")
    local extension="${basename##*.}"
    local name_without_ext="${basename%.*}"
    
    # Saltar archivos que ya tienen el formato correcto (empiezan con 8 dígitos)
    if [[ "$basename" =~ ^[0-9]{8}- ]]; then
        echo "⏭️  Saltando (ya formateado): $file"
        return
    fi
    
    # Obtener timestamp de creación
    local timestamp=$(stat -f "%B" "$file" 2>/dev/null)
    if [ -z "$timestamp" ]; then
        echo "❌ Error obteniendo fecha de: $file"
        ((errors++))
        return
    fi
    
    # Convertir timestamp a formato deseado
    local formatted_date=$(date -r "$timestamp" "+%Y%m%d-%H%M" 2>/dev/null)
    if [ -z "$formatted_date" ]; then
        echo "❌ Error formateando fecha de: $file"
        ((errors++))
        return
    fi
    
    # Construir nuevo nombre
    # Eliminar prefijos existentes como [FEAT]-, [FIX]-, etc.
    local clean_name="$name_without_ext"
    clean_name=$(echo "$clean_name" | sed -E 's/^\[[A-Z]+\]-//')
    clean_name=$(echo "$clean_name" | sed -E 's/^\([0-9]{2}-[0-9]{2}-[0-9]{4}\)-//')
    clean_name=$(echo "$clean_name" | sed -E 's/^[0-9]{2}-[0-9]{2}-[0-9]{4}-//')
    
    local new_name="${formatted_date}-${clean_name}.${extension}"
    local new_path="${dir}/${new_name}"
    
    # Verificar si el archivo destino ya existe
    if [ -f "$new_path" ] && [ "$file" != "$new_path" ]; then
        echo "⚠️  Archivo destino ya existe: $new_path"
        echo "   Añadiendo sufijo..."
        local suffix=1
        while [ -f "${dir}/${formatted_date}-${clean_name}_${suffix}.${extension}" ]; do
            ((suffix++))
        done
        new_name="${formatted_date}-${clean_name}_${suffix}.${extension}"
        new_path="${dir}/${new_name}"
    fi
    
    # Renombrar archivo
    if [ "$file" != "$new_path" ]; then
        mv "$file" "$new_path"
        if [ $? -eq 0 ]; then
            echo "✅ Renombrado: "
            echo "   De: $file"
            echo "   A:  $new_path"
            ((count++))
        else
            echo "❌ Error al renombrar: $file"
            ((errors++))
        fi
    else
        echo "ℹ️  Sin cambios: $file"
    fi
}

# Procesar todos los archivos .md y .sql en specs/
echo "🔍 Buscando archivos .md y .sql en specs/..."
echo "---"

# Usar find para obtener todos los archivos
while IFS= read -r file; do
    process_file "$file"
done < <(find specs -type f \( -name "*.md" -o -name "*.sql" \) | sort)

echo "---"
echo "📊 Resumen:"
echo "   ✅ Archivos renombrados: $count"
echo "   ❌ Errores: $errors"
echo "   📁 Total procesados: $((count + errors))"

# Mostrar estructura actualizada
echo ""
echo "📁 Nueva estructura de specs/:"
echo "---"
tree specs -I 'node_modules' 2>/dev/null || find specs -type f \( -name "*.md" -o -name "*.sql" \) | sort

echo ""
echo "✨ Proceso completado!"