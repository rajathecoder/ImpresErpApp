import 'package:add_dev_dolphin/Data/Student_Data.dart';
import 'package:add_dev_dolphin/Style_font/designs.dart';
import 'package:add_dev_dolphin/main.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';

Widget StudentLogin() => DelayedDisplay(
  slidingCurve: Curves.linear,
  delay: Duration(seconds: 1),
  child:   Container(

      margin: EdgeInsets.only(top: 50.0),

        width: 200,

        height: 70,

        decoration: PrimaryRoundBox(),

        child: Center(
          child: Text("Student Login", style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.w500)),
        ),

      ),
);

Widget StaffLogin() => DelayedDisplay(
  slidingCurve: Curves.linear,
  delay: Duration(seconds: 2),
  child:   Container(
    margin: EdgeInsets.only(top: 20.0),
    width: 200,
    height: 70,
    decoration: PrimaryRoundBox(),
    child: Center(
      child: Text("Staff Login", style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.w500)),
    ),
  ),
);


String image = 'https://pbs.twimg.com/profile_images/1170313858700865539/GQb9y9md_400x400.jpg';

Widget WelcomeImage (BuildContext context)=> Container(
  child: ShortImagedisplay(img, MediaQuery.of(context).size.height /1.1, 200),
);

void SetImage(String CallImage){
  img = CallImage;
}

// http://impreserp.co.in/images/impreslogo.jpg Dolphin

// https://pbs.twimg.com/profile_images/1170313858700865539/GQb9y9md_400x400.jpg VETIAS