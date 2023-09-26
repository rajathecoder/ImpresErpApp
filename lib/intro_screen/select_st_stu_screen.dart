import 'package:add_dev_dolphin/Data/Student_Data.dart';
import 'package:add_dev_dolphin/Model/Login_Screen/login_body.dart';
import 'package:add_dev_dolphin/intro_screen/login_student.dart';
import 'package:add_dev_dolphin/main.dart';
import 'package:flutter/material.dart';

class Selection_Screen extends StatefulWidget {
  const Selection_Screen({
    Key? key,
  }) : super(key: key);

  @override
  State<Selection_Screen> createState() => _Studentstaff_screenState();
}

class _Studentstaff_screenState extends State<Selection_Screen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              SizedBox(
                height: sHeight(2.5, context),
              ),
              const Center(
                child: Text(
                  'Select Your',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "METHOD TO",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                  ),
                  SizedBox(
                    width: sWidth(5, context),
                  ),
                  const Text(
                    "LOGIN",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: Colors.red),
                  ),
                ],
              ),
              SizedBox(
                height: sHeight(2.5, context),
              ),
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.white60,
                child: Stack(
                  children: [
                    const Center(child: CircularProgressIndicator()),
                    WelcomeImage(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

double sHeight(double per, BuildContext context) {
  double h = MediaQuery.of(context).size.height;
  return h * per / 100;
}

double sWidth(double per, BuildContext context) {
  double w = MediaQuery.of(context).size.width;
  return w * per / 100;
}
