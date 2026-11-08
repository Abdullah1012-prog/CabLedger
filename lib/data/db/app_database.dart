import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// SQLite access for CabLedger. Uses FFI on desktop and in tests.
class AppDatabase {
  AppDatabase({DatabaseFactory? this._factory, this.inMemory = false});

  static const dbName = 'cabledger.db';
  static const version = 1;

  final DatabaseFactory? _factory;
  final bool inMemory;

  Database? _db;

  Database get db {
    final database = _db;
    if (database == null) {
      throw StateError('Database has not been opened. Call open() first.');
    }
    return database;
  }

  bool get isOpen => _db != null && _db!.isOpen;

  static void ensureDesktopFfi() {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
  }

  Future<Database> open() async {
    if (_db != null && _db!.isOpen) {
      return _db!;
    }

    final factory = _factory ?? databaseFactory;
    final String path;
    if (inMemory) {
      path = inMemoryDatabasePath;
    } else {
      final dir = await getApplicationDocumentsDirectory();
      path = p.join(dir.path, dbName);
    }

    _db = await factory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: version,
        onConfigure: (db) async {
          await db.execute('PRAGMA foreign_keys = ON');
        },
        onCreate: (db, version) async {
          await _createSchema(db);
        },
      ),
    );
    return _db!;
  }

  Future<void> _createSchema(Database db) async {
    await db.execute('''
CREATE TABLE daily_records (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  date TEXT NOT NULL UNIQUE,
  sale REAL NOT NULL DEFAULT 0 CHECK (sale >= 0),
  fuel REAL NOT NULL DEFAULT 0 CHECK (fuel >= 0),
  expense REAL NOT NULL DEFAULT 0 CHECK (expense >= 0),
  expense_description TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
)
''');

    await db.execute('''
CREATE TABLE vehicle (
  id INTEGER PRIMARY KEY CHECK (id = 1),
  vehicle_name TEXT NOT NULL,
  registration_number TEXT,
  purchase_date TEXT,
  purchase_price REAL CHECK (purchase_price IS NULL OR purchase_price >= 0)
)
''');
  }

  Future<String> databaseFilePath() async {
    final dir = await getApplicationDocumentsDirectory();
    return p.join(dir.path, dbName);
  }

  Future<void> close() async {
    if (_db != null) {
      await _db!.close();
      _db = null;
    }
  }

  /// Deletes all rows. Schema remains.
  Future<void> resetAllData() async {
    await db.transaction((txn) async {
      await txn.delete('daily_records');
      await txn.delete('vehicle');
    });
  }

  /// Closes, replaces the on-disk file, and reopens.
  Future<void> restoreFromFile(String sourcePath) async {
    final target = await databaseFilePath();
    await close();
    final source = File(sourcePath);
    if (!await source.exists()) {
      throw StateError('Backup file not found.');
    }
    await source.copy(target);
    await open();
  }

  Future<void> backupToFile(String destinationPath) async {
    if (!isOpen) {
      await open();
    }
    // Checkpoint so the main file is consistent for copy.
    await db.rawQuery('PRAGMA wal_checkpoint(FULL)');
    final sourcePath = await databaseFilePath();
    final source = File(sourcePath);
    if (!await source.exists()) {
      throw StateError('Database file not found.');
    }
    await source.copy(destinationPath);
  }
}
