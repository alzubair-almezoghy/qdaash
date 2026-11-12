import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masar_finance/l10n/generated/app_localizations.dart';
import 'package:masar_finance/src/l10n/financial_labels.dart';
import 'package:masar_finance/src/data/finance_repository.dart';
import 'package:masar_finance/src/screens/settings_screen.dart';
import 'package:masar_finance/src/settings/app_settings.dart';

class _InMemorySettingsController extends SettingsController {
  @override
  Future<void> set(String key, Object? value) async {
    state = state.withValue(key, value);
  }
}

void main() {
  test(
    'default financial labels and notification copy use selected language',
    () {
      final arabic = lookupAppLocalizations(const Locale('ar'));
      final english = lookupAppLocalizations(const Locale('en'));
      expect(localizedCategoryWith(arabic, 'Food'), 'الطعام والمشروبات');
      expect(localizedCategoryWith(english, 'Food'), 'Food & Drinks');
      expect(localizedCategoryWith(arabic, 'Custom'), 'Custom');
      expect(arabic.dailyReminderBody, isNot(contains('Record')));
      expect(english.dailyReminderBody, isNot(contains('سجّل')));
    },
  );

  test('settings defaults remain light, Arabic, LYD and locally scoped', () {
    final settings = AppSettings();
    expect(settings.theme, 'light');
    expect(settings.language, 'ar');
    expect(settings.currency, 'LYD');
    expect(settings.categories.where((c) => !c.archived).length, 6);
    expect(settings.withValue('theme', 'dark').theme, 'dark');
    expect(settings.theme, 'light');
    expect(formatMoney(25, const Locale('en'), settings), contains('LYD'));
  });

  test('invalid stored financial preferences fall back safely', () {
    final settings = AppSettings({
      'monthlyBudget': 'not-a-number',
      'currencyRate': double.infinity,
      'decimals': 7,
      'monthStart': 31,
    });
    expect(settings.monthlyBudget, 0);
    expect(settings.currencyRate, 1);
    expect(settings.decimals, 2);
    expect(settings.monthStart, 28);
  });

  test('backup rejects invalid records before opening the database', () async {
    final repository = FinanceRepository();
    await expectLater(
      repository.restore({
        'format': 'gaddash-backup',
        'version': 1,
        'transactions': [
          {
            'id': 1,
            'amount': -5,
            'category': 'Food',
            'note': '',
            'date': '2026-11-11',
            'is_income': 0,
          },
        ],
        'goals': [],
      }),
      throwsFormatException,
    );
  });

  testWidgets('settings layout supports Arabic RTL on a compact phone', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(720, 1280);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [initialSettingsProvider.overrideWithValue(AppSettings())],
        child: const MaterialApp(
          locale: Locale('ar'),
          supportedLocales: [Locale('ar'), Locale('en')],
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: SettingsScreen(),
        ),
      ),
    );
    expect(find.text('الإعدادات', skipOffstage: false), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.text('الإعدادات'))),
      TextDirection.rtl,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('language switch from settings updates locale and direction', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          initialSettingsProvider.overrideWithValue(
            AppSettings({'language': 'en'}),
          ),
          settingsProvider.overrideWith(_InMemorySettingsController.new),
        ],
        child: Consumer(
          builder:
              (context, ref, _) => MaterialApp(
                locale: Locale(ref.watch(settingsProvider).language),
                supportedLocales: const [Locale('ar'), Locale('en')],
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                home: const SettingsScreen(),
              ),
        ),
      ),
    );
    await tester.ensureVisible(find.text('Language'));
    await tester.tap(find.text('Language'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('العربية').last);
    await tester.pumpAndSettle();
    expect(find.text('اللغة'), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.text('اللغة'))),
      TextDirection.rtl,
    );
    expect(tester.takeException(), isNull);
  });
}
