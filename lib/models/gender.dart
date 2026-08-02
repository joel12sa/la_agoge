import 'package:flutter/material.dart';

enum Gender {
  male('♂'),
  female('♀');

  const Gender(this.icon);

  final String icon;

  static Gender? fromString(String? value) {
    for (final gender in Gender.values) {
      if (gender.name == value) return gender;
    }
    return null;
  }
}

class GenderTrack {
  const GenderTrack._({
    required this.label,
    required this.paletteName,
    required this.seed,
    required this.groupLabel,
  });

  final String label;
  final String paletteName;
  final Color seed;
  final String groupLabel;

  static const male = GenderTrack._(
    label: 'se forjan guerreros',
    paletteName: 'red/black',
    seed: Color(0xFFB71C1C),
    groupLabel: 'guerreros',
  );

  static const female = GenderTrack._(
    label: 'se forjan guerreras',
    paletteName: 'gold/bronze',
    seed: Color(0xFFE0A800),
    groupLabel: 'guerreras',
  );
}

extension GenderTrackExtension on Gender {
  GenderTrack get track => switch (this) {
        Gender.male => GenderTrack.male,
        Gender.female => GenderTrack.female,
      };
}