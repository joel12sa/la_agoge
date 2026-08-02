# Feedback — Onboarding (Feature #1)

Este documento describe la retroalimentación (feedback) que se muestra al usuario
al completar la selección de género y arquetipo durante el onboarding.

> Nota de alcance: este feedback fue concebido como pantalla de confirmación,
> pero quedó documentado aquí para su implementación futura. No está en el código
> de la app.

## Propuesta

Al terminar la selección de arquetipo, mostrar un paso de confirmación que
resuma las elecciones del usuario antes de cruzar hacia la selección de reto
(feature #2).

## Contenido

- Título: **"Tu camino está marcado"**
- Card **CAMINO**: muestra el icono del género (♂ / ♀) y la etiqueta del grupo
  (`se forjan guerreros` / `se forjan guerreras`).
- Card **ARQUETIPO**: muestra el arquetipo elegido:
  - Male track → **Depredador**
  - Female track → **Arquitecta**
- Texto motivacional de confirmación.
- CTA final: **"ENTRAR"** que navega a `/challenge`.

## Estado

| Paso                  | Estado |
|-----------------------|--------|
| Género                | ✅ implementado |
| Arquetipo             | ✅ implementado |
| Pantalla de feedback  | 📝 documentado (pendiente de implementar) |