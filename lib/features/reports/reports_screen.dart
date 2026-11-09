import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/format/date_format.dart';
import '../../core/theme/app_theme.dart';
import '../../export/backup_service.dart';
import '../../export/pdf_exporter.dart';
import '../../l10n/app_localizations.dart';
import '../../state/records_controller.dart';
import '../../state/report_controller.dart';
import '../../state/settings_controller.dart';
import '../shared/stat_card.dart';
import 'report_charts.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final records = context.watch<RecordsController>();
    final report = context.watch<ReportController>();
    final money = context.watch<SettingsController>().money;
    final monthRecords = report.recordsForSelected(records.records);
    final totals = report.totalsForSelected(records.records);
    final nested = ModalRoute.of(context)?.canPop ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.monthlyReports),
        automaticallyImplyLeading: nested,
        actions: [
          IconButton(
            tooltip: l10n.exportCsv,
            onPressed: () => _exportCsv(context),
            icon: const Icon(Icons.table_chart_outlined),
          ),
          IconButton(
            tooltip: l10n.exportPdf,
            onPressed: () => _exportPdf(context),
            icon: const Icon(Icons.picture_as_pdf_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          Row(
            children: [
              IconButton(
                tooltip: l10n.previousMonth,
                onPressed: () =>
                    context.read<ReportController>().previousMonth(),
                icon: const Icon(Icons.chevron_left),
              ),
              Expanded(
                child: Text(
                  AppDateFormat.monthYear(report.selectedMonth),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              IconButton(
                tooltip: l10n.nextMonth,
                onPressed: () => context.read<ReportController>().nextMonth(),
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
          const SizedBox(height: 8),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.4,
            children: [
              StatCard(
                label: l10n.sale,
                value: money.format(totals.sales),
                color: AppColors.profit,
              ),
              StatCard(
                label: l10n.fuel,
                value: money.format(totals.fuel),
                color: AppColors.fuel,
              ),
              StatCard(
                label: l10n.expenses,
                value: money.format(totals.expenses),
                color: AppColors.expense,
              ),
              StatCard(
                label: l10n.profit,
                value: money.formatSigned(totals.netProfit),
                color: totals.netProfit >= 0
                    ? AppColors.profit
                    : AppColors.expense,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _metricRow(l10n.workingDays, '${totals.workingDays}'),
                  _metricRow(
                    l10n.averageDailySales,
                    totals.averageDailySales == null
                        ? '—'
                        : money.format(totals.averageDailySales!),
                  ),
                  _metricRow(
                    l10n.averageDailyProfit,
                    totals.averageDailyProfit == null
                        ? '—'
                        : money.formatSigned(totals.averageDailyProfit!),
                  ),
                  _metricRow(
                    l10n.bestEarningDay,
                    totals.bestDay == null
                        ? '—'
                        : '${AppDateFormat.displayStorage(totals.bestDay!.date)} (${money.formatSigned(totals.bestDay!.net)})',
                  ),
                  _metricRow(
                    l10n.lowestEarningDay,
                    totals.lowestDay == null
                        ? '—'
                        : '${AppDateFormat.displayStorage(totals.lowestDay!.date)} (${money.formatSigned(totals.lowestDay!.net)})',
                    isLast: true,
                  ),
                ],
              ),
            ),
          ),
          SectionHeader(l10n.salesVsExpenses),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: DailySalesVsExpensesChart(records: monthRecords),
            ),
          ),
          SectionHeader(l10n.dailyNetEarnings),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: DailyNetChart(records: monthRecords),
            ),
          ),
          SectionHeader(l10n.monthComparison),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: MonthComparisonChart(totals: totals),
            ),
          ),
        ],
      ),
    );
  }

  Widget _metricRow(String label, String value, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _exportCsv(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    try {
      final report = context.read<ReportController>();
      final records = context.read<RecordsController>();
      final backup = context.read<BackupService>();
      final monthRecords = report.recordsForSelected(records.records);
      final totals = report.totalsForSelected(records.records);
      final file = await backup.exportMonthCsv(
        month: report.selectedMonth,
        records: monthRecords,
        totals: totals,
      );
      await SharePlus.instance.share(
        ShareParams(files: [XFile(file.path)], text: 'CabLedger monthly CSV'),
      );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.exportSuccess)),
      );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.errorGeneric)),
      );
    }
  }

  Future<void> _exportPdf(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    try {
      final report = context.read<ReportController>();
      final records = context.read<RecordsController>();
      final money = context.read<SettingsController>().money;
      final backup = context.read<BackupService>();
      final monthRecords = report.recordsForSelected(records.records);
      final totals = report.totalsForSelected(records.records);
      final bytes = await const PdfExporter().monthlyReportPdf(
        month: report.selectedMonth,
        records: monthRecords,
        totals: totals,
        money: money,
      );
      final stamp =
          '${report.selectedMonth.year}-${report.selectedMonth.month.toString().padLeft(2, '0')}';
      final file = await backup.writePdfBytes(
        'cabledger_month_$stamp.pdf',
        bytes,
      );
      await SharePlus.instance.share(
        ShareParams(files: [XFile(file.path)], text: 'CabLedger monthly PDF'),
      );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.exportSuccess)),
      );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.errorGeneric)),
      );
    }
  }
}
