import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InputBoxDecoration extends StatelessWidget {
  const InputBoxDecoration({
    super.key,
    this.focusNode,
    required this.hintText,
    required this.obscureText,
    required this.controller
    });

  final FocusNode? focusNode;
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
      child: TextField(
        obscureText: obscureText,
        controller: controller,
        focusNode: focusNode,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 207, 207, 245)
            )
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(180, 0, 17, 238)
            )
          ),

          fillColor: Colors.grey[200],
          filled: true,
          hintText: hintText,
          hintStyle: GoogleFonts.sora(
            color:Colors.grey[400]
          )
        ),
      ),
    );
  }
}