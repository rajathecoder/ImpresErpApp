import 'dart:async';
import 'package:add_dev_dolphin/Data/Staff_Data.dart';
import 'package:add_dev_dolphin/Model/Staff_Screen/staff_main.dart';
import 'package:add_dev_dolphin/Style_font/designs.dart';
import 'package:add_dev_dolphin/UI/main_ui.dart';
import 'package:add_dev_dolphin/intro_screen/DrawerScreen.dart';
import 'package:add_dev_dolphin/intro_screen/code_screen.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StaffDrawerScreen extends StatefulWidget {
  const StaffDrawerScreen({Key? key, required this.username, required this.password}) : super(key: key);
  final String username;
  final String password;


  @override
  State<StaffDrawerScreen> createState() => _StaffDrawerScreenState();
}

class _StaffDrawerScreenState extends State<StaffDrawerScreen> {
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
      menuScreen: StaffMenuScreen(username: widget.username, password: widget.password,),
      mainScreen:  StaffHomePage(username: widget.username, password: widget.password),
      showShadow: false,
      borderRadius: 50,
      slideWidth: 200,
      shadowLayer1Color: Colors.white38,
      shadowLayer2Color: Colors.white60,
      angle: 0.0,
      menuBackgroundColor:  const Color.fromRGBO(255, 98, 118, 1),
    );
  }
}


class StaffMenuScreen extends StatefulWidget {
  const StaffMenuScreen({Key? key, required this.username, required this.password}) : super(key: key);
  final String username;
  final String password;

  @override
  _StaffMenuScreenState createState() => _StaffMenuScreenState();
}

class _StaffMenuScreenState extends State<StaffMenuScreen> {
  late Future <StaffData_List> APIData;
  late Future <ModuleData_List> ModuleAPIData;
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
      content: const Text("Please check your Internet Connection"),
      actions: [
        CupertinoButton.filled(child: const Text("Retry"), onPressed: (){
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

  double sHeight(double per, BuildContext context){
    double h = MediaQuery.of(context).size.height;
    return h * per / 100;
  }

  double sWidth(double per, BuildContext context){
    double w = MediaQuery.of(context).size.width;
    return w * per / 100;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StaffNetwork network = StaffNetwork("StaffInfo?StaffCode=${widget.username.toLowerCase()}&Password=${widget.password}");
    APIData = network.StaffloadData();
    ModuleNetwork Modulenetwork = ModuleNetwork("menu?instid=1");
    ModuleAPIData = Modulenetwork.ModuleloadData();
  }
  @override
  Widget build(BuildContext context){
    return FutureBuilder(
        future: APIData,
        builder: (context, AsyncSnapshot<StaffData_List> snapshot){
          if (snapshot.hasError)
          {
            ErrorShowingWidget(context);
          }

            List <StaffAPI_data> data;
            if(snapshot.hasData){
              data = snapshot.data!.Staffdata_list;
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
                          return
                            Scaffold(
                            backgroundColor:  const Color.fromRGBO(255, 98, 118, 1),
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
                                    height: sHeight(8, context),
                                  ),
                                  InkWell(
                                    onTap: (){
                                      ZoomDrawer.of(context)!.close();
                                    },
                                    child: Container(
                                      height: sHeight(7, context),
                                      width: sWidth(50, context),
                                      decoration: BoxDecoration(
                                          color: const Color.fromRGBO(255, 147, 0,1),
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: sWidth(4, context),
                                          ),
                                          const Icon(Icons.home,color: Colors.white,),
                                          const Text(' Home',style: TextStyle(fontSize: 15,color: Colors.white),)
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: sHeight(2, context),
                                  ),
                                  InkWell(
                                      child: Container(
                                        height: sHeight(7, context),
                                        width: sWidth(50, context),
                                        decoration: BoxDecoration(
                                            color: const Color.fromRGBO(255, 98, 118, 1),
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: sWidth(2, context),
                                            ),
                                            const Icon(Icons.settings_suggest_outlined,color: Colors.white,),
                                            const Text(' Privacy Policy',style: TextStyle(fontSize: 14,color: Colors.white),)
                                          ],
                                        ),
                                      ),
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const PrivacyPolicy()));
                                        ZoomDrawer.of(context)!.close();
                                      }
                                  ),
                                  InkWell(
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 3),
                                      height: sHeight(7, context),
                                      width: sWidth(50, context),
                                      decoration: BoxDecoration(
                                          color: const Color.fromRGBO(255, 98, 118, 1),
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.info,color: Colors.white,),
                                          SizedBox(
                                            width: sWidth(2, context),
                                          ),
                                          const Text('About Us',style: TextStyle(fontSize: 16,color: Colors.white),)
                                        ],
                                      ),
                                    ),
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const AboutUs()));
                                    },
                                  ),

                                  // InkWell(
                                  //   child: Container(
                                  //     child: Row(
                                  //       children: [
                                  //         Icon(Icons.logout,color: Colors.white,),
                                  //         Text('Logout',style: TextStyle(fontSize: 20,color: Colors.white),)
                                  //       ],
                                  //     ),
                                  //   ),
                                  //   onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login_Screen_Student())),
                                  // ),
                                ],
                              ),
                            ),
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
                        return Container(color: Colors.white,child: const Center(child: CircularProgressIndicator()),);
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
              return Container(color: Colors.white,child: Center(child: StaffMainLoading(context)),);

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



  void DisableBiometric()async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('useStaffBiometric', false);
    SetuseStaffBiometric(false);
  }

  Widget Toggle(bool Savetext){
    if(Savetext == true){
      return const Icon(Icons.toggle_on_outlined, color: Colors.white, size: 45,);
    }
    else{
      return const Icon(Icons.toggle_off_outlined, color: Colors.white70, size: 45,);
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


