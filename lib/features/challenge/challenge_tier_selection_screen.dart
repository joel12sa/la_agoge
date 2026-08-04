import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../models/gender.dart';
import '../../../providers/challenge_providers.dart';
import '../../../providers/profile_providers.dart';
import '../onboarding/widgets/continue_button.dart';
import 'widgets/tier_card.dart';

/// "La Puerta del Agogé": choose the burpee challenge tier for the current
/// attempt. Tiers are loaded from the remote configuration; selecting one
/// records a pending attempt before crossing into evidence capture.
class ChallengeTierSelectionScreen extends ConsumerWidget {
  const ChallengeTierSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileControllerProvider).valueOrNull;
    final gender = profile?.gender;
    final tiersAsync = ref.watch(challengeTiersProvider);
    final attempt = ref.watch(challengeAttemptControllerProvider).valueOrNull;
    final selectedTier = attempt?.tier;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AGOGE'),
        actions: [
          IconButton(
            tooltip: 'Reiniciar onboarding',
            icon: const Icon(Icons.restart_alt),
            onPressed: () async {
              await ref.read(profileControllerProvider.notifier).reset();
              await ref.read(challengeAttemptControllerProvider.notifier).clear();
              if (!context.mounted) return;
              context.go('/splash');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'LA PUERTA DEL AGOGE',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                '¿Cuántos burpees puedes conquistar?',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: tiersAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stackTrace) => _ErrorState(
                    message: 'No pudimos cargar los retos.',
                    onRetry: () => ref.invalidate(challengeTiersProvider),
                  ),
                  data: (tiers) => ListView(
                    children: [
                      for (final tier in tiers)
                        TierCard(
                          tier: tier,
                          selected: selectedTier?.id == tier.id,
                          onTap: () => ref
                              .read(challengeAttemptControllerProvider.notifier)
                              .selectTier(tier),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: OnboardingContinueButton(
        enabled: selectedTier != null,
        label: gender == Gender.female ? 'ACEPTA EL RETO' : 'CONTINUAR',
        onPressed: () => context.go('/evidence'),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.cloud_off, size: 48),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: onRetry,
            child: const Text('REINTENTAR'),
          ),
        ],
      ),
    );
  }
}