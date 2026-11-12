import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @notificationChannelName.
  ///
  /// In en, this message translates to:
  /// **'qdaash reminders'**
  String get notificationChannelName;

  /// No description provided for @notificationChannelDescription.
  ///
  /// In en, this message translates to:
  /// **'Expense reminders and financial alerts'**
  String get notificationChannelDescription;

  /// No description provided for @maskedPercent.
  ///
  /// In en, this message translates to:
  /// **'••%'**
  String get maskedPercent;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get goodEvening;

  /// No description provided for @greetingWithName.
  ///
  /// In en, this message translates to:
  /// **'{greeting}, {name}'**
  String greetingWithName(String greeting, String name);

  /// No description provided for @greetingWithDate.
  ///
  /// In en, this message translates to:
  /// **'{greeting}, {date}'**
  String greetingWithDate(String greeting, String date);

  /// No description provided for @goalTargetField.
  ///
  /// In en, this message translates to:
  /// **'Target · LYD'**
  String get goalTargetField;

  /// No description provided for @goalContributionField.
  ///
  /// In en, this message translates to:
  /// **'Amount · LYD'**
  String get goalContributionField;

  /// No description provided for @biometricPrompt.
  ///
  /// In en, this message translates to:
  /// **'Unlock qdaash'**
  String get biometricPrompt;

  /// No description provided for @pdfTitle.
  ///
  /// In en, this message translates to:
  /// **'qdaash financial report'**
  String get pdfTitle;

  /// No description provided for @pdfGenerated.
  ///
  /// In en, this message translates to:
  /// **'Generated {date}'**
  String pdfGenerated(String date);

  /// No description provided for @pdfIncome.
  ///
  /// In en, this message translates to:
  /// **'Income: {amount}'**
  String pdfIncome(String amount);

  /// No description provided for @pdfExpenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses: {amount}'**
  String pdfExpenses(String amount);

  /// No description provided for @pdfBalance.
  ///
  /// In en, this message translates to:
  /// **'Balance: {amount}'**
  String pdfBalance(String amount);

  /// No description provided for @pdfDateColumn.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get pdfDateColumn;

  /// No description provided for @pdfTypeColumn.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get pdfTypeColumn;

  /// No description provided for @pdfCategoryColumn.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get pdfCategoryColumn;

  /// No description provided for @pdfWalletColumn.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get pdfWalletColumn;

  /// No description provided for @pdfAmountColumn.
  ///
  /// In en, this message translates to:
  /// **'Amount (LYD)'**
  String get pdfAmountColumn;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'qdaash'**
  String get appName;

  /// No description provided for @incorrectPin.
  ///
  /// In en, this message translates to:
  /// **'Incorrect PIN'**
  String get incorrectPin;

  /// No description provided for @biometricUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Biometric check unavailable'**
  String get biometricUnavailable;

  /// No description provided for @enterPositiveAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount greater than zero'**
  String get enterPositiveAmount;

  /// No description provided for @conversionRatePrompt.
  ///
  /// In en, this message translates to:
  /// **'How much is 1 LYD in {currency}?'**
  String conversionRatePrompt(String currency);

  /// No description provided for @financialMonthDay.
  ///
  /// In en, this message translates to:
  /// **'Day {day}'**
  String financialMonthDay(int day);

  /// No description provided for @budgetThresholdUsed.
  ///
  /// In en, this message translates to:
  /// **'{percent}% used'**
  String budgetThresholdUsed(int percent);

  /// No description provided for @newCategory.
  ///
  /// In en, this message translates to:
  /// **'New category'**
  String get newCategory;

  /// No description provided for @categoryName.
  ///
  /// In en, this message translates to:
  /// **'Category name'**
  String get categoryName;

  /// No description provided for @insightSpendingRose.
  ///
  /// In en, this message translates to:
  /// **'Spending rose {percent}% from the prior period'**
  String insightSpendingRose(int percent);

  /// No description provided for @insightSpendingFell.
  ///
  /// In en, this message translates to:
  /// **'Spending fell {percent}% from the prior period'**
  String insightSpendingFell(int percent);

  /// No description provided for @insightSavingsRemain.
  ///
  /// In en, this message translates to:
  /// **'{amount} remains after spending'**
  String insightSavingsRemain(String amount);

  /// No description provided for @insightPeriodSummary.
  ///
  /// In en, this message translates to:
  /// **'{count} transactions this period · {amount} spent'**
  String insightPeriodSummary(int count, String amount);

  /// No description provided for @budgetRemainingAmount.
  ///
  /// In en, this message translates to:
  /// **'{amount} remaining'**
  String budgetRemainingAmount(String amount);

  /// No description provided for @showBalances.
  ///
  /// In en, this message translates to:
  /// **'Show balances'**
  String get showBalances;

  /// No description provided for @dailySpending.
  ///
  /// In en, this message translates to:
  /// **'Daily spending'**
  String get dailySpending;

  /// No description provided for @categoryFood.
  ///
  /// In en, this message translates to:
  /// **'Food & Drinks'**
  String get categoryFood;

  /// No description provided for @categoryTransport.
  ///
  /// In en, this message translates to:
  /// **'Transportation'**
  String get categoryTransport;

  /// No description provided for @categoryShopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get categoryShopping;

  /// No description provided for @categoryBills.
  ///
  /// In en, this message translates to:
  /// **'Bills'**
  String get categoryBills;

  /// No description provided for @categoryHealth.
  ///
  /// In en, this message translates to:
  /// **'Healthcare'**
  String get categoryHealth;

  /// No description provided for @categoryEducation.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get categoryEducation;

  /// No description provided for @categoryEntertainment.
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get categoryEntertainment;

  /// No description provided for @categoryHousing.
  ///
  /// In en, this message translates to:
  /// **'Housing'**
  String get categoryHousing;

  /// No description provided for @categorySubscriptions.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions'**
  String get categorySubscriptions;

  /// No description provided for @categoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get categoryOther;

  /// No description provided for @categorySalary.
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get categorySalary;

  /// No description provided for @categoryFreelance.
  ///
  /// In en, this message translates to:
  /// **'Freelance'**
  String get categoryFreelance;

  /// No description provided for @categoryBusiness.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get categoryBusiness;

  /// No description provided for @categoryGift.
  ///
  /// In en, this message translates to:
  /// **'Gift'**
  String get categoryGift;

  /// No description provided for @categoryTravel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get categoryTravel;

  /// No description provided for @walletCash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get walletCash;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navTransactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get navTransactions;

  /// No description provided for @navReports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get navReports;

  /// No description provided for @navGoals.
  ///
  /// In en, this message translates to:
  /// **'Financial Goals'**
  String get navGoals;

  /// No description provided for @navAdd.
  ///
  /// In en, this message translates to:
  /// **'Add transaction'**
  String get navAdd;

  /// No description provided for @collapseNavigation.
  ///
  /// In en, this message translates to:
  /// **'Collapse navigation'**
  String get collapseNavigation;

  /// No description provided for @expandNavigation.
  ///
  /// In en, this message translates to:
  /// **'Expand navigation'**
  String get expandNavigation;

  /// No description provided for @notificationTitle.
  ///
  /// In en, this message translates to:
  /// **'qdaash'**
  String get notificationTitle;

  /// No description provided for @dailyReminderBody.
  ///
  /// In en, this message translates to:
  /// **'Record today\'s expenses'**
  String get dailyReminderBody;

  /// No description provided for @weeklyReminderBody.
  ///
  /// In en, this message translates to:
  /// **'Review your spending this week'**
  String get weeklyReminderBody;

  /// No description provided for @monthlyReminderBody.
  ///
  /// In en, this message translates to:
  /// **'Your monthly report is ready'**
  String get monthlyReminderBody;

  /// No description provided for @budgetAlertTitle.
  ///
  /// In en, this message translates to:
  /// **'Budget alert'**
  String get budgetAlertTitle;

  /// No description provided for @budgetAlertBody.
  ///
  /// In en, this message translates to:
  /// **'You used {percent}% of your budget'**
  String budgetAlertBody(int percent);

  /// No description provided for @goalAlertTitle.
  ///
  /// In en, this message translates to:
  /// **'Savings goal'**
  String get goalAlertTitle;

  /// No description provided for @goalAlertBody.
  ///
  /// In en, this message translates to:
  /// **'Your goal is {percent}% complete'**
  String goalAlertBody(int percent);

  /// No description provided for @aCleanSlate.
  ///
  /// In en, this message translates to:
  /// **'A clean slate'**
  String get aCleanSlate;

  /// No description provided for @aboutGaddash.
  ///
  /// In en, this message translates to:
  /// **'About qdaash'**
  String get aboutGaddash;

  /// No description provided for @aboutTheApp.
  ///
  /// In en, this message translates to:
  /// **'About the app'**
  String get aboutTheApp;

  /// No description provided for @accentColor.
  ///
  /// In en, this message translates to:
  /// **'Accent color'**
  String get accentColor;

  /// No description provided for @acrossAllRecordedActivity.
  ///
  /// In en, this message translates to:
  /// **'Across all recorded activity'**
  String get acrossAllRecordedActivity;

  /// No description provided for @activity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get activity;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @addANoteOptional.
  ///
  /// In en, this message translates to:
  /// **'Add a note (optional)'**
  String get addANoteOptional;

  /// No description provided for @addCategory.
  ///
  /// In en, this message translates to:
  /// **'Add category'**
  String get addCategory;

  /// No description provided for @addEditReorderAndArchive.
  ///
  /// In en, this message translates to:
  /// **'Add, edit, reorder and archive'**
  String get addEditReorderAndArchive;

  /// No description provided for @addSavings.
  ///
  /// In en, this message translates to:
  /// **'Add savings'**
  String get addSavings;

  /// No description provided for @addToGoal.
  ///
  /// In en, this message translates to:
  /// **'Add to goal'**
  String get addToGoal;

  /// No description provided for @addTransaction.
  ///
  /// In en, this message translates to:
  /// **'Add transaction'**
  String get addTransaction;

  /// No description provided for @addWallet.
  ///
  /// In en, this message translates to:
  /// **'Add wallet'**
  String get addWallet;

  /// No description provided for @addYourFirstTransactionToSeeYourSpending.
  ///
  /// In en, this message translates to:
  /// **'Add your first transaction to see your spending take shape.'**
  String get addYourFirstTransactionToSeeYourSpending;

  /// No description provided for @addYourName.
  ///
  /// In en, this message translates to:
  /// **'Add your name'**
  String get addYourName;

  /// No description provided for @alertWhenSpendingCrossesAThreshold.
  ///
  /// In en, this message translates to:
  /// **'Alert when spending crosses a threshold'**
  String get alertWhenSpendingCrossesAThreshold;

  /// No description provided for @allFiguresUseYourLocalRecordsNoSample.
  ///
  /// In en, this message translates to:
  /// **'All figures use your local records. No sample values or estimates.'**
  String get allFiguresUseYourLocalRecordsNoSample;

  /// No description provided for @allLocalFinancialRecordsAndPreferencesWillBe.
  ///
  /// In en, this message translates to:
  /// **'All local financial records and preferences will be removed.'**
  String get allLocalFinancialRecordsAndPreferencesWillBe;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'AMOUNT'**
  String get amount;

  /// No description provided for @amountsHidden.
  ///
  /// In en, this message translates to:
  /// **'Amounts hidden'**
  String get amountsHidden;

  /// No description provided for @animations.
  ///
  /// In en, this message translates to:
  /// **'Animations'**
  String get animations;

  /// No description provided for @appLock.
  ///
  /// In en, this message translates to:
  /// **'App lock'**
  String get appLock;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @appearance2.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance2;

  /// No description provided for @appearance3.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance3;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @archive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get archive;

  /// No description provided for @archived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get archived;

  /// No description provided for @automaticLock.
  ///
  /// In en, this message translates to:
  /// **'Automatic lock'**
  String get automaticLock;

  /// No description provided for @availableForNewTransactions.
  ///
  /// In en, this message translates to:
  /// **'Available for new transactions'**
  String get availableForNewTransactions;

  /// No description provided for @averagePerCalendarDay.
  ///
  /// In en, this message translates to:
  /// **'Average per calendar day'**
  String get averagePerCalendarDay;

  /// No description provided for @baseCurrency.
  ///
  /// In en, this message translates to:
  /// **'Base currency'**
  String get baseCurrency;

  /// No description provided for @basedOnTransactionsRecordedThisMonth.
  ///
  /// In en, this message translates to:
  /// **'Based on transactions recorded this month'**
  String get basedOnTransactionsRecordedThisMonth;

  /// No description provided for @bills.
  ///
  /// In en, this message translates to:
  /// **'Bills'**
  String get bills;

  /// No description provided for @biometrics.
  ///
  /// In en, this message translates to:
  /// **'Biometrics'**
  String get biometrics;

  /// No description provided for @blockScreenshotsAndRecentAppPreviews.
  ///
  /// In en, this message translates to:
  /// **'Block screenshots and recent-app previews'**
  String get blockScreenshotsAndRecentAppPreviews;

  /// No description provided for @budgetAndCategories.
  ///
  /// In en, this message translates to:
  /// **'Budget and categories'**
  String get budgetAndCategories;

  /// No description provided for @budgetLimitAlerts.
  ///
  /// In en, this message translates to:
  /// **'Budget limit alerts'**
  String get budgetLimitAlerts;

  /// No description provided for @budgeting.
  ///
  /// In en, this message translates to:
  /// **'Budgeting'**
  String get budgeting;

  /// No description provided for @byCategory.
  ///
  /// In en, this message translates to:
  /// **'By category'**
  String get byCategory;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'CATEGORY'**
  String get category;

  /// No description provided for @chooseColor.
  ///
  /// In en, this message translates to:
  /// **'Choose color'**
  String get chooseColor;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get chooseFromGallery;

  /// No description provided for @chooseIcon.
  ///
  /// In en, this message translates to:
  /// **'Choose icon'**
  String get chooseIcon;

  /// No description provided for @chooseTheme.
  ///
  /// In en, this message translates to:
  /// **'Choose theme'**
  String get chooseTheme;

  /// No description provided for @chooseWallet.
  ///
  /// In en, this message translates to:
  /// **'Choose wallet'**
  String get chooseWallet;

  /// No description provided for @clearTransactionHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear transaction history'**
  String get clearTransactionHistory;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @confirmPIN.
  ///
  /// In en, this message translates to:
  /// **'Confirm PIN'**
  String get confirmPIN;

  /// No description provided for @control.
  ///
  /// In en, this message translates to:
  /// **'Control'**
  String get control;

  /// No description provided for @coral.
  ///
  /// In en, this message translates to:
  /// **'Coral'**
  String get coral;

  /// No description provided for @couldNotCompleteAction.
  ///
  /// In en, this message translates to:
  /// **'Could not complete action'**
  String get couldNotCompleteAction;

  /// No description provided for @couldNotLoadTheReport.
  ///
  /// In en, this message translates to:
  /// **'Could not load the report'**
  String get couldNotLoadTheReport;

  /// No description provided for @couldNotLoadTransactions.
  ///
  /// In en, this message translates to:
  /// **'Could not load transactions'**
  String get couldNotLoadTransactions;

  /// No description provided for @couldNotLoadYourGoals.
  ///
  /// In en, this message translates to:
  /// **'Could not load your goals'**
  String get couldNotLoadYourGoals;

  /// No description provided for @createA48DigitPIN.
  ///
  /// In en, this message translates to:
  /// **'Create a 4–8 digit PIN'**
  String get createA48DigitPIN;

  /// No description provided for @createAGoal.
  ///
  /// In en, this message translates to:
  /// **'Create a goal'**
  String get createAGoal;

  /// No description provided for @createAGoalAndTrackYourProgressAt.
  ///
  /// In en, this message translates to:
  /// **'Create a goal and track your progress at your own pace.'**
  String get createAGoalAndTrackYourProgressAt;

  /// No description provided for @createBackup.
  ///
  /// In en, this message translates to:
  /// **'Create backup'**
  String get createBackup;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @currencyDisplay.
  ///
  /// In en, this message translates to:
  /// **'Currency display'**
  String get currencyDisplay;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @dataManagement.
  ///
  /// In en, this message translates to:
  /// **'Data management'**
  String get dataManagement;

  /// No description provided for @decimalPlaces.
  ///
  /// In en, this message translates to:
  /// **'Decimal places'**
  String get decimalPlaces;

  /// No description provided for @defaultCategory.
  ///
  /// In en, this message translates to:
  /// **'Default category'**
  String get defaultCategory;

  /// No description provided for @defaultExpenseCategory.
  ///
  /// In en, this message translates to:
  /// **'Default expense category'**
  String get defaultExpenseCategory;

  /// No description provided for @defaultWallet.
  ///
  /// In en, this message translates to:
  /// **'Default wallet'**
  String get defaultWallet;

  /// No description provided for @deleteAllTransactions.
  ///
  /// In en, this message translates to:
  /// **'Delete all transactions?'**
  String get deleteAllTransactions;

  /// No description provided for @deleteData.
  ///
  /// In en, this message translates to:
  /// **'Delete data'**
  String get deleteData;

  /// No description provided for @deleteTransactionsGoalsAndPreferences.
  ///
  /// In en, this message translates to:
  /// **'Delete transactions, goals and preferences'**
  String get deleteTransactionsGoalsAndPreferences;

  /// No description provided for @displayCurrency.
  ///
  /// In en, this message translates to:
  /// **'Display currency'**
  String get displayCurrency;

  /// No description provided for @displayName.
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get displayName;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @education.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get education;

  /// No description provided for @emerald.
  ///
  /// In en, this message translates to:
  /// **'Emerald'**
  String get emerald;

  /// No description provided for @enterCurrentPIN.
  ///
  /// In en, this message translates to:
  /// **'Enter current PIN'**
  String get enterCurrentPIN;

  /// No description provided for @everyEntryAllInOnePlace.
  ///
  /// In en, this message translates to:
  /// **'Every entry, all in one place.'**
  String get everyEntryAllInOnePlace;

  /// No description provided for @expense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expense;

  /// No description provided for @expensesLogged.
  ///
  /// In en, this message translates to:
  /// **'Expenses logged'**
  String get expensesLogged;

  /// No description provided for @exportAndBackup.
  ///
  /// In en, this message translates to:
  /// **'Export and backup'**
  String get exportAndBackup;

  /// No description provided for @exportBackupAndRestore.
  ///
  /// In en, this message translates to:
  /// **'Export, backup and restore'**
  String get exportBackupAndRestore;

  /// No description provided for @exportCSV.
  ///
  /// In en, this message translates to:
  /// **'Export CSV'**
  String get exportCSV;

  /// No description provided for @exportPDFReport.
  ///
  /// In en, this message translates to:
  /// **'Export PDF report'**
  String get exportPDFReport;

  /// No description provided for @financialAlerts.
  ///
  /// In en, this message translates to:
  /// **'Financial alerts'**
  String get financialAlerts;

  /// No description provided for @financialDataAndPreferences.
  ///
  /// In en, this message translates to:
  /// **'Financial data and preferences'**
  String get financialDataAndPreferences;

  /// No description provided for @financialInsights.
  ///
  /// In en, this message translates to:
  /// **'Financial insights'**
  String get financialInsights;

  /// No description provided for @financialMonthStarts.
  ///
  /// In en, this message translates to:
  /// **'Financial month starts'**
  String get financialMonthStarts;

  /// No description provided for @financialPreferences.
  ///
  /// In en, this message translates to:
  /// **'Financial preferences'**
  String get financialPreferences;

  /// No description provided for @financialSummary.
  ///
  /// In en, this message translates to:
  /// **'Financial summary'**
  String get financialSummary;

  /// No description provided for @followSystem.
  ///
  /// In en, this message translates to:
  /// **'Follow system'**
  String get followSystem;

  /// No description provided for @food.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get food;

  /// No description provided for @full.
  ///
  /// In en, this message translates to:
  /// **'Full'**
  String get full;

  /// No description provided for @gaddash.
  ///
  /// In en, this message translates to:
  /// **'qdaash'**
  String get gaddash;

  /// No description provided for @gift.
  ///
  /// In en, this message translates to:
  /// **'Gift'**
  String get gift;

  /// No description provided for @goalName.
  ///
  /// In en, this message translates to:
  /// **'Goal name'**
  String get goalName;

  /// No description provided for @goalsRemainSaved.
  ///
  /// In en, this message translates to:
  /// **'Goals remain saved'**
  String get goalsRemainSaved;

  /// No description provided for @gold.
  ///
  /// In en, this message translates to:
  /// **'Gold'**
  String get gold;

  /// No description provided for @hapticFeedback.
  ///
  /// In en, this message translates to:
  /// **'Haptic feedback'**
  String get hapticFeedback;

  /// No description provided for @health.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get health;

  /// No description provided for @hideBalances.
  ///
  /// In en, this message translates to:
  /// **'Hide balances'**
  String get hideBalances;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @identity.
  ///
  /// In en, this message translates to:
  /// **'Identity'**
  String get identity;

  /// No description provided for @immediately.
  ///
  /// In en, this message translates to:
  /// **'Immediately'**
  String get immediately;

  /// No description provided for @income.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get income;

  /// No description provided for @income2.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get income2;

  /// No description provided for @income3.
  ///
  /// In en, this message translates to:
  /// **'INCOME'**
  String get income3;

  /// No description provided for @installedVersion.
  ///
  /// In en, this message translates to:
  /// **'Installed version'**
  String get installedVersion;

  /// No description provided for @interaction.
  ///
  /// In en, this message translates to:
  /// **'Interaction'**
  String get interaction;

  /// No description provided for @label15Minutes.
  ///
  /// In en, this message translates to:
  /// **'15 minutes'**
  String get label15Minutes;

  /// No description provided for @label1Minute.
  ///
  /// In en, this message translates to:
  /// **'1 minute'**
  String get label1Minute;

  /// No description provided for @label255075AndCompletion.
  ///
  /// In en, this message translates to:
  /// **'25%, 50%, 75% and completion'**
  String get label255075AndCompletion;

  /// No description provided for @label5Minutes.
  ///
  /// In en, this message translates to:
  /// **'5 minutes'**
  String get label5Minutes;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @last7DAYS.
  ///
  /// In en, this message translates to:
  /// **'LAST 7 DAYS'**
  String get last7DAYS;

  /// No description provided for @left.
  ///
  /// In en, this message translates to:
  /// **'Left '**
  String get left;

  /// No description provided for @libyanDinarLYD.
  ///
  /// In en, this message translates to:
  /// **'Libyan dinar (LYD)'**
  String get libyanDinarLYD;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @localRemindersAndAlerts.
  ///
  /// In en, this message translates to:
  /// **'Local reminders and alerts'**
  String get localRemindersAndAlerts;

  /// No description provided for @lydExistingRecordsUseLibyanDinar.
  ///
  /// In en, this message translates to:
  /// **'LYD — existing records use Libyan dinar'**
  String get lydExistingRecordsUseLibyanDinar;

  /// No description provided for @makeABackupFirstRestoringReplacesTransactionsAnd.
  ///
  /// In en, this message translates to:
  /// **'Make a backup first. Restoring replaces transactions and goals.'**
  String get makeABackupFirstRestoringReplacesTransactionsAnd;

  /// No description provided for @manageCategories.
  ///
  /// In en, this message translates to:
  /// **'Manage categories'**
  String get manageCategories;

  /// No description provided for @maskDashboardAmounts.
  ///
  /// In en, this message translates to:
  /// **'Mask dashboard amounts'**
  String get maskDashboardAmounts;

  /// No description provided for @monthlyBudget.
  ///
  /// In en, this message translates to:
  /// **'Monthly budget'**
  String get monthlyBudget;

  /// No description provided for @newSavingsGoal.
  ///
  /// In en, this message translates to:
  /// **'New savings goal'**
  String get newSavingsGoal;

  /// No description provided for @newTransaction.
  ///
  /// In en, this message translates to:
  /// **'New transaction'**
  String get newTransaction;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// No description provided for @nothingHereYet.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get nothingHereYet;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @notifications2.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications2;

  /// No description provided for @notifyAtThisLevel.
  ///
  /// In en, this message translates to:
  /// **'Notify at this level'**
  String get notifyAtThisLevel;

  /// No description provided for @ocean.
  ///
  /// In en, this message translates to:
  /// **'Ocean'**
  String get ocean;

  /// No description provided for @off.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get off;

  /// No description provided for @offlineInsights.
  ///
  /// In en, this message translates to:
  /// **'Offline insights'**
  String get offlineInsights;

  /// No description provided for @offlinePersonalFinanceTracking.
  ///
  /// In en, this message translates to:
  /// **'Offline personal finance tracking'**
  String get offlinePersonalFinanceTracking;

  /// No description provided for @offlineSummaries.
  ///
  /// In en, this message translates to:
  /// **'Offline summaries'**
  String get offlineSummaries;

  /// No description provided for @openSourceLicenses.
  ///
  /// In en, this message translates to:
  /// **'Open-source licenses'**
  String get openSourceLicenses;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @packagesUsedByTheApp.
  ///
  /// In en, this message translates to:
  /// **'Packages used by the app'**
  String get packagesUsedByTheApp;

  /// No description provided for @personalProfile.
  ///
  /// In en, this message translates to:
  /// **'Personal profile'**
  String get personalProfile;

  /// No description provided for @personalization.
  ///
  /// In en, this message translates to:
  /// **'Personalization'**
  String get personalization;

  /// No description provided for @personalizeYourExperience.
  ///
  /// In en, this message translates to:
  /// **'Personalize your experience'**
  String get personalizeYourExperience;

  /// No description provided for @pin.
  ///
  /// In en, this message translates to:
  /// **'PIN'**
  String get pin;

  /// No description provided for @pinBiometricsAndBalances.
  ///
  /// In en, this message translates to:
  /// **'PIN, biometrics and balances'**
  String get pinBiometricsAndBalances;

  /// No description provided for @pinEnabled.
  ///
  /// In en, this message translates to:
  /// **'PIN enabled'**
  String get pinEnabled;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @preferredDisplayCurrency.
  ///
  /// In en, this message translates to:
  /// **'Preferred display currency'**
  String get preferredDisplayCurrency;

  /// No description provided for @privacyAndSecurity.
  ///
  /// In en, this message translates to:
  /// **'Privacy and security'**
  String get privacyAndSecurity;

  /// No description provided for @privateAppPreview.
  ///
  /// In en, this message translates to:
  /// **'Private app preview'**
  String get privateAppPreview;

  /// No description provided for @profilePicture.
  ///
  /// In en, this message translates to:
  /// **'Profile picture'**
  String get profilePicture;

  /// No description provided for @protection.
  ///
  /// In en, this message translates to:
  /// **'Protection'**
  String get protection;

  /// No description provided for @purple.
  ///
  /// In en, this message translates to:
  /// **'Purple'**
  String get purple;

  /// No description provided for @qdaash.
  ///
  /// In en, this message translates to:
  /// **'qdaash'**
  String get qdaash;

  /// No description provided for @recentTransactions.
  ///
  /// In en, this message translates to:
  /// **'Recent transactions'**
  String get recentTransactions;

  /// No description provided for @recordAnExpenseToSeeYourSpendingBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Record an expense to see your spending breakdown.'**
  String get recordAnExpenseToSeeYourSpendingBreakdown;

  /// No description provided for @reduced.
  ///
  /// In en, this message translates to:
  /// **'Reduced'**
  String get reduced;

  /// No description provided for @reminderTime.
  ///
  /// In en, this message translates to:
  /// **'Reminder time'**
  String get reminderTime;

  /// No description provided for @reminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get reminders;

  /// No description provided for @renameWallet.
  ///
  /// In en, this message translates to:
  /// **'Rename wallet'**
  String get renameWallet;

  /// No description provided for @replacesCurrentFinancialData.
  ///
  /// In en, this message translates to:
  /// **'Replaces current financial data'**
  String get replacesCurrentFinancialData;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @resetAppData.
  ///
  /// In en, this message translates to:
  /// **'Reset app data'**
  String get resetAppData;

  /// No description provided for @resetGaddash.
  ///
  /// In en, this message translates to:
  /// **'Reset qdaash?'**
  String get resetGaddash;

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// No description provided for @restoreBackup.
  ///
  /// In en, this message translates to:
  /// **'Restore backup'**
  String get restoreBackup;

  /// No description provided for @restoreBackup2.
  ///
  /// In en, this message translates to:
  /// **'Restore backup?'**
  String get restoreBackup2;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @saveTransaction.
  ///
  /// In en, this message translates to:
  /// **'Save transaction'**
  String get saveTransaction;

  /// No description provided for @savedOf.
  ///
  /// In en, this message translates to:
  /// **'saved of'**
  String get savedOf;

  /// No description provided for @savingsGoalMilestones.
  ///
  /// In en, this message translates to:
  /// **'Savings goal milestones'**
  String get savingsGoalMilestones;

  /// No description provided for @scheduledOnThisDevice.
  ///
  /// In en, this message translates to:
  /// **'Scheduled on this device'**
  String get scheduledOnThisDevice;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @sensitiveInformation.
  ///
  /// In en, this message translates to:
  /// **'Sensitive information'**
  String get sensitiveInformation;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @shopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get shopping;

  /// No description provided for @smallStepsAddUp.
  ///
  /// In en, this message translates to:
  /// **'Small steps add up.'**
  String get smallStepsAddUp;

  /// No description provided for @smallStepsAddUp2.
  ///
  /// In en, this message translates to:
  /// **'Small steps add up'**
  String get smallStepsAddUp2;

  /// No description provided for @spending.
  ///
  /// In en, this message translates to:
  /// **'SPENDING'**
  String get spending;

  /// No description provided for @spendingTrend.
  ///
  /// In en, this message translates to:
  /// **'Spending trend'**
  String get spendingTrend;

  /// No description provided for @spent.
  ///
  /// In en, this message translates to:
  /// **'Spent'**
  String get spent;

  /// No description provided for @startASavingsGoal.
  ///
  /// In en, this message translates to:
  /// **'Start a savings goal'**
  String get startASavingsGoal;

  /// No description provided for @startDay.
  ///
  /// In en, this message translates to:
  /// **'Start day'**
  String get startDay;

  /// No description provided for @symbol.
  ///
  /// In en, this message translates to:
  /// **'Symbol'**
  String get symbol;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themeAccentAndMotion.
  ///
  /// In en, this message translates to:
  /// **'Theme, accent and motion'**
  String get themeAccentAndMotion;

  /// No description provided for @thisCannotBeUndoneExportABackupFirst.
  ///
  /// In en, this message translates to:
  /// **'This cannot be undone. Export a backup first.'**
  String get thisCannotBeUndoneExportABackupFirst;

  /// No description provided for @topCategory.
  ///
  /// In en, this message translates to:
  /// **'Top category'**
  String get topCategory;

  /// No description provided for @totalBALANCE.
  ///
  /// In en, this message translates to:
  /// **'CURRENT BALANCE'**
  String get totalBALANCE;

  /// No description provided for @totalSPENDING.
  ///
  /// In en, this message translates to:
  /// **'TOTAL SPENDING'**
  String get totalSPENDING;

  /// No description provided for @touchResponse.
  ///
  /// In en, this message translates to:
  /// **'Touch response'**
  String get touchResponse;

  /// No description provided for @transactionHistory.
  ///
  /// In en, this message translates to:
  /// **'Transaction history'**
  String get transactionHistory;

  /// No description provided for @transport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get transport;

  /// No description provided for @travel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get travel;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @unlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get unlock;

  /// No description provided for @unlockGaddash.
  ///
  /// In en, this message translates to:
  /// **'Unlock qdaash'**
  String get unlockGaddash;

  /// No description provided for @unlockWithFingerprintOrFace.
  ///
  /// In en, this message translates to:
  /// **'Unlock with fingerprint or face'**
  String get unlockWithFingerprintOrFace;

  /// No description provided for @updatesExistingTransactionLabels.
  ///
  /// In en, this message translates to:
  /// **'Updates existing transaction labels'**
  String get updatesExistingTransactionLabels;

  /// No description provided for @useBiometrics.
  ///
  /// In en, this message translates to:
  /// **'Use biometrics'**
  String get useBiometrics;

  /// No description provided for @versionAndLicenses.
  ///
  /// In en, this message translates to:
  /// **'Version and licenses'**
  String get versionAndLicenses;

  /// No description provided for @wallet.
  ///
  /// In en, this message translates to:
  /// **'WALLET'**
  String get wallet;

  /// No description provided for @walletName.
  ///
  /// In en, this message translates to:
  /// **'Wallet name'**
  String get walletName;

  /// No description provided for @wallets.
  ///
  /// In en, this message translates to:
  /// **'Wallets'**
  String get wallets;

  /// No description provided for @whatAreYouSavingFor.
  ///
  /// In en, this message translates to:
  /// **'What are you saving for?'**
  String get whatAreYouSavingFor;

  /// No description provided for @yourData.
  ///
  /// In en, this message translates to:
  /// **'Your data'**
  String get yourData;

  /// No description provided for @yourDataStaysOnThisDevice.
  ///
  /// In en, this message translates to:
  /// **'Your data stays on this device'**
  String get yourDataStaysOnThisDevice;

  /// No description provided for @yourFinancialDataStaysOnThisDevice.
  ///
  /// In en, this message translates to:
  /// **'Your financial data stays on this device.'**
  String get yourFinancialDataStaysOnThisDevice;

  /// No description provided for @yourFinancialInsights.
  ///
  /// In en, this message translates to:
  /// **'Your financial insights'**
  String get yourFinancialInsights;

  /// No description provided for @yourGoals.
  ///
  /// In en, this message translates to:
  /// **'Your goals'**
  String get yourGoals;

  /// No description provided for @yourIncomeAndSpendingWillShowUpHere.
  ///
  /// In en, this message translates to:
  /// **'Your income and spending will show up here once you record them.'**
  String get yourIncomeAndSpendingWillShowUpHere;

  /// No description provided for @yourLocalDataCouldNotBeOpened.
  ///
  /// In en, this message translates to:
  /// **'Your local data could not be opened'**
  String get yourLocalDataCouldNotBeOpened;

  /// No description provided for @yourProfile.
  ///
  /// In en, this message translates to:
  /// **'Your profile'**
  String get yourProfile;

  /// No description provided for @yourReportIsWaiting.
  ///
  /// In en, this message translates to:
  /// **'Your report is waiting'**
  String get yourReportIsWaiting;

  /// No description provided for @z.
  ///
  /// In en, this message translates to:
  /// **'Z'**
  String get z;

  /// No description provided for @dailyExpenseReminder.
  ///
  /// In en, this message translates to:
  /// **'Daily expense reminder'**
  String get dailyExpenseReminder;

  /// No description provided for @weeklyReviewReminder.
  ///
  /// In en, this message translates to:
  /// **'Weekly review reminder'**
  String get weeklyReviewReminder;

  /// No description provided for @monthlyReportReminder.
  ///
  /// In en, this message translates to:
  /// **'Monthly report reminder'**
  String get monthlyReportReminder;

  /// No description provided for @enableFinancialInsights.
  ///
  /// In en, this message translates to:
  /// **'Enable financial insights'**
  String get enableFinancialInsights;

  /// No description provided for @calculatedOnThisDevice.
  ///
  /// In en, this message translates to:
  /// **'Calculated on this device'**
  String get calculatedOnThisDevice;

  /// No description provided for @budgetProgressOnHome.
  ///
  /// In en, this message translates to:
  /// **'Budget progress on Home'**
  String get budgetProgressOnHome;

  /// No description provided for @spendingAgainstYourBudget.
  ///
  /// In en, this message translates to:
  /// **'Spending against your budget'**
  String get spendingAgainstYourBudget;

  /// No description provided for @spendingComparison.
  ///
  /// In en, this message translates to:
  /// **'Spending comparison'**
  String get spendingComparison;

  /// No description provided for @compareWithThePreviousPeriod.
  ///
  /// In en, this message translates to:
  /// **'Compare with the previous period'**
  String get compareWithThePreviousPeriod;

  /// No description provided for @savingsSuggestion.
  ///
  /// In en, this message translates to:
  /// **'Savings suggestion'**
  String get savingsSuggestion;

  /// No description provided for @showRemainingIncomeAfterSpending.
  ///
  /// In en, this message translates to:
  /// **'Show remaining income after spending'**
  String get showRemainingIncomeAfterSpending;

  /// No description provided for @financialPeriodSummary.
  ///
  /// In en, this message translates to:
  /// **'Financial period summary'**
  String get financialPeriodSummary;

  /// No description provided for @showRecordedIncomeAndExpenses.
  ///
  /// In en, this message translates to:
  /// **'Show recorded income and expenses'**
  String get showRecordedIncomeAndExpenses;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
