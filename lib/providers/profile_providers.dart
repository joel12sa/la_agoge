import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/profile_repository.dart';
import '../models/archetype.dart';
import '../models/gender.dart';
import '../models/profile.dart';

/// Repository instance available across the app and overridable in tests.
final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => const ProfileRepository(),
);

/// Holds the user [Profile] and the loading state while onboarding data loads.
class ProfileNotifier extends AsyncNotifier<Profile> {
  @override
  Future<Profile> build() => ref.read(profileRepositoryProvider).load();

  Future<void> selectGender(Gender gender) async {
    final current = state.valueOrNull ?? const Profile();
    final next = current.copyWith(gender: gender);
    state = AsyncData(next);
    await _persist(next);
  }

  Future<void> selectArchetype(Archetype archetype) async {
    final current = state.valueOrNull ?? const Profile();
    final next = current.copyWith(archetype: archetype);
    state = AsyncData(next);
    await _persist(next);
  }

  Future<void> reset() async {
    state = const AsyncData(Profile());
    await ref.read(profileRepositoryProvider).save(const Profile());
  }

  Future<void> _persist(Profile profile) =>
      ref.read(profileRepositoryProvider).save(profile);
}

final profileControllerProvider =
    AsyncNotifierProvider<ProfileNotifier, Profile>(
  ProfileNotifier.new,
);