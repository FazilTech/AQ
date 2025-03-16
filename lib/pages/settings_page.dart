import 'package:aq/pages/Settings_Page/account_details.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(240, 240, 245, 1),
      appBar: AppBar(
        title: Text(
          "Settings",
          style: GoogleFonts.sora(
            fontWeight: FontWeight.bold,
          ),
          ),
      ),

      body: Column(
        children: [
          GestureDetector(
            onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context) => AccountDetails(),)),
            child: Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.manage_accounts,
                    size: 35,
                  ),
                  const SizedBox(width: 20,),
                  Text(
                    "Account Details",
                    style: GoogleFonts.sora(
                      fontSize: 20
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}