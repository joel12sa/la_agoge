import 'package:flutter/material.dart';

import '../models/gender.dart';

class AppTheme {
  const AppTheme._();

  /// Returns the [ColorScheme] seed for a gender track, or a neutral default
  /// before any selection has been made (splash screen).
  static Color seedFor(Gender? gender) =>
      gender?.track.seed ?? const Color(0xFF1E1E1E);

  static ThemeData themeFor(Gender? gender) {
    final scheme = ColorScheme.fromSeed(seedColor: seedFor(gender));
    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(backgroundColor: scheme.inversePrimary),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}