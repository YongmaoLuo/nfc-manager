/**
 * NFC Manager Plugin for HarmonyOS
 * 
 * This plugin implements the nfc_manager Flutter plugin interface
 * for HarmonyOS (OpenHarmony) platform.
 * 
 * MethodChannel: plugins.flutter.io/nfc_manager
 * 
 * Supported methods:
 * - Nfc#isAvailable: Check if NFC is available and enabled
 * - Nfc#startSession: Start NFC reader mode
 * - Nfc#stopSession: Stop NFC reader mode
 * - Nfc#disposeTag: Dispose tag handle
 * - Ndef#read: Read NDEF message from tag
 * - Ndef#write: Write NDEF message to tag
 * - Ndef#writeLock: Make tag read-only
 */

import { FlutterPlugin, FlutterPluginBinding } from '@ohos/flutter_ohos/src/main/ets/embedding/engine/plugins/FlutterPlugin';
import MethodChannel, { MethodCallHandler, MethodResult } from '@ohos/flutter_ohos/src/main/ets/plugin/common/MethodChannel';
import MethodCall from '@ohos/flutter_ohos/src/main/ets/plugin/common/MethodCall';
import EventChannel from '@ohos/flutter_ohos/src/main/ets/plugin/common/EventChannel';
import { BinaryMessenger } from '@ohos/flutter_ohos/src/main/ets/plugin/common/BinaryMessenger';
import { Log } from '@ohos/flutter_ohos/src/main/ets/util/Log';
import common from '@ohos.app.ability.common';
import tag from '@ohos.nfc.tag';
import nfcController from '@ohos.nfc.controller';

const TAG = "NfcManagerPlugin";
const CHANNEL_NAME = "plugins.flutter.io/nfc_manager";

// UUID generator for tag handles
function generateUUID(): string {
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
    const r = Math.random() * 16 | 0;
    const v = c === 'x' ? r : (r & 0x3 | 0x8);
    return v.toString(16);
  });
}

export default class NfcManagerPlugin implements FlutterPlugin, MethodCallHandler {
  private channel: MethodChannel | null = null;
  private context: common.Context | null = null;
  private cachedTags: Map<string, tag.TagInfo> = new Map();
  private cachedNdef: Map<string, tag.Ndef> = new Map();
  private isReaderModeEnabled: boolean = false;
  private tagDiscoveryCallback: ((tagInfo: tag.TagInfo) => void) | null = null;

  getUniqueClassName(): string {
    return "NfcManagerPlugin";
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.context = binding.getApplicationContext();
    this.channel = new MethodChannel(binding.getBinaryMessenger(), CHANNEL_NAME);
    this.channel.setMethodCallHandler(this);
    Log.i(TAG, "NfcManagerPlugin attached to engine");
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    this.channel?.setMethodCallHandler(null);
    this.channel = null;
    this.stopReaderMode();
    Log.i(TAG, "NfcManagerPlugin detached from engine");
  }

  onMethodCall(call: MethodCall, result: MethodResult): void {
    Log.i(TAG, `Method called: ${call.method}`);

    switch (call.method) {
      case "Nfc#isAvailable":
        this.handleIsAvailable(result);
        break;
      case "Nfc#startSession":
        this.handleStartSession(call, result);
        break;
      case "Nfc#stopSession":
        this.handleStopSession(result);
        break;
      case "Nfc#disposeTag":
        this.handleDisposeTag(call, result);
        break;
      case "Ndef#read":
        this.handleNdefRead(call, result);
        break;
      case "Ndef#write":
        this.handleNdefWrite(call, result);
        break;
      case "Ndef#writeLock":
        this.handleNdefWriteLock(call, result);
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  /**
   * Check if NFC is available and enabled
   */
  private handleIsAvailable(result: MethodResult): void {
    try {
      // Check if NFC feature is supported
      const isSupported = nfcController.hasNfcFeature();
      if (!isSupported) {
        Log.w(TAG, "NFC feature not supported");
        result.success(false);
        return;
      }

      // Check if NFC is enabled
      const isOpen = nfcController.isNfcOpen();
      Log.i(TAG, `NFC available: ${isOpen}`);
      result.success(isOpen);
    } catch (e) {
      Log.e(TAG, `Error checking NFC availability: ${e}`);
      result.success(false);
    }
  }

  /**
   * Start NFC reader session
   */
  private handleStartSession(call: MethodCall, result: MethodResult): void {
    try {
      if (this.isReaderModeEnabled) {
        Log.w(TAG, "Reader mode already enabled");
        result.success(null);
        return;
      }

      // Get polling options
      const pollingOptions = call.argument<Array<string>>("pollingOptions") || [];
      Log.i(TAG, `Starting NFC session with options: ${pollingOptions.join(", ")}`);

      // Register for tag discovery using foreground dispatch
      this.tagDiscoveryCallback = (tagInfo: tag.TagInfo) => {
        this.onTagDiscovered(tagInfo);
      };

      // Use tag.on for foreground tag discovery
      tag.on('tag', this.tagDiscoveryCallback);
      this.isReaderModeEnabled = true;

      Log.i(TAG, "NFC reader mode started");
      result.success(null);
    } catch (e) {
      Log.e(TAG, `Error starting NFC session: ${e}`);
      result.error("nfc_error", `Failed to start NFC session: ${e}`, null);
    }
  }

  /**
   * Stop NFC reader session
   */
  private handleStopSession(result: MethodResult): void {
    try {
      this.stopReaderMode();
      Log.i(TAG, "NFC reader mode stopped");
      result.success(null);
    } catch (e) {
      Log.e(TAG, `Error stopping NFC session: ${e}`);
      result.error("nfc_error", `Failed to stop NFC session: ${e}`, null);
    }
  }

  /**
   * Stop reader mode and cleanup
   */
  private stopReaderMode(): void {
    if (this.tagDiscoveryCallback) {
      tag.off('tag', this.tagDiscoveryCallback);
      this.tagDiscoveryCallback = null;
    }
    this.isReaderModeEnabled = false;
  }

  /**
   * Handle tag discovery callback
   */
  private onTagDiscovered(tagInfo: tag.TagInfo): void {
    try {
      Log.i(TAG, `Tag discovered: ${JSON.stringify(tagInfo)}`);

      // Generate unique handle for this tag
      const handle = generateUUID();
      
      // Cache the tag
      this.cachedTags.set(handle, tagInfo);

      // Try to get NDEF technology
      const ndef = tag.getNdef(tagInfo);
      if (ndef) {
        this.cachedNdef.set(handle, ndef);
        Log.i(TAG, "NDEF technology available for this tag");
      }

      // Build tag data map to send to Flutter
      const tagData = this.buildTagData(tagInfo, handle);

      // Send tag discovered event to Flutter
      this.channel?.invokeMethod("onDiscovered", tagData);
    } catch (e) {
      Log.e(TAG, `Error handling tag discovery: ${e}`);
    }
  }

  /**
   * Build tag data map for Flutter
   */
  private buildTagData(tagInfo: tag.TagInfo, handle: string): Record<string, Object> {
    const data: Record<string, Object> = {
      "handle": handle,
      "supported Technologies": tagInfo.supportedTechs || [],
    };

    // Add NDEF-specific data if available
    const ndef = this.cachedNdef.get(handle);
    if (ndef) {
      try {
        data["ndef"] = {
          "type": ndef.getTagType ? ndef.getTagType() : "unknown",
          "maxSize": ndef.getMaxTransceiveLength ? ndef.getMaxTransceiveLength() : 0,
          "isWritable": ndef.isNdefWritable ? ndef.isNdefWritable() : false,
        };
      } catch (e) {
        Log.w(TAG, `Error getting NDEF info: ${e}`);
      }
    }

    return data;
  }

  /**
   * Dispose tag handle
   */
  private handleDisposeTag(call: MethodCall, result: MethodResult): void {
    try {
      const handle = call.argument<string>("handle");
      if (!handle) {
        result.success(null);
        return;
      }

      // Remove from caches
      this.cachedTags.delete(handle);
      this.cachedNdef.delete(handle);

      Log.i(TAG, `Tag disposed: ${handle}`);
      result.success(null);
    } catch (e) {
      Log.e(TAG, `Error disposing tag: ${e}`);
      result.success(null);
    }
  }

  /**
   * Read NDEF message from tag
   */
  private handleNdefRead(call: MethodCall, result: MethodResult): void {
    try {
      const handle = call.argument<string>("handle");
      if (!handle) {
        result.error("invalid_parameter", "Tag handle is required", null);
        return;
      }

      const ndef = this.cachedNdef.get(handle);
      if (!ndef) {
        result.error("invalid_parameter", "NDEF technology not available for this tag", null);
        return;
      }

      // Connect to tag
      ndef.connect();

      // Read NDEF message
      const ndefMessage = ndef.getNdefMessage();
      
      // Disconnect
      ndef.disconnect();

      if (!ndefMessage) {
        Log.i(TAG, "No NDEF message on tag");
        result.success(null);
        return;
      }

      // Convert to map for Flutter
      const messageMap = this.ndefMessageToMap(ndefMessage);
      Log.i(TAG, `NDEF message read: ${messageMap.records?.length || 0} records`);
      result.success(messageMap);
    } catch (e) {
      Log.e(TAG, `Error reading NDEF: ${e}`);
      result.error("io_exception", `Failed to read NDEF: ${e}`, null);
    }
  }

  /**
   * Write NDEF message to tag
   */
  private handleNdefWrite(call: MethodCall, result: MethodResult): void {
    try {
      const handle = call.argument<string>("handle");
      const messageMap = call.argument<Record<string, Object>>("message");

      if (!handle || !messageMap) {
        result.error("invalid_parameter", "Tag handle and message are required", null);
        return;
      }

      const ndef = this.cachedNdef.get(handle);
      if (!ndef) {
        result.error("invalid_parameter", "NDEF technology not available for this tag", null);
        return;
      }

      // Convert map to NDEF message
      const ndefMessage = this.mapToNdefMessage(messageMap);
      if (!ndefMessage) {
        result.error("invalid_parameter", "Invalid NDEF message format", null);
        return;
      }

      // Connect and write
      ndef.connect();
      ndef.writeNdefMessage(ndefMessage);
      ndef.disconnect();

      Log.i(TAG, "NDEF message written successfully");
      result.success(null);
    } catch (e) {
      Log.e(TAG, `Error writing NDEF: ${e}`);
      result.error("io_exception", `Failed to write NDEF: ${e}`, null);
    }
  }

  /**
   * Make tag read-only (write lock)
   */
  private handleNdefWriteLock(call: MethodCall, result: MethodResult): void {
    try {
      const handle = call.argument<string>("handle");
      if (!handle) {
        result.error("invalid_parameter", "Tag handle is required", null);
        return;
      }

      const ndef = this.cachedNdef.get(handle);
      if (!ndef) {
        result.error("invalid_parameter", "NDEF technology not available for this tag", null);
        return;
      }

      // Connect and make read-only
      ndef.connect();
      ndef.makeReadOnly();
      ndef.disconnect();

      Log.i(TAG, "Tag made read-only");
      result.success(null);
    } catch (e) {
      Log.e(TAG, `Error making tag read-only: ${e}`);
      result.error("io_exception", `Failed to make tag read-only: ${e}`, null);
    }
  }

  /**
   * Convert NDEF message to map for Flutter
   */
  private ndefMessageToMap(message: tag.NdefMessage): Record<string, Object> {
    const records: Object[] = [];
    
    // Get records from message
    const ndefRecords = message.getNdefRecords();
    if (ndefRecords) {
      for (const record of ndefRecords) {
        records.push({
          "tnf": record.tnf,
          "type": Array.from(record.type || []),
          "id": Array.from(record.id || []),
          "payload": Array.from(record.payload || []),
        });
      }
    }

    return { "records": records };
  }

  /**
   * Convert map to NDEF message
   */
  private mapToNdefMessage(map: Record<string, Object>): tag.NdefMessage | null {
    try {
      const records = map["records"] as Array<Object>;
      if (!records || records.length === 0) {
        return null;
      }

      // Create NDEF records
      const ndefRecords: tag.NdefRecord[] = [];
      for (const recordMap of records) {
        const r = recordMap as Record<string, Object>;
        const ndefRecord: tag.NdefRecord = {
          tnf: r["tnf"] as number,
          type: new Uint8Array(r["type"] as Array<number>),
          id: new Uint8Array(r["id"] as Array<number>),
          payload: new Uint8Array(r["payload"] as Array<number>),
        };
        ndefRecords.push(ndefRecord);
      }

      // Create NDEF message
      return tag.createNdefMessage(ndefRecords);
    } catch (e) {
      Log.e(TAG, `Error creating NDEF message: ${e}`);
      return null;
    }
  }
}
