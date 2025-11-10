// services/storage_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _biometricEnabledKey = 'biometric_enabled';

  static Future<bool> getBiometricEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_biometricEnabledKey) ?? false;
  }

  static Future<void> setBiometricEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_biometricEnabledKey, enabled);
  }
}