import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/app.dart';
import 'src/data/finance_repository.dart';
import 'src/settings/app_settings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final settings = await AppSettings.load();
  runApp(
    ProviderScope(
      overrides: [
        financeRepositoryProvider.overrideWithValue(FinanceRepository()),
        initialSettingsProvider.overrideWithValue(settings),
      ],
      child: const MasarApp(),
    ),
  );
}
