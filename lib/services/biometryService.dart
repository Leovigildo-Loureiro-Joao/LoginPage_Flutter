// services/biometric_service.dart
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';


class BiometricService {
  static final LocalAuthentication _auth = LocalAuthentication();

  // ✅ VERIFICA SE A BIOMETRIA ESTÁ DISPONÍVEL (REAL)
  static Future<bool> get isAvailable async {
    try {
      return await _auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print('Erro ao verificar biometria: $e');
      return false;
    }
  }

  // ✅ VERIFICA SE HÁ BIOMETRIA CADASTRADA
  static Future<bool> get hasEnrolledBiometrics async {
    try {
      return await _auth.isDeviceSupported() && 
             await _auth.canCheckBiometrics && 
             (await _auth.getAvailableBiometrics()).isNotEmpty;
    } on PlatformException catch (e) {
      print('Erro ao verificar biometria cadastrada: $e');
      return false;
    }
  }

  // ✅ AUTENTICAÇÃO BIOMÉTRICA REAL
  static Future<bool> authenticate() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Autentique-se para acessar suas senhas',
        authMessages: [
          const AndroidAuthMessages(
            signInTitle: 'Autenticação Requerida',
            biometricHint: '',
            biometricNotRecognized: 'Biometria não reconhecida',
            biometricRequiredTitle: 'Biometria necessária',
            cancelButton: 'Cancelar',
          ),
        ],
        options: const AuthenticationOptions(
          biometricOnly: true, // Só permite biometria, não fallback para PIN
          stickyAuth: true,
          sensitiveTransaction: true,
        ),
      );
    } on PlatformException catch (e) {
      print('Erro na autenticação: $e');
      return false;
    }
  }

  // ✅ OBTÉM TIPOS DE BIOMETRIA DISPONÍVEIS
  static Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print('Erro ao obter biometrias: $e');
      return [];
    }
  }

  // ✅ NOME AMIGÁVEL DA BIOMETRIA
  static String getBiometricName(List<BiometricType> availableBiometrics) {
    if (availableBiometrics.contains(BiometricType.face)) {
      return 'Face ID';
    } else if (availableBiometrics.contains(BiometricType.iris)) {
      return 'Digital';
    } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
      return 'Digital';
    } else {
      return 'Biometria';
    }
  }

  // ✅ VERIFICA SE O DISPOSITIVO É COMPATÍVEL
  static Future<bool> get isDeviceSupported async {
    try {
      return await _auth.isDeviceSupported();
    } on PlatformException catch (e) {
      print('Erro ao verificar suporte: $e');
      return false;
    }
  }
}