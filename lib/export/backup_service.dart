import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../data/db/app_database.dart';
import '../export/csv_exporter.dart';
import '../data/models/daily_record.dart';
import '../domain/finance_calculator.dart';

class BackupService {
  BackupService(this._database);

  final AppDatabase _database;
  final CsvExporter _csv = const CsvExporter();

  Future<File> backupDatabase() async {
    final dir = await getApplicationDocumentsDirectory();
    final stamp = DateTime.now()
        .toIso8601String()
        .replaceAll(':', '-')
        .split('.')
        .first;
    final dest = File(p.join(dir.path, 'cabledger_backup_$stamp.db'));
    await _database.backupToFile(dest.path);
    return dest;
  }

  Future<void> restoreDatabase(String sourcePath) async {
    await _database.restoreFromFile(sourcePath);
  }

  Future<File> writeCsvFile(String name, String contents) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, name));
    await file.writeAsString(contents);
    return file;
  }

  Future<File> exportAllRecordsCsv(List<DailyRecord> records) {
    final stamp = DateTime.now().toIso8601String().split('T').first;
    return writeCsvFile(
      'cabledger_all_$stamp.csv',
      _csv.dailyRecordsCsv(records),
    );
  }

  Future<File> exportMonthCsv({
    required DateTime month,
    required List<DailyRecord> records,
    required MonthTotals totals,
  }) {
    final stamp =
        '${month.year}-${month.month.toString().padLeft(2, '0')}';
    return writeCsvFile(
      'cabledger_month_$stamp.csv',
      _csv.monthlyReportCsv(
        month: month,
        records: records,
        totals: totals,
      ),
    );
  }

  Future<File> writePdfBytes(String name, List<int> bytes) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, name));
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }
}
