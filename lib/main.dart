import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:loginpage/model/passordItem.dart';
import 'package:loginpage/pages/welcome_screen.dart';
import 'package:loginpage/services/appSettings.dart';
import 'package:loginpage/services/secureStroregeService.dart';
import 'package:loginpage/ui/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/login_screen.dart';
void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  // ✅ INICIALIZA O HIVE
  await Hive.initFlutter();
  
  // ✅ REGISTRA OS ADAPTERS (gerados automaticamente)
  Hive.registerAdapter(PasswordItemAdapter());
  
  // ✅ ABRE AS BOXES
  await Hive.openBox<PasswordItem>('passwords');
  await Hive.openBox('app_settings');

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
  void initState() {
    super.initState();
    _debugSharedPreferences();
    _debugHive();
    AppSettings.loadSettings().then((value) {
      if (value["darkMode"]!=null&&value["darkMode"]!) {
        _switchTheme();
      }
    });
  }


  @override
Widget build(BuildContext context) {
  return MaterialApp(
    title: 'Flutter Demo',
    debugShowCheckedModeBanner: false,
    theme: _currentTheme,
    home: FutureBuilder<bool>(
      future: SecureStorageService.isFirstTime(),
      builder: (context, snapshot) {
        // ✅ Enquanto carrega
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        // ✅ Quando tem dados
        if (snapshot.hasData) {
          final isFirstTime = snapshot.data!;
          return isFirstTime 
              ? WelcomeScreen(theme: _currentTheme, switchTheme: _switchTheme,cadastrado: isFirstTime,)
              : LoginScreen(theme: _currentTheme, updateTheme: _switchTheme,cadastrado: isFirstTime);
        }
        
        // ✅ Em caso de erro
        return Scaffold(
          body: Center(
            child: Text('Erro ao carregar'),
          ),
        );
      },
    ),
  );
}
  
}



// No SettingsScreen ou onde quiseres ver
void _debugSharedPreferences() async {
  final prefs = await SharedPreferences.getInstance();
  print('=== SHARED_PREFERENCES DEBUG ===');
  print('Todas as chaves: ${prefs.getKeys()}');
  
  for (String key in prefs.getKeys()) {
    print('$key: ${prefs.get(key)}');
  }
  print('================================');
}

// Chama onde quiseres:
// No MainScreen ou PasswordRepository
void _debugHive() {
  final passwordsBox = Hive.box<PasswordItem>('passwords');
  print('=== HIVE DEBUG ===');
  print('Total de senhas: ${passwordsBox.length}');
  print('Chaves: ${passwordsBox.keys}');
  
  for (var key in passwordsBox.keys) {
    final item = passwordsBox.get(key);
    print('$key: ${item?.title} - ${item?.username}');
  }
  print('========================');
}