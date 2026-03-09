// Basic smoke test for NFC Manager app
//
// This test verifies that the app can be initialized without errors.

import 'package:flutter_test/flutter_test.dart';

import 'package:app/view/app.dart';

void main() {
  testWidgets('App initializes correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    final app = await App.withDependency();
    await tester.pumpWidget(app);

    // Verify that the app title is displayed
    expect(find.text('NFC Manager'), findsOneWidget);
  });
}
