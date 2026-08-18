import 'package:flutter_test/flutter_test.dart';
import 'package:password_generator/main.dart';

void main() {
  testWidgets('Password Generator app loads successfully',
          (WidgetTester tester) async {
        await tester.pumpWidget(const PasswordGeneratorApp());

        expect(find.text('Password Generator'), findsOneWidget);
        expect(find.text('Generate Password'), findsOneWidget);
      });
}