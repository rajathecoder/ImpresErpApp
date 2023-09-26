import 'dart:async';
import 'package:add_dev_dolphin/LocalDb/DatabaseHelper.dart';
import 'package:add_dev_dolphin/intro_screen/code_screen.dart';
import 'package:add_dev_dolphin/intro_screen/staffdrawer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class logo_screen extends StatefulWidget {
  const logo_screen({Key? key, required this.userName, required this.password }) : super(key: key);
  final String userName;
  final String password;


  @override
  State<logo_screen> createState() => logo_screenState();
}

class logo_screenState extends State<logo_screen> {


  static const String KEYLOGIN = "login";

  static const String USERKEY = "intro";

  static const String PASSKEY = "pass";

  static const String UserIdentity = "useridentity";

  static const String CollCode = "CollCode";


  @override
  void initState(){
    super.initState();
    dbInitlize();
    whereToGo();
  }
  dbInitlize() async {
    await DatabaseHelper.initDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              SizedBox(
                height: 300,
                width: 300,
                child: Image.asset('images/introscreen/front_logo.png'),
              ),
              Image.asset("images/introscreen/loading.gif",height: sHeight(15, context),),
            ],
          ),
        ),
      ),
    );
  }

  void whereToGo() async {
    var sharedPref = await SharedPreferences.getInstance();
    var isLoggedIn = sharedPref.getBool("KEYLOGIN");
    Timer(const Duration(seconds: 3),(){
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context)=> const code_screen()));

    });
  }

}

double sHeight(double per, BuildContext context){
  double h = MediaQuery.of(context).size.height;
  return h * per / 100;
}

double sWidth(double per, BuildContext context){
  double w = MediaQuery.of(context).size.width;
  return w * per / 100;
}