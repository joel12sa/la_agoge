import 'package:flutter/material.dart';

import '../../../models/challenge_tier.dart';

/// Selectable card for a single challenge tier: burpee count, rank label, and
/// the XP reward granted on completion.
class TierCard extends StatelessWidget {
  const TierCard({
    super.key,
    required this.tier,
    required this.selected,
    required this.onTap,
  });

  final ChallengeTier tier;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: selected ? colorScheme.primaryContainer : colorScheme.surface,
            border: Border.all(
              color: selected ? colorScheme.primary : colorScheme.outline,
              width: 2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tier.label,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: selected
                              ? colorScheme.onPrimaryContainer
                              : colorScheme.onSurface,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tier.rank,
                    style: TextStyle(
                      color: selected
                          ? colorScheme.onPrimaryContainer
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              Text(
                tier.rewardText,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: selected
                          ? colorScheme.onPrimaryContainer
                          : colorScheme.primary,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}