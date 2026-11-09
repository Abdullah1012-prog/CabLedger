import '../data/models/daily_record.dart';
import '../data/models/vehicle.dart';

class MonthTotals {
  const MonthTotals({
    required this.sales,
    required this.fuel,
    required this.expenses,
    required this.netProfit,
    required this.workingDays,
    required this.averageDailySales,
    required this.averageDailyProfit,
    required this.bestDay,
    required this.lowestDay,
  });

  final double sales;
  final double fuel;
  final double expenses;
  final double netProfit;
  final int workingDays;
  final double? averageDailySales;
  final double? averageDailyProfit;
  final DailyRecord? bestDay;
  final DailyRecord? lowestDay;
}

class InvestmentSummary {
  const InvestmentSummary({
    required this.purchasePrice,
    required this.cumulativeProfit,
    required this.remainingInvestment,
    required this.recoveryPercent,
    required this.hasPurchasePrice,
  });

  final double? purchasePrice;
  final double cumulativeProfit;
  final double? remainingInvestment;
  final double? recoveryPercent;
  final bool hasPurchasePrice;

  bool get hasSurplus =>
      remainingInvestment != null && remainingInvestment! < 0;

  double get recoveredInvestment => cumulativeProfit;

  /// Progress bar fill 0.0–1.0. Values above 100% still fill the bar fully.
  double get progressFraction {
    final percent = recoveryPercent;
    if (percent == null) return 0;
    if (percent <= 0) return 0;
    if (percent >= 100) return 1;
    return percent / 100;
  }
}

/// Pure financial calculations. No I/O.
class FinanceCalculator {
  const FinanceCalculator();

  double dailyProfit(DailyRecord record) =>
      record.sale - record.fuel - record.expense;

  double dailyProfitFromAmounts({
    required double sale,
    required double fuel,
    required double expense,
  }) =>
      sale - fuel - expense;

  MonthTotals monthTotals(List<DailyRecord> records) {
    if (records.isEmpty) {
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

    var sales = 0.0;
    var fuel = 0.0;
    var expenses = 0.0;
    DailyRecord? best;
    DailyRecord? lowest;

    // Prefer chronological order for earliest-date tie-breaks.
    final ordered = List<DailyRecord>.from(records)
      ..sort((a, b) => a.date.compareTo(b.date));

    for (final record in ordered) {
      sales += record.sale;
      fuel += record.fuel;
      expenses += record.expense;
      final profit = dailyProfit(record);
      if (best == null || profit > dailyProfit(best)) {
        best = record;
      }
      if (lowest == null || profit < dailyProfit(lowest)) {
        lowest = record;
      }
    }

    final days = ordered.length;
    final net = sales - fuel - expenses;
    return MonthTotals(
      sales: sales,
      fuel: fuel,
      expenses: expenses,
      netProfit: net,
      workingDays: days,
      averageDailySales: sales / days,
      averageDailyProfit: net / days,
      bestDay: best,
      lowestDay: lowest,
    );
  }

  /// Sum of daily net profits for records on/after purchase date (if set).
  double cumulativeOperatingProfit({
    required List<DailyRecord> records,
    String? purchaseDate,
  }) {
    var total = 0.0;
    for (final record in records) {
      if (purchaseDate != null && record.date.compareTo(purchaseDate) < 0) {
        continue;
      }
      total += dailyProfit(record);
    }
    return total;
  }

  InvestmentSummary investmentSummary({
    required List<DailyRecord> records,
    required Vehicle? vehicle,
  }) {
    final purchasePrice = vehicle?.purchasePrice;
    final purchaseDate = vehicle?.purchaseDate;
    final cumulative = cumulativeOperatingProfit(
      records: records,
      purchaseDate: purchaseDate,
    );

    final hasPrice = purchasePrice != null && purchasePrice > 0;
    if (!hasPrice) {
      return InvestmentSummary(
        purchasePrice: purchasePrice,
        cumulativeProfit: cumulative,
        remainingInvestment: null,
        recoveryPercent: null,
        hasPurchasePrice: false,
      );
    }

    return InvestmentSummary(
      purchasePrice: purchasePrice,
      cumulativeProfit: cumulative,
      remainingInvestment: purchasePrice - cumulative,
      recoveryPercent: (cumulative / purchasePrice) * 100,
      hasPurchasePrice: true,
    );
  }

  List<DailyRecord> recordsForMonth(
    List<DailyRecord> records,
    int year,
    int month,
  ) {
    final prefix =
        '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}';
    return records.where((r) => r.date.startsWith(prefix)).toList();
  }

  DailyRecord? recordForDate(List<DailyRecord> records, String isoDate) {
    for (final record in records) {
      if (record.date == isoDate) return record;
    }
    return null;
  }
}
