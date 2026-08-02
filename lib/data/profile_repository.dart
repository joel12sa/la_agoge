import 'package:shared_preferences/shared_preferences.dart';

import '../models/profile.dart';

/// Persists the [Profile] locally via SharedPreferences.
class ProfileRepository {
  static const _kGender = 'profile.gender';
  static const _kArchetype = 'profile.archetype';

  const ProfileRepository();

  Future<Profile> load() async {
    final prefs = await SharedPreferences.getInstance();
    return Profile.fromJson({
      'gender': prefs.getString(_kGender),
      'archetype': prefs.getString(_kArchetype),
    });
  }

  Future<void> save(Profile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kGender, profile.gender?.name ?? '');
    await prefs.setString(_kArchetype, profile.archetype?.name ?? '');
  }
}