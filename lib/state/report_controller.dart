import 'package:flutter/foundation.dart';

import '../data/models/daily_record.dart';
import '../domain/finance_calculator.dart';

class ReportController extends ChangeNotifier {
  ReportController({this._calculator = const FinanceCalculator()});

  final FinanceCalculator _calculator;

  late DateTime _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);

  DateTime get selectedMonth => _selectedMonth;

  void setMonth(DateTime month) {
    _selectedMonth = DateTime(month.year, month.month);
    notifyListeners();
  }

  void previousMonth() {
    setMonth(DateTime(_selectedMonth.year, _selectedMonth.month - 1));
  }

  void nextMonth() {
    setMonth(DateTime(_selectedMonth.year, _selectedMonth.month + 1));
  }

  List<DailyRecord> recordsForSelected(List<DailyRecord> all) {
    return _calculator.recordsForMonth(
      all,
      _selectedMonth.year,
      _selectedMonth.month,
    );
  }

  MonthTotals totalsForSelected(List<DailyRecord> all) {
    return _calculator.monthTotals(recordsForSelected(all));
  }
}
