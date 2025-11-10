// services/secure_storage_service.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static final _storage = FlutterSecureStorage();
  
  static const _masterPasswordKey = 'master_password';
  static const _isFirstTimeKey = 'is_first_time';

  // ✅ SALVA SENHA MESTRA (SEGURA)
  static Future<void> saveMasterPassword(String password) async {
    await _storage.write(
      key: _masterPasswordKey,
      value: password,
    );
    print('🔐 Senha mestra salva com segurança');
  }

  // ✅ OBTÉM SENHA MESTRA
  static Future<String?> getMasterPassword() async {
    return await _storage.read(key: _masterPasswordKey);
  }

  // ✅ VERIFICA SE É PRIMEIRO ACESSO
  static Future<bool> isFirstTime() async {
    final value = await _storage.read(key: _isFirstTimeKey);
    return value == null;
  }

  // ✅ MARCA PRIMEIRO ACESSO COMO CONCLUÍDO
  static Future<void> setFirstTimeCompleted() async {
    await _storage.write(key: _isFirstTimeKey, value: 'false');
  }

  // ✅ LIMPA TODOS OS DADOS (logout)
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}