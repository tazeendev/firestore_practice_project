import 'package:flutter/material.dart';
class NextScreen extends StatefulWidget {
  const NextScreen({super.key});

  @override
  State<NextScreen> createState() => _NextScreenState();
}

class _NextScreenState extends State<NextScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFDCDC),
      body:  Center(
        child: Text('Success',style:
        TextStyle(color: Color(0xffC71E64),fontSize: 40,fontWeight: FontWeight.bold),),
      ),
    );

  }
}
