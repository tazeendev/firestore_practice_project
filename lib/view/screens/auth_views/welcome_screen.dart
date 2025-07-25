import 'package:firebase_app/controller/utills/routes.dart';
import 'package:firebase_app/controller/utills/screen_sizes/media_quries.dart';
import 'package:flutter/material.dart';
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final widthSize=GetMediaQuery.getWidth(context);
    final heightSize=GetMediaQuery.getHeight(context);
    return Scaffold(
      body: Stack(
        children: [
          Positioned(child: Image.asset('assets/images/plant.jpg',
            fit: BoxFit.cover,height:heightSize,width: widthSize,),),
          Positioned.fill(child: Container(
          color: Colors.black.withOpacity(0.3),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical:90.0,horizontal: 25.0),
              child: Column(
               // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      text: ' Welcome to Plantland',style: TextStyle(
                      color: Colors.white,fontSize: 25,fontWeight: FontWeight.w600
                    )
                    ),
                  ),
                  SizedBox(height: heightSize*0.01,),
                  Text(' A place where nature thrives! Discover a wide variety of plants  beautiful. Perfect for plant lovers!',style:
                  TextStyle(color: Color(0xff33372C)),),
                  Spacer(),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.pushNamed(context, Routes.login);
                        },
                        child: Container(
                          height: heightSize*0.06,
                          width: widthSize*0.4,
                          decoration: BoxDecoration(
                            color:Color(0xff557C56),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(child: Text('login',style: TextStyle(color: Colors.white),)),
                        ),
                      ),
                      SizedBox(width: widthSize*0.02,),
                      GestureDetector(
                        onTap: (){
                          Navigator.pushNamed(context, Routes.signup);
                        },
                        child: Container(
                          height: heightSize*0.06,
                          width: widthSize*0.4,
                          decoration: BoxDecoration(
                            color:Color(0xff557C56),
                            borderRadius: BorderRadiusDirectional.circular(5)
                          ),
                          child: Center(child: Text('signup',style: TextStyle(color: Colors.white),)),
                        ),
                      ),
                    ],
                  )

                ],
              ),
            ),
          ))
        ],
      ),
    );
  }
}
