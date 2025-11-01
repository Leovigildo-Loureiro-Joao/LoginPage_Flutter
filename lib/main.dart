import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 58, 112, 183)),

      ),
      home: const LoginScreen(title: 'Login Page'),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.title});

  final String title;

  @override
  State<LoginScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<LoginScreen> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Column(
          children: [
            Text(
            widget.title,
            style: TextStyle(
              color: Colors.white
            ),
          ),
          
          ],
        )
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        width: 500,
        margin: EdgeInsets.all(20),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/login.png"),
            width: 250,),
            Column(
              spacing: 20,
              children: [
                TextField(
              decoration: InputDecoration(
                labelText: "Insira o seu email",
                suffixIcon: Icon(Icons.email),
                labelStyle: TextStyle(
                  fontSize: 13
                )
              ),
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Insira a tua password",
                suffixIcon: Icon(Icons.password_sharp),
                labelStyle: TextStyle(
                  fontSize: 13
                )
                
              ),
            ),
            ElevatedButton(onPressed:  ()=>{}, child: Text("Entrar"),
                style: ButtonStyle(
                 
                  minimumSize: MaterialStatePropertyAll<Size>(
                    Size(500,50)
                  ) ,
                 foregroundColor: MaterialStatePropertyAll<Color>(
                    Color.fromARGB(255, 255, 255, 255)
                  ) ,
                  backgroundColor: MaterialStatePropertyAll<Color>(
                    Color.fromARGB(255, 112, 170, 247)
                  ) 
                ),
              )
              ],
            )
          ],
        ),
      ),
    );
  }
}
