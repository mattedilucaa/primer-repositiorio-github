#!/usr/bin/env bash
# Uso: ./medir.sh antes   (o)   ./medir.sh despues
# Guarda dumpsys meminfo, pm list packages -s y pm list packages -d
# en tv-debloat/medidas/<etiqueta>-<fecha>.txt
set -euo pipefail

ETIQUETA="${1:?Uso: ./medir.sh antes|despues}"
TV_IP="${TV_IP:-192.168.18.153}"
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/medidas"
FECHA="$(date +%Y%m%d-%H%M%S)"
SALIDA="$DIR/${ETIQUETA}-${FECHA}.txt"

mkdir -p "$DIR"

echo "Conectando a $TV_IP:5555..."
adb connect "${TV_IP}:5555"

{
  echo "=== dumpsys meminfo ($(date)) ==="
  adb shell dumpsys meminfo
  echo
  echo "=== pm list packages -s (apps de sistema) ==="
  adb shell pm list packages -s
  echo
  echo "=== pm list packages -d (ya desactivadas) ==="
  adb shell pm list packages -d
} > "$SALIDA"

echo "Guardado en: $SALIDA"
