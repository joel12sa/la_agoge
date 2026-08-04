/// A selectable challenge tier in "La Puerta del Agogé".
///
/// Taholds the number of burpees required, the rank it unlocks when completed,
/// and the XP reward granted. Instances are parsed from the remote tier
/// configuration (see `lib/config/app_config.dart`).
class ChallengeTier {
  const ChallengeTier({
    required this.id,
    required this.reps,
    required this.rank,
    required this.xpReward,
  });

  final String id;
  final int reps;
  final String rank;
  final int xpReward;

  /// Card title, e.g. "50 burpees".
  String get label => '$reps burpees';

  /// Reward text, e.g. "+250 XP".
  String get rewardText => '+$xpReward XP';

  ChallengeTier copyWith({int? xpReward}) => ChallengeTier(
        id: id,
        reps: reps,
        rank: rank,
        xpReward: xpReward ?? this.xpReward,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'reps': reps,
        'rank': rank,
        'xp_reward': xpReward,
      };

  factory ChallengeTier.fromJson(Map<String, dynamic> json) => ChallengeTier(
        id: json['id'] as String,
        reps: json['reps'] as int,
        rank: json['rank'] as String,
        xpReward: json['xp_reward'] as int,
      );
}