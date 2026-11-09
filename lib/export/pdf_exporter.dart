import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../core/format/date_format.dart';
import '../core/format/money_format.dart';
import '../data/models/daily_record.dart';
import '../domain/finance_calculator.dart';

class PdfExporter {
  const PdfExporter();

  Future<List<int>> monthlyReportPdf({
    required DateTime month,
    required List<DailyRecord> records,
    required MonthTotals totals,
    required MoneyFormat money,
  }) async {
    final doc = pw.Document();
    final ordered = List<DailyRecord>.from(records)
      ..sort((a, b) => a.date.compareTo(b.date));

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          pw.Text(
            'CabLedger Monthly Report',
            style: pw.TextStyle(
              fontSize: 22,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(AppDateFormat.monthYear(month)),
          pw.SizedBox(height: 20),
          pw.TableHelper.fromTextArray(
            headers: const ['Metric', 'Amount'],
            data: [
              ['Total Sales', money.format(totals.sales)],
              ['Total Fuel', money.format(totals.fuel)],
              ['Total Expenses', money.format(totals.expenses)],
              ['Net Profit', money.formatSigned(totals.netProfit)],
              ['Working Days', '${totals.workingDays}'],
              [
                'Average Daily Sales',
                totals.averageDailySales == null
                    ? '—'
                    : money.format(totals.averageDailySales!),
              ],
              [
                'Average Daily Profit',
                totals.averageDailyProfit == null
                    ? '—'
                    : money.formatSigned(totals.averageDailyProfit!),
              ],
              [
                'Best Earning Day',
                totals.bestDay == null
                    ? '—'
                    : '${AppDateFormat.displayStorage(totals.bestDay!.date)} (${money.formatSigned(totals.bestDay!.net)})',
              ],
              [
                'Lowest Earning Day',
                totals.lowestDay == null
                    ? '—'
                    : '${AppDateFormat.displayStorage(totals.lowestDay!.date)} (${money.formatSigned(totals.lowestDay!.net)})',
              ],
            ],
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            cellAlignment: pw.Alignment.centerLeft,
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
          ),
          pw.SizedBox(height: 24),
          pw.Text(
            'Daily Records',
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 8),
          if (ordered.isEmpty)
            pw.Text('No records for this month.')
          else
            pw.TableHelper.fromTextArray(
              headers: const ['Date', 'Sale', 'Fuel', 'Expense', 'Net'],
              data: ordered
                  .map(
                    (r) => [
                      AppDateFormat.displayStorage(r.date),
                      money.format(r.sale),
                      money.format(r.fuel),
                      money.format(r.expense),
                      money.formatSigned(r.net),
                    ],
                  )
                  .toList(),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              headerDecoration:
                  const pw.BoxDecoration(color: PdfColors.grey300),
              cellStyle: const pw.TextStyle(fontSize: 10),
            ),
        ],
      ),
    );

    return doc.save();
  }
}
