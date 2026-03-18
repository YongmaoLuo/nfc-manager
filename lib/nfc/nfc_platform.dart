/// Platform detection utilities for NFC Manager
library platform_utils;

import 'dart:io';

/// Check if running on HarmonyOS platform
bool get isHarmonyOS {
  try {
    return Platform.operatingSystem == 'ohos';
  } catch (_) {
    return false;
  }
}

/// Check if NFC is supported on current platform
bool get isNfcSupported {
  if (isHarmonyOS) return false; // Not yet supported
  try {
    return Platform.isAndroid || Platform.isIOS;
  } catch (_) {
    return false;
  }
}
