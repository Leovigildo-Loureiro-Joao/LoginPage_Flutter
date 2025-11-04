import 'package:flutter/material.dart'; 


class ColorsApp {
  static final Color primaryColor=Color(0xFF21BDE4);
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

  static final TextStyle bodyTextDark = TextStyle(
    color: Colors.white,
    fontSize: 13,
  );

  static final TextStyle titleText = TextStyle(
    color: ColorsApp.primaryColor,
    fontWeight: FontWeight.bold,
  );

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light, // ✅ IMPORTANTE!
    primaryColor: ColorsApp.primaryColor,
    scaffoldBackgroundColor: Colors.white, // ✅ FUNDO CLARO
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        minimumSize: WidgetStatePropertyAll<Size>(Size(500, 50)),
        foregroundColor: WidgetStatePropertyAll<Color>(Colors.white),
        backgroundColor: WidgetStatePropertyAll<Color>(ColorsApp.primaryColor),
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark, // ✅ IMPORTANTE!
    primaryColor: ColorsApp.primaryColor,
    scaffoldBackgroundColor: Colors.grey[900], // ✅ FUNDO ESCURO
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        minimumSize: WidgetStatePropertyAll<Size>(Size(500, 50)),
        foregroundColor: WidgetStatePropertyAll<Color>(Colors.white),
        backgroundColor: WidgetStatePropertyAll<Color>(ColorsApp.primaryColor),
      ),
    ),
  );
}