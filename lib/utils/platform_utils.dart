import 'dart:io';

import 'package:flutter/foundation.dart';

/// Platform detection utilities for HarmonyOS support
class PlatformUtils {
  /// Check if running on HarmonyOS (OpenHarmony)
  /// Uses Flutter's target platform detection instead of dart:io Platform
  /// because Platform.isOhos doesn't exist and causes build failures
  static bool get isOHOS {
    return defaultTargetPlatform == TargetPlatform.ohos;
  }

  /// Check if NFC is available on current platform
  static bool get isNfcAvailable {
    // NFC is available on Android, iOS, and potentially OHOS
    // For now, OHOS doesn't have nfc_manager plugin support
    return Platform.isAndroid || Platform.isIOS;
  }
}
