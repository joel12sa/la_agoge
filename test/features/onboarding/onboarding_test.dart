import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:la_agoge/app.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Helper that pumps the full app with a clean SharedPreferences store.
Future<void> pumpAgoge(WidgetTester tester) async {
  SharedPreferences.setMockInitialValues({});
  await tester.pumpWidget(const ProviderScope(child: AgogeApp()));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Continue is disabled on splash until profile loads', (tester) async {
    await pumpAgoge(tester);
    expect(find.text('AGOGE'), findsOneWidget);
    expect(find.text('CONTINUAR'), findsOneWidget);
  });

  testWidgets('Continue stays disabled on gender screen until a track is picked',
      (tester) async {
    await pumpAgoge(tester);

    // Tap CONTINUAR on splash to reach gender selection.
    await tester.tap(find.text('CONTINUAR'));
    await tester.pumpAndSettle();

    // Continue button is present but disabled (no enabled scroll action).
    final continueBtn = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, 'CONTINUAR'),
    );
    expect(continueBtn.onPressed, isNull);
  });

  testWidgets('Selecting a gender enables continue and routes to archetype',
      (tester) async {
    await pumpAgoge(tester);

    await tester.tap(find.text('CONTINUAR'));
    await tester.pumpAndSettle();

    // Select the male track.
    await tester.tap(find.text('GUERREROS'));
    await tester.pumpAndSettle();

    final continueBtn = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, 'CONTINUAR'),
    );
    expect(continueBtn.onPressed, isNotNull);

    await tester.tap(find.text('CONTINUAR'));
    await tester.pumpAndSettle();

    // Male archetype screen prompt + disclaimer are shown.
    expect(find.text('¿Eres presa o depredador?'), findsOneWidget);
    expect(find.text('Al entrar aceptas que el camino duele'), findsOneWidget);
    expect(find.text('Que nadie va a rescatarte'), findsOneWidget);
    expect(find.text('Que eres el único responsable'), findsOneWidget);
  });

  testWidgets('Archetype selection enables continue and completes onboarding',
      (tester) async {
    // Seed a completed gender choice so we can go straight to archetype.
    SharedPreferences.setMockInitialValues({
      'profile.gender': 'male',
    });
    await tester.pumpWidget(const ProviderScope(child: AgogeApp()));
    await tester.pumpAndSettle();

    // Splash redirect should now take us toward archetype selection.
    await tester.tap(find.text('CONTINUAR'));
    await tester.pumpAndSettle();

    expect(find.text('¿Eres presa o depredador?'), findsOneWidget);

    final continueBtn = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, 'CONTINUAR'),
    );
    expect(continueBtn.onPressed, isNull);

    await tester.tap(find.text('DEPREDADOR'));
    await tester.pumpAndSettle();

    expect(
      tester
          .widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'CONTINUAR'))
          .onPressed,
      isNotNull,
    );

    await tester.tap(find.text('CONTINUAR'));
    await tester.pumpAndSettle();

    // Completing archetype routes to "La Puerta del Agogé" (feature #2).
    expect(find.text('LA PUERTA DEL AGOGE'), findsOneWidget);
  });

  testWidgets('Male and female tracks load distinct group labels',
      (tester) async {
    await pumpAgoge(tester);
    await tester.tap(find.text('CONTINUAR'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('GUERREROS'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('CONTINUAR'));
    await tester.pumpAndSettle();

    // Male-track prompt.
    expect(find.text('¿Eres una muñeca rota o arquitecta de tu destino?'),
        findsNothing);
    expect(find.text('GUERRERAS'), findsNothing);
  });
}