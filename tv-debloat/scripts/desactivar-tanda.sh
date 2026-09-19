#!/usr/bin/env bash
# Desactiva hasta 10 paquetes de una vez con pm disable-user --user 0.
# NUNCA usa pm uninstall. Comprueba la lista de protegidos antes de tocar nada.
#
# Uso:
#   ./desactivar-tanda.sh com.paquete.uno com.paquete.dos ...
#
# Anota cada paquete en disabled.txt y añade el comando de deshacer al final.

set -euo pipefail

TV_IP="${TV_IP:-192.168.18.153}"
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROTEGIDOS="$DIR/PROTECTED-PACKAGES.txt"
DISABLED="$DIR/disabled.txt"

if [ "$#" -eq 0 ]; then
  echo "Uso: $0 <paquete1> [paquete2] ... (máximo 10)"
  exit 1
fi

if [ "$#" -gt 10 ]; then
  echo "ALTO: son más de 10 paquetes. Las reglas piden tandas de máximo 10. Abortando."
  exit 1
fi

# Bloqueo de seguridad: si algún paquete pedido está en la lista de protegidos
# (o es un método de entrada), no se ejecuta nada.
for pkg in "$@"; do
  if grep -qiE "^\s*${pkg}\s*(#|$)" "$PROTEGIDOS" || [[ "$pkg" == *inputmethod* ]]; then
    echo "ALTO: '$pkg' está en la lista de intocables (PROTECTED-PACKAGES.txt). No se toca nada de esta tanda."
    exit 1
  fi
done

adb connect "${TV_IP}:5555" >/dev/null

echo "Se van a desactivar estos paquetes:"
printf '  - %s\n' "$@"
read -r -p "¿Confirmas? (s/N) " CONF
if [[ "$CONF" != "s" && "$CONF" != "S" ]]; then
  echo "Cancelado."
  exit 0
fi

FECHA="$(date +%Y-%m-%d)"
UNDO=""
for pkg in "$@"; do
  echo "Desactivando $pkg ..."
  adb shell pm disable-user --user 0 "$pkg"
  echo "$pkg  # desactivado el $FECHA" >> "$DISABLED"
  UNDO="${UNDO}adb shell pm enable ${pkg}; "
done

echo
echo "Hecho. Para deshacer SOLO esta tanda, ejecuta:"
echo "  $UNDO"
echo
echo "(Recuerda pegar esta línea de 'undo' en DEBLOAT-LOG.md junto con la entrada de esta tanda.)"
