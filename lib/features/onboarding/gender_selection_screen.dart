import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../models/gender.dart';
import '../../../providers/profile_providers.dart';
import 'widgets/continue_button.dart';

/// Step 1: choose the gender track. Selecting a gender switches the app to that
/// track's palette and unlocks the continue action.
class GenderSelectionScreen extends ConsumerStatefulWidget {
  const GenderSelectionScreen({super.key});

  @override
  ConsumerState<GenderSelectionScreen> createState() =>
      _GenderSelectionScreenState();
}

class _GenderSelectionScreenState
    extends ConsumerState<GenderSelectionScreen> {
  Gender? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AGOGE')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '¿Cuál es tu camino?',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _GenderCard(
                  icon: Gender.male.icon,
                  label: 'GUERREROS',
                  selected: _selected == Gender.male,
                  onTap: () => _onSelect(Gender.male),
                ),
                const SizedBox(width: 24),
                _GenderCard(
                  icon: Gender.female.icon,
                  label: 'GUERRERAS',
                  selected: _selected == Gender.female,
                  onTap: () => _onSelect(Gender.female),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: OnboardingContinueButton(
        enabled: _selected != null,
        onPressed: () =>
            context.go('/archetype'),
      ),
    );
  }

  void _onSelect(Gender gender) {
    setState(() => _selected = gender);
    ref.read(profileControllerProvider.notifier).selectGender(gender);
  }
}

class _GenderCard extends StatelessWidget {
  const _GenderCard({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 120,
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: selected ? colorScheme.primaryContainer : colorScheme.surface,
          border: Border.all(
            color: selected ? colorScheme.primary : colorScheme.outline,
            width: 3,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: selected
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}