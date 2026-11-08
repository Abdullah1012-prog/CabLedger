import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/format/money_format.dart';
import '../models/app_settings.dart';

class SettingsRepository {
  SettingsRepository(this._prefs);

  final SharedPreferences _prefs;

  static const _themeKey = 'theme_mode';
  static const _currencyKey = 'currency_style';

  AppSettings load() {
    return AppSettings(
      themeMode: AppSettings.themeFromStorage(_prefs.getString(_themeKey)),
      currencyStyle: MoneyFormat.parseStyle(_prefs.getString(_currencyKey)),
    );
  }

  Future<void> saveTheme(ThemeMode mode) async {
    await _prefs.setString(_themeKey, AppSettings.themeToStorage(mode));
  }

  Future<void> saveCurrency(CurrencyStyle style) async {
    await _prefs.setString(_currencyKey, MoneyFormat.styleToStorage(style));
  }
}
