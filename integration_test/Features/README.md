# AGOGE — Gherkin Feature Suite

Behavior specs for the AGOGE challenge app, derived from `Requerimientos_Tecnicos_App_300_Agoge.docx`.

## Files (build/test in this order)

| # | File | Covers |
|---|---|---|
| 1 | `01_onboarding.feature` | Gender selection, archetype selection, theming |
| 2 | `02_challenge_selection.feature` | "La Puerta del Agogé" — tier selection, XP display |
| 3 | `03_evidence_capture.feature` | Camera-first video/photo capture, restricted gallery fallback, format/size validation, upload resilience |
| 4 | `04_timer.feature` | In-app stopwatch, manual fallback, time immutability |
| 5 | `05_submission.feature` | "Resumen del sacrificio" summary, certification, atomic + idempotent submit |
| 6 | `06_evidence_verification.feature` | Async AI analysis, approve/needs_review/reject outcomes, content moderation |
| 7 | `07_gamification.feature` | XP accumulation, rank thresholds, attempt history |

## Tags

Each feature is tagged (`@onboarding`, `@evidence_capture`, etc.) so you can run subsets, e.g. with Cucumber:

```bash
cucumber --tags "@evidence_capture"
```

## Notes for implementation

- **Camera-first evidence**: `03_evidence_capture.feature` encodes the decision to make in-app camera recording the primary path, with gallery upload only as a time-restricted fallback (files must be recently created) — not a general file picker.
- **Async verification**: `06_evidence_verification.feature` assumes evidence analysis runs as a background job, not inline during submission — the user shouldn't be blocked waiting on the vision model.
- **Undefined in the original mockups, now specified here**: the rejected/needs_review evidence flow, idempotent resubmission on network failure, and rank threshold table — these were gaps in the design and are called out explicitly so step definitions don't get built on assumptions.
- Step definitions are not included — this is the spec layer. Wire it up with Cucumber.js, Behave (Python), or Cucumber-JVM depending on your stack.
