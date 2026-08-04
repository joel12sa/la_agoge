/// Central app configuration.
///
/// ## Challenge tier API
///
/// Tiers for "La Puerta del Agogé" are fetched from a remote endpoint so they
/// are sourced from configuration rather than hardcoded in the UI.
///
/// `GET {apiBaseUrl}/tiers` returns a JSON array, e.g.:
///
/// ```json
/// [
///   { "id": "pre_iniciado", "reps": 50,  "rank": "Pre Iniciado", "xp_reward": 250 },
///   { "id": "iniciado",     "reps": 100, "rank": "Iniciado",     "xp_reward": 500 },
///   { "id": "guerrero",     "reps": 200, "rank": "Guerrero",     "xp_reward": 1200 }
/// ]
/// ```
///
/// TODO(app): replace [apiBaseUrl] with the real backend base URL. On the
/// Android emulator, the host machine is reachable at `http://10.0.2.2:8080`.
class AppConfig {
  const AppConfig._();

  static const String apiBaseUrl = 'http://10.0.2.2:8080';

  static const String tiersPath = '/tiers';
}