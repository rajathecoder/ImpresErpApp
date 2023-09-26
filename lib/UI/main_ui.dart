import 'dart:async';
import 'dart:convert';
import 'package:add_dev_dolphin/Data/Staff_Data.dart';
import 'package:add_dev_dolphin/Data/Student_Data.dart';
import 'package:add_dev_dolphin/Model/Login_Screen/login_body.dart';
import 'package:add_dev_dolphin/Model/Login_Screen/student_login.dart';
import 'package:add_dev_dolphin/Model/Staff_Screen/staff_main.dart';
import 'package:add_dev_dolphin/Model/Student_Screen/student_main.dart';
import 'package:add_dev_dolphin/Style_font/designs.dart';
import 'package:add_dev_dolphin/Style_font/student_screen_design.dart';
import 'package:add_dev_dolphin/UI/password_file.dart';
import 'package:add_dev_dolphin/intro_screen/mobile_signin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

int index = 0;
String name = '';
bool savePass = false;
bool StaffsavePass = false;
bool useStudentBiometric = false;
bool useStaffBiometric = false;
String ID = '';
String Code = '';
String StaffID = '';
String StaffCode = '';
String ItemName = '';
int Selection = -1;
String ip = '';
late ConnectivityResult result;
late StreamSubscription subscription;
var isConnected = false;
void SetID(String value){
  ID = value;
}

void SetCode(String value){
  Code = value;
}

void SetStaffID(String value){
  StaffID = value;
}

void SetStaffCode(String value){
  StaffCode = value;
}

void SetSavePass(bool value){
  savePass = value;
}

void SetStaffsavePass(bool value){
  StaffsavePass = value;
}

void SetuseStudentBiometric(bool value){
  useStudentBiometric = value;
}

void SetuseStaffBiometric(bool value){
  useStaffBiometric = value;
}

class SetupScreen extends StatefulWidget {
  const SetupScreen({Key? key}) : super(key: key);

  @override
  _SetupScreenState createState() => _SetupScreenState();
}
class _SetupScreenState extends State<SetupScreen> {
  final Stream<QuerySnapshot> users = FirebaseFirestore.instance.collection('User').snapshots();
  late bool done = false;
  late List <dynamic> ItemListName = [];
  late String CollegeImage = 'https://dhaanish.co.in/Inst/FSI/impres_erp_logo.jpg';
  late List <PageViewModel> pages = [
    PageViewModel(
        reverse: true,
        title: 'College',
        bodyWidget: Container(
          width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height/2,
            child: SetupShowcase()),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Setup", style: PrimaryText(context),),
        centerTitle: true,
        backgroundColor: PrimaryColor(),
      ),
      body: Builder(builder: (context)=> IntroductionScreen(
          pages: pages,
          showDoneButton: true,
          dotsDecorator: DotsDecorator(
              size: Size.square(15),
            activeColor: PrimaryColor(),
            activeSize: Size.square(20)
          ),
          done: Container(
            width: 70,
            height: 50,
            decoration: PrimaryRoundBox(),
            child: Center(
              child: Text("Done", style: SecondaryText()),
            ),
          ),
          onDone: ()=> onDone(context),
          showNextButton: true,
          next: Container(
            width: 70,
            height: 50,
            decoration: PrimaryRoundBox(),
            child: Center(
              child: Text("Next", style: SecondaryText()),
            ),
          ),
          showSkipButton: true,
          skip: Container(
            width: 70,
            height: 50,
            decoration: PrimaryRoundBox(),
            child: Center(
              child: Text("Skip", style: SecondaryText()),
            ),
          ),
        ),
      )
    );
  }
  void onDone(context)async {
    if(Selection == 1)
      {
        final snackbar4 = SnackBar(
          backgroundColor: Colors.red,
          content: const Text('Please Select Your College'),
          action: SnackBarAction(
            label: '',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackbar4);
      }
    else
      {
        final prefs = await SharedPreferences.getInstance();
        prefs.setInt('college', Selection);
        prefs.setString('name', ItemName);
        prefs.setString('IPAddress', ip);
        SetSetupDone(true);
        Navigator.push(context, MaterialPageRoute(builder: (context)=> StudentLoginMain()));
      }
  }
}

class SetupShowcase extends StatefulWidget {
  const SetupShowcase({Key? key}) : super(key: key);

  @override
  _SetupShowcaseState createState() => _SetupShowcaseState();
}

class _SetupShowcaseState extends State<SetupShowcase> {
  late List <dynamic> ItemListName = [];
  late String CollegeImage = 'https://dhaanish.co.in/Inst/FSI/impres_erp_logo.jpg';
  String? C_code,i;
   Map<String, dynamic> College_Details={};
  final _keyCode = GlobalKey<FormState>();
  Check_Code(){
    final form =_keyCode.currentState;
    if(form!.validate()){
      form.save();
       Search_College();
    }
  }
  Search_College()async{
    // final resp = await http.post(
    //     Uri.parse("http://15.206.173.184/upload/raja/impress/api.php"), // server login url
    //     body: {"collegeCode": C_code,});
    // print(resp.statusCode);
    // if (resp.statusCode == 200) {
    //     College_Details = json.decode(resp.body);
    //     print(College_Details);
    //      i =(College_Details["response"][0]['redirectIp'].toString());
    //      ip = i!;
    //      SetStudentIP(i!);
    //      SetStaffIP(i!);
    //     print(i);
    // } else {
    //   print("login fail");
    // }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: Column(
       children: [
         Form(
           key: _keyCode,
           child: Container(
             height: 100,width: 200,
             child: TextFormField(
               decoration: InputDecoration(
                 hintStyle: TextStyle(color: Colors.orange),
                 labelText: "Enter college code",
                 labelStyle: TextStyle(color: Colors.orange),
                 border: OutlineInputBorder(),
                 hintText: "College Code",
               ),
               keyboardType: TextInputType.number,
               validator: (e){
                 if(e!.isEmpty){
                   return "please enter your College Code";
                 }
               },
               style:  TextStyle(color: Colors.black),
               onSaved: (e)=>  C_code =  e ,
             ),
           ),
         ),
         SizedBox(height: 10,),
         ElevatedButton(onPressed: (){
           Check_Code();
         },
             child: Text("Search",style: TextStyle(),)),
          // Text(College_Details["request"]['collegeCode']),
       ],
     ),
    );
  }
}

class Login extends StatefulWidget {
  const Login({Key? key,}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late Future <CVHomeData_List> CVHomeAPIData;
  late LocalAuthentication auth = LocalAuthentication();
  late bool _canCheckBiometric = false;
  late List<BiometricType> _availableBiometrics = [];
  late String _authorized = "Not Authorized";
  late bool CVAccess = false;
  late String _cvCode = '';
  late String userName = "";
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
    }
    if(!mounted) return;
    setState(() {
      _authorized = authorized ? "Authenrized Success" : "Failed to authenticate";
      print("Authorized : $_authorized");
    });

    if(authorized){
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => ControlVault(username: 'impres', password: 'dolphin')));
    }
  }

  Future <void> _studentAuthenticate() async {
    bool authorized = false;
    try{
      authorized = await auth.authenticate(
        localizedReason: 'Scan your finger to authenticate',
      );
    } on PlatformException catch (e){
      print('Authentication error $e');
    }
    if(!mounted) return;
    setState(() {
      _authorized = authorized ? "Authenrized Success" : "Failed to authenticate";
      print("Authorized : $_authorized");
    });

    if(authorized){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => StudentHomePage(username: ID, password: Code)));
    }
  }

  Future <void> _staffAuthenticate() async {
    bool authorized = false;
    try{
      authorized = await auth.authenticate(
        localizedReason: 'Scan your finger to authenticate',
      );
    } on PlatformException catch (e){
      print('Authentication error $e');
    }
    if(!mounted) return;
    setState(() {
      _authorized = authorized ? "Authenrized Success" : "Failed to authenticate";
      print("Authorized : $_authorized");
    });

    if(authorized){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => StaffHomePage(username: StaffID, password: StaffCode)));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    college();
    CVHomeNetwork CVHomenetwork = CVHomeNetwork("appsetting?instid=1");
    CVHomeAPIData = CVHomenetwork.CVHomeloadData();
    _checkBiometric();
    _getAvailableBiometrics();
  }
  @override
  Widget build(BuildContext context) {
    college();
    final Stream<QuerySnapshot> users = FirebaseFirestore.instance.collection('User').snapshots();
    List <dynamic> CollegeNameList = [];
    return StreamBuilder<QuerySnapshot>(
      stream: users,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(snapshot.hasError) return Text('Something went wrong!!!');
        if(snapshot.connectionState == ConnectionState.waiting) return CircularProgressIndicator();
        final data = snapshot.requireData;
        CollegeNameList = data.docs[0]['Name'];
          if(CollegeNameList.contains(name)){
            return FutureBuilder(
                future: CVHomeAPIData,
                builder: (context, AsyncSnapshot<CVHomeData_List> snapshot){
                  if(snapshot.hasError){
                    ErrorShowingWidget(context);
                  }
                  List <CVHomeAPI_data> CVHomedata;
                  if(snapshot.hasData){
                    CVHomedata = snapshot.data!.CVHomedata_list;
                    if (CVHomedata.length > 0){
                      // Setting image and file values
                      SetImage(data.docs[0]['Images'][index]);
                      SetStudentIP(data.docs[0]['IPAddress'][index]);
                      SetStaffIP(data.docs[0]['IPAddress'][index]);
                      SetImageIPAddress(CVHomedata[0].WebPath);
                      SetAttendanceHours(int.parse(CVHomedata[0].AttendanceHour));
                      return Scaffold(
                        appBar: AppBar(
                          leading: Container(),
                          title: Text(data.docs[0]['Name'][index], style: PrimaryText(context)),
                          centerTitle: true,
                          backgroundColor: PrimaryColor(),
                          actions: <Widget> [
                            InkWell(
                              child: Container(
                                  margin: EdgeInsets.only(right: 30),
                                  child: Icon(Icons.phonelink_setup, size: 30,)),
                              onTap: () async {
                                UnsaveDetails();
                                SetSetupDone(false);
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> SetupScreen()));
                              },
                              onDoubleTap: (){
                                _cvCode = _cvCode + 'e';
                                print(_cvCode);
                                if(_cvCode == "acecae" || _cvCode == 'eeeffe'){
                                  showDialog(context: context, builder: (context)=> AlertDialog(
                                    title: Text('Control Vault', style: PrimaryText2(), textAlign: TextAlign.start,),
                                    content: Container(
                                      margin: EdgeInsets.only(top: 20.0),
                                      child: TextField(
                                        decoration: PrimaryInputDecor(" Enter PIN to Continue"),
                                        obscureText: true,
                                        keyboardType: TextInputType.number,
                                        style: SecondaryText2(),
                                        onChanged: (String value) => _setvalueUsername(value),
                                      ),
                                    ),
                                    actionsAlignment: MainAxisAlignment.spaceBetween,
                                    actionsPadding: EdgeInsets.only(left: 30, right: 30, bottom: 15),
                                    actions: [
                                      InkWell(
                                        child: Text('OK', style: PrimaryText2(), textAlign: TextAlign.start,),
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      InkWell(
                                        child: Text('Cancel', style: PrimaryText2(), textAlign: TextAlign.start,),
                                        onTap: ()=> Navigator.pop(context),
                                      ),
                                    ],
                                    elevation: 20.0,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                  ));
                                }
                              },
                              onLongPress: (){
                                _cvCode = _cvCode + 'f';
                                print(_cvCode);
                              },
                            )
                          ],
                        ),
                        body: Builder(
                            builder: (BuildContext context) => ListView(
                              scrollDirection: Axis.vertical,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    WelcomeImage(context),
                                    InkWell(
                                        child: StudentLogin(),
                                        onTap: () {
                                          setState(() {
                                          });
                                          if(savePass == false)
                                          {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => StudentLoginMain()));
                                          }
                                          else{
                                            if(useStudentBiometric){
                                                _studentAuthenticate();
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => StudentLoginMain()));
                                              }
                                                else {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              StudentHomePage(
                                                                  username: ID,
                                                                  password: Code)));
                                                }
                                          }
                                        },
                                      onDoubleTap: (){
                                          _cvCode = _cvCode + 'a';
                                          print(_cvCode);
                                      },
                                      onLongPress: (){
                                        _cvCode = _cvCode + 'b';
                                        print(_cvCode);
                                      },
                                    ),
                                    InkWell(
                                      child: StaffLogin(),
                                      onTap: () {
                                        setState(() {

                                        });
                                        if(StaffsavePass == false)
                                        {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => StaffLoginMain()));
                                        }
                                        else {
                                          if (useStaffBiometric) {
                                            _staffAuthenticate();
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        StaffLoginMain()));
                                          }
                                            else {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          StaffHomePage(
                                                              username: StaffID,
                                                              password: StaffCode)));
                                            }
                                        }
                                      },
                                      onDoubleTap: (){
                                        _cvCode = _cvCode + 'c';
                                        print(_cvCode);
                                      },
                                      onLongPress: (){
                                        _cvCode = _cvCode + 'd';
                                        print(_cvCode);
                                      },
                                    ),
                                    if(CVAccess)
                                    InkWell(
                                      child: Container(
                                        margin: EdgeInsets.only(top: 20.0),
                                        width: 200,
                                        height: 70,
                                        decoration: PrimaryRoundBox(),
                                        child: Center(
                                          child: Text("Control\nVault", style: SecondaryText(), textAlign: TextAlign.center,),
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=> CVNavigator()));
                                        if(_canCheckBiometric){
                                          _authenticate();
                                        }
                                      }),
                                  ],
                                ),
                              ],
                            )),
                      );
                    }
                    else{
                      return Scaffold(
                        appBar: AppBar(
                          leading: Container(),
                          title: Text('Sorry', style: PrimaryText(context)),
                          centerTitle: true,
                          backgroundColor: PrimaryColor(),
                          actions: <Widget> [
                            InkWell(
                              child: Container(
                                  margin: EdgeInsets.only(right: 30),
                                  child: Icon(Icons.phonelink_setup, size: 30,)),
                              onTap: () async {
                                UnsaveDetails();
                                SetSetupDone(false);
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> SetupScreen()));
                              },
                              onDoubleTap: (){
                                _cvCode = _cvCode + 'e';
                                print(_cvCode);
                                if(_cvCode == "acecae" || _cvCode == 'eeeffe'){
                                  showDialog(context: context, builder: (context)=> AlertDialog(
                                    title: Text('Control Vault', style: PrimaryText2(), textAlign: TextAlign.start,),
                                    content: Container(
                                      margin: EdgeInsets.only(top: 20.0),
                                      child: TextField(
                                        decoration: PrimaryInputDecor(" Enter PIN to Continue"),
                                        obscureText: true,
                                        keyboardType: TextInputType.number,
                                        style: SecondaryText2(),
                                        onChanged: (String value) => _setvalueUsername(value),
                                      ),
                                    ),
                                    actionsAlignment: MainAxisAlignment.spaceBetween,
                                    actionsPadding: EdgeInsets.only(left: 30, right: 30, bottom: 15),
                                    actions: [
                                      InkWell(
                                        child: Text('OK', style: PrimaryText2(), textAlign: TextAlign.start,),
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      InkWell(
                                        child: Text('Cancel', style: PrimaryText2(), textAlign: TextAlign.start,),
                                        onTap: ()=> Navigator.pop(context),
                                      ),
                                    ],
                                    elevation: 20.0,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                  ));
                                }
                              },
                              onLongPress: (){
                                _cvCode = _cvCode + 'f';
                                print(_cvCode);
                              },
                            )
                          ],
                        ),
                        body: Builder(
                            builder: (BuildContext context) => ListView(
                              scrollDirection: Axis.vertical,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(margin: EdgeInsets.only(top: 20),),
                                    Text('Something went wrong\nPlease try again later', style: ErrorText2Big(),textAlign: TextAlign.center,),
                                    if(CVAccess)
                                      InkWell(
                                          child: Container(
                                            margin: EdgeInsets.only(top: 20.0),
                                            width: 200,
                                            height: 70,
                                            decoration: PrimaryRoundBox(),
                                            child: Center(
                                              child: Text("Control\nVault", style: SecondaryText(), textAlign: TextAlign.center,),
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context)=> CVNavigator()));
                                            if(_canCheckBiometric){
                                              _authenticate();
                                            }
                                          }),
                                  ],
                                ),
                              ],
                            )),
                      );
                    }
                  }
                  else{
                    return Scaffold(
                      appBar: AppBar(
                        leading: Container(),
                        title: Text(data.docs[0]['Name'][index], style: PrimaryText(context)),
                        centerTitle: true,
                        backgroundColor: PrimaryColor(),
                        actions: <Widget> [
                          InkWell(
                            child: Container(
                                margin: EdgeInsets.only(right: 30),
                                child: Icon(Icons.phonelink_setup, size: 30,)),
                            onTap: () async {
                              UnsaveDetails();
                              SetSetupDone(false);
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> SetupScreen()));
                            },
                            onDoubleTap: (){
                              _cvCode = _cvCode + 'e';
                              print(_cvCode);
                              if(_cvCode == "acecae" || _cvCode == 'eeeffe'){
                                showDialog(context: context, builder: (context)=> AlertDialog(
                                  title: Text('Control Vault', style: PrimaryText2(), textAlign: TextAlign.start,),
                                  content: Container(
                                    margin: EdgeInsets.only(top: 20.0),
                                    child: TextField(
                                      decoration: PrimaryInputDecor(" Enter PIN to Continue"),
                                      obscureText: true,
                                      keyboardType: TextInputType.number,
                                      style: SecondaryText2(),
                                      onChanged: (String value) => _setvalueUsername(value),
                                    ),
                                  ),
                                  actionsAlignment: MainAxisAlignment.spaceBetween,
                                  actionsPadding: EdgeInsets.only(left: 30, right: 30, bottom: 15),
                                  actions: [
                                    InkWell(
                                      child: Text('OK', style: PrimaryText2(), textAlign: TextAlign.start,),
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    InkWell(
                                      child: Text('Cancel', style: PrimaryText2(), textAlign: TextAlign.start,),
                                      onTap: ()=> Navigator.pop(context),
                                    ),
                                  ],
                                  elevation: 20.0,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                ));
                              }
                            },
                            onLongPress: (){
                              _cvCode = _cvCode + 'f';
                              print(_cvCode);
                            },
                          )
                        ],
                      ),
                      body: Builder(
                          builder: (BuildContext context) => ListView(
                            scrollDirection: Axis.vertical,
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(child: Center(child: MainScreenSearchinLottie(context))),
                                    if(CVAccess)
                                      InkWell(
                                          child: Container(
                                            margin: EdgeInsets.only(top: 20.0),
                                            width: 200,
                                            height: 70,
                                            decoration: PrimaryRoundBox(),
                                            child: Center(
                                              child: Text("Control\nVault", style: SecondaryText(), textAlign: TextAlign.center,),
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context)=> CVNavigator()));
                                            if(_canCheckBiometric){
                                              _authenticate();
                                            }
                                          }),
                                  ],
                                ),
                              ),
                            ],
                          )),
                    );
                  }
                });
          }
          else{
            return Scaffold(
              appBar: AppBar(
                leading: Container(),
                title: Text('Sorry', style: PrimaryText(context)),
                centerTitle: true,
                backgroundColor: PrimaryColor(),
                actions: <Widget> [
                  InkWell(
                    child: Container(
                        margin: EdgeInsets.only(right: 30),
                        child: Icon(Icons.phonelink_setup, size: 30,)),
                    onTap: () async {
                      UnsaveDetails();
                      SetSetupDone(false);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> SetupScreen()));
                    },
                    onDoubleTap: (){
                      _cvCode = _cvCode + 'e';
                      print(_cvCode);
                      if(_cvCode == "acecae" || _cvCode == 'eeeffe'){
                        showDialog(context: context, builder: (context)=> AlertDialog(
                          title: Text('Control Vault', style: PrimaryText2(), textAlign: TextAlign.start,),
                          content: Container(
                            margin: EdgeInsets.only(top: 20.0),
                            child: TextField(
                              decoration: PrimaryInputDecor(" Enter PIN to Continue"),
                              obscureText: true,
                              keyboardType: TextInputType.number,
                              style: SecondaryText2(),
                              onChanged: (String value) => _setvalueUsername(value),
                            ),
                          ),
                          actionsAlignment: MainAxisAlignment.spaceBetween,
                          actionsPadding: EdgeInsets.only(left: 30, right: 30, bottom: 15),
                          actions: [
                            InkWell(
                              child: Text('OK', style: PrimaryText2(), textAlign: TextAlign.start,),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                            InkWell(
                              child: Text('Cancel', style: PrimaryText2(), textAlign: TextAlign.start,),
                              onTap: ()=> Navigator.pop(context),
                            ),
                          ],
                          elevation: 20.0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                        ));
                      }
                    },
                    onLongPress: (){
                      _cvCode = _cvCode + 'f';
                      print(_cvCode);
                    },
                  )
                ],
              ),
              body: Builder(
                  builder: (BuildContext context) => ListView(
                    scrollDirection: Axis.vertical,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(margin: EdgeInsets.only(top: 20),),
                          Text('Something went wrong\nPlease try again later', style: ErrorText2Big(),textAlign: TextAlign.center,),
                          Container(margin: EdgeInsets.only(top: 20),),
                          if(CVAccess)
                            InkWell(
                                child: Container(
                                  margin: EdgeInsets.only(top: 20.0),
                                  width: 200,
                                  height: 70,
                                  decoration: PrimaryRoundBox(),
                                  child: Center(
                                    child: Text("Control\nVault", style: SecondaryText(), textAlign: TextAlign.center,),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> CVNavigator()));
                                  if(_canCheckBiometric){
                                    _authenticate();
                                  }
                                }),
                        ],
                      ),
                    ],
                  )),
            );
          }
      },
    );
  }

  _setvalueUsername(String value) {
    return setState(() {
      try {
        userName = value;
        if(userName == '9976'){
          CVAccess = true;
          Navigator.pop(context);
        }
        if(userName.length >4){
          Navigator.pop(context);
          _cvCode = '';
        }
      }
      catch(exception){
        userName = "";
      }
    });
  }

  college () async{
    final prefs = await SharedPreferences.getInstance();
    index = prefs.getInt('college') ?? 0;
    name = prefs.getString('name') ?? '';
    savePass = prefs.getBool('savePass') ?? false;
    ID = prefs.getString('ID') ?? '';
    Code = prefs.getString('Code') ?? '';
    StaffsavePass = prefs.getBool('StaffsavePass') ?? false;
    StaffID = prefs.getString('StaffID') ?? '';
    StaffCode = prefs.getString('StaffCode') ?? '';
    useStudentBiometric = prefs.getBool('useStudentBiometric') ?? false;
    useStaffBiometric = prefs.getBool('useStaffBiometric') ?? false;
  }

  UnsaveDetails() async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('savePass', false);
    prefs.setBool('StaffsavePass', false);
    prefs.setBool('useStudentBiometric', false);
    prefs.setBool('useStaffBiometric', false);
    SetSavePass(false);
    SetStaffsavePass(false);
    SetuseStudentBiometric(false);
    SetuseStaffBiometric(false);
  }
}

class StudentLoginMain extends StatefulWidget {
  const StudentLoginMain({Key? key}) : super(key: key);

  @override
  _StudentLoginMainState createState() => _StudentLoginMainState();

}

class _StudentLoginMainState extends State<StudentLoginMain> {
  String userName = "";
  String password = "";
  bool save = true;
  checkInternet()async{
    result = await Connectivity().checkConnectivity();
    if(result != ConnectivityResult.none){
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
    startStreaming();
  }
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Student Login", style: PrimaryText(context)),
          centerTitle: true,
          backgroundColor: PrimaryColor(),
        ),
        body: Builder(
            builder: (BuildContext context) => Padding(
              padding: const EdgeInsets.only(left: 25.0,right: 25.0),
              child: ListView(
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      WelcomeImage(context),
                      Container(
                        margin: EdgeInsets.only(top: 20.0),
                        child: TextField(
                          decoration: UserInputDecor(" User ID"),
                          style: SecondaryText2(),
                          onChanged: (String value) => _setvalueUsername(value),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20.0),
                        child: TextField(
                          obscureText: true,
                          decoration: PassWordInputDecor(" Password"),
                          style: SecondaryText2(),
                          onChanged: (String value) => _setvaluePassword(value),
                        ),
                      ),
                      Container(margin: EdgeInsets.only(top: 25),),
                      InkWell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget> [
                            Text('Save Password', style: PrimaryText2(),),
                            Toggle(save),
                          ],
                        ),
                        onTap: (){
                          save = !save;
                          setState(() {
                          });
                        },
                      ),
                      Container(margin: EdgeInsets.only(top: 15),),
                      InkWell(
                          child: StudentLoginButton(context),
                          onTap: () {
                            if(save == true){
                              SavePassword();
                            }
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => StudentHomePage(username: userName, password: password)));
                          }
                      ),
                    ],
                  )
                ],
              ),
            )),
      );
  }


  _setvalueUsername(String value) {
      return setState(() {
        try {
          userName = value;
        }
        catch(exception){
          userName = "";
        }
      });
  }

  _setvaluePassword(String value) {
    return setState(() {
      try {
        password = value;
      }
      catch(exception){
        password = "";
      }
    });
  }

  Widget Toggle(bool Savetext){
    if(Savetext == true){
      return Icon(Icons.toggle_on, color: Colors.green, size: 45,);
    }
    else{
      return Icon(Icons.toggle_off, color: ErrorColor(), size: 45,);
    }
  }

  void SavePassword() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('savePass', true);
    prefs.setString('ID', userName);
    prefs.setString('Code', password);
    SetID(userName);
    SetCode(password);
    SetSavePass(true);
  }
}

class StaffLoginMain extends StatefulWidget {
  const StaffLoginMain({Key? key}) : super(key: key);

  @override
  _StaffLoginMainState createState() => _StaffLoginMainState();
}

class _StaffLoginMainState extends State<StaffLoginMain> {
  String userName = "";
  String password = "";
  bool save = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Staff Login", style: PrimaryText(context)),
        centerTitle: true,
        backgroundColor: PrimaryColor(),
      ),
      body: Builder(
          builder: (BuildContext context) => Padding(
            padding: const EdgeInsets.only(left: 25.0,right: 25.0),
            child: ListView(
              scrollDirection: Axis.vertical,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    WelcomeImage(context),
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        decoration: UserInputDecor(" User ID"),
                        style: SecondaryText2(),
                        onChanged: (String value) => _setvalueUsername(value),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        obscureText: true,
                        decoration: PassWordInputDecor(" Password"),
                        style: SecondaryText2(),
                        onChanged: (String value) => _setvaluePassword(value),
                      ),
                    ),
                    Container(margin: EdgeInsets.only(top: 25),),
                    InkWell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget> [
                          Text('Save Password', style: PrimaryText2(),),
                          Toggle(save),
                        ],
                      ),
                      onTap: (){
                        save = !save;
                        setState(() {

                        });
                      },
                    ),
                    InkWell(
                        child: StudentLoginButton(context),
                        onTap: () {
                          if(save == true){
                            SavePassword();
                          }
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> StaffHomePage(username: userName, password: password)));
                        }
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }
  _setvalueUsername(String value) {
    return setState(() {
      try {
        userName = value;
      }
      catch(exception){
        userName = "";
      }
    });
  }

  _setvaluePassword(String value) {
    return setState(() {
      try {
        password = value;
      }
      catch(exception){
        password = "";
      }
    });
  }

  Widget Toggle(bool Savetext){
    if(Savetext == true){
      return Icon(Icons.toggle_on, color: Colors.green, size: 45,);
    }
    else{
      return Icon(Icons.toggle_off, color: ErrorColor(), size: 45,);
    }
  }

  void SavePassword() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('StaffsavePass', true);
    prefs.setString('StaffID', userName);
    prefs.setString('StaffCode', password);
    SetStaffID(userName);
    SetStaffCode(password);
    SetStaffsavePass(true);
  }
}

class CVNavigator extends StatefulWidget {
  const CVNavigator({Key? key}) : super(key: key);

  @override
  _CVNavigatorState createState() => _CVNavigatorState();
}

class _CVNavigatorState extends State<CVNavigator> {
  String userName = "";
  String password = "";

  @override
  Widget build(
      BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Control Vault Login", style: PrimaryText(context)),
        centerTitle: true,
        backgroundColor: PrimaryColor(),
      ),
      body: Builder(
          builder: (BuildContext context) => Padding(
            padding: const EdgeInsets.only(left: 25.0,right: 25.0),
            child: ListView(
              scrollDirection: Axis.vertical,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.1,
                          left: MediaQuery.of(context).size.width * 0.05,
                          right: MediaQuery.of(context).size.width * 0.05),
                      child: ShortImagedisplay('https://dhaanish.co.in/Inst/FSI/impres_erp_logo.jpg', MediaQuery.of(context).size.height /1.1, 200),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        decoration: PrimaryInputDecor(" User ID"),
                        style: SecondaryText2(),
                        onChanged: (String value) => _setvalueUsername(value),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        obscureText: true,
                        decoration: PrimaryInputDecor(" Password"),
                        style: SecondaryText2(),
                        onChanged: (String value) => _setvaluePassword(value),
                      ),
                    ),
                    InkWell(
                        child: StudentLoginButton(context),
                        onTap: () => Navigator.push(context, MaterialPageRoute(
                            builder: (context) => ControlVault(username: userName, password: password)))

                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }


  _setvalueUsername(String value) {
    return setState(() {
      try {
        userName = value;
      }
      catch(exception){
        userName = "";
      }
    });
  }

  _setvaluePassword(String value) {
    return setState(() {
      try {
        password = value;
      }
      catch(exception){
        password = "";
      }
    });
  }
}

class ControlVault extends StatefulWidget {
  const ControlVault({Key? key, required this.username, required this.password}) : super(key: key);
  final String username;
  final String password;

  @override
  _ControlVaultState createState() => _ControlVaultState();
}

class _ControlVaultState extends State<ControlVault> {
  late Stream<QuerySnapshot> users = FirebaseFirestore.instance.collection('User').snapshots();
  @override
  Widget build(BuildContext context) {
    if(widget.username == 'impres' && widget.password == 'dolphin')
      {
        return StreamBuilder<QuerySnapshot>(
          stream: users,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(snapshot.hasError) return Text('Something went wrong!!!');
            if(snapshot.connectionState == ConnectionState.waiting) return CircularProgressIndicator();
            final data = snapshot.requireData;
            return Scaffold(
              appBar: AppBar(
                title: Text('Impres Control Vault', style: PrimaryText(context)),
                centerTitle: true,
                backgroundColor: PrimaryColor(),
                actions: <Widget>[
                  InkWell(
                    child: Container(
                      margin: EdgeInsets.only(right: 20.0),
                      child: Icon(Icons.settings_power),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
              body: Builder(
                  builder: (BuildContext context) => ListView(
                    scrollDirection: Axis.vertical,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.1,
                                left: MediaQuery.of(context).size.width * 0.05,
                                right: MediaQuery.of(context).size.width * 0.05),
                            child: ShortImagedisplay('https://dhaanish.co.in/Inst/FSI/impres_erp_logo.jpg', MediaQuery.of(context).size.height /1.1, 200),
                          ),
                          InkWell(
                              child: Container(
                                margin: EdgeInsets.only(top: 20.0),
                                width: 200,
                                height: 70,
                                decoration: PrimaryRoundBox(),
                                child: Center(
                                  child: Text("Create", style: SecondaryText()),
                                ),
                              ),
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CVCreate(username: widget.username, password: widget.password,)))
                          ),
                          InkWell(
                            child: Container(
                              margin: EdgeInsets.only(top: 20.0),
                              width: 200,
                              height: 70,
                              decoration: PrimaryRoundBox(),
                              child: Center(
                                child: Text("Update", style: SecondaryText()),
                              ),
                            ),
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CVUpdate(username: widget.username, password: widget.password,)))
                          ),
                          InkWell(
                            child: Container(
                              margin: EdgeInsets.only(top: 20.0),
                              width: 200,
                              height: 70,
                              decoration: PrimaryRoundBox(),
                              child: Center(
                                child: Text("Delete", style: SecondaryText()),
                              ),
                            ),
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CVDelete(username: widget.username, password: widget.password,)))
                          ),
                        ],
                      ),
                    ],
                  )),
              bottomSheet: Credits(context),
            );
          },
        );
      }
    else
    {
      return Scaffold(
        appBar: AppBar(
          title: Text("Impres Control Vault", style: PrimaryText(context)),
          centerTitle: true,
          backgroundColor: PrimaryColor(),
        ),
        body: Center(child: Text("Please check your Details", style: ErrorText2Big(),textAlign: TextAlign.center,)),
      );
    }
  }
}

class CVCreate extends StatefulWidget {
  const CVCreate({Key? key, required this.username, required this.password}) : super(key: key);
  final String username;
  final String password;
  @override
  _CVCreateState createState() => _CVCreateState();
}

class _CVCreateState extends State<CVCreate> {
  late Stream<QuerySnapshot> users = FirebaseFirestore.instance.collection('User').snapshots();
  String CollegeName = "";
  String IPAddress = "";
  String Image = "";
  List <dynamic> CollegeNameList = [];
  List <dynamic> IPAddressList = [];
  List <dynamic> ImageList = [];
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: users,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(snapshot.hasError) return Text('Something went wrong!!!');
        if(snapshot.connectionState == ConnectionState.waiting) return CircularProgressIndicator();
        final data = snapshot.requireData;
        CollegeNameList = data.docs[0]['Name'];
        IPAddressList = data.docs[0]['IPAddress'];
        ImageList = data.docs[0]['Images'];
        return Scaffold(
          appBar: AppBar(
            title: Text("Create", style: PrimaryText(context)),
            centerTitle: true,
            backgroundColor: PrimaryColor(),
          ),
          body: Builder(
              builder: (BuildContext context) => Padding(
                padding: const EdgeInsets.only(left: 25.0,right: 25.0),
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 20.0),
                          child: TextField(
                            decoration: PrimaryInputDecor("College Name"),
                            style: SecondaryText2(),
                            onChanged: (String value) => _setvalueCollegeName(value),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20.0),
                          child: TextField(
                            decoration: PrimaryInputDecor("IP Address"),
                            style: SecondaryText2(),
                            onChanged: (String value) => _setvalueIPAddress(value),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20.0),
                          child: TextField(
                            decoration: PrimaryInputDecor("Image"),
                            style: SecondaryText2(),
                            onChanged: (String value) => _setvalueImage(value),
                          ),
                        ),
                        if(Image != '')
                        Container(
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.1,
                              left: MediaQuery.of(context).size.width * 0.05,
                              right: MediaQuery.of(context).size.width * 0.05),
                          child: ShortImagedisplay(Image, MediaQuery.of(context).size.height /1.1, 200),
                        ),
                        InkWell(
                            child: Container(
                              margin: EdgeInsets.only(top: 20.0),
                              width: 200,
                              height: 70,
                              decoration: PrimaryRoundBox(),
                              child: Center(
                                child: Text("Save", style: SecondaryText()),
                              ),
                            ),
                          onTap: () {
                              if(CollegeName == '' || IPAddress == '' || Image == '')
                                {
                                  SnackBar snackbar =  SnackBar(content: Text('Please fill all details', style: SecondaryText(),), backgroundColor: ErrorColor(), duration: Duration(seconds: 2),);
                                  // Scaffold.of(context).hideCurrentSnackBar();
                                  // Scaffold .of(context).showSnackBar(snackbar);
                                }
                              else{
                                if(CollegeNameList.contains(CollegeName))
                                {
                                  SnackBar snackbar =  SnackBar(content: Text('College already entered', style: SecondaryText(),), backgroundColor: ErrorColor(), duration: Duration(seconds: 2),);
                                  // Scaffold.of(context).hideCurrentSnackBar();
                                  // Scaffold .of(context).showSnackBar(snackbar);
                                }
                                else
                                {
                                  CollegeNameList.add(CollegeName);
                                  IPAddressList.add(IPAddress);
                                  ImageList.add(Image);
                                  final UpdateUser = FirebaseFirestore.instance.collection('User').doc('CollegeList');
                                  UpdateUser.update({'Name' : CollegeNameList, 'IPAddress' : IPAddressList, 'Images' : ImageList
                                  }).then((value) => print('Value Changed Successfully')).onError((error, stackTrace) =>
                                      print('Something went wrong'));
                                  SnackBar snackbar =  SnackBar(content: Text('Details of $CollegeName is added', style: SecondaryText(),), backgroundColor: SecondaryColor(), duration: Duration(seconds: 2),);
                                  // Scaffold.of(context).hideCurrentSnackBar();
                                  // Scaffold .of(context).showSnackBar(snackbar);
                                }
                              }
                          },
                        ),
                        Container(margin: EdgeInsets.only(top: 20),)
                      ],
                    )
                  ],
                ),
              )),
          bottomSheet: Credits(context),
        );
      },
    );
  }
  _setvalueCollegeName(String value) {
    return setState(() {
      try {
        CollegeName = value;
      }
      catch(exception){
        CollegeName = "";
      }
    });
  }

  _setvalueIPAddress(String value) {
    return setState(() {
      try {
        IPAddress = value;
      }
      catch(exception){
        IPAddress = "";
      }
    });
  }

  _setvalueImage(String value) {
    return setState(() {
      try {
        Image = value;
      }
      catch(exception){
        Image = "";
      }
    });
  }
}

class CVUpdate extends StatefulWidget {
  const CVUpdate({Key? key, required this.username, required this.password}) : super(key: key);
  final String username;
  final String password;
  @override
  _CVUpdateState createState() => _CVUpdateState();
}

class _CVUpdateState extends State<CVUpdate> {
  late Stream<QuerySnapshot> users = FirebaseFirestore.instance.collection('User').snapshots();
  int Selection = 0;
  String CollegeName = "";
  String IPAddress = "";
  String Image = "";
  List <dynamic> CollegeNameList = [];
  List <dynamic> IPAddressList = [];
  List <dynamic> ImageList = [];
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: users,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(snapshot.hasError) return Text('Something went wrong!!!');
        if(snapshot.connectionState == ConnectionState.waiting) return CircularProgressIndicator();
        final data = snapshot.requireData;
        CollegeNameList = data.docs[0]['Name'];
        IPAddressList = data.docs[0]['IPAddress'];
        ImageList = data.docs[0]['Images'];
        return Scaffold(
          appBar: AppBar(
            title: Text("Update", style: PrimaryText(context)),
            centerTitle: true,
            backgroundColor: PrimaryColor(),
          ),
          body: Builder(
              builder: (BuildContext context) => Padding(
                padding: const EdgeInsets.only(left: 25.0,right: 25.0),
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                          child: DropdownSearch<dynamic>(
                            popupProps: PopupProps.menu(),
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: PrimaryInputDecor('College'),
                            ),
                            dropdownButtonProps: DropdownButtonProps(
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                icon: Icon(Icons.arrow_drop_down_sharp),
                                color: Colors.black
                            ),
                            items: CollegeNameList,
                            selectedItem: 'Select College',
                            onChanged: (value) {
                              CollegeName = value.toString();
                              Selection = CollegeNameList.indexOf(CollegeName);
                              IPAddress = IPAddressList[Selection];
                              Image = ImageList[Selection];
                              _setvalueCollegeName(CollegeName);
                              _setvalueIPAddress(IPAddress);
                              _setvalueImage(Image);
                              print(CollegeName);
                              print(IPAddress);
                              print(Image);
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20.0),
                          child: TextField(
                            decoration: PrimaryInputDecor(data.docs[0]['Name'][Selection]),
                            style: SecondaryText2(),
                            onChanged: (String value) => _setvalueCollegeName(value),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20.0),
                          child: TextField(
                            decoration: PrimaryInputDecor(data.docs[0]['IPAddress'][Selection]),
                            style: SecondaryText2(),
                            onChanged: (String value) => _setvalueIPAddress(value),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20.0),
                          child: TextField(
                            decoration: PrimaryInputDecor("Image"),
                            style: SecondaryText2(),
                            onChanged: (String value) => _setvalueImage(value),
                          ),
                        ),
                        if(Image != '')
                          Container(
                            margin: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.1,
                                left: MediaQuery.of(context).size.width * 0.05,
                                right: MediaQuery.of(context).size.width * 0.05),
                            child: ShortImagedisplay(Image, MediaQuery.of(context).size.height /1.1, 200),
                          ),
                        InkWell(
                          child: Container(
                            margin: EdgeInsets.only(top: 20.0),
                            width: 200,
                            height: 70,
                            decoration: PrimaryRoundBox(),
                            child: Center(
                              child: Text("Save", style: SecondaryText()),
                            ),
                          ),
                          onTap: () {
                            if(CollegeName == data.docs[0]['Name'][Selection] && IPAddress == data.docs[0]['IPAddress'][Selection] && Image == data.docs[0]['Images'][Selection])
                            {
                              SnackBar snackbar =  SnackBar(content: Text('No details changed', style: SecondaryText(),), backgroundColor: ErrorColor(), duration: Duration(seconds: 2),);
                              // Scaffold.of(context).hideCurrentSnackBar();
                              // Scaffold .of(context).showSnackBar(snackbar);
                            }
                            else{
                                CollegeNameList[Selection] = CollegeName;
                                IPAddressList[Selection] = IPAddress;
                                ImageList[Selection] = Image;
                                final UpdateUser = FirebaseFirestore.instance.collection('User').doc('CollegeList');
                                UpdateUser.update({'Name' : CollegeNameList, 'IPAddress' : IPAddressList, 'Images' : ImageList
                                }).then((value) => print('Value Changed Successfully')).onError((error, stackTrace) =>
                                    print('Something went wrong'));
                                SnackBar snackbar =  SnackBar(content: Text('Details of ${data.docs[0]['Name'][Selection]} is updated', style: SecondaryText(),), backgroundColor: SecondaryColor(), duration: Duration(seconds: 2),);
                                // Scaffold.of(context).hideCurrentSnackBar();
                                // Scaffold .of(context).showSnackBar(snackbar);
                            }
                          },
                        ),
                        Container(margin: EdgeInsets.only(top: 20),)
                      ],
                    )
                  ],
                ),
              )),
          bottomSheet: Credits(context),
        );
      },
    );
  }
  _setvalueCollegeName(String value) {
    return setState(() {
      try {
        CollegeName = value;
      }
      catch(exception){
        CollegeName = "";
      }
    });
  }

  _setvalueIPAddress(String value) {
    return setState(() {
      try {
        IPAddress = value;
      }
      catch(exception){
        IPAddress = "";
      }
    });
  }

  _setvalueImage(String value) {
    return setState(() {
      try {
        Image = value;
      }
      catch(exception){
        Image = "";
      }
    });
  }
}

class CVDelete extends StatefulWidget {
  const CVDelete({Key? key, required this.username, required this.password}) : super(key: key);
  final String username;
  final String password;

  @override
  _CVDeleteState createState() => _CVDeleteState();
}

class _CVDeleteState extends State<CVDelete> {
  late Stream<QuerySnapshot> users = FirebaseFirestore.instance.collection('User').snapshots();
  int Selection = 0;
  String CollegeName = "";
  String IPAddress = "";
  String Image = "";
  List <dynamic> CollegeNameList = [];
  List <dynamic> IPAddressList = [];
  List <dynamic> ImageList = [];
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: users,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(snapshot.hasError) return Text('Something went wrong!!!');
        if(snapshot.connectionState == ConnectionState.waiting) return CircularProgressIndicator();
        final data = snapshot.requireData;
        CollegeNameList = data.docs[0]['Name'];
        IPAddressList = data.docs[0]['IPAddress'];
        ImageList = data.docs[0]['Images'];
        return Scaffold(
          appBar: AppBar(
            title: Text("Delete", style: PrimaryText(context)),
            centerTitle: true,
            backgroundColor: PrimaryColor(),
          ),
          body: Builder(
              builder: (BuildContext context) => Padding(
                padding: const EdgeInsets.only(left: 25.0,right: 25.0),
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                          child: DropdownSearch<dynamic>(
                            popupProps: PopupProps.menu(),
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: PrimaryInputDecor('College'),
                            ),
                            dropdownButtonProps: DropdownButtonProps(
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                icon: Icon(Icons.arrow_drop_down_sharp),
                                color: Colors.black
                            ),
                            items: CollegeNameList,
                            selectedItem: 'Select College',
                            onChanged: (value) {
                              CollegeName = value.toString();
                              Selection = CollegeNameList.indexOf(CollegeName);
                              IPAddress = IPAddressList[Selection];
                              Image = ImageList[Selection];
                              _setvalueCollegeName(CollegeName);
                              _setvalueIPAddress(IPAddress);
                              _setvalueImage(Image);
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20.0),
                          child: TextField(
                            enabled: false,
                            decoration: PrimaryInputDecorCV(data.docs[0]['Name'][Selection]),
                            style: SecondaryText2(),
                            onChanged: (String value) => _setvalueCollegeName(value),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20.0),
                          child: TextField(
                            enabled: false,
                            decoration: PrimaryInputDecor(data.docs[0]['IPAddress'][Selection]),
                            style: SecondaryText2(),
                            onChanged: (String value) => _setvalueIPAddress(value),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20.0),
                          child: TextField(
                            enabled: false,
                            decoration: PrimaryInputDecor("Image"),
                            style: SecondaryText2(),
                            onChanged: (String value) => _setvalueImage(value),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.1,
                              left: MediaQuery.of(context).size.width * 0.05,
                              right: MediaQuery.of(context).size.width * 0.05),
                          child: ShortImagedisplay(data.docs[0]['Images'][Selection], MediaQuery.of(context).size.height /1.1, 200),
                        ),
                        Container(margin: EdgeInsets.only(top: 20),),
                        InkWell(
                          child: Container(
                            margin: EdgeInsets.only(top: 20.0),
                            width: 200,
                            height: 70,
                            decoration: PrimaryRoundBox(),
                            child: Center(
                              child: Text("Delete", style: SecondaryText()),
                            ),
                          ),
                          onTap: () {
                            showDialog(context: context, builder: (context)=> AlertDialog(
                              title: Text('Are you sure?', style: PrimaryText2(), textAlign: TextAlign.start,),
                              content: Text('Do you want to delete the details of ${data.docs[0]['Name'][Selection]}?', style: SecondaryText2(), textAlign: TextAlign.center,),
                              actionsAlignment: MainAxisAlignment.spaceBetween,
                              actionsPadding: EdgeInsets.only(left: 30, right: 30, bottom: 15),
                              actions: [
                                InkWell(
                                    child: Text('Yes', style: PrimaryText2(), textAlign: TextAlign.start,),
                                  onTap: () {
                                    CollegeNameList.removeAt(Selection);
                                    IPAddressList.removeAt(Selection);
                                    ImageList.removeAt(Selection);
                                    final UpdateUser = FirebaseFirestore.instance.collection('User').doc('CollegeList');
                                    UpdateUser.update({'Name' : CollegeNameList, 'IPAddress' : IPAddressList, 'Images' : ImageList
                                    }).then((value) => print('Value Changed Successfully')).onError((error, stackTrace) =>
                                        print('Something went wrong'));
                                    Selection = 0;
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                ),
                                InkWell(
                                    child: Text('No', style: PrimaryText2(), textAlign: TextAlign.start,),
                                  onTap: ()=> Navigator.pop(context),
                                ),
                              ],
                              elevation: 20.0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                            ));
                          },
                        ),
                        Container(margin: EdgeInsets.only(top: 20),)
                      ],
                    )
                  ],
                ),
              )),
          bottomSheet: Credits(context),
        );
      },
    );
  }
  _setvalueCollegeName(String value) {
    return setState(() {
      try {
        CollegeName = value;
      }
      catch(exception){
        CollegeName = "";
      }
    });
  }

  _setvalueIPAddress(String value) {
    return setState(() {
      try {
        IPAddress = value;
      }
      catch(exception){
        IPAddress = "";
      }
    });
  }

  _setvalueImage(String value) {
    return setState(() {
      try {
        Image = value;
      }
      catch(exception){
        Image = "";
      }
    });
  }
}

// int template = 5;
// class Template extends StatefulWidget {
//   const Template({Key? key,required this.username, required this.password, required this.student}) : super(key: key);
//   final String username;
//   final String password;
//   final String student;
//
//   @override
//   State<Template> createState() => _TemplateState();
// }



// class _TemplateState extends State<Template> {
//   @override
//   Widget build(BuildContext context) {
//     switch(template){
//       case 1: return Scaffold(
//         appBar: AppBar(title: Text(widget.student),),
//         body: Column(
//           children: <Widget> [
//             InkWell(child: Icon(Icons.search),
//               onTap: (){
//               Navigator.push(context, MaterialPageRoute(builder: (context)=>My_Template1(
//
//               )));
//               template = 1;
//               setState(() {});
//               },
//             ),
//             InkWell(child: Icon(Icons.place),
//               onTap: (){
//                 template = 2;
//                 setState(() {});
//               },
//             ),
//             InkWell(child: Icon(Icons.soap),
//               onTap: (){
//                 template = 3;
//                 setState(() {});
//               },
//             ),
//           ],
//         ),
//       );
//       break;
//       case 2: return Scaffold(
//         appBar: AppBar(title: Text('theme 2'),),
//         body: Column(
//           children: <Widget> [
//             InkWell(child: Icon(Icons.search),
//               onTap: (){
//                 template = 1;
//                 setState(() {});
//               },
//             ),
//             InkWell(child: Icon(Icons.place),
//               onTap: (){
//                 template = 2;
//                 setState(() {});
//               },
//             ),
//             InkWell(child: Icon(Icons.soap),
//               onTap: (){
//                 template = 3;
//                 setState(() {});
//               },
//             ),
//           ],
//         ),
//       );
//       break;
//       default : return Scaffold(
//         appBar: AppBar(title: Text('theme 3'),),
//         body: Column(
//           children: <Widget> [
//             InkWell(child: Icon(Icons.search),
//               onTap: (){
//                 template = 1;
//                 setState(() {});
//               },
//             ),
//             InkWell(child: Icon(Icons.place),
//               onTap: (){
//                 template = 2;
//                 setState(() {});
//               },
//             ),
//             InkWell(child: Icon(Icons.soap),
//               onTap: (){
//                 template = 3;
//                 setState(() {});
//               },
//             ),
//           ],
//         ),
//       );
//       break;
//     }
//   }
// }

