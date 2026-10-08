import { common, ConfigurationConstant } from '@kit.AbilityKit';
import { preferences } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';

const PREFS_NAME = 'theme_settings';
const KEY_COLOR_MODE = 'colorMode';

/**
 * Single place that switches, saves and restores the app's color mode.
 * Pages never touch the context for theming; they call ThemeManager instead.
 */
export class ThemeManager {
  private static ctx?: common.UIAbilityContext;
  private static prefs?: preferences.Preferences;

  /** Call once from EntryAbility.onCreate. Restores the user's saved choice. */
  static init(ctx: common.UIAbilityContext): void {
    ThemeManager.ctx = ctx;
    ThemeManager.prefs = preferences.getPreferencesSync(ctx, { name: PREFS_NAME });
    const saved = ThemeManager.prefs.getSync(
      KEY_COLOR_MODE, ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET) as ConfigurationConstant.ColorMode;
    ThemeManager.apply(saved);
  }

  /** True if the app is currently rendered in dark mode (explicit or via system). */
  static isDark(): boolean {
    return ThemeManager.ctx?.config.colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK;
  }

  /** LIGHT, DARK, or NOT_SET (follow system). Applies app-wide and persists it. */
  static setMode(mode: ConfigurationConstant.ColorMode): void {
    ThemeManager.apply(mode);
    if (ThemeManager.prefs) {
      ThemeManager.prefs.putSync(KEY_COLOR_MODE, mode);
      ThemeManager.prefs.flush().catch((err: BusinessError) => {
        console.error(`ThemeManager: failed to save theme, code=${err.code}`);
      });
    }
  }

  /** Flips between light and dark based on what is currently shown. */
  static toggle(): void {
    ThemeManager.setMode(ThemeManager.isDark()
      ? ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT
      : ConfigurationConstant.ColorMode.COLOR_MODE_DARK);
  }

  private static apply(mode: ConfigurationConstant.ColorMode): void {
    ThemeManager.ctx?.getApplicationContext().setColorMode(mode);
    // Global, reactive copy of the user's *preference* (Light / Dark / System).
    // Only UI that must show this choice (the settings page) binds to it.
    AppStorage.setOrCreate<number>('themePreference', mode);
  }
}
