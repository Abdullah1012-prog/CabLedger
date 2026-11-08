import 'package:cabledger/core/format/money_format.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('formats with Rs. prefix and grouping', () {
    final money = MoneyFormat(style: CurrencyStyle.rs);
    expect(money.format(10000), 'Rs. 10,000');
    expect(money.format(1000.5), 'Rs. 1,000.5');
  });

  test('formats with PKR prefix', () {
    final money = MoneyFormat(style: CurrencyStyle.pkr);
    expect(money.format(2500), 'PKR 2,500');
  });

  test('formats signed negatives', () {
    final money = MoneyFormat();
    expect(money.formatSigned(-1500), '-Rs. 1,500');
  });
}
