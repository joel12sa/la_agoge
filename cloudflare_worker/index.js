/**
 * AGOGE — challenge tier configuration endpoint.
 *
 * Deployed to Cloudflare Workers:
 *   https://la-agoge-tiers.sasigjo3190.workers.dev
 *
 * The app calls GET /tiers (the worker answers any path) and parses the JSON
 * array with ChallengeTier.fromJson (lib/models/challenge_tier.dart).
 *
 * To change tiers, edit this file in the Cloudflare dashboard and redeploy —
 * the app picks up the new configuration without a rebuild.
 */
export default {
  async fetch(request) {
    const tiers = [
      { id: "pre_iniciado", reps: 50,  rank: "Pre Iniciado", xp_reward: 250 },
      { id: "iniciado",     reps: 100, rank: "Iniciado",     xp_reward: 500 },
      { id: "guerrero",     reps: 200, rank: "Guerrero",     xp_reward: 1200 },
    ];
    return new Response(JSON.stringify(tiers), {
      headers: { 'content-type': 'application/json' },
    });
  }
}
