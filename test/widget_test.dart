import 'package:cabledger/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  testWidgets('CabLedger shell shows Home destination', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final app = await createTestApp();
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    expect(find.text('CabLedger'), findsOneWidget);
    expect(find.text('Home'), findsWidgets);
  });
}
