import 'dart:async';
import 'dart:math';
import 'package:add_dev_dolphin/Data/Staff_Data.dart';
import 'package:add_dev_dolphin/Data/Student_Data.dart';
import 'package:add_dev_dolphin/Local_Data/notification_database.dart';
import 'package:add_dev_dolphin/Model/Login_Screen/login_body.dart';
import 'package:add_dev_dolphin/intro_screen/code_screen.dart';
import 'package:add_dev_dolphin/intro_screen/logoscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
bool Xnt = false;
bool chk = false;
bool temp = false;
bool show = false;
String IPGet = '';
String img = '';
String? log_type;
String? StudentImageIP;
String? StaffImageIP;
String? ManagementImageIP;
bool LogB = false;
String userName = "";
String password = "";
String? UserID;
bool Mresult = false;
String Muser = '';
String Mpass = '';
bool MIdentity = false;
String MCode = '';
String MLogCode()=> MCode;
bool MLogIdentity()=> MIdentity;
bool MLogin()=> Mresult;
String MLogUser()=> Muser;
String MLogPass()=> Mpass;
int Stu = 0;
int Ste = 0;
bool Serve = false;
String?Link3,LinkSta1;
int KLK = 0;
String? Cer_MSG;
int? AttendanceHou;
refreshNotes() async {
  KLK = (await DatabaseHandler().getCount())!;
  print("-x--x-x-x--x-x$KLK");
}
final DarwinInitializationSettings initializationSettings = DarwinInitializationSettings();
const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
    'This channel is used for important notifications.', // description
    importance: Importance.high,
    ledColor: Colors.red,
    playSound: true);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
 print('A bg message just showed up :  ${message.messageId}');
 RemoteNotification? notification = message.notification;
 AndroidNotification? android = message.notification?.android;
 if (notification != null && android != null) {
  final String? title3 = message.notification?.title;
  final String? body3 = message.notification?.body;
  final String? date3= DateFormat.yMMMMd().add_jm().format(message.sentTime as DateTime);
  message.data['openURL'].toString().length > 3 ?   Link3 = message.data['openURL'] : Link3 = '';
   await refreshNotes();
  await DatabaseHandler().inserttodo(todo(
      title: title3!,
      description: body3!,
      Date: date3.toString(),
      URL: Link3!,
      id: Random().nextInt(50)));
  flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        // android: AndroidNotificationDetails(
        //   channel.id,
        //   channel.name,
        //   channelDescription: channel.description,
        //   color: Colors.red,
        //   playSound: true,
        //  icon: '@mipmap/ic_launcher',
        // ),
        iOS:  DarwinNotificationDetails(),
      ));
 }
}


 Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized();
   final prefs = await SharedPreferences.getInstance();
   await Firebase.initializeApp();
   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  IPGet = prefs.getString('IPAddress')?? '';
  Mresult = prefs.getBool(logo_screenState.KEYLOGIN) ?? false;
  MIdentity = prefs.getBool(logo_screenState.UserIdentity) ?? false;
  Muser = prefs.getString(logo_screenState.USERKEY) ?? 'No User';
  Mpass = prefs.getString(logo_screenState.PASSKEY) ?? 'No Pass';
  MCode = prefs.getString(logo_screenState.CollCode) ?? 'No Code';
  SetStudentIP(IPGet);
  SetStaffIP(IPGet);
  SetImage(img);
  show = prefs.getBool('SetupDone') ?? false;
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    // home: show ? const Login() : /*SetupScreen()*/ logo_screen(),
    home: show ? const code_screen() : /*SetupScreen()*/ logo_screen(userName: userName, password: password,),
  ));
}

/*
* For complete project: Login
* For Student login only: StudentLoginMain
* For Staff Login only: StaffLoginMain
* For Student data testing: StudentLoginCheck
* For Staff data testing: StaffLoginCheck
* Student Login Sample UserID: username:'20COA01' ,password:'20/05/2003'
* Staff Login Sample UserID: username:'21fm21' ,password:'DolphinAdmin123!@#'
*/


