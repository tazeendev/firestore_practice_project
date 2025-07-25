import 'package:firebase_app/controller/utills/screen_sizes/media_quries.dart';
import 'package:flutter/material.dart';
class Dimensions{
  static getSmalSize(BuildContext context)=>GetMediaQuery.getWidth(context)*0.02;
  static getMediumSize(BuildContext context)=>GetMediaQuery.getWidth(context)*0.05;
  static getLargeSize(BuildContext context)=>GetMediaQuery.getWidth(context)*0.07;
}