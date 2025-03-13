import 'package:flutter/material.dart';

class IconContainer extends StatelessWidget {
  final Function()? onTap;
  final Icon icon;
  const IconContainer({
    super.key,
    required this.onTap,
    required this.icon
    });

  @override
  Widget build(BuildContext context) {
      return Container(
              decoration: BoxDecoration(
                color: const Color.fromRGBO(0, 53, 102, 1),
                borderRadius: BorderRadius.circular(30)
              ),
              child: IconButton(
                onPressed: onTap, 
                icon: icon,
                color: Colors.white,
              ),
        );
  }
}