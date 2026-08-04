import 'challenge_tier.dart';

enum ChallengeAttemptStatus { pending }

/// A started but not-yet-confirmed challenge.
///
/// Carries a snapshot of the selected [ChallengeTier] so the attempt remains
/// intact even if the remote tier configuration changes or goes offline.
class ChallengeAttempt {
  const ChallengeAttempt({this.tier, this.status = ChallengeAttemptStatus.pending});

  final ChallengeTier? tier;
  final ChallengeAttemptStatus status;

  bool get isPending => status == ChallengeAttemptStatus.pending;

  ChallengeAttempt withTier(ChallengeTier value) =>
      ChallengeAttempt(tier: value, status: status);

  Map<String, dynamic> toJson() => {
        if (tier != null) 'tier': tier!.toJson(),
        if (status == ChallengeAttemptStatus.pending) 'status': 'pending',
      };

  factory ChallengeAttempt.fromJson(Map<String, dynamic> json) =>
      ChallengeAttempt(
        tier: json['tier'] == null
            ? null
            : ChallengeTier.fromJson(json['tier'] as Map<String, dynamic>),
      );
}