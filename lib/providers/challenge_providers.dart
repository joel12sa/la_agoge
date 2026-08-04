import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

import '../data/challenge_repository.dart';
import '../models/challenge_attempt.dart';
import '../models/challenge_tier.dart';

/// HTTP client used for backend calls. Overridable in tests (e.g. with a
/// `MockClient` from `package:http/testing`).
final httpClientProvider = Provider<Client>((ref) => Client());

/// Repository instance available across the app and overridable in tests.
final challengeRepositoryProvider = Provider<ChallengeRepository>(
  (ref) => const ChallengeRepository(),
);

/// Loads the tier configuration from the backend once and caches it until the
/// provider is invalidated.
final challengeTiersProvider = FutureProvider<List<ChallengeTier>>((ref) async {
  final client = ref.watch(httpClientProvider);
  final repository = ref.watch(challengeRepositoryProvider);
  return repository.fetchTiers(client);
});

/// Holds the pending [ChallengeAttempt] created while selecting a tier.
class ChallengeAttemptNotifier extends AsyncNotifier<ChallengeAttempt> {
  @override
  Future<ChallengeAttempt> build() =>
      ref.read(challengeRepositoryProvider).loadAttempt();

  Future<void> selectTier(ChallengeTier tier) async {
    final attempt = (state.valueOrNull ?? const ChallengeAttempt())
        .withTier(tier);
    state = AsyncData(attempt);
    await ref.read(challengeRepositoryProvider).saveAttempt(attempt);
  }

  Future<void> clear() async {
    state = const AsyncData(ChallengeAttempt());
    await ref.read(challengeRepositoryProvider).saveAttempt(const ChallengeAttempt());
  }
}

final challengeAttemptControllerProvider =
    AsyncNotifierProvider<ChallengeAttemptNotifier, ChallengeAttempt>(
  ChallengeAttemptNotifier.new,
);