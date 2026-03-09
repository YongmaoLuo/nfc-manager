import { FlutterAbility, FlutterEngine } from '@ohos/flutter_ohos';
import { GeneratedPluginRegistrant } from '../plugins/GeneratedPluginRegistrant';
import { tag } from '@kit.ConnectivityKit';
import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { bundleManager } from '@kit.AbilityKit';
import { Log } from '@ohos/flutter_ohos/src/main/ets/util/Log';

const TAG = "EntryAbility";

export default class EntryAbility extends FlutterAbility {
  private nfcTagElementName?: bundleManager.ElementName;
  private foregroundRegister: boolean = false;

  configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    GeneratedPluginRegistrant.registerWith(flutterEngine)
  }

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    super.onCreate(want, launchParam);
    
    // Check NFC capability
    if (!canIUse("SystemCapability.Communication.NFC.Core")) {
      Log.w(TAG, "NFC not supported on this device");
      return;
    }

    // Initialize element name for NFC foreground dispatch
    this.nfcTagElementName = {
      bundleName: want.bundleName ?? '',
      abilityName: want.abilityName ?? '',
      moduleName: want.moduleName,
    }
    
    Log.i(TAG, "EntryAbility created with NFC support");
  }

  onForeground(): void {
    super.onForeground();
    
    // Register for foreground NFC reading
    if (this.nfcTagElementName) {
      const techList: number[] = [
        tag.NFC_A, 
        tag.NFC_B, 
        tag.NFC_F, 
        tag.NFC_V, 
        tag.NDEF,
        tag.ISO_DEP
      ];
      
      try {
        tag.on('readerMode', this.nfcTagElementName, techList, (error: BusinessError, tagInfo: tag.TagInfo | null) => {
          if (!error && tagInfo != null) {
            Log.i(TAG, `NFC Tag discovered: ${JSON.stringify(tagInfo.supportedTechs)}`);
            // The NfcManagerPlugin will handle this via its own callback
          } else if (error) {
            Log.e(TAG, `NFC reader mode error: ${error.code} - ${error.message}`);
          }
        });
        this.foregroundRegister = true;
        Log.i(TAG, "NFC foreground reader mode registered");
      } catch (error) {
        Log.e(TAG, `Failed to register NFC reader mode: ${error}`);
      }
    }
  }

  onBackground(): void {
    // Unregister NFC reader mode when app goes to background
    if (this.foregroundRegister && this.nfcTagElementName) {
      try {
        tag.off('readerMode', this.nfcTagElementName);
        this.foregroundRegister = false;
        Log.i(TAG, "NFC foreground reader mode unregistered");
      } catch (error) {
        Log.e(TAG, `Failed to unregister NFC reader mode: ${error}`);
      }
    }
    
    super.onBackground();
  }

  onDestroy(): void {
    // Cleanup NFC registration
    if (this.foregroundRegister && this.nfcTagElementName) {
      try {
        tag.off('readerMode', this.nfcTagElementName);
      } catch (error) {
        Log.e(TAG, `Failed to cleanup NFC: ${error}`);
      }
    }
    
    super.onDestroy();
  }
}
