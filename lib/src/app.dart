import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/generated/app_localizations.dart';

import 'settings/app_settings.dart';
import 'screens/settings_screen.dart';
import 'screens/app_lock_screen.dart';
import 'settings/security_service.dart';
import 'settings/notification_service.dart';
import 'screens/splash_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/placeholder_screens.dart';
import 'theme.dart';
import 'widgets/radial_navigation_dock.dart';
import 'widgets/stateful_branch_transitions.dart';
import 'widgets/transaction_sheet.dart';

class MasarApp extends ConsumerStatefulWidget {
  const MasarApp({super.key});

  @override
  ConsumerState<MasarApp> createState() => _MasarAppState();
}

class _MasarAppState extends ConsumerState<MasarApp>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  bool _showSplash = true;
  bool _locked = false;
  DateTime? _backgroundedAt;
  late final AnimationController _navigationRotation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _navigationRotation = AnimationController.unbounded(vsync: this, value: 0);
    final settings = ref.read(settingsProvider);
    _locked = settings.lockEnabled;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Platform.isAndroid) {
        SecurityService.setPrivatePreview(settings.privacyMode);
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _navigationRotation.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      _backgroundedAt ??= DateTime.now();
    } else if (state == AppLifecycleState.resumed && _backgroundedAt != null) {
      final settings = ref.read(settingsProvider);
      final elapsed = DateTime.now().difference(_backgroundedAt!);
      _backgroundedAt = null;
      if (settings.lockEnabled &&
          elapsed >= Duration(minutes: settings.lockDelay)) {
        setState(() => _locked = true);
      }
    }
  }

  late final GoRouter _router = GoRouter(
    initialLocation: '/home',
    routes: [
      StatefulShellRoute(
        builder:
            (context, state, shell) => MasarShell(
              shell: shell,
              rotationController: _navigationRotation,
              locale: Locale(ref.read(settingsProvider).language),
              onAdd: () => showTransactionSheet(context),
            ),
        navigatorContainerBuilder:
            (context, navigationShell, children) => StatefulBranchTransitions(
              rotationController: _navigationRotation,
              isRtl: Localizations.localeOf(context).languageCode == 'ar',
              children: children,
            ),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (_, __) => const DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/activity',
                builder: (_, __) => const ActivityScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/reports',
                builder: (_, __) => const ReportsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/goals', builder: (_, __) => const GoalsScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (_, __) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    ref.listen(settingsProvider, (previous, next) {
      if (previous?.privacyMode != next.privacyMode && Platform.isAndroid) {
        SecurityService.setPrivatePreview(next.privacyMode);
      }
      if (!next.lockEnabled && _locked) setState(() => _locked = false);
    });
    final locale = Locale(settings.language);
    final themeMode = switch (settings.theme) {
      'dark' => ThemeMode.dark,
      'system' => ThemeMode.system,
      _ => ThemeMode.light,
    };
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appName,
      debugShowCheckedModeBanner: false,
      locale: locale,
      supportedLocales: const [Locale('en'), Locale('ar')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: MasarTheme.lightWith(accentColor(settings.accent)),
      darkTheme: MasarTheme.darkWith(accentColor(settings.accent)),
      themeMode: themeMode,
      routerConfig: _router,
      builder:
          (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              disableAnimations:
                  settings.motion == 'reduced' ||
                  (settings.motion == 'system' &&
                      MediaQuery.of(context).disableAnimations),
            ),
            child: MasarLocaleScope(
              locale: locale,
              settings: settings,
              onChanged: (value) async {
                await ref
                    .read(settingsProvider.notifier)
                    .set('language', value.languageCode);
                try {
                  await NotificationService.refreshScheduledContent(
                    ref.read(settingsProvider),
                  );
                } catch (_) {
                  // A denied notification permission does not undo language selection.
                }
              },
              child: Stack(
                fit: StackFit.expand,
                children: [
                  child ?? const SizedBox.shrink(),
                  if (_showSplash)
                    SplashOverlay(
                      onFinished: () => setState(() => _showSplash = false),
                    ),
                  if (_locked && !_showSplash)
                    AppLockScreen(
                      biometric: settings.biometric,
                      onUnlocked: () => setState(() => _locked = false),
                    ),
                ],
              ),
            ),
          ),
    );
  }
}

class MasarLocaleScope extends InheritedWidget {
  const MasarLocaleScope({
    required this.locale,
    required this.settings,
    required this.onChanged,
    required super.child,
    super.key,
  });

  final Locale locale;
  final AppSettings settings;
  final ValueChanged<Locale> onChanged;

  static MasarLocaleScope of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<MasarLocaleScope>()!;

  @override
  bool updateShouldNotify(MasarLocaleScope oldWidget) =>
      locale != oldWidget.locale || settings != oldWidget.settings;
}

class MasarShell extends StatelessWidget {
  const MasarShell({
    required this.shell,
    required this.rotationController,
    required this.locale,
    required this.onAdd,
    super.key,
  });

  final StatefulNavigationShell shell;
  final AnimationController rotationController;
  final Locale locale;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 108),
              child: shell,
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: RadialNavigationDock(
            rotationController: rotationController,
            selectedIndex: shell.currentIndex,
            locale: MasarLocaleScope.of(context).locale,
            haptics: MasarLocaleScope.of(context).settings.haptics,
            reduceMotion: MediaQuery.of(context).disableAnimations,
            onDestinationSelected: shell.goBranch,
            onAdd: onAdd,
          ),
        ),
      ],
    ),
  );
}
