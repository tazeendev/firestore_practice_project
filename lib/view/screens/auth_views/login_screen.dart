import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_app/controller/utills/routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  bool obscureText = true;

  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter email and password")),
      );
      return;
    }

    try {
      setState(() => isLoading = true);
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login Successful")),
      );

      Navigator.pushNamed(context, '/welcome'); // Navigate after login
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Something went wrong";
      if (e.code == 'user-not-found') {
        errorMessage = "No user found for this email.";
      } else if (e.code == 'wrong-password') {
        errorMessage = "Incorrect password.";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
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
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe0f2f1),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            const Text(
              "Hello!",
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Color(0xff0A400C)),
            ),
            const Text("Welcome to Plantland", style: TextStyle(fontSize: 18, color: Colors.grey)),

            const SizedBox(height: 30),

            // Email Field
            TextFormField(
              controller: emailController,
              decoration: _inputDecoration("Email"),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),

            // Password Field
            TextFormField(
              controller: passwordController,
              obscureText: obscureText,
              decoration: _inputDecoration("Password").copyWith(
                suffixIcon: IconButton(
                  icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      obscureText = !obscureText;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text("Forgot Password?", style: TextStyle(color: Color(0xff0A400C))),
              ),
            ),
            const SizedBox(height: 20),

            // Login Button
            GestureDetector(
              onTap: login,
              child: Container(
                width: double.infinity,
                height: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(colors: [Color(0xff819067), Color(0xff0A400C)]),
                ),
                child: Center(
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Login", style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // OR Divider
            Row(
              children: const [
                Expanded(child: Divider(color: Colors.grey)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text("Or login with"),
                ),
                Expanded(child: Divider(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 15),

            // Social Icons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _socialIcon("assets/images/google.png"),
                _socialIcon("assets/images/facebook.png"),
                _socialIcon("assets/images/apple.png"),
              ],
            ),
            const SizedBox(height: 30),

            // Signup Link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
                const SizedBox(width: 3),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.signup);
                  },
                  child: const Text(" Signup", style: TextStyle(color: Color(0xff0A400C), fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xff819067)),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xff819067)),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xff0A400C), width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _socialIcon(String path) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.grey.shade300, blurRadius: 6, spreadRadius: 2),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Image.asset(path),
      ),
    );
  }
}
