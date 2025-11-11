// services/encryption_service.dart
import 'package:encrypt/encrypt.dart';

class EncryptionService {
  static final _key = Key.fromLength(32); // AES-256 key
  static final _iv = IV.fromLength(16);   // Initialization Vector
  static final _encrypter = Encrypter(AES(_key));

  // ✅ ENCRIPTA (reversível)
  static String encrypt(String password) {
    try {
      final encrypted = _encrypter.encrypt(password, iv: _iv);
      return encrypted.base64;
    } catch (e) {
      print('❌ Erro ao encriptar: $e');
      return password; // Fallback
    }
  }

  // ✅ DESENCRIPTA (reversível)
  static String decrypt(String encryptedPassword) {
    try {
      final decrypted = _encrypter.decrypt64(encryptedPassword, iv: _iv);
      return decrypted;
    } catch (e) {
      print('❌ Erro ao desencriptar: $e');
      return encryptedPassword; // Fallback
    }
  }
}