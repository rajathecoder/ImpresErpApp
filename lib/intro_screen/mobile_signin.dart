import 'package:add_dev_dolphin/Style_font/designs.dart';
import 'package:flutter/material.dart';
class Signin_Buttons extends StatefulWidget {
  const Signin_Buttons({Key? key}) : super(key: key);

  @override
  State<Signin_Buttons> createState() => _Signin_ButtonsState();
}

class _Signin_ButtonsState extends State<Signin_Buttons> {
  Color change = Colors.grey;
  Color Change1 = Colors.red;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: sHeight(30, context),),
          InkWell(
            onTap: (){

            },
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(15),
                height: sHeight(10, context),
                width: sWidth(80, context),
                decoration: const BoxDecoration(
                  color: Color(0xFF08C56E),
                  borderRadius: BorderRadius.all(Radius.circular(10),),
                ),
                child: Row(
                  children: [
                   Image.asset("images/intro_img/mobilr_number.png"),
                    SizedBox(width: sWidth(4, context),),
                    const Text("Login With Mobile Number",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700,color: Colors.white),),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: sHeight(6, context),),
          Center(
            child: Container(
              padding: const EdgeInsets.all(15),
              height: sHeight(10, context),
              width: sWidth(80, context),
              decoration: BoxDecoration(
                color: const Color(0xFFC5C5C5),
                borderRadius: const BorderRadius.all(Radius.circular(10),),
                border: Border.all(color: Colors.black),
              ),
              child: Row(
                children: [
                 Image.asset("images/intro_img/google_login.png"),
                  SizedBox(width: sWidth(4, context),),
                  const Text("Continue With Google",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700,color: Colors.white),),
                ],
              ),
            ),
          ),
          SizedBox(height: sHeight(6, context),),
        ],
      ),
    );
  }
}
