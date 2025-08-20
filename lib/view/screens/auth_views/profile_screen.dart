import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBar(
  actions: [
    IconButton(onPressed: ()async{
      await FirebaseAuth.instance.signOut();
      // navigate to logon screen-----------
    }, icon: Icon(Icons.logout))
  ],
),
    );
  }
}
