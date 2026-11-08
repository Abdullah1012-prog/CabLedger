import 'package:flutter/material.dart';

import '../../core/format/money_format.dart';

class AppSettings {
  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.currencyStyle = CurrencyStyle.rs,
  });

  final ThemeMode themeMode;
  final CurrencyStyle currencyStyle;

  AppSettings copyWith({
    ThemeMode? themeMode,
    CurrencyStyle? currencyStyle,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      currencyStyle: currencyStyle ?? this.currencyStyle,
    );
  }

  static ThemeMode themeFromStorage(String? raw) {
    switch (raw) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  static String themeToStorage(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}
