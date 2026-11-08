import 'package:flutter/material.dart';

import '../core/format/money_format.dart';
import '../data/models/app_settings.dart';
import '../data/repositories/settings_repository.dart';

class SettingsController extends ChangeNotifier {
  SettingsController(this._repository);

  final SettingsRepository _repository;

  late AppSettings _settings = _repository.load();

  AppSettings get settings => _settings;
  ThemeMode get themeMode => _settings.themeMode;
  CurrencyStyle get currencyStyle => _settings.currencyStyle;
  MoneyFormat get money => MoneyFormat(style: _settings.currencyStyle);

  Future<void> setThemeMode(ThemeMode mode) async {
    await _repository.saveTheme(mode);
    _settings = _settings.copyWith(themeMode: mode);
    notifyListeners();
  }

  Future<void> setCurrencyStyle(CurrencyStyle style) async {
    await _repository.saveCurrency(style);
    _settings = _settings.copyWith(currencyStyle: style);
    notifyListeners();
  }

  void reload() {
    _settings = _repository.load();
    notifyListeners();
  }
}
