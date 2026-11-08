import 'package:sqflite/sqflite.dart';

import '../db/app_database.dart';
import '../models/daily_record.dart';

class DailyRecordRepository {
  DailyRecordRepository(this._appDatabase);

  final AppDatabase _appDatabase;

  Database get _db => _appDatabase.db;

  String _nowIso() => DateTime.now().toUtc().toIso8601String();

  Future<List<DailyRecord>> getAll({
    String? monthPrefix,
    String? searchDate,
  }) async {
    final where = <String>[];
    final args = <Object?>[];

    if (monthPrefix != null && monthPrefix.isNotEmpty) {
      where.add("date LIKE ?");
      args.add('$monthPrefix%');
    }
    if (searchDate != null && searchDate.isNotEmpty) {
      where.add('date = ?');
      args.add(searchDate);
    }

    final rows = await _db.query(
      'daily_records',
      where: where.isEmpty ? null : where.join(' AND '),
      whereArgs: args.isEmpty ? null : args,
      orderBy: 'date DESC',
    );
    return rows.map(DailyRecord.fromMap).toList();
  }

  Future<DailyRecord?> getById(int id) async {
    final rows = await _db.query(
      'daily_records',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return DailyRecord.fromMap(rows.first);
  }

  Future<DailyRecord?> getByDate(String isoDate) async {
    final rows = await _db.query(
      'daily_records',
      where: 'date = ?',
      whereArgs: [isoDate],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return DailyRecord.fromMap(rows.first);
  }

  Future<DailyRecord> upsert(DailyRecord record) async {
    if (record.sale < 0 || record.fuel < 0 || record.expense < 0) {
      throw ArgumentError('Monetary values cannot be negative.');
    }

    final now = _nowIso();
    return _db.transaction((txn) async {
      final existing = await txn.query(
        'daily_records',
        where: 'date = ?',
        whereArgs: [record.date],
        limit: 1,
      );

      if (existing.isNotEmpty) {
        final id = existing.first['id'] as int;
        final createdAt = existing.first['created_at'] as String;
        await txn.update(
          'daily_records',
          {
            'sale': record.sale,
            'fuel': record.fuel,
            'expense': record.expense,
            'expense_description': record.expenseDescription,
            'updated_at': now,
          },
          where: 'id = ?',
          whereArgs: [id],
        );
        return DailyRecord(
          id: id,
          date: record.date,
          sale: record.sale,
          fuel: record.fuel,
          expense: record.expense,
          expenseDescription: record.expenseDescription,
          createdAt: createdAt,
          updatedAt: now,
        );
      }

      final id = await txn.insert('daily_records', {
        'date': record.date,
        'sale': record.sale,
        'fuel': record.fuel,
        'expense': record.expense,
        'expense_description': record.expenseDescription,
        'created_at': now,
        'updated_at': now,
      });

      return DailyRecord(
        id: id,
        date: record.date,
        sale: record.sale,
        fuel: record.fuel,
        expense: record.expense,
        expenseDescription: record.expenseDescription,
        createdAt: now,
        updatedAt: now,
      );
    });
  }

  Future<void> delete(int id) async {
    await _db.delete('daily_records', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<DailyRecord>> getForMonth(int year, int month) async {
    final prefix =
        '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}';
    return getAll(monthPrefix: prefix);
  }
}
