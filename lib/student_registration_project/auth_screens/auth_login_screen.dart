import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FormLoginScreen extends StatefulWidget {
  const FormLoginScreen({super.key});

  @override
  State<FormLoginScreen> createState() => _FormLoginScreenState();
}
class _FormLoginScreenState extends State<FormLoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  void login() {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill the email and password')),
      );
      return;
    }
    setState(() => isLoading = true);

    FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    )
        .then((userCredential) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Login successful')));
      Navigator.pushNamed(context, '/signin_form');
    })
        .onError((error, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    })
        .whenComplete(() => setState(() => isLoading = false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Stack(
          children: [
            // 🔹 Header (fixed 200)
            Container(
              height: 200,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              decoration: BoxDecoration(
                color: Color(0xff113F67),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(35),
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hello",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Welcome Back!",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.only(top: 150, left: 20, right: 20, bottom: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Login Account",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Enter your email and password to continue",
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 20),

                      // Email
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: "Your Email Address",
                          prefixIcon: const Icon(Icons.email,color:Color(0xff113F67)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Password",
                          prefixIcon: const Icon(Icons.lock,color:Color(0xff113F67)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: true,
                                onChanged: (value) {},
                                activeColor: Color(0xff113F67),
                              ),
                              const Text("Save Password"),
                            ],
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              "Forgot Password?",
                              style: TextStyle(color: Colors.redAccent),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff113F67),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: login,
                          child: isLoading
                              ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                              : const Text(
                            "Login Account",
                            style: TextStyle(
                              color:Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Color(0xff113F67)!),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/signin_form');
                          },
                          child: Text(
                            "Create New Account",
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xff113F67),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
