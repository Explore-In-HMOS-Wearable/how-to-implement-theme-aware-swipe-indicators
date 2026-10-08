import { AbilityConstant, Configuration, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { ThemeManager } from '../common/ThemeManager';

const DOMAIN = 0x0000;
const TAG = 'EntryAbility';

export default class EntryAbility extends UIAbility {
  private mainWindow?: window.Window;

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    // Restore the saved theme before any page is shown.
    ThemeManager.init(this.context);
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(DOMAIN, TAG, 'Failed to load content: %{public}s', JSON.stringify(err));
        return;
      }
      this.mainWindow = windowStage.getMainWindowSync();
      this.updateSystemBar(this.context.config.colorMode);
    });
  }

  // Called for every configuration change, including our own setColorMode calls
  // and the user switching dark mode in system settings.
  onConfigurationUpdate(newConfig: Configuration): void {
    this.updateSystemBar(newConfig.colorMode);
  }

  // Status bar icons are not a resource, so they are handled here once for the whole app.
  private updateSystemBar(mode?: ConfigurationConstant.ColorMode): void {
    const dark = mode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK;
    this.mainWindow?.setWindowSystemBarProperties({
      statusBarContentColor: dark ? '#FFFFFF' : '#000000'
    }).catch((err: BusinessError) => {
      hilog.error(DOMAIN, TAG, 'Failed to set system bar: %{public}d', err.code);
    });
  }
}
