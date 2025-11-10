// models/password_model.dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'passordItem.g.dart';
@HiveType(typeId: 0) // ✅ ID único para o adapter
class PasswordItem {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String title;
  
  @HiveField(2)
  final String username;
  
  @HiveField(3)
  final String encryptedPassword; // ✅ SENHA CRIPTOGRAFADA
  
  @HiveField(4)
  final String website;
  
  @HiveField(5)
  final String iconName; // ✅ Guarda o code point do ícone
  
  @HiveField(6)
  final int strength;
  
  @HiveField(7)
  final String category;
  
  @HiveField(8)
  final DateTime createdAt;
  
  @HiveField(9)
  final DateTime updatedAt;

  PasswordItem({
    required this.id,
    required this.title,
    required this.username,
    required this.encryptedPassword,
    required this.website,
    required this.iconName,
    required this.strength,
    required this.category,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : 
    createdAt = createdAt ?? DateTime.now(),
    updatedAt = updatedAt ?? DateTime.now();


  // ✅ MÉTODO PARA CALCULAR FORÇA DA SENHA
  static int calculatePasswordStrength(String password) {
    int score = 0;
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;
    if (password.contains(RegExp(r'[a-z]'))) score++;
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++;
    return score.clamp(1, 5);
  }

  // ✅ COR BASEADA NA FORÇA
  Color get strengthColor {
    switch (strength) {
      case 1: return Colors.red;
      case 2: return Colors.orange;
      case 3: return Colors.yellow;
      case 4: return Colors.lightGreen;
      case 5: return Colors.green;
      default: return Colors.grey;
    }
  }

  // ✅ LABEL DA FORÇA
  String get strengthLabel {
    switch (strength) {
      case 1: return 'Muito Fraca';
      case 2: return 'Fraca';
      case 3: return 'Média';
      case 4: return 'Forte';
      case 5: return 'Muito Forte';
      default: return 'Desconhecida';
    }
  }

   static String iconDataToName(IconData iconData) {
    if (iconData == Icons.email) return 'email';
    if (iconData == Icons.facebook) return 'facebook';
    if (iconData == Icons.account_balance) return 'account_balance';
    if (iconData == Icons.wifi) return 'wifi';
    if (iconData == Icons.movie) return 'movie';
    return 'lock';
  }

  IconData get icon {
    switch (iconName) {
      case 'email': return Icons.email;
      case 'facebook': return Icons.facebook;
      case 'account_balance': return Icons.account_balance;
      case 'wifi': return Icons.wifi;
      case 'movie': return Icons.movie;
      case 'lock': return Icons.lock;
      default: return Icons.lock;
    }
  }

  // ✅ ÍCONE DA FORÇA
  IconData get strengthIcon {
    switch (strength) {
      case 1: return Icons.warning_amber;
      case 2: return Icons.warning;
      case 3: return Icons.check_circle_outline;
      case 4: return Icons.security;
      case 5: return Icons.verified_user;
      default: return Icons.help_outline;
    }
  }
}