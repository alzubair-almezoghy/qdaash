import 'package:flutter/widgets.dart';

import '../../l10n/generated/app_localizations.dart';

/// Stored category names are stable identifiers. Only their presentation changes.
String localizedCategory(BuildContext context, String storedName) {
  return localizedCategoryWith(AppLocalizations.of(context)!, storedName);
}

String localizedCategoryWith(AppLocalizations l10n, String storedName) {
  return switch (storedName.toLowerCase()) {
    'food' || 'dining' => l10n.categoryFood,
    'transport' => l10n.categoryTransport,
    'shopping' => l10n.categoryShopping,
    'bills' => l10n.categoryBills,
    'health' => l10n.categoryHealth,
    'education' => l10n.categoryEducation,
    'entertainment' => l10n.categoryEntertainment,
    'housing' || 'home' => l10n.categoryHousing,
    'subscriptions' => l10n.categorySubscriptions,
    'other' => l10n.categoryOther,
    'salary' => l10n.categorySalary,
    'freelance' => l10n.categoryFreelance,
    'business' => l10n.categoryBusiness,
    'gift' => l10n.categoryGift,
    'travel' => l10n.categoryTravel,
    _ => storedName,
  };
}

String localizedWallet(BuildContext context, String storedName) =>
    localizedWalletWith(AppLocalizations.of(context)!, storedName);

String localizedWalletWith(AppLocalizations l10n, String storedName) =>
    storedName == 'Cash' ? l10n.walletCash : storedName;
