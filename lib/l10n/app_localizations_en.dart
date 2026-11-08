// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'CabLedger';

  @override
  String get home => 'Home';

  @override
  String get history => 'History';

  @override
  String get reports => 'Reports';

  @override
  String get settings => 'Settings';

  @override
  String get addDailyRecord => 'Add Daily Record';

  @override
  String get editDailyRecord => 'Edit Daily Record';

  @override
  String get viewHistory => 'View History';

  @override
  String get monthlyReports => 'Monthly Reports';

  @override
  String get vehicleSettings => 'Vehicle Settings';

  @override
  String get sale => 'Sale';

  @override
  String get fuel => 'Fuel';

  @override
  String get expense => 'Expense';

  @override
  String get expenses => 'Expenses';

  @override
  String get net => 'Net';

  @override
  String get profit => 'Profit';

  @override
  String get date => 'Date';

  @override
  String get optionalNote => 'Note (optional)';

  @override
  String get saveRecord => 'Save Record';

  @override
  String get updateRecord => 'Update Record';

  @override
  String get today => 'Today';

  @override
  String get thisMonth => 'This Month';

  @override
  String get todaysSales => 'Today\'s Sales';

  @override
  String get todaysFuel => 'Today\'s Fuel';

  @override
  String get todaysExpenses => 'Today\'s Expenses';

  @override
  String get todaysNet => 'Today\'s Net';

  @override
  String get monthSales => 'Month Sales';

  @override
  String get monthFuel => 'Month Fuel';

  @override
  String get monthExpenses => 'Month Expenses';

  @override
  String get monthProfit => 'Month Profit';

  @override
  String get investmentRecovery => 'Investment Recovery';

  @override
  String get vehicleInvestment => 'Vehicle Investment';

  @override
  String get originalPurchasePrice => 'Original Purchase Price';

  @override
  String get totalOperatingProfit => 'Total Operating Profit';

  @override
  String get remainingInvestment => 'Remaining Investment';

  @override
  String get surplusBeyondInvestment => 'Profit Beyond Investment';

  @override
  String get recoveryPercentage => 'Recovery';

  @override
  String get vehicleName => 'Vehicle Name / Model';

  @override
  String get registrationNumber => 'Registration Number (optional)';

  @override
  String get purchaseDate => 'Purchase Date';

  @override
  String get purchasePrice => 'Purchase Price (PKR)';

  @override
  String get saveVehicle => 'Save Vehicle';

  @override
  String get workingDays => 'Working Days';

  @override
  String get averageDailySales => 'Average Daily Sales';

  @override
  String get averageDailyProfit => 'Average Daily Profit';

  @override
  String get bestEarningDay => 'Best Earning Day';

  @override
  String get lowestEarningDay => 'Lowest Earning Day';

  @override
  String get exportPdf => 'Export PDF';

  @override
  String get exportCsv => 'Export CSV';

  @override
  String get exportAllData => 'Export All Data';

  @override
  String get backupDatabase => 'Backup Database';

  @override
  String get restoreDatabase => 'Restore Database';

  @override
  String get about => 'About';

  @override
  String get resetData => 'Reset Application Data';

  @override
  String get theme => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get currencyDisplay => 'Currency Display';

  @override
  String get currencyRs => 'Rs.';

  @override
  String get currencyPkr => 'PKR';

  @override
  String get deleteRecord => 'Delete Record';

  @override
  String get deleteConfirm =>
      'Delete this daily record? This cannot be undone.';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get save => 'Save';

  @override
  String get searchByDate => 'Search by date';

  @override
  String get filterMonth => 'Month';

  @override
  String get filterYear => 'Year';

  @override
  String get allMonths => 'All months';

  @override
  String get noRecords => 'No records yet';

  @override
  String get noRecordsHint =>
      'Tap Add Daily Record to save today\'s sale, fuel, and expense.';

  @override
  String get recordSaved => 'Record saved';

  @override
  String get recordUpdated => 'Record updated';

  @override
  String get recordDeleted => 'Record deleted';

  @override
  String get vehicleSaved => 'Vehicle saved';

  @override
  String get dateAlreadyExists =>
      'A record for this date already exists. Saving will update it.';

  @override
  String get amountCannotBeNegative => 'Amount cannot be negative';

  @override
  String get invalidAmount => 'Enter a valid amount';

  @override
  String get requiredField => 'Required';

  @override
  String get noVehicleYet =>
      'Add your vehicle details to track investment recovery.';

  @override
  String get purchasePriceMissing =>
      'Set a purchase price to see recovery progress.';

  @override
  String get purchasePriceZero =>
      'Purchase price is zero, so recovery percent is not shown.';

  @override
  String get salesVsExpenses => 'Daily Sales vs Expenses';

  @override
  String get dailyNetEarnings => 'Daily Net Earnings';

  @override
  String get monthComparison => 'Sales, Fuel & Expenses';

  @override
  String get previousMonth => 'Previous month';

  @override
  String get nextMonth => 'Next month';

  @override
  String get backupCreated => 'Backup created';

  @override
  String get restoreSuccess => 'Database restored';

  @override
  String get exportSuccess => 'Export ready';

  @override
  String get resetTitle => 'Reset all data?';

  @override
  String get resetBody =>
      'This permanently deletes every daily record and vehicle setting. Type RESET to confirm.';

  @override
  String get resetConfirmWord => 'RESET';

  @override
  String get resetSuccess => 'All data cleared';

  @override
  String get aboutBody =>
      'CabLedger helps cab drivers track daily sales, fuel, and vehicle expenses offline, and see how much of the vehicle purchase price has been recovered through operating profit.';

  @override
  String get version => 'Version 1.0.0';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get editVehicle => 'Edit Vehicle';
}
