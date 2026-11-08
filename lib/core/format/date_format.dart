import 'package:intl/intl.dart';

/// Storage uses ISO dates; display uses a readable Pakistani English style.
class AppDateFormat {
  static final DateFormat _storage = DateFormat('yyyy-MM-dd');
  static final DateFormat _display = DateFormat('dd MMM yyyy', 'en_PK');
  static final DateFormat _monthYear = DateFormat('MMMM yyyy', 'en_PK');
  static final DateFormat _dayMonth = DateFormat('dd MMM', 'en_PK');

  static String toStorage(DateTime date) =>
      _storage.format(DateTime(date.year, date.month, date.day));

  static DateTime fromStorage(String value) => _storage.parseStrict(value);

  static String display(DateTime date) => _display.format(date);

  static String displayStorage(String isoDate) =>
      display(fromStorage(isoDate));

  static String monthYear(DateTime date) => _monthYear.format(date);

  static String dayMonth(DateTime date) => _dayMonth.format(date);

  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static DateTime dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);
}
