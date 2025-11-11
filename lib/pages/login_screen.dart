import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:loginpage/main.dart';
import 'package:loginpage/pages/security_question_screen.dart';
import 'package:loginpage/pages/sing_screen.dart';
import 'package:loginpage/services/appSettings.dart';
import 'package:loginpage/services/biometryService.dart';
import 'package:loginpage/services/secureStroregeService.dart';
import 'package:loginpage/widget/TypeWritterEraser.dart';
import '../ui/themes.dart';
import '../widget/textField.dart';
import 'home_screen.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key,required this.theme,required this.updateTheme,this.cadastrado});

  final ThemeData theme;
  final VoidCallback updateTheme;
  final bool? cadastrado;

  @override
  State<LoginScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<LoginScreen> {

  // ISSO É LÓGICA PURA! 👇
  TextEditingController emailController = TextEditingController();
  WidgetStatesController button=WidgetStatesController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool erro=false;

  bool _biometricEnabled = false;
  bool _isCheckingBiometrics = false;
  bool _showBiometricOption = false;
  List<BiometricType> _availableBiometrics = [];
  String _biometricName = 'Biometria';
  late bool obscure=false;

  IconData icone= Icons.light_mode;
  IconData get iconeTema {
    print( Theme.of(context));
    return Theme.of(context).brightness == Themes.lightTheme.brightness 
        ? Icons.dark_mode 
        : Icons.light_mode;
  }

  void _checkBiometricAvailability() async {
    setState(() => _isCheckingBiometrics = true);
    
    try {
      final isSupported = await BiometricService.isDeviceSupported;
      final hasBiometrics = await BiometricService.hasEnrolledBiometrics;
      final availableBiometrics = await BiometricService.getAvailableBiometrics();
      
      setState(() {
        _showBiometricOption = isSupported && hasBiometrics;
        _availableBiometrics = availableBiometrics;
        _biometricName = BiometricService.getBiometricName(availableBiometrics);
        _isCheckingBiometrics = false;
      });
    } catch (e) {
      setState(() {
        _showBiometricOption = false;
        _isCheckingBiometrics = false;
      });
      print('Erro ao verificar biometria: $e');
    }
  }


  // E ISSO TAMBÉM É LÓGICA! 👇  
  void fakeLogin() async {
    setState(() => isLoading = true);          // ✅ LÓGICA DE ESTADO
    await Future.delayed(Duration(seconds: 2)); // ✅ LÓGICA TEMPORAL
    SecureStorageService.getMasterPassword().then((value) {
      erro=value!=passwordController.text;
       if (!erro) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen(theme: Theme.of(context),updateTheme: widget.updateTheme,)),
        );
      }
      setState(() => isLoading = false);  
      
    },);
    
          // ✅ LÓGICA DE ESTADO
  }

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
     AppSettings.loadSettings().then((values) {
        if(values.values.elementAt(1)){
          widget.updateTheme();
        }
          
    },);
  }

   void _loginWithBiometrics() async {
    setState(() => isLoading = true);
    
    try {
      final isAuthenticated = await BiometricService.authenticate();
      
      if (isAuthenticated) {
        _performAutoLogin();
      } else {
        setState(() => isLoading = false);
        _showBiometricError('Autenticação cancelada ou falhou');
      }
    } catch (e) {
      setState(() => isLoading = false);
      _showBiometricError('Erro na autenticação biométrica');
      print('Erro na biometria: $e');
    }
  }

  void _performAutoLogin() {
    // Simula credenciais salvas (num app real viria do SecureStorage)
    emailController.text = "usuario@exemplo.com";
    passwordController.text = "senha123";
    
    Future.delayed(Duration(milliseconds: 500), () {
      fakeLogin();
    });
  }

  void _showBiometricError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'Tentar novamente',
          onPressed: _loginWithBiometrics,
        ),
      ),
    );
  }

  // ✅ ÍCONE DINÂMICO BASEADO NO TIPO DE BIOMETRIA
  Widget _getBiometricIcon() {
    if (_availableBiometrics.contains(BiometricType.face)) {
      return Icon(Icons.face, size: 24);
    } else if (_availableBiometrics.contains(BiometricType.fingerprint)) {
      return Icon(Icons.fingerprint, size: 24);
    } else {
      return Icon(Icons.security, size: 24);
    }
  }

  

  @override
  Widget build(BuildContext context) {
     final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        
          title: Text(
            "Gestor de senhas",
            style: Theme.of(context).textTheme.titleLarge, // ✅ USA O TEMA RECEBIDO
          ),
          
      ),
      body: Align(
        alignment: Alignment.center,
        child:Container(
        padding: EdgeInsets.only(left: 10,right: 10),
        width: 500,
        margin: EdgeInsets.only(left: 20,right: 20),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/login.png"),
              width: height<500?width * 0:height*0.3,
            ),
            
            TypewriterWithCursor(
              text: "Nossa maior prioridade e dar seguranca aos seus dados.",
              duration: Duration(milliseconds:1000),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                height: 1.4, // Melhor espaçamento
              ),
              textAlign: TextAlign.center,
              cursorColor: ColorsApp.primaryColor,
            ),
            SizedBox(height: 10),
              if (_showBiometricOption) ...[
                _buildBiometricButton(),
                SizedBox(height: 16),
              ] else if (_isCheckingBiometrics) ...[
                _buildBiometricChecking(),
              ],
            Column(
              children: [
                inputUnderline(
                  icone: IconButton(
                          icon: Icon(
                            obscure ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              obscure = !obscure;
                            });
                          },
                        ), 
                  obscure:obscure, 
                  text: "Insira a sua password", 
                  error:erro, 
                  controller: passwordController,
                  context: context
                ),SizedBox(height: 30),
                isLoading?
                CircularProgressIndicator()
                :ElevatedButton(
                  onPressed:fakeLogin, 
                  child: Text("Entrar"),
                )
              ],
            ),
            SizedBox(height: 20,),
            TextButton(
              onPressed: ()=>{
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SecurityQuestionScreen(),
                  )
              )}, 
              child: Text(
                "Esqueceu sua senha?",
                style: Theme.of(context).textTheme.bodySmall
              )),
              TextButton(
                onPressed: ()=>{
                   Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SingScreen(theme: Theme.of(context),updateTheme: widget.updateTheme,isFisrtTime: widget.cadastrado,)),
                  )
                }, 
                child: Text(
                  "Criar conta",
                  style: Theme.of(context).textTheme.bodySmall,
              ))
          ],
        ),
      ),
      ) 
    );
  }

  Widget _buildBiometricButton() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'ou',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            Expanded(child: Divider()),
          ],
        ),
        
        SizedBox(height: 16),
        
        OutlinedButton.icon(
          icon: _getBiometricIcon(),
          label: Text('Entrar com $_biometricName'),
          onPressed: _loginWithBiometrics,
          style: OutlinedButton.styleFrom(
            foregroundColor: ColorsApp.primaryColor,
            side: BorderSide(color: ColorsApp.primaryColor),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildBiometricChecking() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'ou',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            Expanded(child: Divider()),
          ],
        ),
        
        SizedBox(height: 16),
        
        OutlinedButton.icon(
          icon: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          label: Text('Verificando biometria...'),
          onPressed: null,
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.grey,
            side: BorderSide(color: Colors.grey),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ],
    );
  }
}
