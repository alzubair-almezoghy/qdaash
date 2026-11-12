// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get notificationChannelName => 'تذكيرات قدّاش';

  @override
  String get notificationChannelDescription => 'تذكيرات المصروفات والتنبيهات المالية';

  @override
  String get maskedPercent => '••٪';

  @override
  String get goodMorning => 'صباح الخير';

  @override
  String get goodAfternoon => 'مساء الخير';

  @override
  String get goodEvening => 'مساء النور';

  @override
  String greetingWithName(String greeting, String name) {
    return '$greeting، $name';
  }

  @override
  String greetingWithDate(String greeting, String date) {
    return '$greeting، $date';
  }

  @override
  String get goalTargetField => 'المبلغ المستهدف · LYD';

  @override
  String get goalContributionField => 'المبلغ · LYD';

  @override
  String get biometricPrompt => 'افتح قدّاش بالبصمة';

  @override
  String get pdfTitle => 'تقرير قدّاش المالي';

  @override
  String pdfGenerated(String date) {
    return 'تاريخ الإنشاء: $date';
  }

  @override
  String pdfIncome(String amount) {
    return 'إجمالي الدخل: $amount';
  }

  @override
  String pdfExpenses(String amount) {
    return 'إجمالي المصروفات: $amount';
  }

  @override
  String pdfBalance(String amount) {
    return 'الرصيد الحالي: $amount';
  }

  @override
  String get pdfDateColumn => 'التاريخ';

  @override
  String get pdfTypeColumn => 'النوع';

  @override
  String get pdfCategoryColumn => 'الفئة';

  @override
  String get pdfWalletColumn => 'المحفظة';

  @override
  String get pdfAmountColumn => 'المبلغ (LYD)';

  @override
  String get appName => 'قدّاش';

  @override
  String get incorrectPin => 'الرمز غير صحيح';

  @override
  String get biometricUnavailable => 'تعذر التحقق بالبصمة';

  @override
  String get enterPositiveAmount => 'أدخل مبلغًا أكبر من صفر';

  @override
  String conversionRatePrompt(String currency) {
    return 'كم تساوي 1 LYD بعملة $currency؟';
  }

  @override
  String financialMonthDay(int day) {
    return 'اليوم $day';
  }

  @override
  String budgetThresholdUsed(int percent) {
    return 'استخدام $percent٪';
  }

  @override
  String get newCategory => 'فئة جديدة';

  @override
  String get categoryName => 'اسم الفئة';

  @override
  String insightSpendingRose(int percent) {
    return 'زادت المصروفات بنسبة $percent٪ مقارنة بالفترة السابقة';
  }

  @override
  String insightSpendingFell(int percent) {
    return 'انخفضت المصروفات بنسبة $percent٪ مقارنة بالفترة السابقة';
  }

  @override
  String insightSavingsRemain(String amount) {
    return 'يتبقى $amount بعد الإنفاق';
  }

  @override
  String insightPeriodSummary(int count, String amount) {
    return '$count عمليات خلال الفترة · المصروفات $amount';
  }

  @override
  String budgetRemainingAmount(String amount) {
    return 'المبلغ المتبقي $amount';
  }

  @override
  String get showBalances => 'عرض الأرصدة';

  @override
  String get dailySpending => 'إنفاق اليوم';

  @override
  String get categoryFood => 'الطعام والمشروبات';

  @override
  String get categoryTransport => 'المواصلات';

  @override
  String get categoryShopping => 'التسوق';

  @override
  String get categoryBills => 'الفواتير';

  @override
  String get categoryHealth => 'الصحة';

  @override
  String get categoryEducation => 'التعليم';

  @override
  String get categoryEntertainment => 'الترفيه';

  @override
  String get categoryHousing => 'السكن';

  @override
  String get categorySubscriptions => 'الاشتراكات';

  @override
  String get categoryOther => 'أخرى';

  @override
  String get categorySalary => 'الراتب';

  @override
  String get categoryFreelance => 'عمل حر';

  @override
  String get categoryBusiness => 'الأعمال';

  @override
  String get categoryGift => 'الهدايا';

  @override
  String get categoryTravel => 'السفر';

  @override
  String get walletCash => 'نقدًا';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navTransactions => 'العمليات';

  @override
  String get navReports => 'التقارير';

  @override
  String get navGoals => 'الأهداف المالية';

  @override
  String get navAdd => 'إضافة عملية';

  @override
  String get collapseNavigation => 'طيّ القائمة';

  @override
  String get expandNavigation => 'توسيع القائمة';

  @override
  String get notificationTitle => 'قدّاش';

  @override
  String get dailyReminderBody => 'سجّل مصروفات اليوم';

  @override
  String get weeklyReminderBody => 'راجع مصروفاتك هذا الأسبوع';

  @override
  String get monthlyReminderBody => 'تقريرك الشهري جاهز';

  @override
  String get budgetAlertTitle => 'تنبيه الميزانية';

  @override
  String budgetAlertBody(int percent) {
    return 'استخدمت $percent٪ من ميزانيتك';
  }

  @override
  String get goalAlertTitle => 'هدف الادخار';

  @override
  String goalAlertBody(int percent) {
    return 'وصلت إلى $percent٪ من هدفك';
  }

  @override
  String get aCleanSlate => 'بداية مالية جديدة';

  @override
  String get aboutGaddash => 'حول قدّاش';

  @override
  String get aboutTheApp => 'عن التطبيق';

  @override
  String get accentColor => 'لون التمييز';

  @override
  String get acrossAllRecordedActivity => 'من إجمالي الحركات المسجلة';

  @override
  String get activity => 'العمليات';

  @override
  String get add => 'إضافة';

  @override
  String get addANoteOptional => 'ملاحظة اختيارية';

  @override
  String get addCategory => 'إضافة فئة';

  @override
  String get addEditReorderAndArchive => 'إضافة وتعديل وترتيب وأرشفة';

  @override
  String get addSavings => 'إضافة ادخار';

  @override
  String get addToGoal => 'إضافة إلى الهدف';

  @override
  String get addTransaction => 'إضافة حركة';

  @override
  String get addWallet => 'إضافة محفظة';

  @override
  String get addYourFirstTransactionToSeeYourSpending => 'أضف أول حركة لتظهر لك صورة إنفاقك هنا';

  @override
  String get addYourName => 'أضف اسمك';

  @override
  String get alertWhenSpendingCrossesAThreshold => 'تنبيه عند تجاوز نسبة من الميزانية';

  @override
  String get allFiguresUseYourLocalRecordsNoSample => 'الأرقام هنا محسوبة من بياناتك المحلية، من دون تقديرات.';

  @override
  String get allLocalFinancialRecordsAndPreferencesWillBe => 'ستُحذف جميع السجلات والتفضيلات المحلية.';

  @override
  String get amount => 'المبلغ';

  @override
  String get amountsHidden => 'المبالغ مخفية';

  @override
  String get animations => 'الحركة';

  @override
  String get appLock => 'قفل التطبيق';

  @override
  String get appearance => 'المظهر';

  @override
  String get appearance2 => 'المظهر والتخصيص';

  @override
  String get appearance3 => 'الوضع';

  @override
  String get arabic => 'English';

  @override
  String get archive => 'أرشفة';

  @override
  String get archived => 'مؤرشفة';

  @override
  String get automaticLock => 'القفل التلقائي';

  @override
  String get availableForNewTransactions => 'متاحة للحركات الجديدة';

  @override
  String get averagePerCalendarDay => 'متوسط المصروف اليومي';

  @override
  String get baseCurrency => 'العملة الأساسية';

  @override
  String get basedOnTransactionsRecordedThisMonth => 'مبني على الحركات المسجلة لهذا الشهر';

  @override
  String get bills => 'فواتير';

  @override
  String get biometrics => 'البصمة';

  @override
  String get blockScreenshotsAndRecentAppPreviews => 'منع اللقطات والمعاينة في التطبيقات الأخيرة';

  @override
  String get budgetAndCategories => 'الميزانية والفئات';

  @override
  String get budgetLimitAlerts => 'تنبيهات حد الميزانية';

  @override
  String get budgeting => 'الميزانية';

  @override
  String get byCategory => 'حسب الفئة';

  @override
  String get cancel => 'إلغاء';

  @override
  String get category => 'الفئة';

  @override
  String get chooseColor => 'اختر اللون';

  @override
  String get chooseFromGallery => 'اختر من المعرض';

  @override
  String get chooseIcon => 'اختر الأيقونة';

  @override
  String get chooseTheme => 'اختر السمة';

  @override
  String get chooseWallet => 'اختر المحفظة';

  @override
  String get clearTransactionHistory => 'مسح سجل العمليات';

  @override
  String get confirm => 'تأكيد';

  @override
  String get confirmPIN => 'تأكيد الرمز';

  @override
  String get control => 'التحكم';

  @override
  String get coral => 'مرجاني';

  @override
  String get couldNotCompleteAction => 'تعذر إكمال العملية';

  @override
  String get couldNotLoadTheReport => 'تعذر تحميل التقرير';

  @override
  String get couldNotLoadTransactions => 'تعذر تحميل الحركات';

  @override
  String get couldNotLoadYourGoals => 'تعذر تحميل أهدافك';

  @override
  String get createA48DigitPIN => 'أنشئ رمزًا من 4 إلى 8 أرقام';

  @override
  String get createAGoal => 'إنشاء هدف';

  @override
  String get createAGoalAndTrackYourProgressAt => 'أنشئ هدفاً بسيطاً وتابع تقدمك بوتيرتك.';

  @override
  String get createBackup => 'إنشاء نسخة احتياطية';

  @override
  String get currency => 'العملة';

  @override
  String get currencyDisplay => 'عرض العملة';

  @override
  String get dark => 'داكن';

  @override
  String get dataManagement => 'إدارة البيانات';

  @override
  String get decimalPlaces => 'الخانات العشرية';

  @override
  String get defaultCategory => 'الفئة الافتراضية';

  @override
  String get defaultExpenseCategory => 'فئة المصروف الافتراضية';

  @override
  String get defaultWallet => 'المحفظة الافتراضية';

  @override
  String get deleteAllTransactions => 'حذف جميع الحركات؟';

  @override
  String get deleteData => 'حذف البيانات';

  @override
  String get deleteTransactionsGoalsAndPreferences => 'حذف الحركات والأهداف والتفضيلات';

  @override
  String get displayCurrency => 'عملة العرض';

  @override
  String get displayName => 'اسم العرض';

  @override
  String get edit => 'تعديل';

  @override
  String get education => 'تعليم';

  @override
  String get emerald => 'زمردي';

  @override
  String get enterCurrentPIN => 'أدخل الرمز الحالي';

  @override
  String get everyEntryAllInOnePlace => 'كل ما سجلته، بوضوح.';

  @override
  String get expense => 'مصروف';

  @override
  String get expensesLogged => 'عدد المصروفات';

  @override
  String get exportAndBackup => 'التصدير والنسخ';

  @override
  String get exportBackupAndRestore => 'تصدير ونسخ واستعادة';

  @override
  String get exportCSV => 'تصدير CSV';

  @override
  String get exportPDFReport => 'تصدير تقرير PDF';

  @override
  String get financialAlerts => 'التنبيهات المالية';

  @override
  String get financialDataAndPreferences => 'البيانات المالية والتفضيلات';

  @override
  String get financialInsights => 'التحليلات المالية';

  @override
  String get financialMonthStarts => 'بداية الشهر المالي';

  @override
  String get financialPreferences => 'التفضيلات المالية';

  @override
  String get financialSummary => 'ملخص مالي';

  @override
  String get followSystem => 'حسب النظام';

  @override
  String get food => 'طعام';

  @override
  String get full => 'كاملة';

  @override
  String get gaddash => 'قدّاش';

  @override
  String get gift => 'هدية';

  @override
  String get goalName => 'اسم الهدف';

  @override
  String get goalsRemainSaved => 'تبقى الأهداف محفوظة';

  @override
  String get gold => 'ذهبي';

  @override
  String get hapticFeedback => 'الاهتزاز';

  @override
  String get health => 'صحة';

  @override
  String get hideBalances => 'إخفاء الأرصدة';

  @override
  String get home => 'الرئيسية';

  @override
  String get identity => 'الهوية';

  @override
  String get immediately => 'فورًا';

  @override
  String get income => 'دخل';

  @override
  String get income2 => 'الدخل';

  @override
  String get income3 => 'الدخل';

  @override
  String get installedVersion => 'الإصدار المثبت';

  @override
  String get interaction => 'التفاعل';

  @override
  String get label15Minutes => '15 دقيقة';

  @override
  String get label1Minute => 'دقيقة';

  @override
  String get label255075AndCompletion => '25% و50% و75% وعند الإنجاز';

  @override
  String get label5Minutes => '5 دقائق';

  @override
  String get language => 'اللغة';

  @override
  String get last7DAYS => 'آخر ٧ أيام';

  @override
  String get left => 'متبقٍ ';

  @override
  String get libyanDinarLYD => 'الدينار الليبي (LYD)';

  @override
  String get light => 'فاتح';

  @override
  String get localRemindersAndAlerts => 'تذكيرات وتنبيهات محلية';

  @override
  String get lydExistingRecordsUseLibyanDinar => 'LYD — السجلات الحالية بالدينار الليبي';

  @override
  String get makeABackupFirstRestoringReplacesTransactionsAnd => 'أنشئ نسخة أولًا. الاستعادة تستبدل الحركات والأهداف.';

  @override
  String get manageCategories => 'إدارة الفئات';

  @override
  String get maskDashboardAmounts => 'إخفاء مبالغ الرئيسية';

  @override
  String get monthlyBudget => 'الميزانية الشهرية';

  @override
  String get newSavingsGoal => 'هدف ادخار جديد';

  @override
  String get newTransaction => 'عملية جديدة';

  @override
  String get notSet => 'غير محددة';

  @override
  String get nothingHereYet => 'لا توجد عمليات بعد';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get notifications2 => 'الإشعارات والتذكيرات';

  @override
  String get notifyAtThisLevel => 'تنبيه عند هذه النسبة';

  @override
  String get ocean => 'أزرق';

  @override
  String get off => 'متوقف';

  @override
  String get offlineInsights => 'تحليلات محلية';

  @override
  String get offlinePersonalFinanceTracking => 'تتبع مالي شخصي بلا إنترنت';

  @override
  String get offlineSummaries => 'ملخصات محلية';

  @override
  String get openSourceLicenses => 'تراخيص المصادر المفتوحة';

  @override
  String get other => 'أخرى';

  @override
  String get packagesUsedByTheApp => 'الحزم المستخدمة في التطبيق';

  @override
  String get personalProfile => 'الملف الشخصي';

  @override
  String get personalization => 'التخصيص';

  @override
  String get personalizeYourExperience => 'خصص تجربتك المالية';

  @override
  String get pin => 'رمز PIN';

  @override
  String get pinBiometricsAndBalances => 'الرمز والبصمة والأرصدة';

  @override
  String get pinEnabled => 'الرمز مفعّل';

  @override
  String get preferences => 'التفضيلات';

  @override
  String get preferredDisplayCurrency => 'عملة العرض المفضلة';

  @override
  String get privacyAndSecurity => 'الخصوصية والأمان';

  @override
  String get privateAppPreview => 'خصوصية معاينة التطبيق';

  @override
  String get profilePicture => 'الصورة الشخصية';

  @override
  String get protection => 'الحماية';

  @override
  String get purple => 'بنفسجي';

  @override
  String get qdaash => 'قدّاش';

  @override
  String get recentTransactions => 'أحدث العمليات';

  @override
  String get recordAnExpenseToSeeYourSpendingBreakdown => 'سجل مصروفاً واحداً على الأقل لبدء التحليل.';

  @override
  String get reduced => 'مخففة';

  @override
  String get reminderTime => 'وقت التذكير';

  @override
  String get reminders => 'التذكيرات';

  @override
  String get renameWallet => 'إعادة تسمية محفظة';

  @override
  String get replacesCurrentFinancialData => 'تستبدل البيانات المالية الحالية';

  @override
  String get reports => 'التقارير';

  @override
  String get resetAppData => 'إعادة ضبط التطبيق';

  @override
  String get resetGaddash => 'إعادة ضبط قدّاش؟';

  @override
  String get restore => 'استعادة';

  @override
  String get restoreBackup => 'استعادة نسخة';

  @override
  String get restoreBackup2 => 'استعادة النسخة؟';

  @override
  String get save => 'حفظ';

  @override
  String get saveTransaction => 'حفظ الحركة';

  @override
  String get savedOf => 'من أصل';

  @override
  String get savingsGoalMilestones => 'مراحل أهداف الادخار';

  @override
  String get scheduledOnThisDevice => 'مجدول على هذا الجهاز';

  @override
  String get seeAll => 'عرض الكل';

  @override
  String get sensitiveInformation => 'المعلومات الحساسة';

  @override
  String get settings => 'الإعدادات';

  @override
  String get shopping => 'تسوق';

  @override
  String get smallStepsAddUp => 'كل خطوة تقربك.';

  @override
  String get smallStepsAddUp2 => 'الخطوات الصغيرة';

  @override
  String get spending => 'الإنفاق';

  @override
  String get spendingTrend => 'اتجاه الإنفاق';

  @override
  String get spent => 'المصروفات';

  @override
  String get startASavingsGoal => 'ابدأ هدفاً للادخار';

  @override
  String get startDay => 'يوم البداية';

  @override
  String get symbol => 'الرمز';

  @override
  String get theme => 'السمة';

  @override
  String get themeAccentAndMotion => 'السمة واللون والحركة';

  @override
  String get thisCannotBeUndoneExportABackupFirst => 'لا يمكن التراجع. صدّر نسخة أولًا.';

  @override
  String get topCategory => 'أكبر فئة';

  @override
  String get totalBALANCE => 'الرصيد الحالي';

  @override
  String get totalSPENDING => 'إجمالي المصروفات';

  @override
  String get touchResponse => 'استجابة اللمس';

  @override
  String get transactionHistory => 'سجل العمليات';

  @override
  String get transport => 'مواصلات';

  @override
  String get travel => 'سفر';

  @override
  String get tryAgain => 'إعادة المحاولة';

  @override
  String get unlock => 'فتح';

  @override
  String get unlockGaddash => 'افتح قدّاش';

  @override
  String get unlockWithFingerprintOrFace => 'فتح بالبصمة أو الوجه';

  @override
  String get updatesExistingTransactionLabels => 'تحدّث أسماء المحافظ في الحركات';

  @override
  String get useBiometrics => 'استخدام البصمة';

  @override
  String get versionAndLicenses => 'الإصدار والتراخيص';

  @override
  String get wallet => 'المحفظة';

  @override
  String get walletName => 'اسم المحفظة';

  @override
  String get wallets => 'المحافظ';

  @override
  String get whatAreYouSavingFor => 'ما الذي تخطط له؟';

  @override
  String get yourData => 'بياناتك';

  @override
  String get yourDataStaysOnThisDevice => 'تبقى بياناتك على هذا الجهاز';

  @override
  String get yourFinancialDataStaysOnThisDevice => 'تبقى بياناتك المالية على هذا الجهاز.';

  @override
  String get yourFinancialInsights => 'تحليلاتك المالية';

  @override
  String get yourGoals => 'أهدافك';

  @override
  String get yourIncomeAndSpendingWillShowUpHere => 'ستظهر مصروفاتك ودخولك هنا بعد تسجيلها.';

  @override
  String get yourLocalDataCouldNotBeOpened => 'تعذر فتح بياناتك';

  @override
  String get yourProfile => 'ملفك الشخصي';

  @override
  String get yourReportIsWaiting => 'التقرير ينتظرك';

  @override
  String get z => 'ز';

  @override
  String get dailyExpenseReminder => 'تذكير تسجيل المصروفات اليومي';

  @override
  String get weeklyReviewReminder => 'تذكير المراجعة الأسبوعية';

  @override
  String get monthlyReportReminder => 'تذكير التقرير الشهري';

  @override
  String get enableFinancialInsights => 'تفعيل التحليلات المالية';

  @override
  String get calculatedOnThisDevice => 'محسوبة على هذا الجهاز';

  @override
  String get budgetProgressOnHome => 'تقدم الميزانية في الرئيسية';

  @override
  String get spendingAgainstYourBudget => 'الإنفاق مقارنة بالميزانية';

  @override
  String get spendingComparison => 'مقارنة الإنفاق';

  @override
  String get compareWithThePreviousPeriod => 'مقارنة بالفترة السابقة';

  @override
  String get savingsSuggestion => 'اقتراح الادخار';

  @override
  String get showRemainingIncomeAfterSpending => 'عرض المتبقي من الدخل بعد الإنفاق';

  @override
  String get financialPeriodSummary => 'ملخص الفترة المالية';

  @override
  String get showRecordedIncomeAndExpenses => 'عرض الدخل والمصروفات المسجلة';
}
