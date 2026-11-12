import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

final initialSettingsProvider = Provider<AppSettings>((ref) => AppSettings());
final settingsProvider = NotifierProvider<SettingsController, AppSettings>(
  SettingsController.new,
);

class AppSettings {
  AppSettings([Map<String, dynamic>? values]) : values = Map.of(values ?? {});

  final Map<String, dynamic> values;

  T get<T>(String key, T fallback) {
    final value = values[key];
    return value is T ? value : fallback;
  }

  AppSettings withValue(String key, Object? value) =>
      AppSettings({...values, key: value});

  String get language => get('language', 'ar');
  String get theme => get('theme', 'light');
  String get accent => get('accent', 'emerald');
  String get motion => get('motion', 'system');
  bool get haptics => get('haptics', true);
  String get name => get('name', '');
  String get avatar => get('avatar', '');
  String get currency => get('currency', 'LYD');
  double get currencyRate {
    final value = values['currencyRate'];
    if (value is! num || !value.isFinite || value <= 0) return 1;
    return value.toDouble();
  }

  String get currencyDisplay => get('currencyDisplay', 'code');
  int get decimals {
    final value = get<int>('decimals', 2);
    return value == 0 || value == 2 ? value : 2;
  }

  double get monthlyBudget {
    final value = values['monthlyBudget'];
    if (value is! num || !value.isFinite || value < 0) return 0;
    return value.toDouble();
  }

  int get monthStart => get<int>('monthStart', 1).clamp(1, 28);
  String get defaultCategory => get('defaultCategory', 'Food');
  String get defaultWallet => get('defaultWallet', 'Cash');
  List<String> get wallets {
    final raw = values['wallets'];
    if (raw is! List) return ['Cash'];
    final parsed =
        raw
            .whereType<String>()
            .where((item) => item.trim().isNotEmpty)
            .toList();
    return parsed.isEmpty ? ['Cash'] : parsed;
  }

  List<ExpenseCategory> get categories {
    final raw = values['categories'];
    if (raw is! List) return List.of(ExpenseCategory.defaults);
    try {
      return raw
          .map(
            (entry) => ExpenseCategory.fromMap(
              Map<String, dynamic>.from(entry as Map),
            ),
          )
          .toList();
    } catch (_) {
      return List.of(ExpenseCategory.defaults);
    }
  }

  bool get hideBalances => get('hideBalances', false);
  bool get privacyMode => get('privacyMode', false);
  bool get lockEnabled => get('lockEnabled', false);
  bool get biometric => get('biometric', false);
  int get lockDelay => get('lockDelay', 0);

  static Future<AppSettings> load() async {
    final raw = await SharedPreferencesAsync().getString('gaddash.settings.v1');
    if (raw == null) return AppSettings();
    try {
      final decoded = jsonDecode(raw);
      return decoded is Map<String, dynamic>
          ? AppSettings(decoded)
          : AppSettings();
    } on FormatException {
      return AppSettings();
    }
  }
}

class SettingsController extends Notifier<AppSettings> {
  @override
  AppSettings build() => ref.read(initialSettingsProvider);

  Future<void> set(String key, Object? value) async {
    final previous = state;
    state = state.withValue(key, value);
    try {
      await SharedPreferencesAsync().setString(
        'gaddash.settings.v1',
        jsonEncode(state.values),
      );
    } catch (_) {
      state = previous;
      rethrow;
    }
  }

  Future<void> reset() async {
    await SharedPreferencesAsync().remove('gaddash.settings.v1');
    state = AppSettings();
  }

  Future<void> replace(AppSettings replacement) async {
    await SharedPreferencesAsync().setString(
      'gaddash.settings.v1',
      jsonEncode(replacement.values),
    );
    state = replacement;
  }

  Future<void> setCategories(List<ExpenseCategory> categories) => set(
    'categories',
    categories.map((category) => category.toMap()).toList(),
  );
}

class ExpenseCategory {
  const ExpenseCategory(
    this.name,
    this.icon,
    this.color, {
    this.archived = false,
  });
  final String name;
  final String icon;
  final int color;
  final bool archived;

  static const defaults = [
    ExpenseCategory('Food', 'food', 0xFFE88870),
    ExpenseCategory('Transport', 'car', 0xFF2575A7),
    ExpenseCategory('Shopping', 'shopping', 0xFF7964AC),
    ExpenseCategory('Bills', 'receipt', 0xFFE7B965),
    ExpenseCategory('Health', 'health', 0xFF078F78),
    ExpenseCategory('Other', 'category', 0xFF81909C),
  ];

  factory ExpenseCategory.fromMap(Map<String, dynamic> map) => ExpenseCategory(
    map['name'] as String,
    map['icon'] as String,
    map['color'] as int,
    archived: map['archived'] == true,
  );

  Map<String, Object> toMap() => {
    'name': name,
    'icon': icon,
    'color': color,
    'archived': archived,
  };

  ExpenseCategory copyWith({
    String? name,
    String? icon,
    int? color,
    bool? archived,
  }) => ExpenseCategory(
    name ?? this.name,
    icon ?? this.icon,
    color ?? this.color,
    archived: archived ?? this.archived,
  );

  IconData get iconData => switch (icon) {
    'food' => Icons.restaurant_rounded,
    'car' => Icons.directions_car_rounded,
    'shopping' => Icons.shopping_bag_rounded,
    'receipt' => Icons.receipt_long_rounded,
    'health' => Icons.favorite_rounded,
    'home' => Icons.home_rounded,
    'travel' => Icons.flight_rounded,
    'education' => Icons.school_rounded,
    'gift' => Icons.card_giftcard_rounded,
    _ => Icons.category_rounded,
  };
}

Color accentColor(String choice) => switch (choice) {
  'ocean' => const Color(0xFF2575A7),
  'purple' => const Color(0xFF7964AC),
  'teal' => const Color(0xFF078F91),
  _ => const Color(0xFF078F78),
};

String formatMoney(double amount, Locale locale, AppSettings settings) {
  final code = settings.currency;
  final symbol =
      settings.currencyDisplay == 'symbol'
          ? switch (code) {
            'USD' => r'$',
            'EUR' => '€',
            'GBP' => '£',
            _ => 'د.ل',
          }
          : '$code ';
  return NumberFormat.currency(
    locale: locale.toLanguageTag(),
    name: code,
    symbol: symbol,
    decimalDigits: settings.decimals,
  ).format(amount * (code == 'LYD' ? 1 : settings.currencyRate));
}

String formatPercent(double ratio, Locale locale) =>
    NumberFormat.percentPattern(locale.toLanguageTag()).format(ratio);
