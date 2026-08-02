import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../providers/profile_providers.dart';
import 'widgets/continue_button.dart';

/// Launch screen. On first run it routes to gender selection; returning users
/// are routed past onboarding automatically.
class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),
              const Icon(Icons.spa, size: 96),
              const SizedBox(height: 16),
              Text(
                'AGOGE',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 6,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'El camino duele. Da igual. Entra.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const Spacer(flex: 3),
              OnboardingContinueButton(
                enabled: profileAsync.hasValue,
                onPressed: () {
                  final profile = profileAsync.valueOrNull;
                  if (profile != null && profile.gender != null) {
                    context.go('/archetype');
                  } else {
                    context.go('/gender');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}