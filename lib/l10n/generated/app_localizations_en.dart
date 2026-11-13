// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get notificationChannelName => 'qdaash reminders';

  @override
  String get notificationChannelDescription => 'Expense reminders and financial alerts';

  @override
  String get maskedPercent => '••%';

  @override
  String get goodMorning => 'Good morning';

  @override
  String get goodAfternoon => 'Good afternoon';

  @override
  String get goodEvening => 'Good evening';

  @override
  String greetingWithName(String greeting, String name) {
    return '$greeting, $name';
  }

  @override
  String greetingWithDate(String greeting, String date) {
    return '$greeting, $date';
  }

  @override
  String get goalTargetField => 'Target · LYD';

  @override
  String get goalContributionField => 'Amount · LYD';

  @override
  String get biometricPrompt => 'Unlock qdaash';

  @override
  String get pdfTitle => 'qdaash financial report';

  @override
  String pdfGenerated(String date) {
    return 'Generated $date';
  }

  @override
  String pdfIncome(String amount) {
    return 'Income: $amount';
  }

  @override
  String pdfExpenses(String amount) {
    return 'Expenses: $amount';
  }

  @override
  String pdfBalance(String amount) {
    return 'Balance: $amount';
  }

  @override
  String get pdfDateColumn => 'Date';

  @override
  String get pdfTypeColumn => 'Type';

  @override
  String get pdfCategoryColumn => 'Category';

  @override
  String get pdfWalletColumn => 'Wallet';

  @override
  String get pdfAmountColumn => 'Amount (LYD)';

  @override
  String get appName => 'qdaash';

  @override
  String get incorrectPin => 'Incorrect PIN';

  @override
  String get biometricUnavailable => 'Biometric check unavailable';

  @override
  String get enterPositiveAmount => 'Enter an amount greater than zero';

  @override
  String conversionRatePrompt(String currency) {
    return 'How much is 1 LYD in $currency?';
  }

  @override
  String financialMonthDay(int day) {
    return 'Day $day';
  }

  @override
  String budgetThresholdUsed(int percent) {
    return '$percent% used';
  }

  @override
  String get newCategory => 'New category';

  @override
  String get categoryName => 'Category name';

  @override
  String insightSpendingRose(int percent) {
    return 'Spending rose $percent% from the prior period';
  }

  @override
  String insightSpendingFell(int percent) {
    return 'Spending fell $percent% from the prior period';
  }

  @override
  String insightSavingsRemain(String amount) {
    return '$amount remains after spending';
  }

  @override
  String insightPeriodSummary(int count, String amount) {
    return '$count transactions this period · $amount spent';
  }

  @override
  String budgetRemainingAmount(String amount) {
    return '$amount remaining';
  }

  @override
  String get showBalances => 'Show balances';

  @override
  String get dailySpending => 'Daily spending';

  @override
  String get categoryFood => 'Food & Drinks';

  @override
  String get categoryTransport => 'Transportation';

  @override
  String get categoryShopping => 'Shopping';

  @override
  String get categoryBills => 'Bills';

  @override
  String get categoryHealth => 'Healthcare';

  @override
  String get categoryEducation => 'Education';

  @override
  String get categoryEntertainment => 'Entertainment';

  @override
  String get categoryHousing => 'Housing';

  @override
  String get categorySubscriptions => 'Subscriptions';

  @override
  String get categoryOther => 'Other';

  @override
  String get categorySalary => 'Salary';

  @override
  String get categoryFreelance => 'Freelance';

  @override
  String get categoryBusiness => 'Business';

  @override
  String get categoryGift => 'Gift';

  @override
  String get categoryTravel => 'Travel';

  @override
  String get walletCash => 'Cash';

  @override
  String get navHome => 'Home';

  @override
  String get navTransactions => 'Transactions';

  @override
  String get navReports => 'Reports';

  @override
  String get navGoals => 'Financial Goals';

  @override
  String get navAdd => 'Add transaction';

  @override
  String get collapseNavigation => 'Collapse navigation';

  @override
  String get expandNavigation => 'Expand navigation';

  @override
  String get notificationTitle => 'qdaash';

  @override
  String get dailyReminderBody => 'Record today\'s expenses';

  @override
  String get weeklyReminderBody => 'Review your spending this week';

  @override
  String get monthlyReminderBody => 'Your monthly report is ready';

  @override
  String get budgetAlertTitle => 'Budget alert';

  @override
  String budgetAlertBody(int percent) {
    return 'You used $percent% of your budget';
  }

  @override
  String get goalAlertTitle => 'Savings goal';

  @override
  String goalAlertBody(int percent) {
    return 'Your goal is $percent% complete';
  }

  @override
  String get aCleanSlate => 'A clean slate';

  @override
  String get aboutGaddash => 'About qdaash';

  @override
  String get aboutTheApp => 'About the app';

  @override
  String get aboutAppDescription => 'Qdaash is a personal finance app that helps you record income and expenses, organize them by category and wallet, and keep track of your budget and savings goals in one place. Clear reports make it easier to understand how your spending changes over time.';

  @override
  String get aboutAppBenefit => 'See where your money goes, notice expenses you may want to adjust, and plan savings and financial decisions with more confidence. The app works offline, and your financial records stay on your device.';

  @override
  String get accentColor => 'Accent color';

  @override
  String get acrossAllRecordedActivity => 'Across all recorded activity';

  @override
  String get activity => 'Activity';

  @override
  String get add => 'Add';

  @override
  String get addANoteOptional => 'Add a note (optional)';

  @override
  String get addCategory => 'Add category';

  @override
  String get addEditReorderAndArchive => 'Add, edit, reorder and archive';

  @override
  String get addSavings => 'Add savings';

  @override
  String get addToGoal => 'Add to goal';

  @override
  String get addTransaction => 'Add transaction';

  @override
  String get addWallet => 'Add wallet';

  @override
  String get addYourFirstTransactionToSeeYourSpending => 'Add your first transaction to see your spending take shape.';

  @override
  String get addYourName => 'Add your name';

  @override
  String get alertWhenSpendingCrossesAThreshold => 'Alert when spending crosses a threshold';

  @override
  String get allFiguresUseYourLocalRecordsNoSample => 'All figures use your local records. No sample values or estimates.';

  @override
  String get allLocalFinancialRecordsAndPreferencesWillBe => 'All local financial records and preferences will be removed.';

  @override
  String get amount => 'AMOUNT';

  @override
  String get amountsHidden => 'Amounts hidden';

  @override
  String get animations => 'Animations';

  @override
  String get appLock => 'App lock';

  @override
  String get appearance => 'Appearance';

  @override
  String get appearance2 => 'Appearance';

  @override
  String get appearance3 => 'Appearance';

  @override
  String get arabic => 'Arabic';

  @override
  String get archive => 'Archive';

  @override
  String get archived => 'Archived';

  @override
  String get automaticLock => 'Automatic lock';

  @override
  String get availableForNewTransactions => 'Available for new transactions';

  @override
  String get averagePerCalendarDay => 'Average per calendar day';

  @override
  String get baseCurrency => 'Base currency';

  @override
  String get basedOnTransactionsRecordedThisMonth => 'Based on transactions recorded this month';

  @override
  String get bills => 'Bills';

  @override
  String get biometrics => 'Biometrics';

  @override
  String get blockScreenshotsAndRecentAppPreviews => 'Block screenshots and recent-app previews';

  @override
  String get budgetAndCategories => 'Budget and categories';

  @override
  String get budgetLimitAlerts => 'Budget limit alerts';

  @override
  String get budgeting => 'Budgeting';

  @override
  String get byCategory => 'By category';

  @override
  String get cancel => 'Cancel';

  @override
  String get category => 'CATEGORY';

  @override
  String get chooseColor => 'Choose color';

  @override
  String get chooseFromGallery => 'Choose from gallery';

  @override
  String get chooseIcon => 'Choose icon';

  @override
  String get chooseTheme => 'Choose theme';

  @override
  String get chooseWallet => 'Choose wallet';

  @override
  String get clearTransactionHistory => 'Clear transaction history';

  @override
  String get confirm => 'Confirm';

  @override
  String get confirmPIN => 'Confirm PIN';

  @override
  String get control => 'Control';

  @override
  String get coral => 'Coral';

  @override
  String get couldNotCompleteAction => 'Could not complete action';

  @override
  String get couldNotLoadTheReport => 'Could not load the report';

  @override
  String get couldNotLoadTransactions => 'Could not load transactions';

  @override
  String get couldNotLoadYourGoals => 'Could not load your goals';

  @override
  String get createA48DigitPIN => 'Create a 4–8 digit PIN';

  @override
  String get createAGoal => 'Create a goal';

  @override
  String get createAGoalAndTrackYourProgressAt => 'Create a goal and track your progress at your own pace.';

  @override
  String get createBackup => 'Create backup';

  @override
  String get currency => 'Currency';

  @override
  String get currencyDisplay => 'Currency display';

  @override
  String get dark => 'Dark';

  @override
  String get dataManagement => 'Data management';

  @override
  String get decimalPlaces => 'Decimal places';

  @override
  String get defaultCategory => 'Default category';

  @override
  String get defaultExpenseCategory => 'Default expense category';

  @override
  String get defaultWallet => 'Default wallet';

  @override
  String get deleteAllTransactions => 'Delete all transactions?';

  @override
  String get deleteData => 'Delete data';

  @override
  String get deleteTransactionsGoalsAndPreferences => 'Delete transactions, goals and preferences';

  @override
  String get displayCurrency => 'Display currency';

  @override
  String get displayName => 'Display name';

  @override
  String get edit => 'Edit';

  @override
  String get education => 'Education';

  @override
  String get emerald => 'Emerald';

  @override
  String get enterCurrentPIN => 'Enter current PIN';

  @override
  String get everyEntryAllInOnePlace => 'Every entry, all in one place.';

  @override
  String get expense => 'Expense';

  @override
  String get expensesLogged => 'Expenses logged';

  @override
  String get exportAndBackup => 'Export and backup';

  @override
  String get exportBackupAndRestore => 'Export, backup and restore';

  @override
  String get exportCSV => 'Export CSV';

  @override
  String get exportPDFReport => 'Export PDF report';

  @override
  String get financialAlerts => 'Financial alerts';

  @override
  String get financialDataAndPreferences => 'Financial data and preferences';

  @override
  String get financialInsights => 'Financial insights';

  @override
  String get financialMonthStarts => 'Financial month starts';

  @override
  String get financialPreferences => 'Financial preferences';

  @override
  String get financialSummary => 'Financial summary';

  @override
  String get followSystem => 'Follow system';

  @override
  String get food => 'Food';

  @override
  String get full => 'Full';

  @override
  String get gaddash => 'qdaash';

  @override
  String get gift => 'Gift';

  @override
  String get goalName => 'Goal name';

  @override
  String get goalsRemainSaved => 'Goals remain saved';

  @override
  String get gold => 'Gold';

  @override
  String get hapticFeedback => 'Haptic feedback';

  @override
  String get health => 'Health';

  @override
  String get hideBalances => 'Hide balances';

  @override
  String get home => 'Home';

  @override
  String get identity => 'Identity';

  @override
  String get immediately => 'Immediately';

  @override
  String get income => 'Income';

  @override
  String get income2 => 'Income';

  @override
  String get income3 => 'INCOME';

  @override
  String get installedVersion => 'Installed version';

  @override
  String get interaction => 'Interaction';

  @override
  String get label15Minutes => '15 minutes';

  @override
  String get label1Minute => '1 minute';

  @override
  String get label255075AndCompletion => '25%, 50%, 75% and completion';

  @override
  String get label5Minutes => '5 minutes';

  @override
  String get language => 'Language';

  @override
  String get last7DAYS => 'LAST 7 DAYS';

  @override
  String get left => 'Left ';

  @override
  String get libyanDinarLYD => 'Libyan dinar (LYD)';

  @override
  String get light => 'Light';

  @override
  String get localRemindersAndAlerts => 'Local reminders and alerts';

  @override
  String get lydExistingRecordsUseLibyanDinar => 'LYD — existing records use Libyan dinar';

  @override
  String get makeABackupFirstRestoringReplacesTransactionsAnd => 'Make a backup first. Restoring replaces transactions and goals.';

  @override
  String get manageCategories => 'Manage categories';

  @override
  String get maskDashboardAmounts => 'Mask dashboard amounts';

  @override
  String get monthlyBudget => 'Monthly budget';

  @override
  String get newSavingsGoal => 'New savings goal';

  @override
  String get newTransaction => 'New transaction';

  @override
  String get notSet => 'Not set';

  @override
  String get nothingHereYet => 'Nothing here yet';

  @override
  String get notifications => 'Notifications';

  @override
  String get notifications2 => 'Notifications';

  @override
  String get notifyAtThisLevel => 'Notify at this level';

  @override
  String get ocean => 'Ocean';

  @override
  String get off => 'Off';

  @override
  String get offlineInsights => 'Offline insights';

  @override
  String get offlinePersonalFinanceTracking => 'Offline personal finance tracking';

  @override
  String get offlineSummaries => 'Offline summaries';

  @override
  String get openSourceLicenses => 'Open-source licenses';

  @override
  String get other => 'Other';

  @override
  String get packagesUsedByTheApp => 'Packages used by the app';

  @override
  String get personalProfile => 'Personal profile';

  @override
  String get personalization => 'Personalization';

  @override
  String get personalizeYourExperience => 'Personalize your experience';

  @override
  String get pin => 'PIN';

  @override
  String get pinBiometricsAndBalances => 'PIN, biometrics and balances';

  @override
  String get pinEnabled => 'PIN enabled';

  @override
  String get preferences => 'Preferences';

  @override
  String get preferredDisplayCurrency => 'Preferred display currency';

  @override
  String get privacyAndSecurity => 'Privacy and security';

  @override
  String get privateAppPreview => 'Private app preview';

  @override
  String get profilePicture => 'Profile picture';

  @override
  String get protection => 'Protection';

  @override
  String get purple => 'Purple';

  @override
  String get qdaash => 'qdaash';

  @override
  String get recentTransactions => 'Recent transactions';

  @override
  String get recordAnExpenseToSeeYourSpendingBreakdown => 'Record an expense to see your spending breakdown.';

  @override
  String get reduced => 'Reduced';

  @override
  String get reminderTime => 'Reminder time';

  @override
  String get reminders => 'Reminders';

  @override
  String get renameWallet => 'Rename wallet';

  @override
  String get replacesCurrentFinancialData => 'Replaces current financial data';

  @override
  String get reports => 'Reports';

  @override
  String get resetAppData => 'Reset app data';

  @override
  String get resetGaddash => 'Reset qdaash?';

  @override
  String get restore => 'Restore';

  @override
  String get restoreBackup => 'Restore backup';

  @override
  String get restoreBackup2 => 'Restore backup?';

  @override
  String get save => 'Save';

  @override
  String get saveTransaction => 'Save transaction';

  @override
  String get savedOf => 'saved of';

  @override
  String get savingsGoalMilestones => 'Savings goal milestones';

  @override
  String get scheduledOnThisDevice => 'Scheduled on this device';

  @override
  String get seeAll => 'See all';

  @override
  String get sensitiveInformation => 'Sensitive information';

  @override
  String get settings => 'Settings';

  @override
  String get shopping => 'Shopping';

  @override
  String get smallStepsAddUp => 'Small steps add up.';

  @override
  String get smallStepsAddUp2 => 'Small steps add up';

  @override
  String get spending => 'SPENDING';

  @override
  String get spendingTrend => 'Spending trend';

  @override
  String get spent => 'Spent';

  @override
  String get startASavingsGoal => 'Start a savings goal';

  @override
  String get startDay => 'Start day';

  @override
  String get symbol => 'Symbol';

  @override
  String get theme => 'Theme';

  @override
  String get themeAccentAndMotion => 'Theme, accent and motion';

  @override
  String get thisCannotBeUndoneExportABackupFirst => 'This cannot be undone. Export a backup first.';

  @override
  String get topCategory => 'Top category';

  @override
  String get totalBALANCE => 'CURRENT BALANCE';

  @override
  String get totalSPENDING => 'TOTAL SPENDING';

  @override
  String get touchResponse => 'Touch response';

  @override
  String get transactionHistory => 'Transaction history';

  @override
  String get transport => 'Transport';

  @override
  String get travel => 'Travel';

  @override
  String get tryAgain => 'Try again';

  @override
  String get unlock => 'Unlock';

  @override
  String get unlockGaddash => 'Unlock qdaash';

  @override
  String get unlockWithFingerprintOrFace => 'Unlock with fingerprint or face';

  @override
  String get updatesExistingTransactionLabels => 'Updates existing transaction labels';

  @override
  String get useBiometrics => 'Use biometrics';

  @override
  String get versionAndLicenses => 'Version and licenses';

  @override
  String get wallet => 'WALLET';

  @override
  String get walletName => 'Wallet name';

  @override
  String get wallets => 'Wallets';

  @override
  String get whatAreYouSavingFor => 'What are you saving for?';

  @override
  String get yourData => 'Your data';

  @override
  String get yourDataStaysOnThisDevice => 'Your data stays on this device';

  @override
  String get yourFinancialDataStaysOnThisDevice => 'Your financial data stays on this device.';

  @override
  String get yourFinancialInsights => 'Your financial insights';

  @override
  String get yourGoals => 'Your goals';

  @override
  String get yourIncomeAndSpendingWillShowUpHere => 'Your income and spending will show up here once you record them.';

  @override
  String get yourLocalDataCouldNotBeOpened => 'Your local data could not be opened';

  @override
  String get yourProfile => 'Your profile';

  @override
  String get yourReportIsWaiting => 'Your report is waiting';

  @override
  String get z => 'Z';

  @override
  String get dailyExpenseReminder => 'Daily expense reminder';

  @override
  String get weeklyReviewReminder => 'Weekly review reminder';

  @override
  String get monthlyReportReminder => 'Monthly report reminder';

  @override
  String get enableFinancialInsights => 'Enable financial insights';

  @override
  String get calculatedOnThisDevice => 'Calculated on this device';

  @override
  String get budgetProgressOnHome => 'Budget progress on Home';

  @override
  String get spendingAgainstYourBudget => 'Spending against your budget';

  @override
  String get spendingComparison => 'Spending comparison';

  @override
  String get compareWithThePreviousPeriod => 'Compare with the previous period';

  @override
  String get savingsSuggestion => 'Savings suggestion';

  @override
  String get showRemainingIncomeAfterSpending => 'Show remaining income after spending';

  @override
  String get financialPeriodSummary => 'Financial period summary';

  @override
  String get showRecordedIncomeAndExpenses => 'Show recorded income and expenses';
}
