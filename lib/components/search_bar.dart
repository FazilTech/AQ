import 'package:aq/components/input_box.dart';
import 'package:flutter/material.dart';

class MySearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Icon preFixIcon;
  final String hintText;
  const MySearchBar({
    super.key,
    required this.controller,
    required this.hintText,
    required this.preFixIcon
    });

  @override
  Widget build(BuildContext context) {
    return Expanded(
       child:Container(
         decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(20),
           boxShadow: const[
             BoxShadow(
               blurRadius: 6, 
               spreadRadius: -23, 
               offset: Offset(0, 16),
             )
           ]
         ),
         child: InputBoxDecoration(
                 hintText: hintText,
                 obscureText: false,
                 controller: controller,
                 icon: preFixIcon,
                 radius: 20,
               ),
       ),
    );
  }
}