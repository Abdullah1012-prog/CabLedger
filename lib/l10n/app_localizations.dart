import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

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
/// import 'l10n/app_localizations.dart';
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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'CabLedger'**
  String get appName;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @addDailyRecord.
  ///
  /// In en, this message translates to:
  /// **'Add Daily Record'**
  String get addDailyRecord;

  /// No description provided for @editDailyRecord.
  ///
  /// In en, this message translates to:
  /// **'Edit Daily Record'**
  String get editDailyRecord;

  /// No description provided for @viewHistory.
  ///
  /// In en, this message translates to:
  /// **'View History'**
  String get viewHistory;

  /// No description provided for @monthlyReports.
  ///
  /// In en, this message translates to:
  /// **'Monthly Reports'**
  String get monthlyReports;

  /// No description provided for @vehicleSettings.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Settings'**
  String get vehicleSettings;

  /// No description provided for @sale.
  ///
  /// In en, this message translates to:
  /// **'Sale'**
  String get sale;

  /// No description provided for @fuel.
  ///
  /// In en, this message translates to:
  /// **'Fuel'**
  String get fuel;

  /// No description provided for @expense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expense;

  /// No description provided for @expenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get expenses;

  /// No description provided for @net.
  ///
  /// In en, this message translates to:
  /// **'Net'**
  String get net;

  /// No description provided for @profit.
  ///
  /// In en, this message translates to:
  /// **'Profit'**
  String get profit;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @optionalNote.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get optionalNote;

  /// No description provided for @saveRecord.
  ///
  /// In en, this message translates to:
  /// **'Save Record'**
  String get saveRecord;

  /// No description provided for @updateRecord.
  ///
  /// In en, this message translates to:
  /// **'Update Record'**
  String get updateRecord;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @todaysSales.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Sales'**
  String get todaysSales;

  /// No description provided for @todaysFuel.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Fuel'**
  String get todaysFuel;

  /// No description provided for @todaysExpenses.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Expenses'**
  String get todaysExpenses;

  /// No description provided for @todaysNet.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Net'**
  String get todaysNet;

  /// No description provided for @monthSales.
  ///
  /// In en, this message translates to:
  /// **'Month Sales'**
  String get monthSales;

  /// No description provided for @monthFuel.
  ///
  /// In en, this message translates to:
  /// **'Month Fuel'**
  String get monthFuel;

  /// No description provided for @monthExpenses.
  ///
  /// In en, this message translates to:
  /// **'Month Expenses'**
  String get monthExpenses;

  /// No description provided for @monthProfit.
  ///
  /// In en, this message translates to:
  /// **'Month Profit'**
  String get monthProfit;

  /// No description provided for @investmentRecovery.
  ///
  /// In en, this message translates to:
  /// **'Investment Recovery'**
  String get investmentRecovery;

  /// No description provided for @vehicleInvestment.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Investment'**
  String get vehicleInvestment;

  /// No description provided for @originalPurchasePrice.
  ///
  /// In en, this message translates to:
  /// **'Original Purchase Price'**
  String get originalPurchasePrice;

  /// No description provided for @totalOperatingProfit.
  ///
  /// In en, this message translates to:
  /// **'Total Operating Profit'**
  String get totalOperatingProfit;

  /// No description provided for @remainingInvestment.
  ///
  /// In en, this message translates to:
  /// **'Remaining Investment'**
  String get remainingInvestment;

  /// No description provided for @surplusBeyondInvestment.
  ///
  /// In en, this message translates to:
  /// **'Profit Beyond Investment'**
  String get surplusBeyondInvestment;

  /// No description provided for @recoveryPercentage.
  ///
  /// In en, this message translates to:
  /// **'Recovery'**
  String get recoveryPercentage;

  /// No description provided for @vehicleName.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Name / Model'**
  String get vehicleName;

  /// No description provided for @registrationNumber.
  ///
  /// In en, this message translates to:
  /// **'Registration Number (optional)'**
  String get registrationNumber;

  /// No description provided for @purchaseDate.
  ///
  /// In en, this message translates to:
  /// **'Purchase Date'**
  String get purchaseDate;

  /// No description provided for @purchasePrice.
  ///
  /// In en, this message translates to:
  /// **'Purchase Price (PKR)'**
  String get purchasePrice;

  /// No description provided for @saveVehicle.
  ///
  /// In en, this message translates to:
  /// **'Save Vehicle'**
  String get saveVehicle;

  /// No description provided for @workingDays.
  ///
  /// In en, this message translates to:
  /// **'Working Days'**
  String get workingDays;

  /// No description provided for @averageDailySales.
  ///
  /// In en, this message translates to:
  /// **'Average Daily Sales'**
  String get averageDailySales;

  /// No description provided for @averageDailyProfit.
  ///
  /// In en, this message translates to:
  /// **'Average Daily Profit'**
  String get averageDailyProfit;

  /// No description provided for @bestEarningDay.
  ///
  /// In en, this message translates to:
  /// **'Best Earning Day'**
  String get bestEarningDay;

  /// No description provided for @lowestEarningDay.
  ///
  /// In en, this message translates to:
  /// **'Lowest Earning Day'**
  String get lowestEarningDay;

  /// No description provided for @exportPdf.
  ///
  /// In en, this message translates to:
  /// **'Export PDF'**
  String get exportPdf;

  /// No description provided for @exportCsv.
  ///
  /// In en, this message translates to:
  /// **'Export CSV'**
  String get exportCsv;

  /// No description provided for @exportAllData.
  ///
  /// In en, this message translates to:
  /// **'Export All Data'**
  String get exportAllData;

  /// No description provided for @backupDatabase.
  ///
  /// In en, this message translates to:
  /// **'Backup Database'**
  String get backupDatabase;

  /// No description provided for @restoreDatabase.
  ///
  /// In en, this message translates to:
  /// **'Restore Database'**
  String get restoreDatabase;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @resetData.
  ///
  /// In en, this message translates to:
  /// **'Reset Application Data'**
  String get resetData;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @currencyDisplay.
  ///
  /// In en, this message translates to:
  /// **'Currency Display'**
  String get currencyDisplay;

  /// No description provided for @currencyRs.
  ///
  /// In en, this message translates to:
  /// **'Rs.'**
  String get currencyRs;

  /// No description provided for @currencyPkr.
  ///
  /// In en, this message translates to:
  /// **'PKR'**
  String get currencyPkr;

  /// No description provided for @deleteRecord.
  ///
  /// In en, this message translates to:
  /// **'Delete Record'**
  String get deleteRecord;

  /// No description provided for @deleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this daily record? This cannot be undone.'**
  String get deleteConfirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @searchByDate.
  ///
  /// In en, this message translates to:
  /// **'Search by date'**
  String get searchByDate;

  /// No description provided for @filterMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get filterMonth;

  /// No description provided for @filterYear.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get filterYear;

  /// No description provided for @allMonths.
  ///
  /// In en, this message translates to:
  /// **'All months'**
  String get allMonths;

  /// No description provided for @noRecords.
  ///
  /// In en, this message translates to:
  /// **'No records yet'**
  String get noRecords;

  /// No description provided for @noRecordsHint.
  ///
  /// In en, this message translates to:
  /// **'Tap Add Daily Record to save today\'s sale, fuel, and expense.'**
  String get noRecordsHint;

  /// No description provided for @recordSaved.
  ///
  /// In en, this message translates to:
  /// **'Record saved'**
  String get recordSaved;

  /// No description provided for @recordUpdated.
  ///
  /// In en, this message translates to:
  /// **'Record updated'**
  String get recordUpdated;

  /// No description provided for @recordDeleted.
  ///
  /// In en, this message translates to:
  /// **'Record deleted'**
  String get recordDeleted;

  /// No description provided for @vehicleSaved.
  ///
  /// In en, this message translates to:
  /// **'Vehicle saved'**
  String get vehicleSaved;

  /// No description provided for @dateAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'A record for this date already exists. Saving will update it.'**
  String get dateAlreadyExists;

  /// No description provided for @amountCannotBeNegative.
  ///
  /// In en, this message translates to:
  /// **'Amount cannot be negative'**
  String get amountCannotBeNegative;

  /// No description provided for @invalidAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount'**
  String get invalidAmount;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get requiredField;

  /// No description provided for @noVehicleYet.
  ///
  /// In en, this message translates to:
  /// **'Add your vehicle details to track investment recovery.'**
  String get noVehicleYet;

  /// No description provided for @purchasePriceMissing.
  ///
  /// In en, this message translates to:
  /// **'Set a purchase price to see recovery progress.'**
  String get purchasePriceMissing;

  /// No description provided for @purchasePriceZero.
  ///
  /// In en, this message translates to:
  /// **'Purchase price is zero, so recovery percent is not shown.'**
  String get purchasePriceZero;

  /// No description provided for @salesVsExpenses.
  ///
  /// In en, this message translates to:
  /// **'Daily Sales vs Expenses'**
  String get salesVsExpenses;

  /// No description provided for @dailyNetEarnings.
  ///
  /// In en, this message translates to:
  /// **'Daily Net Earnings'**
  String get dailyNetEarnings;

  /// No description provided for @monthComparison.
  ///
  /// In en, this message translates to:
  /// **'Sales, Fuel & Expenses'**
  String get monthComparison;

  /// No description provided for @previousMonth.
  ///
  /// In en, this message translates to:
  /// **'Previous month'**
  String get previousMonth;

  /// No description provided for @nextMonth.
  ///
  /// In en, this message translates to:
  /// **'Next month'**
  String get nextMonth;

  /// No description provided for @backupCreated.
  ///
  /// In en, this message translates to:
  /// **'Backup created'**
  String get backupCreated;

  /// No description provided for @restoreSuccess.
  ///
  /// In en, this message translates to:
  /// **'Database restored'**
  String get restoreSuccess;

  /// No description provided for @exportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Export ready'**
  String get exportSuccess;

  /// No description provided for @resetTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset all data?'**
  String get resetTitle;

  /// No description provided for @resetBody.
  ///
  /// In en, this message translates to:
  /// **'This permanently deletes every daily record and vehicle setting. Type RESET to confirm.'**
  String get resetBody;

  /// No description provided for @resetConfirmWord.
  ///
  /// In en, this message translates to:
  /// **'RESET'**
  String get resetConfirmWord;

  /// No description provided for @resetSuccess.
  ///
  /// In en, this message translates to:
  /// **'All data cleared'**
  String get resetSuccess;

  /// No description provided for @aboutBody.
  ///
  /// In en, this message translates to:
  /// **'CabLedger helps cab drivers track daily sales, fuel, and vehicle expenses offline, and see how much of the vehicle purchase price has been recovered through operating profit.'**
  String get aboutBody;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0'**
  String get version;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneric;

  /// No description provided for @editVehicle.
  ///
  /// In en, this message translates to:
  /// **'Edit Vehicle'**
  String get editVehicle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
