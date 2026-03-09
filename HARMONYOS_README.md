# NFC Manager - HarmonyOS Version

This document describes the HarmonyOS (OpenHarmony) adaptation of the NFC Manager Flutter app.

## What Was Created

The HarmonyOS platform support has been added to this Flutter app with the following structure:

### Directory Structure
```
ohos/
├── AppScope/              # App-level resources and configuration
│   ├── app.json5         # App configuration
│   └── resources/        # App resources (icons, strings)
├── entry/                # Main entry module
│   ├── src/
│   │   ├── main/
│   │   │   ├── ets/
│   │   │   │   ├── entryability/
│   │   │   │   │   └── EntryAbility.ets    # Main entry point (extends FlutterAbility)
│   │   │   │   ├── pages/
│   │   │   │   │   └── Index.ets           # Index page
│   │   │   │   └── plugins/
│   │   │   │       └── GeneratedPluginRegistrant.ets  # Plugin registration
│   │   │   ├── resources/  # HarmonyOS resources
│   │   │   └── module.json5  # Module configuration with NFC permissions
│   │   └── ohosTest/       # Test code
│   ├── build-profile.json5  # Build configuration
│   ├── hvigorfile.ts        # Hvigor build script
│   └── oh-package.json5     # Package dependencies
├── hvigor/                  # Hvigor build system config
├── build-profile.json5      # Project build configuration
├── hvigorconfig.ts          # Hvigor configuration
├── hvigorfile.ts            # Root Hvigor script
└── oh-package.json5         # Root package configuration
```

## Permissions Configured

The following NFC permissions have been added to `ohos/entry/src/main/module.json5`:

- `ohos.permission.INTERNET` - Network access
- `ohos.permission.NFC` - NFC hardware access
- `ohos.permission.NFC_CARD_EMULATION` - NFC card emulation (if needed)

## Key Files

### EntryAbility.ets
The main entry point extends `FlutterAbility` and is configured to:
- Initialize the Flutter engine
- Register Flutter plugins
- Handle the app lifecycle

### GeneratedPluginRegistrant.ets
Currently a placeholder file. This will be auto-generated when:
1. `flutter pub get` succeeds
2. Plugins with HarmonyOS support are added to pubspec.yaml

### module.json5
Contains module configuration including:
- Ability definitions
- Permissions
- Device types
- Page routing

## What Needs to Be Done

### 1. Flutter SDK Version Issue
The current custom Flutter SDK shows version `0.0.0-unknown` which causes dependency resolution issues. Options:
- Set `FLUTTER_GIT_URL` environment variable
- Update the Flutter fork to report a proper version
- Use dependency overrides in pubspec.yaml

### 2. nfc_manager Plugin HarmonyOS Support
The `nfc_manager` Flutter plugin currently does NOT have HarmonyOS support. You need to:

**Option A: Use a HarmonyOS-compatible NFC plugin**
- Search for alternative NFC plugins with OHOS support
- Check https://gitcode.com/openharmony-tpc for community adaptations

**Option B: Adapt the nfc_manager plugin for HarmonyOS**
- Create a fork of nfc_manager
- Add HarmonyOS platform implementation
- Follow the flutter-ohos-plugin skill documentation

**Option C: Implement NFC directly via Platform Channels**
- Create custom MethodChannel in Dart
- Implement native HarmonyOS NFC code in ArkTS
- Reference HarmonyOS NFC APIs: https://docs.openharmony.cn/pages/v5.1/zh-cn/application-dev/application-dev-guide.md/

### 3. Update Dart Code for HarmonyOS Platform
Modify `lib/view/common/nfc_session.dart` to handle HarmonyOS:

```dart
// Add after line 23 in nfc_session.dart
if (Platform.isOHOS || Platform.operatingSystem == 'ohos')
  return NfcManager.instance.startSession(
    alertMessage: alertMessage,
    onDiscovered: (tag) async {
      try {
        final result = await handleTag(tag);
        if (result == null) return;
        await NfcManager.instance.stopSession(alertMessage: result);
      } catch (e) {
        await NfcManager.instance.stopSession(errorMessage: '$e');
      }
    },
  );
```

Note: You'll need to check if `dart:io` supports `Platform.isOHOS` or use a different detection method.

### 4. Dependencies
Update `pubspec.yaml` dependencies:
- Some dependencies may need HarmonyOS-compatible versions
- Test each dependency individually
- Use `dependency_overrides` if needed

### 5. Build and Test
Once dependencies are resolved:

```bash
# Get dependencies
flutter pub get

# Build for HarmonyOS
cd nfc-manager
flutter build ohos --debug

# Or run directly
flutter run -d ohos
```

### 6. Platform-Specific NFC Implementation
If using custom Platform Channels, create the implementation in:
`ohos/entry/src/main/ets/` directory

Reference HarmonyOS NFC documentation for API usage.

## Environment Requirements

- ✓ Flutter (OpenHarmony version) - **INSTALLED**
- ✓ HarmonyOS SDK (API 20) - **INSTALLED**
- ✓ DevEco Studio - **INSTALLED**
- ✓ Ohpm (5.3.2) - **INSTALLED**
- ✓ Node.js (v18.20.1) - **INSTALLED**
- ✓ Hvigor build system - **INSTALLED**

## Next Steps

1. **Resolve dependency issues** - Fix pubspec.yaml to work with custom Flutter SDK
2. **Add NFC plugin support** - Either adapt nfc_manager or find HarmonyOS alternative
3. **Update platform detection** - Add HarmonyOS support in Dart code
4. **Build and test** - Compile and run on HarmonyOS device/emulator
5. **Implement NFC functionality** - Add platform-specific NFC code if needed

## Resources

- Flutter OHOS Documentation: `~/.config/opencode/skills/flutter-ohos-plugin/docs/`
- HarmonyOS Developer Docs: https://docs.openharmony.cn/
- Flutter OHOS Repo: https://gitcode.com/openharmony-tpc/flutter_flutter
- Community Plugins: https://gitcode.com/openharmony-tpc

## Skill Used

This HarmonyOS adaptation was created using the `flutter-ohos-plugin` skill, which is installed at:
`~/.config/opencode/skills/flutter-ohos-plugin`

The skill provides comprehensive documentation for Flutter-to-HarmonyOS adaptation in its `docs/` directory.
