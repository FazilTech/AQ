import 'package:aq/components/input_box.dart';
import 'package:aq/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool _animate = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 50), ()=>{
      setState(() {
        _animate = true;
      })
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(seconds: 2),
            curve: Curves.easeOut,
            top: _animate ? -110 : -300,
            right: _animate ? -180 : -400,
            child: Container(
              height: 350,
              width: 350,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 207, 207, 245),
                shape: BoxShape.circle
              ),
            ),
          ),

          AnimatedPositioned(
            duration: const Duration(seconds: 2),
            curve: Curves.easeInOut,
            bottom: _animate ? -190 : -400,
            left: _animate ? -150 : -400,
            child: Container(
              height: 350,
              width: 350,
              decoration: const BoxDecoration(
                color: Color.fromARGB(180, 0, 17, 238),
                shape: BoxShape.circle
              ),
            ),
          ),

          Column(
            children: [
              const SizedBox(height: 100),
              Padding(
                padding: const EdgeInsets.only(top: 90, right: 300, left: 10),
                child: Text(
                  "Login",
                  style: GoogleFonts.sora(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 51, 51, 51),
                  ),
                ),
              ),

              const SizedBox(height: 50,),

              Padding(
                padding: const EdgeInsets.only(right: 315),
                child: Text(
                  "Email",
                  style: GoogleFonts.sora(
                    fontSize:19,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),

              InputBoxDecoration(
                hintText: "Enter the email",
                obscureText: false,
                controller: _emailController,
              ),

              Padding(
                padding: const EdgeInsets.only(right: 270),
                child: Text(
                  "Password",
                  style: GoogleFonts.sora(
                    fontSize:19,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),

              InputBoxDecoration(
                hintText: "Enter the password",
                obscureText: true,
                controller: _passwordController,
              ),

              Padding(
                padding: const EdgeInsets.only(left: 240),
                child: Text(
                  "forgot password?",
                  style: GoogleFonts.sora(
                    color: const Color.fromARGB(180, 0, 17, 238)
                  ),
                ),
              ),

              const SizedBox(height: 30,),

              GestureDetector(
                onTap: () => Navigator.pushReplacement(
                  context, MaterialPageRoute(
                    builder: (context) => const HomePage(),
                    )
                  ),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 160),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(180, 0, 17, 238),
                        Color.fromARGB(255, 207, 207, 245),
                      ]
                      ),
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Text(
                    "LogIn",
                    style: GoogleFonts.sora(
                      fontSize: 17,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't you have an account?",
                    style: GoogleFonts.sora(
                      color: Colors.grey[600]
                    ),
                  ),
                  const SizedBox(width: 5,),
                  Text( 
                    "Register Now",
                    style: GoogleFonts.sora(
                      color: const Color.fromARGB(180, 0, 17, 238),
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}