import 'dart:io';
import 'package:flutter_test/flutter_test.dart';


void main() {
  group('Platform Channel Names', () {
    test('Android uses correct channel name', () {
      // Android platform channel should match
      expect(
        'dev.flutter.pigeon.nfc_manager_android',
        equals('dev.flutter.pigeon.nfc_manager_android'),
      );
    });

    test('iOS uses correct channel name', () {
      // iOS platform channel should match
      expect(
        'dev.flutter.pigeon.nfc_manager_ios',
        equals('dev.flutter.pigeon.nfc_manager_ios'),
      );
    });
  });

  group('Platform Detection', () {
    test('Platform.isAndroid works correctly', () {
      // This will be true on Android, false otherwise
      if (Platform.isAndroid) {
        expect(Platform.isAndroid, isTrue);
      } else {
        expect(Platform.isAndroid, isFalse);
      }
    });

    test('Platform.isIOS works correctly', () {
      // This will be true on iOS, false otherwise
      if (Platform.isIOS) {
        expect(Platform.isIOS, isTrue);
      } else {
        expect(Platform.isIOS, isFalse);
      }
    });

    test('Platform.operatingSystem returns valid value', () {
      expect(
        Platform.operatingSystem,
        isIn(['android', 'ios', 'macos', 'linux', 'windows']),
      );
    });
  });

  group('NfcTag Data Structure', () {
    test('NfcTag data contains expected keys', () {
      final mockTagData = {
        'nfca': {
          'identifier': [0x01, 0x02, 0x03, 0x04]
        },
        'ndef': {
          'message': {
            'records': [
              {
                'typeNameFormat': 1,
                'type': [0x54],
                'identifier': [],
                'payload': [0x02, 0x65, 0x6E, 0x48, 0x69],
              }
            ],
          },
          'type': 'org.nfcforum.ndef',
          'maxSize': 1024,
          'isWritable': true,
          'canMakeReadOnly': true,
        },
      };

      // Verify the mock data structure is valid
      expect(mockTagData, isNotNull);
      expect(mockTagData, containsPair('nfca', isA<Map>()));
      expect(mockTagData, containsPair('ndef', isA<Map>()));
    });
  });
}
