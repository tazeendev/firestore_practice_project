import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> login() async {
    try {
      setState(() => isLoading = true);
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login Successful")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe0f2f1), // Similar light green background
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50),

            // Title
            Text(
              "Hello!",
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Color(0xff0A400C)),
            ),
            Text("Welcome back", style: TextStyle(fontSize: 18, color: Colors.grey)),

            SizedBox(height: 30),

            // Email Field
            TextFormField(
              controller: emailController,
              decoration: _inputDecoration("Email"),
            ),
            SizedBox(height: 20),

            // Password Field
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: _inputDecoration("Password"),
            ),
            SizedBox(height: 10),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Forgot Password Logic
                },
                child: Text("Forgot Password?", style: TextStyle(color: Color(0xff0A400C))),
              ),
            ),

            SizedBox(height: 20),

            // Login Button
            GestureDetector(
              onTap: login,
              child: Container(
                width: double.infinity,
                height: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(colors: [Color(0xff819067), Color(0xff0A400C)]),
                ),
                child: Center(
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text("Login", style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ),
            ),

            SizedBox(height: 20),

            // OR Divider
            Row(
              children: [
                Expanded(child: Divider(color: Colors.grey)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text("Or login with"),
                ),
                Expanded(child: Divider(color: Colors.grey)),
              ],
            ),
            SizedBox(height: 15),

            // Social Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _socialIcon("assets/facebook.png"),
                _socialIcon("assets/google.png"),
                _socialIcon("assets/apple.png"),
              ],
            ),

            SizedBox(height: 30),

            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup'); // Navigate to Signup
                },
                child: Text("Don't have an account? Sign Up"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Color(0xff819067)),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xff819067)),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xff0A400C), width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _socialIcon(String path) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white, boxShadow: [
        BoxShadow(color: Colors.grey.shade300, blurRadius: 6, spreadRadius: 2),
      ]),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Image.asset(path),
      ),
    );
  }
}
