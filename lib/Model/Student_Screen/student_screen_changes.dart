import 'dart:async';
import 'package:add_dev_dolphin/Data/Staff_Data.dart';
import 'package:add_dev_dolphin/Data/Student_Data.dart';
import 'package:add_dev_dolphin/Style_font/Staff_Screen_Design.dart';
import 'package:add_dev_dolphin/Style_font/designs.dart';
import 'package:add_dev_dolphin/Style_font/student_screen_design.dart';
import 'package:add_dev_dolphin/UI/main_ui.dart';
import 'package:add_dev_dolphin/main.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../Data/Admin_data.dart';
import '../../main.dart';

double sHeight(double per, BuildContext context){
  double h = MediaQuery.of(context).size.height;
  return h * per / 100;
}

double sWidth(double per, BuildContext context){
  double w = MediaQuery.of(context).size.width;
  return w * per / 100;
}

class StudentProfileImage extends StatelessWidget {
  final String image;
  final String username;

  const StudentProfileImage(
      {Key? key, required this.image, required this.username})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(username, style: PrimaryText(context)),
          centerTitle: true,
          backgroundColor: PrimaryColor(),
          elevation: 20.0,
        ),
        backgroundColor: PhotoColor(),
        body: Imagedisplay(image, MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height));
  }
}

// Student Profile
class StudentProfile extends StatefulWidget {
  const StudentProfile({Key? key, required this.username, required this.password}) : super(key: key);
  final String username;
  final String password;

  @override
  _StudentProfileState createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  late Future <Data_List> APIData;
  late LocalAuthentication auth = LocalAuthentication();
  late bool _canCheckBiometric = false;
  late List<BiometricType> _availableBiometrics = [];
  late String _authorized = "Not Authorized";
  bool _enableBiometric = false;
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
  void DisableBiometric()async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('useStudentBiometric', false);
    SetuseStudentBiometric(false);
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
  Widget Toggle(bool Savetext){
    if(Savetext == true){
      return Icon(Icons.toggle_on_outlined, color: Colors.white, size: 45,);
    }
    else{
      return Icon(Icons.toggle_off_outlined, color: Colors.white70, size: 45,);
    }
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
        actionsPadding: EdgeInsets.only(left: 30, right: 30, bottom: 15),
        actions: [
          InkWell(
            child: Container(
              child: Text('Ok', style: PrimaryText2(), textAlign: TextAlign.center,),
              width: 200,
            ),
            onTap: ()=> Navigator.pop(context),
          ),
        ],
        elevation: 20.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
      ));
    }
    if(!mounted) return;
    setState(() {
      _authorized = authorized ? "Authenrized Success" : "Failed to authenticate";
      print("Authorized : $_authorized");
    });

    if(authorized){
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('useStudentBiometric', true);
      // Scaffold.of(context).showSnackBar(SnackBar(
      //   content: Text('Fingerprint Enabled', style: SecondaryText1()(),),
      //   backgroundColor: SecondaryColor(),
      // ));
    }
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Network network = Network("billing?RollNum=${widget.username}&Password=${widget.password}");
    APIData = network.loadData();
    _checkBiometric();
    _getAvailableBiometrics();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: APIData,
        builder: (context, AsyncSnapshot<Data_List> snapshot){
          if(snapshot.hasError){
            ErrorShowingWidget(context);
          }
          List <API_data> data;
          if(snapshot.hasData){
            data = snapshot.data!.data_list;
            if (data.length > 0){
              return  Scaffold(
                backgroundColor:  Color.fromRGBO(242, 249, 250, 0.9),
                appBar: AppBar(
                  titleSpacing: 30,
                  leadingWidth: 55,
                  title: RichText(
                    text: new TextSpan(
                      children: <TextSpan>[
                        new TextSpan(text: 'My Profile', style: TextStyle(fontWeight:
                        FontWeight.bold,fontSize: 20)),
                      ],
                    ),
                  ),
                  toolbarHeight: 70,
                  backgroundColor: PrimaryColor(),
                  elevation: 20.0,
                  actions: <Widget>[
                    // InkWell(
                    //   child: Container(
                    //     margin: EdgeInsets.only(right: 20.0),
                    //     child: Icon(Icons.settings_rounded),
                    //   ),
                    //   onTap: () {
                    //     showModalBottomSheet(
                    //         context: context,
                    //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                    //         isScrollControlled: true,
                    //         isDismissible: true,
                    //         backgroundColor: SecondaryColor(),
                    //         builder: (context)=> Container(
                    //           height: 200,
                    //           child: Padding(
                    //             padding: const EdgeInsets.all(15.0),
                    //             child: SingleChildScrollView(scrollDirection: Axis.vertical,
                    //               child: Column(
                    //                 children: <Widget> [
                    //                   Container(
                    //                     margin: EdgeInsets.only(top: 15),
                    //                   ),
                    //                   InkWell(
                    //                     child: Row(
                    //                       mainAxisAlignment: MainAxisAlignment.start,
                    //                       children: <Widget> [
                    //                         Icon(Icons.settings_power, color: Colors.white, size: 40,),
                    //                         Container(margin: EdgeInsets.only(left: 25),),
                    //                         Text('Log out', style: PrimaryText01(),),
                    //                       ],
                    //                     ),
                    //                     onTap: (){
                    //                       showDialog(context: context, builder: (context)=> AlertDialog(
                    //                         title: Text('Are you sure?', style: PrimaryText2(), textAlign: TextAlign.start,),
                    //                         content: Text('Do you want to Log Out?', style: SecondaryText2(), textAlign: TextAlign.center,),
                    //                         actionsAlignment: MainAxisAlignment.spaceBetween,
                    //                         actionsPadding: EdgeInsets.only(left: 30, right: 30, bottom: 15),
                    //                         actions: [
                    //                           InkWell(
                    //                             child: Text('Yes', style: PrimaryText2(), textAlign: TextAlign.start,),
                    //                             onTap: () {
                    //                               UnsavePass();
                    //                               // Navigator.pop(context);
                    //                               // Navigator.pop(context);
                    //                               // Navigator.pop(context);
                    //                               Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login_Screen_Student()));
                    //                             },
                    //                           ),
                    //                           InkWell(
                    //                             child: Text('No', style: PrimaryText2(), textAlign: TextAlign.start,),
                    //                             onTap: ()=> Navigator.pop(context),
                    //                           ),
                    //                         ],
                    //                         elevation: 20.0,
                    //                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    //                       ));
                    //                     },
                    //                   ),
                    //                   Container(
                    //                     margin: EdgeInsets.only(top: 35),
                    //                   ),
                    //                   InkWell(
                    //                     child: Row(
                    //                       mainAxisAlignment: MainAxisAlignment.start,
                    //                       children: <Widget> [
                    //                         Icon(Icons.fingerprint, color: Colors.white, size: 40,),
                    //                         Container(margin: EdgeInsets.only(left: 25),),
                    //                         Text('Enable Fingerprint', style: PrimaryText01(),),
                    //                         Container(margin: EdgeInsets.only(left: 25),),
                    //                         Toggle(_enableBiometric),
                    //                       ],
                    //                     ),
                    //                     onTap: (){
                    //                       _enableBiometric = !_enableBiometric;
                    //                       setState(() {
                    //                       });
                    //                       if(_enableBiometric){
                    //                         if(_canCheckBiometric)
                    //                         {
                    //                           Navigator.pop(context);
                    //                           _authenticate();
                    //                         }
                    //                         else
                    //                         {
                    //                           SnackBar snackbar =  SnackBar(content: Text('Sorry, this feature is not configured in your device', style: SecondaryText1(),), backgroundColor: ErrorColor(), duration: Duration(seconds: 2),);
                    //                           // Scaffold.of(context).hideCurrentSnackBar();
                    //                           // Scaffold .of(context).showSnackBar(snackbar);
                    //                         }
                    //                       }
                    //                       else{
                    //                         Navigator.pop(context);
                    //                         DisableBiometric();
                    //                       }
                    //                     },
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //           ),
                    //         )
                    //     );
                    //   },
                    // )
                  ],
                ),
                body: Builder(
                    builder: (BuildContext context) => SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: <Widget>[
                          // Container(
                          //   margin: EdgeInsets.only(
                          //     top: MediaQuery.of(context).size.height * 0.05,
                          //     left: MediaQuery.of(context).size.width * 0.02,
                          //     right: MediaQuery.of(context).size.width * 0.02,
                          //   ),
                          //   child: Imagedisplay(data[0].Picture, MediaQuery.of(context).size.width, 450),
                          // ),
                          SizedBox(height: sHeight(3, context),),
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            width: sWidth(90, context),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(10),),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Column(
                                children: [
                                  SizedBox(height: sHeight(2, context),),
                                  Row(
                                    children: [
                                      SizedBox(width: sWidth(4, context),),
                                      CircleAvatar(
                                        radius: 55,
                                        child:  Stack(
                                          children: [
                                            Center(child: CircularProgressIndicator()),
                                            CircleAvatar(
                                              backgroundColor: Color.fromRGBO(218, 239, 245, 0.1),
                                              radius: 55,
                                              backgroundImage: NetworkImage("${StudentImageIP}${data[0].Picture}"),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: sWidth(4, context),),
                                      Column(
                                        children: [
                                          RichText(
                                            text: new TextSpan(
                                              children: <TextSpan>[
                                                new TextSpan(text: "${data[0].StudentName}",style: TextStyle(color:
                                                Colors.red,fontWeight: FontWeight.w900,fontSize: 20)),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: sHeight(1, context),),
                                          Container(
                                            height: sHeight(6, context),width: sWidth(50, context),
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius: BorderRadius.all(Radius.circular(20),),
                                            ),
                                            child: Center(child: Text("Roll No : ${data[0].RollNum}",style: TextStyle(fontSize: 19,fontWeight: FontWeight.w700,color: Colors.white),)),
                                          ),
                                          SizedBox(height: sHeight(2, context),),
                                          Text("Impres Code : ${data[0].ImpresCode}",style:
                                          TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Color.fromRGBO(173, 185, 204, 1)),),
                                        ],
                                      ),

                                    ],
                                  ),
                                  SizedBox(height: sHeight(2, context),),

                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: sHeight(2, context),),
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            width: sWidth(90, context),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(247, 252, 252, 0.8),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Column(
                              children: [
                                StudentProfileContainer(
                                    "Name             :",
                                    data[0].StudentName,
                                    context),
                                StudentProfileContainer(
                                    "Course           :",
                                    data[0].CourseFullName,
                                    context),
                                StudentProfileContainer(
                                    "Roll No           :",
                                    data[0].RollNum,
                                    context),
                                StudentProfileContainer("Register No    :",
                                    data[0].RegNo, context),
                                StudentProfileContainer("Impres Code   :",
                                    data[0].ImpresCode, context),
                                StudentProfileContainer(
                                    "Quota              :",
                                    data[0].Quota,
                                    context),
                                StudentProfileContainer("Community      :",
                                    data[0].Community, context),
                                StudentProfileContainer("First Graduate  :",
                                    data[0].FirstGraduate, context),
                                StudentProfileContainer("Admission Type :",
                                    data[0].AdmissionType, context),
                                StudentProfileContainer(
                                    "Batch Year        :",
                                    data[0].BatchYear,
                                    context),
                                StudentProfileContainer(
                                    "Insurance          :",
                                    data[0].Insurance,
                                    context),
                                StudentProfileContainer(
                                    "Date of Birth      :",
                                    data[0].DateOfBirth,
                                    context),
                                StudentProfileContainer(
                                    "Gender                :",
                                    data[0].Gender,
                                    context),
                                StudentProfileContainer(
                                    "Blood Group        :",
                                    data[0].BloodGroup,
                                    context),
                                StudentProfileContainer(
                                    "Mother Tongue    :",
                                    data[0].MotherTongue,
                                    context),
                                StudentProfileContainer(
                                    "Student Type       :",
                                    data[0].StudentType,
                                    context),
                                StudentProfileContainerInt(
                                    "Hosteller              :",
                                    data[0].Hostel,
                                    context),
                                StudentProfileContainer(
                                    "Hostel Name        :",
                                    data[0]. HostelName,
                                    context),
                                StudentProfileContainer(
                                    "Room Number       :",
                                    data[0].HostelRoom,
                                    context),
                                StudentProfileContainerInt(
                                    "Transport              :",
                                    data[0].Transport,
                                    context),
                                StudentProfileContainer(
                                    "Transport Stage    :",
                                    data[0].TransportStage,
                                    context),
                                StudentProfileContainer(
                                    "Transport Route    :",
                                    data[0].TransportRoute,
                                    context),
                                StudentProfileContainer(
                                    "Student Mobile No    :",
                                    data[0].StudentMobileNo,
                                    context),
                                StudentProfileContainer(
                                    "Father Name             :",
                                    data[0].FatherName,
                                    context),
                                StudentProfileContainer(
                                    "Father Mobile No      :",
                                    data[0].FatherMobileNo,
                                    context),
                                StudentProfileContainer(
                                    "Mother Name            :",
                                    data[0].MotherName,
                                    context),
                                StudentProfileContainer(
                                    "Mother Mobile No     :",
                                    data[0].MotherMobileNo,
                                    context),
                                StudentProfileContainer(
                                    "Guardian Name          :",
                                    data[0].GuardianName,
                                    context),
                                StudentProfileContainer(
                                    "Guardian Mobile no     :",
                                    data[0].GuardianMobileNo,
                                    context),
                                StudentProfileContainer("Email ID   :",
                                    data[0].EMailID, context),
                                StudentProfileContainerInt(
                                    "Status Active           :",
                                    data[0].Status,
                                    context),
                              ],
                            ),
                          )
                        ],
                      ),
                    )),
              );
            }
            else{
              return Scaffold(
                appBar: AppBar(
                  title: Text("My Profile", style: PrimaryText(context)),
                  centerTitle: true,
                  backgroundColor: PrimaryColor(),
                ),
                body: Center(child: Text("No Data Found", style: ErrorText2Big(),textAlign: TextAlign.center,)),
              );
            }
          }
          else{
            return Container(child: Center(child: StudentsSearching(context)), color: Colors.white,);
          }
        });
  }
}


// Student Attendance Summary
class StudentAttendance extends StatefulWidget {
  const StudentAttendance(
      {Key? key, required this.username, required this.password})
      : super(key: key);
  final String username;
  final String password;

  @override
  _StudentAttendanceState createState() => _StudentAttendanceState();
}

class _StudentAttendanceState extends State<StudentAttendance> {
  late Future<AttendanceData_List> AttendanceAPIData;
  late Future<Data_List> APIData;
  List<int> SemFind = [];
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
      content: Text("Please check your Internet Connection"),
      actions: [
        CupertinoButton.filled(child: Text("Retry"), onPressed: (){
          Navigator.pop(context);
          checkInternet();
        }),
      ],
    ));
  }
  List<int> numericalDataList = [1, 2, 3, 4, 5, 6, 7, 8, 9 ,10];

  startStreaming(){
    subscription = Connectivity().onConnectivityChanged.listen((event)async {
      checkInternet();
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AttendanceNetwork attnetwork = AttendanceNetwork(
        "attendance?RollNum=${widget.username}&Password=${widget.password}");
    AttendanceAPIData = attnetwork.AttendanceloadData();
    Network network = Network(
        "billing?RollNum=${widget.username}&Password=${widget.password}");
    APIData = network.loadData();
    // checkInternet();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: APIData,
        builder: (context, AsyncSnapshot<Data_List> snapshot) {
          if (snapshot.hasError) {
            ErrorShowingWidget(context);
          }
          List<API_data> data;
          if (snapshot.hasData) {
            data = snapshot.data!.data_list;
            return FutureBuilder(
                future: AttendanceAPIData,
                builder: (context,
                    AsyncSnapshot<AttendanceData_List> Attendancesnapshot) {
                  if (Attendancesnapshot.hasError) {
                    ErrorShowingWidget(context);
                  }
                  List<AttendanceAPI_data> Attendancedata;
                  if (Attendancesnapshot.hasData) {
                    Attendancedata =
                        Attendancesnapshot.data!.Attendancedata_list;
                    SemFind = [
                      for(int i = Attendancedata.length-1; i>=0; i--)
                        Attendancedata[i].SemesterNumber,
                    ];
                    SemFind.sort();
                    if (Attendancedata.length > 0) {
                      return Scaffold(
                          backgroundColor: Color.fromRGBO(242, 249, 250, 0.9),
                          appBar: AppBar(
                            titleSpacing: 30,
                            leadingWidth: 55,
                            title: RichText(
                              text: new TextSpan(
                                children: <TextSpan>[
                                  new TextSpan(
                                      text: 'Attendance',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)),
                                ],
                              ),
                            ),
                            toolbarHeight: 70,
                            backgroundColor: PrimaryColor(),
                            elevation: 20.0,
                            actions: <Widget>[
                            ],
                          ),
                          body: Builder(
                            builder: (BuildContext context) => SingleChildScrollView(
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(height: sHeight(3, context),),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                        borderRadius: BorderRadius.all(Radius.circular(5),)
                                      ),
                                      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                                      child: DropdownSearch<dynamic>(
                                        popupProps: PopupProps.menu(
                                        ),
                                        //dropdownDecoratorProps: DropDownDecoratorProps(),
                                        dropdownButtonProps: DropdownButtonProps(
                                          // padding: EdgeInsets.symmetric(horizontal: 20.0),
                                            icon: Icon(Icons.arrow_drop_down_circle_rounded),
                                            color: Colors.green
                                        ),
                                        items: SemFind,
                                        selectedItem: 'Select Semester',
                                        onChanged: (value) {
                                          int SEM = value;
                                          Stu = SemFind.indexOf(SEM).toInt();
                                           print(Stu);
                                           setState(() {
                                           });
                                          print(Ste);
                                        },
                                      ),
                                    ),
                                    AttendanceFullSummary(
                                        context,
                                        Attendancedata,
                                        widget.username,
                                        widget.password),
                                  ],
                                )),)
                      );
                    } else {
                      return Scaffold(
                        appBar: AppBar(
                          title:
                          Text("Attendance", style: PrimaryText(context)),
                          centerTitle: true,
                          backgroundColor: PrimaryColor(),
                        ),
                        body: Builder(
                            builder: (BuildContext context) => ListView(
                              children: <Widget>[
                                Container(
                                  height: sHeight(25, context),
                                  width: sWidth(90, context),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(10),),
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        SizedBox(width: sWidth(4, context),),
                                        CircleAvatar(
                                          radius: 55,
                                          child: Stack(
                                            children: [
                                              Center(child: CircularProgressIndicator()),
                                              CircleAvatar(
                                                backgroundColor: Color.fromRGBO(218, 239, 245, 0.1),
                                                radius: 55,
// backgroundImage: NetworkImage("https://tse2.mm.bing.net/th?id=OIP.mDpORGilB-hIUna_BUxCowAAAA&pid=Api&P=0"),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: sWidth(4, context),),
                                        RichText(
                                          text: new TextSpan(
                                            children: <TextSpan>[
                                              new TextSpan(text: "${data[0].StudentName}\n\n",style: TextStyle(color:
                                              Colors.red,fontWeight: FontWeight.w900,fontSize: 25)),
                                              new TextSpan(text: '${data[0].CourseFullName}\n\n', style: TextStyle(fontWeight:
                                              FontWeight.bold,fontSize: 15,color: Colors.black)),
                                              new TextSpan(text: 'Batch : ${data[0].BatchYear}', style: TextStyle(fontWeight:
                                              FontWeight.bold,fontSize: 15,color: Colors.black)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: sWidth(4, context),),
                                Center(
                                    child: Image.asset('images/Dataimg/data_not_found.png'))
                              ],
                            )),
                      );
                    }
                  } else {
                    return Container(
                      child: Center(child: CircularProgressIndicator()),
                      color: Colors.white,
                    );
                  }
                });
          } else {
            return Container(
              child: Center(child: StudentsSearching(context)),
              color: Colors.white,
            );
          }
        });
  }
}

class StudentAttendanceAbstansia extends StatefulWidget {
  const StudentAttendanceAbstansia(
      {Key? key,
        required this.username,
        required this.SemestedID,
        required this.SemNo,
        required this.password})
      : super(key: key);
  final String username;
  final String SemestedID;
  final String SemNo;
  final String password;

  @override
  _StudentAttendanceAbstansiaState createState() =>
      _StudentAttendanceAbstansiaState();
}

class _StudentAttendanceAbstansiaState extends State<StudentAttendanceAbstansia> {
  late Future<AttendanceData_List> AttendanceAPIData;
  late Future<Data_List> APIData;
  late Future<AttendanceAbstansiaData_List> AttendanceAbstansiaData;
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
      content: Text("Please check your Internet Connection"),
      actions: [
        CupertinoButton.filled(child: Text("Retry"), onPressed: (){
          Navigator.pop(context);
          checkInternet();
        }),
      ],
    ));
  }
  startStreaming(){
    subscription = Connectivity().onConnectivityChanged.listen((event)async {
      checkInternet();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AttendanceNetwork attnetwork = AttendanceNetwork(
        "attendance?RollNum=${widget.username}&Password=${widget.password}");
    AttendanceAPIData = attnetwork.AttendanceloadData();
    Network network = Network(
        "billing?RollNum=${widget.username}&Password=${widget.password}");
    APIData = network.loadData();
    AttendanceAbstansiaNetwork absnetwork = AttendanceAbstansiaNetwork(
        "attendance?RollNum=${widget.username}&Password=${widget.password}&SemPeriodId=${widget.SemestedID.toLowerCase()}");
    AttendanceAbstansiaData = absnetwork.AttendanceAbstansialoadData();
    checkInternet();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AttendanceAPIData,
        builder:
            (context, AsyncSnapshot<AttendanceData_List> Attendancesnapshot) {
          if (Attendancesnapshot.hasError) {
            ErrorShowingWidget(context);
          }
          List<AttendanceAPI_data> Attendancedata;
          if (Attendancesnapshot.hasData) {
            Attendancedata = Attendancesnapshot.data!.Attendancedata_list;
            return FutureBuilder(
                future: APIData,
                builder: (context, AsyncSnapshot<Data_List> snapshot) {
                  if (snapshot.hasError) {
                    ErrorShowingWidget(context);
                  }
                  List<API_data> data;
                  if (snapshot.hasData) {
                    data = snapshot.data!.data_list;
                    return FutureBuilder(
                        future: AttendanceAbstansiaData,
                        builder: (context,
                            AsyncSnapshot<AttendanceAbstansiaData_List>
                            snapshot) {
                          if (snapshot.hasError) {
                            ErrorShowingWidget(context);
                          }
                          List<AttendanceAbstansiaAPI_data> absdata;
                          if (snapshot.hasData) {
                            absdata = snapshot.data!.AttendanceAbstansiadata_list;
                            if (absdata.length > 0) {
                              return Scaffold(
                                  backgroundColor: Color.fromRGBO(242, 249, 250, 0.9),
                                  appBar: AppBar(
                                    titleSpacing: 30,
                                    leadingWidth: 55,
                                    title: RichText(
                                      text: new TextSpan(
                                        children: <TextSpan>[
                                          new TextSpan(
                                              text: 'Absentia ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20)),
                                        ],
                                      ),
                                    ),
                                    toolbarHeight: 70,
                                    backgroundColor: PrimaryColor(),
                                    elevation: 5.0,
                                    actions: <Widget>[

                                    ],
                                  ),
                                  body: Builder(
                                    builder: (BuildContext context) => SingleChildScrollView(
                                        child: Column(
                                          children: <Widget>[
                                            Column(
                                              children: <Widget>[
                                                SizedBox(
                                                  height: sHeight(1.5, context),
                                                ),
                                               /* Column(
                                                  children: [
                                                    SizedBox(height: sHeight(2, context),),
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text("       ${Attendancedata.SemesterName}",style: TextStyle(fontSize: 18,color: Colors.green,fontWeight: FontWeight.w900),),
                                                      ],
                                                    ),
                                                    SizedBox(height: sHeight(2.5, context),),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        Column(
                                                          children: [
                                                            Text("Sem  ",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                                                            SizedBox(height: sHeight(1, context),),
                                                            Text("${Attendancedata.SemesterNumber}",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
                                                            SizedBox(height: sHeight(1, context),),
                                                            Container(
                                                              width: sWidth(15, context),
                                                              decoration: BoxDecoration(
                                                                  color: Color(0xFFE23F8B),
                                                                  borderRadius: BorderRadius.all(Radius.circular(5),)),
                                                              child: Column(
                                                                children: [
                                                                  SizedBox(height: sHeight(1, context),),
                                                                  Center(
                                                                    child: Text("Days",style: TextStyle(fontSize: 10,color: Colors.white,fontWeight: FontWeight.w600),),
                                                                  ),
                                                                  Center(
                                                                    child: Text("${Attendancedata.TotalDays}",style: TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.w900),),
                                                                  ),
                                                                  SizedBox(height: sHeight(1, context),),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(height: sHeight(1, context),),
                                                            Container(
                                                              width: sWidth(15, context),
                                                              decoration: BoxDecoration(
                                                                  color: Color(0xFFE23F8B),
                                                                  borderRadius: BorderRadius.all(Radius.circular(5),)),
                                                              child: Column(
                                                                children: [
                                                                  SizedBox(height: sHeight(1, context),),
                                                                  Center(
                                                                    child: Text("Hours",style: TextStyle(fontSize: 10,color: Colors.white,fontWeight: FontWeight.w600),),
                                                                  ),
                                                                  Center(
                                                                    child: Text("${Attendancedata.TotalHours}",style: TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.w900),),
                                                                  ),
                                                                  SizedBox(height: sHeight(1, context),),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Column(
                                                          children: [
                                                            Text("Year  ",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                                                            SizedBox(height: sHeight(1, context),),
                                                            Text("${Attendancedata.Year}",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
                                                            SizedBox(height: sHeight(1, context),),
                                                            Container(
                                                              width: sWidth(15, context),
                                                              decoration: BoxDecoration(
                                                                  color: Colors.green,
                                                                  borderRadius: BorderRadius.all(Radius.circular(5),)),
                                                              child: Column(
                                                                children: [
                                                                  SizedBox(height: sHeight(1, context),),
                                                                  Center(
                                                                    child: Text("Pre",style: TextStyle(fontSize: 10,color: Colors.white,fontWeight: FontWeight.w600),),
                                                                  ),
                                                                  Center(
                                                                    child: Text("${Attendancedata.DaysPresent}",style: TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.w900),),
                                                                  ),
                                                                  SizedBox(height: sHeight(1, context),),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(height: sHeight(1, context),),
                                                            Container(
                                                              width: sWidth(15, context),
                                                              decoration: BoxDecoration(
                                                                  color: Colors.green,
                                                                  borderRadius: BorderRadius.all(Radius.circular(5),)),
                                                              child: Column(
                                                                children: [
                                                                  SizedBox(height: sHeight(1, context),),
                                                                  Center(
                                                                    child: Text("Pre",style: TextStyle(fontSize: 10,color: Colors.white,fontWeight: FontWeight.w600),),
                                                                  ),
                                                                  Center(
                                                                    child: Text("${Attendancedata.HoursPresent}",style: TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.w900),),
                                                                  ),
                                                                  SizedBox(height: sHeight(1, context),),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Column(
                                                          children: [
                                                            Text("From  ",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                                                            SizedBox(height: sHeight(1, context),),
                                                            Text("${Attendancedata.AttendanceFromDate}",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
                                                            SizedBox(height: sHeight(1, context),),
                                                            Container(
                                                              width: sWidth(15, context),
                                                              decoration: BoxDecoration(
                                                                  color: Color(0XFFF5BADF2),
                                                                  borderRadius: BorderRadius.all(Radius.circular(5),)),
                                                              child: Column(
                                                                children: [
                                                                  SizedBox(height: sHeight(1, context),),
                                                                  Center(
                                                                    child: Text("Abs",style: TextStyle(fontSize: 10,color: Colors.white,fontWeight: FontWeight.w600),),
                                                                  ),
                                                                  Center(
                                                                    child: Text("${Attendancedata.DayAbsent}",style: TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.w900),),
                                                                  ),
                                                                  SizedBox(height: sHeight(1, context),),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(height: sHeight(1, context),),
                                                            Container(
                                                              width: sWidth(15, context),
                                                              decoration: BoxDecoration(
                                                                  color: Color(0XFFF5BADF2),
                                                                  borderRadius: BorderRadius.all(Radius.circular(5),)),
                                                              child: Column(
                                                                children: [
                                                                  SizedBox(height: sHeight(1, context),),
                                                                  Center(
                                                                    child: Text("Abs",style: TextStyle(fontSize: 10,color: Colors.white,fontWeight: FontWeight.w600),),
                                                                  ),
                                                                  Center(
                                                                    child: Text("${Attendancedata.HoursAbsent}",style: TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.w900),),
                                                                  ),
                                                                  SizedBox(height: sHeight(1, context),),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Column(
                                                          children: [
                                                            Text("To  ",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                                                            SizedBox(height: sHeight(1, context),),
                                                            Text("${Attendancedata.AttendanceToDate}",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
                                                            SizedBox(height: sHeight(1, context),),
                                                            Container(
                                                              width: sWidth(15, context),
                                                              decoration: BoxDecoration(
                                                                  color: Color(0XFFF97A52),
                                                                  borderRadius: BorderRadius.all(Radius.circular(5),)),
                                                              child: Column(
                                                                children: [
                                                                  SizedBox(height: sHeight(1, context),),
                                                                  Center(
                                                                    child: Text("Per%",style: TextStyle(fontSize: 10,color: Colors.white,fontWeight: FontWeight.w600),),
                                                                  ),
                                                                  Center(
                                                                    child: Text("${Attendancedata.DaysPresentPercentage}",style: TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.w900),),
                                                                  ),
                                                                  SizedBox(height: sHeight(1, context),),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(height: sHeight(1, context),),
                                                            Container(
                                                              width: sWidth(15, context),
                                                              decoration: BoxDecoration(
                                                                  color: Color(0XFFF97A52),
                                                                  borderRadius: BorderRadius.all(Radius.circular(5),)),
                                                              child: Column(
                                                                children: [
                                                                  SizedBox(height: sHeight(1, context),),
                                                                  Center(
                                                                    child: Text("Per%",style: TextStyle(fontSize: 10,color: Colors.white,fontWeight: FontWeight.w600),),
                                                                  ),
                                                                  Center(
                                                                    child: Text("${Attendancedata.HoursPercentage}",style: TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.w900),),
                                                                  ),
                                                                  SizedBox(height: sHeight(1, context),),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: sHeight(2.5, context),),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        InkWell(
                                                          child: Container(
                                                            margin: EdgeInsets.only(right: 25),
                                                            height: sHeight(5, context),
                                                            width: sWidth(30, context),
                                                            decoration: BoxDecoration(
                                                              color:
                                                              Color(0XFF7C6AFF),
                                                              borderRadius: BorderRadius.all(
                                                                Radius.circular(10),
                                                              ),
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                'View More',
                                                                style: TextStyle(
                                                                    color: Colors.white),
                                                              ),
                                                            ),
                                                          ),
                                                          onTap: () {

                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (BuildContext context) => StudentAttendanceAbstansia(
                                                                      username: username,
                                                                      SemestedID: Attendancedata.SemesterId.toString(),
                                                                      SemNo: SemNo,
                                                                      password: password,
                                                                    )));
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: sHeight(2, context),),
                                                  ],
                                                ),*/
                                                Container(
                                                  margin: EdgeInsets.only(left: 20,right: 20),
                                                  width: sWidth(90, context),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.all(
                                                      Radius.circular(10),
                                                    ),
                                                  ),
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      children: [
                                                        InfoDesignAttendance(
                                                            context,
                                                            "",
                                                            widget.SemestedID,
                                                            widget.username,
                                                            widget.SemNo,
                                                            widget.password),
                                                        // Text("SEM NO: $SemNo "),
                                                        /*Divider(
                                                          height: 10,
                                                          thickness: 1,
                                                          indent: 5.0,
                                                          endIndent: 5.0,
                                                          color: LineColor2(),
                                                        ),*/
                                                        AbstantiaDetailsDesignTitle(context),
                                                        for (int i =
                                                            absdata.length -
                                                                1;
                                                        i >= 0;
                                                        i--)
                                                          AbstantiaDetailsDesign(
                                                            context,
                                                            absdata[i].Date,
                                                            absdata[i].Weekday,
                                                            absdata[i]
                                                                .AbsentHours,
                                                            absdata[i]
                                                                .TotalHours
                                                                .toString(),
                                                            absdata[i]
                                                                .CumulativeHours
                                                                .toString(),
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                ),

                                              ],
                                            ),
                                          ],
                                        )),
                                  )
                              );
                            } else {
                              return Scaffold(
                                  appBar: AppBar(
                                    title: Text("My Absentia History",
                                        style: PrimaryText(context)),
                                    centerTitle: true,
                                    backgroundColor: PrimaryColor(),
                                  ),
                                  body: Builder(
                                    builder: (BuildContext context) =>
                                               Center(child: Image.asset("images/Dataimg/data_not_found.png")),
                                  ));
                            }
                          } else {
                            return Container(
                              child: Center(child: CircularProgressIndicator()),
                              color: Colors.white,
                            );
                          }
                        });
                  } else {
                    return Container(
                      child: Center(child: CircularProgressIndicator()),
                      color: Colors.white,
                    );
                  }
                });
          } else {
            return Container(
              child: Center(child: CircularProgressIndicator()),
              color: Colors.white,
            );
          }
        });
  }
}

class StudentAttendanceDetails extends StatefulWidget {
  const StudentAttendanceDetails(
      {Key? key,
        required this.username,
        required this.SemestedID,
        required this.password,
        required this.SemNo})
      : super(key: key);
  final String username;
  final String SemestedID;
  final String password;
  final String SemNo;

  @override
  _StudentAttendanceDetailsState createState() =>
      _StudentAttendanceDetailsState();
}

class _StudentAttendanceDetailsState extends State<StudentAttendanceDetails> {

  late Future<AttendanceData_List> AttendanceAPIData;
  late Future<Data_List> APIData;
  late Future<AttendanceDetailsData_List> AttendanceDetailsData;
  DateTime SelectedDate = DateTime.now();
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
      content: Text("Please check your Internet Connection"),
      actions: [
        CupertinoButton.filled(child: Text("Retry"), onPressed: (){
          Navigator.pop(context);
          checkInternet();
        }),
      ],
    ));
  }
  startStreaming(){
    subscription = Connectivity().onConnectivityChanged.listen((event)async {
      checkInternet();
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AttendanceNetwork attnetwork = AttendanceNetwork(
        "attendance?RollNum=${widget.username}&Password=${widget.password}");
    AttendanceAPIData = attnetwork.AttendanceloadData();
    Network network = Network(
        "billing?RollNum=${widget.username}&Password=${widget.password}");
    APIData = network.loadData();
    AttendanceDetailsNetwork detnetwork = AttendanceDetailsNetwork(
        "attendanceDetail?RollNum=${widget.username}&Password=${widget.password}&SemPeriodId=${widget.SemestedID.toLowerCase()}");
    AttendanceDetailsData = detnetwork.AttendanceDetailsloadData();
    checkInternet();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AttendanceAPIData,
        builder:
            (context, AsyncSnapshot<AttendanceData_List> Attendancesnapshot) {
          if (Attendancesnapshot.hasError) {
            ErrorShowingWidget(context);
          }
          List<AttendanceAPI_data> Attendancedata;
          if (Attendancesnapshot.hasData) {
            Attendancedata = Attendancesnapshot.data!.Attendancedata_list;
            return FutureBuilder(
                future: APIData,
                builder: (context, AsyncSnapshot<Data_List> snapshot) {
                  if (snapshot.hasError) {
                    ErrorShowingWidget(context);
                  }
                  List<API_data> data;
                  if (snapshot.hasData) {
                    data = snapshot.data!.data_list;
                    return FutureBuilder(
                        future: AttendanceDetailsData,
                        builder: (context,
                            AsyncSnapshot<AttendanceDetailsData_List>
                            snapshot) {
                          if (snapshot.hasError) {
                            ErrorShowingWidget(context);
                          }
                          List<AttendanceDetailsAPI_data> detailsdata;
                          if (snapshot.hasData) {
                            detailsdata =
                                snapshot.data!.AttendanceDetailsdata_list;
                            if (detailsdata.length > 0) {
                              return Scaffold(
                                  backgroundColor: Color.fromRGBO(239, 242, 253, 0.9),
                                  appBar: AppBar(
                                    titleSpacing: 30,
                                    leadingWidth: 55,
                                    title: RichText(
                                      text: new TextSpan(
                                        children: <TextSpan>[
                                          new TextSpan(
                                              text: 'Attendance Details',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20)),
                                        ],
                                      ),
                                    ),
                                    toolbarHeight: 70,
                                    backgroundColor: PrimaryColor(),
                                    elevation: 20.0,
                                    actions: <Widget>[
                                    ],
                                  ),
                                  body: Builder(
                                    builder: (BuildContext context) =>
                                        SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                Column(
                                                  children: <Widget>[
                                                    SizedBox(
                                                      height: sHeight(2, context),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(left: 15,right: 15),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.all(
                                                          Radius.circular(10),
                                                        ),
                                                      ),
                                                      child: SingleChildScrollView(
                                                        scrollDirection: Axis.horizontal,
                                                        child: Column(
                                                          children: <Widget>[
                                                            Row(
                                                              children: [
                                                                Container(
                                                                  child: Column(
                                                                    children: [
                                                                      SizedBox(
                                                                        height: sHeight(0.5, context),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Container(
                                                                  margin: EdgeInsets.only(
                                                                      left: 30.0, top: 20.0),
                                                                  child: Text(
                                                                      "Semester  : ${detailsdata[0].Semester.toString()}",
                                                                      style: PrimaryText2()),
                                                                ),
                                                              ],
                                                            ),
                                                            Divider(
                                                       height: 20,
                                                       thickness: 2,
                                                       indent: 20.0,
                                                       endIndent: 20.0,
                                                       color: LineColor2(),
                                                     ),
                                                            DisplayAttendanceDetails(
                                                                context, detailsdata),
                                                            Text(" ********** End Of Statement ********** "),
                                                            SizedBox(height: sHeight(3, context),)
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )),
                                  ));
                            } else {
                              return Scaffold(
                                appBar: AppBar(
                                  title: Text("Attendance Details",
                                      style: PrimaryText(context)),
                                  centerTitle: true,
                                  backgroundColor: PrimaryColor(),
                                ),
                                body: Builder(
                                    builder: (BuildContext context) => ListView(
                                      children: <Widget>[
                                        AttendanceProfile1(
                                            context, data[0]),
                                        AttendanceProfile2(context, data[0],
                                            Attendancedata[0]),
                                        AttendanceProfileDivider(),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 15.0, bottom: 15.0),
                                          child: Text("Attendance details",
                                              style: PrimaryText2Big()),
                                        ),
                                        Center(
                                            child: Text(
                                              "No Data Found",
                                              style: ErrorText2Big(),
                                              textAlign: TextAlign.center,
                                            ))
                                      ],
                                    )),
                              );
                            }
                          } else {
                            return Container(
                              child: Center(child: CircularProgressIndicator()),
                              color: Colors.white,
                            );
                          }
                        });
                  } else {
                    return Container(
                      child: Center(child: CircularProgressIndicator()),
                      color: Colors.white,
                    );
                  }
                });
          } else {
            return Container(
              child: Center(child: CircularProgressIndicator()),
              color: Colors.white,
            );
          }
        });
  }
}
// Student Internal Mark

class StudentInternalMark extends StatefulWidget {
  const StudentInternalMark({Key? key, required this.username, required this.password}) : super(key: key);
  final String username;
  final String password;
  @override
  _StudentInternalMarkState createState() => _StudentInternalMarkState();
}

class _StudentInternalMarkState extends State<StudentInternalMark> {

  late Future <AttendanceData_List> AttendanceAPIData;
  late Future <Data_List> APIData;
  late Future <InternalMarkData_List> InternalMarkAPIData;
  List<int> Internal_Find = [];
  var Exam_Find = [];
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
      content: Text("Please check your Internet Connection"),
      actions: [
        CupertinoButton.filled(child: Text("Retry"), onPressed: (){
          Navigator.pop(context);
          checkInternet();
        }),
      ],
    ));
  }
  startStreaming(){
    subscription = Connectivity().onConnectivityChanged.listen((event)async {
      checkInternet();
    });
  }

  // Dummy() {
  //   List<double> myNumbers = [1, 2.5, 3, 4, -3, 5.4, 7];
  //   myNumbers.sort();
  //   print('Ascending order: $myNumbers');
  //   print('Descending order ${myNumbers.reversed}');
  // }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AttendanceNetwork attnetwork = AttendanceNetwork("attendance?RollNum=${widget.username}&Password=${widget.password}");
    AttendanceAPIData = attnetwork.AttendanceloadData();
    Network network = Network("billing?RollNum=${widget.username}&Password=${widget.password}");
    APIData = network.loadData();
    InternalMarkNetwork InternalMarknetwork = InternalMarkNetwork("internalmarkdisplay?RollNum=${widget.username}&Password=${widget.password}");
    InternalMarkAPIData = InternalMarknetwork.InternalMarkloadData();
    // checkInternet();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AttendanceAPIData,
        builder: (context, AsyncSnapshot<AttendanceData_List> Attendancesnapshot){
          if(Attendancesnapshot.hasError){
            ErrorShowingWidget(context);
          }
          List <AttendanceAPI_data> Attendancedata;
          if(Attendancesnapshot.hasData){
            Attendancedata = Attendancesnapshot.data!.Attendancedata_list;
            return FutureBuilder(
                future: APIData,
                builder: (context, AsyncSnapshot<Data_List> snapshot){
                  if(snapshot.hasError){
                    ErrorShowingWidget(context);
                  }
                  List <API_data> data;
                  if(snapshot.hasData) {
                    data = snapshot.data!.data_list;
                    return FutureBuilder(
                        future: InternalMarkAPIData,
                        builder: (context, AsyncSnapshot<InternalMarkData_List> snapshot) {
                          if (snapshot.hasError) {
                            ErrorShowingWidget(context);
                          }
                          List <InternalMarkAPI_data> InternalMarkdata;
                          if (snapshot.hasData) {
                            InternalMarkdata = snapshot.data!.InternalMarkdata_list;
                            Internal_Find = [
                              for(int i = InternalMarkdata.length - 1; i >=
                                  0; i--)
                                InternalMarkdata[i].SemesterNo
                            ];
                            Internal_Find.sort();
                            print("-------------------${InternalMarkdata
                                .length}");
                            // Exam_Find = [for(int i = InternalMarkdata[Ste].TestNameList.length -1; i>=0; i--)
                            //   InternalMarkdata[Ste].TestNameList[i].TestName];
                            if (InternalMarkdata.length > 0) {
                              return Scaffold(
                                backgroundColor: Color.fromRGBO(
                                    242, 249, 250, 0.9),
                                appBar: AppBar(
                                  titleSpacing: 30,
                                  leadingWidth: 55,
                                  title: RichText(
                                    text: new TextSpan(
                                      children: <TextSpan>[
                                        new TextSpan(text: 'Internal Marks',
                                            style: TextStyle(fontWeight:
                                            FontWeight.bold, fontSize: 20)),
                                      ],
                                    ),
                                  ),
                                  toolbarHeight: 70,
                                  backgroundColor: PrimaryColor(),
                                  elevation: 20.0,
                                  actions: <Widget>[
                                  ],
                                ),
                                body: Builder(
                                    builder: (BuildContext context) =>
                                        SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: Column(
                                            children: <Widget>[
                                              SizedBox(
                                                height: sHeight(1, context),),
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius
                                                        .all(
                                                      Radius.circular(5),)
                                                ),
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 20.0,
                                                    vertical: 10.0),
                                                child: DropdownSearch<dynamic>(
                                                  popupProps: PopupProps
                                                      .menu(
                                                  ),
                                                  dropdownDecoratorProps: DropDownDecoratorProps(
                                                  ),
                                                  dropdownButtonProps: DropdownButtonProps(
                                                      padding: EdgeInsets
                                                          .symmetric(
                                                          horizontal: 20.0),
                                                      icon: Icon(Icons
                                                          .arrow_drop_down_circle_rounded),
                                                      color: Colors.green
                                                  ),
                                                  items: Internal_Find,
                                                  selectedItem: 'Select Your Semester',
                                                  onChanged: (value) {
                                                    int Intern = value;
                                                    Ste = Internal_Find.indexOf(
                                                        Intern).toInt();
                                                    print(Ste);
                                                    setState(() {});
                                                  },
                                                ),
                                              ),
                                              // Container(
                                              //   decoration: BoxDecoration(
                                              //       color: Colors.white,
                                              //       borderRadius: BorderRadius.all(Radius.circular(5),)
                                              //   ),
                                              //   margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                                              //   child: DropdownSearch<dynamic>(
                                              //     popupProps: PopupProps.modalBottomSheet(
                                              //       showSearchBox: true,
                                              //     ),
                                              //     dropdownDecoratorProps: DropDownDecoratorProps(
                                              //     ),
                                              //     dropdownButtonProps: DropdownButtonProps(
                                              //       // padding: EdgeInsets.symmetric(horizontal: 20.0),
                                              //         icon: Icon(Icons.arrow_drop_down_circle_rounded),
                                              //         color: Colors.green
                                              //     ),
                                              //     items: Exam_Find,
                                              //     selectedItem: 'Select Yours Exam Name',
                                              //     onChanged: (value) {
                                              //        String Exam = value.toString();
                                              //        StuE = Exam_Find.indexOf(Exam);
                                              //        print(StuE);
                                              //       setState(() {
                                              //       });
                                              //     },
                                              //   ),
                                              // ),
                                              Column(
                                                children: [
                                                  InfoDesignDetails(context,
                                                      InternalMarkdata[Ste]),
                                                  // for (int i = InternalMarkdata[InternalMarkdata.length -2].TestNameList.length-2; i >= 0; i--)
                                                  for (int i = InternalMarkdata[0].TestNameList.length - 1; i >= 0; i--)
                                                    TestNameBuilder(context, InternalMarkdata[Ste], /*StuE*/i)
                                                ],
                                              ),
                                              Container(margin: EdgeInsets.only(
                                                  bottom: 20.0)),
                                            ],
                                          ),
                                        )),
                              );
                            }
                            else{
                              return Scaffold(
                                appBar: AppBar(
                                  title: Text("Internal Marks",
                                      style: PrimaryText(context)),
                                  centerTitle: true,
                                  backgroundColor: PrimaryColor(),
                                ),
                                  body: Builder(
                                      builder:(BuildContext context) => ListView(
                                        scrollDirection: Axis.vertical,
                                        children: <Widget>[
                                          Image.asset('images/Dataimg/data_not_found.png',)
                                        ],
                                      )
                                  )
                              );
                            }
                          }
                          else {
                            return Container(
                              child: Center(child: CircularProgressIndicator()),
                              color: Colors.white,);
                          }
                        }
                    );
                  }
                  else{
                    return Container(child: Center(child: CircularProgressIndicator()), color: Colors.white,);
                  }
                });
          }
          else{
            return Container(child: Center(child: StudentsSearching(context)), color: Colors.white,);
          }
        });
  }
}

// Student University Mark
class StudentUniversityMark extends StatefulWidget {
  const StudentUniversityMark({Key? key, required this.username, required this.password}) : super(key: key);
  final String username;
  final String password;

  @override
  _StudentUniversityMarkState createState() => _StudentUniversityMarkState();
}

class _StudentUniversityMarkState extends State<StudentUniversityMark> {
  late Future <AttendanceData_List> AttendanceAPIData;
  late Future <Data_List> APIData;
  late Future <UniversityData_List> UniversityMarkAPIData;
  var SemFix  = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AttendanceNetwork attnetwork = AttendanceNetwork("attendance?RollNum=${widget.username}&Password=${widget.password}");
    AttendanceAPIData = attnetwork.AttendanceloadData();
    Network network = Network("billing?RollNum=${widget.username}&Password=${widget.password}");
    APIData = network.loadData();
    UniversityNetwork UniversityMarknetwork = UniversityNetwork("universitymark?RollNum=${widget.username}&Password=${widget.password}");
    UniversityMarkAPIData = UniversityMarknetwork.UniversityloadData();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AttendanceAPIData,
        builder: (context, AsyncSnapshot<AttendanceData_List> Attendancesnapshot){
          if(Attendancesnapshot.hasError){
            ErrorShowingWidget(context);
          }
          List <AttendanceAPI_data> Attendancedata;
          if(Attendancesnapshot.hasData){
            Attendancedata = Attendancesnapshot.data!.Attendancedata_list;
            return FutureBuilder(
                future: APIData,
                builder: (context, AsyncSnapshot<Data_List> snapshot){
                  if(snapshot.hasError){
                    ErrorShowingWidget(context);
                  }
                  List <API_data> data;
                  if(snapshot.hasData){
                    data = snapshot.data!.data_list;
                    return FutureBuilder(
                        future: UniversityMarkAPIData,
                        builder: (context, AsyncSnapshot<UniversityData_List> snapshot){
                          if(snapshot.hasError){
                            ErrorShowingWidget(context);
                          }
                          List <UniversityAPI_data> UniversityMarkdata;
                          if(snapshot.hasData){
                            UniversityMarkdata = snapshot.data!.Universitydata_list;
                            // SemFix = [
                            //   for(int i = UniversityMarkdata.length-1; i>=0; i--)
                            //     UniversityMarkdata[i].SemesterNo,
                            // ];
                            if (UniversityMarkdata.length > 0){
                              return Scaffold(
                                backgroundColor:  Color.fromRGBO(242, 249, 250, 0.9),
                                body: Builder(
                                    builder: (BuildContext context) => SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child:
                                      Column(
                                        children: <Widget>[
                                          // Container(
                                          //
                                          //
                                          //
                                          //
                                          //
                                          //   decoration: BoxDecoration(
                                          //       color: Colors.white,
                                          //       borderRadius: BorderRadius.all(Radius.circular(5),)
                                          //   ),
                                          //   margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                                          //   child: DropdownSearch<dynamic>(
                                          //     popupProps: PopupProps.modalBottomSheet(
                                          //       showSearchBox: true,
                                          //     ),
                                          //     dropdownDecoratorProps: DropDownDecoratorProps(
                                          //     ),
                                          //     dropdownButtonProps: DropdownButtonProps(
                                          //         padding: EdgeInsets.symmetric(horizontal: 20.0),
                                          //         icon: Icon(Icons.arrow_drop_down_circle_rounded),
                                          //         color: Colors.green
                                          //     ),
                                          //     items: SemFix,
                                          //     selectedItem: 'Select Yours Semester',
                                          //     onChanged: (value) {
                                          //       String Sem1 = value.toString();
                                          //       StuU = SemFix.indexOf(Sem1);
                                          //       print(StuU);
                                          //       setState(() {
                                          //       });
                                          //     },
                                          //   ),
                                          // ),

                                          InfoDesign(context, UniversityMarkdata[UniversityMarkdata.length-1], "University Marks"),
                                          SizedBox(height: sHeight(4, context),),
                                          Container(width: sWidth(100, context),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(Radius.circular(20),),
                                            ),
                                            child: Column(
                                              children: [
                                                for(int i = UniversityMarkdata.length-1; i >=0; i--)
                                                  UniversityMarkIteration(context, i, UniversityMarkdata)],),)
                                        ],
                                      ),
                                    )),
                              );
                            }
                            else{
                              return Scaffold(
                                appBar: AppBar(
                                  title: Text("University Marks", style: PrimaryText(context)),
                                  centerTitle: true,
                                  backgroundColor: PrimaryColor(),
                                ),
                                body: Builder(
                                    builder: (BuildContext context) => ListView(
                                      children: <Widget>[
                                        AttendanceProfile1(context, data[0]),
                                        AttendanceProfile2(context, data[0], Attendancedata[0]),
                                        AttendanceProfileDivider(),
                                        Container(
                                          margin: EdgeInsets.only(left: 15.0, bottom: 15.0),
                                          child: Text("University Mark", style: PrimaryText2Big()),
                                        ),
                                        Center(child: Text("No Data Found", style: ErrorText2Big(),textAlign: TextAlign.center,))
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
                    return Container(child: Center(child: CircularProgressIndicator()), color: Colors.white,);
                  }
                });
          }
          else{
            return Container(child: Center(child: StudentsSearching(context)), color: Colors.white,);
          }
        });
  }
}

// Students Timetable

class StudentsTimetable extends StatefulWidget {
  const StudentsTimetable({Key? key, required this.username, required this.password}) : super(key: key);
  final String username;
  final String password;

  @override
  _StudentsTimetableState createState() => _StudentsTimetableState();
}

class _StudentsTimetableState extends State<StudentsTimetable> {
 int cha = 0;
 bool Mon = true;
 bool Tue = false;
 bool Wed = false;
 bool Thu = false;
 bool Fri = false;
 bool Sat = false;
  late Future <AttendanceData_List> AttendanceAPIData;
  late Future <Data_List> APIData;
  late Future <TimetableData_List> TimetableAPIData;
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
     content: Text("Please check your Internet Connection"),
     actions: [
       CupertinoButton.filled(child: Text("Retry"), onPressed: (){
         Navigator.pop(context);
         checkInternet();
       }),
     ],
   ));
 }
 startStreaming(){
   subscription = Connectivity().onConnectivityChanged.listen((event)async {
     checkInternet();
   });
 }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AttendanceNetwork attnetwork = AttendanceNetwork("attendance?RollNum=${widget.username}&Password=${widget.password}");
    AttendanceAPIData = attnetwork.AttendanceloadData();
    Network network = Network("billing?RollNum=${widget.username}&Password=${widget.password}");
    APIData = network.loadData();
    TimetableNetwork Timetablenetwork = TimetableNetwork("TimeTableStudent?studentcode=${widget.username}&Password=${widget.password}");
    TimetableAPIData = Timetablenetwork.TimetableloadData();
    // checkInternet();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AttendanceAPIData,
        builder: (context, AsyncSnapshot<AttendanceData_List> Attendancesnapshot){
          if(Attendancesnapshot.hasError){
            ErrorShowingWidget(context);
          }
          List <AttendanceAPI_data> Attendancedata;
          if(Attendancesnapshot.hasData){
            Attendancedata = Attendancesnapshot.data!.Attendancedata_list;
            return FutureBuilder(
                future: APIData,
                builder: (context, AsyncSnapshot<Data_List> snapshot){
                  if(snapshot.hasError){
                    ErrorShowingWidget(context);
                  }
                  List <API_data> data;
                  if(snapshot.hasData){
                    data = snapshot.data!.data_list;
                    return FutureBuilder(
                        future: TimetableAPIData,
                        builder: (context, AsyncSnapshot<TimetableData_List> snapshot){
                          if(snapshot.hasError){
                            ErrorShowingWidget(context);
                          }
                          List <TimetableAPI_data> Timetabledata;
                          if(snapshot.hasData){
                            Timetabledata = snapshot.data!.Timetabledata_list;
                            if (Timetabledata.length > 0){
                              return Scaffold(
                                backgroundColor:  Color.fromRGBO(242, 249, 250, 0.9),
                                appBar: AppBar(
                                  titleSpacing: 30,
                                  leadingWidth: 55,
                                  title: RichText(
                                    text: new TextSpan(
                                      children: <TextSpan>[
                                        new TextSpan(text: "Time Table", style: TextStyle(fontWeight:
                                        FontWeight.bold,fontSize: 20)),
                                      ],
                                    ),
                                  ),
                                  toolbarHeight: 70,
                                  backgroundColor: PrimaryColor(),
                                  elevation: 20.0,
                                  actions: <Widget>[

                                  ],
                                ),
                                body: Builder(
                                    builder: (BuildContext context) => SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Column(
                                        children: <Widget>[
                                          SizedBox(height: sHeight(3, context),),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(Radius.circular(10),),
                                            ),
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Column(
                                                children: <Widget> [
                                                  DisplayTimetable(context, Timetabledata),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                              );
                            }
                            else{
                              return Scaffold(
                                appBar: AppBar(
                                  title: Text("Timetable", style: PrimaryText(context)),
                                  centerTitle: true,
                                  backgroundColor: PrimaryColor(),
                                ),
                                body: Builder(
                                    builder: (BuildContext context) => Center(
                                        child: Image.asset('images/Dataimg/data_not_found.png'))),
                              );
                            }
                          }
                          else{
                            return Container(child: Center(child: CircularProgressIndicator()), color: Colors.white,);
                          }
                        });

                  }
                  else{
                    return Container(child: Center(child: CircularProgressIndicator()), color: Colors.white,);
                  }
                });
          }
          else{
            return Container(child: Center(child: StudentsSearching(context)), color: Colors.white,);
          }
        });
  }
}

// Students Holiday

class StudentHoliday extends StatefulWidget {
  const StudentHoliday(
      {Key? key, required this.username, required this.password})
      : super(key: key);
  final String username;
  final String password;

  @override
  _StudentHolidayState createState() => _StudentHolidayState();
}

class _StudentHolidayState extends State<StudentHoliday> {
  late Future<AttendanceData_List> AttendanceAPIData;
  late Future<Data_List> APIData;
  late Future<HolidayData_List> HolidayAPIData;
  DateTime today = DateTime.now();
  void  _onDaySelected(DateTime day, DateTime focusedday){
    setState(() {
      today=day;
    });
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
      content: Text("Please check your Internet Connection"),
      actions: [
        CupertinoButton.filled(child: Text("Retry"), onPressed: (){
          Navigator.pop(context);
          checkInternet();
        }),
      ],
    ));
  }
  startStreaming(){
    subscription = Connectivity().onConnectivityChanged.listen((event)async {
      checkInternet();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AttendanceNetwork attnetwork = AttendanceNetwork(
        "attendance?RollNum=${widget.username}&Password=${widget.password}");
    AttendanceAPIData = attnetwork.AttendanceloadData();
    Network network = Network(
        "billing?RollNum=${widget.username}&Password=${widget.password}");
    APIData = network.loadData();
    HolidayNetwork Holidaynetwork = HolidayNetwork(
        "Holiday?StudentCode=${widget.username}&Password=${widget.password}&Student=1");
    HolidayAPIData = Holidaynetwork.HolidayloadData();
    // checkInternet();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AttendanceAPIData,
        builder:
            (context, AsyncSnapshot<AttendanceData_List> Attendancesnapshot) {
          if (Attendancesnapshot.hasError) {
            ErrorShowingWidget(context);
          }
          List<AttendanceAPI_data> Attendancedata;
          if (Attendancesnapshot.hasData) {
            Attendancedata = Attendancesnapshot.data!.Attendancedata_list;
            return FutureBuilder(
                future: APIData,
                builder: (context, AsyncSnapshot<Data_List> snapshot) {
                  if (snapshot.hasError) {
                    ErrorShowingWidget(context);
                  }
                  List<API_data> data;
                  if (snapshot.hasData) {
                    data = snapshot.data!.data_list;
                    return FutureBuilder(
                        future: HolidayAPIData,
                        builder: (context,
                            AsyncSnapshot<HolidayData_List> snapshot) {
                          if (snapshot.hasError) {
                            ErrorShowingWidget(context);
                          }
                          List<HolidayAPI_data> Holidaydata;
                          if (snapshot.hasData) {
                            Holidaydata = snapshot.data!.Holidaydata_list;
                            if (Holidaydata.length > 0) {
                              return Scaffold(
                                //backgroundColor: Color.fromRGBO(211,223,253,0.9),
                                appBar: AppBar(
                                  title: Text("Holidays",
                                      style: PrimaryText(context)),
                                  backgroundColor: PrimaryColor(),
                                ),
                                body: Builder(
                                  builder: (BuildContext context) => SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: sHeight(1, context),
                                        ),
                                        //Text("selected day = " + today.toString().split(" ")[0]),
                                        Text(
                                            "List of Holidays (${Holidaydata[0].Year})",
                                            style: TextStyle(fontSize: 24,fontWeight: FontWeight.w900)),
                                        StudentProfileContainer(


                                            "Total Holidays :",
                                            Holidaydata.length.toString(),
                                            context),
                                        for (int i = 0;
                                        i <= Holidaydata.length - 1;
                                        i++)
                                          StudentsHolidayGenerator(
                                              context, Holidaydata[i]),
                                        Container(
                                          margin:
                                          EdgeInsets.only(top: 20.0),
                                        ),
                                      ],
                                    ),
                                  ),
                                  /* child: Column(
                                          children: <Widget>[
                                            SizedBox(
                                              height: sHeight(2, context),
                                            ),
                                            Container(
                                              height: sHeight(25, context),
                                              width: sWidth(90, context),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                              ),
                                              child: SingleChildScrollView(
                                                scrollDirection: Axis.horizontal,
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      width: sWidth(4, context),
                                                    ),
                                                    CircleAvatar(
                                                      radius: 55,
                                                      child: Stack(
                                                        children: [
                                                          Center(
                                                              child:
                                                              CircularProgressIndicator()),
                                                          CircleAvatar(
                                                            backgroundColor:
                                                            Color.fromRGBO(218,
                                                                239, 245, 0.1),
                                                            radius: 55,
                                                            backgroundImage:
                                                            NetworkImage(
                                                                "${ImageIPAddress}${data[0].Picture}"),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: sWidth(4, context),
                                                    ),
                                                    RichText(
                                                      text: new TextSpan(
                                                        children: <TextSpan>[
                                                          new TextSpan(
                                                              text:
                                                              "${data[0].StudentName}\n\n",
                                                              style:
                                                              TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w900,
                                                                  fontSize:
                                                                  25)),
                                                          new TextSpan(
                                                              text:
                                                              '${data[0].CourseFullName}\n\n',
                                                              style:
                                                              TextStyle(
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .black)),
                                                          new TextSpan(
                                                              text:
                                                              'Batch : ${data[0].BatchYear}',
                                                              style:
                                                              TextStyle(
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .black)),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 15.0, top: 15.0),
                                              child: Row(
                                                children: [
                                                  Text(
                                                     // "Holiday (${Holidaydata[0].Year})",
                                                    "List of Holidays ",
                                                      style: PrimaryText5()),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin:
                                                  EdgeInsets.only(top: 10.0),
                                            ),
                                            for (int i = 0;
                                                i <= Holidaydata.length - 1;
                                                i++)
                                              StudentsHolidayGenerator(
                                                  context, Holidaydata[i]),
                                            Container(
                                              margin:
                                                  EdgeInsets.only(top: 20.0),
                                            ),
                                            Container(
                                              margin:
                                                  EdgeInsets.only(left: 15.0),
                                              child: Text("Summary",
                                                  style: PrimaryText2Big()),
                                            ),
                                            StudentProfileContainer(
                                                "Total Holidays :",
                                                Holidaydata.length.toString(),
                                                context),
                                          ],
                                        )*/
                                ),
                              );
                            }
                            else {
                              return Scaffold(
                                appBar: AppBar(
                                  title: Text("Holiday",
                                      style: PrimaryText(context)),
                                  centerTitle: true,
                                  backgroundColor: PrimaryColor(),
                                ),
                                  body: Builder(
                                      builder:(BuildContext context) => ListView(
                                        scrollDirection: Axis.vertical,
                                        children: <Widget>[
                                          Image.asset('images/Dataimg/data_not_found.png',)
                                        ],
                                      )
                                  )
                              );
                            }
                          } else {
                            return Container(
                              child: Center(child: CircularProgressIndicator()),
                              color: Colors.white,
                            );
                          }
                        });
                  }
                  else {
                    return Container(
                      child: Center(child: CircularProgressIndicator()),
                      color: Colors.white,
                    );
                  }
                });
          } else {
            return Container(
              child: Center(child: StudentsSearching(context)),
              color: Colors.white,
            );
          }
        });
  }
}
// Students Circular

class StudentCircular extends StatefulWidget {
  const StudentCircular({Key? key, required this.username, required this.password}) : super(key: key);
  final String username;
  final String password;

  @override
  _StudentCircularState createState() => _StudentCircularState();
}

class _StudentCircularState extends State<StudentCircular> {

  late Future <AttendanceData_List> AttendanceAPIData;
  late Future <Data_List> APIData;
  late Future <CircularData_List> CircularAPIData;
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
      content: Text("Please check your Internet Connection"),
      actions: [
        CupertinoButton.filled(child: Text("Retry"), onPressed: (){
          Navigator.pop(context);
          checkInternet();
        }),
      ],
    ));
  }
  startStreaming(){
    subscription = Connectivity().onConnectivityChanged.listen((event)async {
      checkInternet();
    });
  }
  String StuCirATdate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AttendanceNetwork attnetwork = AttendanceNetwork("attendance?RollNum=${widget.username}&Password=${widget.password}");
    AttendanceAPIData = attnetwork.AttendanceloadData();
    Network network = Network("billing?RollNum=${widget.username}&Password=${widget.password}");
    APIData = network.loadData();
    CircularNetwork Circularnetwork = CircularNetwork("Circular?StudentCode=${widget.username}&Password=${widget.password}&FromDateStr=01/01/2020&ToDateStr=${StuCirATdate}&Student=1");
    CircularAPIData = Circularnetwork.CircularloadData();
    // checkInternet();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AttendanceAPIData,
        builder: (context, AsyncSnapshot<AttendanceData_List> Attendancesnapshot){
          if(Attendancesnapshot.hasError){
            ErrorShowingWidget(context);
          }
          List <AttendanceAPI_data> Attendancedata;
          if(Attendancesnapshot.hasData){
            Attendancedata = Attendancesnapshot.data!.Attendancedata_list;
            return FutureBuilder(
                future: APIData,
                builder: (context, AsyncSnapshot<Data_List> snapshot){
                  if(snapshot.hasError){
                    ErrorShowingWidget(context);
                  }
                  List <API_data> data;
                  if(snapshot.hasData){
                    data = snapshot.data!.data_list;
                    return FutureBuilder(
                        future: CircularAPIData,
                        builder: (context, AsyncSnapshot<CircularData_List> snapshot){
                          if(snapshot.hasError){
                            ErrorShowingWidget(context);
                          }
                          List <CircularAPI_data> Circulardata;
                          if(snapshot.hasData){
                            Circulardata = snapshot.data!.Circulardata_list;
                            if (Circulardata.length > 0){
                              return Scaffold(
                                backgroundColor:  Color.fromRGBO(242, 249, 250, 0.9),
                                appBar: AppBar(
                                  titleSpacing: 30,
                                  leadingWidth: 55,
                                  title: RichText(
                                    text: new TextSpan(
                                      children: <TextSpan>[
                                        new TextSpan(text: 'Circulars', style: TextStyle(fontWeight:
                                        FontWeight.bold,fontSize: 20)),
                                      ],
                                    ),
                                  ),
                                  toolbarHeight: 70,
                                  backgroundColor: PrimaryColor(),
                                  elevation: 20.0,
                                  actions: <Widget>[
                                  ],
                                ),
                                body: Builder(
                                    builder: (BuildContext context) => ListView(
                                      children: <Widget>[
                                        Container(margin: EdgeInsets.only(top: 10.0),),
                                        for(int i = 0; i<= Circulardata.length-1; i++)
                                          StudentsCircularGenerator(context, Circulardata[i]),
                                        Container(margin: EdgeInsets.only(top: 20.0),)
                                      ],
                                    )),
                              );
                            }
                            else{
                              return Scaffold(
                                appBar: AppBar(
                                  title: Text("Circular", style: PrimaryText(context)),
                                  centerTitle: true,
                                  backgroundColor: PrimaryColor(),
                                ),
                                  body: Builder(
                                      builder:(BuildContext context) => ListView(
                                        scrollDirection: Axis.vertical,
                                        children: <Widget>[
                                          Image.asset('images/Dataimg/data_not_found.png',)
                                        ],
                                      )
                                  )
                              );
                            }
                          }
                          else{
                            return Container(child: Center(child: CircularProgressIndicator()), color: Colors.white,);
                          }
                        });
                  }
                  else{
                    return Container(child: Center(child: CircularProgressIndicator()), color: Colors.white,);
                  }
                });
          }
          else{
            return Container(child: Center(child: StudentsSearching(context)), color: Colors.white,);
          }
        });
  }
}

// Students OPAC

class StudentOpac extends StatefulWidget {
  const StudentOpac({Key? key, required this.username, required this.password}) : super(key: key);
  final String username;
  final String password;
  @override
  _StudentOpacState createState() => _StudentOpacState();
}

class _StudentOpacState extends State<StudentOpac> {
  final _BookFind = GlobalKey<FormState>();
  late Future <AttendanceData_List> AttendanceAPIData;
  late Future <Data_List> APIData;
  late Future <StaffOPACData_List> StaffOPACAPIData;
  late String Search = '';
  late String ItemName = '';
  late int ItemID = 1;
  late int SearchTypeIndex = 1;
  late int RecordIndex = 10;
  late List <String> ItemListName = [];
  late List <int> ItemListID= [];
  late List <String> SearchType = [
    'Keyword(All)', 'Accession No', 'Title', 'Author',
    'Subject', 'Series', 'Abstract', 'Call Number', 'Publisher',];
  late List <String> RecordType = [
    '10 Records', '25 Records', '50 Records', '100 Records', 'All Records'];
  late List <int> RecordID = [10, 25, 50, 100, 0];
  late bool done = false;
  bool isYes = false;
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
      content: Text("Please check your Internet Connection"),
      actions: [
        CupertinoButton.filled(child: Text("Retry"), onPressed: (){
          Navigator.pop(context);
          checkInternet();
        }),
      ],
    ));
  }
  startStreaming(){
    subscription = Connectivity().onConnectivityChanged.listen((event)async {
      checkInternet();
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AttendanceNetwork attnetwork = AttendanceNetwork("attendance?RollNum=${widget.username}&Password=${widget.password}");
    AttendanceAPIData = attnetwork.AttendanceloadData();
    Network network = Network("billing?RollNum=${widget.username}&Password=${widget.password}");
    APIData = network.loadData();
    StaffOPACNetwork StaffOPACnetwork = StaffOPACNetwork("opac");
    StaffOPACAPIData = StaffOPACnetwork.StaffOPACloadData();
    checkInternet();
  }
  Search_Book(){
    final form =_BookFind.currentState;
    if(form!.validate()){
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => StudentOpacSearch(
        username: widget.username,password: widget.password, Search: Search,
        RecordIndex: RecordIndex, ItemID: ItemID, SearchTypeIndex: SearchTypeIndex,)));
    }
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AttendanceAPIData,
        builder: (context, AsyncSnapshot<AttendanceData_List> Attendancesnapshot){
          if(Attendancesnapshot.hasError){
            ErrorShowingWidget(context);
          }
          List <AttendanceAPI_data> Attendancedata;
          if(Attendancesnapshot.hasData){
            Attendancedata = Attendancesnapshot.data!.Attendancedata_list;
            return FutureBuilder(
                future: APIData,
                builder: (context, AsyncSnapshot<Data_List> snapshot){
                  if(snapshot.hasError){
                    ErrorShowingWidget(context);
                  }
                  List <API_data> data;
                  if(snapshot.hasData){
                    data = snapshot.data!.data_list;
                    return FutureBuilder(
                        future: StaffOPACAPIData,
                        builder: (context, AsyncSnapshot<StaffOPACData_List> snapshot){
                          if(snapshot.hasError){
                            ErrorShowingWidget(context);
                          }
                          List <StaffOPACAPI_data> StaffOPACdata;
                          if(snapshot.hasData){
                            StaffOPACdata = snapshot.data!.StaffOPACdata_list;
                            if (StaffOPACdata.length > 0){
                              if(done == false)
                              {
                                for(int i =0; i<= StaffOPACdata.length-1; i++){
                                  ItemListName.add(StaffOPACdata[i].Name);
                                  ItemListID.add(StaffOPACdata[i].LibararyId);}
                                done = true;
                              }
                              return Scaffold(
                                body: Builder(
                                    builder: (BuildContext context) => Container(
                                      margin: EdgeInsets.only(left: 10,right: 10),
                                      height: sHeight(100, context),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Column(
                                              children: <Widget>[
                                                Container(
                                                    margin: EdgeInsets.only(bottom: 10.0)),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                        child: Text("Library",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w900,),textAlign: TextAlign.start,)),
                                                  ],
                                                ),
                                                SizedBox(height: sHeight(2, context),),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text("Select Library",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,)),
                                                  ],
                                                ),
                                                SizedBox(height: sHeight(2, context),),
                                                Row(
                                                  children: [
                                                    Stack(
                                                      children:[
                                                        Container(
                                                        height: sHeight(20, context),
                                                        width: sWidth(30, context),
                                                        color: Colors.white,
                                                        child: ClipRRect(
                                                            borderRadius: BorderRadius.all(Radius.circular(15),),
                                                            child: Image.asset("images/introscreen/libary_pic.png",fit: BoxFit.cover,)),
                                                      ),
                                                        Container(
                                                          margin: EdgeInsets.only(top: 110,left: 20),
                                                            child: Text(
                                                              'VET',
                                                              style: TextStyle(color: Colors.white,
                                                                  fontWeight: FontWeight.w900,
                                                                  fontSize: 23.0),
                                                            )),
                                                        Container(
                                                          margin: EdgeInsets.only(left: 60),
                                                          child: Checkbox(
                                                            focusColor: Colors.white,
                                                            checkColor: Colors.white,
                                                            activeColor: Colors.blue,
                                                            value: isYes,
                                                            shape: CircleBorder(),
                                                            onChanged: (bool? value) {
                                                              setState(() {
                                                                isYes = value!;
                                                              });
                                                            },
                                                            side: BorderSide(color: Colors.white,width: 2,),
                                                          ),
                                                        ),
                                                        ],
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: sHeight(2, context),),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text("Category",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w900,),),
                                                  ],
                                                ),
                                                SizedBox(height: sHeight(2, context),),
                                                Container(
                                                  child: DropdownSearch<String>(
                                                    popupProps: PopupProps.menu(),
                                                    dropdownDecoratorProps: DropDownDecoratorProps(
                                                    ),
                                                    dropdownButtonProps: DropdownButtonProps(
                                                      // padding: EdgeInsets.symmetric(horizontal: 20.0),
                                                        icon: Icon(Icons.arrow_drop_down_circle_rounded),
                                                        color: Colors.green
                                                    ),
                                                    items: SearchType,
                                                    selectedItem: 'Select Category',
                                                    onChanged: (value) {
                                                      SearchTypeIndex = 1 + SearchType.indexOf(value.toString());
                                                    },
                                                  ),
                                                ),
                                                SizedBox(height: sHeight(2, context),),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text("Book Search",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w900,),),
                                                    Text("  *",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w900,color: Colors.red),),

                                                  ],
                                                ),
                                                SizedBox(height: sHeight(2, context),),
                                                Container(
                                                  // color: Colors.green,
                                                  child: Form(
                                                        key: _BookFind,
                                                    child: TextFormField(
                                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                                        inputFormatters: [FilteringTextInputFormatter.deny(''),
                                                        ],
                                                      decoration: InputDecoration(
                                                        border: OutlineInputBorder(
                                                          borderRadius: BorderRadius.all(Radius.circular(10),),
                                                        ),
                                                        prefixIcon: Icon(Icons.search,color: Colors.black,),
                                                        hintText: "Search Keyword...",
                                                        hintStyle: TextStyle(fontSize: 13),
                                                      ),
                                                      style: TextStyle(),
                                                      validator: (e){
                                                        if (e!.isEmpty){
                                                          return "Please Enter Keyword";
                                                        }
                                                      },
                                                      onChanged: (String value){
                                                        setState(() {
                                                          Search = value.trim();
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: sHeight(2, context),),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text("Records",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w900,)),
                                                  ],
                                                ),
                                                SizedBox(height: sHeight(2, context),),
                                                Container(
                                                  child:  FormField<String>(
                                                    builder: (FormFieldState<String> state) {
                                                      return DropdownButtonHideUnderline(
                                                        child:   DropdownSearch<String>(
                                                          popupProps: PopupProps.menu(),
                                                          dropdownDecoratorProps: DropDownDecoratorProps(
                                                            // dropdownSearchDecoration: PrimaryInputDecor('Records'),
                                                          ),
                                                          dropdownButtonProps: DropdownButtonProps(
                                                              // padding: EdgeInsets.symmetric(horizontal: 20.0),
                                                              icon: Icon(Icons.arrow_drop_down_circle_rounded),
                                                              color: Colors.green
                                                          ),
                                                          items: RecordType,
                                                          selectedItem: 'Select Records',
                                                          onChanged: (value) {
                                                            RecordIndex = RecordID[RecordType.indexOf(value.toString())];
                                                          },
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                                SizedBox(height: sHeight(2, context),),
                                                InkWell(
                                                  onTap: (){
                                                    checkInternet();
                                                    Search_Book();
                                                  },
                                                  child: Container(
                                                    height: sHeight(8, context),
                                                    decoration: BoxDecoration(
                                                      color: Colors.green,
                                                      borderRadius: BorderRadius.all(Radius.circular(10),),
                                                    ),
                                                    child: Center(child: Text("SEARCH",style: TextStyle(fontWeight:FontWeight.w900,color: Colors.white),)),
                                                  ),
                                                ),
                                                SizedBox(height: sHeight(2, context),),

                                                // Container(
                                                //   margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                                                //   child: DropdownSearch<String>(
                                                //     popupProps: PopupProps.menu(),
                                                //     dropdownDecoratorProps: DropDownDecoratorProps(
                                                //       dropdownSearchDecoration: PrimaryInputDecor('Library'),
                                                //     ),
                                                //     dropdownButtonProps: DropdownButtonProps(
                                                //         padding: EdgeInsets.symmetric(horizontal: 20.0),
                                                //         icon: Icon(Icons.arrow_drop_down_sharp),
                                                //         color: Colors.black
                                                //     ),
                                                //     items: ItemListName,
                                                //     selectedItem: 'Select Library',
                                                //     onChanged: (value) {
                                                //       ItemName = value.toString();
                                                //       ItemID = ItemListID[ItemListName.indexOf(ItemName)];
                                                //     },
                                                //   ),
                                                // ),
                                                // Container(
                                                //   margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                                                //   child: DropdownSearch<String>(
                                                //     popupProps: PopupProps.menu(),
                                                //     dropdownDecoratorProps: DropDownDecoratorProps(
                                                //       dropdownSearchDecoration: PrimaryInputDecor('Category'),
                                                //     ),
                                                //     dropdownButtonProps: DropdownButtonProps(
                                                //         padding: EdgeInsets.symmetric(horizontal: 20.0),
                                                //         icon: Icon(Icons.arrow_drop_down_sharp),
                                                //         color: Colors.black
                                                //     ),
                                                //      items: SearchType,
                                                //     selectedItem: 'Search by',
                                                //     onChanged: (value) {
                                                //       SearchTypeIndex = SearchType.indexOf(value.toString());
                                                //     },
                                                //   ),
                                                // ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    )),
                              );
                            }
                            else{
                              return Scaffold(
                                body: Builder(
                                    builder: (BuildContext context) => ListView(
                                      children: <Widget>[
                                        Image.asset('images/Dataimg/data_not_found.png')
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
                    return Container(child: Center(child: CircularProgressIndicator()), color: Colors.white,);
                  }
                });
          }
          else{
            return Container(child: Center(child:StudentsSearching(context)), color: Colors.white,);
          }
        });
  }
}

// Student OPAC Search

class StudentOpacSearch extends StatefulWidget {
  const StudentOpacSearch({Key? key, required this.username, required this.password, required this.ItemID, required this.SearchTypeIndex, required this.RecordIndex, required this.Search}) : super(key: key);
  final String username;
  final String password;
  final int ItemID;
  final int SearchTypeIndex;
  final int RecordIndex;
  final String Search;

  @override
  _StudentOpacSearchState createState() => _StudentOpacSearchState();
}

class _StudentOpacSearchState extends State<StudentOpacSearch> {
  late Future <AttendanceData_List> AttendanceAPIData;
  late Future <Data_List> APIData;
  late Future<StaffOPACSearchData_List> StaffOPACSearchAPIData;
  late int start = 0;
  late int end = widget.RecordIndex-1;
  late int page = 1;
  late bool front = true;
  late bool back = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AttendanceNetwork attnetwork = AttendanceNetwork("attendance?RollNum=${widget.username}&Password=${widget.password}");
    AttendanceAPIData = attnetwork.AttendanceloadData();
    Network network = Network("billing?RollNum=${widget.username}&Password=${widget.password}");
    APIData = network.loadData();
    StaffOPACSearchNetwork StaffOPACSearchnetwork = StaffOPACSearchNetwork(
        "opac?SearchValue=${widget.Search}&SearchType=${widget.SearchTypeIndex}&Library=${widget.ItemID}&Show=0&From=1&TO=1&ResId=1");
    StaffOPACSearchAPIData = StaffOPACSearchnetwork.StaffOPACSearchloadData();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AttendanceAPIData,
        builder: (context, AsyncSnapshot<AttendanceData_List> Attendancesnapshot){
          if(Attendancesnapshot.hasError){
            ErrorShowingWidget(context);
          }
          List <AttendanceAPI_data> Attendancedata;
          if(Attendancesnapshot.hasData){
            Attendancedata = Attendancesnapshot.data!.Attendancedata_list;
            return FutureBuilder(
                future: APIData,
                builder: (context, AsyncSnapshot<Data_List> snapshot){
                  if(snapshot.hasError){
                    ErrorShowingWidget(context);
                  }
                  List <API_data> data;
                  if(snapshot.hasData){
                    data = snapshot.data!.data_list;
                    return FutureBuilder(
                        future: StaffOPACSearchAPIData,
                        builder: (context,
                            AsyncSnapshot<StaffOPACSearchData_List> StaffOPACSearchsnapshot) {
                          if(snapshot.hasError){
                            ErrorShowingWidget(context);
                          }
                          List<StaffOPACSearchAPI_data> StaffOPACSearchdata;
                          if (StaffOPACSearchsnapshot.hasData) {
                            StaffOPACSearchdata =
                                StaffOPACSearchsnapshot.data!.StaffOPACSearchdata_list;
                            if (StaffOPACSearchdata.length > 0) {
                              if(widget.RecordIndex == 0){
                                end = StaffOPACSearchdata.length-1;
                                front = false;
                              }
                              else{
                                if(StaffOPACSearchdata.length-1 <= end){
                                  end = StaffOPACSearchdata.length-1;
                                  front = false;
                                }
                              }
                              return Scaffold(
                                backgroundColor:  Color.fromRGBO(242, 249, 250, 0.9),
                                appBar: AppBar(
                                  title: Text("OPAC Search", style: PrimaryText(context)),
                                  centerTitle: true,
                                  backgroundColor: PrimaryColor(),
                                ),
                                body: Builder(
                                    builder: (BuildContext context) => ListView(
                                      scrollDirection: Axis.vertical,
                                      children: <Widget>[
                                        Column(
                                          children: <Widget>[
                                            SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Column(
                                                children: <Widget> [
                                                  // StaffOPACGeneratorTitle(context),
                                                  for(int i = start; i<=end; i++)
                                                    StaffOPACGenerator(context,StaffOPACSearchdata, i),
                                                ],
                                              ),
                                            ),
                                            Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(0),
                                                  ),
                                                ),
                                                margin: EdgeInsets.only(
                                                    bottom: 15.0)),
                                            Container(
                                              width: sWidth(90, context),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                    35.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                                  children: <Widget>[
                                                    InkWell(
                                                      child: Icon(Icons
                                                          .arrow_back_ios,),
                                                      onTap: () {
                                                        if (back == true) {
                                                          if (0 >
                                                              start -
                                                                  widget
                                                                      .RecordIndex) {
                                                            end = start;
                                                            start = 0;
                                                            page = page - 1;
                                                            back = false;
                                                            front = true;
                                                          } else {
                                                            end = start;
                                                            start = start -
                                                                widget
                                                                    .RecordIndex;
                                                            page = page - 1;
                                                            front = true;
                                                          }
                                                        }
                                                        setState(() {});
                                                      },
                                                    ),
                                                    Container(
                                                      child: Text(
                                                        page.toString(),
                                                        style:
                                                        TextStyle(fontWeight: FontWeight.w800,fontSize: 20),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      child: Icon(Icons
                                                          .arrow_forward_ios),
                                                      onTap: () {
                                                        if (front == true) {
                                                          if (StaffOPACSearchdata
                                                              .length -
                                                              1 <=
                                                              end +
                                                                  widget
                                                                      .RecordIndex) {
                                                            start = end;
                                                            end = StaffOPACSearchdata
                                                                .length -
                                                                1;
                                                            page = page + 1;
                                                            front = false;
                                                            back = true;
                                                          } else {
                                                            start = end;
                                                            end = end +
                                                                widget
                                                                    .RecordIndex;
                                                            page = page + 1;
                                                            back = true;
                                                          }
                                                        }
                                                        setState(() {});
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.green,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(15),
                                                ),
                                              ),
                                              margin: EdgeInsets.only(
                                                  top: 20.0),
                                              width: 200,
                                              height: 70,
                                              child: Center(
                                                child: Text(
                                                    "Books Found : ${StaffOPACSearchdata.length.toString()}",
                                                    style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w900)),
                                              ),
                                            ),
                                            Container(
                                                margin: EdgeInsets.only(
                                                    bottom: 15.0)),
                                            Container(
                                                margin: EdgeInsets.only(bottom: 15.0)),
                                          ],
                                        )
                                      ],
                                    )),
                              );
                            }
                            else{
                              return Scaffold(
                                appBar: AppBar(
                                  title: Text(
                                    "Book Search",
                                    style: PrimaryText(context),
                                  ),

                                backgroundColor: PrimaryColor(),
                                  elevation: 20.0,
                                ),
                                body: Builder(
                                    builder: (BuildContext context) => ListView(
                                      scrollDirection: Axis.vertical,
                                      children: <Widget>[
                                        Image.asset('images/Dataimg/data_not_found.png',)
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
                    return Container(child: Center(child: CircularProgressIndicator()), color: Colors.white,);
                  }
                });
          }
          else{
            return Container(child: Center(child: CircularProgressIndicator()), color: Colors.white,);
          }
        });
  }
}

// Student Library Transaction

class StudentLibraryTransaction extends StatefulWidget {
  const StudentLibraryTransaction({Key? key, required this.username, required this.password}) : super(key: key);
  final String username;
  final String password;

  @override
  _StudentLibraryTransactionState createState() => _StudentLibraryTransactionState();
}

class _StudentLibraryTransactionState extends State<StudentLibraryTransaction> {
  late Future <AttendanceData_List> AttendanceAPIData;
  late Future <Data_List> APIData;
  late Future <LibraryData_List> LibraryAPIData;
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
      content: Text("Please check your Internet Connection"),
      actions: [
        CupertinoButton.filled(child: Text("Retry"), onPressed: (){
          Navigator.pop(context);
          checkInternet();
        }),
      ],
    ));
  }
  startStreaming(){
    subscription = Connectivity().onConnectivityChanged.listen((event)async {
      checkInternet();
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AttendanceNetwork attnetwork = AttendanceNetwork("attendance?RollNum=${widget.username}&Password=${widget.password}");
    AttendanceAPIData = attnetwork.AttendanceloadData();
    Network network = Network("billing?RollNum=${widget.username}&Password=${widget.password}");
    APIData = network.loadData();
    LibraryNetwork Librarynetwork = LibraryNetwork("Library?StudentCode=${widget.username}&Password=${widget.password}&Method=3&Student=1");
    LibraryAPIData = Librarynetwork.LibraryloadData();
    checkInternet();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AttendanceAPIData,
        builder: (context, AsyncSnapshot<AttendanceData_List> Attendancesnapshot){
          if(Attendancesnapshot.hasError){
            ErrorShowingWidget(context);
          }
          List <AttendanceAPI_data> Attendancedata;
          if(Attendancesnapshot.hasData){
            Attendancedata = Attendancesnapshot.data!.Attendancedata_list;
            return FutureBuilder(
                future: APIData,
                builder: (context, AsyncSnapshot<Data_List> snapshot){
                  if(snapshot.hasError){
                    ErrorShowingWidget(context);
                  }
                  List <API_data> data;
                  if(snapshot.hasData){
                    data = snapshot.data!.data_list;
                    return FutureBuilder(
                        future: LibraryAPIData,
                        builder: (context, AsyncSnapshot<LibraryData_List> snapshot){
                          if(snapshot.hasError){
                            ErrorShowingWidget(context);
                          }
                          List <LibraryAPI_data> Librarydata;
                          if(snapshot.hasData){
                            Librarydata = snapshot.data!.Librarydata_list;
                            if (Librarydata.length > 0){
                              return Scaffold(
                                backgroundColor:  Color.fromRGBO(242, 249, 250, 0.9),
                                body: Builder(
                                    builder: (BuildContext context) => SingleChildScrollView(
                                      scrollDirection: Axis.vertical,

                                      child: Column(
                                        children: <Widget>[
                                          SizedBox(height: sHeight(3, context),),
                                          Container(margin: EdgeInsets.only(top: 10.0),),
                                          for(int i = 0; i<=Librarydata.length-1; i++)
                                            StaffLibraryGenerator(context,Librarydata, i),
                                        ],
                                      ),
                                    )),
                              );
                            }
                            else{
                              return Scaffold(
                                body: Builder(
                                    builder: (BuildContext context) => ListView(
                                      children: <Widget>[
                                        Image.asset('images/Dataimg/data_not_found.png')
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
                    return Container(child: Center(child: CircularProgressIndicator()), color: Colors.white,);
                  }
                });
          }
          else{
            return Container(child: Center(child: StudentsSearching(context)), color: Colors.white,);
          }
        });
  }
}

// Student Library Overdue

class StudentLibraryOverdue extends StatefulWidget {
  const StudentLibraryOverdue({Key? key, required this.username, required this.password}) : super(key: key);
  final String username;
  final String password;

  @override
  _StudentLibraryOverdueState createState() => _StudentLibraryOverdueState();
}

class _StudentLibraryOverdueState extends State<StudentLibraryOverdue> {
  late Future <AttendanceData_List> AttendanceAPIData;
  late Future <Data_List> APIData;
  late Future <LibraryData_List> LibraryAPIData;
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
      content: Text("Please check your Internet Connection"),
      actions: [
        CupertinoButton.filled(child: Text("Retry"), onPressed: (){
          Navigator.pop(context);
          checkInternet();
        }),
      ],
    ));
  }
  startStreaming(){
    subscription = Connectivity().onConnectivityChanged.listen((event)async {
      checkInternet();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AttendanceNetwork attnetwork = AttendanceNetwork("attendance?RollNum=${widget.username}&Password=${widget.password}");
    AttendanceAPIData = attnetwork.AttendanceloadData();
    Network network = Network("billing?RollNum=${widget.username}&Password=${widget.password}");
    APIData = network.loadData();
    LibraryNetwork Librarynetwork = LibraryNetwork("Library?StudentCode=${widget.username}&Password=${widget.password}&Method=1&Student=1");
    LibraryAPIData = Librarynetwork.LibraryloadData();
    checkInternet();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AttendanceAPIData,
        builder: (context, AsyncSnapshot<AttendanceData_List> Attendancesnapshot){
          if(Attendancesnapshot.hasError){
            ErrorShowingWidget(context);
          }
          List <AttendanceAPI_data> Attendancedata;
          if(Attendancesnapshot.hasData){
            Attendancedata = Attendancesnapshot.data!.Attendancedata_list;
            return FutureBuilder(
                future: APIData,
                builder: (context, AsyncSnapshot<Data_List> snapshot){
                  if(snapshot.hasError){
                    ErrorShowingWidget(context);
                  }
                  List <API_data> data;
                  if(snapshot.hasData){
                    data = snapshot.data!.data_list;
                    return FutureBuilder(
                        future: LibraryAPIData,
                        builder: (context, AsyncSnapshot<LibraryData_List> snapshot){
                          if(snapshot.hasError){
                            ErrorShowingWidget(context);
                          }
                          List <LibraryAPI_data> Librarydata;
                          if(snapshot.hasData){
                            Librarydata = snapshot.data!.Librarydata_list;
                            if (Librarydata.length > 0){
                              return Scaffold(
                                backgroundColor:  Color.fromRGBO(242, 249, 250, 0.9),
                                body: Builder(
                                    builder: (BuildContext context) => SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Column(
                                        children: <Widget>[
                                          SizedBox(height: sHeight(3, context),),
                                          for(int i = 0; i<=Librarydata.length-1; i++)
                                            StaffLibraryGenerator(context,Librarydata, i),
                                          Container(margin: EdgeInsets.only(top: 20.0),)
                                        ],
                                      ),
                                    )),
                              );
                            }
                            else{
                              return Scaffold(
                                body: Builder(
                                    builder: (BuildContext context) => ListView(
                                      children: <Widget>[
                                        Image.asset('images/Dataimg/data_not_found.png')
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
                    return Container(child: Center(child: CircularProgressIndicator()), color: Colors.white,);
                  }
                });
          }
          else{
            return Container(child: Center(child: StudentsSearching(context)), color: Colors.white,);
          }
        });
  }

}

// Students Exam Certificate

class StudentExamCertificate extends StatefulWidget {
  const StudentExamCertificate({Key? key, required this.username, required this.password}) : super(key: key);
  final String username;
  final String password;

  @override
  _StudentExamCertificateState createState() => _StudentExamCertificateState();
}

class _StudentExamCertificateState extends State<StudentExamCertificate> {
  late Future <AttendanceData_List> AttendanceAPIData;
  late Future <Data_List> APIData;
  late Future <ExamCertificateData_List> ExamCertificateAPIData;
  bool Nxt = true;
  bool Nxt1 = false;
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
      content: Text("Please check your Internet Connection"),
      actions: [
        CupertinoButton.filled(child: Text("Retry"), onPressed: (){
          Navigator.pop(context);
          checkInternet();
        }),
      ],
    ));
  }
  startStreaming(){
    subscription = Connectivity().onConnectivityChanged.listen((event)async {
      checkInternet();
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AttendanceNetwork attnetwork = AttendanceNetwork("attendance?RollNum=${widget.username}&Password=${widget.password}");
    AttendanceAPIData = attnetwork.AttendanceloadData();
    Network network = Network("billing?RollNum=${widget.username}&Password=${widget.password}");
    APIData = network.loadData();
    ExamCertificateNetwork ExamCertificatenetwork = ExamCertificateNetwork("ExamCertificate?StudentCode=${widget.username}&Password=${widget.password}");
    ExamCertificateAPIData = ExamCertificatenetwork.ExamCertificateloadData();
    checkInternet();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AttendanceAPIData,
        builder: (context, AsyncSnapshot<AttendanceData_List> Attendancesnapshot){
          if(Attendancesnapshot.hasError){
            ErrorShowingWidget(context);
          }
          List <AttendanceAPI_data> Attendancedata;
          if(Attendancesnapshot.hasData){
            Attendancedata = Attendancesnapshot.data!.Attendancedata_list;
            return FutureBuilder(
                future: APIData,
                builder: (context, AsyncSnapshot<Data_List> snapshot){
                  if(snapshot.hasError){
                    ErrorShowingWidget(context);
                  }
                  List <API_data> data;
                  if(snapshot.hasData){
                    data = snapshot.data!.data_list;
                    return FutureBuilder(
                        future: ExamCertificateAPIData,
                        builder: (context, AsyncSnapshot<ExamCertificateData_List> snapshot){
                          if(snapshot.hasError){
                            ErrorShowingWidget(context);
                          }
                          List <ExamCertificateAPI_data> ExamCertificatedata;
                          if(snapshot.hasData){
                            ExamCertificatedata = snapshot.data!.ExamCertificatedata_list;
                            if (ExamCertificatedata.length > 0){
                              return Scaffold(
                                backgroundColor:  Color.fromRGBO(242, 249, 250, 0.9),

                                body: Builder(
                                    builder: (BuildContext context) => SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Column(
                                        children: <Widget>[
                                          SizedBox(height: sHeight(2, context),),
                                           Container(
                                     child: Column(
                                       children: [
                                         for(int i = 0; i<=ExamCertificatedata.length-1; i++)
                                           Column(
                                             children: [
                                               Container(
                                                 width: sWidth(90, context),
                                                 decoration: BoxDecoration(
                                                     color: Colors.white,
                                                     borderRadius: BorderRadius.all(Radius.circular(15),)),
                                                 child: Column(
                                                   children: [
                                                     SizedBox(height: sHeight(2, context),),
                                                     Row(
                                                       children: [
                                                         Container( margin:EdgeInsets.only(left: 15) ,child: Text("Course : ",style: TextStyle(color: Colors.black38,fontSize: 17,fontWeight: FontWeight.w600),)),
                                                         Text('${data[0].CourseFullName}',style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.w600),)
                                                       ],
                                                     ),
                                                     SizedBox(height: sHeight(3, context),),
                                                     Row(
                                                       children: [
                                                         Container( margin:EdgeInsets.only(left: 15) ,child: Text("Batch   : ",style: TextStyle(color: Colors.black38,fontSize: 17,fontWeight: FontWeight.w600),)),
                                                         Text('${data[0].BatchYear}',style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.w600),)
                                                       ],
                                                     ),
                                                     /*Divider(
                                                       height: 20,
                                                       thickness: 1,
                                                       indent: 20.0,
                                                       endIndent: 20.0,
                                                       color: LineColor2(),
                                                     ),*/
                                                     StudentExamCertificateGenerator(context,ExamCertificatedata[i],),
                                                   ],
                                                 ),
                                               ),
                                               SizedBox(height: sHeight(1, context),),
                                             ],
                                           ),
                                         Container(margin: EdgeInsets.only(top: 20.0),)
                                       ],
                                     ),
                                   ),
                                        ],
                                      ),
                                    )),
                              );
                            }
                            else{
                              return Scaffold(
                                appBar: AppBar(
                                  title: Text("University MarkSheet", style: PrimaryText(context)),
                                  centerTitle: true,
                                  backgroundColor: PrimaryColor(),
                                ),
                                body: Builder(
                                    builder: (BuildContext context) => ListView(
                                      children: <Widget>[
                                        Container(
                                          height: sHeight(25, context),
                                          width: sWidth(90, context),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(Radius.circular(10),),
                                          ),
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: [
                                                SizedBox(width: sWidth(4, context),),
                                                CircleAvatar(
                                                  radius: 55,
                                                  child: Stack(
                                                    children: [
                                                      Center(child: CircularProgressIndicator()),
                                                      CircleAvatar(
                                                        backgroundColor: Color.fromRGBO(218, 239, 245, 0.1),
                                                        radius: 55,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(width: sWidth(4, context),),
                                                RichText(
                                                  text: new TextSpan(
                                                    children: <TextSpan>[
                                                      new TextSpan(text: "${data[0].StudentName}\n\n",style: TextStyle(color:
                                                      Colors.red,fontWeight: FontWeight.w900,fontSize: 25)),
                                                      new TextSpan(text: '${data[0].CourseFullName}\n\n', style: TextStyle(fontWeight:
                                                      FontWeight.bold,fontSize: 15,color: Colors.black)),
                                                      new TextSpan(text: 'Batch : ${data[0].BatchYear}', style: TextStyle(fontWeight:
                                                      FontWeight.bold,fontSize: 15,color: Colors.black)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: sWidth(4, context),),
                                        Center(
                                            child: Image.asset('images/Dataimg/data_not_found.png')) ],
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
                    return Container(child: Center(child: CircularProgressIndicator()), color: Colors.white,);
                  }
                });
          }
          else{
            return Container(child: Center(child: StudentsSearching(context)), color: Colors.white,);
          }
        });
  }
}
//Student DCB state
class StudentsDCB extends StatefulWidget {
  const StudentsDCB({Key? key, required this.username, required this.password})
      : super(key: key);
  final String username;
  final String password;

  @override
  _StudentsDCBState createState() => _StudentsDCBState();
}

class _StudentsDCBState extends State<StudentsDCB> {
  late Future<AttendanceData_List> AttendanceAPIData;
  late Future<Data_List> APIData;
  late Future<StudentDCBData_List> StudentDCBAPIData;
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
      content: Text("Please check your Internet Connection"),
      actions: [
        CupertinoButton.filled(child: Text("Retry"), onPressed: (){
          Navigator.pop(context);
          checkInternet();
        }),
      ],
    ));
  }
  startStreaming(){
    subscription = Connectivity().onConnectivityChanged.listen((event)async {
      checkInternet();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AttendanceNetwork attnetwork = AttendanceNetwork(
        "attendance?RollNum=${widget.username}&Password=${widget.password}");
    AttendanceAPIData = attnetwork.AttendanceloadData();
    Network network = Network(
        "billing?RollNum=${widget.username}&Password=${widget.password}");
    APIData = network.loadData();
    StudentDCBNetwork StudentDCBnetwork = StudentDCBNetwork(
        "SemesterDCB?StudentCode=${widget.username}&Password=${widget.password}");
    StudentDCBAPIData = StudentDCBnetwork.StudentDCBloadData();
    checkInternet();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AttendanceAPIData,
        builder:
            (context, AsyncSnapshot<AttendanceData_List> Attendancesnapshot) {
          if (Attendancesnapshot.hasError) {
            ErrorShowingWidget(context);
          }
          List<AttendanceAPI_data> Attendancedata;
          if (Attendancesnapshot.hasData) {
            Attendancedata = Attendancesnapshot.data!.Attendancedata_list;
            return FutureBuilder(
                future: APIData,
                builder: (context, AsyncSnapshot<Data_List> snapshot) {
                  if (snapshot.hasError) {
                    ErrorShowingWidget(context);
                  }
                  List<API_data> data;
                  if (snapshot.hasData) {
                    data = snapshot.data!.data_list;
                    return FutureBuilder(
                        future: StudentDCBAPIData,
                        builder: (context,
                            AsyncSnapshot<StudentDCBData_List> snapshot) {
                          if (snapshot.hasError) {
                            ErrorShowingWidget(context);
                          }
                          List<StudentDCBAPI_data> StudentDCBdata;
                          if (snapshot.hasData) {
                            StudentDCBdata = snapshot.data!.StudentDCBdata_list;
                            if (StudentDCBdata.length > 0) {
                              return Scaffold(
                                  backgroundColor: Color.fromRGBO(239, 242, 249, 0.9),
                                  body: Builder(
                                    builder: (BuildContext context) => SingleChildScrollView(
                                        child: Column(
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                              const EdgeInsets.all(5.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: <Widget>[
                                                ],
                                              ),
                                            ),
                                            for (int i = 0;
                                            i <= StudentDCBdata.length - 1;
                                            i++)
                                              StudentsDCBGenerator(
                                                  context, StudentDCBdata[i]),
                                            Container(
                                              margin:
                                              EdgeInsets.only(top: 20.0),
                                            )
                                          ],
                                        )),)
                              );
                            } else {
                              return Scaffold(
                                appBar: AppBar(
                                  title:
                                  Text("DCB", style: PrimaryText(context)),
                                  centerTitle: true,
                                  backgroundColor: PrimaryColor(),
                                ),
                                body: Builder(
                                    builder: (BuildContext context) => ListView(
                                      children: <Widget>[
                                        AttendanceProfile1(
                                            context, data[0]),
                                        AttendanceProfile2(context, data[0],
                                            Attendancedata[0]),
                                        AttendanceProfileDivider(),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 15.0, bottom: 15.0),
                                          child: Text("DCB",
                                              style: PrimaryText2Big()),
                                        ),
                                        Center(
                                            child: Text(
                                              "No Data Found",
                                              style: ErrorText2Big(),
                                              textAlign: TextAlign.center,
                                            ))
                                      ],
                                    )),
                              );
                            }
                          } else {
                            return Container(
                              child: Center(child: CircularProgressIndicator()),
                              color: Colors.white,
                            );
                          }
                        });
                  } else {
                    return Container(
                      child: Center(child: CircularProgressIndicator()),
                      color: Colors.white,
                    );
                  }
                });
          } else {
            return Container(
              child: Center(child: StudentsSearching(context)),
              color: Colors.white,
            );
          }
        });
  }
}

// Students DCB History
class StudentsDCBHistory extends StatefulWidget {
  const StudentsDCBHistory(
      {Key? key, required this.username, required this.password})
      : super(key: key);
  final String username;
  final String password;

  @override
  _StudentsDCBHistoryState createState() => _StudentsDCBHistoryState();
}

class _StudentsDCBHistoryState extends State<StudentsDCBHistory> {
  late Future<AttendanceData_List> AttendanceAPIData;
  late Future<Data_List> APIData;
  late Future<StudentDCBHistoryData_List> StudentDCBHistoryAPIData;
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
      content: Text("Please check your Internet Connection"),
      actions: [
        CupertinoButton.filled(child: Text("Retry"), onPressed: (){
          Navigator.pop(context);
          checkInternet();
        }),
      ],
    ));
  }
  startStreaming(){
    subscription = Connectivity().onConnectivityChanged.listen((event)async {
      checkInternet();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AttendanceNetwork attnetwork = AttendanceNetwork(
        "attendance?RollNum=${widget.username}&Password=${widget.password}");
    AttendanceAPIData = attnetwork.AttendanceloadData();
    Network network = Network(
        "billing?RollNum=${widget.username}&Password=${widget.password}");
    APIData = network.loadData();
    StudentDCBHistoryNetwork StudentDCBHistorynetwork = StudentDCBHistoryNetwork(
        "BillingHistory?StudentCode=${widget.username}&Password=${widget.password}");
    StudentDCBHistoryAPIData =
        StudentDCBHistorynetwork.StudentDCBHistoryloadData();
    checkInternet();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AttendanceAPIData,
        builder:
            (context, AsyncSnapshot<AttendanceData_List> Attendancesnapshot) {
          if (Attendancesnapshot.hasError) {
            ErrorShowingWidget(context);
          }
          List<AttendanceAPI_data> Attendancedata;
          if (Attendancesnapshot.hasData) {
            Attendancedata = Attendancesnapshot.data!.Attendancedata_list;
            return FutureBuilder(
                future: APIData,
                builder: (context, AsyncSnapshot<Data_List> snapshot) {
                  if (snapshot.hasError) {
                    ErrorShowingWidget(context);
                  }
                  List<API_data> data;
                  if (snapshot.hasData) {
                    data = snapshot.data!.data_list;
                    return FutureBuilder(
                        future: StudentDCBHistoryAPIData,
                        builder: (context,
                            AsyncSnapshot<StudentDCBHistoryData_List>
                            snapshot) {
                          if (snapshot.hasError) {
                            ErrorShowingWidget(context);
                          }
                          List<StudentDCBHistoryAPI_data> StudentDCBHistorydata;
                          if (snapshot.hasData) {
                            StudentDCBHistorydata =
                                snapshot.data!.StudentDCBHistorydata_list;
                            if (StudentDCBHistorydata.length > 0) {
                              return Scaffold(
                                  backgroundColor: Color.fromRGBO(239, 242, 249, 0.9),
                                  body: Builder(
                                    builder: (BuildContext context) => SingleChildScrollView(
                                        child: Column(
                                          children: <Widget>[
                                            SizedBox(height: sHeight(2, context),),
                                            for (int i = 0;
                                            i <=
                                                StudentDCBHistorydata
                                                    .length -
                                                    1;
                                            i++)
                                              StudentsDCBHistoryGenerator(
                                                  context,
                                                  StudentDCBHistorydata,
                                                  i),
                                            Container(
                                              margin:
                                              EdgeInsets.only(top: 20.0),
                                            )
                                          ],
                                        )),)
                              );
                            } else {
                              return Scaffold(
                                appBar: AppBar(
                                  title: Text("DCB History",
                                      style: PrimaryText(context)),
                                  centerTitle: true,
                                  backgroundColor: PrimaryColor(),
                                ),
                                body: Builder(
                                    builder: (BuildContext context) => ListView(
                                      children: <Widget>[
                                        AttendanceProfile1(
                                            context, data[0]),
                                        AttendanceProfile2(context, data[0],
                                            Attendancedata[0]),
                                        AttendanceProfileDivider(),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 15.0, bottom: 15.0),
                                          child: Text("DCB History",
                                              style: PrimaryText2Big()),
                                        ),
                                        Center(
                                            child: Text(
                                              "No Data Found",
                                              style: ErrorText2Big(),
                                              textAlign: TextAlign.center,
                                            ))
                                      ],
                                    )),
                              );
                            }
                          } else {
                            return Container(
                              child: Center(child: CircularProgressIndicator()),
                              color: Colors.white,
                            );
                          }
                        });
                  } else {
                    return Container(
                      child: Center(child: CircularProgressIndicator()),
                      color: Colors.white,
                    );
                  }
                });
          } else {
            return Container(
              child: Center(child: ImpLogo_Load(context)),
              color: Colors.white,
            );
          }
        });
  }
}


class HomePage1 extends StatefulWidget {
  const HomePage1({Key? key, required this.username, required this.password}) : super(key: key);
  final String username;
  final String password;


  @override
  _HomePage1State createState() => _HomePage1State();
}

class _HomePage1State extends State<HomePage1> {
  late Future <AttendanceData_List> AttendanceAPIData;
  late Future <Data_List> APIData;
  late Future <LibraryData_List> LibraryAPIData;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AttendanceNetwork attnetwork = AttendanceNetwork("attendance?RollNum=${widget.username}&Password=${widget.password}");
    AttendanceAPIData = attnetwork.AttendanceloadData();
    Network network = Network("billing?RollNum=${widget.username}&Password=${widget.password}");
    APIData = network.loadData();
    LibraryNetwork Librarynetwork = LibraryNetwork("Library?StudentCode=${widget.username}&Password=${widget.password}&Method=3&Student=1");
    LibraryAPIData = Librarynetwork.LibraryloadData();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AttendanceAPIData,
        builder: (context, AsyncSnapshot<AttendanceData_List> Attendancesnapshot){
          if(Attendancesnapshot.hasError){
            ErrorShowingWidget(context);
          }
          List <AttendanceAPI_data> Attendancedata;
          if(Attendancesnapshot.hasData){
            Attendancedata = Attendancesnapshot.data!.Attendancedata_list;
            return FutureBuilder(
                future: APIData,
                builder: (context, AsyncSnapshot<Data_List> snapshot){
                  if(snapshot.hasError){
                    ErrorShowingWidget(context);
                  }
                  List <API_data> data;
                  if(snapshot.hasData){
                    data = snapshot.data!.data_list;
                    return FutureBuilder(
                        future: LibraryAPIData,
                        builder: (context, AsyncSnapshot<LibraryData_List> snapshot){
                          if(snapshot.hasError){
                            ErrorShowingWidget(context);
                          }
                          List <LibraryAPI_data> Librarydata;
                          if(snapshot.hasData){
                            Librarydata = snapshot.data!.Librarydata_list;
                            if (Librarydata.length > 0){
                              return DefaultTabController(
                                length: 3,
                                child: Scaffold(
                                  appBar: AppBar(
                                    title:   Text('OPAC - Library Search'),
                                    backgroundColor: PrimaryColor(),
                                  ),
                                  body: Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TabBar(
                                        indicator: BoxDecoration(
                                            color: Color(0xFFF97A52),
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                        tabs: [

                                          Tab(
                                            child: Text('Book Search',style: TextStyle(color: Colors.black),),
                                          ),
                                          Tab(
                                            child: Text('Transactions',style: TextStyle(color: Colors.black),),
                                          ),
                                          Tab(
                                            child: Text('Overdue',style: TextStyle(color: Colors.black),),
                                          ),
                                        ],
                                      ),
                                      Expanded(
                                          child: TabBarView(
                                              children: [
                                                StudentOpac(username: data[0].RollNum.toLowerCase(), password: widget.password,),
                                                StudentLibraryTransaction(username: data[0].RollNum.toLowerCase(), password: widget.password,),
                                                StudentLibraryOverdue(username: data[0].RollNum.toLowerCase(), password: widget.password,)
                                              ]))
                                    ],
                                  ),
                                ),
                              );
                            }
                            else{
                              return DefaultTabController(
                                length: 3,
                                child: Scaffold(
                                  appBar: AppBar(
                                    title:   Text('Opac - Library search'),
                                    backgroundColor: PrimaryColor(),
                                  ),
                                  body: Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TabBar(
                                        indicator: BoxDecoration(
                                            color: Color(0xFFF97A52),
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                        tabs: [

                                          Tab(
                                            child: Text('Book Search',style: TextStyle(color: Colors.black),),
                                          ),
                                          Tab(
                                            child: Text('Transactions',style: TextStyle(color: Colors.black),),
                                          ),
                                          Tab(
                                            child: Text('Overdue',style: TextStyle(color: Colors.black),),
                                          ),
                                        ],
                                      ),
                                      Expanded(
                                          child: TabBarView(
                                              children: [
                                                StudentOpac(username: data[0].RollNum.toLowerCase(), password: widget.password,),
                                                StudentLibraryTransaction(username: data[0].RollNum.toLowerCase(), password: widget.password,),
                                                StudentLibraryOverdue(username: data[0].RollNum.toLowerCase(), password: widget.password,)
                                              ]))
                                    ],
                                  ),
                                ),
                              );
                            }
                          }
                          else{
                            return Container(child: Center(child: CircularProgressIndicator()), color: Colors.white,);
                          }
                        });

                  }
                  else{
                    return Container(child: Center(child: CircularProgressIndicator()), color: Colors.white,);
                  }
                });
          }
          else{
            return Container(child: Center(child: StudentsSearching(context)), color: Colors.white,);
          }
        });
  }
}

class HomePage2 extends StatefulWidget {
  const HomePage2(
      {Key? key, required this.username, required this.password})
      : super(key: key);
  final String username;
  final String password;

  @override
  _HomePage2State createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  late Future<AttendanceData_List> AttendanceAPIData;
  late Future<Data_List> APIData;
  late Future<StudentDCBHistoryData_List> StudentDCBHistoryAPIData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AttendanceNetwork attnetwork = AttendanceNetwork(
        "attendance?RollNum=${widget.username}&Password=${widget.password}");
    AttendanceAPIData = attnetwork.AttendanceloadData();
    Network network = Network(
        "billing?RollNum=${widget.username}&Password=${widget.password}");
    APIData = network.loadData();
    StudentDCBHistoryNetwork StudentDCBHistorynetwork = StudentDCBHistoryNetwork(
        "BillingHistory?StudentCode=${widget.username}&Password=${widget.password}");
    StudentDCBHistoryAPIData =
        StudentDCBHistorynetwork.StudentDCBHistoryloadData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AttendanceAPIData,
        builder:
            (context, AsyncSnapshot<AttendanceData_List> Attendancesnapshot) {
          if (Attendancesnapshot.hasError) {
            ErrorShowingWidget(context);
          }
          List<AttendanceAPI_data> Attendancedata;
          if (Attendancesnapshot.hasData) {
            Attendancedata = Attendancesnapshot.data!.Attendancedata_list;
            return FutureBuilder(
                future: APIData,
                builder: (context, AsyncSnapshot<Data_List> snapshot) {
                  if (snapshot.hasError) {
                    ErrorShowingWidget(context);
                  }
                  List<API_data> data;
                  if (snapshot.hasData) {
                    data = snapshot.data!.data_list;
                    return FutureBuilder(
                        future: StudentDCBHistoryAPIData,
                        builder: (context,
                            AsyncSnapshot<StudentDCBHistoryData_List>
                            snapshot) {
                          if (snapshot.hasError) {
                            ErrorShowingWidget(context);
                          }
                          List<StudentDCBHistoryAPI_data> StudentDCBHistorydata;
                          if (snapshot.hasData) {
                            StudentDCBHistorydata =
                                snapshot.data!.StudentDCBHistorydata_list;
                            if (StudentDCBHistorydata.length > 0) {
                              return DefaultTabController(
                                length: 2,
                                child: Scaffold(
                                  appBar: AppBar(
                                    title:   Text('Fee Details'),
                                    backgroundColor: PrimaryColor(),
                                  ),
                                  body: Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TabBar(
                                        indicator: BoxDecoration(
                                            color: Color(0xFFF97A52 ),
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                        tabs: [
                                          Tab(
                                            child: Text('Fee Details',style: TextStyle(color: Colors.black),),
                                          ),
                                          Tab(
                                            child: Text('Fee History',style: TextStyle(color: Colors.black),),
                                          ),

                                        ],
                                      ),
                                      Expanded(
                                          child: TabBarView(
                                              children: [
                                                StudentsDCB(username: data[0].RollNum.toLowerCase(), password: widget.password,),
                                                StudentsDCBHistory(username: data[0].RollNum.toLowerCase(), password: widget.password,)
                                              ]))
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return Scaffold(
                                appBar: AppBar(
                                  title: Text("DCB History",
                                      style: PrimaryText(context)),
                                  centerTitle: true,
                                  backgroundColor: PrimaryColor(),
                                ),
                              body: Builder(
                              builder:(BuildContext context) => ListView(
                                scrollDirection: Axis.vertical,
                                children: <Widget>[
                                  Image.asset('images/Dataimg/data_not_found.png',)
                                ],
                              )
                          )
                              );
                            }
                          } else {
                            return Container(
                              child: Center(child: CircularProgressIndicator()),
                              color: Colors.white,
                            );
                          }
                        });
                  } else {
                    return Container(
                      child: Center(child: CircularProgressIndicator()),
                      color: Colors.white,
                    );
                  }
                });
          } else {
            return Container(
              child: Center(child: CircularProgressIndicator()),
              color: Colors.white,
            );
          }
        });
  }
}


class Homepage3 extends StatefulWidget {
  const Homepage3({Key? key, required this.username, required this.password}) : super(key: key);
  final String username;
  final String password;

  @override
  _Homepage3State createState() => _Homepage3State();
}

class _Homepage3State extends State<Homepage3> {
  late Future <AttendanceData_List> AttendanceAPIData;
  late Future <Data_List> APIData;
  late Future <ExamCertificateData_List> ExamCertificateAPIData;
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AttendanceNetwork attnetwork = AttendanceNetwork("attendance?RollNum=${widget.username}&Password=${widget.password}");
    AttendanceAPIData = attnetwork.AttendanceloadData();
    Network network = Network("billing?RollNum=${widget.username}&Password=${widget.password}");
    APIData = network.loadData();
    ExamCertificateNetwork ExamCertificatenetwork = ExamCertificateNetwork("ExamCertificate?StudentCode=${widget.username}&Password=${widget.password}");
    ExamCertificateAPIData = ExamCertificatenetwork.ExamCertificateloadData();
    checkInternet();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AttendanceAPIData,
        builder: (context, AsyncSnapshot<AttendanceData_List> Attendancesnapshot){
          if(Attendancesnapshot.hasError){
            ErrorShowingWidget(context);
          }
          List <AttendanceAPI_data> Attendancedata;
          if(Attendancesnapshot.hasData){
            Attendancedata = Attendancesnapshot.data!.Attendancedata_list;
            return FutureBuilder(
                future: APIData,
                builder: (context, AsyncSnapshot<Data_List> snapshot){
                  if(snapshot.hasError){
                    ErrorShowingWidget(context);
                  }
                  List <API_data> data;
                  if(snapshot.hasData){
                    data = snapshot.data!.data_list;
                    return FutureBuilder(
                        future: ExamCertificateAPIData,
                        builder: (context, AsyncSnapshot<ExamCertificateData_List> snapshot){
                          if(snapshot.hasError){
                            ErrorShowingWidget(context);
                          }
                          List <ExamCertificateAPI_data> ExamCertificatedata;
                          if(snapshot.hasData){
                            ExamCertificatedata = snapshot.data!.ExamCertificatedata_list;
                            if (ExamCertificatedata.length > 0){
                              return DefaultTabController(
                                length: 2,
                                child: Scaffold(
                                  appBar: AppBar(
                                    title:   Text('University Marks'),
                                    backgroundColor: PrimaryColor(),
                                  ),
                                  body: Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TabBar(
                                        indicator: BoxDecoration(
                                            color: Color(0xFFF97A52),
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                        tabs: [

                                          Tab(
                                            child: Text('Marks',style: TextStyle(color: Colors.black),),
                                          ),
                                          Tab(
                                            child: Text('Marksheets \n Download',style: TextStyle(color: Colors.black),),
                                          ),

                                        ],
                                      ),
                                      Expanded(
                                          child: TabBarView(
                                              children: [
                                                StudentUniversityMark(username: data[0].RollNum.toLowerCase(), password: widget.password,),
                                                StudentExamCertificate(username: data[0].RollNum.toLowerCase(), password: widget.password,)
                                              ]))
                                    ],
                                  ),
                                ),
                              );
                            }
                            else{
                              return Scaffold(
                                appBar: AppBar(
                                  title: Text("University MarkSheet", style: PrimaryText(context)),
                                  centerTitle: true,
                                  backgroundColor: PrimaryColor(),
                                ),
                                body: Builder(
                                    builder: (BuildContext context) => ListView(
                                      children: <Widget>[
                                        SizedBox(height: sHeight(25, context),),
                                        Center(
                                            child: Image.asset('images/Dataimg/data_not_found.png')) ],
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
                    return Container(child: Center(child: CircularProgressIndicator()), color: Colors.white,);
                  }
                });
          }
          else{
            return Container(child: Center(child: StudentsSearching(context)), color: Colors.white,);
          }
        });
  }
}



