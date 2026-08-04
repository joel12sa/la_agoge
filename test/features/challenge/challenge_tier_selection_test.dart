import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:la_agoge/app.dart';
import 'package:la_agoge/features/challenge/widgets/tier_card.dart';
import 'package:la_agoge/models/challenge_attempt.dart';
import 'package:la_agoge/providers/challenge_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _defaultTiers = [
  {
    'id': 'pre_iniciado',
    'reps': 50,
    'rank': 'Pre Iniciado',
    'xp_reward': 250,
  },
  {'id': 'iniciado', 'reps': 100, 'rank': 'Iniciado', 'xp_reward': 500},
  {'id': 'guerrero', 'reps': 200, 'rank': 'Guerrero', 'xp_reward': 1200},
];

http.Response _okResponse() => http.Response(jsonEncode(_defaultTiers), 200);

/// Pumps the full app with a complete onboarding profile (so the router lands
/// on `/challenge`) and an overridable HTTP client for tier loading.
Future<void> pumpChallenge(
  WidgetTester tester, {
  http.Client? client,
  String gender = 'male',
}) async {
  await pumpChallengeRaw(tester, client: client, gender: gender);
  await tester.pumpAndSettle();
}

/// Same as [pumpChallenge] but does not settle pending frames, for tests that
/// control async timing themselves (e.g. loading state).
Future<void> pumpChallengeRaw(
  WidgetTester tester, {
  http.Client? client,
  String gender = 'male',
}) async {
  SharedPreferences.setMockInitialValues({
    'profile.gender': gender,
    'profile.archetype': gender == 'male' ? 'depredador' : 'arquitecta',
  });
  final overrides = <Override>[
    if (client != null) httpClientProvider.overrideWithValue(client),
  ];
  await tester.pumpWidget(
    ProviderScope(overrides: overrides, child: const AgogeApp()),
  );
  // Splash profile loads async, then auto-advances to /challenge.
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

ChallengeAttempt? _readAttempt(WidgetTester tester) {
  final context = tester.element(find.byType(Scaffold).first);
  final container = ProviderScope.containerOf(context);
  return container.read(challengeAttemptControllerProvider).valueOrNull;
}

void main() {
  testWidgets('Available challenge tiers show reps, rank, and XP reward',
      (tester) async {
    await pumpChallenge(tester, client: MockClient((_) async => _okResponse()));

    expect(find.text('50 burpees'), findsOneWidget);
    expect(find.text('Pre Iniciado'), findsOneWidget);
    expect(find.text('+250 XP'), findsOneWidget);

    expect(find.text('100 burpees'), findsOneWidget);
    expect(find.text('Iniciado'), findsOneWidget);
    expect(find.text('+500 XP'), findsOneWidget);

    expect(find.text('200 burpees'), findsOneWidget);
    expect(find.text('Guerrero'), findsOneWidget);
    expect(find.text('+1200 XP'), findsOneWidget);
  });

  testWidgets('Selecting a tier marks it selected and creates a pending attempt',
      (tester) async {
    await pumpChallenge(tester, client: MockClient((_) async => _okResponse()));

    await tester.tap(find.text('100 burpees'));
    await tester.pumpAndSettle();

    final card = tester.widget<TierCard>(
      find.byWidgetPredicate((w) => w is TierCard && w.tier.id == 'iniciado'),
    );
    expect(card.selected, isTrue);

    final attempt = _readAttempt(tester)!;
    expect(attempt.tier?.rank, 'Iniciado');
    expect(attempt.tier?.reps, 100);
    expect(attempt.tier?.xpReward, 500);
  });

  testWidgets('Only one tier stays selected; switching updates the attempt',
      (tester) async {
    await pumpChallenge(tester, client: MockClient((_) async => _okResponse()));

    await tester.tap(find.text('50 burpees'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('200 burpees'));
    await tester.pumpAndSettle();

    final guerreroCard = tester.widget<TierCard>(
      find.byWidgetPredicate((w) => w is TierCard && w.tier.id == 'guerrero'),
    );
    final preIniciadoCard = tester.widget<TierCard>(
      find.byWidgetPredicate((w) => w is TierCard && w.tier.id == 'pre_iniciado'),
    );
    expect(guerreroCard.selected, isTrue);
    expect(preIniciadoCard.selected, isFalse);

    final attempt = _readAttempt(tester)!;
    expect(attempt.tier?.rank, 'Guerrero');
    expect(attempt.tier?.reps, 200);
    expect(attempt.tier?.xpReward, 1200);
  });

  testWidgets('Confirming navigates to evidence and keeps the tier associated',
      (tester) async {
    await pumpChallenge(tester, client: MockClient((_) async => _okResponse()));

    await tester.tap(find.text('50 burpees'));
    await tester.pumpAndSettle();

    // Male track CTA label.
    expect(find.text('CONTINUAR'), findsOneWidget);
    await tester.tap(find.text('CONTINUAR'));
    await tester.pumpAndSettle();

    expect(find.text('Reto elegido: 50 burpees (Pre Iniciado)'), findsOneWidget);
    final attempt = _readAttempt(tester)!;
    expect(attempt.tier?.reps, 50);
  });

  testWidgets('Female track uses the "ACEPTA EL RETO" CTA label', (tester) async {
    await pumpChallenge(
      tester,
      client: MockClient((_) async => _okResponse()),
      gender: 'female',
    );

    expect(find.text('ACEPTA EL RETO'), findsOneWidget);
    expect(find.text('CONTINUAR'), findsNothing);
  });

  testWidgets('Tier XP comes from the remote configuration, not hardcoding',
      (tester) async {
    final configTiers = [
      for (final tier in _defaultTiers)
        tier['id'] == 'guerrero' ? {...tier, 'xp_reward': 1500} : tier,
    ];
    final client = MockClient(
      (_) async => http.Response(jsonEncode(configTiers), 200),
    );

    await pumpChallenge(tester, client: client);

    expect(find.text('+1500 XP'), findsOneWidget);
    expect(find.text('+1200 XP'), findsNothing);
  });

  testWidgets('Shows loading indicator while tiers are being fetched',
      (tester) async {
    final completer = Completer<http.Response>();
    await pumpChallengeRaw(tester, client: MockClient((_) => completer.future));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    completer.complete(_okResponse());
    await tester.pumpAndSettle();
    expect(find.text('50 burpees'), findsOneWidget);
  });

  testWidgets('Shows error state with retry that reloads tiers', (tester) async {
    var calls = 0;
    final client = MockClient((_) async {
      calls += 1;
      return calls == 1
          ? http.Response('boom', 500)
          : _okResponse();
    });

    await pumpChallenge(tester, client: client);

    expect(find.text('No pudimos cargar los retos.'), findsOneWidget);
    expect(find.text('REINTENTAR'), findsOneWidget);

    await tester.tap(find.text('REINTENTAR'));
    await tester.pumpAndSettle();

    expect(find.text('50 burpees'), findsOneWidget);
  });
}
