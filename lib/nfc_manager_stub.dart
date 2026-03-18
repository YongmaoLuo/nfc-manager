/// Stub implementation of nfc_manager for platforms not supported by the original package.
/// This file provides empty implementations to allow compilation on HarmonyOS.
library nfc_manager_stub;

import 'dart:typed_data';
import 'dart:async';

// ============ Core Types ============

/// NDEF Type Name Format enum
enum NdefTypeNameFormat {
  empty,
  nfcWellknown,
  media,
  absoluteUri,
  nfcExternal,
  unknown,
  unchanged,
}

/// Represents an NDEF record
class NdefRecord {
  final NdefTypeNameFormat typeNameFormat;
  final Uint8List type;
  final Uint8List identifier;
  final Uint8List payload;

  const NdefRecord({
    required this.typeNameFormat,
    required this.type,
    required this.identifier,
    required this.payload,
  });

  /// URI prefix list for URI records
  static const List<String> URI_PREFIX_LIST = [
    '', 'http://www.', 'https://www.', 'http://', 'https://',
    'tel:', 'mailto:', 'ftp://anonymous:anonymous@', 'ftp://ftp.',
    'ftps://', 'sftp://', 'smb://', 'nfs://', 'ftp://', 'dav://',
    'news:', 'telnet://', 'imap:', 'rtsp://', 'urn:', 'pop:',
    'sip:', 'sips:', 'tftp:', 'btspp://', 'btl2cap://', 'tcp://',
    'tcpoob://', 'hcp://', 'hcp://', 'hcp://', 'https://',
  ];

  int get byteLength => 3 + type.length + identifier.length + payload.length;
}

/// Represents an NDEF message
class NdefMessage {
  final List<NdefRecord> records;

  const NdefMessage(this.records);

  int get byteLength => records.fold(0, (sum, r) => sum + r.byteLength);
}

// ============ NFC Manager ============

/// NFC Manager singleton for checking availability and starting sessions
class NfcManager {
  NfcManager._();

  static final NfcManager instance = NfcManager._();

  /// Check if NFC is available
  Future<bool> isAvailable() async => false;

  /// Start an NFC session (Android style)
  Future<void> startSession({
    void Function(NfcTag)? onDiscovered,
    // iOS style parameters
    String? alertMessage,
    bool invalidateAfterFirstRead = false,
  }) async {
    throw UnsupportedError('NFC is not supported on this platform');
  }

  /// Stop the NFC session
  Future<void> stopSession({
    String? alertMessage,
    String? errorMessage,
  }) async {}
}

/// Represents an NFC tag
class NfcTag {
  final Map<String, dynamic> data;

  NfcTag(this.data);
}

// ============ Platform-specific Tag Types (Stubs) ============

// Android tag types
class NfcA {
  final Uint8List identifier;
  final Uint8List atqa;
  final int sak;
  final int maxTransceiveLength;
  final int timeout;

  NfcA({
    required this.identifier,
    required this.atqa,
    required this.sak,
    required this.maxTransceiveLength,
    required this.timeout,
  });

  static NfcA? from(NfcTag tag) => null;

  Future<Uint8List> transceive(Uint8List data) async {
    throw UnsupportedError('NFC is not supported on this platform');
  }
}

class NfcB {
  final Uint8List identifier;
  final Uint8List applicationData;
  final Uint8List protocolInfo;
  final int maxTransceiveLength;
  final int timeout;

  NfcB({
    required this.identifier,
    required this.applicationData,
    required this.protocolInfo,
    required this.maxTransceiveLength,
    required this.timeout,
  });

  static NfcB? from(NfcTag tag) => null;

  Future<Uint8List> transceive(Uint8List data) async {
    throw UnsupportedError('NFC is not supported on this platform');
  }
}

class NfcF {
  final Uint8List identifier;
  final Uint8List systemCode;
  final Uint8List manufacturer;
  final int maxTransceiveLength;
  final int timeout;

  NfcF({
    required this.identifier,
    required this.systemCode,
    required this.manufacturer,
    required this.maxTransceiveLength,
    required this.timeout,
  });

  static NfcF? from(NfcTag tag) => null;

  Future<Uint8List> transceive(Uint8List data) async {
    throw UnsupportedError('NFC is not supported on this platform');
  }
}

class NfcV {
  final Uint8List identifier;
  final int dsfId;
  final int responseFlags;
  final int maxTransceiveLength;

  NfcV({
    required this.identifier,
    required this.dsfId,
    required this.responseFlags,
    required this.maxTransceiveLength,
  });

  static NfcV? from(NfcTag tag) => null;

  Future<Uint8List> transceive(Uint8List data) async {
    throw UnsupportedError('NFC is not supported on this platform');
  }
}

class IsoDep {
  final Uint8List identifier;
  final Uint8List hiLayerResponse;
  final Uint8List historicalBytes;
  final bool isExtendedLengthApduSupported;
  final int maxTransceiveLength;
  final int timeout;

  IsoDep({
    required this.identifier,
    required this.hiLayerResponse,
    required this.historicalBytes,
    required this.isExtendedLengthApduSupported,
    required this.maxTransceiveLength,
    required this.timeout,
  });

  static IsoDep? from(NfcTag tag) => null;

  Future<Uint8List> transceive(Uint8List data) async {
    throw UnsupportedError('NFC is not supported on this platform');
  }
}

class MifareClassic {
  final Uint8List identifier;
  final int maxTransceiveLength;
  final int timeout;
  final int size;
  final int sectorCount;
  final int blockCount;
  final int type;

  MifareClassic({
    required this.identifier,
    required this.maxTransceiveLength,
    required this.timeout,
    required this.size,
    required this.sectorCount,
    required this.blockCount,
    required this.type,
  });

  static MifareClassic? from(NfcTag tag) => null;

  // Mifare Classic types
  static const int TYPE_UNKNOWN = 0;
  static const int TYPE_CLASSIC = 1;
  static const int TYPE_PLUS = 2;
  static const int TYPE_PRO = 3;

  Future<bool> authenticateSectorWithKeyA(int sectorIndex, Uint8List key) async {
    throw UnsupportedError('NFC is not supported on this platform');
  }

  Future<bool> authenticateSectorWithKeyB(int sectorIndex, Uint8List key) async {
    throw UnsupportedError('NFC is not supported on this platform');
  }

  Future<Uint8List> readBlock(int blockIndex) async {
    throw UnsupportedError('NFC is not supported on this platform');
  }

  Future<void> writeBlock(int blockIndex, Uint8List data) async {
    throw UnsupportedError('NFC is not supported on this platform');
  }

  Future<Uint8List> transceive(Uint8List data) async {
    throw UnsupportedError('NFC is not supported on this platform');
  }

  static final Uint8List KEY_DEFAULT = Uint8List.fromList([0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF]);
  static final Uint8List KEY_MIFARE_APPLICATION_DIRECTORY = Uint8List.fromList([0xA0, 0xA1, 0xA2, 0xA3, 0xA4, 0xA5]);
  static final Uint8List KEY_NFC_FORUM = Uint8List.fromList([0xD3, 0xF7, 0xD3, 0xF7, 0xD3, 0xF7]);
}

class MifareUltralight {
  final Uint8List identifier;
  final int maxTransceiveLength;
  final int timeout;
  final int type;

  MifareUltralight({
    required this.identifier,
    required this.maxTransceiveLength,
    required this.timeout,
    required this.type,
  });

  static MifareUltralight? from(NfcTag tag) => null;

  // Mifare Ultralight types
  static const int TYPE_UNKNOWN = 0;
  static const int TYPE_ULTRALIGHT = 1;
  static const int TYPE_ULTRALIGHT_C = 2;

  Future<Uint8List> readPages(int pageOffset) async {
    throw UnsupportedError('NFC is not supported on this platform');
  }

  Future<void> writePage(int pageOffset, Uint8List data) async {
    throw UnsupportedError('NFC is not supported on this platform');
  }

  Future<Uint8List> transceive(Uint8List data) async {
    throw UnsupportedError('NFC is not supported on this platform');
  }
}

class Ndef {
  final Uint8List identifier;
  final NdefMessage? cachedMessage;
  final int maxSize;
  final bool isWritable;
  final Map<String, dynamic> additionalData;

  Ndef({
    required this.identifier,
    this.cachedMessage,
    required this.maxSize,
    required this.isWritable,
    Map<String, dynamic>? additionalData,
  }) : additionalData = additionalData ?? {};

  static Ndef? from(NfcTag tag) => null;

  // NFC Forum types
  static const int NFC_FORUM_TYPE_1 = 1;
  static const int NFC_FORUM_TYPE_2 = 2;
  static const int NFC_FORUM_TYPE_3 = 3;
  static const int NFC_FORUM_TYPE_4 = 4;
  static const int MIFARE_CLASSIC = 101;

  Future<NdefMessage?> read() async {
    throw UnsupportedError('NFC is not supported on this platform');
  }

  Future<void> write(NdefMessage message) async {
    throw UnsupportedError('NFC is not supported on this platform');
  }

  Future<void> writeLock() async {
    throw UnsupportedError('NFC is not supported on this platform');
  }

  Future<bool> makeReadOnly() async {
    throw UnsupportedError('NFC is not supported on this platform');
  }
}

class NdefFormatable {
  final Uint8List identifier;

  NdefFormatable({required this.identifier});

  static NdefFormatable? from(NfcTag tag) => null;

  Future<void> format(NdefMessage message) async {
    throw UnsupportedError('NFC is not supported on this platform');
  }

  Future<void> formatReadOnly(NdefMessage message) async {
    throw UnsupportedError('NFC is not supported on this platform');
  }
}

// iOS tag types
class FeliCa {
  final Uint8List identifier;
  final Uint8List currentSystemCode;
  final Uint8List currentIDm;

  FeliCa({
    required this.identifier,
    required this.currentSystemCode,
    required this.currentIDm,
  });

  static FeliCa? from(NfcTag tag) => null;

  Future<Uint8List> sendFeliCaCommand(Uint8List data) async {
    throw UnsupportedError('NFC is not supported on this platform');
  }

  Future<FeliCaPollingResponse> polling({
    required Uint8List systemCode,
    required FeliCaPollingRequestCode requestCode,
    required FeliCaPollingTimeSlot timeSlot,
  }) async {
    throw UnsupportedError('NFC is not supported on this platform');
  }
}

class FeliCaPollingResponse {
  final Uint8List manufacturerParameter;
  final Uint8List? requestData;

  FeliCaPollingResponse({required this.manufacturerParameter, this.requestData});
}

class Iso15693 {
  final Uint8List identifier;
  final Uint8List icSerialNumber;
  final int icManufacturerCode;
  final int maxTransceiveLength;

  Iso15693({
    required this.identifier,
    required this.icSerialNumber,
    required this.icManufacturerCode,
    required this.maxTransceiveLength,
  });

  static Iso15693? from(NfcTag tag) => null;

  Future<Uint8List> sendCommand(Iso15693Command command) async {
    throw UnsupportedError('NFC is not supported on this platform');
  }
}

class Iso15693Command {
  final int flags;
  final int commandCode;
  final Uint8List? manufacturerCode;
  final Uint8List? identifier;
  final Uint8List? data;
  final int? extension;

  Iso15693Command({
    required this.flags,
    required this.commandCode,
    this.manufacturerCode,
    this.identifier,
    this.data,
    this.extension,
  });
}

class Iso7816 {
  final Uint8List identifier;
  final Uint8List historicalBytes;
  final Uint8List applicationData;
  final String initialSelectedAID;
  final bool proprietaryApplicationDataCoding;

  Iso7816({
    required this.identifier,
    required this.historicalBytes,
    required this.applicationData,
    required this.initialSelectedAID,
    required this.proprietaryApplicationDataCoding,
  });

  static Iso7816? from(NfcTag tag) => null;

  Future<Uint8List> sendCommand(Iso7816ApduCommand command) async {
    throw UnsupportedError('NFC is not supported on this platform');
  }
}

class Iso7816ApduCommand {
  final int cla;
  final int ins;
  final int p1;
  final int p2;
  final Uint8List? dataIn;
  final int? le;

  Iso7816ApduCommand({
    required this.cla,
    required this.ins,
    required this.p1,
    required this.p2,
    this.dataIn,
    this.le,
  });
}

class MiFare {
  final Uint8List identifier;
  final Uint8List historicalBytes;
  final MiFareFamily mifareFamily;

  MiFare({
    required this.identifier,
    required this.historicalBytes,
    required this.mifareFamily,
  });

  static MiFare? from(NfcTag tag) => null;

  Future<Uint8List> sendMiFareCommand(Uint8List data) async {
    throw UnsupportedError('NFC is not supported on this platform');
  }
}

// iOS FeliCa polling types
enum FeliCaPollingRequestCode {
  noRequest,
  systemCode,
  communicationPerformance,
}

enum FeliCaPollingTimeSlot {
  max1,
  max2,
  max4,
  max8,
  max16,
}

// MiFare family enum (iOS)
enum MiFareFamily {
  unknown,
  ultralight,
  plus,
  desfire,
}
