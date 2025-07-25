import 'package:flutter/material.dart';
class GetMediaQuery{
  static getHeight(BuildContext context){
    return MediaQuery.of(context).size.height;
  }
  static getWidth(BuildContext context){
    return MediaQuery.of(context).size.width;
  }
}