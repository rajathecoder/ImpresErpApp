import 'dart:async';
import 'dart:convert';

import 'package:add_dev_dolphin/Data/Staff_Data.dart';
import 'package:add_dev_dolphin/Data/Student_Data.dart';
import 'package:add_dev_dolphin/Model/Login_Screen/login_body.dart';
import 'package:add_dev_dolphin/Style_font/designs.dart';
import 'package:add_dev_dolphin/UI/main_ui.dart';
import 'package:add_dev_dolphin/intro_screen/login_student.dart';
import 'package:add_dev_dolphin/intro_screen/logoscreen.dart';
import 'package:add_dev_dolphin/main.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class code_screen extends StatefulWidget {
  const code_screen({Key? key}) : super(key: key);

  @override
  State<code_screen> createState() => _code_screenState();
}

class _code_screenState extends State<code_screen> {
  String? C_code,i,img,StuImaIp,StaImaIP,ManaImaIP;
  final _keyCode = GlobalKey<FormState>();
  late List College_Details=[];
  bool result = false;
  String user = '';
  String pass = '';
  Check_Code()async{
    final form =_keyCode.currentState;
    if (MLogCode() != 'No Code')
    {
      C_code = MLogCode();
       await Search_College();
      var sharedpref = await SharedPreferences.getInstance();
      sharedpref.setString(logo_screenState.CollCode, C_code!);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login_Screen_Student()));
    }
    else
    {
      if(form!.validate()){
        form.save();
        print('----Code = $C_code');
        await Search_College();
        var sharedpref = await SharedPreferences.getInstance();
        sharedpref.setString(logo_screenState.CollCode, C_code!);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login_Screen_Student()));
      }
    }
  }
  Search_College()async{
    print('Verification Started. Code = $C_code');
    final resp = await http.get(
      Uri.parse("http://52.66.132.36/college/api/college?collegeCode=${C_code}"), // server login url
    );
    if (resp.statusCode == 200){
      College_Details = json.decode(resp.body);
      Wr_Code();
      print('Verification Completed');
       // print(College_Details);
      i =(College_Details[0]['Response'][0]['list'][0]['redirectIp'].toString());
      img =(College_Details[0]['Response'][0]['list'][0]['collegeLogo'].toString());
      log_type =(College_Details[0]['Response'][0]['list'][0]['loginVia'].toString());
      StuImaIp = (College_Details[0]['Response'][0]['list'][0]['studentImage'].toString());
      StaImaIP = College_Details[0]['Response'][0]['list'][0]['staffImage'].toString();
      ManaImaIP = College_Details[0]['Response'][0]['list'][0]['managementImage'].toString();
      ip = i!;
      StudentImageIP = StuImaIp!;
      StaffImageIP = StaImaIP!;
      ManagementImageIP = ManaImaIP!;
      SetStudentIP(i!);
      SetStaffIP(i!);
      SetImage(img!);
    }
    else{
    }
  }
  Wr_Code()async{
    if(College_Details[0]['Response'][0]['status'].toString() == 'true'){
      // await Fluttertoast.showToast(
      //     backgroundColor: Colors.green,
      //     msg: "Welcome",
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.SNACKBAR,
      //     textColor: Colors.white,
      //     fontSize: 16.0
      // );
    }
    else{
      await Fluttertoast.showToast(
          backgroundColor: Colors.red,
          msg: "Entered College Code is Wrong! Please Contact Your ERP Admin",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }
  void SavePassword() async {
    final sharedpref = await SharedPreferences.getInstance();
    result = sharedpref.getBool(logo_screenState.KEYLOGIN) ?? false;
    user = sharedpref.getString(logo_screenState.USERKEY) ?? 'No User';
    pass = sharedpref.getString(logo_screenState.PASSKEY) ?? 'No Pass';
    String colcode = MLogCode();
    print(MCode);
    // print("The result is : $result\nUser Name : $user \t Passowrd : $pass\n College Code : $colcode");
  }
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
    if(mounted) return;
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
    // SavePassword();
    if(MLogin() == true){
      Check_Code();
      return Scaffold(
        body: Center(
          child: SearchingDataLottie(context),
        ),
      );
    }
    else{
      return SafeArea(
        child: Scaffold(
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(top: 30),
                child: Column(
                  children: [
                    Text(
                      'Welcome',
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Image.asset(
                      'images/introscreen/college_code.png',
                      height: 300,
                      width: 300,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    MCode == 'No Code'? Column(
                      children: [
                        Row(
                          children: [
                            Padding(padding: EdgeInsets.only(left: 40)),
                            Text(
                              'College Code',
                              style:
                              TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 40, right: 40),
                          child:
                          Form(
                            key: _keyCode,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 70,
                              child: TextFormField(
                                maxLength: 6,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                  counter: Offstage(),
                                  hintStyle: TextStyle(color: Colors.grey),
                                  labelText: "Enter Your College Code",
                                  labelStyle: TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(),
                                  hintText: "College Code",
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                validator: (e){
                                  if(e!.isEmpty){
                                    return "Please Enter Your College Code";
                                  }
                                },
                                style:  TextStyle(color: Colors.black),
                                onSaved: (e)=>  C_code =  e,

                              ),
                            ),
                          ),),
                        SizedBox(
                          height: 19,
                        ),
                      ],
                    ):new Container(),

                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      margin: const EdgeInsets.fromLTRB(40, 10, 40, 20),
                      decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(30)),
                      child: ElevatedButton(
                        onPressed: ()async{
                          checkInternet();
                          Check_Code();
                        },
                        style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.resolveWith((states) {
                              if (states.contains(MaterialState.pressed)) {
                                return Color.fromRGBO(255, 52, 62, 1);
                              }
                              return Color.fromRGBO(255, 52, 62, 1);
                            }),
                            shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)))),
                        child: MCode == 'No Code'? Text(
                          'Proceed',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ):new Text(
                          'Click to Sign in',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'By continuing you are agreed to our',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(child: Text(" Privacy Policy",style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800,
                            color: Colors.blue)),onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> PrivacyPolicy()));
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

  }

}


class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  WebViewController controller = WebViewController()
  ..setJavaScriptMode(JavaScriptMode.unrestricted)
  ..setBackgroundColor(const Color(0x00000000))
  ..setNavigationDelegate(
  NavigationDelegate(
  onProgress: (int progress) {
  // Update loading bar.
  },
  onPageStarted: (String url) {},
  onPageFinished: (String url) {},
  onWebResourceError: (WebResourceError error) {},
  onNavigationRequest: (NavigationRequest request) {
  if (request.url.startsWith('https://www.impreserp.co.in/wp-content/Privacy_Policy.html')) {
  return NavigationDecision.prevent;
  }
  return NavigationDecision.navigate;
  },
  ),
  )
  ..loadRequest(Uri.parse('https://www.impreserp.co.in/wp-content/Privacy_Policy.html'));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Privacy Policy"),
      ),
      body: InkWell(
       child: WebViewWidget(
            controller: controller,
         ),
         onLongPress: (){},
       ),
    );
  }
}
