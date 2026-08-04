import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../providers/profile_providers.dart';
import 'widgets/continue_button.dart';

/// Launch screen. On first run it routes to gender selection; returning users
/// with a complete profile are routed to the challenge screen automatically.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _autoAdvanced = false;

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileControllerProvider);
    final profile = profileAsync.valueOrNull;

    // A fully-provisioned user skips onboarding. The router redirect only runs
    // on navigation events, so advance once the async profile finishes loading.
    if (profile != null && profile.isComplete && !_autoAdvanced) {
      _autoAdvanced = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        context.go('/challenge');
      });
    }

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