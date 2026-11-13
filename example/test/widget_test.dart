import 'package:flutter_test/flutter_test.dart';

import 'package:veerens_floating_api_example/main.dart';

void main() {
  testWidgets('home page renders with the floating button', (WidgetTester tester) async {
    await tester.pumpWidget(const ExampleApp());
    await tester.pump();
    // No native plugin answers the automatic store-install check in a
    // widget test, so it falls back only after its internal timeout —
    // advance virtual time past that explicitly.
    await tester.pump(const Duration(seconds: 3));
    await tester.pump();

    expect(find.text('veerens_floating_api demo'), findsOneWidget);
    expect(find.text('V'), findsOneWidget);
  });
}
