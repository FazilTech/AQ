import 'package:aq/components/input_box.dart';
import 'package:aq/components/my_button.dart';
import 'package:aq/services/authentication/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  final void Function() onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _auth = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();


  bool _animate = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 50), () {
      setState(() {
        _animate = true;
      });
    });
  }

  Future<void> register(context) async {
  if (_emailController.text.isEmpty ||
      _passwordController.text.isEmpty ||
      _confirmPasswordController.text.isEmpty ||
      _nameController.text.isEmpty) { 
    showErrorDialog("All fields are required.");
    return;
  }

  if (_passwordController.text != _confirmPasswordController.text) {
    showErrorDialog("Passwords do not match.");
    return;
  }

  showLoadingDialog();

  try {
    UserCredential userCredential = await _auth.signUpWithEmailAndPassword(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    String name = _nameController.text.trim();
    await _auth.createUserDocument(userCredential, name);

    if (mounted) {
      Navigator.pop(context); 
    }

    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    _nameController.clear();

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
      
  } catch (e) {
    if (mounted) {
      Navigator.pop(context); // Close loading dialog if an error occurs
      showErrorDialog(e.toString());
    }
  }
}


  void showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
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
                top: _animate ? -170 : -300,
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
                bottom: _animate ? -220 : -400,
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
                  const SizedBox(height: 100),
                  Padding(
                    padding: const EdgeInsets.only(top: 50, right: 230, left: 10),
                    child: Text(
                      "Register",
                      style: GoogleFonts.sora(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 51, 51, 51),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  inputField("User Name", "Enter User Name", false, _nameController),
                  inputField("Email", "Enter the email", false, _emailController),
                  inputField("Password", "Enter the password", true, _passwordController),
                  inputField("Confirm Password", "Re-enter the password", true, _confirmPasswordController),
                  const SizedBox(height: 5),
                  MyButton(
                    color: const Color.fromARGB(180, 0, 17, 238),
                    onTap: () => register(context),
                    text: "Register",
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: GoogleFonts.sora(color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          "Login Now",
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
