import 'package:flutter_test/flutter_test.dart';
import 'package:waroengkolong/main.dart';

void main() {
  testWidgets('renders Waroeng Kolong web-like order rules', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const WaroengKolongApp());

    expect(find.text('WAROENG KOLONG'), findsWidgets);
    expect(find.text('Mie Rebus Medan'), findsWidgets);
    expect(find.text('Lontong Medan'), findsWidgets);

    await tester.scrollUntilVisible(
      find.textContaining('Minimal 20 porsi per menu'),
      500,
    );
    expect(find.textContaining('Minimal 20 porsi per menu'), findsOneWidget);
    expect(find.textContaining('BCA: 0461964345'), findsOneWidget);
    expect(find.textContaining('ShopeePay: 082179717972'), findsOneWidget);
  });
}
