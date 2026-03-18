/// NFC compatibility layer for cross-platform support.
/// Provides a unified API that works across Android, iOS, and HarmonyOS.
library nfc_compat;

import 'dart:io';
import 'dart:typed_data';

// Type definitions for NFC compatibility
/// NDEF Record representation
class NdefRecord {
  final int tnf;
  final Uint8List? type;
  final Uint8List? id;
  final Uint8List? payload;

  NdefRecord({
    required this.tnf,
    this.type,
    this.id,
    this.payload,
  });
}

/// NDEF Message containing multiple records
class NdefMessage {
  final List<NdefRecord> records;

  NdefMessage(this.records);
}

/// NDEF Type Name Format constants
class NdefTypeNameFormat {
  static const int empty = 0x0;
  static const int wellKnown = 0x1;
  static const int media = 0x2;
  static const int absoluteUri = 0x3;
  static const int external = 0x4;
  static const int unknown = 0x5;
  static const int unchanged = 0x6;
}

/// NFC Tag representation
class NfcTag {
  final Map<String, dynamic> data;
  NfcTag(this.data);
}

// Platform detection
bool get _isOhos {
  try {
    return Platform.operatingSystem == 'ohos';
  } catch (_) {
    return false;
  }
}

/// Check if NFC is available on this platform
Future<bool> isNfcAvailable() async {
  if (_isOhos) {
    // HarmonyOS NFC not yet implemented in this compatibility layer
    return false;
  }
  // For Android/iOS, we need to use the actual nfc_manager
  // This is handled by the platform-specific implementation
  return true;
}

/// Exception thrown when NFC is not supported
class NfcNotSupportedException implements Exception {
  final String message;
  NfcNotSupportedException([this.message = 'NFC is not supported on this platform']);

  @override
  String toString() => 'NfcNotSupportedException: $message';
}
