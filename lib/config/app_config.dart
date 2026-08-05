/// Central app configuration.
///
/// ## Challenge tier API
///
/// Tiers for "La Puerta del Agogé" are served by a Cloudflare Worker so they
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
/// The worker source lives in `cloudflare_worker/index.js`. To change the
/// tiers (e.g. bump Guerrero XP), edit that worker in the Cloudflare dashboard
/// and redeploy — no app rebuild required.
class AppConfig {
  const AppConfig._();

  static const String apiBaseUrl = 'https://la-agoge-tiers.sasigjo3190.workers.dev';

  static const String tiersPath = '/tiers';
}