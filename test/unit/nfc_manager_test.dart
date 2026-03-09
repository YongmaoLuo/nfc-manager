import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nfc_manager/nfc_manager.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('NfcManager', () {
    setUp(() {
      // Set up mock MethodChannel handler before each test
      MethodChannel('dev.flutter.pigeon.nfc_manager')
          .setMockMethodCallHandler((call) async {
        switch (call.method) {
          case 'checkAvailability':
            return true; // Simulate NFC available
          case 'startSession':
            return null; // Simulate successful start
          case 'stopSession':
            return null; // Simulate successful stop
          default:
            return null;
        }
      });
    });

    tearDown(() {
      // Clean up mock after each test
      MethodChannel('dev.flutter.pigeon.nfc_manager')
          .setMockMethodCallHandler(null);
    });

    test('isAvailable returns true when NFC is available', () async {
      final isAvailable = await NfcManager.instance.isAvailable();
      expect(isAvailable, isTrue);
    });

    test('startSession can be called successfully', () async {
      // This should not throw
      await expectLater(
        NfcManager.instance.startSession(
          onDiscovered: (tag) async {},
        ),
        completes,
      );
    });

    test('stopSession can be called successfully', () async {
      // This should not throw
      await expectLater(
        NfcManager.instance.stopSession(),
        completes,
      );
    });
  });
}
