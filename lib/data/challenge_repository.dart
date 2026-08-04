import 'dart:convert';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/app_config.dart';
import '../models/challenge_attempt.dart';
import '../models/challenge_tier.dart';

/// Loads challenge tier configuration from the remote backend and persists the
/// pending [ChallengeAttempt] locally.
class ChallengeRepository {
  static const _kAttempt = 'challenge.attempt';

  const ChallengeRepository();

  /// Fetches the current tier table from `{apiBaseUrl}/tiers`.
  Future<List<ChallengeTier>> fetchTiers(Client client) async {
    final uri = Uri.parse('${AppConfig.apiBaseUrl}${AppConfig.tiersPath}');
    final response = await client.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Failed to load tiers (HTTP ${response.statusCode})');
    }
    final decoded = jsonDecode(response.body) as List<dynamic>;
    return decoded
        .map((item) => ChallengeTier.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<ChallengeAttempt> loadAttempt() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kAttempt);
    if (raw == null) return const ChallengeAttempt();
    return ChallengeAttempt.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> saveAttempt(ChallengeAttempt attempt) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kAttempt, jsonEncode(attempt.toJson()));
  }
}