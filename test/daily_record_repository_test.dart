import 'package:cabledger/data/db/app_database.dart';
import 'package:cabledger/data/models/daily_record.dart';
import 'package:cabledger/data/repositories/daily_record_repository.dart';
import 'package:cabledger/data/repositories/vehicle_repository.dart';
import 'package:cabledger/data/models/vehicle.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  late AppDatabase db;
  late DailyRecordRepository repo;

  setUp(() async {
    db = AppDatabase(factory: databaseFactoryFfi, inMemory: true);
    await db.open();
    repo = DailyRecordRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('upsert inserts then updates same date', () async {
    final first = await repo.upsert(
      const DailyRecord(
        date: '2026-04-01',
        sale: 1000,
        fuel: 200,
        expense: 0,
      ),
    );
    expect(first.id, isNotNull);

    final second = await repo.upsert(
      const DailyRecord(
        date: '2026-04-01',
        sale: 2000,
        fuel: 300,
        expense: 100,
        expenseDescription: 'Oil',
      ),
    );
    expect(second.id, first.id);

    final all = await repo.getAll();
    expect(all, hasLength(1));
    expect(all.first.sale, 2000);
    expect(all.first.expenseDescription, 'Oil');
  });

  test('rejects negative amounts', () async {
    expect(
      () => repo.upsert(
        const DailyRecord(
          date: '2026-04-02',
          sale: -1,
          fuel: 0,
          expense: 0,
        ),
      ),
      throwsArgumentError,
    );
  });

  test('delete removes record', () async {
    final saved = await repo.upsert(
      const DailyRecord(
        date: '2026-04-03',
        sale: 500,
        fuel: 0,
        expense: 0,
      ),
    );
    await repo.delete(saved.id!);
    expect(await repo.getAll(), isEmpty);
  });

  test('vehicle repository save and load', () async {
    final vehicles = VehicleRepository(db);
    await vehicles.save(
      const Vehicle(
        vehicleName: 'Suzuki Alto',
        registrationNumber: 'LES-123',
        purchaseDate: '2024-01-15',
        purchasePrice: 1800000,
      ),
    );
    final loaded = await vehicles.getVehicle();
    expect(loaded!.vehicleName, 'Suzuki Alto');
    expect(loaded.purchasePrice, 1800000);
  });
}
