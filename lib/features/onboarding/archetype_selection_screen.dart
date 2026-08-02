import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../models/archetype.dart';
import '../../../models/gender.dart';
import '../../../providers/profile_providers.dart';
import 'widgets/continue_button.dart';

/// Step 2: choose the motivational archetype. The set of options and the
/// disclaimer depend on the gender track selected in the previous step.
class ArchetypeSelectionScreen extends ConsumerWidget {
  const ArchetypeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileControllerProvider);
    final profile = profileAsync.valueOrNull;
    final gender = profile?.gender;

    // Guard: archetype selection requires a gender track.
    if (gender == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Elige tu camino primero')),
        body: Center(
          child: ElevatedButton(
            onPressed: () => context.go('/gender'),
            child: const Text('ELEGIR GENERO'),
          ),
        ),
      );
    }

    final options = ArchetypeOption.optionsFor(gender);
    final selected = profile?.archetype;

    return Scaffold(
      appBar: AppBar(title: Text(gender.track.label)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            options.first.prompt,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          ...options.map(
            (option) => _ArchetypeCard(
              label: option.label,
              selected: selected == option.value,
              onTap: () =>
                  ref.read(profileControllerProvider.notifier).selectArchetype(
                        option.value,
                      ),
            ),
          ),
          const SizedBox(height: 24),
          const _Disclaimer(),
        ],
      ),
      bottomNavigationBar: OnboardingContinueButton(
        enabled: selected != null,
        onPressed: () => context.go('/challenge'),
      ),
    );
  }
}

class _ArchetypeCard extends StatelessWidget {
  const _ArchetypeCard({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
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
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: selected
                  ? colorScheme.onPrimaryContainer
                  : colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

class _Disclaimer extends StatelessWidget {
  const _Disclaimer();

  static const lines = [
    'Al entrar aceptas que el camino duele',
    'Que nadie va a rescatarte',
    'Que eres el único responsable',
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AVISO DE ENTRADA',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    letterSpacing: 1.5,
                  ),
            ),
            const SizedBox(height: 8),
            for (final line in lines)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('•  '),
                    Expanded(child: Text(line)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}