import 'dart:math';

import 'package:add_dev_dolphin/Admin_Page/admin_main.dart';
import 'package:add_dev_dolphin/Local_Data/notification_database.dart';
import 'package:add_dev_dolphin/intro_screen/code_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../intro_screen/DrawerScreen.dart';
import '../main.dart';

//Admin Drawer Screen
class Admin_Drawer extends StatefulWidget {
  const Admin_Drawer({Key? key, required this.username, required this.password}) : super(key: key);
  final String username;
  final String password;
  @override
  State<Admin_Drawer> createState() => _Admin_DrawerState();
}

class _Admin_DrawerState extends State<Admin_Drawer> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  final zoomDrawerController = ZoomDrawerController();
  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      controller: zoomDrawerController,
      menuScreen: Admin_Menu_Drawer(username: widget.username, password: widget.password,),
      mainScreen: Admin_HomePage(username: widget.username, password: widget.password,),
      showShadow: false,
      borderRadius: 50,
      slideWidth: 200,
      shadowLayer1Color: Colors.white38,
      shadowLayer2Color: Colors.white60,
      angle: 0.0,
      menuBackgroundColor: Color.fromRGBO(8, 197, 110, 1),
    );
  }
}

//Admin Drawer Menu screen
class Admin_Menu_Drawer extends StatefulWidget {
  const Admin_Menu_Drawer({Key? key, required this.username, required this.password}) : super(key: key);
  final String username;
  final String password;
  @override
  State<Admin_Menu_Drawer> createState() => _Admin_Menu_DrawerState();
}
class _Admin_Menu_DrawerState extends State<Admin_Menu_Drawer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color.fromRGBO(8, 197, 110, 1),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SizedBox(
              height: sHeight(5, context),
            ),
            InkWell(
                onTap: (){
                  ZoomDrawer.of(context)!.close();
                },
                child: Image.asset("images/introscreen/nav_new.png",scale: 2,)),
            SizedBox(
              height: sHeight(5, context),
            ),
            InkWell(
              onTap: (){
                ZoomDrawer.of(context)!.close();
              },
              child: Container(
                height: sHeight(7, context),
                width: sWidth(50, context),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 147, 0,1),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Row(
                  children: [
                    Icon(Icons.home,color: Colors.white,),
                    SizedBox(
                      height: sWidth(8, context),
                    ),
                    Text('  Home',style: TextStyle(fontSize: 16,color: Colors.white),)
                  ],
                ),
              ),
            ),
            SizedBox(
              height: sHeight(2.5, context),
            ),
            InkWell(
                child: Container(
                  height: sHeight(7, context),
                  width: sWidth(50, context),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(8, 197, 110, 1),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.settings_suggest_outlined,color: Colors.white,),
                      Text('  Privacy Policy',style: TextStyle(fontSize: 15,color: Colors.white),)
                    ],
                  ),
                ),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>PrivacyPolicy()));
                  ZoomDrawer.of(context)!.close();
                }
            ),
            InkWell(
              child: Container(
                height: sHeight(7, context),
                width: sWidth(50, context),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(8, 197, 110, 1),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Row(
                  children: [
                    Icon(Icons.info,color: Colors.white,),
                    SizedBox(
                      height: sWidth(2, context),
                    ),
                    Text('  About Us',style: TextStyle(fontSize: 16,color: Colors.white),)
                  ],
                ),
              ),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> AboutUs()));
              },
            ),
          ],
        ),
      ),
    );
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