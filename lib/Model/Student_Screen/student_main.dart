import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:add_dev_dolphin/Local_Data/notification_database.dart';
import 'package:add_dev_dolphin/Model/Student_Screen/student_notification.dart';
import 'package:add_dev_dolphin/Model/Student_Screen/student_sc_1.dart';
import 'package:add_dev_dolphin/main.dart';
import 'package:add_dev_dolphin/Data/Staff_Data.dart';
import 'package:add_dev_dolphin/Data/Student_Data.dart';
import 'package:add_dev_dolphin/Style_font/designs.dart';
import 'package:add_dev_dolphin/UI/main_ui.dart';
import 'package:badges/badges.dart' as badges;
import 'package:badges/badges.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'student_screen_changes.dart';
import 'package:http/http.dart' as http;
double sHeight(double per, BuildContext context){
  double h = MediaQuery.of(context).size.height;
  return h * per / 100;
}

double sWidth(double per, BuildContext context){
  double w = MediaQuery.of(context).size.width;
  return w * per / 100;
}
class StudentHomePage extends StatefulWidget {
  const StudentHomePage({Key? key, required this.username, required this.password}) : super(key: key);
  final String username;
  final String password;

  @override
  _StudentHomePageState createState() => _StudentHomePageState();

}
class _StudentHomePageState extends State<StudentHomePage> {
  late Future <Data_List> APIData;
  late Future <ModuleData_List> ModuleAPIData;
  late LocalAuthentication auth = LocalAuthentication();
  late bool _canCheckBiometric = false;
  late List<BiometricType> _availableBiometrics = [];
  late String _authorized = "Not Authorized";
  bool _enableBiometric = false;
  TimeOfDay selectedTime = TimeOfDay.now();
  String? Gn = 'Good Night';
  String? Gm = "Good Morning";
  String? GA = "Good Afternoon";
  String? Ge = "Good Evening";
  bool Gni = false;
  bool Gmi = false;
  bool GAi = false;
  bool Gei = false;
   check_greeting()async{
      if(selectedTime.hour == 20 ||
          selectedTime.hour == 21 ||
          selectedTime.hour == 22 ||
          selectedTime.hour == 23 ||
          selectedTime.hour == 00 ||
          selectedTime.hour == 01 ||
          selectedTime.hour == 02 ||
          selectedTime.hour == 03 ){
      Gni = true;
      }
      else if(selectedTime.hour == 04 ||
          selectedTime.hour == 05 ||
          selectedTime.hour == 06 ||
          selectedTime.hour == 07 ||
          selectedTime.hour == 08 ||
          selectedTime.hour == 09 ||
          selectedTime.hour == 10 ||
          selectedTime.hour == 11
      ){
        // SetSetupDone(true);
        Gmi = true;
      }
      else if(selectedTime.hour == 12 ||
          selectedTime.hour == 13||
          selectedTime.hour == 14||
          selectedTime.hour == 15||
          selectedTime.hour == 16
      ){
       GAi = true;
      }
      else if(selectedTime.hour == 17 ||
          selectedTime.hour == 18 ||
          selectedTime.hour == 19
      ){
       Gei = true;
      }
   }
  late ConnectivityResult results;
  late StreamSubscription subscription;
  checkInternet()async{
    results = await Connectivity().checkConnectivity();
    if(results != ConnectivityResult.none){
      isConnected = true;
    }
    else{
      isConnected = false;
      showDialogbox();
    }
    setState(() {

    });
  }
  showDialogbox(){
    showDialog(
      barrierDismissible: false,
        context: context, builder: (context)=> CupertinoAlertDialog(
      title: Text("No Internet"),
      content: Text("Please check your Internet Connection and Try Again"),
      actions: [
        CupertinoButton.filled(child: Text("OK"), onPressed: (){
          Navigator.pop(context);
          Navigator.pop(context);
        }),
      ],
    ));
  }
  startStreaming(){
    subscription = Connectivity().onConnectivityChanged.listen((event)async {
      checkInternet();
    });
  }
  Future <void> _checkBiometric()async{
    bool canCheckBiometric = false;
    try{
      canCheckBiometric = await auth.canCheckBiometrics;
    } on PlatformException catch(e){
      print("Checking Biometric $e");
    }
    if(!mounted) return;
    setState(() {
      _canCheckBiometric = canCheckBiometric;
    });
  }
  DateTime now = DateTime.now();
  String? Link,Link1;
  int? sp1;
  SaveBool()async{
    final prefs = await SharedPreferences.getInstance();
    int? changFC1 = 1;
    await prefs.setInt('changefcm', changFC1);
  }
  ChangeBool()async{
    final prefs = await SharedPreferences.getInstance();
    int? changFC = 2;
    prefs.setInt('changefcm', changFC);
    print("changed");
  }
  ReadBool()async{
    final prefs = await SharedPreferences.getInstance();
    sp1 = await prefs.getInt('changefcm');
    print("-c--c-c--c-c${sp1}");
    if(sp1 == null || sp1 == 1.toInt()){
      Add_Token_Database();
      print("saved FCM in Data Base");
    }
    else{
      print("enough");
    }
  }
  Add_Token_Database()async{
    FirebaseMessaging.instance.getToken().then((newtoken){
      print(newtoken);
      // Map<String,String>dataTosave={
      //   'FCM' : newtoken.toString(),
      //   'user': Position,
      //   'Studentcode': Staff_Code,
      //   'Generated Time': DateFormat('dd/MM/yyyy').add_jm().format(now),
      // };
      // CollectionReference collectionRef = FirebaseFirestore.instance.collection('64641');
      // collectionRef.add(dataTosave);
      // FirebaseFirestore.instance.collection('user_list').add(dataTosave);
    });
  }/*
  Widget _shoppingCartBadge() {
    return
      badges.Badge(
      position: BadgePosition.topEnd(top: 6, end: 6),
      badgeAnimation: BadgeAnimation.slide(),
        badgeStyle: KLK > 0 ? badges.BadgeStyle(badgeColor: Colors.green,borderGradient: BadgeGradient.radial(colors: [Colors.blue,Colors.yellow])):badges.BadgeStyle(badgeColor: Colors.red,borderGradient: BadgeGradient.radial(colors: [Colors.blue,Colors.yellow])),
        // Text(
      //   "${KLK}",
      //   style: TextStyle(color: Colors.white),
      // ),
      child: IconButton(icon: Icon(Icons.notifications), onPressed: ()async {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Student_Notification_screen()));
        // Delete_Count();
        setState((){});
      }),
    );
  }*/
  Widget Attendance_Widget(){
    return InkWell(
        child: Container(
          margin: EdgeInsets.all(8),
          width: MediaQuery.of(context).size.width / 2.4,
          height: 80,
          decoration: PrimaryRoundBox1(),
          child: Row(
            children: [
              SizedBox(width: sWidth(3, context),),
              Image.asset("images/introscreen/attendance.png",scale: 3,),
              SizedBox(width: sWidth(2, context),),
              Center(
                child: Text("Attendance", style: SecondaryText1()),
              ),
            ],
          ),
        ),
        onTap: (){
          checkInternet();
          Navigator.push(context, MaterialPageRoute(builder: (context)=> StudentAttendance(username: widget.username, password: widget.password,)));
        }
    );
  }
  Widget InterNal_Widget(){
    return InkWell(
        child: Container(
          margin: EdgeInsets.all(8),
          width: MediaQuery.of(context).size.width / 2.4,
          height: 80,
          decoration: PrimaryRoundBox1(),
          child: Row(
            children: [
              SizedBox(width: sWidth(3, context),),
              Image.asset("images/introscreen/internal_mark.png",scale: 3,),
              SizedBox(width: sWidth(2, context),),
              Center(
                child: Text("Internal\nMarks", style: SecondaryText1()),
              ),
            ],
          ),
        ),
        onTap: () {
          checkInternet();
          Navigator.push(context, MaterialPageRoute(builder:
              (BuildContext context) =>
              StudentInternalMark(username: widget.username,
                password: widget.password,)));
          print(isConnected);
        }
    );
  }
  Widget TimeTable_Widget(){
    return  InkWell(
        child: Container(
          margin: EdgeInsets.all(8),
          width: MediaQuery.of(context).size.width / 2.4,
          height: 80,
          decoration: PrimaryRoundBox1(),
          child: Row(
            children: [
              SizedBox(width: sWidth(3, context),),
              Image.asset("images/introscreen/time_table.png",scale: 3,),
              SizedBox(width: sWidth(2, context),),
              Center(
                child: Text("Time Table", style: SecondaryText1()),
              ),
            ],
          ),
        ),
        onTap: (){
          checkInternet();
          Navigator.push(context, MaterialPageRoute(builder: (context)=> StudentsTimetable(username: widget.username, password: widget.password,)));
        }
    );
  }
  Widget University_Widget(){
    return  InkWell(
        child: Container(
          margin: EdgeInsets.all(8),
          width: MediaQuery.of(context).size.width / 2.4,
          height: 80,
          decoration: PrimaryRoundBox1(),
          child: Row(
            children: [
              SizedBox(width: sWidth(3, context),),
              Image.asset("images/introscreen/university_marksheet.png",scale: 3,),
              SizedBox(width: sWidth(2, context),),
              Center(
                child: Text("University\nMarksheets", style: SecondaryText1(), textAlign: TextAlign.left,),
              ),
            ],
          ),
        ),
        onTap: (){
          Navigator.push(context, MaterialPageRoute
            (builder: (context)=> Homepage3(username: widget.username, password: widget.password,)));
        }
    );
  }
  Widget Circular_Widget(){
    return InkWell(
        child: Container(
          margin: EdgeInsets.all(8),
          width: MediaQuery.of(context).size.width / 2.4,
          height: 80,
          decoration: PrimaryRoundBox1(),
          child: Row(
            children: [
              SizedBox(width: sWidth(3, context),),
              Image.asset("images/introscreen/circular.png",scale: 3,),
              SizedBox(width: sWidth(2, context),),
              Center(
                child: Text("Circulars", style: SecondaryText1()),
              ),
            ],
          ),
        ),
        onTap: (){
          checkInternet();
          Navigator.push(context, MaterialPageRoute(builder: (context)=> StudentCircular(username: widget.username, password: widget.password,)));}
    );}
  Widget Holidays_Widget(){
    return  InkWell(
        child: Container(
          margin: EdgeInsets.all(8),
          width: MediaQuery.of(context).size.width / 2.4,
          height: 80,
          decoration: PrimaryRoundBox1(),
          child: Row(
            children: [
              SizedBox(width: sWidth(3, context),),
              Image.asset("images/introscreen/holidays.png",scale: 3,),
              SizedBox(width: sWidth(2, context),),
              Center(
                child: Text("Holidays", style: SecondaryText1()),
              ),
            ],
          ),
        ),
        onTap: (){
          checkInternet();
          Navigator.push(context, MaterialPageRoute(builder: (context)=> StudentHoliday(username: widget.username, password: widget.password,)));}
    );
  }
  Widget FeeDetails_Widget(){
    return InkWell(
        child: Container(
          margin: EdgeInsets.all(8),
          width: MediaQuery.of(context).size.width / 2.4,
          height: 80,
          decoration: PrimaryRoundBox1(),
          child: Row(
            children: [
              SizedBox(width: sWidth(3, context),),
              Image.asset("images/introscreen/dcb.png",scale: 3,),
              SizedBox(width: sWidth(2, context),),
              Center(
                child: Text("Fee\nDetails", style: SecondaryText1(), textAlign: TextAlign.left,),
              ),
            ],
          ),
        ),
        onTap: (){
          checkInternet();
          Navigator.push
            (context, MaterialPageRoute(builder:
              (context)=> HomePage2
            (username: widget.username, password: widget.password,)));}
    );}
  Widget Library_Widget(){
    return InkWell(
        child: Container(
          margin: EdgeInsets.all(8),
          width: MediaQuery.of(context).size.width / 2.4,
          height: 80,
          decoration: PrimaryRoundBox1(),
          child: Row(
            children: [
              SizedBox(width: sWidth(3, context),),
              Image.asset("images/introscreen/Library_transaction.png",scale: 3,),
              SizedBox(width: sWidth(2, context),),
              Center(
                child: Text("Library", style: SecondaryText1(), textAlign: TextAlign.center,),
              ),
            ],
          ),
        ),
        onTap: (){
          checkInternet();
          Navigator.push(context, MaterialPageRoute(builder: (context)=>
              HomePage1(username: widget.username, password: widget.password,)));}
    );}
  Widget Internship_Widget(){
    return InkWell(
        child: Container(
          margin: EdgeInsets.all(8),
          width: MediaQuery.of(context).size.width / 2.4,
          height: 80,
          decoration: PrimaryRoundBox1(),
          child: Row(
            children: [
              SizedBox(width: sWidth(3, context),),
              Image.asset("images/introscreen/interview.png",scale: 4,),
              SizedBox(width: sWidth(2, context),),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Internship", style: SecondaryText1(), textAlign: TextAlign.left,),
                  Text("(Coming Soon)", style: PrimaryText3Small(),overflow: TextOverflow.ellipsis),
                ],
              ),
            ],
          ),
        ),
        onTap: (){}
    );}
  Widget JObs_Widget(){
    return  InkWell(
        child: Container(
          margin: EdgeInsets.all(8),
          width: MediaQuery.of(context).size.width / 2.4,
          height: 80,
          decoration: PrimaryRoundBox1(),
          child: Row(
            children: [
              SizedBox(width: sWidth(3, context),),
              Image.asset("images/introscreen/jobs.png",scale: 4,),
              SizedBox(width: sWidth(2, context),),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Jobs", style: SecondaryText1(),),
                  Text("(Coming Soon)", style: PrimaryText3Small(),overflow: TextOverflow.ellipsis),
                ],
              ),
            ],
          ),
        ),
        onTap: (){
        }
    );}
  Widget Resume_Widget(){
    return InkWell(
        child: Container(
          margin: EdgeInsets.all(8),
          width: MediaQuery.of(context).size.width / 2.4,
          height: 80,
          decoration: PrimaryRoundBox1(),
          child: Row(
            children: [
              SizedBox(width: sWidth(3, context),),
              Image.asset("images/introscreen/resume.png",scale: 4,),
              SizedBox(width: sWidth(2, context),),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: sWidth(25, context),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Create Your Resume\n", style: SecondaryText1(),maxLines: 2,overflow: TextOverflow.ellipsis),
                          Text("(Coming Soon)", style: PrimaryText3Small(),overflow: TextOverflow.ellipsis),
                        ],
                      )),
                ],
              ),
            ],
          ),
        ),
        onTap: (){}
    );}
  Widget Certificate_Widget(){
    return InkWell(
        child: Container(
          margin: EdgeInsets.all(8),
          width: MediaQuery.of(context).size.width / 2.4,
          height: 80,
          decoration: PrimaryRoundBox1(),
          child: Row(
            children: [
              SizedBox(width: sWidth(3, context),),
              Image.asset("images/admin_image/certi_req.png",scale: 4,),
              SizedBox(width: sWidth(2, context),),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: sWidth(25, context),
                      child: Text("Certificate Request   ", style: SecondaryText1(),maxLines: 2,overflow: TextOverflow.ellipsis)),
                ],
              ),
            ],
          ),
        ),
        onTap: (){
          checkInternet();
          Navigator.push(context, MaterialPageRoute(builder: (context)=>
              Certificate_Request(username: widget.username, password: widget.password,)));
        }
    );}
 late List <String> status = [];
  late List Get_Attendance_HS_LIST=[];
  GET_At()async{
    final resp = await http.get(
        Uri.parse("http://${ip}/api/AppSetting?InstId=1"));
    if (resp.statusCode == 200){
      Get_Attendance_HS_LIST = json.decode(resp.body);
      String Attenparse = Get_Attendance_HS_LIST[0]['AttendanceHour'];
      AttendanceHou = int.parse(Attenparse);
      print(AttendanceHou);
    }
    else{
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GET_At();
    ReadBool();
    ChangeBool();
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async{
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        if (notification != null && android != null) {
          final String? title = message.notification?.title;
          final String? body = message.notification?.body;
          final String? date = DateFormat.yMMMMd().add_jm().format(message.sentTime as DateTime);
          message.data['openURL'].toString().length > 3 ?   Link = message.data['openURL'] : Link = '';
          setState(() {
            refreshNotes();
          });
          await DatabaseHandler()
              .inserttodo(todo(
              title: title!,
              description: body!,
              Date: date.toString(),
              URL: Link!,
              id: Random().nextInt(50)));
          // showDialog(
          //     context: context,
          //     builder: (_) {
          //       return AlertDialog(
          //         title: Text(notification.title!),
          //         content: SingleChildScrollView(
          //           child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [Text(notification.body!),Text(message.sentTime.toString())],
          //           ),
          //         ),
          //      );
          //   }
          // );
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  channelDescription: channel.description,
                  playSound: true,
                  icon: '@mipmap/ic_launcher',
                  // colorized: true,
                  color: Colors.pink,
                ),
              ));
        }
      });
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
        print('A new onMessageOpenedApp event was published!');
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        if (notification != null && android != null) {
          final String? title1 = message.notification?.title;
          final String? body1 = message.notification?.body;
          final String? date1 = DateFormat.yMMMMd().add_jm().format(message.sentTime as DateTime);
          message.data['openURL'].toString().length > 3 ?   Link1 = message.data['openURL'] : Link1 = '';
           await refreshNotes();
          await DatabaseHandler()
              .inserttodo(todo(
              title: title1!,
              description: body1!,
              Date: date1.toString(),
              URL: Link1!,
              id: Random().nextInt(50)));
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  channelDescription: channel.description,
                  playSound: true,
                  color: Colors.transparent,
                  icon: '@mipmap/ic_launcher',
                ),
              ));
          late String? title = message.notification?.title;
          late String? body = message.notification?.body;
          if(title.toString() == "Circular".toString()){
            // Navigator.push(context, MaterialPageRoute(builder: (context)=>Circular_Page()));
          }
          // else{
          //   showDialog(
          //       context: context,
          //       builder: (_) {
          //         return AlertDialog(
          //           title: Text(notification.title!),
          //           content: SingleChildScrollView(
          //             child: Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [Text(notification.body!),Text(message.sentTime.toString())],
          //             ),
          //           ),
          //         );
          //       });
          // }
        }
      });
    check_greeting();
    Network network = Network("billing?RollNum=${widget.username}&Password=${widget.password}");
    APIData = network.loadData();
    ModuleNetwork Modulenetwork = ModuleNetwork("menu?instid=1");
    ModuleAPIData = Modulenetwork.ModuleloadData();
    checkInternet();
    refreshNotes();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: APIData,
        builder: (context, AsyncSnapshot<Data_List> snapshot){
          if (snapshot.hasError){
            return Scaffold(
              backgroundColor: Colors.white,
              body: Center(child: WrongDataLottie(context),),
            );
          }
          else
            {
              List <API_data> data;
              if(snapshot.hasData){
                data = snapshot.data!.data_list;
                if (data.length > 0){
                  return FutureBuilder(
                    future: ModuleAPIData,
                      builder: (context, AsyncSnapshot<ModuleData_List> Modulesnapshot){
                        if(Modulesnapshot.hasError){
                          ErrorShowingWidget(context);
                        }
                        List <ModuleAPI_data> Moduledata;
                      if(Modulesnapshot.hasData){
                        Moduledata = Modulesnapshot.data!.Moduledata_list;
                        if(snapshot.hasData) {
                          for (int i = 0; i <= Moduledata.length - 1; i++) {
                            if (Moduledata[i].MenuName[Moduledata[i].MenuName
                                .length - 1] == 's') {
                              status.add("${Moduledata[i].Status}${Moduledata[i]
                                  .MenuName}");
                            }
                          }
                           // print(status);
                          return WillPopScope(
                            onWillPop: () async => _onBackButtonPressed(context),
                            child: Scaffold(
                              backgroundColor:  Color.fromRGBO(242, 249, 250, 0.9),
                              body: Builder(
                                  builder: (BuildContext context) => ListView(
                                    scrollDirection: Axis.vertical,
                                    children: <Widget>[
                                      Stack(
                                        children:[
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                  child: Image.asset("images/introscreen/bg_overlay.png")),
                                            ],
                                          ),
                                          Container(
                                          width: MediaQuery.of(context).size.width,
                                          child:
                                          SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: Column(
                                              children: [
                                                SizedBox(height: sHeight(3, context),),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    InkWell(
                                                      onTap: (){
                                                        // print(user);
                                                        if (ZoomDrawer.of(context)!.isOpen())
                                                        {
                                                          ZoomDrawer.of(context)!.close();
                                                        }
                                                        else {
                                                          ZoomDrawer.of(context)!.open();
                                                        }
                                                      },
                                                      child: Container(
                                                        margin: EdgeInsets.only(left: 15),
                                                        child: Image.asset("images/introscreen/nav_bar.png",width: sWidth(8, context),),
                                                      ),
                                                    ),
                                                    Image.asset("images/admin_image/logo.png",),
                                                    //_shoppingCartBadge(),
                                                    Container(
                                                      child: CircleAvatar(
                                                        backgroundImage: NetworkImage("${img}"),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: sHeight(3, context),),
                                                Row(
                                                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Gei?
                                                        Container(
                                                          width: sWidth(40, context),
                                                          child: Text("${Ge.toString()},",textAlign: TextAlign.left, maxLines: 1,
                                                              overflow: TextOverflow.ellipsis,style: TextStyle(color:
                                                              Colors.black54,fontWeight: FontWeight.w900,fontSize: 20)),
                                                        ):new Container(),
                                                        GAi?
                                                        Container(
                                                          width: sWidth(40, context),
                                                          child: Text("${GA.toString()},",textAlign: TextAlign.left, maxLines: 1,
                                                              overflow: TextOverflow.ellipsis,style: TextStyle(color:
                                                              Colors.black54,fontWeight: FontWeight.w900,fontSize: 18)),
                                                        ):new Container(),
                                                        Gmi?
                                                        Container(
                                                          width: sWidth(40, context),
                                                          child: Text("${Gm.toString()},",textAlign: TextAlign.left, maxLines: 1,
                                                              overflow: TextOverflow.ellipsis,style: TextStyle(color:
                                                              Colors.black54,fontWeight: FontWeight.w900,fontSize: 18)),
                                                        ):new Container(),
                                                        Gni?
                                                        Container(
                                                          width: sWidth(40, context),
                                                          child: Text("${Gn.toString()},",textAlign: TextAlign.left, maxLines: 1,
                                                              overflow: TextOverflow.ellipsis,style: TextStyle(color:
                                                              Colors.black54,fontWeight: FontWeight.w900,fontSize: 18)),
                                                        ):new Container(),
                                                        Container(
                                                          width: sWidth(40, context),
                                                          child: Text('${data[0].StudentName}',textAlign: TextAlign.left, maxLines: 1,
                                                              overflow: TextOverflow.ellipsis , style: TextStyle(fontWeight:
                                                              FontWeight.w900,fontSize: 20,color: Colors.red)),
                                                        ),
                                                        Container(
                                                          width: sWidth(40, context),
                                                          child: Text('${data[0].RollNum.toUpperCase()}',textAlign: TextAlign.left, maxLines: 1,
                                                              overflow: TextOverflow.ellipsis ,  style: TextStyle(fontWeight:
                                                              FontWeight.w900,fontSize: 20,color: Colors.deepPurple)),
                                                        ),
                                                        Container(
                                                          width: sWidth(40, context),
                                                          child: Text('${data[0].CourseFullName}',textAlign: TextAlign.left, maxLines: 1,
                                                              overflow: TextOverflow.ellipsis ,  style: TextStyle(fontWeight:
                                                              FontWeight.w900,fontSize: 20,color: Colors.black54)),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(width: sWidth(5, context),),
                                                    Container(
                                                    height: sHeight(20, context),
                                                    decoration: BoxDecoration(
                                                    ),
                                                    child: Stack(
                                                      children:[
                                                        ClipRRect(
                                                          borderRadius: BorderRadius.all(Radius.circular(15),),
                                                          child:  Stack(
                                                              children: [
                                                                Center(child: CircularProgressIndicator()),
                                                                Image.network("${StudentImageIP}${data[0].Picture}",scale: 1,)
                                                              ])),
                                                          ],
                                                    ),
                                                      ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        ]
                                      ),
                                      GridView.count(
                                        // primary: true,
                                        crossAxisCount: 2,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        childAspectRatio: 2,
                                        children: [
                                          if(status.contains("1Attendance - Students"))
                                            Attendance_Widget(),
                                          if(status.contains("1Internal Marks - Students"))
                                            InterNal_Widget(),
                                          if(status.contains("1Time Table - Students"))
                                           TimeTable_Widget(),
                                          if(status.contains("1University Marks - Students"))
                                           University_Widget(),
                                          if(status.contains("1Circular - Students"))
                                            Circular_Widget(),
                                          if(status.contains("1Holiday - Students"))
                                           Holidays_Widget(),
                                          if(status.contains("1DCB- Students"))
                                            FeeDetails_Widget(),
                                          if(status.contains("1OPAC - Students"))
                                           Library_Widget(),
                                          if(status.contains("1Certificate Request - Students"))
                                            Certificate_Widget(),
                                          if(status.contains("1Internship - Students"))
                                           Internship_Widget(),
                                          if(status.contains("1Jobs - Students"))
                                           JObs_Widget(),
                                          if(status.contains("1Create Resume - Students"))
                                          Resume_Widget(),
                                        ],
                                      ),
                                      Container(
                                        height: sHeight(5, context),
                                      ),
                                    ],
                                  )
                              ),
                            ),
                          );
                        }
                        else{
                          return Scaffold(
                            appBar: AppBar(
                              leading: InkWell(
                                child: LeedingProfile(data[0].Picture),
                                onTap:  () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => StudentProfileImage(
                                          image: data[0].Picture,
                                          username: data[0].StudentName,
                                        ))),
                              ),
                              title: Text(data[0].StudentName, style: PrimaryText(context)),
                              centerTitle: true,
                              backgroundColor: PrimaryColor(),
                            ),
                            body: Builder(
                                builder: (BuildContext context) => ListView(
                                  children: <Widget>[
                                    Center(
                                        child: Text(
                                          "Oops... Something went wrong.\nPlease try again later",
                                          style: ErrorText2Big(),
                                          textAlign: TextAlign.center,
                                        ))
                                  ],
                                )),
                          );
                        }
                      }
                      else{
                        return Container(child: Center(child: CircularProgressIndicator()), color: Colors.white,);
                      }
                      });
                }
                else{
                  return Scaffold(
                    backgroundColor: Colors.white,
                    appBar: AppBar(
                      title: Text("Login", style: PrimaryText(context)),
                      centerTitle: true,
                      backgroundColor: PrimaryColor(),
                      actions: <Widget>[
                      ],
                    ),
                    body: Container(child: WrongDataLottie(context),),
                  );
                }
              }
              else{
                return Scaffold(
                    backgroundColor: Colors.white,
                    body: Container(child: Center(child: EnterScreenLoadLottie(context)), color: Colors.white,));
              }
            }
        });
  }

  void UnsavePass()async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('savePass', false);
    prefs.setBool('useStudentBiometric', false);
    SetSavePass(false);
    SetStaffsavePass(false);
    SetuseStudentBiometric(false);
    SetuseStaffBiometric(false);
  }

  void GetBiometric()async{
    final prefs = await SharedPreferences.getInstance();
    _enableBiometric = prefs.getBool('useStudentBiometric') ?? false;
    SetuseStudentBiometric(_enableBiometric);

  }

  void DisableBiometric()async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('useStudentBiometric', false);
    SetuseStudentBiometric(false);
  }

  Widget Toggle(bool Savetext){
    if(Savetext == true){
      return Icon(Icons.toggle_on_outlined, color: Colors.white, size: 45,);
    }
    else{
      return Icon(Icons.toggle_off_outlined, color: Colors.white70, size: 45,);
    }
  }

  _onBackButtonPressed(BuildContext context) async {
    if(Platform.isAndroid){
      SystemNavigator.pop();
    };
  }

}

