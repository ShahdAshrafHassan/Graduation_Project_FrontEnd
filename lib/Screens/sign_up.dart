import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:ui'; 
import 'package:sign_in/Screens/sign_in_screen.dart';
import 'package:sign_in/url.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      var regBody = {
        "email": _emailController.text,
        "password": _passwordController.text
      };

      try {
        var response = await http.post(
          Uri.parse(registration),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration successful!')),
          );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const SignInScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${response.body}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Stack(
        children: [
          Background(), // Custom background
          Center(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                margin: const EdgeInsets.symmetric(vertical: 80),
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        "Join Us",
                        style: TextStyle(
                          fontSize: 45,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(67, 75, 213, 1),
                          fontFamily: 'Lobster',
                        ),
                      ),
                      const SizedBox(height: 30),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _buildTextField("Email", _emailController, Icons.email , ),
                            const SizedBox(height: 20),
                            _buildTextField("Password", _passwordController, Icons.lock, obscureText: _obscurePassword, toggleVisibility: _togglePasswordVisibility),
                            const SizedBox(height: 20),
                            _buildTextField("Confirm Password", _confirmPasswordController, Icons.lock, obscureText: _obscureConfirmPassword, toggleVisibility: _toggleConfirmPasswordVisibility),
                            const SizedBox(height: 40),
                            _buildButton("Register", Color.fromRGBO(67, 75, 213, 1)),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Already have an account?", style: TextStyle(color: Color.fromRGBO(67, 75, 213, 1), fontSize: 18)),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SignInScreen()));
                                  },
                                  child: const Text('Log in', style: TextStyle(color: Color.fromRGBO(67, 75, 213, 1), fontSize: 17)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            GestureDetector(
                              onTap: () {
                                // Handle Google Sign-Up functionality
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 15.0),
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(67, 75, 213, 1),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.g_mobiledata, color: Colors.white),
                                    SizedBox(width: 10),
                                    Text('Sign up with Google', style: TextStyle(fontSize: 18, color: Colors.white)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {bool obscureText = false, void Function()? toggleVisibility}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: Color.fromRGBO(67, 75, 213, 1)),
      decoration: InputDecoration(
         filled: true, 
         fillColor: Colors.white,
        labelText: label,
        labelStyle: const TextStyle(color: Color.fromRGBO(67, 75, 213, 1)),
        prefixIcon: Icon(icon, color: Color.fromRGBO(67, 75, 213, 1)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        suffixIcon: toggleVisibility != null
            ? IconButton(
                icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility, color: Color.fromRGBO(67, 75, 213, 1)),
                onPressed: toggleVisibility,
              )
            : null,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter $label';
        if (label == "Email" && !RegExp(r'^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+').hasMatch(value)) {
          return 'Enter a valid email';
        }
        if (label == "Confirm Password" && value != _passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }

  Widget _buildButton(String text, Color color) {
    return GestureDetector(
      onTap: _registerUser,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 80.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [color.withOpacity(0.8), color], begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Text(text, style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}


class Background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: WaveClipper(),
      child: Container(
        color: Colors.blueGrey,
        height: double.infinity,
        width: double.infinity,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color.fromRGBO(67, 75, 213, 1) ,
                const Color.fromARGB(0, 95, 132, 196) ,
                const  Color(0xFFF4F4F4) ,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 0);
    path.quadraticBezierTo(size.width / 4, size.height / 3, size.width / 2, size.height / 2);
    path.quadraticBezierTo(3 * size.width / 4, size.height - size.height / 3, size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
