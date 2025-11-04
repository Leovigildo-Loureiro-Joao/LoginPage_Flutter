import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import "../ui/themes.dart";

TextField inputUnderline(Icon icone,bool obscure,String text,bool error,TextEditingController controller) {
  return TextField(
      obscureText: obscure,
      controller: controller,
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
           borderSide: BorderSide(
            color: error?ColorsApp.error:ColorsApp.textColor,
           )
        ),
        labelText: text,
        suffixIcon:icone,
        labelStyle: error?Themes.errorInput:Themes.bodyText
        
      ),
    );
}  