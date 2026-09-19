#!/usr/bin/env bash
# Reactiva TODOS los paquetes anotados en disabled.txt.
# Es el "botón del pánico": vuelve la tele al estado de fábrica en cuanto a apps.
set -euo pipefail

TV_IP="${TV_IP:-192.168.18.153}"
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DISABLED="$DIR/disabled.txt"

adb connect "${TV_IP}:5555" >/dev/null

grep -v '^\s*#' "$DISABLED" | grep -v '^\s*$' | awk '{print $1}' | while read -r pkg; do
  echo "Reactivando $pkg ..."
  adb shell pm enable "$pkg" || true
done

echo "Listo. Todos los paquetes de disabled.txt han sido reactivados."
