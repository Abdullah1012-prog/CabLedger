import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'app.dart';
import 'data/db/app_database.dart';
import 'data/repositories/daily_record_repository.dart';
import 'data/repositories/settings_repository.dart';
import 'data/repositories/vehicle_repository.dart';
import 'export/backup_service.dart';
import 'state/records_controller.dart';
import 'state/report_controller.dart';
import 'state/settings_controller.dart';
import 'state/vehicle_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppDatabase.ensureDesktopFfi();

  final prefs = await SharedPreferences.getInstance();
  final database = AppDatabase();
  await database.open();

  final dailyRepo = DailyRecordRepository(database);
  final vehicleRepo = VehicleRepository(database);
  final settingsRepo = SettingsRepository(prefs);
  final backupService = BackupService(database);

  final recordsController = RecordsController(repository: dailyRepo);
  final vehicleController = VehicleController(repository: vehicleRepo);
  final settingsController = SettingsController(settingsRepo);
  final reportController = ReportController();

  await Future.wait([
    recordsController.load(),
    vehicleController.load(),
  ]);

  runApp(
    MultiProvider(
      providers: [
        Provider<AppDatabase>.value(value: database),
        Provider<BackupService>.value(value: backupService),
        ChangeNotifierProvider<RecordsController>.value(
          value: recordsController,
        ),
        ChangeNotifierProvider<VehicleController>.value(
          value: vehicleController,
        ),
        ChangeNotifierProvider<SettingsController>.value(
          value: settingsController,
        ),
        ChangeNotifierProvider<ReportController>.value(
          value: reportController,
        ),
      ],
      child: const CabLedgerApp(),
    ),
  );
}

/// Test/bootstrap helper used by widget tests.
Future<Widget> createTestApp({
  AppDatabase? database,
  SharedPreferences? prefs,
}) async {
  WidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  final prefsInstance = prefs ?? await SharedPreferences.getInstance();
  final db = database ?? AppDatabase(factory: databaseFactoryFfi, inMemory: true);
  if (!db.isOpen) {
    await db.open();
  }

  final dailyRepo = DailyRecordRepository(db);
  final vehicleRepo = VehicleRepository(db);
  final settingsRepo = SettingsRepository(prefsInstance);
  final backupService = BackupService(db);

  final recordsController = RecordsController(repository: dailyRepo);
  final vehicleController = VehicleController(repository: vehicleRepo);
  final settingsController = SettingsController(settingsRepo);
  final reportController = ReportController();

  await Future.wait([
    recordsController.load(),
    vehicleController.load(),
  ]);

  return MultiProvider(
    providers: [
      Provider<AppDatabase>.value(value: db),
      Provider<BackupService>.value(value: backupService),
      ChangeNotifierProvider<RecordsController>.value(value: recordsController),
      ChangeNotifierProvider<VehicleController>.value(value: vehicleController),
      ChangeNotifierProvider<SettingsController>.value(
        value: settingsController,
      ),
      ChangeNotifierProvider<ReportController>.value(value: reportController),
    ],
    child: const CabLedgerApp(),
  );
}
