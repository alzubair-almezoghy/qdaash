import '../../l10n/generated/app_localizations.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import '../data/finance_repository.dart';
import '../l10n/financial_labels.dart';
import '../settings/app_settings.dart';
import '../settings/data_portability.dart';
import '../settings/notification_service.dart';
import '../settings/security_service.dart';

Future<String?> _choice(
  BuildContext context,
  String title,
  Map<String, String> options,
) async {
  final result = await showDialog<String>(
    context: context,
    builder:
        (context) => AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  options.entries
                      .map(
                        (entry) => ListTile(
                          title: Text(entry.value),
                          onTap: () => Navigator.pop(context, entry.key),
                        ),
                      )
                      .toList(),
            ),
          ),
        ),
  );
  await Future<void>.delayed(const Duration(milliseconds: 220));
  return result;
}

Future<String?> _textInput(
  BuildContext context,
  String title, {
  String initial = '',
  bool secret = false,
  TextInputType? keyboard,
}) async {
  return showDialog<String>(
    context: context,
    builder:
        (context) => _SettingsTextInputDialog(
          title: title,
          initial: initial,
          secret: secret,
          keyboard: keyboard,
        ),
  );
}

class _SettingsTextInputDialog extends StatefulWidget {
  const _SettingsTextInputDialog({
    required this.title,
    required this.initial,
    required this.secret,
    required this.keyboard,
  });

  final String title;
  final String initial;
  final bool secret;
  final TextInputType? keyboard;

  @override
  State<_SettingsTextInputDialog> createState() =>
      _SettingsTextInputDialogState();
}

class _SettingsTextInputDialogState extends State<_SettingsTextInputDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initial);
  }

  void _close([String? value]) {
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.of(context).pop(value);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.title),
    content: TextField(
      controller: _controller,
      obscureText: widget.secret,
      keyboardType: widget.keyboard,
      autofocus: true,
      onSubmitted: (_) => _close(_controller.text.trim()),
    ),
    actions: [
      TextButton(
        onPressed: _close,
        child: Text(AppLocalizations.of(context)!.cancel),
      ),
      FilledButton(
        onPressed: () => _close(_controller.text.trim()),
        child: Text(AppLocalizations.of(context)!.save),
      ),
    ],
  );
}

Future<bool> _confirm(
  BuildContext context,
  String title,
  String body, {
  bool destructive = false,
}) async =>
    await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(title),
            content: Text(body),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(AppLocalizations.of(context)!.cancel),
              ),
              FilledButton(
                style:
                    destructive
                        ? FilledButton.styleFrom(
                          backgroundColor: Colors.red.shade700,
                        )
                        : null,
                onPressed: () => Navigator.pop(context, true),
                child: Text(AppLocalizations.of(context)!.confirm),
              ),
            ],
          ),
    ) ??
    false;

Future<void> _run(
  BuildContext context,
  Future<void> Function() action, {
  String? success,
}) async {
  try {
    await action();
    if (context.mounted && success != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(success)));
    }
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.couldNotCompleteAction),
        ),
      );
    }
  }
}

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final accent = Theme.of(context).colorScheme.primary;
    final avatar = settings.avatar;
    return PopScope<void>(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) context.go('/home');
      },
      child: Scaffold(
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => context.go('/home'),
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context)!.settings,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
              const SizedBox(height: 18),
              InkWell(
                onTap: () => _open(context, 'profile'),
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [accent, accent.withValues(alpha: .78)],
                    ),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: accent.withValues(alpha: .16),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.white.withValues(alpha: .22),
                        backgroundImage:
                            avatar.isNotEmpty && File(avatar).existsSync()
                                ? FileImage(File(avatar))
                                : null,
                        child:
                            avatar.isEmpty
                                ? const Icon(
                                  Icons.person_rounded,
                                  color: Colors.white,
                                  size: 28,
                                )
                                : null,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              settings.name.isEmpty
                                  ? AppLocalizations.of(context)!.yourProfile
                                  : settings.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 17,
                              ),
                            ),
                            Text(
                              AppLocalizations.of(
                                context,
                              )!.personalizeYourExperience,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: .78),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _section(context, AppLocalizations.of(context)!.personalization, [
                _tile(
                  context,
                  Icons.palette_outlined,
                  AppLocalizations.of(context)!.appearance,
                  AppLocalizations.of(context)!.themeAccentAndMotion,
                  () => _open(context, 'appearance'),
                ),
                _languageTile(context, ref),
                _tile(
                  context,
                  Icons.account_balance_wallet_outlined,
                  AppLocalizations.of(context)!.financialPreferences,
                  AppLocalizations.of(context)!.budgetAndCategories,
                  () => _open(context, 'financial'),
                ),
              ]),
              _section(context, AppLocalizations.of(context)!.control, [
                _tile(
                  context,
                  Icons.notifications_none_rounded,
                  AppLocalizations.of(context)!.notifications,
                  AppLocalizations.of(context)!.localRemindersAndAlerts,
                  () => _open(context, 'notifications'),
                ),
                _tile(
                  context,
                  Icons.lock_outline_rounded,
                  AppLocalizations.of(context)!.privacyAndSecurity,
                  AppLocalizations.of(context)!.pinBiometricsAndBalances,
                  () => _open(context, 'security'),
                ),
                _tile(
                  context,
                  Icons.lightbulb_outline_rounded,
                  AppLocalizations.of(context)!.financialInsights,
                  AppLocalizations.of(context)!.offlineSummaries,
                  () => _open(context, 'insights'),
                ),
              ]),
              _section(context, AppLocalizations.of(context)!.yourData, [
                _tile(
                  context,
                  Icons.inventory_2_outlined,
                  AppLocalizations.of(context)!.dataManagement,
                  AppLocalizations.of(context)!.exportBackupAndRestore,
                  () => _open(context, 'data'),
                ),
                _tile(
                  context,
                  Icons.info_outline_rounded,
                  AppLocalizations.of(context)!.aboutGaddash,
                  AppLocalizations.of(context)!.versionAndLicenses,
                  () => _open(context, 'about'),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}

void _open(BuildContext context, String page) => Navigator.of(
  context,
).push(MaterialPageRoute<void>(builder: (_) => _SettingsPage(page: page)));

Widget _section(BuildContext context, String title, List<Widget> children) =>
    Padding(
      padding: const EdgeInsets.only(bottom: 23),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 10),
            child: Text(title, style: Theme.of(context).textTheme.titleSmall),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: Theme.of(context).dividerColor.withValues(alpha: .25),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .025),
                  blurRadius: 16,
                ),
              ],
            ),
            child: Column(children: children),
          ),
        ],
      ),
    );

Widget _tile(
  BuildContext context,
  IconData icon,
  String title,
  String subtitle,
  VoidCallback? onTap, {
  Widget? trailing,
}) => ListTile(
  onTap: onTap,
  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
  leading: Container(
    width: 39,
    height: 39,
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.primary.withValues(alpha: .1),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 21),
  ),
  title: Text(
    title,
    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
  ),
  subtitle: Text(subtitle, style: const TextStyle(fontSize: 11)),
  trailing:
      trailing ??
      (onTap == null
          ? null
          : const Icon(Icons.chevron_right_rounded, size: 20)),
);

class _SettingsPage extends ConsumerWidget {
  const _SettingsPage({required this.page});
  final String page;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = switch (page) {
      'profile' => AppLocalizations.of(context)!.personalProfile,
      'appearance' => AppLocalizations.of(context)!.appearance2,
      'financial' => AppLocalizations.of(context)!.financialPreferences,
      'notifications' => AppLocalizations.of(context)!.notifications2,
      'security' => AppLocalizations.of(context)!.privacyAndSecurity,
      'insights' => AppLocalizations.of(context)!.financialInsights,
      'data' => AppLocalizations.of(context)!.dataManagement,
      _ => AppLocalizations.of(context)!.aboutGaddash,
    };
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body:
          page == 'about'
              ? Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                child: _about(context),
              )
              : ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                children: switch (page) {
                  'profile' => _profile(context, ref),
                  'appearance' => _appearance(context, ref),
                  'financial' => _financial(context, ref),
                  'notifications' => _notifications(context, ref),
                  'security' => _security(context, ref),
                  'insights' => _insights(context, ref),
                  'data' => _data(context, ref),
                  _ => const <Widget>[],
                },
              ),
    );
  }
}

Future<void> _set(
  BuildContext context,
  WidgetRef ref,
  String key,
  Object? value,
) => _run(context, () => ref.read(settingsProvider.notifier).set(key, value));

Widget _languageTile(BuildContext context, WidgetRef ref) {
  final settings = ref.watch(settingsProvider);
  final isArabic = settings.language == 'ar';

  Future<void> setLanguage(bool arabic) async {
    final language = arabic ? 'ar' : 'en';
    if (language == settings.language) return;

    await _run(context, () async {
      await ref.read(settingsProvider.notifier).set('language', language);
      try {
        await NotificationService.refreshScheduledContent(
          ref.read(settingsProvider),
        );
      } catch (_) {
        // A denied notification permission does not undo language selection.
      }
    });
  }

  return _tile(
    context,
    Icons.language_rounded,
    AppLocalizations.of(context)!.language,
    isArabic ? 'العربية' : 'English',
    () => setLanguage(!isArabic),
    trailing: Switch(value: isArabic, onChanged: setLanguage),
  );
}

List<Widget> _profile(BuildContext context, WidgetRef ref) {
  final s = ref.watch(settingsProvider);
  return [
    _section(context, AppLocalizations.of(context)!.identity, [
      _tile(
        context,
        Icons.person_outline_rounded,
        AppLocalizations.of(context)!.displayName,
        s.name.isEmpty ? AppLocalizations.of(context)!.addYourName : s.name,
        () async {
          final name = await _textInput(
            context,
            AppLocalizations.of(context)!.displayName,
            initial: s.name,
          );
          if (name != null && context.mounted) {
            await _set(context, ref, 'name', name);
          }
        },
      ),
      _tile(
        context,
        Icons.photo_camera_outlined,
        AppLocalizations.of(context)!.profilePicture,
        AppLocalizations.of(context)!.chooseFromGallery,
        () => _run(context, () async {
          final image = await ImagePicker().pickImage(
            source: ImageSource.gallery,
            imageQuality: 80,
            maxWidth: 640,
          );
          if (image == null) return;
          final dir = await getApplicationSupportDirectory();
          final target = File('${dir.path}/gaddash_profile.jpg');
          await File(image.path).copy(target.path);
          await ref.read(settingsProvider.notifier).set('avatar', target.path);
        }),
      ),
    ]),
    _section(context, AppLocalizations.of(context)!.preferences, [
      _tile(
        context,
        Icons.payments_outlined,
        AppLocalizations.of(context)!.currency,
        AppLocalizations.of(context)!.libyanDinarLYD,
        () => _open(context, 'financial'),
      ),
    ]),
  ];
}

List<Widget> _appearance(BuildContext context, WidgetRef ref) {
  final s = ref.watch(settingsProvider);
  final colors = {
    'emerald': const Color(0xFF078F78),
    'ocean': const Color(0xFF2575A7),
    'purple': const Color(0xFF7964AC),
    'teal': const Color(0xFF078F91),
  };
  return [
    _section(context, AppLocalizations.of(context)!.theme, [
      _tile(
        context,
        Icons.brightness_6_outlined,
        AppLocalizations.of(context)!.appearance3,
        switch (s.theme) {
          'dark' => AppLocalizations.of(context)!.dark,
          'system' => AppLocalizations.of(context)!.followSystem,
          _ => AppLocalizations.of(context)!.light,
        },
        () async {
          final value = await _choice(
            context,
            AppLocalizations.of(context)!.chooseTheme,
            {
              'light': AppLocalizations.of(context)!.light,
              'dark': AppLocalizations.of(context)!.dark,
              'system': AppLocalizations.of(context)!.followSystem,
            },
          );
          if (value != null && context.mounted) {
            await _set(context, ref, 'theme', value);
          }
        },
      ),
    ]),
    _section(context, AppLocalizations.of(context)!.accentColor, [
      Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 14,
          runSpacing: 12,
          children:
              colors.entries
                  .map(
                    (entry) => InkWell(
                      onTap: () => _set(context, ref, 'accent', entry.key),
                      borderRadius: BorderRadius.circular(32),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 230),
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: entry.value,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: s.accent == entry.key ? 4 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: entry.value.withValues(alpha: .25),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child:
                            s.accent == entry.key
                                ? const Icon(
                                  Icons.check_rounded,
                                  color: Colors.white,
                                )
                                : null,
                      ),
                    ),
                  )
                  .toList(),
        ),
      ),
    ]),
    _section(context, AppLocalizations.of(context)!.interaction, [
      _tile(
        context,
        Icons.animation_rounded,
        AppLocalizations.of(context)!.animations,
        switch (s.motion) {
          'full' => AppLocalizations.of(context)!.full,
          'reduced' => AppLocalizations.of(context)!.reduced,
          _ => AppLocalizations.of(context)!.followSystem,
        },
        () async {
          final value =
              await _choice(context, AppLocalizations.of(context)!.animations, {
                'full': AppLocalizations.of(context)!.full,
                'reduced': AppLocalizations.of(context)!.reduced,
                'system': AppLocalizations.of(context)!.followSystem,
              });
          if (value != null && context.mounted) {
            await _set(context, ref, 'motion', value);
          }
        },
      ),
      _tile(
        context,
        Icons.vibration_rounded,
        AppLocalizations.of(context)!.hapticFeedback,
        AppLocalizations.of(context)!.touchResponse,
        () => _set(context, ref, 'haptics', !s.haptics),
        trailing: Switch(
          value: s.haptics,
          onChanged: (v) => _set(context, ref, 'haptics', v),
        ),
      ),
    ]),
  ];
}

List<Widget> _financial(BuildContext context, WidgetRef ref) {
  final s = ref.watch(settingsProvider);
  return [
    _section(context, AppLocalizations.of(context)!.currency, [
      _tile(
        context,
        Icons.currency_exchange_rounded,
        AppLocalizations.of(context)!.baseCurrency,
        AppLocalizations.of(context)!.lydExistingRecordsUseLibyanDinar,
        null,
      ),
      _tile(
        context,
        Icons.public_rounded,
        AppLocalizations.of(context)!.preferredDisplayCurrency,
        s.currency == 'LYD'
            ? 'LYD'
            : '${s.currency} · 1 LYD = ${s.currencyRate} ${s.currency}',
        () async {
          final choice = await _choice(
            context,
            AppLocalizations.of(context)!.displayCurrency,
            {'LYD': 'LYD', 'USD': 'USD', 'EUR': 'EUR', 'GBP': 'GBP'},
          );
          if (choice == null || !context.mounted) return;
          if (choice == 'LYD') {
            await _set(context, ref, 'currency', 'LYD');
            return;
          }
          final input = await _textInput(
            context,
            AppLocalizations.of(context)!.conversionRatePrompt(choice),
            initial: s.currency == choice ? s.currencyRate.toString() : '',
            keyboard: const TextInputType.numberWithOptions(decimal: true),
          );
          if (input == null || !context.mounted) return;
          final rate = double.tryParse(input.replaceAll(',', '.'));
          if (rate == null || !rate.isFinite || rate <= 0) return;
          await _run(context, () async {
            await ref.read(settingsProvider.notifier).set('currencyRate', rate);
            await ref.read(settingsProvider.notifier).set('currency', choice);
          });
        },
      ),
      _tile(
        context,
        Icons.label_outline_rounded,
        AppLocalizations.of(context)!.currencyDisplay,
        s.currencyDisplay == 'symbol'
            ? switch (s.currency) {
              'USD' => r'$',
              'EUR' => '€',
              'GBP' => '£',
              _ => 'د.ل',
            }
            : s.currency,
        () async {
          final value = await _choice(
            context,
            AppLocalizations.of(context)!.currencyDisplay,
            {
              'code': s.currency,
              'symbol': AppLocalizations.of(context)!.symbol,
            },
          );
          if (value != null && context.mounted) {
            await _set(context, ref, 'currencyDisplay', value);
          }
        },
      ),
      _tile(
        context,
        Icons.pin_outlined,
        AppLocalizations.of(context)!.decimalPlaces,
        '${s.decimals}',
        () async {
          final value = await _choice(
            context,
            AppLocalizations.of(context)!.decimalPlaces,
            {'0': '0', '2': '2'},
          );
          if (value != null && context.mounted) {
            await _set(context, ref, 'decimals', int.parse(value));
          }
        },
      ),
    ]),
    _section(context, AppLocalizations.of(context)!.budgeting, [
      _tile(
        context,
        Icons.pie_chart_outline_rounded,
        AppLocalizations.of(context)!.monthlyBudget,
        s.monthlyBudget > 0
            ? formatMoney(s.monthlyBudget, Localizations.localeOf(context), s)
            : AppLocalizations.of(context)!.notSet,
        () async {
          final value = await _textInput(
            context,
            AppLocalizations.of(context)!.monthlyBudget,
            initial: s.monthlyBudget > 0 ? s.monthlyBudget.toString() : '',
            keyboard: const TextInputType.numberWithOptions(decimal: true),
          );
          if (value == null || !context.mounted) return;
          final amount = double.tryParse(value.replaceAll(',', '.'));
          if (amount != null && amount >= 0) {
            await _set(context, ref, 'monthlyBudget', amount);
          }
        },
      ),
      _tile(
        context,
        Icons.event_outlined,
        AppLocalizations.of(context)!.financialMonthStarts,
        AppLocalizations.of(context)!.financialMonthDay(s.monthStart),
        () async {
          final value = await _choice(
            context,
            AppLocalizations.of(context)!.startDay,
            {for (var day = 1; day <= 28; day++) '$day': '$day'},
          );
          if (value != null && context.mounted) {
            await _set(context, ref, 'monthStart', int.parse(value));
          }
        },
      ),
      _tile(
        context,
        Icons.category_outlined,
        AppLocalizations.of(context)!.defaultExpenseCategory,
        localizedCategory(context, s.defaultCategory),
        () async {
          final value = await _choice(
            context,
            AppLocalizations.of(context)!.defaultCategory,
            {
              for (final category in s.categories.where((c) => !c.archived))
                category.name: localizedCategory(context, category.name),
            },
          );
          if (value != null && context.mounted) {
            await _set(context, ref, 'defaultCategory', value);
          }
        },
      ),
      _tile(
        context,
        Icons.edit_note_rounded,
        AppLocalizations.of(context)!.manageCategories,
        AppLocalizations.of(context)!.addEditReorderAndArchive,
        () => Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (_) => const CategoryManagerScreen(),
          ),
        ),
      ),
    ]),
    _section(context, AppLocalizations.of(context)!.wallets, [
      _tile(
        context,
        Icons.account_balance_wallet_outlined,
        AppLocalizations.of(context)!.defaultWallet,
        localizedWallet(context, s.defaultWallet),
        () async {
          final value = await _choice(
            context,
            AppLocalizations.of(context)!.defaultWallet,
            {
              for (final wallet in s.wallets)
                wallet: localizedWallet(context, wallet),
            },
          );
          if (value != null && context.mounted) {
            await _set(context, ref, 'defaultWallet', value);
          }
        },
      ),
      _tile(
        context,
        Icons.add_circle_outline_rounded,
        AppLocalizations.of(context)!.addWallet,
        AppLocalizations.of(context)!.availableForNewTransactions,
        () async {
          final value = await _textInput(
            context,
            AppLocalizations.of(context)!.walletName,
          );
          if (value == null ||
              value.isEmpty ||
              s.wallets.contains(value) ||
              !context.mounted) {
            return;
          }
          await _set(context, ref, 'wallets', [...s.wallets, value]);
        },
      ),
      _tile(
        context,
        Icons.drive_file_rename_outline_rounded,
        AppLocalizations.of(context)!.renameWallet,
        AppLocalizations.of(context)!.updatesExistingTransactionLabels,
        () async {
          final oldName = await _choice(
            context,
            AppLocalizations.of(context)!.chooseWallet,
            {
              for (final wallet in s.wallets)
                wallet: localizedWallet(context, wallet),
            },
          );
          if (oldName == null || !context.mounted) return;
          final displayedName = localizedWallet(context, oldName);
          final enteredName = await _textInput(
            context,
            AppLocalizations.of(context)!.walletName,
            initial: displayedName,
          );
          final newName = enteredName == displayedName ? oldName : enteredName;
          if (newName == null ||
              newName.isEmpty ||
              (newName != oldName && s.wallets.contains(newName)) ||
              !context.mounted) {
            return;
          }
          await _run(context, () async {
            await ref
                .read(financeRepositoryProvider)
                .renameWallet(oldName, newName);
            await ref
                .read(settingsProvider.notifier)
                .set(
                  'wallets',
                  s.wallets
                      .map((wallet) => wallet == oldName ? newName : wallet)
                      .toList(),
                );
            if (s.defaultWallet == oldName) {
              await ref
                  .read(settingsProvider.notifier)
                  .set('defaultWallet', newName);
            }
            ref.invalidate(transactionsProvider);
          });
        },
      ),
    ]),
  ];
}

List<Widget> _notifications(BuildContext context, WidgetRef ref) {
  final s = ref.watch(settingsProvider);
  Future<void> toggle(String key, bool value) => _run(context, () async {
    await NotificationService.setReminder(key, value, s);
    await ref.read(settingsProvider.notifier).set(key, value);
  });
  Widget reminder(String key, IconData icon, String label) => _tile(
    context,
    icon,
    label,
    AppLocalizations.of(context)!.scheduledOnThisDevice,
    () => toggle(key, !s.get(key, false)),
    trailing: Switch(
      value: s.get(key, false),
      onChanged: (v) => toggle(key, v),
    ),
  );
  return [
    _section(context, AppLocalizations.of(context)!.reminders, [
      reminder(
        'dailyReminder',
        Icons.today_outlined,
        AppLocalizations.of(context)!.dailyExpenseReminder,
      ),
      _tile(
        context,
        Icons.schedule_rounded,
        AppLocalizations.of(context)!.reminderTime,
        s.get('reminderTime', '20:00'),
        () async {
          final parts = s.get('reminderTime', '20:00').split(':');
          final chosen = await showTimePicker(
            context: context,
            initialTime: TimeOfDay(
              hour: int.parse(parts[0]),
              minute: int.parse(parts[1]),
            ),
          );
          if (chosen == null || !context.mounted) return;
          final time =
              '${chosen.hour.toString().padLeft(2, '0')}:${chosen.minute.toString().padLeft(2, '0')}';
          await _run(context, () async {
            final next = s.withValue('reminderTime', time);
            for (final key in [
              'dailyReminder',
              'weeklySummary',
              'monthlyReport',
            ]) {
              if (s.get(key, false)) {
                await NotificationService.setReminder(key, true, next);
              }
            }
            await ref.read(settingsProvider.notifier).set('reminderTime', time);
          });
        },
      ),
      reminder(
        'weeklySummary',
        Icons.calendar_view_week_rounded,
        AppLocalizations.of(context)!.weeklyReviewReminder,
      ),
      reminder(
        'monthlyReport',
        Icons.calendar_month_outlined,
        AppLocalizations.of(context)!.monthlyReportReminder,
      ),
    ]),
    _section(context, AppLocalizations.of(context)!.financialAlerts, [
      _tile(
        context,
        Icons.warning_amber_rounded,
        AppLocalizations.of(context)!.budgetLimitAlerts,
        AppLocalizations.of(context)!.alertWhenSpendingCrossesAThreshold,
        () => _toggleAlert(
          context,
          ref,
          'budgetAlerts',
          !s.get('budgetAlerts', false),
        ),
        trailing: Switch(
          value: s.get('budgetAlerts', false),
          onChanged: (v) => _toggleAlert(context, ref, 'budgetAlerts', v),
        ),
      ),
      if (s.get('budgetAlerts', false))
        for (final threshold in [75, 90, 100])
          _tile(
            context,
            Icons.tune_rounded,
            AppLocalizations.of(context)!.budgetThresholdUsed(threshold),
            AppLocalizations.of(context)!.notifyAtThisLevel,
            () => _set(
              context,
              ref,
              'threshold$threshold',
              !s.get('threshold$threshold', true),
            ),
            trailing: Switch(
              value: s.get('threshold$threshold', true),
              onChanged: (v) => _set(context, ref, 'threshold$threshold', v),
            ),
          ),
      _tile(
        context,
        Icons.flag_outlined,
        AppLocalizations.of(context)!.savingsGoalMilestones,
        AppLocalizations.of(context)!.label255075AndCompletion,
        () => _toggleAlert(
          context,
          ref,
          'goalMilestones',
          !s.get('goalMilestones', false),
        ),
        trailing: Switch(
          value: s.get('goalMilestones', false),
          onChanged: (v) => _toggleAlert(context, ref, 'goalMilestones', v),
        ),
      ),
    ]),
  ];
}

Future<void> _toggleAlert(
  BuildContext context,
  WidgetRef ref,
  String key,
  bool value,
) => _run(context, () async {
  if (value && !await NotificationService.requestPermission()) {
    throw const FormatException('Notifications permission denied');
  }
  await ref.read(settingsProvider.notifier).set(key, value);
});

List<Widget> _security(BuildContext context, WidgetRef ref) {
  final s = ref.watch(settingsProvider);
  return [
    _section(context, AppLocalizations.of(context)!.protection, [
      _tile(
        context,
        Icons.lock_outline_rounded,
        AppLocalizations.of(context)!.appLock,
        s.lockEnabled
            ? AppLocalizations.of(context)!.pinEnabled
            : AppLocalizations.of(context)!.off,
        () => _togglePin(context, ref, s.lockEnabled),
        trailing: Switch(
          value: s.lockEnabled,
          onChanged: (_) => _togglePin(context, ref, s.lockEnabled),
        ),
      ),
      if (s.lockEnabled) ...[
        _tile(
          context,
          Icons.fingerprint_rounded,
          AppLocalizations.of(context)!.biometrics,
          AppLocalizations.of(context)!.unlockWithFingerprintOrFace,
          () => _toggleBiometric(context, ref, s.biometric),
          trailing: Switch(
            value: s.biometric,
            onChanged: (_) => _toggleBiometric(context, ref, s.biometric),
          ),
        ),
        _tile(
          context,
          Icons.timer_outlined,
          AppLocalizations.of(context)!.automaticLock,
          switch (s.lockDelay) {
            1 => AppLocalizations.of(context)!.label1Minute,
            5 => AppLocalizations.of(context)!.label5Minutes,
            15 => AppLocalizations.of(context)!.label15Minutes,
            _ => AppLocalizations.of(context)!.immediately,
          },
          () async {
            final value = await _choice(
              context,
              AppLocalizations.of(context)!.automaticLock,
              {
                '0': AppLocalizations.of(context)!.immediately,
                '1': AppLocalizations.of(context)!.label1Minute,
                '5': AppLocalizations.of(context)!.label5Minutes,
                '15': AppLocalizations.of(context)!.label15Minutes,
              },
            );
            if (value != null && context.mounted) {
              await _set(context, ref, 'lockDelay', int.parse(value));
            }
          },
        ),
      ],
    ]),
    _section(context, AppLocalizations.of(context)!.sensitiveInformation, [
      _tile(
        context,
        Icons.visibility_off_outlined,
        AppLocalizations.of(context)!.hideBalances,
        AppLocalizations.of(context)!.maskDashboardAmounts,
        () => _set(context, ref, 'hideBalances', !s.hideBalances),
        trailing: Switch(
          value: s.hideBalances,
          onChanged: (v) => _set(context, ref, 'hideBalances', v),
        ),
      ),
      _tile(
        context,
        Icons.phonelink_lock_outlined,
        AppLocalizations.of(context)!.privateAppPreview,
        AppLocalizations.of(context)!.blockScreenshotsAndRecentAppPreviews,
        () => _set(context, ref, 'privacyMode', !s.privacyMode),
        trailing: Switch(
          value: s.privacyMode,
          onChanged: (v) => _set(context, ref, 'privacyMode', v),
        ),
      ),
    ]),
  ];
}

Future<void> _togglePin(
  BuildContext context,
  WidgetRef ref,
  bool enabled,
) async {
  if (enabled) {
    final pin = await _textInput(
      context,
      AppLocalizations.of(context)!.enterCurrentPIN,
      secret: true,
      keyboard: TextInputType.number,
    );
    if (pin == null || !context.mounted) {
      return;
    }
    final valid = await SecurityService.verifyPin(pin);
    if (!valid || !context.mounted) {
      return;
    }
    await _run(context, () async {
      await ref.read(settingsProvider.notifier).set('lockEnabled', false);
      await ref.read(settingsProvider.notifier).set('biometric', false);
      await SecurityService.clearPin();
    });
  } else {
    final pin = await _textInput(
      context,
      AppLocalizations.of(context)!.createA48DigitPIN,
      secret: true,
      keyboard: TextInputType.number,
    );
    if (pin == null ||
        !context.mounted ||
        !RegExp(r'^\d{4,8}$').hasMatch(pin)) {
      return;
    }
    final repeat = await _textInput(
      context,
      AppLocalizations.of(context)!.confirmPIN,
      secret: true,
      keyboard: TextInputType.number,
    );
    if (repeat != pin || !context.mounted) return;
    await _run(context, () async {
      await SecurityService.setPin(pin);
      await ref.read(settingsProvider.notifier).set('lockEnabled', true);
    });
  }
}

Future<void> _toggleBiometric(
  BuildContext context,
  WidgetRef ref,
  bool enabled,
) => _run(context, () async {
  if (enabled) {
    await ref.read(settingsProvider.notifier).set('biometric', false);
  } else {
    final success = await SecurityService.authenticateBiometric(
      Localizations.localeOf(context),
    );
    if (!success) {
      throw const FormatException('Biometric authentication unavailable');
    }
    await ref.read(settingsProvider.notifier).set('biometric', true);
  }
});

List<Widget> _insights(BuildContext context, WidgetRef ref) {
  final s = ref.watch(settingsProvider);
  Widget toggle(String key, IconData icon, String label, String description) =>
      _tile(
        context,
        icon,
        label,
        description,
        () => _set(context, ref, key, !s.get(key, true)),
        trailing: Switch(
          value: s.get(key, true),
          onChanged: (value) => _set(context, ref, key, value),
        ),
      );
  return [
    _section(context, AppLocalizations.of(context)!.offlineInsights, [
      toggle(
        'insightsEnabled',
        Icons.insights_outlined,
        AppLocalizations.of(context)!.enableFinancialInsights,
        AppLocalizations.of(context)!.calculatedOnThisDevice,
      ),
      if (s.get('insightsEnabled', true)) ...[
        toggle(
          'showBudgetInsight',
          Icons.pie_chart_outline_rounded,
          AppLocalizations.of(context)!.budgetProgressOnHome,
          AppLocalizations.of(context)!.spendingAgainstYourBudget,
        ),
        toggle(
          'comparisonInsight',
          Icons.compare_arrows_rounded,
          AppLocalizations.of(context)!.spendingComparison,
          AppLocalizations.of(context)!.compareWithThePreviousPeriod,
        ),
        toggle(
          'savingsInsight',
          Icons.savings_outlined,
          AppLocalizations.of(context)!.savingsSuggestion,
          AppLocalizations.of(context)!.showRemainingIncomeAfterSpending,
        ),
        toggle(
          'summaryInsight',
          Icons.summarize_outlined,
          AppLocalizations.of(context)!.financialPeriodSummary,
          AppLocalizations.of(context)!.showRecordedIncomeAndExpenses,
        ),
      ],
    ]),
  ];
}

List<Widget> _data(BuildContext context, WidgetRef ref) => [
  _section(context, AppLocalizations.of(context)!.exportAndBackup, [
    _tile(
      context,
      Icons.table_chart_outlined,
      AppLocalizations.of(context)!.exportCSV,
      AppLocalizations.of(context)!.transactionHistory,
      () => _run(context, () => DataPortability.exportCsv(ref)),
    ),
    _tile(
      context,
      Icons.picture_as_pdf_outlined,
      AppLocalizations.of(context)!.exportPDFReport,
      AppLocalizations.of(context)!.financialSummary,
      () => _run(context, () => DataPortability.exportPdf(ref)),
    ),
    _tile(
      context,
      Icons.backup_outlined,
      AppLocalizations.of(context)!.createBackup,
      AppLocalizations.of(context)!.financialDataAndPreferences,
      () => _run(context, () => DataPortability.exportBackup(ref)),
    ),
    _tile(
      context,
      Icons.settings_backup_restore_rounded,
      AppLocalizations.of(context)!.restoreBackup,
      AppLocalizations.of(context)!.replacesCurrentFinancialData,
      () async {
        if (!await _confirm(
          context,
          AppLocalizations.of(context)!.restoreBackup2,
          AppLocalizations.of(
            context,
          )!.makeABackupFirstRestoringReplacesTransactionsAnd,
        )) {
          return;
        }
        if (context.mounted) {
          await _run(context, () async {
            await DataPortability.restoreBackup(ref);
          });
        }
      },
    ),
  ]),
  _section(context, AppLocalizations.of(context)!.deleteData, [
    _tile(
      context,
      Icons.delete_outline_rounded,
      AppLocalizations.of(context)!.clearTransactionHistory,
      AppLocalizations.of(context)!.goalsRemainSaved,
      () async {
        if (!await _confirm(
          context,
          AppLocalizations.of(context)!.deleteAllTransactions,
          AppLocalizations.of(context)!.thisCannotBeUndoneExportABackupFirst,
          destructive: true,
        )) {
          return;
        }
        if (context.mounted) {
          await _run(context, () async {
            await ref.read(financeRepositoryProvider).clearTransactions();
            ref.invalidate(transactionsProvider);
          });
        }
      },
    ),
    _tile(
      context,
      Icons.restart_alt_rounded,
      AppLocalizations.of(context)!.resetAppData,
      AppLocalizations.of(context)!.deleteTransactionsGoalsAndPreferences,
      () async {
        if (!await _confirm(
          context,
          AppLocalizations.of(context)!.resetGaddash,
          AppLocalizations.of(
            context,
          )!.allLocalFinancialRecordsAndPreferencesWillBe,
          destructive: true,
        )) {
          return;
        }
        if (context.mounted) {
          await _run(context, () async {
            final avatar = ref.read(settingsProvider).avatar;
            await NotificationService.cancelAll();
            await ref.read(financeRepositoryProvider).resetFinancialData();
            await ref.read(settingsProvider.notifier).reset();
            await SecurityService.clearPin();
            if (avatar.isNotEmpty) {
              final file = File(avatar);
              if (await file.exists()) await file.delete();
            }
            ref.invalidate(transactionsProvider);
            ref.invalidate(goalsProvider);
          });
        }
      },
    ),
  ]),
];

Widget _about(BuildContext context) {
  final strings = AppLocalizations.of(context)!;
  final colors = Theme.of(context).colorScheme;

  return Column(
    children: [
      Expanded(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: colors.outlineVariant),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final scale =
                  (constraints.maxHeight / 600).clamp(0.95, 1.2).toDouble();
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.account_balance_wallet_rounded,
                            color: colors.primary,
                            size: 30 * scale,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            strings.appName,
                            style: Theme.of(
                              context,
                            ).textTheme.titleLarge?.copyWith(
                              fontSize: 26 * scale,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        strings.aboutAppDescription,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 20 * scale,
                          height: 1.65,
                        ),
                      ),
                      Text(
                        strings.aboutAppBenefit,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colors.onSurfaceVariant,
                          fontSize: 18 * scale,
                          height: 1.65,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
      const SizedBox(height: 10),
      FutureBuilder<Map<Object?, Object?>?>(
        future: const MethodChannel(
          'gaddash/privacy',
        ).invokeMapMethod<Object?, Object?>('getAppInfo'),
        builder: (context, snapshot) {
          final version = snapshot.data?['version']?.toString();
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            leading: Icon(Icons.new_releases_outlined, color: colors.primary),
            title: Text(strings.installedVersion),
            subtitle: Text(version?.isNotEmpty == true ? version! : '…'),
          );
        },
      ),
    ],
  );
}

class CategoryManagerScreen extends ConsumerWidget {
  const CategoryManagerScreen({super.key});

  Future<void> _edit(
    BuildContext context,
    WidgetRef ref,
    ExpenseCategory? existing,
  ) async {
    final current = ref.read(settingsProvider).categories;
    final displayedName =
        existing == null ? '' : localizedCategory(context, existing.name);
    final enteredName = await _textInput(
      context,
      existing == null
          ? AppLocalizations.of(context)!.newCategory
          : AppLocalizations.of(context)!.categoryName,
      initial: displayedName,
    );
    final name =
        existing != null && enteredName == displayedName
            ? existing.name
            : enteredName;
    if (name == null || name.isEmpty || !context.mounted) return;
    if (current.any(
      (c) =>
          c.name.toLowerCase() == name.toLowerCase() &&
          c.name != existing?.name,
    )) {
      return;
    }
    final icon =
        await _choice(context, AppLocalizations.of(context)!.chooseIcon, {
          'food': AppLocalizations.of(context)!.food,
          'car': AppLocalizations.of(context)!.transport,
          'shopping': AppLocalizations.of(context)!.shopping,
          'receipt': AppLocalizations.of(context)!.bills,
          'health': AppLocalizations.of(context)!.health,
          'home': AppLocalizations.of(context)!.home,
          'travel': AppLocalizations.of(context)!.travel,
          'education': AppLocalizations.of(context)!.education,
          'gift': AppLocalizations.of(context)!.gift,
          'category': AppLocalizations.of(context)!.other,
        });
    if (icon == null || !context.mounted) return;
    final color =
        await _choice(context, AppLocalizations.of(context)!.chooseColor, {
          '078F78': AppLocalizations.of(context)!.emerald,
          '2575A7': AppLocalizations.of(context)!.ocean,
          '7964AC': AppLocalizations.of(context)!.purple,
          'E88870': AppLocalizations.of(context)!.coral,
          'E7B965': AppLocalizations.of(context)!.gold,
        });
    if (color == null || !context.mounted) return;
    await _run(context, () async {
      final next = ExpenseCategory(
        name,
        icon,
        int.parse('FF$color', radix: 16),
        archived: existing?.archived ?? false,
      );
      if (existing == null) {
        current.add(next);
      } else {
        if (existing.name != name) {
          await ref
              .read(financeRepositoryProvider)
              .renameCategory(existing.name, name);
          ref.invalidate(transactionsProvider);
          if (ref.read(settingsProvider).defaultCategory == existing.name) {
            await ref
                .read(settingsProvider.notifier)
                .set('defaultCategory', name);
          }
        }
        current[current.indexWhere((c) => c.name == existing.name)] = next;
      }
      await ref.read(settingsProvider.notifier).setCategories(current);
    });
  }

  Future<void> _archive(
    BuildContext context,
    WidgetRef ref,
    ExpenseCategory category,
  ) async {
    final categories = ref.read(settingsProvider).categories;
    if (!category.archived &&
        categories.where((c) => !c.archived).length == 1) {
      return;
    }
    final index = categories.indexWhere((c) => c.name == category.name);
    categories[index] = category.copyWith(archived: !category.archived);
    if (!category.archived &&
        ref.read(settingsProvider).defaultCategory == category.name) {
      await ref
          .read(settingsProvider.notifier)
          .set(
            'defaultCategory',
            categories.firstWhere((c) => !c.archived).name,
          );
    }
    if (context.mounted) {
      await _set(
        context,
        ref,
        'categories',
        categories.map((c) => c.toMap()).toList(),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(settingsProvider).categories;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.manageCategories),
        actions: [
          IconButton(
            tooltip: AppLocalizations.of(context)!.addCategory,
            onPressed: () => _edit(context, ref, null),
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
      body: ReorderableListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        itemCount: categories.length,
        onReorder: (oldIndex, newIndex) {
          final reordered = [...categories];
          if (newIndex > oldIndex) newIndex--;
          reordered.insert(newIndex, reordered.removeAt(oldIndex));
          _run(
            context,
            () => ref.read(settingsProvider.notifier).setCategories(reordered),
          );
        },
        itemBuilder: (context, index) {
          final category = categories[index];
          return Card(
            key: ValueKey(category.name),
            margin: const EdgeInsets.only(bottom: 9),
            child: ListTile(
              onTap: () => _edit(context, ref, category),
              leading: CircleAvatar(
                backgroundColor: Color(category.color).withValues(alpha: .15),
                child: Icon(category.iconData, color: Color(category.color)),
              ),
              title: Text(localizedCategory(context, category.name)),
              subtitle:
                  category.archived
                      ? Text(AppLocalizations.of(context)!.archived)
                      : null,
              trailing: PopupMenuButton<String>(
                onSelected:
                    (value) =>
                        value == 'edit'
                            ? _edit(context, ref, category)
                            : _archive(context, ref, category),
                itemBuilder:
                    (_) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Text(AppLocalizations.of(context)!.edit),
                      ),
                      PopupMenuItem(
                        value: 'archive',
                        child: Text(
                          category.archived
                              ? AppLocalizations.of(context)!.restore
                              : AppLocalizations.of(context)!.archive,
                        ),
                      ),
                    ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _edit(context, ref, null),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
