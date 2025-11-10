import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:local_auth/local_auth.dart';
import 'package:loginpage/main.dart';
import 'package:loginpage/pages/loginscreen.dart';
import 'package:loginpage/services/biometryService.dart';
import 'package:loginpage/services/secureStroregeService.dart';
import 'package:loginpage/widget/TypeWritterEraser.dart';
import '../ui/themes.dart';
import '../widget/textField.dart';
import 'homescreen.dart';
class SingSreen extends StatefulWidget {
  const SingSreen({super.key,required this.theme,required this.updateTheme});

  final ThemeData theme;
  final VoidCallback updateTheme;
  

  @override
  State<SingSreen> createState() => _MySingSreen();
}

class _MySingSreen extends State<SingSreen> {

  // ISSO É LÓGICA PURA! 👇
  TextEditingController _cpasswordController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  WidgetStatesController button=WidgetStatesController();
  bool isLoading = false;
  List erro=[false,false];
  bool _obscurePassword=true;
  bool _obscureCPassword=true;

  IconData icone= Icons.light_mode;
  IconData get iconeTema {
    print( Theme.of(context));
    return Theme.of(context).brightness == Themes.lightTheme.brightness 
        ? Icons.dark_mode 
        : Icons.light_mode;
  }


  bool _isStrongPassword(String password) {
    if (password.length < 8) return false;
    if (!password.contains(RegExp(r'[A-Z]'))) return false;
    if (!password.contains(RegExp(r'[a-z]'))) return false;
    if (!password.contains(RegExp(r'[0-9]'))) return false;
    return true;
  }

  // E ISSO TAMBÉM É LÓGICA! 👇  
  void fakeLogin() async {
    setState(() => isLoading = true);          // ✅ LÓGICA DE ESTADO
    await Future.delayed(Duration(seconds: 2)); // ✅ LÓGICA TEMPORAL
    erro[0]=!_isStrongPassword(_passwordController.text);
    erro[1]=_passwordController.text!=_cpasswordController.text;
    
    if (!erro[0]&&!erro[1]) {
      SecureStorageService.saveMasterPassword(_passwordController.text);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen(theme: Theme.of(context),updateTheme: widget.updateTheme,)),
      );
    }
    setState(() => isLoading = false);         // ✅ LÓGICA DE ESTADO
  }

  @override
  void initState() {
    super.initState();
  }


  Widget _buildPasswordStrengthIndicator(int strength) {
    final colors = [Colors.red, Colors.orange, Colors.yellow, Colors.lightGreen, Colors.green];
    final labels = ['Muito Fraca', 'Fraca', 'Média', 'Forte', 'Muito Forte'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: strength / 5,
                backgroundColor: Colors.grey[300],
                color: colors[strength - 1],
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            SizedBox(width: 12),
            Text(
              labels[strength - 1],
              style: TextStyle(
                fontSize: 12,
                color: colors[strength - 1],
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ✅ REQUISITOS DA SENHA
  Widget _buildPasswordRequirements() {
    final password = _passwordController.text;
    
    final requirements = [
      {'text': 'Mínimo 8 caracteres', 'met': password.length >= 8},
      {'text': 'Pelo menos 1 letra maiúscula', 'met': password.contains(RegExp(r'[A-Z]'))},
      {'text': 'Pelo menos 1 letra minúscula', 'met': password.contains(RegExp(r'[a-z]'))},
      {'text': 'Pelo menos 1 número', 'met': password.contains(RegExp(r'[0-9]'))},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: requirements.map((req) => Padding(
        padding: EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            Icon(
              req['met'] as bool ? Icons.check_circle : Icons.radio_button_unchecked,
              size: 16,
              color: req['met'] as bool ? Colors.green : Colors.grey,
            ),
            SizedBox(width: 8),
            Text(
              req['text'] as String,
              style: TextStyle(
                fontSize: 12,
                color: req['met'] as bool ? Colors.green : Colors.grey,
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }

  int _getPasswordStrength(String password) {
    int score = 0;
    if (password!=null&&password.length >= 8) score++;
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[a-z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++;
    return score;
  }


  @override
  Widget build(BuildContext context) {
    final passwordStrength = _getPasswordStrength(_passwordController.text);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        
          title: Text(
            "Gestor de contas",
            style: Theme.of(context).textTheme.titleLarge, // ✅ USA O TEMA RECEBIDO
          ),
          
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child:Container(
        padding: EdgeInsets.all(10),
        width: 500,
        margin: EdgeInsets.only(left: 20,right: 20),
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 40),
            TypewriterWithCursor(
              text: "Proteja suas senhas com uma conta segura.",
              duration: Duration(milliseconds:1000),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.4, // Melhor espaçamento
              ),
              textAlign: TextAlign.center,
              cursorColor: ColorsApp.primaryColor,
            ),
             if (_passwordController.text.isNotEmpty) ...[
              SizedBox(height: 8),
              _buildPasswordStrengthIndicator(passwordStrength),
              SizedBox(height: 8),
              _buildPasswordRequirements(),
            ],
            SizedBox(height: 30),
            Column(
              children: [
                inputUnderline(
                  icone: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  obscure:_obscurePassword, 
                  text: "Insira a sua password", 
                  error:erro[0], 
                  controller: _passwordController,
                  context: context
                ),
                SizedBox(height: 20),
                inputUnderline(
                  icone: IconButton(
                    icon: Icon(
                      _obscureCPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureCPassword = !_obscureCPassword;
                      });
                    },
                  ), 
                  obscure:_obscureCPassword, 
                  text: "Comfirma a sua password", 
                  error:erro[1], 
                  controller: _cpasswordController,
                  context: context,
                 
                ),SizedBox(height: 30),
                isLoading?
                CircularProgressIndicator()
                :ElevatedButton(
                  onPressed:fakeLogin, 
                  child: Text("Criar conta"),
                )
              ],
            ),
            SizedBox(height: 20,),
            TextButton(
              onPressed: ()=>{
                Navigator.pushReplacement(context, 
                MaterialPageRoute(builder: (context) => LoginScreen(theme: widget.theme, updateTheme: widget.updateTheme),))
              }, 
              child: Text(
                "Ja tenho uma conta?",
                style: Theme.of(context).textTheme.bodySmall
              ))
          ],
        ),
      ),
      ) 
    );
  }
}
