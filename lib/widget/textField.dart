import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import "../ui/themes.dart";

TextField inputUnderline({required Widget icone,required bool obscure,required String text,required bool error,required TextEditingController controller,dynamic context}) {
  return TextField(
      obscureText: obscure,
      controller: controller,
      style: TextStyle(
        fontWeight: FontWeight.w400

      ),
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
           borderSide: BorderSide(
            color: error?ColorsApp.error:ColorsApp.textColor,
           )
        ),
        labelText: text,
        suffixIcon:icone,
        labelStyle: error?Themes.errorInput:Theme.of(context).textTheme.bodySmall
      ),
    );
}  