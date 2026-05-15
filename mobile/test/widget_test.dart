import 'package:flutter_test/flutter_test.dart';
import 'package:waroengkolong/main.dart';

void main() {
  testWidgets('renders Waroeng Kolong order MVP', (WidgetTester tester) async {
    await tester.pumpWidget(const WaroengKolongApp());

    expect(find.text('Waroeng Kolong'), findsOneWidget);
    expect(find.text('Order dari app, ambil di stan'), findsOneWidget);
    expect(find.text('Nasi Ayam Kolong'), findsOneWidget);
  });
}
