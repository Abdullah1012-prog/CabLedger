import 'package:sqflite/sqflite.dart';

import '../db/app_database.dart';
import '../models/vehicle.dart';

class VehicleRepository {
  VehicleRepository(this._appDatabase);

  final AppDatabase _appDatabase;

  Future<Vehicle?> getVehicle() async {
    final rows = await _appDatabase.db.query(
      'vehicle',
      where: 'id = ?',
      whereArgs: [1],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return Vehicle.fromMap(rows.first);
  }

  Future<Vehicle> save(Vehicle vehicle) async {
    if (vehicle.purchasePrice != null && vehicle.purchasePrice! < 0) {
      throw ArgumentError('Purchase price cannot be negative.');
    }

    final data = vehicle.copyWith(id: 1).toMap();
    await _appDatabase.db.insert(
      'vehicle',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return Vehicle.fromMap(data);
  }
}
