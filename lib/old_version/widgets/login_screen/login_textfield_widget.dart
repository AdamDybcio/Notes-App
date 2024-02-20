import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginTextFieldWidget extends StatelessWidget {
  const LoginTextFieldWidget({
    Key? key,
    required this.nextFocusNode,
    required this.currentFocusNode,
    required this.controller,
    required this.textFieldText,
    required this.obscureText,
  }) : super(key: key);

  final FocusNode? nextFocusNode;
  final FocusNode currentFocusNode;
  final TextEditingController controller;
  final String textFieldText;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(
        MediaQuery.of(context).size.width * 0.05,
      ),
      child: TextFormField(
        onFieldSubmitted: (value) {
          if (nextFocusNode != null) {
            nextFocusNode!.requestFocus();
          }
        },
        focusNode: currentFocusNode,
        textAlign: TextAlign.center,
        controller: controller,
        style: GoogleFonts.lato(
          textStyle: const TextStyle(
            color: Colors.black,
          ),
        ),
        keyboardType: TextInputType.text,
        obscureText: obscureText,
        decoration: InputDecoration(
          fillColor: Colors.white54,
          filled: true,
          labelText: textFieldText,
          prefixIconColor: Colors.redAccent,
          labelStyle: GoogleFonts.lato(
            color: Colors.black,
            fontSize: 20,
          ),
          prefixIcon: const Icon(
            Icons.login,
            size: 35,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
