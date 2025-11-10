// services/stats_service.dart
import 'package:flutter/material.dart';
import 'package:loginpage/model/passordItem.dart';

class StatsService {
  static Map<String, dynamic> calculateStats(List<PasswordItem> passwords) {
    if (passwords.isEmpty) {
      return {
        'totalPasswords': 0,
        'averageStrength': 0,
        'weakPasswords': 0,
        'strongPasswords': 0,
        'recentAdded': 0,
        'categories': {},
        'strengthDistribution': [0, 0, 0, 0, 0],
      };
    }

    // Cálculo de estatísticas
    final total = passwords.length;
    final averageStrength = passwords.map((p) => p.strength).reduce((a, b) => a + b) / total;
    final weakPasswords = passwords.where((p) => p.strength <= 2).length;
    final strongPasswords = passwords.where((p) => p.strength >= 4).length;
    
    // Passwords adicionadas nos últimos 7 dias
    final weekAgo = DateTime.now().subtract(Duration(days: 7));
    final recentAdded = passwords.where((p) => p.createdAt.isAfter(weekAgo)).length;

    // Distribuição por categoria
    final categories = <String, int>{};
    for (final password in passwords) {
      categories[password.category] = (categories[password.category] ?? 0) + 1;
    }

    // Distribuição de força
    final strengthDistribution = List<int>.filled(5, 0);
    for (final password in passwords) {
      strengthDistribution[password.strength - 1]++;
    }

    return {
      'totalPasswords': total,
      'averageStrength': double.parse(averageStrength.toStringAsFixed(1)),
      'weakPasswords': weakPasswords,
      'strongPasswords': strongPasswords,
      'recentAdded': recentAdded,
      'categories': categories,
      'strengthDistribution': strengthDistribution,
    };
  }

  static String getStrengthLabel(int strength) {
    switch (strength) {
      case 1: return 'Muito Fraca';
      case 2: return 'Fraca';
      case 3: return 'Média';
      case 4: return 'Forte';
      case 5: return 'Muito Forte';
      default: return 'Desconhecida';
    }
  }

  static Color getStrengthColor(int strength) {
    switch (strength) {
      case 1: return Colors.red;
      case 2: return Colors.orange;
      case 3: return Colors.yellow;
      case 4: return Colors.lightGreen;
      case 5: return Colors.green;
      default: return Colors.grey;
    }
  }
}