import 'package:flutter/foundation.dart';

import '../core/format/date_format.dart';
import '../data/models/daily_record.dart';
import '../data/repositories/daily_record_repository.dart';
import '../domain/finance_calculator.dart';

class RecordsController extends ChangeNotifier {
  RecordsController({
    required DailyRecordRepository this._repository,
    this._calculator = const FinanceCalculator(),
  });

  final DailyRecordRepository _repository;
  final FinanceCalculator _calculator;

  List<DailyRecord> _records = [];
  bool _loading = true;
  String? _error;
  String? _searchDate;
  int? _filterYear;
  int? _filterMonth;

  List<DailyRecord> get records => List.unmodifiable(_records);
  bool get loading => _loading;
  String? get error => _error;
  String? get searchDate => _searchDate;
  int? get filterYear => _filterYear;
  int? get filterMonth => _filterMonth;
  FinanceCalculator get calculator => _calculator;

  List<DailyRecord> get filteredRecords {
    var list = _records;
    if (_searchDate != null && _searchDate!.isNotEmpty) {
      list = list.where((r) => r.date == _searchDate).toList();
    } else if (_filterYear != null && _filterMonth != null) {
      list = _calculator.recordsForMonth(list, _filterYear!, _filterMonth!);
    } else if (_filterYear != null) {
      final prefix = _filterYear!.toString().padLeft(4, '0');
      list = list.where((r) => r.date.startsWith(prefix)).toList();
    }
    return list;
  }

  DailyRecord? get todayRecord {
    final today = AppDateFormat.toStorage(DateTime.now());
    return _calculator.recordForDate(_records, today);
  }

  MonthTotals get todayTotals {
    final record = todayRecord;
    if (record == null) {
      return const MonthTotals(
        sales: 0,
        fuel: 0,
        expenses: 0,
        netProfit: 0,
        workingDays: 0,
        averageDailySales: null,
        averageDailyProfit: null,
        bestDay: null,
        lowestDay: null,
      );
    }
    return MonthTotals(
      sales: record.sale,
      fuel: record.fuel,
      expenses: record.expense,
      netProfit: record.net,
      workingDays: 1,
      averageDailySales: record.sale,
      averageDailyProfit: record.net,
      bestDay: record,
      lowestDay: record,
    );
  }

  MonthTotals currentMonthTotals() {
    final now = DateTime.now();
    return _calculator.monthTotals(
      _calculator.recordsForMonth(_records, now.year, now.month),
    );
  }

  Future<void> load() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _records = await _repository.getAll();
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void setSearchDate(String? isoDate) {
    _searchDate = isoDate;
    notifyListeners();
  }

  void setMonthFilter({int? year, int? month}) {
    _filterYear = year;
    _filterMonth = month;
    notifyListeners();
  }

  void clearFilters() {
    _searchDate = null;
    _filterYear = null;
    _filterMonth = null;
    notifyListeners();
  }

  Future<DailyRecord?> findByDate(String isoDate) {
    return _repository.getByDate(isoDate);
  }

  Future<DailyRecord> save(DailyRecord record) async {
    final saved = await _repository.upsert(record);
    await load();
    return saved;
  }

  Future<void> delete(int id) async {
    await _repository.delete(id);
    await load();
  }
}
