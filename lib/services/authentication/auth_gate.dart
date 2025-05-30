import 'package:aq/pages/home.dart';
import 'package:aq/pages/homee_page.dart';
import 'package:aq/services/authentication/login_or_register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: ((context, snapshot) {
          if(snapshot.hasData){
            return const Home();
            //return const Homen();
          }
          else{
            return const LoginOrRegister();
          }
        }
      )
    ),
    );
  }
}