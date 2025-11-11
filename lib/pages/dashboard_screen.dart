// pages/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:loginpage/model/passordItem.dart';
import 'package:loginpage/services/statsService.dart';
import 'package:loginpage/widget/StateCard.dart';
import '../ui/themes.dart';

class DashboardScreen extends StatelessWidget {
  final List<PasswordItem> passwords;
  final ThemeData theme;
  final VoidCallback updateTheme;

  const DashboardScreen({
    super.key,
    required this.passwords,
    required this.theme,
    required this.updateTheme,
  });

  @override
  Widget build(BuildContext context) {
    final stats = StatsService.calculateStats(passwords);
      final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Dashboard de Segurança',
          style: theme.textTheme.titleLarge,
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CARDS DE ESTATÍSTICAS PRINCIPAIS
            _buildStatsGrid(stats, theme,width),
            SizedBox(height: 24),
            
            // GRÁFICO DE DISTRIBUIÇÃO DE FORÇA
            _buildStrengthChart(stats, theme),
            SizedBox(height: 24),
            
            // DISTRIBUIÇÃO POR CATEGORIA
            _buildCategoriesChart(stats, theme),
            SizedBox(height: 24),
            
            // RECOMENDAÇÕES
            _buildRecommendations(stats, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(Map<String, dynamic> stats, ThemeData theme,double width) {

    return GridView.count(
      crossAxisCount: width<250?1:2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.2,
      children: [
        StatCard(
          title: 'Total de Senhas',
          value: '${stats['totalPasswords']}',
          icon: Icons.lock,
          color: Colors.blue,
          theme: theme,
        ),
       StatCard(
        title: 'Força Média',
        value: '${stats['averageStrength']}/5',
        icon: Icons.security,
        color: _getAverageStrengthColor(
          // ✅ CONVERTE para double com segurança
          (stats['averageStrength'] is int 
              ? (stats['averageStrength'] as int).toDouble() 
              : stats['averageStrength']) ?? 0.0
        ),
        theme: theme,
      ),
        StatCard(
          title: 'Senhas Fracas',
          value: '${stats['weakPasswords']}',
          icon: Icons.warning,
          color: Colors.orange,
          theme: theme,
        ),
        StatCard(
          title: 'Adições Recentes',
          value: '${stats['recentAdded']}',
          icon: Icons.trending_up,
          color: Colors.green,
          theme: theme,
        ),
      ],
    );
  }

  Widget _buildStrengthChart(Map<String, dynamic> stats, ThemeData theme) {
    return Card(
      color: theme.cardTheme.color,
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Distribuição de Força',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Column(
              children: List.generate(5, (index) {
                final strength = index + 1;
                final count = stats['strengthDistribution'][index];
                final percentage = stats['totalPasswords'] > 0 
                    ? (count / stats['totalPasswords'] * 100).toStringAsFixed(1)
                    : '0.0';
                
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 100,
                        child: Text(
                          StatsService.getStrengthLabel(strength),
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: LinearProgressIndicator(
                            value: stats['totalPasswords'] > 0 
                                ? count / stats['totalPasswords'] 
                                : 0,
                            backgroundColor: theme.dividerColor,
                            color: StatsService.getStrengthColor(strength),
                          ),
                        ),
                      ),
                      Container(
                        width: 60,
                        child: Text(
                          '$count ($percentage%)',
                          style: theme.textTheme.bodySmall,
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesChart(Map<String, dynamic> stats, ThemeData theme) {
     final categories = stats['categories'];
  
  // Verifica se categories é um Map e converte corretamente
  if (categories is! Map || categories.isEmpty) {
    return SizedBox.shrink();
  }

    return Card(
      color: theme.cardTheme.color,
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Distribuição por Categoria',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Column(
              children: categories.entries.map((entry) {
                final percentage = (entry.value / stats['totalPasswords'] * 100).toStringAsFixed(1);
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          entry.key,
                          style: theme.textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '${entry.value} ($percentage%)',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendations(Map<String, dynamic> stats, ThemeData theme) {
    final recommendations = <String>[];
    
    if (stats['weakPasswords'] > 0) {
      recommendations.add('${stats['weakPasswords']} senhas precisam ser fortalecidas');
    }
    
    if (stats['averageStrength'] < 3) {
      recommendations.add('A força média das suas senhas está baixa');
    }
    
    if (stats['totalPasswords'] == 0) {
      recommendations.add('Comece adicionando suas primeiras senhas');
    }
    
    if (recommendations.isEmpty) {
      recommendations.add('Suas senhas estão seguras! Continue assim!');
    }

    return Card(
      color: theme.cardTheme.color,
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb_outline, color: Colors.amber),
                SizedBox(width: 8),
                Text(
                  'Recomendações',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Column(
              children: recommendations.map((rec) => Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.circle, size: 8, color: theme.primaryColor),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        rec,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Color _getAverageStrengthColor(double average) {
    if (average >= 4) return Colors.green;
    if (average >= 3) return Colors.lightGreen;
    if (average >= 2) return const Color(0xFFF3DB00);
    return Colors.orange;
  }
}

// Widget de Card de Estatística
