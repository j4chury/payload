#!/bin/bash

# === Ruta de salida ===
DIR="$2"
OUT="$DIR/informe.html"
mkdir -p "$DIR"

# === Comienza el archivo HTML ===
cat <<EOF > "$OUT"
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Informe SPWMCAT</title>
  <style>
    body { background-color: #111; color: #33ff33; font-family: monospace; padding: 20px; }
    h1, h2 { color: #00ffff; border-bottom: 1px solid #555; margin-top: 30px; }
    pre { background-color: #000; border: 1px solid #333; padding: 10px; overflow-x: auto; white-space: pre-wrap; }
    .ascii-cat { color: #ff66cc; margin-bottom: 20px; }
  </style>
</head>
<body>
  <h1>🐾 Informe Forense SPWMCAT</h1>
  <div class="ascii-cat">
    <pre>
     /\_/\  
    ( o.o ) 
     > ^ <
    </pre>
  </div>
EOF

# === Función para añadir secciones ===
function add_section() {
  local title="\$1"
  local command="\$2"
  echo "<h2>$title</h2>" >> "$OUT"
  echo "<div class=\"ascii-cat\"><pre> /\_/\ ( ^_^ ) > ^ < </pre></div>" >> "$OUT"
  echo "<pre>" >> "$OUT"
  eval "$command" 2>&1 | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g' >> "$OUT"
  echo "</pre>" >> "$OUT"
}

# === Agregar secciones forenses ===
add_section "Información del sistema" "uname -a"
add_section "Usuarios conectados" "who"
add_section "Procesos en ejecución" "ps aux --sort=-%mem | head -n 25"
add_section "Puertos abiertos" "ss -tulnp"
add_section "Uso de disco" "df -h"
add_section "Variables de entorno" "printenv"
add_section "Crontabs del sistema" "cat /etc/crontab"
add_section "Historial del root (si existe)" "cat /root/.bash_history"

# === Cierra el HTML ===
cat <<EOF >> "$OUT"
</body>
</html>
EOF

echo "Informe generado en: $OUT"
