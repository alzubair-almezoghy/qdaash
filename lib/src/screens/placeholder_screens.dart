import '../../l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../app.dart';
import '../l10n/financial_labels.dart';
import '../settings/app_settings.dart';
import '../settings/notification_service.dart';

import '../data/finance_repository.dart';
import '../theme.dart';

class ActivityScreen extends ConsumerWidget {
  const ActivityScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = Localizations.localeOf(context);
    return ref
        .watch(transactionsProvider)
        .when(
          loading:
              () => const Center(
                child: CircularProgressIndicator(color: MasarColors.emerald),
              ),
          error:
              (e, _) => Center(
                child: Text(
                  AppLocalizations.of(context)!.couldNotLoadTransactions,
                ),
              ),
          data:
              (items) => CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(22, 26, 22, 12),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.activity,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            AppLocalizations.of(
                              context,
                            )!.everyEntryAllInOnePlace,
                            style: const TextStyle(color: MasarColors.muted),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  if (items.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: _EmptyPanel(
                        icon: Icons.receipt_long_rounded,
                        title: AppLocalizations.of(context)!.nothingHereYet,
                        message:
                            AppLocalizations.of(
                              context,
                            )!.yourIncomeAndSpendingWillShowUpHere,
                      ),
                    )
                  else
                    ..._groupedTransactionSlivers(items, locale),
                ],
              ),
        );
  }
}

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final locale = Localizations.localeOf(context);
    return ref
        .watch(transactionsProvider)
        .when(
          loading:
              () => const Center(
                child: CircularProgressIndicator(color: MasarColors.emerald),
              ),
          error:
              (e, _) => Center(
                child: Text(
                  AppLocalizations.of(context)!.couldNotLoadTheReport,
                ),
              ),
          data: (items) {
            final now = DateTime.now();
            final start = DateTime(
              now.year,
              now.month - (now.day < settings.monthStart ? 1 : 0),
              settings.monthStart,
            );
            final end = DateTime(
              start.year,
              start.month + 1,
              settings.monthStart,
            );
            final month =
                items
                    .where(
                      (t) => !t.date.isBefore(start) && t.date.isBefore(end),
                    )
                    .toList();
            final expenses = month.where((t) => !t.isIncome).toList();
            final total = expenses.fold<double>(0, (s, t) => s + t.amount);
            final grouped = <String, double>{};
            for (final t in expenses) {
              grouped.update(
                t.category,
                (v) => v + t.amount,
                ifAbsent: () => t.amount,
              );
            }
            final ranked =
                grouped.entries.toList()
                  ..sort((a, b) => b.value.compareTo(a.value));
            return ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(22, 25, 22, 30),
              children: [
                Text(
                  AppLocalizations.of(context)!.reports,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${DateFormat.yMMMd(locale.toLanguageTag()).format(start)} – ${DateFormat.yMMMd(locale.toLanguageTag()).format(end.subtract(const Duration(days: 1)))}',
                  style: const TextStyle(color: MasarColors.muted),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [MasarColors.emerald, Color(0xFF087865)],
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.totalSPENDING,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: .65),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(height: 9),
                      Text(
                        _money(context, total, locale),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        AppLocalizations.of(
                          context,
                        )!.basedOnTransactionsRecordedThisMonth,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: .66),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  AppLocalizations.of(context)!.byCategory,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                if (ranked.isEmpty)
                  _EmptyPanel(
                    icon: Icons.insert_chart_outlined_rounded,
                    title: AppLocalizations.of(context)!.yourReportIsWaiting,
                    message:
                        AppLocalizations.of(
                          context,
                        )!.recordAnExpenseToSeeYourSpendingBreakdown,
                  )
                else
                  ...ranked.map(
                    (e) => _CategoryBar(entry: e, total: total, locale: locale),
                  ),
                if (expenses.isNotEmpty) ...[
                  const SizedBox(height: 19),
                  _MetricRow(
                    icon: Icons.receipt_rounded,
                    label: AppLocalizations.of(context)!.expensesLogged,
                    value: '${expenses.length}',
                  ),
                  _MetricRow(
                    icon: Icons.bolt_rounded,
                    label: AppLocalizations.of(context)!.averagePerCalendarDay,
                    value: _money(
                      context,
                      total / (now.difference(start).inDays + 1),
                      locale,
                    ),
                  ),
                  _MetricRow(
                    icon: Icons.arrow_upward_rounded,
                    label: AppLocalizations.of(context)!.topCategory,
                    value: localizedCategory(context, ranked.first.key),
                  ),
                ],
                const SizedBox(height: 15),
                Text(
                  AppLocalizations.of(
                    context,
                  )!.allFiguresUseYourLocalRecordsNoSample,
                  style: const TextStyle(
                    color: MasarColors.muted,
                    fontSize: 11,
                    height: 1.5,
                  ),
                ),
              ],
            );
          },
        );
  }
}

class GoalsScreen extends ConsumerWidget {
  const GoalsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = Localizations.localeOf(context);
    return ref
        .watch(goalsProvider)
        .when(
          loading:
              () => const Center(
                child: CircularProgressIndicator(color: MasarColors.emerald),
              ),
          error:
              (e, _) => Center(
                child: Text(
                  AppLocalizations.of(context)!.couldNotLoadYourGoals,
                ),
              ),
          data:
              (goals) => CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(22, 25, 22, 14),
                    sliver: SliverToBoxAdapter(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.yourGoals,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  AppLocalizations.of(context)!.smallStepsAddUp,
                                  style: const TextStyle(
                                    color: MasarColors.muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton.filledTonal(
                            onPressed: () => _createGoal(context, ref),
                            icon: const Icon(
                              Icons.add_rounded,
                              color: MasarColors.emerald,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (goals.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: _EmptyPanel(
                        icon: Icons.flag_rounded,
                        title:
                            AppLocalizations.of(context)!.whatAreYouSavingFor,
                        message:
                            AppLocalizations.of(
                              context,
                            )!.createAGoalAndTrackYourProgressAt,
                        action: FilledButton.icon(
                          onPressed: () => _createGoal(context, ref),
                          icon: const Icon(Icons.add_rounded),
                          label: Text(
                            AppLocalizations.of(context)!.createAGoal,
                          ),
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(22, 0, 22, 30),
                      sliver: SliverList.builder(
                        itemCount: goals.length,
                        itemBuilder:
                            (context, index) => _GoalCard(
                              goal: goals[index],
                              locale: locale,
                              onContribute:
                                  () => _contribute(context, ref, goals[index]),
                            ),
                      ),
                    ),
                ],
              ),
        );
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({
    required this.goal,
    required this.locale,
    required this.onContribute,
  });
  final SavingsGoal goal;
  final Locale locale;
  final VoidCallback onContribute;
  @override
  Widget build(BuildContext context) {
    final progress = (goal.saved / goal.target).clamp(0.0, 1.0);
    final remaining = (goal.target - goal.saved).clamp(0.0, double.infinity);
    return Container(
      margin: const EdgeInsets.only(bottom: 13),
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(23),
        border: Border.all(color: MasarColors.line.withValues(alpha: .7)),
        boxShadow: [
          BoxShadow(
            color: MasarColors.navy.withValues(alpha: .035),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: MasarColors.mint.withValues(alpha: .45),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.flag_rounded,
                  color: MasarColors.emerald,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Text(
                  goal.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                formatPercent(progress, Localizations.localeOf(context)),
                style: const TextStyle(
                  color: MasarColors.emerald,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: progress),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeOutCubic,
            builder:
                (context, value, _) => ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: value,
                    minHeight: 9,
                    backgroundColor: MasarColors.ivory,
                    color: MasarColors.emerald,
                  ),
                ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                _money(context, goal.saved, locale),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Text(
                '${AppLocalizations.of(context)!.left}${_money(context, remaining, locale)}',
                style: const TextStyle(color: MasarColors.muted, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton.icon(
              onPressed: onContribute,
              icon: const Icon(Icons.add_circle_outline_rounded),
              label: Text(AppLocalizations.of(context)!.addSavings),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _createGoal(BuildContext context, WidgetRef ref) async {
  final name = TextEditingController();
  final target = TextEditingController();
  final valid = await showDialog<bool>(
    context: context,
    builder:
        (context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.newSavingsGoal),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: name,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.goalName,
                ),
              ),
              TextField(
                controller: target,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.goalTargetField,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(AppLocalizations.of(context)!.save),
            ),
          ],
        ),
  );
  final amount = double.tryParse(target.text.trim().replaceAll(',', '.'));
  if (valid == true &&
      name.text.trim().isNotEmpty &&
      amount != null &&
      amount > 0) {
    await ref
        .read(financeRepositoryProvider)
        .addGoal(
          SavingsGoal(
            id: null,
            name: name.text.trim(),
            target: amount,
            saved: 0,
          ),
        );
    ref.invalidate(goalsProvider);
  }
  name.dispose();
  target.dispose();
}

Future<void> _contribute(
  BuildContext context,
  WidgetRef ref,
  SavingsGoal goal,
) async {
  final amount = TextEditingController();
  final valid = await showDialog<bool>(
    context: context,
    builder:
        (context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.addToGoal),
          content: TextField(
            controller: amount,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.goalContributionField,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(AppLocalizations.of(context)!.add),
            ),
          ],
        ),
  );
  final value = double.tryParse(amount.text.trim().replaceAll(',', '.'));
  if (valid == true && value != null && value > 0) {
    await ref.read(financeRepositoryProvider).contribute(goal, value);
    ref.invalidate(goalsProvider);
    try {
      await NotificationService.goalMilestone(
        goal.id ?? 0,
        goal.saved / goal.target * 100,
        (goal.saved + value) / goal.target * 100,
        ref.read(settingsProvider),
      );
    } catch (_) {
      // Contributions remain saved even if notifications are unavailable.
    }
  }
  amount.dispose();
}

List<Widget> _groupedTransactionSlivers(
  List<FinanceTransaction> items,
  Locale locale,
) {
  final groups = <String, List<FinanceTransaction>>{};
  for (final item in items) {
    final key = DateFormat.yMMMMd(locale.toLanguageTag()).format(item.date);
    groups.putIfAbsent(key, () => []).add(item);
  }
  return groups.entries
      .map(
        (entry) => SliverPadding(
          padding: const EdgeInsets.fromLTRB(22, 2, 22, 8),
          sliver: SliverMainAxisGroup(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    entry.key,
                    style: const TextStyle(
                      color: MasarColors.muted,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SliverList.builder(
                itemCount: entry.value.length,
                itemBuilder:
                    (context, i) => _ActivityTile(
                      transaction: entry.value[i],
                      locale: locale,
                    ),
              ),
            ],
          ),
        ),
      )
      .toList();
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({required this.transaction, required this.locale});
  final FinanceTransaction transaction;
  final Locale locale;
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(18),
    ),
    child: Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color:
                transaction.isIncome
                    ? MasarColors.mint.withValues(alpha: .5)
                    : const Color(0xFFFFF0EB),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            transaction.isIncome
                ? Icons.south_west_rounded
                : Icons.north_east_rounded,
            color:
                transaction.isIncome ? MasarColors.emerald : MasarColors.coral,
          ),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                transaction.note.isEmpty
                    ? localizedCategory(context, transaction.category)
                    : transaction.note,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                '${localizedCategory(context, transaction.category)} · ${localizedWallet(context, transaction.wallet)}',
                style: const TextStyle(color: MasarColors.muted, fontSize: 11),
              ),
            ],
          ),
        ),
        Text(
          '${transaction.isIncome ? '+' : '−'} ${_money(context, transaction.amount, locale)}',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: transaction.isIncome ? MasarColors.emerald : null,
          ),
        ),
      ],
    ),
  );
}

class _CategoryBar extends StatelessWidget {
  const _CategoryBar({
    required this.entry,
    required this.total,
    required this.locale,
  });
  final MapEntry<String, double> entry;
  final double total;
  final Locale locale;
  @override
  Widget build(BuildContext context) {
    final share = total == 0 ? 0.0 : entry.value / total;
    return Padding(
      padding: const EdgeInsets.only(bottom: 17),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  localizedCategory(context, entry.key),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              Text(_money(context, entry.value, locale)),
              const SizedBox(width: 8),
              Text(
                formatPercent(share, Localizations.localeOf(context)),
                style: const TextStyle(color: MasarColors.muted, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: share),
            duration: const Duration(milliseconds: 750),
            curve: Curves.easeOutCubic,
            builder:
                (context, value, _) => ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: value,
                    minHeight: 8,
                    color:
                        share > .55 ? MasarColors.coral : MasarColors.emerald,
                    backgroundColor: const Color(0xFFE6EEE9),
                  ),
                ),
          ),
        ],
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label, value;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      children: [
        Icon(icon, size: 18, color: MasarColors.emerald),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: MasarColors.muted, fontSize: 12),
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        ),
      ],
    ),
  );
}

class _EmptyPanel extends StatelessWidget {
  const _EmptyPanel({
    required this.icon,
    required this.title,
    required this.message,
    this.action,
  });
  final IconData icon;
  final String title, message;
  final Widget? action;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
    child: Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 31),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: MasarColors.line.withValues(alpha: .7)),
          boxShadow: [
            BoxShadow(
              color: MasarColors.navy.withValues(alpha: .035),
              blurRadius: 18,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: MasarColors.mint.withValues(alpha: .42),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: MasarColors.emerald, size: 25),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 7),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: MasarColors.muted,
                fontSize: 12,
                height: 1.5,
              ),
            ),
            if (action != null) ...[const SizedBox(height: 17), action!],
          ],
        ),
      ),
    ),
  );
}

String _money(BuildContext context, double value, Locale locale) =>
    formatMoney(value, locale, MasarLocaleScope.of(context).settings);
