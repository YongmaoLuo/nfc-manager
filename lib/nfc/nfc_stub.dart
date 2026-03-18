/// Platform abstraction for NFC functionality.
/// This file provides stub implementations for platforms not supported by nfc_manager.
library nfc_platform;

import 'dart:io';

// Export the correct implementation based on platform
export 'nfc_impl_io.dart' if (dart.library.io) 'nfc_impl_io.dart';

/// Check if NFC is available on the current platform
bool isNfcAvailable() {
  try {
    return Platform.isAndroid || Platform.isIOS;
  } catch (_) {
    return false;
  }
}

/// Check if running on HarmonyOS
bool isHarmonyOS() {
  try {
    return Platform.operatingSystem == 'ohos';
  } catch (_) {
    return false;
  }
}
