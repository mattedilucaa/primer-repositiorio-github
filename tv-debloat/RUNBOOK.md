# Manual paso a paso — limpieza de la TopHouse TV por ADB

Tele: TopHouse TV, IP `192.168.18.153`. Depuración USB/inalámbrica ya activada.

Importante: estos comandos los ejecutas TÚ en tu ordenador (el que está en la
misma red que la tele). Pega aquí en el chat la salida de cada paso y te digo
el siguiente, para respetar lo de "tandas pequeñas + comprobar antes de seguir".

## a) Instalar adb y conectar

### Windows
1. Descarga "SDK Platform-Tools for Windows" desde la web oficial de Android:
   https://developer.android.com/tools/releases/platform-tools
2. Descomprime el zip, por ejemplo en `C:\platform-tools`.
3. Añade esa carpeta al PATH (Panel de control → Sistema → Configuración
   avanzada → Variables de entorno → Path → Nueva → `C:\platform-tools`).
4. Abre una terminal nueva (cmd o PowerShell) y comprueba: `adb version`.

### macOS
```
brew install android-platform-tools
```

### Linux
```
sudo apt update && sudo apt install -y adb
```

### Conectar con la tele
Si tu Android es 11+ y la pantalla de "Depuración inalámbrica" te pide un
código de emparejamiento, primero:
```
adb pair <IP-tele>:<puerto-de-emparejamiento>
```
(el puerto de emparejamiento lo enseña la propia tele, es distinto del 5555).

Luego, siempre:
```
adb connect 192.168.18.153:5555
```
La tele va a mostrar un diálogo "¿Permitir la depuración desde este
ordenador?" — acéptalo en la tele con el mando. Avísame cuando lo hayas
aceptado y me confirmes `adb devices` mostrando el dispositivo como
`device` (no `unauthorized`).

## b) Medir antes de tocar nada

```
cd tv-debloat/scripts
chmod +x medir.sh desactivar-tanda.sh deshacer-todo.sh
TV_IP=192.168.18.153 ./medir.sh antes
```

Pégame el contenido de `tv-debloat/medidas/antes-*.txt` (o al menos el
resumen de `dumpsys meminfo` y el número de paquetes de sistema).

## c) Clasificar y aprobar

Con la lista de `pm list packages -s`, te la voy a devolver en una tabla de
3 grupos:
1. **Basura segura** (streaming no usado, demos, salvapantallas, asistentes
   de voz/configuración, telemetría).
2. **Depende de ti** (te pregunto uno a uno si lo usas).
3. **Intocable** (ver `PROTECTED-PACKAGES.txt`).

Nada se desactiva sin tu OK explícito grupo por grupo.

## d) Desactivar en tandas de máximo 10

```
TV_IP=192.168.18.153 ./desactivar-tanda.sh com.paquete.uno com.paquete.dos ...
```

El script:
- Rechaza la tanda si pides más de 10 paquetes.
- Rechaza cualquier paquete que esté en `PROTECTED-PACKAGES.txt`.
- Te pide confirmación antes de tocar nada.
- Anota cada paquete en `disabled.txt` y te da el comando de deshacer
  SOLO esa tanda.

Después de cada tanda, para antes de seguir y comprueba en la tele:
- ¿Funciona el botón Fuentes/Entradas del mando?
- ¿Puedes pasar a HDMI?
- ¿Abren Netflix y YouTube?
- ¿Funciona el sonido?
- ¿Funciona el teclado en pantalla?

Dime "sigue bien" para pasar a la siguiente tanda, o "se rompió X" para
deshacer esa tanda con el comando que te dio el script.

## e) Reducir animaciones a la mitad

```
adb shell settings put global window_animation_scale 0.5
adb shell settings put global transition_animation_scale 0.5
adb shell settings put global animator_duration_scale 0.5
```

## f) Vaciar cachés y reiniciar

```
adb shell pm trim-caches 1000G
adb reboot
```

Espera a que la tele arranque del todo y reconecta:
```
adb connect 192.168.18.153:5555
```

Luego repite la medición:
```
TV_IP=192.168.18.153 ./medir.sh despues
```

## Cambiar la pantalla de inicio a FLauncher

1. **Tú**: instala "FLauncher" desde la Play Store de la tele. Avísame
   cuando esté instalado.
2. **Tú**: ábrelo una vez y, cuando el sistema pregunte por la app de inicio
   por defecto, elige FLauncher (o hazlo desde Ajustes → Apps → App de
   inicio predeterminada → FLauncher). Confírmame que ya es tu pantalla de
   inicio.
3. **Solo entonces**, desactivamos el launcher de Google:
   ```
   adb shell pm disable-user --user 0 com.google.android.apps.tv.launcherx
   ```
   (esto se añade a `disabled.txt` igual que cualquier otra tanda).
4. Reinicia la tele y comprueba que sigue arrancando en FLauncher:
   ```
   adb reboot
   ```

Si algo va mal en este paso, el deshacer es:
```
adb shell pm enable com.google.android.apps.tv.launcherx
```

## Si algo se rompe

1. Reactiva primero la ÚLTIMA tanda con el comando de "undo" que te dio
   `desactivar-tanda.sh` (o mira la entrada correspondiente en
   `DEBLOAT-LOG.md`).
2. Si el problema persiste, ve afinando paquete a paquete con:
   ```
   adb shell pm enable <paquete>
   ```
3. Botón de pánico (reactiva todo lo desactivado hasta ahora):
   ```
   TV_IP=192.168.18.153 ./deshacer-todo.sh
   ```

## Entrega final

Al terminar, te doy:
1. Tabla de RAM antes/después (de `medidas/antes-*.txt` vs `medidas/despues-*.txt`).
2. Lista de paquetes desactivados con una línea de "qué era" (en `disabled.txt` y `DEBLOAT-LOG.md`).
3. El comando único para deshacer todo (`./deshacer-todo.sh`).
