import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/view/screens/auth_views/login_screen.dart';
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
  final nameController = TextEditingController();
  bool isLoading = false;
  bool obscureText = true;
// username
  void signUp() async{
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    setState(() => isLoading = true);

   await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    )
        .then((userCredential) async{
          // mew function for insert data into firestore--primary key---document id
      //--current userid-------------
      String id= await FirebaseAuth.instance.currentUser!.uid;
          FirebaseFirestore.instance.collection('userdata').doc(id).set({
            'userName':nameController.text,
            'userId':id
          });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Sign Up Successful")),
      );
      Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
      //Navigator.pop(context);
    })
        .onError((error, stackTrace) {
      String errorMessage = "Something went wrong";

      if (error is FirebaseAuthException) {
        if (error.code == 'email-already-in-use') {
          errorMessage = "Email already exists.";
        } else if (error.code == 'invalid-email') {
          errorMessage = "Please enter a valid email.";
        } else if (error.code == 'weak-password') {
          errorMessage = "Password is too weak.";
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    })
        .whenComplete(() => setState(() => isLoading = false));
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe0f2f1),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 70),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            const Text(
              "Sign Up",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xff0A400C)),
            ),
            const SizedBox(height: 10),
            const Text("Create your account", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 30),
            TextFormField(
              controller: nameController,
              decoration: _inputDecoration("User Name"),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: emailController,
              decoration: _inputDecoration("Email"),
            ),
            const SizedBox(height: 20),

            TextFormField(
              controller: passwordController,
              obscureText: obscureText,
              decoration: _inputDecoration("Password").copyWith(
                suffixIcon: IconButton(
                  icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() => obscureText = !obscureText);
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            TextFormField(
              controller: confirmPasswordController,
              obscureText: obscureText,
              decoration: _inputDecoration("Confirm Password").copyWith(
                suffixIcon: IconButton(
                  icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() => obscureText = !obscureText);
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            GestureDetector(
              onTap: signUp,
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
                      : const Text("Sign Up", style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ),
            ),
            const SizedBox(height: 20),

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_back,color: Color(0xff0A400C),size: 20 ,),
                  SizedBox(width: 5,),
                  const Text("Back to Login", style: TextStyle(color: Color(0xff0A400C))),
                ],
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
}
