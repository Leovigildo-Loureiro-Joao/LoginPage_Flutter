import 'package:flutter/material.dart';
import 'package:loginpage/ui/themes.dart';
import 'loginscreen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  
  const MyApp({super.key});

  @override
  State<MyApp> createState() =>_MainState(); 
  
  // This widget is the root of your application.
 
  

}

class _MainState extends State<MyApp> {

  ThemeData _currentTheme=Themes.lightTheme;

  void _switchTheme() {
    setState(() {
      _currentTheme = _currentTheme == Themes.lightTheme 
          ? Themes.darkTheme 
          : Themes.lightTheme;
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: _currentTheme,
      home: LoginScreen(title: 'SmartControl',theme: _currentTheme,updateTheme: _switchTheme,),
    );
  }
  
}


