import 'package:cabledger/data/models/daily_record.dart';
import 'package:cabledger/data/models/vehicle.dart';
import 'package:cabledger/domain/finance_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const calc = FinanceCalculator();

  DailyRecord record({
    required String date,
    double sale = 0,
    double fuel = 0,
    double expense = 0,
  }) {
    return DailyRecord(
      date: date,
      sale: sale,
      fuel: fuel,
      expense: expense,
    );
  }

  group('daily profit', () {
    test('sale minus fuel minus expense', () {
      expect(
        calc.dailyProfit(
          record(date: '2026-01-01', sale: 5000, fuel: 1500, expense: 500),
        ),
        3000,
      );
    });

    test('allows zero amounts and negative net', () {
      expect(
        calc.dailyProfitFromAmounts(sale: 0, fuel: 100, expense: 50),
        -150,
      );
    });
  });

  group('month totals', () {
    test('empty month returns zeros and null averages', () {
      final totals = calc.monthTotals([]);
      expect(totals.sales, 0);
      expect(totals.fuel, 0);
      expect(totals.expenses, 0);
      expect(totals.netProfit, 0);
      expect(totals.workingDays, 0);
      expect(totals.averageDailySales, isNull);
      expect(totals.averageDailyProfit, isNull);
      expect(totals.bestDay, isNull);
      expect(totals.lowestDay, isNull);
    });

    test('sums month and picks best/lowest by profit with earliest tie', () {
      final records = [
        record(date: '2026-03-02', sale: 4000, fuel: 1000, expense: 0),
        record(date: '2026-03-01', sale: 4000, fuel: 1000, expense: 0),
        record(date: '2026-03-03', sale: 1000, fuel: 2000, expense: 500),
      ];
      final totals = calc.monthTotals(records);
      expect(totals.sales, 9000);
      expect(totals.fuel, 4000);
      expect(totals.expenses, 500);
      expect(totals.netProfit, 4500);
      expect(totals.workingDays, 3);
      expect(totals.averageDailySales, 3000);
      expect(totals.averageDailyProfit, 1500);
      expect(totals.bestDay!.date, '2026-03-01');
      expect(totals.lowestDay!.date, '2026-03-03');
    });
  });

  group('investment recovery', () {
    final records = [
      record(date: '2025-12-31', sale: 10000, fuel: 0, expense: 0),
      record(date: '2026-01-01', sale: 5000, fuel: 1000, expense: 0),
      record(date: '2026-01-02', sale: 4000, fuel: 500, expense: 500),
    ];

    test('ignores records before purchase date', () {
      final summary = calc.investmentSummary(
        records: records,
        vehicle: const Vehicle(
          vehicleName: 'Alto',
          purchaseDate: '2026-01-01',
          purchasePrice: 1000000,
        ),
      );
      // 4000 + 3000 = 7000, December ignored
      expect(summary.cumulativeProfit, 7000);
      expect(summary.remainingInvestment, 993000);
      expect(summary.recoveryPercent, closeTo(0.7, 0.0001));
    });

    test('uses all records when purchase date missing', () {
      final summary = calc.investmentSummary(
        records: records,
        vehicle: const Vehicle(
          vehicleName: 'Alto',
          purchasePrice: 1000000,
        ),
      );
      expect(summary.cumulativeProfit, 17000);
    });

    test('does not clamp remaining below zero when surplus', () {
      final summary = calc.investmentSummary(
        records: [
          record(date: '2026-01-01', sale: 120000, fuel: 0, expense: 0),
        ],
        vehicle: const Vehicle(
          vehicleName: 'Alto',
          purchaseDate: '2026-01-01',
          purchasePrice: 100000,
        ),
      );
      expect(summary.cumulativeProfit, 120000);
      expect(summary.remainingInvestment, -20000);
      expect(summary.hasSurplus, isTrue);
      expect(summary.recoveryPercent, 120);
      expect(summary.progressFraction, 1);
    });

    test('missing purchase price yields no percent', () {
      final summary = calc.investmentSummary(
        records: records,
        vehicle: const Vehicle(vehicleName: 'Alto'),
      );
      expect(summary.hasPurchasePrice, isFalse);
      expect(summary.recoveryPercent, isNull);
      expect(summary.remainingInvestment, isNull);
      expect(summary.cumulativeProfit, 17000);
    });

    test('zero purchase price yields no percent', () {
      final summary = calc.investmentSummary(
        records: records,
        vehicle: const Vehicle(
          vehicleName: 'Alto',
          purchasePrice: 0,
        ),
      );
      expect(summary.hasPurchasePrice, isFalse);
      expect(summary.recoveryPercent, isNull);
    });

    test('never uses gross sales for recovery', () {
      final summary = calc.investmentSummary(
        records: [
          record(date: '2026-01-01', sale: 10000, fuel: 3000, expense: 2000),
        ],
        vehicle: const Vehicle(
          vehicleName: 'Alto',
          purchasePrice: 100000,
          purchaseDate: '2026-01-01',
        ),
      );
      expect(summary.cumulativeProfit, 5000);
      expect(summary.recoveredInvestment, 5000);
    });
  });
}
