import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/profile_providers.dart';
import '../features/challenge/challenge_tier_selection_screen.dart';
import '../features/evidence/evidence_capture_placeholder_screen.dart';
import '../features/onboarding/archetype_selection_screen.dart';
import '../features/onboarding/gender_selection_screen.dart';
import '../features/onboarding/splash_screen.dart';

/// Builds the app router. [ref] is supplied by the root [ProviderScope].
GoRouter buildAppRouter(WidgetRef ref) {
  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final profile = ref.read(profileControllerProvider).valueOrNull;
      final atOnboarding = state.matchedLocation.startsWith('/splash') ||
          state.matchedLocation.startsWith('/gender') ||
          state.matchedLocation.startsWith('/archetype');

      // Fully-provisioned users skip onboarding unless they re-enter it.
      if (profile != null && profile.isComplete && atOnboarding) {
        return '/challenge';
      }

      // The archetype step cannot be reached without a gender track.
      if (state.matchedLocation.startsWith('/archetype') &&
          (profile == null || profile.gender == null)) {
        return '/gender';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/gender',
        builder: (context, state) => const GenderSelectionScreen(),
      ),
      GoRoute(
        path: '/archetype',
        builder: (context, state) => const ArchetypeSelectionScreen(),
      ),
      GoRoute(
        path: '/challenge',
        builder: (context, state) => const ChallengeTierSelectionScreen(),
      ),
      GoRoute(
        path: '/evidence',
        builder: (context, state) => const EvidenceCapturePlaceholderScreen(),
      ),
    ],
  );
}