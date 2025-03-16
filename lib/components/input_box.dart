import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InputBoxDecoration extends StatelessWidget {
  const InputBoxDecoration({
    super.key,
    this.focusNode,
    this.icon,
    required this.radius,
    required this.hintText,
    required this.obscureText,
    required this.controller
    });

  final FocusNode? focusNode;
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final Icon? icon;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: TextField(
        obscureText: obscureText,
        controller: controller,
        focusNode: focusNode,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 207, 207, 245),
            ),
            borderRadius: BorderRadius.circular(radius)
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(180, 0, 17, 238)
            )
          ),

          fillColor: const Color.fromRGBO(240, 240, 245, 1),
          filled: true,
          hintText: hintText,
          hintStyle: GoogleFonts.sora(
            color:Colors.grey[700]
          ),
          prefixIcon: icon,
        ),
      ),
    );
  }
}