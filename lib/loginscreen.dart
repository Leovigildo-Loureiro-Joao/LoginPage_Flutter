import 'package:flutter/material.dart';
import 'theme.dart';
import 'homescreen.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.title,});
  
  final String title;

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
  // E ISSO TAMBÉM É LÓGICA! 👇  
  void fakeLogin() async {
    setState(() => isLoading = true);          // ✅ LÓGICA DE ESTADO
    await Future.delayed(Duration(seconds: 2)); // ✅ LÓGICA TEMPORAL
    if (!emailController.text.contains("@") && emailController.text.length<1) {
      print("Erro!!! email mal inserido");
      erro=true;
    }if (passwordController.text.length<6) {
      print("Erro!!! password muito curta");
      erro=true;
    }
    if (!erro) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
    setState(() => isLoading = false);         // ✅ LÓGICA DE ESTADO
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:Text(
          widget.title,
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold

          ),
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
              style: TextStyle(
                fontSize: 13
              ),
            ),
            SizedBox(height: 10),
            Column(
              children: [
                TextField(
                  
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Insira o seu email",
                    suffixIcon: Icon(Icons.email),
                    labelStyle: TextStyle(
                      fontSize: 13
                    )
                  ),
                ),
                 SizedBox(height: 20),
                TextField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: "Insira a tua password",
                    suffixIcon: Icon(
                      Icons.password_sharp
                    ),
                    labelStyle: TextStyle(
                      fontSize: 13
                    )
                    
                  ),
                ),
                 SizedBox(height: 30),
            isLoading?
            CircularProgressIndicator()
            :ElevatedButton(onPressed:fakeLogin, child: Text("Entrar"),

                style: ButtonStyle(
                  minimumSize: WidgetStatePropertyAll<Size>(
                    Size(500,50)
                  ) ,
                 foregroundColor: WidgetStatePropertyAll<Color>(
                    Colors.white
                  ) ,
                  backgroundColor:  WidgetStatePropertyAll<Color>(
                    primaryColor
                  ) 
                ),
              )
              ],
            ),
            TextButton(onPressed: ()=>{}, child: Text("Esqueceu sua senha?"))
          ],
        ),
      ),
      ) 
    );
  }
}
