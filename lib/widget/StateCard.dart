import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final ThemeData theme;

  const StatCard({super.key, 
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
          final width = MediaQuery.of(context).size.width;
    return Card(
      color: theme.cardTheme.color,
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(width*0.016),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            SizedBox(height: width*0.012),
            Text(
              value,
              softWrap: true,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 4),
             width>360||width<250? Text(
              title,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ): SizedBox(height: 0),
          ],
        ),
      ),
    );
  }
}