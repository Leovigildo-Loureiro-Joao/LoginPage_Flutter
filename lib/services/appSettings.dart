// services/app_settings.dart
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  static Future<void> saveSettings({
    required bool darkMode,
    required bool biometricEnabled,
    required bool backup_auto,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', darkMode);
    await prefs.setBool('biometric_enabled', biometricEnabled);
    await prefs.setBool('backup_auto', backup_auto);
  }

  static Future<Map<String, bool>> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'darkMode': prefs.getBool('dark_mode') ?? false,
      'biometricEnabled': prefs.getBool('biometric_enabled') ?? false,
      'backup_auto': prefs.getBool('backup_auto') ?? false,
    };
  }
}