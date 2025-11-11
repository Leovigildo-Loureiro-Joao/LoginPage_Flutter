
import 'package:flutter/material.dart';
import 'package:loginpage/ui/themes.dart';
import 'package:loginpage/model/passordItem.dart';

class PasswordSearchDelegate extends SearchDelegate {
  final List<PasswordItem> passwords;

  PasswordSearchDelegate({required this.passwords});
  @override
  // TODO: implement searchFieldStyle

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

   @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: theme.brightness == Brightness.light 
            ? ColorsApp.primaryColor 
            : Colors.black,
        foregroundColor: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: theme.textTheme.bodyMedium?.copyWith(
          color: theme.brightness == Brightness.light 
              ? Colors.white.withOpacity(0.8) 
              : Colors.white.withOpacity(0.8),
        ),
      ),
      textTheme: theme.textTheme.copyWith(
        titleLarge: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final results = passwords.where((password) =>
        password.title.toLowerCase().contains(query.toLowerCase()) ||
        password.username.toLowerCase().contains(query.toLowerCase()));

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final item = results.elementAt(index);
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: ColorsApp.primaryColor.withOpacity(0.1),
            child: Icon(item.icon, color: ColorsApp.primaryColor),
          ),
          title: Text(item.title),
          subtitle: Text(item.username),
          onTap: () {
            // Navegar para detalhes
          },
        );
      },
    );
  }
}