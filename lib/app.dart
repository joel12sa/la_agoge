import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'providers/profile_providers.dart';
import 'router.dart';
import 'theme/app_theme.dart';

/// Root application widget. Owns the router and rebuilds the theme whenever the
/// selected gender track changes.
class AgogeApp extends ConsumerStatefulWidget {
  const AgogeApp({super.key});

  @override
  ConsumerState<AgogeApp> createState() => _AgogeAppState();
}

class _AgogeAppState extends ConsumerState<AgogeApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = buildAppRouter(ref);
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileControllerProvider).valueOrNull;
    return MaterialApp.router(
      title: 'AGOGE',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeFor(profile?.gender),
      routerConfig: _router,
    );
  }
}