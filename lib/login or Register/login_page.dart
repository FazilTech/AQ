import 'package:aq/components/input_box.dart';
import 'package:aq/components/my_button.dart';
import 'package:aq/services/authentication/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  final void Function() onTap;
  const LoginPage({super.key, required this.onTap});

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
    Future.delayed(const Duration(milliseconds: 50), () {
      setState(() {
        _animate = true;
      });
    });
  }

  void login(BuildContext context) async {
    final authService = AuthService();

    // Show loading dialog
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await authService.signInWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      if (mounted) Navigator.pop(context); // Close loading dialog
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        _emailController.clear();
        _passwordController.clear();
      }
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Login Failed"),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
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
                    shape: BoxShape.circle,
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
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Column(
                children: [
                  const SizedBox(height: 200),
                  Padding(
                    padding: const EdgeInsets.only(top: 50, right: 270, left: 10),
                    child: Text(
                      "Login",
                      style: GoogleFonts.sora(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 51, 51, 51),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  inputField("Email", "Enter the email", false, _emailController),
                  inputField("Password", "Enter the password", true, _passwordController),
                  const SizedBox(height: 30),
                  MyButton(
                    color: const Color.fromARGB(180, 0, 17, 238),
                    onTap: () => login(context),
                    text: "LogIn",
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: GoogleFonts.sora(color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          "Register Now",
                          style: GoogleFonts.sora(
                            color: const Color.fromARGB(180, 0, 17, 238),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget inputField(String label, String hintText, bool obscure, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 5),
          child: Text(
            label,
            style: GoogleFonts.sora(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        InputBoxDecoration(
          hintText: hintText,
          obscureText: obscure,
          controller: controller,
          radius: 0,
        ),
      ],
    );
  }
}
