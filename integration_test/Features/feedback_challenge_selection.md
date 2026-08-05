# Feedback — Selección de Reto (Feature #2)

Este documento describe el feedback que se muestra al usuario al completar
la selección del reto ("La Puerta del Agogé").

## Propuesta

Una pantalla tipo portada ("La Puerta del Agogé") donde el usuario elige el
reto de burpees que asumirá, antes de cruzar hacia la captura de evidencia
(feature #3).

## Contenido

- Título: **"LA PUERTA DEL AGOGE"**
- Subtítulo: "¿Cuántos burpees puedes conquistar?"
- Cards de retos, cada una muestra:
  - Repeticiones, p. ej. **"50 burpees"**
  - Rango, p. ej. **Pre Iniciado**
  - Recompensa, p. ej. **"+250 XP"**
- Selección única: al tocar un card se resalta y los demás se deseleccionan.
- Estado de carga, error y reintento al obtener los retos del backend.
- CTA final según el camino:
  - Track masculino → **"CONTINUAR"**
  - Track femenino → **"ACEPTA EL RETO"**
- Navegación al confirmar → `/evidence` (placeholder de captura de evidencia).
- Acción de "Reiniciar onboarding" en la barra superior.

## Fuente de datos

- Los retos se obtienen del backend: `GET {apiBaseUrl}/tiers`.
  El esquema JSON está documentado en `lib/config/app_config.dart`.
- `AppConfig.apiBaseUrl` apunta a un **Cloudflare Worker**:
  `https://la-agoge-tiers.sasigjo3190.workers.dev`
  (código fuente en `cloudflare_worker/index.js`).

## Estado

| Paso                              | Estado                                   |
|-----------------------------------|------------------------------------------|
| Pantalla "La Puerta del Agogé"    | ✅ implementado                          |
| Cards de retos (50/100/200)       | ✅ implementado                          |
| Selección única + attempt pendiente | ✅ implementado                          |
| Carga de retos desde backend      | ✅ implementado (Cloudflare Worker)      |
| CTA por camino                    | ✅ implementado                          |
| Navegación a `/evidence`          | ✅ implementado (placeholder)            |
