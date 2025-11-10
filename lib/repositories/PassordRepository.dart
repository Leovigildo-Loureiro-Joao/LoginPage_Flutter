// repositories/password_repository.dart
import 'package:hive/hive.dart';
import 'package:loginpage/model/passordItem.dart';

class PasswordRepository {
  static const String _boxName = 'passwords';
  Box<PasswordItem>? _box;

  void _checkInitialized() {
    if (_box == null) {
      init().then((value) => {
        print('✅ Box $_boxName inicializada com sucesso'),
      },);
    }
  }
  // ✅ INICIALIZA O REPOSITÓRIO
  Future<void> init() async {
    _box = await Hive.openBox<PasswordItem>(_boxName);
  }

  // ✅ ADICIONA SENHA
  Future<void> addPassword(PasswordItem password) async {
     init().then((value) => {
         _box!.put(password.id, password)
     });
  }

  // ✅ OBTÉM TODAS AS SENHAS
  List<PasswordItem> getAllPasswords() {
    _checkInitialized();
    return _box!.values.toList();
  }

  // ✅ OBTÉM SENHA POR ID
  PasswordItem? getPasswordById(String id) {
    _checkInitialized();
    return _box!.get(id);
  }

  // ✅ ATUALIZA SENHA
  Future<void> updatePassword(PasswordItem password) async {
    _checkInitialized();
    await _box!.put(password.id, password);
  }

  // ✅ EXCLUI SENHA
  Future<void> deletePassword(String id) async {
    _checkInitialized();
    await _box!.delete(id);
  }

  // ✅ BUSCA SENHAS
  List<PasswordItem> searchPasswords(String query) {
    _checkInitialized();
    final lowerQuery = query.toLowerCase();
    return _box!.values.where((password) {
      return password.title.toLowerCase().contains(lowerQuery) ||
             password.username.toLowerCase().contains(lowerQuery) ||
             password.category.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  // ✅ SENHAS POR CATEGORIA
  List<PasswordItem> getPasswordsByCategory(String category) {
    _checkInitialized();
    return _box!.values
        .where((password) => password.category == category)
        .toList();
  }

  // ✅ SENHAS FRACAS
  List<PasswordItem> getWeakPasswords() {
    _checkInitialized();
    return _box!.values
        .where((password) => password.strength <= 2)
        .toList();
  }

  // ✅ ESTATÍSTICAS
  Map<String, dynamic> getStats() {
    _checkInitialized();
    final passwords = _box!.values.toList();
    final total = passwords.length;
    
    if (total == 0) {
      return {
        'total': 0,
        'averageStrength': 0.0,
        'weakCount': 0,
        'strongCount': 0,
        'categories': {},
      };
    }

    final averageStrength = passwords.map((p) => p.strength).reduce((a, b) => a + b) / total;
    final weakCount = passwords.where((p) => p.strength <= 2).length;
    final strongCount = passwords.where((p) => p.strength >= 4).length;

    final categories = <String, int>{};
    for (final password in passwords) {
      categories[password.category] = (categories[password.category] ?? 0) + 1;
    }

    return {
      'total': total,
      'averageStrength': double.parse(averageStrength.toStringAsFixed(1)),
      'weakCount': weakCount,
      'strongCount': strongCount,
      'categories': categories,
    };
  }

  // ✅ LIMPA TODOS OS DADOS (CUIDADO!)
  Future<void> clearAll() async {
    _checkInitialized();
    await _box!.clear();
  }

  // ✅ FECHA O BOX
  Future<void> close() async {
    _checkInitialized();
    await _box!.close();
  }
}