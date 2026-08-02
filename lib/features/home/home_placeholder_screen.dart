import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/profile_providers.dart';
import '../../models/gender.dart';

/// Temporary landing shown once onboarding completes. Feature #2 (challenge
/// tier selection / "La Puerta del Agogé") will replace this screen.
class HomePlaceholderScreen extends ConsumerWidget {
  const HomePlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileControllerProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AGOGE'),
        actions: [
          IconButton(
            tooltip: 'Reiniciar onboarding',
            icon: const Icon(Icons.restart_alt),
            onPressed: () async {
              await ref
                  .read(profileControllerProvider.notifier)
                  .reset();
              if (!context.mounted) return;
              context.go('/splash');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline, size: 64),
            const SizedBox(height: 16),
            Text(
              'Camino: ${profile?.gender?.track.groupLabel ?? '-'}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Arquetipo: ${profile?.archetype?.name ?? '-'}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),
            const Text('Onboarding completado.'),
            const Text('(Challenge en construcción)'),
          ],
        ),
      ),
    );
  }
}