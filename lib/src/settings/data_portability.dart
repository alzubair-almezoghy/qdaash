import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../data/finance_repository.dart';
import '../l10n/financial_labels.dart';
import '../../l10n/generated/app_localizations.dart';
import 'app_settings.dart';
import 'notification_service.dart';

class DataPortability {
  static const _platform = MethodChannel('gaddash/privacy');
  static Future<File> _file(String name, List<int> bytes) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$name');
    return file.writeAsBytes(bytes, flush: true);
  }

  static Future<void> _share(File file) async {
    await _platform.invokeMethod<void>('shareFile', file.path);
  }

  static Future<void> exportBackup(WidgetRef ref) async {
    final data = await ref.read(financeRepositoryProvider).snapshot();
    final preferences =
        Map<String, dynamic>.from(ref.read(settingsProvider).values)
          ..remove('lockEnabled')
          ..remove('biometric')
          ..remove('avatar');
    data['preferences'] = preferences;
    final avatarPath = ref.read(settingsProvider).avatar;
    if (avatarPath.isNotEmpty) {
      final image = File(avatarPath);
      if (await image.exists() && await image.length() <= 3 * 1024 * 1024) {
        data['profileImage'] = base64Encode(await image.readAsBytes());
      }
    }
    final file = await _file(
      'gaddash-backup-${DateTime.now().millisecondsSinceEpoch}.json',
      utf8.encode(jsonEncode(data)),
    );
    await _share(file);
  }

  static Future<bool> restoreBackup(WidgetRef ref) async {
    final picked = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (picked == null) return false;
    final bytes =
        picked.files.single.bytes ??
        await File(picked.files.single.path!).readAsBytes();
    if (bytes.length > 20 * 1024 * 1024) {
      throw const FormatException('Backup is too large');
    }
    final decoded = jsonDecode(utf8.decode(bytes));
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Invalid backup');
    }
    final preferences = decoded['preferences'];
    if (preferences != null && preferences is! Map) {
      throw const FormatException('Invalid preferences');
    }
    final safe =
        preferences is Map
            ? (Map<String, dynamic>.from(preferences)
              ..remove('lockEnabled')
              ..remove('biometric')
              ..remove('avatar'))
            : <String, dynamic>{};
    final photo = decoded['profileImage'];
    if (photo != null && (photo is! String || photo.length > 5 * 1024 * 1024)) {
      throw const FormatException('Invalid profile image');
    }
    final photoBytes = photo is String ? base64Decode(photo) : null;
    await ref.read(financeRepositoryProvider).restore(decoded);
    if (photoBytes != null) {
      final dir = await getApplicationSupportDirectory();
      final path = '${dir.path}/gaddash_profile.jpg';
      await File(path).writeAsBytes(photoBytes, flush: true);
      safe['avatar'] = path;
    }
    if (safe.isNotEmpty) {
      await ref
          .read(settingsProvider.notifier)
          .replace(
            AppSettings({...ref.read(settingsProvider).values, ...safe}),
          );
      final settings = ref.read(settingsProvider);
      for (final key in ['dailyReminder', 'weeklySummary', 'monthlyReport']) {
        if (settings.get(key, false)) {
          try {
            await NotificationService.setReminder(key, true, settings);
          } catch (_) {
            await ref.read(settingsProvider.notifier).set(key, false);
          }
        }
      }
    }
    ref.invalidate(transactionsProvider);
    ref.invalidate(goalsProvider);
    return true;
  }

  static String _csv(Object? value) =>
      '"${(value ?? '').toString().replaceAll('"', '""')}"';

  static Future<void> exportCsv(WidgetRef ref) async {
    final rows = await ref.read(financeRepositoryProvider).transactions();
    final csv = StringBuffer(
      'id,date,type,amount,currency,category,wallet,note\r\n',
    );
    for (final row in rows) {
      csv.writeln(
        [
          row.id,
          row.date.toIso8601String(),
          row.isIncome ? 'income' : 'expense',
          row.amount,
          'LYD',
          row.category,
          row.wallet,
          row.note,
        ].map(_csv).join(','),
      );
    }
    final file = await _file(
      'gaddash-transactions.csv',
      utf8.encode('\uFEFF$csv'),
    );
    await _share(file);
  }

  static Future<void> exportPdf(WidgetRef ref) async {
    final rows = await ref.read(financeRepositoryProvider).transactions();
    final settings = ref.read(settingsProvider);
    final locale = Locale(settings.language);
    final l10n = lookupAppLocalizations(locale);
    final dateFormat = DateFormat.yMMMMd(locale.toLanguageTag());
    String pdfDate(DateTime value) => dateFormat
        .format(value)
        .replaceAll(RegExp(r'[\u200E\u200F\u061C]'), '');
    final numberFormat = NumberFormat.decimalPatternDigits(
      locale: locale.toLanguageTag(),
      decimalDigits: 2,
    );
    String money(double value) => 'LYD ${numberFormat.format(value)}';
    final income = rows
        .where((r) => r.isIncome)
        .fold<double>(0, (a, r) => a + r.amount);
    final expense = rows
        .where((r) => !r.isIncome)
        .fold<double>(0, (a, r) => a + r.amount);
    final font = pw.Font.ttf(
      await rootBundle.load('assets/fonts/IBMPlexSansArabic-Regular.ttf'),
    );
    final boldFont = pw.Font.ttf(
      await rootBundle.load('assets/fonts/IBMPlexSansArabic-SemiBold.ttf'),
    );
    final document = pw.Document(
      theme: pw.ThemeData.withFont(base: font, bold: boldFont),
    );
    document.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection:
            settings.language == 'ar'
                ? pw.TextDirection.rtl
                : pw.TextDirection.ltr,
        build:
            (_) => [
              pw.Text(
                l10n.pdfTitle,
                style: pw.TextStyle(
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 12),
              pw.Text(l10n.pdfGenerated(pdfDate(DateTime.now()))),
              pw.Text(l10n.pdfIncome(money(income))),
              pw.Text(l10n.pdfExpenses(money(expense))),
              pw.Text(l10n.pdfBalance(money(income - expense))),
              pw.SizedBox(height: 18),
              pw.TableHelper.fromTextArray(
                headerDirection:
                    settings.language == 'ar'
                        ? pw.TextDirection.rtl
                        : pw.TextDirection.ltr,
                tableDirection:
                    settings.language == 'ar'
                        ? pw.TextDirection.rtl
                        : pw.TextDirection.ltr,
                headers: [
                  l10n.pdfDateColumn,
                  l10n.pdfTypeColumn,
                  l10n.pdfCategoryColumn,
                  l10n.pdfWalletColumn,
                  l10n.pdfAmountColumn,
                ],
                data:
                    rows
                        .map(
                          (r) => [
                            pdfDate(r.date),
                            r.isIncome ? l10n.income : l10n.expense,
                            localizedCategoryWith(l10n, r.category),
                            localizedWalletWith(l10n, r.wallet),
                            numberFormat.format(r.amount),
                          ],
                        )
                        .toList(),
              ),
            ],
      ),
    );
    final file = await _file('gaddash-report.pdf', await document.save());
    await _share(file);
  }
}
