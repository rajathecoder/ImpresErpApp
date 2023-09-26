import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:add_dev_dolphin/Model/Staff_Screen/Staff_screen_c_2.dart';
import 'package:add_dev_dolphin/Model/Staff_Screen/staff_screen_c_1.dart';
import 'package:badges/badges.dart' as badges;
import 'package:add_dev_dolphin/Data/Staff_Data.dart';
import 'package:add_dev_dolphin/Local_Data/notification_database.dart';
import 'package:add_dev_dolphin/Model/Staff_Screen/staff_notification.dart';
import 'package:add_dev_dolphin/Style_font/designs.dart';
import 'package:add_dev_dolphin/UI/main_ui.dart';
import 'package:add_dev_dolphin/main.dart';
import 'package:badges/badges.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'staff_screen_changes.dart';
import 'package:http/http.dart' as http;


class StaffHomePage extends StatefulWidget {
  const StaffHomePage({Key? key, required this.username, required this.password,/* required this.staffID, required this.StaffAPI*/}) : super(key: key);
  final String username;
  final String password;
/*  final String staffID;
  final StaffAPI_data StaffAPI;*/

  @override
  _StaffHomePageState createState() => _StaffHomePageState();
}

class _StaffHomePageState extends State<StaffHomePage> {
  late Future <StaffData_List> APIData;
  //late StaffAPI_data StaffAPI = widget.StaffAPI;
  late Future <ModuleData_List> ModuleAPIData;
  late LocalAuthentication auth = LocalAuthentication();
  late bool _canCheckBiometric = false;
  late List<BiometricType> _availableBiometrics = [];
  late String _authorized = "Not Authorized";
  bool _enableBiometric = false;
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
  Future <void> _getAvailableBiometrics() async{
    List <BiometricType> availableBiometrics = [];
    try{
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch(e){
      print('Getting available biometrics $e');
    }
    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }
  Future <void> _authenticate() async {
    bool authorized = false;
    try{
      authorized = await auth.authenticate(
        localizedReason: 'Scan your finger to authenticate',
      );
    } on PlatformException catch (e){
      print('Authentication error $e');
        showDialog(context: context, builder: (context)=> AlertDialog(
        title: Text('Oops!!!', style: PrimaryText2(), textAlign: TextAlign.start,),
        content: Text('No Biometrics found!', style: SecondaryText2(), textAlign: TextAlign.center,),
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: const EdgeInsets.only(left: 30, right: 30, bottom: 15),
        actions: [
          InkWell(
            child: SizedBox(
              child: Text('Ok', style: PrimaryText2(), textAlign: TextAlign.center,),
              width: 200,
            ),
            onTap: ()=> Navigator.pop(context),
          ),
        ],
        elevation: 20.0,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
      ));
    }
    if(!mounted) return;
    setState(() {
      _authorized = authorized ? "Authenrized Success" : "Failed to authenticate";
      print("Authorized : $_authorized");
    });

    if(authorized){
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('useStaffBiometric', true);
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
  TimeOfDay selectedTime = TimeOfDay.now();
  String? Gn = 'Good Night';
  String? Gm = "Good Morning";
  String? GA = "Good Afternoon";
  String? Ge = "Good Evening";
  bool Gni = false;
  bool Gmi = false;
  bool GAi = false;
  bool Gei = false;
  String? Newtoken_FCM;
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
          title: const Text("No Internet"),
          content: const Text("Please check your Internet Connection and Try Again"),
          actions: [
        CupertinoButton.filled(child: const Text("OK"), onPressed: (){
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
  int? sp2;
  String? LinkSta1,LinkSta2;
  SaveBool()async{
    final prefs = await SharedPreferences.getInstance();
    int? changFC1 = 1;
    await prefs.setInt('changefcmSta', changFC1);
  }
  ChangeBool()async{
    final prefs = await SharedPreferences.getInstance();
    int? changFC = 2;
    prefs.setInt('changefcmSta', changFC);
    print("changed");
  }
  ReadBool()async{
    final prefs = await SharedPreferences.getInstance();
    sp2 = await prefs.getInt('changefcmSta');
    print("-c--c-c--c-c$sp2");
    if(sp2 == null || sp2 == 1.toInt()){
      Add_Token_Database();
      print("saved FCM in Data Base");
    }
    else{
      print("enough");
    }
  }
  SendToken()async{
    if (1.toInt() == 1.toInt()){
      final resp = await http.get(
          Uri.parse("http://$StaticIP/api/StaffFcm?StaffCode=${widget.username}&FcmId=$Newtoken_FCM&Password=${widget.password}"));
      print("fcm Send Successfully");
    }
    else{
    }
  }
  Add_Token_Database()async{
    FirebaseMessaging.instance.getToken().then((newtoken){
      print(newtoken);
      Newtoken_FCM = newtoken;
      SendToken();
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
  }
  Widget _shoppingCartBadge() {
    return
      badges.Badge(
        position: BadgePosition.topEnd(top: -10, end: 3),
        badgeAnimation: const BadgeAnimation.slide(),
        //badgeContent: Text("$KLK",style: const TextStyle(color: Colors.white),),
        badgeStyle: KLK > 0 ?
        //badgeStyle: count > 0 ?
        const badges.BadgeStyle(badgeColor: Colors.red,):
        const badges.BadgeStyle(badgeColor: Colors.transparent),
        child:  InkWell(
          child: Container(
            margin: const EdgeInsets.only(right: 5),
            child: CircleAvatar(
              backgroundImage: NetworkImage("$img"),
            ),
          ),
          /*onTap: ()async{
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Staff_Notification_screen()));
            // Delete_Count();
            setState((){});
          },*/
        ),/*IconButton(icon: Icon(Icons.notifications), onPressed: ()async {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Staff_Notification_screen()));
          // Delete_Count();
          setState((){});
        }),*/
      );
  }
  late List Get_Attendance_HS_LIST=[];
  GET_At()async{
    final resp = await http.get(
        Uri.parse("http://$ip/api/AppSetting?InstId=1"));
    if (resp.statusCode == 200){
      Get_Attendance_HS_LIST = json.decode(resp.body);
      String Attenparse = Get_Attendance_HS_LIST[0]['AttendanceHour'];
      AttendanceHou = int.parse(Attenparse);
      print("$AttendanceHou");
    }
    else{
    }
  }
  late List Get_Badge_Count=[];
  int? Counts = 0;
  Get_Notifi_Badge_Count()async{
    final resp = await http.get(
      Uri.parse("http://$StaticIP/api/StaffInboxBadge?StaffCode=${widget.username}&Password=${widget.password}&InstId=1&LoadType=1"), // server login url
    );
    if (resp.statusCode == 200){
      Get_Badge_Count = json.decode(resp.body);
      Counts = Get_Badge_Count[0]['count'];
      setState(() {});
    }
    else{
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get_Notifi_Badge_Count();
    GET_At();
    ReadBool();
    ChangeBool();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async{
      print("two");
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        final String? title = message.notification?.title;
        final String? body = message.notification?.body;
        final String? date = DateFormat.yMMMMd().add_jm().format(message.sentTime as DateTime);
        message.data['openURL'].toString().length > 3 ?   LinkSta1 = message.data['openURL'] : LinkSta1 = '';
        await refreshNotes();
        await DatabaseHandler()
            .inserttodo(todo(
            title: title!,
            description: body!,
            Date: date.toString(),
            URL: LinkSta1!,
            id: Random().nextInt(100)));
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
                color: Colors.green,
              ),
            ));
      }
    });
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    //   print('A new onMessageOpenedApp event was published!');
    //   RemoteNotification? notification = message.notification;
    //   AndroidNotification? android = message.notification?.android;
    //   if (notification != null && android != null) {
    //     final String? title1 = message.notification?.title;
    //     final String? body1 = message.notification?.body;
    //     final String? date1 = DateFormat.yMMMMd().add_jm().format(message.sentTime as DateTime);
    //     message.data['openURL'].toString().length > 3 ?   LinkSta2 = message.data['openURL'] : LinkSta2 = '';
    //     await refreshNotes();
    //     await DatabaseHandler()
    //         .inserttodo(todo(
    //         title: title1!,
    //         description: body1!,
    //         Date: date1.toString(),
    //         URL: LinkSta2!,
    //         id: Random().nextInt(50)));
    //     flutterLocalNotificationsPlugin.show(
    //         notification.hashCode,
    //         notification.title,
    //         notification.body,
    //         NotificationDetails(
    //           android: AndroidNotificationDetails(
    //             channel.id,
    //             channel.name,
    //             channelDescription: channel.description,
    //             playSound: true,
    //             color: Colors.yellow,
    //             icon: '@mipmap/ic_launcher',
    //           ),
    //         ));
    //   }
    // });
    StaffNetwork network = StaffNetwork("StaffInfo?StaffCode=${widget.username.toLowerCase()}&Password=${widget.password}");
    APIData = network.StaffloadData();
    ModuleNetwork Modulenetwork = ModuleNetwork("menu?instid=1");
    ModuleAPIData = Modulenetwork.ModuleloadData();
    _checkBiometric();
    _getAvailableBiometrics();
    check_greeting();
    refreshNotes();
    checkInternet();
  }
  @override
  Widget build(BuildContext context) {
    GetBiometric();
    return FutureBuilder(
        future: APIData,
        builder: (context, AsyncSnapshot<StaffData_List> snapshot){
          if (snapshot.hasError)
          {
            return Scaffold(
              appBar: AppBar(
                title: Text("Login", style: PrimaryText(context)),
                centerTitle: true,
                backgroundColor: PrimaryColor(),
                actions: <Widget>[
                  InkWell(
                    child: Container(
                      margin: const EdgeInsets.only(right: 20.0),
                      child: const Icon(Icons.settings_power),
                    ),
                    onTap: () {
                      UnsavePass();
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
              body: Center(child: StaffMainError(context),),
            );
          }
          else
          {
            List <StaffAPI_data> data;
            if(snapshot.hasData){
              data = snapshot.data!.Staffdata_list;
              refreshNotes();
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
                        if(Moduledata.length >0){
                          List <String> status = [];
                          for (int i = 0; i<= Moduledata.length-1; i++){
                            if(Moduledata[i].MenuName[Moduledata[i].MenuName.length-1] == 'f'){
                              status.add("${Moduledata[i].Status}${Moduledata[i].MenuName}");
                            }
                          }
                          // print(status.length);
                          // print(status);
                          return WillPopScope(
                              onWillPop: () => _onBackButtonPressed(context),
                              child:Scaffold(
                                backgroundColor:  const Color.fromRGBO(242, 249, 250, 0.9),
                                body: Builder(
                                    builder: (BuildContext context) => SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Column(
                                        children: <Widget>[
                                          Stack(
                                              children:[
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Container(
                                                        child: Image.asset("images/introscreen/staff_bvg.png")),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context).size.width,
                                                  child:
                                                  SingleChildScrollView(
                                                    scrollDirection: Axis.vertical,
                                                    child: Column(
                                                      children: [
                                                        SizedBox(height: sHeight(4, context),),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            InkWell(
                                                              onTap: (){
                                                                if (ZoomDrawer.of(context)!.isOpen())
                                                                {
                                                                  ZoomDrawer.of(context)!.close();
                                                                }
                                                                else {
                                                                  ZoomDrawer.of(context)!.open();
                                                                }
                                                              },
                                                              child: Container(
                                                                padding: const EdgeInsets.all(15),
                                                                child: Image.asset("images/introscreen/nav_bar.png",width: sWidth(8, context),),
                                                              ),
                                                            ),
                                                            Image.asset("images/admin_image/logo.png",),
                                                            _shoppingCartBadge(),
                                                            /*Container(
                                                          margin: EdgeInsets.only(right: 15),
                                                          child: CircleAvatar(
                                                            backgroundImage: NetworkImage("${img}"),
                                                          ),
                                                        ),*/
                                                          ],
                                                        ),
                                                        SizedBox(height: sHeight(3, context),),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                          children: [
                                                            Column(
                                                              children: [
                                                                Gei?
                                                                SizedBox(
                                                                  width: sWidth(40, context),
                                                                  child: Text("${Ge.toString()},",textAlign: TextAlign.left, maxLines: 1,
                                                                      overflow: TextOverflow.ellipsis,style: const TextStyle(color:
                                                                      Colors.black54,fontWeight: FontWeight.w900,fontSize: 18)),
                                                                ):Container(),
                                                                GAi?
                                                                SizedBox(
                                                                  width: sWidth(40, context),
                                                                  child: Text("${GA.toString()},",textAlign: TextAlign.left, maxLines: 1,
                                                                      overflow: TextOverflow.ellipsis,style: const TextStyle(color:
                                                                      Colors.black54,fontWeight: FontWeight.w900,fontSize: 18)),
                                                                ):Container(),
                                                                Gmi?
                                                                SizedBox(
                                                                  width: sWidth(40, context),
                                                                  child: Text("${Gm.toString()},",textAlign: TextAlign.left, maxLines: 1,
                                                                      overflow: TextOverflow.ellipsis,style: const TextStyle(color:
                                                                      Colors.black54,fontWeight: FontWeight.w900,fontSize: 18)),
                                                                ):Container(),
                                                                Gni?
                                                                SizedBox(
                                                                  width: sWidth(40, context),
                                                                  child: Text("${Gn.toString()},",textAlign: TextAlign.left, maxLines: 1,
                                                                      overflow: TextOverflow.ellipsis,style: const TextStyle(color:
                                                                      Colors.black54,fontWeight: FontWeight.w900,fontSize: 16)),
                                                                ):Container(),
                                                                SizedBox(
                                                                  width: sWidth(40, context),
                                                                  child: Text('${data[0].StaffName},',textAlign: TextAlign.left, maxLines: 1,
                                                                      overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight:
                                                                      FontWeight.w900,fontSize: 16,color: Colors.red)),
                                                                ),
                                                                SizedBox(
                                                                  width: sWidth(40, context),
                                                                  child: Text('${data[0].Designation}',textAlign: TextAlign.left, maxLines: 1,
                                                                      overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight:
                                                                      FontWeight.w400,fontSize: 13,color: Colors.black)),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(width: sWidth(5, context),),
                                                            SizedBox(
                                                              height: sHeight(20, context),
                                                              // width: sWidth(20, context),
                                                              child: ClipRRect(
                                                                  borderRadius: const BorderRadius.all(Radius.circular(15),),
                                                                  child:
                                                                  Stack(
                                                                      children: [
                                                                        //Center(child: CircularProgressIndicator()),
                                                                        Image.network("$StaffImageIP${data[0].StaffImg}",scale: 1,fit: BoxFit.cover)
                                                                      ])),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(width: sWidth(10, context),),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ]
                                          ),
                                          GridView.count(
                                            crossAxisCount: 2,
                                            shrinkWrap: true,
                                            physics: const NeverScrollableScrollPhysics(),
                                            childAspectRatio: 2,
                                            children: [
                                              if(status.contains("1Staff Attendance - Staff"))
                                                InkWell(
                                                  child: Container(
                                                    margin: const EdgeInsets.all(8),
                                                    width: MediaQuery.of(context).size.width / 2.4,
                                                    height: 80,
                                                    decoration: PrimaryRoundBox1(),
                                                    child: Row(
                                                      children: [
                                                        SizedBox(width: sWidth(3, context),),
                                                        Image.asset("images/introscreen/staff_attendance.png",scale: 1.5,),
                                                        SizedBox(width: sWidth(2, context),),
                                                        Center(
                                                          child: Text("My\nAttendance", style: SecondaryText1()),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  onTap: (){
                                                    checkInternet();
                                                    Navigator.push(context, MaterialPageRoute(builder: (context)=> StaffAttendaceRecord(
                                                      staffID: widget.password, StaffAPI: data[0], Date: DateTime.now(),)));
                                                  },
                                                ),
                                              if(status.contains("1Students Attendance - Staff"))
                                                InkWell(
                                                  child: Container(
                                                    margin: const EdgeInsets.all(8),
                                                    width: MediaQuery.of(context).size.width / 2.4,
                                                    height: 80,
                                                    decoration: PrimaryRoundBox1(),
                                                    child: Row(
                                                      children: [
                                                        SizedBox(width: sWidth(3, context),),
                                                        Image.asset("images/introscreen/sstudent_attendance.png",scale: 1.5,),
                                                        SizedBox(width: sWidth(2, context),),
                                                        Center(
                                                          child: Text("Students\nAttendance", style: SecondaryText1()),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  onTap: (){
                                                    checkInternet();
                                                    Navigator.push(context, MaterialPageRoute(builder: (context)=> StaffAttendanceTimetable(staffID: widget.password, StaffAPI: data[0])));
                                                  },
                                                ),
                                              if(status.contains("1Lesson Plan - Staff"))
                                                InkWell(
                                                  child: Container(
                                                    margin: const EdgeInsets.all(8),
                                                    width: MediaQuery.of(context).size.width / 2.4,
                                                    height: 80,
                                                    decoration: PrimaryRoundBox1(),
                                                    child:
                                                    Row(
                                                      children: [
                                                        SizedBox(width: sWidth(3, context),),
                                                        Image. asset("images/introscreen/note_of_lesson.png",scale: 1.5,),
                                                        SizedBox(width: sWidth(2, context),),
                                                        Center(
                                                          child: Text("Notes of\nLesson", style: SecondaryText1()),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  onTap: (){
                                                    checkInternet();
                                                    Navigator.push(context, MaterialPageRoute(builder: (context)=> StaffLessonPlan(staffID: widget.password, StaffAPI: data[0])));
                                                  },
                                                ),
                                              if(status.contains("1Circular - Staff"))
                                                InkWell(
                                                  child: Container(
                                                    margin: const EdgeInsets.all(8),
                                                    width: MediaQuery.of(context).size.width / 2.4,
                                                    height: 80,
                                                    decoration: PrimaryRoundBox1(),
                                                    child: Row(
                                                      children: [
                                                        SizedBox(width: sWidth(3, context),),
                                                        Image.asset("images/introscreen/scircular.png",scale: 1.5,),
                                                        SizedBox(width: sWidth(2, context),),
                                                        Center(
                                                          child: Text("Circular", style: SecondaryText1()),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  onTap: (){
                                                    checkInternet();
                                                    Navigator.push(context, MaterialPageRoute(builder: (context)=> StaffCircular(staffID: widget.password, StaffAPI: data[0])));
                                                  },
                                                ),
                                              if(status.contains("1OPAC - Staff"))
                                                InkWell(
                                                  child: Container(
                                                    margin: const EdgeInsets.all(8),
                                                    width: MediaQuery.of(context).size.width / 2.4,
                                                    height: 80,
                                                    decoration: PrimaryRoundBox1(),
                                                    child: Row(
                                                      children: [
                                                        SizedBox(width: sWidth(3, context),),
                                                        Image.asset("images/introscreen/sLibrary_transaction.png",scale: 1.5,),
                                                        SizedBox(width: sWidth(2, context),),
                                                        Center(
                                                          child: Text("Library", style: SecondaryText1(), overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  onTap: (){
                                                    Navigator.push(context, MaterialPageRoute(builder: (context)=> Staff_Lib_Home(staffID: widget.password, StaffAPI: data[0])));
                                                  },
                                                ),
                                              if(status.contains("1Leave Balance - Staff"))
                                                InkWell(
                                                  child: Container(
                                                    margin: const EdgeInsets.all(8),
                                                    width: MediaQuery.of(context).size.width / 2.4,
                                                    height: 80,
                                                    decoration: PrimaryRoundBox1(),
                                                    child: Row(
                                                      children: [
                                                        SizedBox(width: sWidth(3, context),),
                                                        Image.asset("images/introscreen/leave_balance.png",scale: 1.5,),
                                                        SizedBox(width: sWidth(2, context),),
                                                        Center(
                                                          child: Text("Leave\nBalance", style: SecondaryText1()),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  onTap: (){
                                                    checkInternet();
                                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                                        StaffLeaveBalance(staffID: widget.password, StaffAPI: data[0])));
                                                  },
                                                ),
                                              if(status.contains("1Timetable - Staff"))
                                                InkWell(
                                                  child: Container(
                                                    margin: const EdgeInsets.all(8),
                                                    width: MediaQuery.of(context).size.width / 2.4,
                                                    height: 80,
                                                    decoration: PrimaryRoundBox1(),
                                                    child: Row(
                                                      children: [
                                                        SizedBox(width: sWidth(3, context),),
                                                        Image.asset("images/introscreen/sslibrary_overdue.png",scale: 1.5,),
                                                        SizedBox(width: sWidth(2, context),),
                                                        Center(
                                                          child: Text("Time Table", style: SecondaryText1()),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  onTap: (){
                                                    checkInternet();
                                                    Navigator.push(context, MaterialPageRoute(builder: (context)=> StaffTimetable(
                                                        staffID: widget.password, StaffAPI: data[0])));
                                                  },
                                                ),
                                              if(status.contains("1Holiday - Staff"))
                                                InkWell(
                                                  child: Container(
                                                    margin: const EdgeInsets.all(8),
                                                    width: MediaQuery.of(context).size.width / 2.4,
                                                    height: 80,
                                                    decoration: PrimaryRoundBox1(),
                                                    child: Row(
                                                      children: [
                                                        SizedBox(width: sWidth(3, context),),
                                                        Image.asset("images/introscreen/leave_balance.png",scale: 1.5,),
                                                        SizedBox(width: sWidth(2, context),),
                                                        Center(
                                                          child: Text("Holidays", style: SecondaryText1()),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  onTap: (){
                                                    checkInternet();
                                                    Navigator.push(context, MaterialPageRoute(builder: (context)=> StaffHoliday(staffID: widget.password, StaffAPI: data[0])));
                                                  },
                                                ),
                                              if(status.contains("1Staff Profoma - Staff"))
                                                InkWell(
                                                  child: Container(
                                                    margin: const EdgeInsets.all(8),
                                                    width: MediaQuery.of(context).size.width / 2.4,
                                                    height: 80,
                                                    decoration: PrimaryRoundBox1(),
                                                    child: Row(
                                                      children: [
                                                        SizedBox(width: sWidth(3, context),),
                                                        Image.asset("images/introscreen/staff_proforma.png",scale: 1.5,),
                                                        SizedBox(width: sWidth(2, context),),
                                                        Center(
                                                          child: Text("My Proforma", style: SecondaryText1()),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  onTap: (){
                                                    checkInternet();
                                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                                        StaffProforma(staffID: widget.password, StaffAPI: data[0])));
                                                  },
                                                ),
                                              if(status.contains("1Leave Apply - Staff"))
                                                InkWell(
                                                  child: Container(
                                                    margin: const EdgeInsets.all(8),
                                                    width: MediaQuery.of(context).size.width / 2.4,
                                                    height: 80,
                                                    decoration: PrimaryRoundBox1(),
                                                    child: Row(
                                                      children: [
                                                        SizedBox(width: sWidth(3, context),),
                                                        Image.asset("images/introscreen/staff_proforma.png",scale: 1.5,),
                                                        SizedBox(width: sWidth(2, context),),
                                                        Center(
                                                          child: Text("Leave Apply", style: SecondaryText1()),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  onTap: (){
                                                    checkInternet();
                                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                                        ApplyScreen(username: widget.username, password: widget.password,)));
                                                  },
                                                ),
                                              if(status.contains("1Leave Inbox - Staff"))
                                                InkWell(
                                                  child: Container(
                                                    margin: const EdgeInsets.all(8),
                                                    width: MediaQuery.of(context).size.width / 2.4,
                                                    height: 80,
                                                    decoration: PrimaryRoundBox1(),
                                                    child: Row(
                                                      children: [
                                                        SizedBox(width: sWidth(3, context),),
                                                        Image.asset("images/introscreen/staff_proforma.png",scale: 1.5,),
                                                        SizedBox(width: sWidth(2, context),),
                                                        Center(
                                                          child: Row(
                                                            children: [
                                                              Text("Inbox", style: SecondaryText1()),
                                                              Text(" (", style: SecondaryText1()),
                                                              Text("$Counts", style: const TextStyle(color: Colors.green,fontWeight: FontWeight.w900,fontSize: 15)),
                                                              Text(")", style: SecondaryText1()),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  onTap: (){
                                                    checkInternet();
                                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                                        Staff_Request_Inbox(username: widget.username, password: widget.password,)));
                                                  },
                                                ),
                                              if(status.contains("1Club Attendance - Staff"))
                                                InkWell(
                                                  child: Container(
                                                    margin: const EdgeInsets.all(8),
                                                    width: MediaQuery.of(context).size.width / 2.4,
                                                    height: 80,
                                                    decoration: PrimaryRoundBox1(),
                                                    child: Row(
                                                      children: [
                                                        SizedBox(width: sWidth(3, context),),
                                                        Image.asset("images/introscreen/staff_proforma.png",scale: 1.5,),
                                                        SizedBox(width: sWidth(2, context),),
                                                        Center(
                                                          child: Row(
                                                            children: [
                                                              Text("Club Activity", style: SecondaryText1()),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  onTap: (){
                                                    checkInternet();
                                                    Navigator.push(context, MaterialPageRoute(builder: (context)=> Club_Activity(username: widget.username, password: widget.password,)));
                                                  },
                                                ),
                                              if(status.contains("1Transport Attendance - Staff"))
                                                InkWell(
                                                  child: Container(
                                                    margin: const EdgeInsets.all(8),
                                                    width: MediaQuery.of(context).size.width / 2.4,
                                                    height: 80,
                                                    decoration: PrimaryRoundBox1(),
                                                    child: Row(
                                                      children: [
                                                        SizedBox(width: sWidth(3, context),),
                                                        Image.asset("images/introscreen/staff_proforma.png",scale: 1.5,),
                                                        SizedBox(width: sWidth(2, context),),
                                                        Center(
                                                          child: Row(
                                                            children: [
                                                              Text(" Transport\nAttendance", style: SecondaryText1()),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  onTap: (){
                                                    checkInternet();
                                                    Navigator.push(context, MaterialPageRoute(builder: (context)=> Club_Activity(username: widget.username, password: widget.password,)));
                                                  },
                                                ),
                                            ],
                                          ),
                                          Container(margin: const EdgeInsets.only(top: 20),),
                                        ],
                                      ),
                                    )),
                              )
                          );
                        }
                        else{
                          return Scaffold(
                            appBar: AppBar(
                              title: Text("Login", style: PrimaryText(context)),
                              centerTitle: true,
                              backgroundColor: PrimaryColor(),
                              actions: <Widget>[
                                InkWell(
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 20.0),
                                    child: const Icon(Icons.settings_power),
                                  ),
                                  onTap: () {
                                    UnsavePass();
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            ),
                            body: Center(child: Text("Oops... Something went wrong.\nPlease try again later", style: ErrorText2Big(),textAlign: TextAlign.center,)),
                          );
                        }
                      }
                      else{
                        return Container(child: const Center(child: CircularProgressIndicator()), color: Colors.white,);
                      }
                    }
                );
              }
              else{
                return Scaffold(
                  appBar: AppBar(
                    title: Text("Login", style: PrimaryText(context)),
                    centerTitle: true,
                    backgroundColor: PrimaryColor(),
                    actions: <Widget>[
                      InkWell(
                        child: Container(
                          margin: const EdgeInsets.only(right: 20.0),
                          child: const Icon(Icons.settings_power),
                        ),
                        onTap: () {
                          UnsavePass();
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                  body: Center(child: Text("Please check your Details", style: ErrorText2Big(),textAlign: TextAlign.center,)),
                );
              }
            }
            else{
              return Container(child: Center(child: StaffMainLoading(context)), color: Colors.white,);
            }
          }
        });
  }

  void UnsavePass()async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('StaffsavePass', false);
    prefs.setBool('useStaffBiometric', false);
    SetSavePass(false);
    SetStaffsavePass(false);
    SetuseStudentBiometric(false);
    SetuseStaffBiometric(false);
  }

  void GetBiometric()async{
    final prefs = await SharedPreferences.getInstance();
    _enableBiometric = prefs.getBool('useStaffBiometric') ?? false;
    SetuseStaffBiometric(_enableBiometric);

  }

  void DisableBiometric()async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('useStaffBiometric', false);
    SetuseStaffBiometric(false);
  }

  Future<Widget> Toggle(bool Savetext) async {
    if(Savetext == true){
      return const Icon(Icons.toggle_on_outlined, color: Colors.white, size: 45,);
    }
    else{
      return const Icon(Icons.toggle_off_outlined, color: Colors.white70, size: 45,);
    }
  }
  _onBackButtonPressed(BuildContext context) async {
    if(Platform.isAndroid){
      SystemNavigator.pop();
    }
  }
}

