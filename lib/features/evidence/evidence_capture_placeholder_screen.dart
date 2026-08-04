import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/challenge_providers.dart';

/// Placeholder for feature #3 (evidence capture). The selected tier from the
/// current pending attempt remains associated here.
class EvidenceCapturePlaceholderScreen extends ConsumerWidget {
  const EvidenceCapturePlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attempt = ref.watch(challengeAttemptControllerProvider).valueOrNull;
    final tier = attempt?.tier;

    return Scaffold(
      appBar: AppBar(title: const Text('AGOGE')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.videocam_outlined, size: 64),
            const SizedBox(height: 16),
            Text(
              tier != null
                  ? 'Reto elegido: ${tier.label} (${tier.rank})'
                  : 'Captura de evidencia',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 32),
            const Text('(Evidencia en construcción)'),
          ],
        ),
      ),
    );
  }
}