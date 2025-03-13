import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomNavBar extends StatelessWidget {
  BottomNavBar({
    super.key,
    required this.onTabChange
    });

  void Function(int)? onTabChange;

  @override
  Widget build(BuildContext context) {
    return GNav(
        backgroundColor: const Color.fromRGBO(7, 42, 200, 1),
        color: Colors.white,
        activeColor: Colors.black,
        mainAxisAlignment: MainAxisAlignment.center,
        tabBorderRadius: 70,
        onTabChange: (value)=> onTabChange!(value),
        tabs: [
          GButton(
            icon: Icons.home,
            text: 'Home',
            textStyle: GoogleFonts.sora(
                color: Colors.white
              ),
            ),
          GButton(
            icon: Icons.flash_on,
            text: 'Flash',
            textStyle: GoogleFonts.sora(
                color: Colors.white
              ),
            ),
            GButton(
              icon: Icons.chat_sharp,
              text: 'Community',
              textStyle: GoogleFonts.sora(
                color: Colors.white
              ),
              ),

            GButton(
              icon: Icons.person,
              text: 'Profile',
              textStyle: GoogleFonts.sora(
                color: Colors.white
              ),
              ),
              
        ]
        );
  }
}