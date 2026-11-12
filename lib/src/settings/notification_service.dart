import 'package:flutter/widgets.dart';
import '../../l10n/generated/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import 'app_settings.dart';

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();
  static const _platform = MethodChannel('gaddash/privacy');
  static bool _initialized = false;

  static Future<void> _initialize() async {
    if (_initialized) return;
    tzdata.initializeTimeZones();
    final timezone = await _platform.invokeMethod<String>('getTimezone');
    tz.setLocalLocation(tz.getLocation(timezone ?? 'UTC'));
    await _plugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );
    _initialized = true;
  }

  static Future<bool> requestPermission() async {
    await _initialize();
    return await _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.requestNotificationsPermission() ??
        true;
  }

  static NotificationDetails _detailsFor(AppSettings settings) {
    final l10n = lookupAppLocalizations(Locale(settings.language));
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'gaddash_finance_${settings.language}',
        l10n.notificationChannelName,
        channelDescription: l10n.notificationChannelDescription,
        importance: Importance.defaultImportance,
      ),
    );
  }

  static int _id(String key) => switch (key) {
    'dailyReminder' => 101,
    'weeklySummary' => 102,
    'monthlyReport' => 103,
    _ => throw ArgumentError.value(key),
  };

  static Future<void> setReminder(
    String key,
    bool enabled,
    AppSettings settings,
  ) async {
    await _initialize();
    final id = _id(key);
    await _plugin.cancel(id);
    if (!enabled) return;
    if (!await requestPermission()) {
      throw const FormatException('Notifications permission denied');
    }
    final l10n = lookupAppLocalizations(Locale(settings.language));
    final parts = settings.get('reminderTime', '20:00').split(':');
    final hour = int.tryParse(parts.first) ?? 20;
    final minute = int.tryParse(parts.last) ?? 0;
    final now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime next;
    DateTimeComponents repeat;
    String title;
    String body;
    switch (key) {
      case 'dailyReminder':
        next = tz.TZDateTime(
          tz.local,
          now.year,
          now.month,
          now.day,
          hour,
          minute,
        );
        if (!next.isAfter(now)) next = next.add(const Duration(days: 1));
        repeat = DateTimeComponents.time;
        title = l10n.notificationTitle;
        body = l10n.dailyReminderBody;
        break;
      case 'weeklySummary':
        final days = (DateTime.monday - now.weekday + 7) % 7;
        next = tz.TZDateTime(
          tz.local,
          now.year,
          now.month,
          now.day + days,
          hour,
          minute,
        );
        if (!next.isAfter(now)) next = next.add(const Duration(days: 7));
        repeat = DateTimeComponents.dayOfWeekAndTime;
        title = l10n.notificationTitle;
        body = l10n.weeklyReminderBody;
        break;
      case 'monthlyReport':
        next = tz.TZDateTime(
          tz.local,
          now.year,
          now.month + 1,
          1,
          hour,
          minute,
        );
        repeat = DateTimeComponents.dayOfMonthAndTime;
        title = l10n.notificationTitle;
        body = l10n.monthlyReminderBody;
        break;
      default:
        throw ArgumentError.value(key);
    }
    await _plugin.zonedSchedule(
      id,
      title,
      body,
      next,
      _detailsFor(settings),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: repeat,
    );
  }

  static Future<void> cancelAll() async {
    await _initialize();
    await _plugin.cancelAll();
  }

  static Future<void> refreshScheduledContent(AppSettings settings) async {
    for (final key in ['dailyReminder', 'weeklySummary', 'monthlyReport']) {
      if (settings.get(key, false)) {
        await setReminder(key, true, settings);
      }
    }
  }

  static Future<void> budgetAlert(
    double previousSpent,
    double newSpent,
    AppSettings settings,
  ) async {
    if (!settings.get('budgetAlerts', false) || settings.monthlyBudget <= 0) {
      return;
    }
    if (!await requestPermission()) return;
    final l10n = lookupAppLocalizations(Locale(settings.language));
    for (final threshold in [75, 90, 100]) {
      if (!settings.get('threshold$threshold', true)) continue;
      final limit = settings.monthlyBudget * threshold / 100;
      if (previousSpent < limit && newSpent >= limit) {
        await _plugin.show(
          300 + threshold,
          l10n.budgetAlertTitle,
          l10n.budgetAlertBody(threshold),
          _detailsFor(settings),
        );
      }
    }
  }

  static Future<void> goalMilestone(
    int id,
    double before,
    double after,
    AppSettings settings,
  ) async {
    if (!settings.get('goalMilestones', false) || !await requestPermission()) {
      return;
    }
    final l10n = lookupAppLocalizations(Locale(settings.language));
    for (final threshold in [25, 50, 75, 100]) {
      if (before < threshold && after >= threshold) {
        await _plugin.show(
          10000 + id * 100 + threshold,
          l10n.goalAlertTitle,
          l10n.goalAlertBody(threshold),
          _detailsFor(settings),
        );
      }
    }
  }
}
