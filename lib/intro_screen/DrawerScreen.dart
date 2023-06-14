import 'dart:async';

import 'package:add_dev_dolphin/Data/Staff_Data.dart';
import 'package:add_dev_dolphin/Data/Student_Data.dart';
import 'package:add_dev_dolphin/Model/Student_Screen/student_main.dart';
import 'package:add_dev_dolphin/Model/Student_Screen/student_screen_changes.dart';
import 'package:add_dev_dolphin/Style_font/designs.dart';
import 'package:add_dev_dolphin/UI/main_ui.dart';
import 'package:add_dev_dolphin/intro_screen/code_screen.dart';
import 'package:add_dev_dolphin/intro_screen/login_student.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({Key? key, required this.username, required this.password}) : super(key: key);
  final String username;
  final String password;


  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {

  final zoomDrawerController = ZoomDrawerController();
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
      // barrierDismissible: false,
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
    checkInternet();
  }

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      controller: zoomDrawerController,
      menuScreen: MenuScreen(username: widget.username, password: widget.password,),
      mainScreen: StudentHomePage(username: widget.username, password: widget.password,),
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

class MenuScreen extends StatefulWidget {


  const MenuScreen({Key? key, required this.username, required this.password }) : super(key: key);
  final String username;
  final String password;

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late Future <Data_List> APIData;
  late Future <ModuleData_List> ModuleAPIData;
  late LocalAuthentication auth = LocalAuthentication();
  late bool _canCheckBiometric = false;
  late List<BiometricType> _availableBiometrics = [];
  late String _authorized = "Not Authorized";
  final zoomDrawerController = ZoomDrawerController();
  bool _enableBiometric = false;
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
      // barrierDismissible: false,
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Network network = Network("billing?RollNum=${widget.username}&Password=${widget.password}");
    APIData = network.loadData();
    ModuleNetwork Modulenetwork = ModuleNetwork("menu?instid=1");
    ModuleAPIData = Modulenetwork.ModuleloadData();
    _checkBiometric();
    _getAvailableBiometrics();
    checkInternet();
  }
  @override
  Widget build(BuildContext context) {
    GetBiometric();
    return FutureBuilder(
        future: APIData,
        builder: (context, AsyncSnapshot<Data_List> snapshot){
          if (snapshot.hasError){
            ErrorShowingWidget(context);
          }
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
                        if(Moduledata.length >0){
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
                                          Icon(Icons.person,color: Colors.white,),
                                          Text('  Profile  ',style: TextStyle(fontSize: 16,color: Colors.white),)
                                        ],
                                      ),
                                    ),
                                      onTap: (){
                                        checkInternet();
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=> StudentProfile(username: data[0].RollNum.toLowerCase(),password: widget.password,)));
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
                                            Icon(Icons.settings_suggest_outlined,color: Colors.white,),
                                            Text('  Privacy Policy',style: TextStyle(fontSize: 15,color: Colors.white),)
                                          ],
                                        ),
                                      ),
                                      onTap: (){
                                        checkInternet();
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

                                  //logout button
                                  // InkWell(
                                  //   child: Container(
                                  //     child: Row(
                                  //       children: [
                                  //         Icon(Icons.logout,color: Colors.white,),
                                  //         Text('Logout',style: GoogleFonts.abel(fontSize: 20,color: Colors.white),)
                                  //       ],
                                  //     ),
                                  //   ),
                                  //   onTap: () => Navigator.pop(context),
                                  // ), ////
                                ],
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
                return  Scaffold();
              }
            }
            else{
              return Scaffold(
                  backgroundColor: Colors.white,
                  body: Container(child: Center(child: EnterScreenLoadLottie(context)), color: Colors.white,));
            }
        }
    );
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
      return Icon(Icons.toggle_on_outlined, color: Colors.green, size: 45,);
    }
    else{
      return Icon(Icons.toggle_off_outlined, color: Colors.red, size: 45,);
    }
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



class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About Us"),
        backgroundColor: PrimaryColor(),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              width: sWidth(90, context),
              margin: EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    child: Image.asset('images/introscreen/front_logo.png'),
                    height: 200,
                    width: 200,
                  ),
                  Container(
                      height: sHeight(58, context),
                      width: sWidth(90, context),
                      child: Column(
                    children: [
                      Text("Impress ERP is a college automation software"
                          "product by Subiksham Software Solutions Private"
                          "Limited, Coimbatore.",style: TextStyle(fontSize: 18,)),

                      SizedBox(
                        height: sHeight(3, context),
                      ),
                      Text("This app is developed in Partnership with Nithra "
                          "Apps India Private Limited,"
                          " India's leading mobile app development company. "
                          "Famously known for its apps like Nithra Calendar,"
                          " Nithra Jobs & Nithra Matrimony used by 1 crore people in five languages viz. "
                          "Tamil, Telugu, Kannada, Malayalam and Hindi",style: TextStyle(fontSize: 18,)),
                      SizedBox(
                        height: sHeight(2, context),
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(child: Image.asset('images/introscreen/ss.png',scale: 15,),

                          ),
                          Container(child: Image.asset('images/introscreen/nithra.png',scale: 3.2,),
                          ),
                        ],
                      )
                    ],
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


