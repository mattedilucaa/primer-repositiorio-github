# Mashup: GTA IV + Mirror's Edge Catalyst (borrador de diseño)

Estado: entrevista de diseño en curso. Todavía no se construyó ni se probó nada.

## Decisiones tomadas
- **Juego anfitrión:** Grand Theft Auto IV: The Complete Edition. El jugador está en Liberty City.
- **Qué hace el jugador en el primer minuto:** free-run inmediato. Niko aparece en un techo de Algonquin con los movimientos de parkour activados y una ayuda breve de controles en pantalla. No hay menús ni misiones.
- **Qué aporta Mirror's Edge Catalyst (juego requerido):**
  - Sonidos de Faith (pasos, respiración, caídas, viento), leídos de la carpeta de Catalyst del jugador al instalar. No se redistribuye nada de EA.
  - Runner Vision: una línea roja que resalta las cornisas y los caños escalables cercanos.
- **Modo:** solo, un jugador. La Complete Edition no tiene multijugador incorporado.
- **Primera versión (lo básico):** wall-run, vault sobre obstáculos, rodada que evita el daño por caída, sonidos de Faith y Runner Vision.

## Pendiente
- Para versiones futuras: carreras cronometradas y barra de momentum.
- Conectarse a Melty: `game_info` y `search_mashups` para los dos juegos.
- Verificar en la PC con los juegos: motor, versión, loaders (ASI loader / ScriptHookDotNet para GTA IV) y formato de audio de Catalyst (Frostbite).
- Planillas JSON (movimientos, sonidos, hooks), compilación, prueba, captura y publicación en Melty.

## Límites conocidos
- La construcción, la prueba y las capturas necesitan una sesión de Claude Code **local** en la PC donde están instalados los juegos.
