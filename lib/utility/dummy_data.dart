import 'dart:typed_data';

import 'package:app/nfc_manager_stub.dart';

final tag1 = NfcTag({
  'mifare': {
    'identifier': Uint8List.fromList([0x04,0xb8,0x01,0x42,0x89,0x5d,0x84]),
    'mifareFamily': 2,
    'historicalBytes': Uint8List(0),
  },
  'ndef': {
    'isWritable': false,
    'maxSize': 137,
    'cachedMessage': {
      'records': [{
        'typeNameFormat': 0x01,
        'type': Uint8List.fromList([0x54]),
        'identifier': Uint8List(0),
        'payload': Uint8List.fromList([0x02, ...'enHello World'.codeUnits]),
      }, {
        'typeNameFormat': 0x01,
        'type': Uint8List.fromList([0x55]),
        'identifier': Uint8List(0),
        'payload': Uint8List.fromList([0x04, ...'example.com'.codeUnits]),
      }],
    }
  }
});
