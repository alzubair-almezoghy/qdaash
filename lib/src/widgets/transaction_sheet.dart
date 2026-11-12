import '../../l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/finance_repository.dart';
import '../l10n/financial_labels.dart';
import '../settings/app_settings.dart';
import '../settings/notification_service.dart';
import '../theme.dart';

const _incomeCategories = ['Salary', 'Freelance', 'Business', 'Gift', 'Other'];

Future<void> showTransactionSheet(BuildContext context) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    builder: (_) => const TransactionSheet(),
  );
}

class TransactionSheet extends ConsumerStatefulWidget {
  const TransactionSheet({super.key});
  @override
  ConsumerState<TransactionSheet> createState() => _TransactionSheetState();
}

class _TransactionSheetState extends ConsumerState<TransactionSheet> {
  final _amount = TextEditingController();
  final _note = TextEditingController();
  bool _income = false;
  String _category = 'Food';
  String _wallet = 'Cash';
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _category = ref.read(settingsProvider).defaultCategory;
    _wallet = ref.read(settingsProvider).defaultWallet;
  }

  @override
  void dispose() {
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final catalog = ref.watch(settingsProvider).categories;
    final wallets = ref.watch(settingsProvider).wallets;
    if (!wallets.contains(_wallet)) _wallet = wallets.first;
    final categories =
        _income
            ? _incomeCategories
            : catalog
                .where((category) => !category.archived)
                .map((category) => category.name)
                .toList();
    if (!categories.contains(_category)) _category = categories.first;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        12,
        24,
        MediaQuery.viewInsetsOf(context).bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: MasarColors.line,
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.newTransaction,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: MasarColors.ivory,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  _TypeChoice(
                    label: AppLocalizations.of(context)!.expense,
                    selected: !_income,
                    onTap: () => setState(() => _income = false),
                  ),
                  _TypeChoice(
                    label: AppLocalizations.of(context)!.income,
                    selected: _income,
                    onTap: () => setState(() => _income = true),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            Text(
              AppLocalizations.of(context)!.amount,
              style: const TextStyle(
                color: MasarColors.muted,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'LYD',
                  style: TextStyle(
                    color: MasarColors.muted,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _amount,
                    autofocus: true,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -1,
                    ),
                    decoration: InputDecoration(
                      hintText: '0.00',
                      hintStyle: TextStyle(
                        color: MasarColors.muted.withValues(alpha: .45),
                      ),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 8),
            const SizedBox(height: 18),
            Text(
              AppLocalizations.of(context)!.category,
              style: const TextStyle(
                color: MasarColors.muted,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  categories
                      .map(
                        (item) => ChoiceChip(
                          label: Text(localizedCategory(context, item)),
                          avatar:
                              _income
                                  ? null
                                  : Icon(
                                    catalog
                                        .firstWhere(
                                          (category) => category.name == item,
                                        )
                                        .iconData,
                                    size: 16,
                                    color: Color(
                                      catalog
                                          .firstWhere(
                                            (category) => category.name == item,
                                          )
                                          .color,
                                    ),
                                  ),
                          selected: _category == item,
                          onSelected: (_) => setState(() => _category = item),
                          selectedColor:
                              _income
                                  ? MasarColors.mint
                                  : Color(
                                    catalog
                                        .firstWhere(
                                          (category) => category.name == item,
                                        )
                                        .color,
                                  ).withValues(alpha: .2),
                          backgroundColor: MasarColors.ivory,
                          side: BorderSide.none,
                          labelStyle: TextStyle(
                            color:
                                _category == item
                                    ? MasarColors.navy
                                    : MasarColors.muted,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                      .toList(),
            ),
            const SizedBox(height: 18),
            Text(
              AppLocalizations.of(context)!.wallet,
              style: const TextStyle(
                color: MasarColors.muted,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 9),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  wallets
                      .map(
                        (wallet) => ChoiceChip(
                          label: Text(localizedWallet(context, wallet)),
                          selected: _wallet == wallet,
                          onSelected: (_) => setState(() => _wallet = wallet),
                        ),
                      )
                      .toList(),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: _note,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.notes_rounded),
                hintText: AppLocalizations.of(context)!.addANoteOptional,
                filled: true,
                fillColor: MasarColors.ivory,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton(
                onPressed: _saving ? null : _save,
                style: FilledButton.styleFrom(
                  backgroundColor: MasarColors.emerald,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17),
                  ),
                ),
                child:
                    _saving
                        ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                        : Text(
                          AppLocalizations.of(context)!.saveTransaction,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    final amount = double.tryParse(_amount.text.trim().replaceAll(',', '.'));
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.enterPositiveAmount),
        ),
      );
      return;
    }
    setState(() => _saving = true);
    final settings = ref.read(settingsProvider);
    double previousSpent = 0;
    if (!_income && settings.monthlyBudget > 0) {
      final now = DateTime.now();
      final start = DateTime(
        now.year,
        now.month - (now.day < settings.monthStart ? 1 : 0),
        settings.monthStart,
      );
      final end = DateTime(start.year, start.month + 1, settings.monthStart);
      final previous = await ref.read(financeRepositoryProvider).transactions();
      previousSpent = previous
          .where(
            (t) =>
                !t.isIncome && !t.date.isBefore(start) && t.date.isBefore(end),
          )
          .fold<double>(0, (sum, t) => sum + t.amount);
    }
    await ref
        .read(financeRepositoryProvider)
        .add(
          FinanceTransaction(
            id: null,
            amount: amount,
            category: _category,
            note: _note.text.trim(),
            date: DateTime.now(),
            isIncome: _income,
            wallet: _wallet,
          ),
        );
    ref.invalidate(transactionsProvider);
    if (!_income) {
      try {
        await NotificationService.budgetAlert(
          previousSpent,
          previousSpent + amount,
          settings,
        );
      } catch (_) {
        // Saving a transaction must never depend on notification delivery.
      }
    }
    if (mounted) Navigator.pop(context);
  }
}

class _TypeChoice extends StatelessWidget {
  const _TypeChoice({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow:
                selected
                    ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .06),
                        blurRadius: 8,
                      ),
                    ]
                    : null,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: selected ? MasarColors.navy : MasarColors.muted,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
