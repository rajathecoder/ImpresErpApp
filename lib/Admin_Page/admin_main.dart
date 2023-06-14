import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:add_dev_dolphin/Admin_Page/admin_notification.dart';
import 'package:add_dev_dolphin/Admin_Page/admin_screens.dart';
import 'package:add_dev_dolphin/Admin_Page/front_page.dart';
import 'package:add_dev_dolphin/Data/Admin_data.dart';
import 'package:add_dev_dolphin/Data/Staff_Data.dart';
import 'package:add_dev_dolphin/Local_Data/notification_database.dart';
import 'package:add_dev_dolphin/Style_font/designs.dart';
import 'package:add_dev_dolphin/UI/main_ui.dart';
import 'package:add_dev_dolphin/main.dart';
import 'package:badges/badges.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:badges/badges.dart' as badges;
import 'package:shared_preferences/shared_preferences.dart';


class Admin_HomePage extends StatefulWidget {
  const Admin_HomePage(
      {Key? key, required this.username, required this.password})
      : super(key: key);
  final String username;
  final String password;

  @override
  State<Admin_HomePage> createState() => _Admin_HomePageState();
}

class _Admin_HomePageState extends State<Admin_HomePage> {
  late Future <ModuleData_List> ModuleAPIData;
  late Future <Admin_Profile_Data_List> Admin_Profile_API;
  TextEditingController Reg_Code = TextEditingController();
  String? St_code;
  valid() async {
    final form = _searCode.currentState;
    if (form!.validate()) {
      form.save();
      await Find_S();
      await Enter_or_Not();
    }
  }
  late List Stu_Check = [];
  String? St_Val;
  Find_S() async {
    final responce = await http.get(
        Uri.parse("http://${ip}/api/FindStudentorStaff?Code=${Reg_Code.text}"));
    if (responce.statusCode == 200) {
      Stu_Check = json.decode(responce.body);
      print(Stu_Check);
      St_Val = Stu_Check[0]['id'].toString();
      print('Recieved user id : $St_Val');
    }
  }
  Enter_or_Not() async {
    if (St_Val.toString() == 2.toString()) {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Search_Students(
                username: widget.username,
                password: widget.password,
                regno: St_code.toString(),
              )));
    } else {
      await Fluttertoast.showToast(
          backgroundColor: Colors.red,
          msg: "Kindly, Check Student RegNo",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
  final _searCode = GlobalKey<FormState>();
  TimeOfDay selectedTime = TimeOfDay.now();
  String? Gn = 'Good Night';
  String? Gm = "Good Morning";
  String? GA = "Good Afternoon";
  String? Ge = "Good Evening";
  bool Gni = false;
  bool Gmi = false;
  bool GAi = false;
  bool Gei = false;
  check_greeting() async {
    if (selectedTime.hour == 20 ||
        selectedTime.hour == 21 ||
        selectedTime.hour == 22 ||
        selectedTime.hour == 23 ||
        selectedTime.hour == 00 ||
        selectedTime.hour == 01 ||
        selectedTime.hour == 02 ||
        selectedTime.hour == 03) {
      Gni = true;
    } else if (selectedTime.hour == 04 ||
        selectedTime.hour == 05 ||
        selectedTime.hour == 06 ||
        selectedTime.hour == 07 ||
        selectedTime.hour == 08 ||
        selectedTime.hour == 09 ||
        selectedTime.hour == 10 ||
        selectedTime.hour == 11) {
      // SetSetupDone(true);
      Gmi = true;
    } else if (selectedTime.hour == 12 ||
        selectedTime.hour == 13 ||
        selectedTime.hour == 14 ||
        selectedTime.hour == 15 ||
        selectedTime.hour == 16) {
      GAi = true;
    } else if (selectedTime.hour == 17 ||
        selectedTime.hour == 18 ||
        selectedTime.hour == 19) {
      Gei = true;
    }
  }
  Widget _shoppingCartBadge() {
    return
      badges.Badge(
        position: BadgePosition.topEnd(top: 6, end: 6),
        badgeAnimation: BadgeAnimation.slide(),
        badgeStyle: KLK > 0 ? badges.BadgeStyle(badgeColor: Colors.green,borderGradient: BadgeGradient.radial(colors: [Colors.blue,Colors.yellow])):badges.BadgeStyle(badgeColor: Colors.red,borderGradient: BadgeGradient.radial(colors: [Colors.blue,Colors.yellow])),
        child: IconButton(icon: Icon(Icons.notifications), onPressed: ()async {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Admin_Notification_screen()));
          setState((){});
        }),
      );
  }
  int? sp3;
  String? LinkAdm1,LinkAdm2;
  SaveBool()async{
    final prefs = await SharedPreferences.getInstance();
    int? changFC2 = 1;
    await prefs.setInt('changefcmAdm', changFC2);
  }
  ChangeBool()async{
    final prefs = await SharedPreferences.getInstance();
    int? changFC = 2;
    prefs.setInt('changefcmAdm', changFC);
    print("changed");
  }
  ReadBool()async{
    final prefs = await SharedPreferences.getInstance();
    sp3 = await prefs.getInt('changefcmAdm');
    print("-c--c-c--c-c${sp3}");
    if(sp3 == null || sp3 == 1.toInt()){
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
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ModuleNetwork Modulenetwork = ModuleNetwork("menu?instid=1");
    ModuleAPIData = Modulenetwork.ModuleloadData();
    Admin_Profile_Network admin_profile_network = Admin_Profile_Network("StaffInfo?StaffCode=${widget.username}&Password=${widget.password}");
    Admin_Profile_API = admin_profile_network.Admin_Profile_loadData();
    check_greeting();
    ReadBool();
    ChangeBool();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async{
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        final String? title = message.notification?.title;
        final String? body = message.notification?.body;
        final String? date = DateFormat.yMMMMd().add_jm().format(message.sentTime as DateTime);
        message.data['openURL'].toString().length > 3 ?   LinkAdm1 = message.data['openURL'] : LinkAdm1 = '';
        setState(() {
          refreshNotes();
        });
        await DatabaseHandler()
            .inserttodo(todo(
            title: title!,
            description: body!,
            Date: date.toString(),
            URL: LinkAdm1!,
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
                color: Colors.transparent,
              ),
            ));
      }
    });
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    //   print('A new onMessageOpenedApp event was published!');
    //   print("second");
    //   RemoteNotification? notification = message.notification;
    //   AndroidNotification? android = message.notification?.android;
    //   if (notification != null && android != null) {
    //     final String? title1 = message.notification?.title;
    //     final String? body1 = message.notification?.body;
    //     final String? date1 = DateFormat.yMMMMd().add_jm().format(message.sentTime as DateTime);
    //     message.data['openURL'].toString().length > 3 ?   LinkAdm2 = message.data['openURL'] : LinkAdm2 = '';
    //     setState(() {
    //       refreshNotes();
    //     });
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
    refreshNotes();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Admin_Profile_API,
        builder: (context, AsyncSnapshot<Admin_Profile_Data_List> profsnapshot)  {
          if (profsnapshot.hasError) {
          return Container(child: Center(child: StaffMainLoading(context)), color: Colors.white,);
          }
          else {
            List <Admin_Profile_Data> profiledata;
            if (profsnapshot.hasData) {
              profiledata = profsnapshot.data!.Ad_Prof_list;
              if(profiledata.length > 0) {
                return FutureBuilder(
                    future: ModuleAPIData,
                    builder: (context,
                        AsyncSnapshot<ModuleData_List> Modulesnapshot) {
                      if (Modulesnapshot.hasError) {
                        ErrorShowingWidget(context);
                      }
                      List <ModuleAPI_data> Moduledata;
                      if (Modulesnapshot.hasData) {
                        Moduledata = Modulesnapshot.data!.Moduledata_list;
                        if (Moduledata.length > 0) {
                          List <String> status = [];
                          for (int i = 0; i <= Moduledata.length - 1; i++) {
                            if (Moduledata[i].MenuName[Moduledata[i].MenuName
                                .length - 1] == 't') {
                              status.add("${Moduledata[i].Status}${Moduledata[i]
                                  .MenuName}");
                            }
                          }
                          print(status);
                          return WillPopScope(
                            onWillPop: () => _onBackButtonPressed(context),
                            child: SafeArea(
                              child: Scaffold(
                                  backgroundColor: Color.fromRGBO(
                                      242, 249, 255, 0.9),
                                  body: Builder(
                                    builder: (BuildContext context) =>
                                        SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: Column(
                                              children: <Widget>[
                                                Stack(children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment
                                                        .end,
                                                    children: [
                                                      Container(
                                                          child: Image.asset(
                                                              "images/introscreen/bg_overlay.png")),
                                                    ],
                                                  ),
                                                  Container(
                                                    width: MediaQuery
                                                        .of(context)
                                                        .size
                                                        .width,
                                                    child: SingleChildScrollView(
                                                      scrollDirection: Axis
                                                          .vertical,
                                                      child: Column(
                                                        children: [
                                                          SizedBox(
                                                            height: sHeight(
                                                                3, context),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment
                                                                .spaceBetween,
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
                                                                  if (ZoomDrawer
                                                                      .of(
                                                                      context)!
                                                                      .isOpen()) {
                                                                    ZoomDrawer
                                                                        .of(
                                                                        context)!
                                                                        .close();
                                                                  } else {
                                                                    ZoomDrawer
                                                                        .of(
                                                                        context)!
                                                                        .open();
                                                                  }
                                                                },
                                                                child: Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                      left: 15),
                                                                  child: Image
                                                                      .asset(
                                                                    "images/introscreen/nav_bar.png",
                                                                    width: sWidth(
                                                                        8,
                                                                        context),
                                                                  ),
                                                                ),
                                                              ),
                                                              Image.asset(
                                                                "images/admin_image/logo.png",
                                                              ),
                                                              // _shoppingCartBadge(),
                                                              Container(
                                                                child: CircleAvatar(
                                                                  backgroundImage: NetworkImage(
                                                                      "${img}"),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: sHeight(
                                                                4, context),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment
                                                                .spaceEvenly,
                                                            children: [
                                                              Column(
                                                                children: [
                                                                  Gei
                                                                      ? Container(
                                                                    width: sWidth(
                                                                        40,
                                                                        context),
                                                                    child: Text(
                                                                        "${Ge
                                                                            .toString()},",
                                                                        textAlign: TextAlign
                                                                            .left,
                                                                        maxLines: 1,
                                                                        overflow: TextOverflow
                                                                            .ellipsis,
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .black54,
                                                                            fontWeight: FontWeight
                                                                                .w900,
                                                                            fontSize: 20)),
                                                                  )
                                                                      : Container(),
                                                                  GAi
                                                                      ? Container(
                                                                    width: sWidth(
                                                                        40,
                                                                        context),
                                                                    child: Text(
                                                                        "${GA
                                                                            .toString()},",
                                                                        textAlign: TextAlign
                                                                            .left,
                                                                        maxLines: 1,
                                                                        overflow: TextOverflow
                                                                            .ellipsis,
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .black54,
                                                                            fontWeight: FontWeight
                                                                                .w900,
                                                                            fontSize: 18)),
                                                                  )
                                                                      : new Container(),
                                                                  Gmi
                                                                      ? Container(
                                                                    width: sWidth(
                                                                        40,
                                                                        context),
                                                                    child: Text(
                                                                        "${Gm
                                                                            .toString()},",
                                                                        textAlign: TextAlign
                                                                            .left,
                                                                        maxLines: 1,
                                                                        overflow: TextOverflow
                                                                            .ellipsis,
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .black54,
                                                                            fontWeight: FontWeight
                                                                                .w900,
                                                                            fontSize: 18)),
                                                                  )
                                                                      : new Container(),
                                                                  Gni
                                                                      ? Container(
                                                                    width: sWidth(
                                                                        40,
                                                                        context),
                                                                    child: Text(
                                                                        "${Gn
                                                                            .toString()},",
                                                                        textAlign: TextAlign
                                                                            .left,
                                                                        maxLines: 1,
                                                                        overflow: TextOverflow
                                                                            .ellipsis,
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .black54,
                                                                            fontWeight: FontWeight
                                                                                .w900,
                                                                            fontSize: 18)),
                                                                  )
                                                                      : new Container(),
                                                                  Container(
                                                                    width: sWidth(
                                                                        40,
                                                                        context),
                                                                    child: Text(
                                                                        '${profiledata[0]
                                                                            .staffName}!',
                                                                        textAlign: TextAlign
                                                                            .left,
                                                                        maxLines: 1,
                                                                        overflow: TextOverflow
                                                                            .ellipsis,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .w700,
                                                                            fontSize: 30,
                                                                            color: Colors
                                                                                .red)),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                width: sWidth(
                                                                    5, context),
                                                              ),
                                                              Container(
                                                                // height: sHeight(10, context),
                                                                decoration: BoxDecoration(),
                                                                child: Stack(
                                                                  children: [
                                                                    ClipRRect(
                                                                        borderRadius: BorderRadius
                                                                            .all(
                                                                          Radius
                                                                              .circular(
                                                                              10),
                                                                        ),
                                                                        child: Stack(
                                                                            children: [
                                                                              // Center(
                                                                              //     child:
                                                                              //     CircularProgressIndicator()),
                                                                              Image
                                                                                  .network(
                                                                                "${ManagementImageIP}${profiledata[0]
                                                                                    .staffImg}",
                                                                                scale: 1,
                                                                                fit: BoxFit
                                                                                    .fill,
                                                                              )
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
                                                ]),
                                                Column(
                                                  children: [
                                                    status.contains(
                                                        "1Search Student - Management")
                                                        ? Form(
                                                      key: _searCode,
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.circular(10)

                                                        ),
                                                        width: sWidth(
                                                            90, context),
                                                        height: 60,
                                                        child: TextFormField(
                                                          // autovalidateMode: AutovalidateMode.onUserInteraction,
                                                          decoration: InputDecoration(
                                                            hintStyle: TextStyle(
                                                                color: Colors
                                                                    .grey),
                                                            labelText: "Search With Student RegNo",
                                                            suffixIcon: InkWell(
                                                                onTap: () async {
                                                                  await valid();
                                                                },
                                                                child: Icon(
                                                                  Icons.search,
                                                                  color: Color(
                                                                      0xff6762FF),
                                                                )),
                                                            labelStyle: TextStyle(
                                                                color: Colors
                                                                    .grey),

                                                            border: OutlineInputBorder(),
                                                            hintText: "Search With Student RegNo",
                                                          ),
                                                          inputFormatters: [
                                                            FilteringTextInputFormatter
                                                                .deny(
                                                                RegExp(r'\s'))
                                                          ],
                                                          validator: (e) {
                                                            if (e!.isEmpty) {
                                                              return "Kindly,Enter Student RegNo";
                                                            }
                                                          },
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black),
                                                          onSaved: (e) =>
                                                          St_code = e,
                                                          controller: Reg_Code,
                                                        ),
                                                      ),
                                                    )
                                                        : Container(),
                                                    GridView.count(
                                                      crossAxisCount: 2,
                                                      shrinkWrap: true,
                                                      physics: NeverScrollableScrollPhysics(),
                                                      childAspectRatio: 2,
                                                      children: [
                                                        if(status.contains(
                                                            "1Fee Balance - Management"))
                                                          InkWell(
                                                              child: Container(
                                                                margin: EdgeInsets
                                                                    .all(8),
                                                                width: MediaQuery
                                                                    .of(context)
                                                                    .size
                                                                    .width /
                                                                    2.4,
                                                                height: 80,
                                                                decoration: PrimaryRoundBox1(),
                                                                child: Row(
                                                                  children: [
                                                                    SizedBox(
                                                                      width: sWidth(
                                                                          3,
                                                                          context),
                                                                    ),
                                                                    Image.asset(
                                                                      "images/admin_image/fee_balances.png",
                                                                      scale: 2,
                                                                    ),
                                                                    SizedBox(
                                                                      width: sWidth(
                                                                          2,
                                                                          context),
                                                                    ),
                                                                    Center(
                                                                      child: Text(
                                                                          "Fee Balance",
                                                                          style: SecondaryText1()),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              onTap: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (
                                                                            context) =>
                                                                            Inst_Colection(
                                                                              username: widget
                                                                                  .username,
                                                                              password: widget
                                                                                  .password,
                                                                            )));
                                                              }),
                                                        if(status.contains(
                                                            "1Fee Collections - Management"))
                                                          InkWell(
                                                              child: Container(
                                                                margin: EdgeInsets
                                                                    .all(8),
                                                                width: MediaQuery
                                                                    .of(context)
                                                                    .size
                                                                    .width /
                                                                    2.4,
                                                                height: 80,
                                                                decoration: PrimaryRoundBox1(),
                                                                child: Row(
                                                                  children: [
                                                                    SizedBox(
                                                                      width: sWidth(
                                                                          3,
                                                                          context),
                                                                    ),
                                                                    Image.asset(
                                                                      "images/admin_image/collection.png",
                                                                      scale: 2,
                                                                    ),
                                                                    SizedBox(
                                                                      width: sWidth(
                                                                          2,
                                                                          context),
                                                                    ),
                                                                    Center(
                                                                      child: Text(
                                                                          "Collections",
                                                                          style: SecondaryText1()),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              onTap: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (
                                                                            context) =>
                                                                            Department_Colection(
                                                                              username: widget
                                                                                  .username,
                                                                              password: widget
                                                                                  .password,
                                                                            )));
                                                              }),
                                                        if(status.contains(
                                                            "1Hostel - Management"))
                                                          InkWell(
                                                              child: Container(
                                                                margin: EdgeInsets
                                                                    .all(8),
                                                                width: MediaQuery
                                                                    .of(context)
                                                                    .size
                                                                    .width /
                                                                    2.4,
                                                                height: 80,
                                                                decoration: PrimaryRoundBox1(),
                                                                child: Row(
                                                                  children: [
                                                                    SizedBox(
                                                                      width: sWidth(
                                                                          3,
                                                                          context),
                                                                    ),
                                                                    Image.asset(
                                                                      "images/admin_image/hostel.png",
                                                                      scale: 2,
                                                                    ),
                                                                    SizedBox(
                                                                      width: sWidth(
                                                                          2,
                                                                          context),
                                                                    ),
                                                                    Center(
                                                                      child: Text(
                                                                          "Hostel",
                                                                          style: SecondaryText1()),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              onTap: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (
                                                                            context) =>
                                                                            Hostel_Data(
                                                                              username: widget
                                                                                  .username,
                                                                              password: widget
                                                                                  .password,
                                                                            )));
                                                              }),
                                                        if(status.contains(
                                                            "1Transport - Management"))
                                                          InkWell(
                                                              child: Container(
                                                                margin: EdgeInsets
                                                                    .all(8),
                                                                width: MediaQuery
                                                                    .of(context)
                                                                    .size
                                                                    .width /
                                                                    2.4,
                                                                height: 80,
                                                                decoration: PrimaryRoundBox1(),
                                                                child: Row(
                                                                  children: [
                                                                    SizedBox(
                                                                      width: sWidth(
                                                                          3,
                                                                          context),
                                                                    ),
                                                                    Image.asset(
                                                                      "images/admin_image/bus.png",
                                                                      scale: 2,
                                                                    ),
                                                                    SizedBox(
                                                                      width: sWidth(
                                                                          2,
                                                                          context),
                                                                    ),
                                                                    Center(
                                                                      child:
                                                                      Text(
                                                                          "Bus",
                                                                          style: SecondaryText1()),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              onTap: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (
                                                                            context) =>
                                                                            TransRoute(
                                                                              username: widget
                                                                                  .username,
                                                                              password: widget
                                                                                  .password,
                                                                            )));
                                                              }),
                                                        if(status.contains(
                                                            "1Admission Report - Management"))
                                                          InkWell(
                                                              child: Container(
                                                                margin: EdgeInsets
                                                                    .all(8),
                                                                width: MediaQuery
                                                                    .of(context)
                                                                    .size
                                                                    .width /
                                                                    2.4,
                                                                height: 80,
                                                                decoration: PrimaryRoundBox1(),
                                                                child: Row(
                                                                  children: [
                                                                    SizedBox(
                                                                      width: sWidth(
                                                                          3,
                                                                          context),
                                                                    ),
                                                                    Image.asset(
                                                                      "images/admin_image/admission_report.png",
                                                                      scale: 4,
                                                                    ),
                                                                    SizedBox(
                                                                      width: sWidth(
                                                                          2,
                                                                          context),
                                                                    ),
                                                                    Center(
                                                                      child:
                                                                      Text(
                                                                          "Admission\nReport",
                                                                          style: SecondaryText1()),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              onTap: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (
                                                                            context) =>
                                                                            Admission_Report(
                                                                              username: widget
                                                                                  .username,
                                                                              password: widget
                                                                                  .password,
                                                                            )));
                                                              }),
                                                      ],
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top: 20),),
                                                  ],
                                                )
                                              ],
                                            )),
                                  )),
                            ),
                          );
                        }
                        else {
                          return Container(
                            child: Center(child: StaffMainLoading(context)),
                            color: Colors.white,);
                        }
                      }
                      else {
                        return Container(
                          child: Center(child: StaffMainLoading(context)),
                          color: Colors.white,);
                      }
                    }
                );
              }
              else{
                return Scaffold(
                 body: Center(
                   child: Image.asset('images/Dataimg/data_not_found.png',),
                   //Profile Not Created
                 ),
                );
              }
            }
            else {
              return Container(
                child: Center(child: StaffMainLoading(context)),
                color: Colors.white,);
            }
          }
          });
  }
  _onBackButtonPressed(BuildContext context) async {
    if(Platform.isAndroid){
      SystemNavigator.pop();
    }
  }
}

