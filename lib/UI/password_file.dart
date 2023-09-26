import 'dart:async';
import 'dart:math';
import 'package:add_dev_dolphin/Data/Student_Data.dart';
import 'package:add_dev_dolphin/Style_font/designs.dart';
import 'package:add_dev_dolphin/UI/main_ui.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class PassW_protect extends StatefulWidget {
  const PassW_protect({Key? key}) : super(key: key);

  @override
  State<PassW_protect> createState() => _PassW_protectState();
}

class _PassW_protectState extends State<PassW_protect> {
  late ConnectivityResult result;
  late StreamSubscription subscription;
  var isConnected = false;
  final _key = GlobalKey<FormState>();
  final _key1 = GlobalKey<FormState>();
  int? OTTP,OTTP_Valid;
  TextEditingController Mycontrol1=TextEditingController();
  TextEditingController Mycontrol2=TextEditingController();
  bool show1 = true;
  bool show2 = false;
  bool show3 = true;
  bool show4 = false;
  bool show_ele1 = false;
  bool show_ele2 = false;
  final _keyPhone = GlobalKey<FormState>();
  String? otp,number;
  String? email1, password1;
  String?email,password;
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
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
     final prefs = await SharedPreferences.getInstance();
     prefs.setInt('college', Selection);
     prefs.setString('name', ItemName);
     prefs.setString('IPAddress', ip);
     SetSetupDone(true);
    final snackbar4 = SnackBar(
      backgroundColor: Colors.green,
      content: const Text('Sign in With Google Successful!'),
      action: SnackBarAction(
        label: '',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar4);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
  Email_Signin() async {
    try {
      final credential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email!,
        password: password!,
      );
      show4 = true;
      show3 = false;
      final snackbar4 = SnackBar(
        backgroundColor: Colors.green,
        content: const Text('Email Sign in Successfully'),
        action: SnackBarAction(
          label: '',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar4);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        final snackbar4 = SnackBar(
          content: const Text('please create a Strong password'),
          action: SnackBarAction(
            label: '',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackbar4);
      }
      else if (e.code == 'email-already-in-use') {
        final snackbar3 = SnackBar(
          content: const Text('Email Already in use! You Can Login'),
          backgroundColor: Colors.green,
          action: SnackBarAction(
            label: '',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackbar3);
      }
    } catch (e) {
      print(e);
    }
    setState(() {

    });
  }
  Email_Login() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email1!,
        password: password1!,
      );
      // var acs=ActionCodeSettings(androidPackageName: "com.example.my_ecom_app",url: "",handleCodeInApp: true, androidMinimumVersion: "23");
      // FirebaseAuth.instance.sendSignInLinkToEmail(email: email1!, actionCodeSettings: acs);
      //print(credential.user!.emailVerified.toString());
      final snackbar2 = SnackBar(
        backgroundColor: Colors.green,
        content: const Text('Login Sucessfull'),
        action: SnackBarAction(
          label: '',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar2);
      final prefs = await SharedPreferences.getInstance();
      prefs.setInt('college', Selection);
      prefs.setString('name', ItemName);
      prefs.setString('IPAddress', ip);
      SetSetupDone(true);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        final snackbar0 = SnackBar(
          backgroundColor: Colors.red,
          content: const Text('No user Found that Email'),
          action: SnackBarAction(
            label: '',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackbar0);
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        final snackbar1 = SnackBar(
          backgroundColor: Colors.red,
          content: const Text('Wrong password'),
          action: SnackBarAction(
            label: '',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackbar1);
      }
    }
  }
  check_login() {
    final form = _key1.currentState;
    if (form!.validate()) {
      form.save();
      Email_Login();
    }
  }
  check() {
    final form = _key.currentState;
    if (form!.validate()) {
      form.save();
      Email_Signin();
    }
  }

  checkOTP(){
    final form =_keyPhone.currentState;
    if(form!.validate()){
      form.save();
       Phone_OTP_Generate();
    }
  }
  GenerateOTP(){
    var rand = Random();
    OTTP = rand.nextInt(4000) + 1000;
    return OTTP;
  }
  Phone_OTP_Generate() async {
    final response = await http.get(Uri.parse("https://smshorizon.co.in/api/sendsms.php?user=gokul.nithra&apikey=RfOXkuINM7lzds6nCOPV&mobile=${Mycontrol1.text}&message=${OTTP}%20is%20your%20OTP%20to%20verify%20your%20mobile%20number%20on%20Nithra%20app%2Fwebsite.&senderid=NITHRA&type=txt&tid=1307160853199181365"));
    if (response.statusCode == 200) {
      final snackbar2 = SnackBar(
        backgroundColor: Colors.green,
        content: const Text('OTP Send successfully'),
        action: SnackBarAction(
          label: '',
          onPressed: () {
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar2);
    }
    else {
      print("login fail");
    }
  }
  Validate_OTP()async {
    String Rotp = Mycontrol2.text;
    if (Rotp.toString() == OTTP.toString()) {
      await Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));
      final snackbar2 = SnackBar(
        backgroundColor: Colors.green,
        content: const Text('Verification successfully Completed'),
        action: SnackBarAction(
          label: '',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar2);
      // final prefs = await SharedPreferences.getInstance();
      // prefs.setInt('college', Selection);
      // prefs.setString('name', ItemName);
      // prefs.setString('IPAddress', ip);
      // SetSetupDone(true);
    }
    else {
      final snackbar2 = SnackBar(
        backgroundColor: Colors.red,
        content: const Text('Wrong OTP'),
        action: SnackBarAction(
          label: '',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar2);
    }
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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(height: sHeight(10, context),),
            Text("Choose Your SignIn Method",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700,color: Colors.purple),),
            SizedBox(height: sHeight(4, context),),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 InkWell(
                 onTap: (){
                   setState(() {
                     show1 = true;
                     show2 = false;
                   });
                 },
                   child: CircleAvatar(
                   radius: 20,
                     backgroundColor: Colors.white,
                     backgroundImage: AssetImage("images/temp_ui_images/phone_login.png"),
                   ),
                 ),
                 SizedBox(width: sWidth(3.5, context),),
                InkWell(
                  onTap: (){
                    setState(() {
                      show1 = false;
                      show2 = true;
                    });
                  },
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage("images/temp_ui_images/mail_login.png",),
                  ),
                ),
                SizedBox(width: sWidth(3.5, context),),
                InkWell(
                  onTap: ()async{
                    UserCredential user = await signInWithGoogle();
                    setState(() {
                      show2 = false;
                      show1 = false;
                    });
                  },
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage("images/temp_ui_images/google_signin.png"),
                  ),
                ),
              ],
            ),
            SizedBox(height: sHeight(3, context),),
            show1?
            Container(
              height: sHeight(80, context),
              width: sWidth(95, context),
              child:
              Form(
                key: _keyPhone,
                child: Column(
                  children: [
                    SizedBox(height: sHeight(18, context),),
                    Container(
                      height: sHeight(10, context),width: sWidth(80, context),
                      child: TextFormField(
                        controller: Mycontrol1,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.orange),
                          labelText: "Enter Phone Number",
                          labelStyle: TextStyle(color: Colors.orange),
                          border: OutlineInputBorder(),
                          hintText: "Phone Number",
                        ),
                        keyboardType: TextInputType.number,
                        validator: (e){
                          if(e!.isEmpty){
                            return "please enter your phone number";
                          }
                          if(e.length<10){
                            return "Phone Number Should be 10 characters";
                          }
                        },
                        style:  TextStyle(color: Colors.black),
                        onSaved: (e)=>  number =  e ,
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(width: sWidth(62, context),),
                        ElevatedButton(onPressed: ()async{
                        await GenerateOTP();
                         checkOTP();
                          setState(() {
                            show_ele1 = true;
                          });
                        }, child: Text("Send OTP",style: TextStyle(),)),
                      ],
                    ),
                    show_ele1?
                    Container(
                      height: sHeight(10, context),width: sWidth(80, context),
                       child:
                        TextFormField(
                        controller: Mycontrol2,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.green),
                          labelText: "Enter OTP",
                          labelStyle: TextStyle(color: Colors.green),
                          border: OutlineInputBorder(),
                          hintText: "OTP",
                        ),
                        keyboardType: TextInputType.number,
                        validator: (e){
                          if(e!.isEmpty){
                            return "please enter validate OTP";
                          }
                        },
                          style:  TextStyle(color: Colors.black),
                      ),
                    ):new Container(),
                    show_ele1?
                    Row(
                      children: [
                        SizedBox(width: sWidth(59, context),),
                        ElevatedButton(onPressed: ()async{
                          Validate_OTP();
                        }, child: Text("Validate OTP",style:  TextStyle(),)),
                      ],
                    ):new Container(),
                    SizedBox(height: sHeight(6, context),),
                  ],
                ),
              ),
            ):new Container(),
            SizedBox(height: sHeight(18, context),),
            show2?
            Container(
              height: sHeight(60, context),
              width: sWidth(95, context),
              child: Column(
                children: [
                  show3?
                  Form(
                    key: _key,
                    child: Column(
                      children: [
                        Container(
                          height: sHeight(10, context),width: sWidth(80, context),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            keyboardType: TextInputType.emailAddress,
                            validator: (e) {
                              if (e!.isEmpty) {
                                return "Please Enter the Email ID";
                              }
                            },
                            onSaved: (e) => email = e!,
                            style:  TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              hintStyle:  TextStyle(color: Colors.orange),
                              labelStyle:  TextStyle(color: Colors.orange),
                              border: OutlineInputBorder(),
                                hintText: "Enter Email ID",
                                labelText: "Email ID"
                            ),
                          ),
                        ),
                        SizedBox(height: sHeight(4, context),),
                        Container(
                          height: sHeight(10, context),width: sWidth(80, context),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (e) {
                              if (e!.isEmpty) {
                                return "Please Enter the Password";
                              }
                              if (e.length < 6) {
                                return "password must atleast 6 characters";
                              }
                            },
                            onSaved: (e) => password = e,
                            style:  TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                                hintStyle: TextStyle(color: Colors.green),
                                labelStyle: TextStyle(color: Colors.green),
                                hintText: "Enter Password",
                                labelText: "Password"),
                          ),
                        ),
                        SizedBox(
                          height: sHeight(2.5, context),
                        ),
                        Row(
                          children: [
                            SizedBox(width: sWidth(65, context),),
                            ElevatedButton(
                              child: Text(
                                "Sign in",
                                style:  TextStyle(color: Colors.white,fontWeight: FontWeight.w700),
                              ),
                              onPressed: () {
                                check();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple,
                              ),
                            ),
                          ],
                        ),
                       Container(
                         height: sHeight(10, context),width: sWidth(80, context),
                           padding: EdgeInsets.only(right: 68),
                           child: TextButton(onPressed: (){
                             setState(() {
                               show4 = true;
                               show3 = false;
                             });
                           }, child:  Text("Already have an Account? Log In",style:  TextStyle(fontSize: 14,fontWeight: FontWeight.w600),textAlign: TextAlign.left,),)),
                      ],
                    ),
                  ):new Container(),
                  show4?
                  Form(
                    key: _key1,
                    child: Column(
                      children: [
                        Container(
                          height: sHeight(10, context),width: sWidth(80, context),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            keyboardType: TextInputType.emailAddress,
                            validator: (e) {
                              if (e!.isEmpty) {
                                return "please Enter the Email ID";
                              }
                            },
                            onSaved: (e) => email1 = e!,
                            style:  TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                hintStyle:  TextStyle(color: Colors.orange),
                                labelStyle:  TextStyle(color: Colors.orange),
                                border: OutlineInputBorder(),
                                hintText: "Enter Email ID",
                                labelText: "Email ID"
                            ),
                          ),
                        ),
                        SizedBox(height: sHeight(4, context),),
                        Container(
                          height: sHeight(10, context),width: sWidth(80, context),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            autovalidateMode:
                            AutovalidateMode.onUserInteraction,
                            validator: (e) {
                              if (e!.isEmpty) {
                                return "Please Enter the Password";
                              }
                              if (e.length < 6) {
                                return "password Character should be 6";
                              }
                            },
                            onSaved: (e) => password1 = e,
                            style:  TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintStyle: TextStyle(color: Colors.green),
                                labelStyle: TextStyle(color: Colors.green),
                                hintText: "Enter Password",
                                labelText: "Password",
                            ),
                          ),
                        ),
                        SizedBox(
                          height: sHeight(2.5, context),
                        ),
                        Row(
                          children: [
                            SizedBox(width: sWidth(65, context),),
                            ElevatedButton(
                              onPressed: () {
                                check_login();
                              },
                              child: Text(
                                "Login",
                                style:  TextStyle(color: Colors.white,fontWeight: FontWeight.w700),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple,
                              ),
                            ),
                          ],
                        ),
                        Container(
                            height: sHeight(10, context),width: sWidth(80, context),
                            padding: EdgeInsets.only(right: 160),
                            child: TextButton(onPressed: (){
                              setState(() {
                                show4 = false;
                                show3 = true;
                              });
                            }, child:  Text("Create ERP App Account",style:  TextStyle(fontSize: 14,fontWeight: FontWeight.w600),textAlign: TextAlign.left,),)),
                      ],
                    ),
                  ):new Container(),
                ],
              ),
            ):new Container(),
          ],
        ),
      ),
    );
  }

}

















