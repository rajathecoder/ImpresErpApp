import 'dart:async';
import 'dart:convert';
import 'package:add_dev_dolphin/Data/Staff_Data.dart';
import 'package:add_dev_dolphin/Data/Student_Data.dart';
import 'package:add_dev_dolphin/LocalDb/DatabaseHelper.dart';
import 'package:add_dev_dolphin/Model/Login_Screen/login_body.dart';
import 'package:add_dev_dolphin/Style_font/designs.dart';
import 'package:add_dev_dolphin/UI/main_ui.dart';
import 'package:add_dev_dolphin/intro_screen/login_student.dart';
import 'package:add_dev_dolphin/intro_screen/logoscreen.dart';
import 'package:add_dev_dolphin/intro_screen/staffdrawer.dart';
import 'package:add_dev_dolphin/main.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../Admin_Page/admin_drawer.dart';
import 'DrawerScreen.dart';

class code_screen extends StatefulWidget {
  const code_screen({Key? key}) : super(key: key);

  @override
  State<code_screen> createState() => _code_screenState();
}

class _code_screenState extends State<code_screen> {


  String? i,img,StuImaIp,StaImaIP,ManaImaIP;
  TextEditingController collegeCode = TextEditingController();
  final _keyCode = GlobalKey<FormState>();
  late List College_Details=[];
  bool result = false, buttonClick= false , loginKey= false  ;
  String user = '';
  String pass = '';

  Check_Code()async{
    List <Person> data = await DatabaseHelper.instance.getAllDetails();
    if (data[0].collegecode==""||data[0].collegecode == null){
      collegeCode.text=   data[0].collegecode!.toString();
      MCode ="";
    } else if (data[0].collegecode!=""||data[0].username!= ""||data[0].password!=""){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login_Screen_Student(collegeCode.text)));
    } else{
      MCode ='No Code';
    }
    setState(() {

    });
  }
  Search_College()async{
    print('Verification Started. Code = ${collegeCode.text.toString()}');
    final resp = await http.get(
      Uri.parse("http://52.66.132.36/college/api/college?collegeCode=${collegeCode.text.toString()}"),
      // server login url
    );
    if (resp.statusCode == 200){
      College_Details = json.decode(resp.body);
      Wr_Code();
      print("http://52.66.132.36/college/api/college?collegeCode=${collegeCode.text.toString()}");
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

  checkLogin() async {


    var sharedpref = await SharedPreferences.getInstance();

    List<Person> getDetails = await DatabaseHelper.instance.getAllDetails();

    loginKey =true;
    setState(() {

    });

    if(getDetails.isNotEmpty){
      collegeCode.text = getDetails[0].collegecode!.toString();
      setState(() {

      });
      if(sharedpref.getString("UserEnterScreen") !=null && sharedpref.getString("UserEnterScreen") =="3"){
        await Search_College();
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Admin_Drawer(username: getDetails[0].username.toString(), password: getDetails[0].password.toString(),)));

      } else if(sharedpref.getString("UserEnterScreen") !=null && sharedpref.getString("UserEnterScreen") =="1"){
        await Search_College();
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => StaffDrawerScreen(username: getDetails[0].username.toString(), password: getDetails[0].password.toString())));

      } else if(sharedpref.getString("UserEnterScreen") !=null && sharedpref.getString("UserEnterScreen") =="2"){
        await Search_College();
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => DrawerScreen(username: getDetails[0].username.toString(), password: getDetails[0].password.toString())));
      }

    }else{
      loginKey =false;
      setState(() {

      });
      Check_Code();
    }


  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkInternet();

    checkLogin();

  }

  @override
  Widget build(BuildContext context) {
    // SavePassword();
/*    if(MLogin() == true){
      Check_Code();
      return Scaffold(
        body: Center(
          child: SearchingDataLottie(context),
        ),
      );
    }
    else{*/
    return SafeArea(
      child: Scaffold(
        body:  loginKey == true ? Center(child: SearchingDataLottie(context)):  SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Column(
                children: [
                  const Text(
                    'Welcome',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Image.asset(
                    'images/introscreen/college_code.png',
                    height: 300,
                    width: 300,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MCode == 'No Code'? Column(
                    children: [
                      const Row(
                        children: [
                          Padding(padding: EdgeInsets.only(left: 40)),
                          Text(
                            'College Code',
                            style:
                            TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 40, right: 40),
                        child:  TextFormField(
                          controller: collegeCode,
                          decoration: const InputDecoration(
                            hintStyle:TextStyle(color: Colors.blueAccent),
                            labelText: "College Code",
                            labelStyle:TextStyle(color: Colors.blueAccent),
                            border: OutlineInputBorder(),
                            hintText: "Enter College Code",
                          ),
                          keyboardType: TextInputType.number,
                          validator: (e){
                            if(e!.isEmpty){
                              return "please enter validate College Code";
                            }
                            return null;
                          },
                          style: const TextStyle(color: Colors.black),
                        ),
                        /*Form(
                            key: _keyCode,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 70,
                              child: TextFormField(
                                maxLength: 6,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                decoration: const InputDecoration(
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
                                  return null;
                                },
                                style:  const TextStyle(color: Colors.black),
                                onSaved: (e){
                                  C_code =  e;
                                  },
                              ),
                            ),
                          ),*/
                      ),
                      const SizedBox(
                        height: 19,
                      ),
                    ],
                  ):Container(),

                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    margin: const EdgeInsets.fromLTRB(40, 10, 40, 20),
                    decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(30)),
                    child: ElevatedButton(
                      onPressed: ()async{
                        if(buttonClick ==false){
                          buttonClick =true;
                          setState(() {

                          });
                          checkInternet();
                          await  insertData();
                        }

                      },
                      style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.resolveWith((states) {
                            if (states.contains(MaterialState.pressed)) {
                              return const Color.fromRGBO(255, 52, 62, 1);
                            }
                            return const Color.fromRGBO(255, 52, 62, 1);
                          }),
                          shape:
                          MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)))),
                      child: MCode == 'No Code'? const Text(
                        'Proceed',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ):const Text(
                        'Click to Sign in',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'By continuing you are agreed to our',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(child: const Text(" Privacy Policy",style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800,
                          color: Colors.blue)),onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> const PrivacyPolicy()));
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

  Future<void> insertData()  async {
    print("checking daa ${collegeCode.runtimeType} .... ${collegeCode.text}");

    if(MCode =="No Code"){
      Person person = Person(collegecode: collegeCode.text.toString(),password: "",username: "");
      await DatabaseHelper.instance.insertNote(person);
      await Search_College();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login_Screen_Student(collegeCode.text)));
    }else{
      await Search_College();
      /*    var sharedpref = await SharedPreferences.getInstance();
      sharedpref.setString(logo_screenState.CollCode, C_code!);*/
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login_Screen_Student(collegeCode.text)));
    }
    buttonClick = true;
    setState(() {

    });




    /*final form =_keyCode.currentState;
    if (MLogCode() != 'No Code')
    {
      var sharedpref = await SharedPreferences.getInstance();
      C_code = sharedpref.getString(logo_screenState.CollCode) ?? 'No Code';
      await Search_College();
      sharedpref.setString(logo_screenState.CollCode, C_code!);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const Login_Screen_Student()));
    }
    else
    {
      if(form!.validate()){
        form.save();
        print('----Code = $C_code');
        await Search_College();
        var sharedpref = await SharedPreferences.getInstance();
        sharedpref.setString(logo_screenState.CollCode, C_code!);
           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const Login_Screen_Student()));

      }
    }*/
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
          if (request.url.startsWith(
              'https://www.impreserp.co.in/wp-content/Privacy_Policy.html')) {
            return NavigationDecision.navigate;
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
        title: const Text("Privacy Policy"),
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
