import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:nfc_manager/nfc_manager.dart';

void main() {
  group('NdefRecord', () {
    test('creates wellknown text record', () {
      final record = NdefRecord(
        typeNameFormat: NdefTypeNameFormat.nfcWellknown,
        type: Uint8List.fromList([0x54]), // 'T' for Text
        identifier: Uint8List(0),
        payload: Uint8List.fromList(
            [0x02, 0x65, 0x6E, 0x48, 0x65, 0x6C, 0x6C, 0x6F]), // en + "Hello"
      );

      expect(record.typeNameFormat, equals(NdefTypeNameFormat.nfcWellknown));
      expect(record.type.first, equals(0x54));
    });

    test('creates wellknown URI record', () {
      final record = NdefRecord(
        typeNameFormat: NdefTypeNameFormat.nfcWellknown,
        type: Uint8List.fromList([0x55]), // 'U' for URI
        identifier: Uint8List(0),
        payload: Uint8List.fromList(
            [0x01, ...'https://'.codeUnits]), // https:// prefix
      );

      expect(record.typeNameFormat, equals(NdefTypeNameFormat.nfcWellknown));
      expect(record.type.first, equals(0x55));
    });

    test('creates MIME type record', () {
      final record = NdefRecord(
        typeNameFormat: NdefTypeNameFormat.media,
        type: Uint8List.fromList('text/plain'.codeUnits),
        identifier: Uint8List(0),
        payload: Uint8List.fromList('Hello World'.codeUnits),
      );

      expect(record.typeNameFormat, equals(NdefTypeNameFormat.media));
    });

    test('creates absolute URI record', () {
      final record = NdefRecord(
        typeNameFormat: NdefTypeNameFormat.absoluteUri,
        type: Uint8List.fromList('https://example.com/path'.codeUnits),
        identifier: Uint8List(0),
        payload: Uint8List(0),
      );

      expect(record.typeNameFormat, equals(NdefTypeNameFormat.absoluteUri));
    });

    test('creates external type record', () {
      final record = NdefRecord(
        typeNameFormat: NdefTypeNameFormat.nfcExternal,
        type: Uint8List.fromList('com.example:custom'.codeUnits),
        identifier: Uint8List(0),
        payload: Uint8List.fromList([0x01, 0x02, 0x03]),
      );

      expect(record.typeNameFormat, equals(NdefTypeNameFormat.nfcExternal));
    });
  });

  group('NdefMessage', () {
    test('creates message with single record', () {
      final record = NdefRecord(
        typeNameFormat: NdefTypeNameFormat.nfcWellknown,
        type: Uint8List.fromList([0x54]),
        identifier: Uint8List(0),
        payload: Uint8List.fromList([0x02, 0x65, 0x6E, 0x48, 0x69]),
      );

      final message = NdefMessage([record]);

      expect(message.records.length, equals(1));
      expect(message.records.first.typeNameFormat,
          equals(NdefTypeNameFormat.nfcWellknown));
    });

    test('creates message with multiple records', () {
      final records = [
        NdefRecord(
          typeNameFormat: NdefTypeNameFormat.nfcWellknown,
          type: Uint8List.fromList([0x54]),
          identifier: Uint8List(0),
          payload: Uint8List.fromList([0x02, 0x65, 0x6E, 0x48, 0x69]),
        ),
        NdefRecord(
          typeNameFormat: NdefTypeNameFormat.nfcWellknown,
          type: Uint8List.fromList([0x55]),
          identifier: Uint8List(0),
          payload: Uint8List.fromList([0x01, ...'https://'.codeUnits]),
        ),
      ];

      final message = NdefMessage(records);

      expect(message.records.length, equals(2));
    });
  });
}
