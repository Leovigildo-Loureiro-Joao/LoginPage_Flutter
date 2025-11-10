import 'package:flutter/material.dart'; 


class ColorsApp {
  static final Color secondaryColor=Color(0xFF020B1F);
  static final Color primaryColor=Color.fromARGB(255, 33, 95, 228);
  static final Color textColor=Color(0xFF424647);
  static final Color error=Color.fromARGB(255, 167, 0, 0);
}


class Themes {
  static final TextStyle errorInput = TextStyle(
    color: ColorsApp.error,
    fontSize: 13,
  );

  static final TextStyle bodyText = TextStyle(
    color: ColorsApp.textColor,
    fontSize: 13,
  );

  static final TextStyle placeholder = TextStyle(
    color: ColorsApp.textColor.withOpacity(0.8),
    fontSize: 13,
  );

  static final TextStyle bodyTextDark = TextStyle(
    color: Colors.white,
    fontSize: 13,
  );

  static final TextStyle titleText = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 18
  );

  // ✅ CORRIGIDO: TextTheme completo para light mode
  static final TextTheme lightTextTheme = TextTheme(
    bodySmall: TextStyle(
      color: ColorsApp.textColor,
      fontSize: 13,
      fontWeight: FontWeight.normal
    ),
    bodyMedium: TextStyle(
      color: ColorsApp.textColor,
      fontSize: 14,
    ),
     bodyLarge: TextStyle(
      fontWeight: FontWeight.bold
    ),
    titleMedium: TextStyle(
      color: ColorsApp.textColor,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    titleLarge: TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  );

  // ✅ CORRIGIDO: TextTheme completo para dark mode
  static final TextTheme darkTextTheme = TextTheme(
    bodySmall: TextStyle(
      color: Colors.white,
      fontSize: 13,
    ),
    bodyMedium: TextStyle(
      color: Colors.white,
      fontSize: 14,
    ),
     bodyLarge: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold
    ),
    titleMedium: TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    titleLarge: TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  );

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: ColorsApp.primaryColor,
    cardTheme: CardThemeData(
      color: Colors.white,
      shadowColor: ColorsApp.textColor.withOpacity(0.3),
    ),
    inputDecorationTheme: InputDecorationTheme(),
    appBarTheme: AppBarTheme(
      foregroundColor: Colors.white,
      backgroundColor: ColorsApp.primaryColor,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
    scaffoldBackgroundColor: Colors.white,
    textTheme: lightTextTheme, // ✅ USANDO O TextTheme COMPLETO
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        minimumSize: WidgetStatePropertyAll<Size>(Size(500, 50)),
        foregroundColor: WidgetStatePropertyAll<Color>(Colors.white),
        backgroundColor: WidgetStatePropertyAll<Color>(ColorsApp.primaryColor),
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: ColorsApp.primaryColor,
   
    appBarTheme: AppBarTheme(
      foregroundColor: Colors.white,
      backgroundColor: Colors.black,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
    scaffoldBackgroundColor: Colors.grey[900],
    textTheme: darkTextTheme, // ✅ USANDO O TextTheme COMPLETO
    cardTheme: CardThemeData(
      color: Colors.grey[800],
      shadowColor: Colors.white.withOpacity(0.1),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        minimumSize: WidgetStatePropertyAll<Size>(Size(500, 50)),
        foregroundColor: WidgetStatePropertyAll<Color>(Colors.white),
        backgroundColor: WidgetStatePropertyAll<Color>(ColorsApp.primaryColor),
      ),
    ),
  );
}