import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WinnerPage",
         style: TextStyle(
            color: const Color.fromARGB(255, 33, 189, 228),
            fontWeight: FontWeight.bold

          )),
        centerTitle: true,
        
      ),
      body: Center(
        child: Text("Bem vindo Leovigildo ao Flutter!!!"),
      ),
    );
  }
}
