import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool absecureText=false;

  Future<void> signUp() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    try {
      setState(() => isLoading = true);
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sign Up Successful")),
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
      backgroundColor: Color(0xffe0f2f1),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              Text(
                "Sign Up",
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff0A400C)),
              ),
              SizedBox(height: 10),
              Text("Create your account", style: TextStyle(color: Colors.grey)),

              SizedBox(height: 30),

              // Email
              TextFormField(
                controller: emailController,
                decoration: _inputDecoration("Email"),
              ),
              SizedBox(height: 20),

              // Password
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: _inputDecoration("Password"),
              ),
              SizedBox(height: 20),

              // Confirm Password
              TextFormField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: _inputDecoration("Confirm Password"),
              ),
              SizedBox(height: 20),

              // Sign Up Button
              GestureDetector(
                onTap: signUp,
                child: Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [Color(0xff819067), Color(0xff0A400C)],
                    ),
                  ),
                  child: Center(
                    child: isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text("Sign Up",
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                ),
              ),

              SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Back to Login"),
                ),
              ),
            ],
          ),
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
      suffixIcon: Icon(absecureText?Icons.visibility_off_outlined:Icons.visibility);
    );
  }
}
