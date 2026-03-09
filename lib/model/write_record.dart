import 'dart:typed_data';

import 'package:nfc_manager/nfc_manager.dart';

class WriteRecord {
  WriteRecord({this.id, required this.record});

  static const ID = 'id';
  static const TYPE_NAME_FORMAT = 'typeNameFormat';
  static const TYPE = 'type';
  static const IDENTIFIER = 'identifier';
  static const PAYLOAD = 'payload';

  final int? id;
  final NdefRecord record;

  WriteRecord copyWith({
    int? id,
    NdefRecord? record,
  }) {
    return WriteRecord(
      id: id ?? this.id,
      record: record ?? this.record,
    );
  }

  factory WriteRecord.fromJson(Map<String, dynamic> json) {
    return WriteRecord(
      id: json[ID],
      record: NdefRecord(
        typeNameFormat: NdefTypeNameFormat.values[json[TYPE_NAME_FORMAT]],
        type: json[TYPE] as Uint8List,
        identifier: json[IDENTIFIER] as Uint8List,
        payload: json[PAYLOAD] as Uint8List,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ID: id,
      TYPE_NAME_FORMAT: record.typeNameFormat.index,
      TYPE: record.type,
      IDENTIFIER: record.identifier,
      PAYLOAD: record.payload,
    };
  }
}
