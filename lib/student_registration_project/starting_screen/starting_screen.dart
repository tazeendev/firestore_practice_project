import 'dart:async';
import 'package:firebase_app/student_registration_project/auth_screens/auth_sigin_screen.dart';
import 'package:firebase_app/student_registration_project/home_screen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../auth_screens/auth_login_screen.dart';

class SplashScreen2 extends StatefulWidget {
  const SplashScreen2({super.key});
  @override
  State<SplashScreen2> createState() => _SplashScreen2State();
}

class _SplashScreen2State extends State<SplashScreen2>
    with TickerProviderStateMixin {
  late AnimationController logoController;
  late Animation<double> logoAnimation;
  late AnimationController textController;
  late Animation<double> textAnimation;
  @override
  void initState() {
    super.initState();
    logoController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 6),
    );
    logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: logoController, curve: Curves.easeOutBack),
    );
    logoController.forward();
    textController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    textAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: textController, curve: Curves.easeIn));
    textController.forward();
//-------------------current user logic --------------------------
    Timer(const Duration(seconds: 4), () {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => RegisterUser()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CreateAccountScreen()),
        );
      }
    });
  }
  @override
  void dispose() {
    logoController.dispose();
    textController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.indigo],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: logoAnimation,
                child: Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(
                    Icons.school,
                    size: 80,
                    color: Color(0xff113F67),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FadeTransition(
                opacity: textAnimation,
                child:  Text(
                  "Student Registration",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              FadeTransition(
                opacity: textAnimation,
                child: const Text(
                  "Register • Manage • Learn",
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
              ),
              const SizedBox(height: 40),
              const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 6,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
