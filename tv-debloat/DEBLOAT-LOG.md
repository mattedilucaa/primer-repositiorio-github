# Registro de limpieza — TopHouse TV (192.168.18.153)

Este archivo es el diario de todo lo que se hace a la tele. Cada entrada
lleva: fecha, qué se hizo, por qué, y el comando exacto para deshacerlo.

Regla de oro: nada se desinstala (`pm uninstall` prohibido). Todo se
desactiva con `pm disable-user --user 0 <paquete>` y se puede revertir con
`pm enable <paquete>`.

## Estado

- [ ] adb instalado y conectado a la tele
- [ ] Medición "antes" tomada (`medidas/antes-*.txt`)
- [ ] Lista de paquetes clasificada (grupo 1 / 2 / 3)
- [ ] Tanda 1 (grupo 1, hasta 10 paquetes)
- [ ] Tanda 2
- [ ] Tanda 3...
- [ ] Animaciones reducidas a 0.5
- [ ] Cachés vaciadas (`pm trim-caches`)
- [ ] Reinicio + medición "después"
- [ ] FLauncher instalado y confirmado por el usuario
- [ ] FLauncher puesto como launcher por defecto (confirmado por el usuario)
- [ ] launcherx desactivado
- [ ] Reinicio final + verificación de que FLauncher sigue siendo el inicio

## Entradas

<!-- Ejemplo de entrada, se borra al añadir la primera real:

### 2026-09-19 — Tanda 1 (grupo 1: streaming no usado)

Desactivados:
- com.ejemplo.app1  — app de streaming que no usas
- com.ejemplo.app2  — demo preinstalada

Comando ejecutado:
    adb shell pm disable-user --user 0 com.ejemplo.app1
    adb shell pm disable-user --user 0 com.ejemplo.app2

Para deshacer esta tanda:
    adb shell pm enable com.ejemplo.app1 && adb shell pm enable com.ejemplo.app2

Verificación del usuario: Fuentes/Entradas OK, Netflix OK, YouTube OK, sonido OK, teclado OK.
-->
