import 'package:flutter/material.dart';
import 'package:loginpage/pages/main.dart';
import '../ui/themes.dart';
import '../widget/textField.dart';
import 'homescreen.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.title,required this.theme,required this.updateTheme});
  
  final String title;
  final ThemeData theme;
  final VoidCallback updateTheme;
  

  @override
  State<LoginScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<LoginScreen> {

  // ISSO É LÓGICA PURA! 👇
  TextEditingController emailController = TextEditingController();
  WidgetStatesController button=WidgetStatesController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  IconData icone= Icons.light_mode;
  List erro=[false,false];

  IconData get iconeTema {
    return widget.theme == Themes.lightTheme 
        ? Icons.dark_mode 
        : Icons.light_mode;
  }
  // E ISSO TAMBÉM É LÓGICA! 👇  
  void fakeLogin() async {
    setState(() => isLoading = true);          // ✅ LÓGICA DE ESTADO
    await Future.delayed(Duration(seconds: 2)); // ✅ LÓGICA TEMPORAL
    erro[0]=!emailController.text.contains("@");
    erro[1]=passwordController.text.length<6;
    
    if (!erro[0]&&!erro[1]) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
    setState(() => isLoading = false);         // ✅ LÓGICA DE ESTADO
  }

  aletrarTema(){
    widget.updateTheme();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:Text(
          widget.title,
          style: Themes.titleText
        ),
        leading: IconButton(onPressed: aletrarTema, icon: Icon(icone),
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
          children: <Widget>[
             SizedBox(height: 20),
            Image(image: AssetImage("assets/login.png"),
              width: 250,
            ),
            
            Text(
              "Nossa maior prioridade e dar seguranca aos seus dados",
              textAlign: TextAlign.center,
              style: icone==Icons.light_mode?Themes.bodyText:Themes.bodyTextDark
            ),
            SizedBox(height: 10),
            Column(
              children: [
                inputUnderline(
                  Icon(
                    Icons.email
                  ), 
                  false, 
                  "Insira o seu email", 
                  erro[0], 
                  emailController
                  ),
                SizedBox(height: 20),
                inputUnderline(
                  Icon(
                    Icons.password
                  ), 
                  true, 
                  "Insira a sua password", 
                  erro[1], 
                  passwordController
                  ),
                 SizedBox(height: 30),
            isLoading?
            CircularProgressIndicator()
            :ElevatedButton(onPressed:fakeLogin, child: Text("Entrar"),
              )
              ],
            ),
            SizedBox(height: 20,),
            TextButton(onPressed: ()=>{}, child: Text("Esqueceu sua senha?",style: Themes.lightTheme.textTheme.bodySmall))
          ],
        ),
      ),
      ) 
    );
  }
}
