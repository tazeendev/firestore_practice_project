// import 'package:flutter/material.dart';
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
// class _SplashScreenState extends State<SplashScreen> {
//   double _opacity = 0.0;
//   double _scale = 0.8;
//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(Duration(milliseconds: 100), () {
//       setState(() {
//         _opacity = 1.0;
//         _scale = 1.0;
//       });
//     });
//
//     Future.delayed(Duration(seconds: 5), () {
//       final authProvider = Provider.of<AuthProviders>(context, listen: false);
//
//       if (authProvider.user != null) {
//         if (authProvider.role == 'admin') {
//           Navigator.pushReplacement(
//               context, MaterialPageRoute(builder: (_) => AdminDashboard()));
//         } else {
//           Navigator.pushReplacement(
//               context, MaterialPageRoute(builder: (_) => StudentDashboard()));
//         }
//       } else {
//         Navigator.pushReplacement(
//             context, MaterialPageRoute(builder: (_) => OnboardingScreen()));
//       }
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           SizedBox(
//             height: double.infinity,
//             width:double.infinity,
//             child: Image.asset(
//               'assets/splash.jpeg',
//               fit: BoxFit.cover,
//             ),
//           ),
//           Center(
//             child: AnimatedOpacity(
//               duration: const Duration(seconds: 2),
//               opacity: _opacity,
//               child: AnimatedScale(
//                 scale: _scale,
//                 duration: const Duration(seconds: 2),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const Text(
//                       'Welcome!',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 28,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     TextButton(
//                       onPressed: () {
//                         print("Hello");
//                       },
//                       style: TextButton.styleFrom(
//                         backgroundColor: Colors.black54,
//                       ),
//                       child: const Text(
//                         'Continue',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
