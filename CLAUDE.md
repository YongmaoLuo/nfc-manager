# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

NFC Manager is a cross-platform NFC application with two implementations:
- **Flutter app** (Android/iOS) - original implementation using `nfc_manager` plugin
- **HarmonyOS app** (`ohos/`) - port using ArkTS and HarmonyOS NFC APIs

## Build Commands

### Flutter (Android/iOS)
```bash
# Get dependencies
flutter pub get

# Run on connected device
flutter run

# Build APK (Android)
flutter build apk

# Build for iOS (requires macOS)
flutter build ios
```

### HarmonyOS
```bash
# Build using hvigor (from ohos directory)
cd ohos && hvigorw assembleHap

# Clean build
cd ohos && hvigorw clean
```

## Architecture

### Flutter App Structure
```
lib/
├── main.dart                 # App entry point
├── view/
│   ├── app.dart              # Main app widget with dependency injection
│   ├── common/
│   │   ├── form_row.dart     # Reusable form UI components
│   │   └── nfc_session.dart  # NFC session handling (platform-specific)
│   ├── tag_read.dart         # Tag reading functionality
│   ├── ndef_write.dart       # NDEF record writing
│   ├── ndef_write_lock.dart  # Write lock functionality
│   └── ndef_format.dart      # NDEF formatting (Android only)
├── model/
│   ├── record.dart           # NDEF record types (Text, URI, MIME, External, etc.)
│   └── write_record.dart     # Write record model for persistence
└── repository/
    ├── repository.dart       # Abstract repository + SubscriptionManager
    ├── repository_impl.dart  # SQLite-backed implementation
    └── database.dart         # Database schema and migrations
```

### HarmonyOS App Structure
```
ohos/entry/src/main/ets/
├── entryability/
│   └── EntryAbility.ets      # App entry point
├── pages/
│   ├── NFCPage.ets           # NFC scanning UI
│   └── SettingsPage.ets      # Settings UI
├── services/
│   ├── NFCService.ets        # NFC singleton service
│   └── NetworkService.ets    # Network utilities
├── models/
│   └── DataModels.ets        # Data interfaces and models
└── utils/
    ├── Logger.ets            # Logging utilities
    ├── PreferencesManager.ets # User preferences
    └── StringUtils.ets       # String utilities
```

## Key Patterns

### State Management
- **Flutter**: Uses `provider` package with `ChangeNotifier` pattern
- **HarmonyOS**: Uses ArkTS `@State` decorators for reactive UI

### Dependency Injection
- Flutter app uses `App.withDependency()` factory method that creates `Repository` and provides it via `MultiProvider`
- Pages use static `withDependency()` methods to wrap widgets with required providers

### NFC Session Handling
- Platform-specific implementations in `nfc_session.dart`:
  - Android: Shows dialog during scan session
  - iOS: Uses native NFC reader session with alert messages
- Always check `NfcManager.instance.isAvailable()` before starting sessions

### Repository Pattern
- Abstract `Repository` class with `createInstance()` factory
- `RepositoryImpl` uses SQLite (`sqflite`) for persistence
- `RepositoryImplDemo` provides in-memory demo mode
- `SubscriptionManager` provides reactive data streams

### NDEF Record Types
The `Record` abstract class in `lib/model/record.dart` supports:
- `WellknownTextRecord` - Text with language code
- `WellknownUriRecord` - URI with prefix compression
- `MimeRecord` - MIME-typed data
- `AbsoluteUriRecord` - Absolute URI type
- `ExternalRecord` - NFC External type with domain:type
- `UnsupportedRecord` - Fallback for unknown types

## Platform Differences

- **NDEF Format**: Only available on Android (conditionally rendered in UI)
- **Tag Types**: Android supports NfcA/B/F/V, Mifare, IsoDep; iOS supports FeliCa, Iso15693, Iso7816, MiFare
- **HarmonyOS**: Uses `@ohos.nfc` and `@ohos.nfc.tag` APIs with similar tag detection callbacks

## HarmonyOS Permissions
Required permissions in `ohos/entry/src/main/module.json5`:
- `ohos.permission.NFC_TAG`
- `ohos.permission.NFC_BASIC_TAG`
- `ohos.permission.NFC_CARD_EMULATION`
- `ohos.permission.GET_NETWORK_INFO`
- `ohos.permission.INTERNET`
