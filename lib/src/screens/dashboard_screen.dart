import '../../l10n/generated/app_localizations.dart';
import 'dart:math' as math;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../app.dart';
import '../data/finance_repository.dart';
import '../l10n/financial_labels.dart';
import '../settings/app_settings.dart';
import '../theme.dart';
import '../widgets/transaction_sheet.dart';

String _money(BuildContext context, double v, Locale l, {int digits = 0}) {
  if (!_MoneyVisibility.of(context)) return '••••';
  return formatMoney(v, l, MasarLocaleScope.of(context).settings);
}

class _MoneyVisibility extends InheritedWidget {
  const _MoneyVisibility({required this.visible, required super.child});
  final bool visible;
  static bool of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_MoneyVisibility>()?.visible ??
      true;
  @override
  bool updateShouldNotify(_MoneyVisibility oldWidget) =>
      visible != oldWidget.visible;
}

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});
  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  bool _revealed = false;

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final locale = Localizations.localeOf(context),
        ar = Localizations.localeOf(context).languageCode == 'ar';
    final tx = ref.watch(transactionsProvider),
        goals = ref.watch(goalsProvider);
    return _MoneyVisibility(
      visible: !settings.hideBalances || _revealed,
      child: tx.when(
        loading:
            () => const Center(
              child: CircularProgressIndicator(color: MasarColors.emerald),
            ),
        error:
            (_, __) => _Error(
              ar: ar,
              retry: () => ref.invalidate(transactionsProvider),
            ),
        data: (items) {
          final now = DateTime.now(),
              start = DateTime(
                now.year,
                now.month - (now.day < settings.monthStart ? 1 : 0),
                settings.monthStart,
              ),
              end = DateTime(start.year, start.month + 1, settings.monthStart),
              month = items.where(
                (t) => !t.date.isBefore(start) && t.date.isBefore(end),
              );
          final income = month
                  .where((t) => t.isIncome)
                  .fold<double>(0, (a, t) => a + t.amount),
              spent = month
                  .where((t) => !t.isIncome)
                  .fold<double>(0, (a, t) => a + t.amount);
          final priorStart = DateTime(
            start.year,
            start.month - 1,
            settings.monthStart,
          );
          final priorSpent = items
              .where(
                (t) =>
                    !t.isIncome &&
                    !t.date.isBefore(priorStart) &&
                    t.date.isBefore(start),
              )
              .fold<double>(0, (sum, t) => sum + t.amount);
          final balance = items.fold<double>(
                0,
                (a, t) => a + (t.isIncome ? t.amount : -t.amount),
              ),
              p = _Palette.of(context);
          return RefreshIndicator(
            color: Theme.of(context).colorScheme.primary,
            onRefresh: () async {
              ref.invalidate(transactionsProvider);
              ref.invalidate(goalsProvider);
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
                  sliver: SliverList.list(
                    children: [
                      _Header(
                        now: now,
                        showReveal: settings.hideBalances,
                        revealed: _revealed,
                        onReveal: () => setState(() => _revealed = !_revealed),
                      ),
                      const SizedBox(height: 22),
                      _Enter(
                        delay: 0,
                        child: _Balance(
                          balance: balance,
                          income: income,
                          spent: spent,
                          locale: locale,
                          ar: ar,
                        ),
                      ),
                      const SizedBox(height: 14),
                      _Enter(
                        delay: 50,
                        child: Row(
                          children: [
                            Expanded(
                              child: _Stat(
                                label: AppLocalizations.of(context)!.income2,
                                amount: income,
                                locale: locale,
                                icon: Icons.south_west_rounded,
                                color: Theme.of(context).colorScheme.primary,
                                p: p,
                              ),
                            ),
                            const SizedBox(width: 11),
                            Expanded(
                              child: _Stat(
                                label: AppLocalizations.of(context)!.spent,
                                amount: spent,
                                locale: locale,
                                icon: Icons.north_east_rounded,
                                color: MasarColors.coral,
                                p: p,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      if (settings.get('insightsEnabled', true) &&
                          settings.monthlyBudget > 0 &&
                          settings.get('showBudgetInsight', true)) ...[
                        _BudgetInsight(
                          spent: spent,
                          budget: settings.monthlyBudget,
                          visible: !settings.hideBalances || _revealed,
                          ar: ar,
                        ),
                        const SizedBox(height: 24),
                      ],
                      if (settings.get('insightsEnabled', true) &&
                          month.isNotEmpty) ...[
                        _FinancialInsights(
                          settings: settings,
                          ar: ar,
                          income: income,
                          spent: spent,
                          priorSpent: priorSpent,
                          transactionCount: month.length,
                          locale: locale,
                        ),
                        const SizedBox(height: 24),
                      ],
                      _Heading(
                        title: AppLocalizations.of(context)!.spendingTrend,
                        sub: AppLocalizations.of(context)!.last7DAYS,
                      ),
                      const SizedBox(height: 10),
                      _Chart(
                        items: items,
                        now: now,
                        locale: locale,
                        ar: ar,
                        p: p,
                      ),
                      const SizedBox(height: 24),
                      _Heading(
                        title: AppLocalizations.of(context)!.yourGoals,
                        action: AppLocalizations.of(context)!.seeAll,
                        onTap: () => context.go('/goals'),
                      ),
                      const SizedBox(height: 10),
                      goals.when(
                        loading:
                            () => const SizedBox(
                              height: 80,
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: MasarColors.emerald,
                                ),
                              ),
                            ),
                        error: (_, __) => const SizedBox.shrink(),
                        data:
                            (all) =>
                                all.isEmpty
                                    ? _GoalEmpty(
                                      ar: ar,
                                      p: p,
                                      onTap: () => context.go('/goals'),
                                    )
                                    : _Goal(
                                      goal: all.first,
                                      locale: locale,
                                      ar: ar,
                                      p: p,
                                      onTap: () => context.go('/goals'),
                                    ),
                      ),
                      const SizedBox(height: 24),
                      _Heading(
                        title: AppLocalizations.of(context)!.recentTransactions,
                        action: AppLocalizations.of(context)!.seeAll,
                        onTap: () => context.go('/activity'),
                      ),
                      const SizedBox(height: 10),
                      if (items.isEmpty)
                        _Empty(
                          ar: ar,
                          p: p,
                          onAdd: () => showTransactionSheet(context),
                        )
                      else
                        ...items
                            .take(4)
                            .map(
                              (t) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: _Transaction(
                                  t: t,
                                  locale: locale,
                                  ar: ar,
                                  p: p,
                                ),
                              ),
                            ),
                      const SizedBox(height: 12),
                      Center(
                        child: Text(
                          AppLocalizations.of(
                            context,
                          )!.yourDataStaysOnThisDevice,
                          style: TextStyle(color: p.muted, fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _FinancialInsights extends StatelessWidget {
  const _FinancialInsights({
    required this.settings,
    required this.ar,
    required this.income,
    required this.spent,
    required this.priorSpent,
    required this.transactionCount,
    required this.locale,
  });
  final AppSettings settings;
  final bool ar;
  final double income, spent, priorSpent;
  final int transactionCount;
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    final lines = <String>[];
    if (settings.get('comparisonInsight', true) && priorSpent > 0) {
      final change = ((spent - priorSpent) / priorSpent * 100).abs().round();
      lines.add(
        spent >= priorSpent
            ? AppLocalizations.of(context)!.insightSpendingRose(change)
            : AppLocalizations.of(context)!.insightSpendingFell(change),
      );
    }
    if (settings.get('savingsInsight', true) && income > spent) {
      lines.add(
        AppLocalizations.of(
          context,
        )!.insightSavingsRemain(_money(context, income - spent, locale)),
      );
    }
    if (settings.get('summaryInsight', true)) {
      lines.add(
        AppLocalizations.of(context)!.insightPeriodSummary(
          transactionCount,
          _money(context, spent, locale),
        ),
      );
    }
    if (lines.isEmpty) return const SizedBox.shrink();
    final accent = Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: accent.withValues(alpha: .17)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.insights_rounded, color: accent, size: 20),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.yourFinancialInsights,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 9),
          for (final line in lines)
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text(
                line,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _BudgetInsight extends StatelessWidget {
  const _BudgetInsight({
    required this.spent,
    required this.budget,
    required this.visible,
    required this.ar,
  });
  final double spent;
  final double budget;
  final bool visible;
  final bool ar;

  @override
  Widget build(BuildContext context) {
    final progress = (spent / budget).clamp(0.0, 1.0);
    final accent = Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(21),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.pie_chart_outline_rounded, color: accent, size: 21),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.monthlyBudget,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Text(
                visible
                    ? formatPercent(
                      spent / budget,
                      Localizations.localeOf(context),
                    )
                    : AppLocalizations.of(context)!.maskedPercent,
                style: TextStyle(color: accent, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 13),
          LinearProgressIndicator(
            value: progress,
            minHeight: 7,
            borderRadius: BorderRadius.circular(8),
            color: accent,
          ),
          const SizedBox(height: 9),
          Text(
            visible
                ? AppLocalizations.of(context)!.budgetRemainingAmount(
                  formatMoney(
                    (budget - spent).clamp(0, double.infinity).toDouble(),
                    Localizations.localeOf(context),
                    MasarLocaleScope.of(context).settings,
                  ),
                )
                : AppLocalizations.of(context)!.amountsHidden,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.now,
    required this.showReveal,
    required this.revealed,
    required this.onReveal,
  });
  final DateTime now;
  final bool showReveal;
  final bool revealed;
  final VoidCallback onReveal;
  @override
  Widget build(BuildContext context) {
    final scope = MasarLocaleScope.of(context),
        l = Localizations.localeOf(context),
        p = _Palette.of(context);
    final settings = scope.settings;
    final l10n = AppLocalizations.of(context)!;
    final hello =
        now.hour < 12
            ? l10n.goodMorning
            : now.hour < 18
            ? l10n.goodAfternoon
            : l10n.goodEvening;
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1BC4A0), Color(0xFF087964)],
            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: MasarColors.emerald.withValues(alpha: .22),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const Icon(
            Icons.show_chart_rounded,
            color: Colors.white,
            size: 25,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.qdaash,
                style: TextStyle(
                  color: p.text,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                settings.name.isEmpty
                    ? l10n.greetingWithDate(
                      hello,
                      DateFormat.MMMEd(l.toLanguageTag()).format(now),
                    )
                    : l10n.greetingWithName(hello, settings.name),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: p.muted, fontSize: 11),
              ),
            ],
          ),
        ),
        IconButton.filledTonal(
          tooltip: AppLocalizations.of(context)!.settings,
          style: IconButton.styleFrom(
            backgroundColor: p.card,
            foregroundColor: p.text,
            fixedSize: const Size(42, 42),
          ),
          onPressed: () => context.push('/settings'),
          icon: const Icon(Icons.settings_outlined, size: 19),
        ),
        if (showReveal)
          IconButton(
            tooltip:
                revealed
                    ? AppLocalizations.of(context)!.hideBalances
                    : AppLocalizations.of(context)!.showBalances,
            onPressed: onReveal,
            icon: Icon(
              revealed
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              size: 20,
            ),
          ),
        const SizedBox(width: 5),
        GestureDetector(
          onTap: () => context.push('/settings'),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: p.card,
              border: Border.all(color: p.line),
            ),
            child:
                settings.avatar.isNotEmpty && File(settings.avatar).existsSync()
                    ? ClipOval(
                      child: Image.file(
                        File(settings.avatar),
                        fit: BoxFit.cover,
                      ),
                    )
                    : Center(
                      child: const Icon(
                        Icons.person_rounded,
                        color: MasarColors.emerald,
                        size: 21,
                      ),
                    ),
          ),
        ),
      ],
    );
  }
}

class _Balance extends StatelessWidget {
  const _Balance({
    required this.balance,
    required this.income,
    required this.spent,
    required this.locale,
    required this.ar,
  });
  final double balance, income, spent;
  final Locale locale;
  final bool ar;
  @override
  Widget build(BuildContext context) => Container(
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(27),
      gradient: const LinearGradient(
        colors: [Color(0xFF168C78), Color(0xFF087865), Color(0xFF075D56)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      border: Border.all(color: Colors.white.withValues(alpha: .08)),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF061826).withValues(alpha: .18),
          blurRadius: 24,
          offset: const Offset(0, 11),
        ),
      ],
    ),
    child: Stack(
      children: [
        Positioned(
          top: -80,
          right: ar ? null : -45,
          left: ar ? -45 : null,
          child: Container(
            width: 190,
            height: 190,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: .045),
                width: 27,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF5DE0BB),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context)!.totalBALANCE,
                    style: const TextStyle(
                      color: Color(0xFFB5CFD1),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.account_balance_wallet_outlined,
                    color: Colors.white70,
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: 17),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: balance),
                duration: const Duration(milliseconds: 900),
                curve: Curves.easeOutCubic,
                builder:
                    (context, v, _) => Text(
                      _money(context, v, locale, digits: 2),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        height: 1.1,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -.8,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    ),
              ),
              const SizedBox(height: 5),
              Text(
                AppLocalizations.of(context)!.acrossAllRecordedActivity,
                style: const TextStyle(color: Color(0xFFAFC1C7), fontSize: 11),
              ),
              const SizedBox(height: 16),
              Container(height: 1, color: Colors.white.withValues(alpha: .1)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _Metric(
                      label: AppLocalizations.of(context)!.income3,
                      amount: income,
                      locale: locale,
                      color: const Color(0xFF70E0B8),
                      icon: Icons.south_west_rounded,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _Metric(
                      label: AppLocalizations.of(context)!.spending,
                      amount: spent,
                      locale: locale,
                      color: const Color(0xFFFFAE99),
                      icon: Icons.north_east_rounded,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.label,
    required this.amount,
    required this.locale,
    required this.color,
    required this.icon,
  });
  final String label;
  final double amount;
  final Locale locale;
  final Color color;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, color: color, size: 16),
      const SizedBox(width: 6),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFFB5CFD1),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
            FittedBox(
              alignment: AlignmentDirectional.centerStart,
              fit: BoxFit.scaleDown,
              child: Text(
                _money(context, amount, locale),
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.label,
    required this.amount,
    required this.locale,
    required this.icon,
    required this.color,
    required this.p,
  });
  final String label;
  final double amount;
  final Locale locale;
  final IconData icon;
  final Color color;
  final _Palette p;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: p.card,
      borderRadius: BorderRadius.circular(21),
      border: Border.all(color: p.line),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: p.dark ? .06 : .025),
          blurRadius: 13,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 31,
              height: 31,
              decoration: BoxDecoration(
                color: color.withValues(alpha: .13),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(icon, size: 17, color: color),
            ),
            const Spacer(),
            Icon(Icons.arrow_outward_rounded, size: 14, color: p.muted),
          ],
        ),
        const SizedBox(height: 11),
        Text(
          label,
          style: TextStyle(
            color: p.text,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 5),
        FittedBox(
          alignment: AlignmentDirectional.centerStart,
          fit: BoxFit.scaleDown,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: amount),
            duration: const Duration(milliseconds: 750),
            curve: Curves.easeOutCubic,
            builder:
                (context, v, _) => Text(
                  _money(context, v, locale),
                  style: TextStyle(
                    color: color,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
          ),
        ),
      ],
    ),
  );
}

class _Heading extends StatelessWidget {
  const _Heading({required this.title, this.sub, this.action, this.onTap});
  final String title;
  final String? sub, action;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    final p = _Palette.of(context);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: p.text,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (sub != null)
                Text(
                  sub!,
                  style: TextStyle(
                    color: p.muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: .7,
                  ),
                ),
            ],
          ),
        ),
        if (action != null)
          TextButton(
            onPressed: onTap,
            style: TextButton.styleFrom(
              foregroundColor: MasarColors.emerald,
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.symmetric(horizontal: 5),
            ),
            child: Text(
              action!,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ),
      ],
    );
  }
}

class _Chart extends StatefulWidget {
  const _Chart({
    required this.items,
    required this.now,
    required this.locale,
    required this.ar,
    required this.p,
  });
  final List<FinanceTransaction> items;
  final DateTime now;
  final Locale locale;
  final bool ar;
  final _Palette p;
  @override
  State<_Chart> createState() => _ChartState();
}

class _ChartState extends State<_Chart> {
  int? selected;
  @override
  Widget build(BuildContext context) {
    final start = DateTime(
      widget.now.year,
      widget.now.month,
      widget.now.day,
    ).subtract(const Duration(days: 6));
    final points = List.generate(7, (i) {
      final day = start.add(Duration(days: i));
      final amount = widget.items
          .where(
            (t) =>
                !t.isIncome &&
                t.date.year == day.year &&
                t.date.month == day.month &&
                t.date.day == day.day,
          )
          .fold<double>(0, (a, t) => a + t.amount);
      return _Point(day, amount);
    });
    final index = selected ?? 6,
        point = points[index],
        max = points.fold<double>(0, (m, p) => math.max(m, p.amount));
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 14, 15, 12),
      decoration: BoxDecoration(
        color: widget.p.card,
        borderRadius: BorderRadius.circular(23),
        border: Border.all(color: widget.p.line),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.insights_rounded,
                  size: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat.MMMEd(
                        widget.locale.toLanguageTag(),
                      ).format(point.date),
                      style: TextStyle(
                        color: widget.p.text,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.dailySpending,
                      style: TextStyle(color: widget.p.muted, fontSize: 11),
                    ),
                  ],
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: Text(
                  _money(context, point.amount, widget.locale),
                  key: ValueKey('$index-${point.amount}'),
                  style: TextStyle(
                    color: widget.p.text,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (d) {
              var i = (d.localPosition.dx / context.size!.width * 7).floor();
              if (widget.ar) i = 6 - i;
              setState(() => selected = i.clamp(0, 6));
            },
            child: SizedBox(
              height: 112,
              width: double.infinity,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 850),
                curve: Curves.easeOutCubic,
                builder:
                    (context, v, _) => CustomPaint(
                      painter: _ChartPainter(
                        values: points.map((x) => x.amount).toList(),
                        max: max,
                        selected: index,
                        rtl: widget.ar,
                        t: v,
                        grid: widget.p.line,
                        accent: Theme.of(context).colorScheme.primary,
                      ),
                    ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children:
                points
                    .map(
                      (x) => Expanded(
                        child: Center(
                          child: Text(
                            DateFormat.E(
                              widget.locale.toLanguageTag(),
                            ).format(x.date),
                            style: TextStyle(
                              color:
                                  x.date == point.date
                                      ? Theme.of(context).colorScheme.primary
                                      : widget.p.muted,
                              fontSize: 11,
                              fontWeight:
                                  x.date == point.date
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),
        ],
      ),
    );
  }
}

class _Point {
  const _Point(this.date, this.amount);
  final DateTime date;
  final double amount;
}

class _ChartPainter extends CustomPainter {
  const _ChartPainter({
    required this.values,
    required this.max,
    required this.selected,
    required this.rtl,
    required this.t,
    required this.grid,
    required this.accent,
  });
  final List<double> values;
  final double max, t;
  final int selected;
  final bool rtl;
  final Color grid, accent;
  @override
  void paint(Canvas c, Size s) {
    const pad = 4.0;
    final r = Rect.fromLTRB(pad, 7, s.width - pad, s.height - 7),
        gp =
            Paint()
              ..color = grid.withValues(alpha: .75)
              ..strokeWidth = 1;
    for (var i = 0; i < 3; i++) {
      final y = r.top + r.height * i / 2;
      c.drawLine(Offset(r.left, y), Offset(r.right, y), gp);
    }
    final pts = List.generate(7, (i) {
      final k = rtl ? 6 - i : i;
      final h = max == 0 ? .04 : values[k] / max * .82 + .05;
      return Offset(r.left + r.width * i / 6, r.bottom - h * r.height);
    });
    final n = (7 * t).ceil().clamp(1, 7), visible = pts.take(n).toList();
    if (visible.length == 1) {
      visible.add(Offset.lerp(pts[0], pts[1], t) ?? pts[1]);
    }
    final path = Path()..moveTo(visible[0].dx, visible[0].dy);
    for (var i = 1; i < visible.length; i++) {
      final a = visible[i - 1], b = visible[i], m = (a.dx + b.dx) / 2;
      path.cubicTo(m, a.dy, m, b.dy, b.dx, b.dy);
    }
    final fill =
        Path.from(path)
          ..lineTo(visible.last.dx, r.bottom)
          ..lineTo(visible.first.dx, r.bottom)
          ..close();
    c.drawPath(
      fill,
      Paint()
        ..shader = LinearGradient(
          colors: [
            accent.withValues(alpha: .15),
            accent.withValues(alpha: .01),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(r),
    );
    c.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.7
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..shader = const LinearGradient(
          colors: [Color(0xFF54D9B4), Color(0xFF078F78)],
        ).createShader(r),
    );
    final p = pts[rtl ? 6 - selected : selected];
    c.drawCircle(p, 9, Paint()..color = accent.withValues(alpha: .14));
    c.drawCircle(p, 4.5, Paint()..color = accent);
    c.drawCircle(p, 2, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant _ChartPainter o) =>
      o.values != values ||
      o.max != max ||
      o.selected != selected ||
      o.rtl != rtl ||
      o.t != t;
}

class _GoalEmpty extends StatelessWidget {
  const _GoalEmpty({required this.ar, required this.p, required this.onTap});
  final bool ar;
  final _Palette p;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Material(
    color: p.card,
    borderRadius: BorderRadius.circular(21),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(21),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(21),
          border: Border.all(color: p.line),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: MasarColors.gold.withValues(alpha: .16),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.flag_rounded, color: MasarColors.gold),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.startASavingsGoal,
                    style: TextStyle(
                      color: p.text,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)!.smallStepsAddUp2,
                    style: TextStyle(color: p.muted, fontSize: 11),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.add_circle_outline_rounded,
              color: MasarColors.emerald,
            ),
          ],
        ),
      ),
    ),
  );
}

class _Goal extends StatelessWidget {
  const _Goal({
    required this.goal,
    required this.locale,
    required this.ar,
    required this.p,
    required this.onTap,
  });
  final SavingsGoal goal;
  final Locale locale;
  final bool ar;
  final _Palette p;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final progress =
        goal.target <= 0 ? 0.0 : (goal.saved / goal.target).clamp(0.0, 1.0);
    return Material(
      color: p.card,
      borderRadius: BorderRadius.circular(21),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(21),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(21),
            border: Border.all(color: p.line),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: MasarColors.gold.withValues(alpha: .15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.flag_rounded,
                      color: MasarColors.gold,
                    ),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          goal.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: p.text,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${_money(context, goal.saved, locale)} ${AppLocalizations.of(context)!.savedOf} ${_money(context, goal.target, locale)}',
                          style: TextStyle(color: p.muted, fontSize: 11),
                        ),
                      ],
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
              const SizedBox(height: 12),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: progress),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutCubic,
                builder:
                    (context, v, _) => ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: LinearProgressIndicator(
                        value: v,
                        minHeight: 7,
                        backgroundColor: p.track,
                        color: MasarColors.emerald,
                      ),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.ar, required this.p, required this.onAdd});
  final bool ar;
  final _Palette p;
  final VoidCallback onAdd;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.fromLTRB(20, 21, 20, 18),
    decoration: BoxDecoration(
      color: p.card,
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: p.line),
    ),
    child: Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: MasarColors.emerald.withValues(alpha: .11),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.receipt_long_rounded,
            color: MasarColors.emerald,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          AppLocalizations.of(context)!.aCleanSlate,
          style: TextStyle(
            color: p.text,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        Text(
          AppLocalizations.of(
            context,
          )!.addYourFirstTransactionToSeeYourSpending,
          textAlign: TextAlign.center,
          style: TextStyle(color: p.muted, fontSize: 11, height: 1.45),
        ),
        const SizedBox(height: 13),
        FilledButton.icon(
          onPressed: onAdd,
          style: FilledButton.styleFrom(
            backgroundColor: MasarColors.emerald,
            foregroundColor: Colors.white,
          ),
          icon: const Icon(Icons.add_rounded, size: 17),
          label: Text(AppLocalizations.of(context)!.addTransaction),
        ),
      ],
    ),
  );
}

class _Transaction extends StatelessWidget {
  const _Transaction({
    required this.t,
    required this.locale,
    required this.ar,
    required this.p,
  });
  final FinanceTransaction t;
  final Locale locale;
  final bool ar;
  final _Palette p;
  @override
  Widget build(BuildContext context) {
    final cat = localizedCategory(context, t.category);
    final custom =
        MasarLocaleScope.of(context).settings.categories
            .where((category) => category.name == t.category)
            .firstOrNull;
    final color =
        t.isIncome
            ? MasarColors.emerald
            : custom == null
            ? MasarColors.coral
            : Color(custom.color);
    final icon =
        custom?.iconData ??
        switch (t.category.toLowerCase()) {
          'food' || 'dining' => Icons.restaurant_rounded,
          'transport' => Icons.directions_car_rounded,
          'shopping' => Icons.shopping_bag_rounded,
          'bills' => Icons.receipt_long_rounded,
          'health' => Icons.favorite_rounded,
          'salary' || 'income' => Icons.payments_rounded,
          _ => Icons.category_rounded,
        };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: p.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: p.line),
      ),
      child: Row(
        children: [
          Container(
            width: 41,
            height: 41,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 19),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.note.isEmpty ? cat : t.note,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: p.text,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '$cat \u{2022} ${DateFormat.MMMd(locale.toLanguageTag()).format(t.date)}',
                  style: TextStyle(color: p.muted, fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(width: 7),
          Text(
            '${t.isIncome ? '+' : '-'} ${_money(context, t.amount, locale)}',
            textDirection: Directionality.of(context),
            style: TextStyle(
              color: t.isIncome ? MasarColors.emerald : p.text,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _Error extends StatelessWidget {
  const _Error({required this.ar, required this.retry});
  final bool ar;
  final VoidCallback retry;
  @override
  Widget build(BuildContext context) {
    final p = _Palette.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.cloud_off_rounded, color: p.muted, size: 38),
          const SizedBox(height: 12),
          Text(
            AppLocalizations.of(context)!.yourLocalDataCouldNotBeOpened,
            style: TextStyle(color: p.text, fontWeight: FontWeight.w600),
          ),
          OutlinedButton(
            onPressed: retry,
            child: Text(AppLocalizations.of(context)!.tryAgain),
          ),
        ],
      ),
    );
  }
}

class _Enter extends StatelessWidget {
  const _Enter({required this.child, required this.delay});
  final Widget child;
  final int delay;
  @override
  Widget build(BuildContext context) =>
      MediaQuery.of(context).disableAnimations
          ? child
          : TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: Duration(milliseconds: 420 + delay),
            curve: Curves.easeOutCubic,
            builder:
                (context, v, child) => Opacity(
                  opacity: v,
                  child: Transform.translate(
                    offset: Offset(0, 11 * (1 - v)),
                    child: child,
                  ),
                ),
            child: child,
          );
}

class _Palette {
  const _Palette({
    required this.dark,
    required this.card,
    required this.line,
    required this.text,
    required this.muted,
    required this.track,
  });
  final bool dark;
  final Color card, line, text, muted, track;
  static _Palette of(BuildContext c) {
    final d = Theme.of(c).brightness == Brightness.dark;
    return _Palette(
      dark: d,
      card: d ? const Color(0xFF132B3B) : Colors.white,
      line: d ? Colors.white.withValues(alpha: .075) : const Color(0xFFE6ECE9),
      text: d ? const Color(0xFFF4F8F7) : MasarColors.ink,
      muted: d ? const Color(0xFF92A5B0) : MasarColors.muted,
      track: d ? Colors.white.withValues(alpha: .09) : const Color(0xFFEAF0ED),
    );
  }
}
