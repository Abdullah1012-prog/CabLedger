import '../core/format/date_format.dart';
import '../data/models/daily_record.dart';
import '../domain/finance_calculator.dart';

class CsvExporter {
  const CsvExporter();

  String dailyRecordsCsv(List<DailyRecord> records) {
    final buffer = StringBuffer();
    buffer.writeln('Date,Sale,Fuel,Expense,Net,Note');
    final ordered = List<DailyRecord>.from(records)
      ..sort((a, b) => a.date.compareTo(b.date));
    for (final r in ordered) {
      final note = _escape(r.expenseDescription ?? '');
      buffer.writeln(
        '${r.date},${_num(r.sale)},${_num(r.fuel)},${_num(r.expense)},${_num(r.net)},$note',
      );
    }
    return buffer.toString();
  }

  String monthlyReportCsv({
    required DateTime month,
    required List<DailyRecord> records,
    required MonthTotals totals,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('CabLedger Monthly Report');
    buffer.writeln('Month,${AppDateFormat.monthYear(month)}');
    buffer.writeln('Total Sales,${_num(totals.sales)}');
    buffer.writeln('Total Fuel,${_num(totals.fuel)}');
    buffer.writeln('Total Expenses,${_num(totals.expenses)}');
    buffer.writeln('Net Profit,${_num(totals.netProfit)}');
    buffer.writeln('Working Days,${totals.workingDays}');
    buffer.writeln(
      'Average Daily Sales,${totals.averageDailySales == null ? '' : _num(totals.averageDailySales!)}',
    );
    buffer.writeln(
      'Average Daily Profit,${totals.averageDailyProfit == null ? '' : _num(totals.averageDailyProfit!)}',
    );
    buffer.writeln(
      'Best Day,${totals.bestDay == null ? '' : totals.bestDay!.date}',
    );
    buffer.writeln(
      'Lowest Day,${totals.lowestDay == null ? '' : totals.lowestDay!.date}',
    );
    buffer.writeln();
    buffer.write(dailyRecordsCsv(records));
    return buffer.toString();
  }

  String _num(num value) => value.toString();

  String _escape(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }
}
