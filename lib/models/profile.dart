import 'archetype.dart';
import 'gender.dart';

/// The persisted user profile assembled during onboarding.
class Profile {
  const Profile({this.gender, this.archetype});

  final Gender? gender;
  final Archetype? archetype;

  bool get isComplete =>
      gender != null &&
      (switch (gender!) {
        Gender.male => archetype == Archetype.depredador,
        Gender.female => archetype == Archetype.arquitecta,
      });

  Profile copyWith({Gender? gender, Archetype? archetype}) {
    return Profile(
      gender: gender ?? this.gender,
      archetype: archetype ?? this.archetype,
    );
  }

  Map<String, String> toJson() => {
        if (gender != null) 'gender': gender!.name,
        if (archetype != null) 'archetype': archetype!.name,
      };

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        gender: Gender.fromString(json['gender'] as String?),
        archetype: Archetype.fromString(json['archetype'] as String?),
      );
}