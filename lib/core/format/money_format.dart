import 'package:intl/intl.dart';

enum CurrencyStyle { rs, pkr }

/// Formats PKR amounts with Pakistani grouping, e.g. Rs. 10,000.
class MoneyFormat {
  MoneyFormat({this.style = CurrencyStyle.rs});

  final CurrencyStyle style;

  static final NumberFormat _number = NumberFormat('#,##0.##', 'en_PK');

  String format(num amount) {
    final prefix = style == CurrencyStyle.rs ? 'Rs.' : 'PKR';
    return '$prefix ${_number.format(amount)}';
  }

  String formatSigned(num amount) {
    if (amount < 0) {
      return '-${format(amount.abs())}';
    }
    return format(amount);
  }

  static CurrencyStyle parseStyle(String? raw) {
    return raw == 'pkr' ? CurrencyStyle.pkr : CurrencyStyle.rs;
  }

  static String styleToStorage(CurrencyStyle style) {
    return style == CurrencyStyle.pkr ? 'pkr' : 'rs';
  }
}
