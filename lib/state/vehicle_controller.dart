import 'package:flutter/foundation.dart';

import '../data/models/daily_record.dart';
import '../data/models/vehicle.dart';
import '../data/repositories/vehicle_repository.dart';
import '../domain/finance_calculator.dart';

class VehicleController extends ChangeNotifier {
  VehicleController({
    required VehicleRepository this._repository,
    this._calculator = const FinanceCalculator(),
  });

  final VehicleRepository _repository;
  final FinanceCalculator _calculator;

  Vehicle? _vehicle;
  bool _loading = true;
  String? _error;

  Vehicle? get vehicle => _vehicle;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> load() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _vehicle = await _repository.getVehicle();
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<Vehicle> save(Vehicle vehicle) async {
    final saved = await _repository.save(vehicle);
    _vehicle = saved;
    notifyListeners();
    return saved;
  }

  InvestmentSummary investmentFor(List<DailyRecord> records) {
    return _calculator.investmentSummary(
      records: records,
      vehicle: _vehicle,
    );
  }
}
