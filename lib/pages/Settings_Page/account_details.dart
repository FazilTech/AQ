import 'package:aq/login%20or%20Register/login_page.dart';
import 'package:aq/services/authentication/auth_gate.dart';
import 'package:aq/services/authentication/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountDetails extends StatelessWidget {
  const AccountDetails({super.key});

  @override
  Widget build(BuildContext context) {
    AuthService _auth =  AuthService();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Account Details",
          style: GoogleFonts.sora(
            fontWeight: FontWeight.bold
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await _auth.signOut();

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AuthGate()),
              );
            },
            icon: const Icon(Icons.logout)
            )
        ],
      ),

      

      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {},
            child: Container(
                margin: const EdgeInsets.only(left: 2, right: 2),
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.person,
                      size: 35,
                      color: Colors.black,
                    ),
                    const SizedBox(width: 20,),
                    Text(
                      "Personal Details",
                      style: GoogleFonts.sora(
                        fontSize: 20,
                        color: Colors.black
                      ),
                    )
                  ],
                ),
              ),
          ),
        ],
      ),
    );
  }
}