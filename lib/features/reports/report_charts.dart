import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../core/format/date_format.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/daily_record.dart';
import '../../domain/finance_calculator.dart';

class DailySalesVsExpensesChart extends StatelessWidget {
  const DailySalesVsExpensesChart({super.key, required this.records});

  final List<DailyRecord> records;

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return const _EmptyChart();
    }
    final ordered = List<DailyRecord>.from(records)
      ..sort((a, b) => a.date.compareTo(b.date));

    return SizedBox(
      height: 220,
      child: BarChart(
        BarChartData(
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= ordered.length) {
                    return const SizedBox.shrink();
                  }
                  if (ordered.length > 10 && index % 3 != 0) {
                    return const SizedBox.shrink();
                  }
                  final day = AppDateFormat.fromStorage(ordered[index].date).day;
                  return Text('$day', style: const TextStyle(fontSize: 10));
                },
              ),
            ),
          ),
          barGroups: [
            for (var i = 0; i < ordered.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: ordered[i].sale,
                    color: AppColors.profit,
                    width: 6,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  BarChartRodData(
                    toY: ordered[i].fuel + ordered[i].expense,
                    color: AppColors.expense,
                    width: 6,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class DailyNetChart extends StatelessWidget {
  const DailyNetChart({super.key, required this.records});

  final List<DailyRecord> records;

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return const _EmptyChart();
    }
    final ordered = List<DailyRecord>.from(records)
      ..sort((a, b) => a.date.compareTo(b.date));
    final spots = <FlSpot>[
      for (var i = 0; i < ordered.length; i++)
        FlSpot(i.toDouble(), ordered[i].net),
    ];

    return SizedBox(
      height: 220,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) => FlLine(
              color: AppColors.border,
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= ordered.length) {
                    return const SizedBox.shrink();
                  }
                  if (ordered.length > 10 && index % 3 != 0) {
                    return const SizedBox.shrink();
                  }
                  final day = AppDateFormat.fromStorage(ordered[index].date).day;
                  return Text('$day', style: const TextStyle(fontSize: 10));
                },
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: AppColors.navy,
              barWidth: 3,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.navy.withValues(alpha: 0.08),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MonthComparisonChart extends StatelessWidget {
  const MonthComparisonChart({super.key, required this.totals});

  final MonthTotals totals;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  switch (value.toInt()) {
                    case 0:
                      return const Text('Sales');
                    case 1:
                      return const Text('Fuel');
                    case 2:
                      return const Text('Expense');
                    default:
                      return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ),
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  toY: totals.sales,
                  color: AppColors.profit,
                  width: 28,
                  borderRadius: BorderRadius.circular(6),
                ),
              ],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(
                  toY: totals.fuel,
                  color: AppColors.fuel,
                  width: 28,
                  borderRadius: BorderRadius.circular(6),
                ),
              ],
            ),
            BarChartGroupData(
              x: 2,
              barRods: [
                BarChartRodData(
                  toY: totals.expenses,
                  color: AppColors.expense,
                  width: 28,
                  borderRadius: BorderRadius.circular(6),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyChart extends StatelessWidget {
  const _EmptyChart();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 160,
      child: Center(child: Text('No data for this month')),
    );
  }
}
