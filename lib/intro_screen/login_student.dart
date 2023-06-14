import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:add_dev_dolphin/Admin_Page/admin_drawer.dart';
import 'package:add_dev_dolphin/Admin_Page/admin_main.dart';
import 'package:add_dev_dolphin/Data/Student_Data.dart';
import 'package:add_dev_dolphin/Model/Staff_Screen/staff_main.dart';
import 'package:add_dev_dolphin/Style_font/designs.dart';
import 'package:add_dev_dolphin/UI/main_ui.dart';
import 'package:add_dev_dolphin/intro_screen/DrawerScreen.dart';
import 'package:add_dev_dolphin/intro_screen/logoscreen.dart';
import 'package:add_dev_dolphin/intro_screen/staffdrawer.dart';
import 'package:add_dev_dolphin/main.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:add_dev_dolphin/Model/Student_Screen/student_main.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login_Screen_Student extends StatefulWidget {
  const Login_Screen_Student({Key? key}) : super(key: key);

  @override
  State<Login_Screen_Student> createState() => _Login_ScreenState();
}

class _Login_ScreenState extends State<Login_Screen_Student> {
  TextEditingController Mycontrol2=TextEditingController();
  String userName = "";
  String password = "";
  String? UserID;
  bool _obscureText = true;
  bool? savepassword = false;
  TextEditingController Mycontrol1=TextEditingController();
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    // final snackbar4 = SnackBar(
    //   backgroundColor: Colors.green,
    //   content: const Text('Sign in With Google Successful!'),
    //   action: SnackBarAction(
    //     label: '',
    //     onPressed: () {
    //       // Some code to undo the change.
    //     },
    //   ),
    // );
    // ScaffoldMessenger.of(context).showSnackBar(snackbar4);
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
  _setvalueUsername(String value) {
  if(mounted){ return setState(() {
      try {
        userName = value;
      }
      catch(exception){
        userName = "";
      }
    });}
  }
  _setvaluePassword(String value) {
   if(mounted) return; setState(() {
      try {
        password = value;
      }
      catch(exception){
        password = "";
      }
    });
  }
  final _keyPhone = GlobalKey<FormState>();
  String? otp,number;
  int? OTTP,OTTP_Valid;
  Color Change = Colors.grey;
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
          context, MaterialPageRoute(builder: (context) => Login_Screen_Student()));
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
  String? Fi,Pa;
  final _keyFind = GlobalKey<FormState>();
  final _keyPA = GlobalKey<FormState>();
  late List Code_Save = [];
  late List Check_Stu = [];
  late List Check_Sta = [];
  late List Check_Ad = [];
  bool save = false;
  Find_Who()async{
    final responce = await http.get(Uri.parse("http://${ip}/api/FindStudentorStaff?Code=${Fi}"));
    print('find who address\nhttp://${ip}/api/FindStudentorStaff?Code=${Fi}');
    if(responce.statusCode == 200){
      Code_Save = json.decode(responce.body);
      print(Code_Save);
      UserID = Code_Save[0]['id'].toString();
      print('Recieved user id : $UserID');
    }
  }
  Find_Stu()async{
    final resk = await http.get(Uri.parse("http://${ip}/api/billing?RollNum=${Fi}&Password=${Pa}"));
    if(resk.statusCode == 200){
      Check_Stu = json.decode(resk.body);
      print(Check_Stu.length);
    }
  }
  Dummy()async{
    if(Check_Stu.length.toString() == 0.toString()){
      await Fluttertoast.showToast(
          backgroundColor: Colors.red,
          msg: "Wrong User ID or Password",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
    else if(Check_Stu.length.toString() == 1.toString()){
      var sharedpref = await SharedPreferences.getInstance();
      sharedpref.setBool(logo_screenState.KEYLOGIN, true);
      sharedpref.setString(logo_screenState.USERKEY, Fi.toString());
      sharedpref.setString(logo_screenState.PASSKEY, Pa.toString());
      sharedpref.setBool(logo_screenState.UserIdentity, false);
      await Navigator.push(context, MaterialPageRoute(
          builder: (context) => DrawerScreen(username: Fi.toString(), password: Pa.toString())));
    }
  }
  Find_Sta()async{
    final respl = await http.get(Uri.parse("http://${ip}/api/StaffInfo?StaffCode=${Fi.toString()}&Password=${Pa.toString()}"));
    if(respl.statusCode == 200){
      Check_Sta = json.decode(respl.body);
      print("---------------${Check_Sta.length}");
      if(Check_Sta.length.toString() == 1.toString()){
        var sharedpref = await SharedPreferences.getInstance();
        sharedpref.setBool(logo_screenState.KEYLOGIN, true);
        sharedpref.setString(logo_screenState.USERKEY, Fi.toString());
        sharedpref.setString(logo_screenState.PASSKEY, Pa.toString());
        sharedpref.setBool(logo_screenState.UserIdentity, true);
        await Navigator.push(context, MaterialPageRoute(
            builder: (context) => StaffDrawerScreen(username: Fi.toString(), password: Pa.toString())));
      }
      else if(Check_Sta.length.toString() != 1.toString()){
        await Fluttertoast.showToast(
            backgroundColor: Colors.red,
            msg: "Wrong User ID or Password",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.SNACKBAR,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
    }
    else if(respl.statusCode != 200){
      await Fluttertoast.showToast(
          backgroundColor: Colors.red,
          msg: "Wrong User ID or Password",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }
  Find_Admin()async{
    final respl = await http.get(Uri.parse("http://${ip}/api/acadyear?StaffCode=${Fi.toString()}&Password=${Pa.toString()}"));
    if(respl.statusCode == 200){
      Check_Ad = json.decode(respl.body);
      print("---------------${Check_Ad.length}");
      if(Check_Ad.length  > 1 ){
        var sharedpref = await SharedPreferences.getInstance();
        sharedpref.setBool(logo_screenState.KEYLOGIN, true);
        sharedpref.setString(logo_screenState.USERKEY, Fi.toString());
        sharedpref.setString(logo_screenState.PASSKEY, Pa.toString());
        sharedpref.setBool(logo_screenState.UserIdentity, true);
       await Navigator.push(context, MaterialPageRoute(builder: (context)=>Admin_Drawer(username: Fi.toString(), password: Pa.toString(),)));
      }
      else if(Check_Ad.length.toString() == 0.toString()){
        await Fluttertoast.showToast(
            backgroundColor: Colors.red,
            msg: "Wrong User ID or Password",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.SNACKBAR,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
    }
    else if(respl.statusCode != 200){
      await Fluttertoast.showToast(
          backgroundColor: Colors.red,
          msg: "Wrong User ID or Password",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }
  valid()async{
    final form =_keyFind.currentState;
    if(MLogUser() != 'No User')
    {
      Fi = MLogUser();
      await Find_Who();
    }
    else
      {
        if(form!.validate()){
          form.save();
          await Find_Who();
        }
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
  validPa()async{
    final form = _keyPA.currentState;
    if(MLogPass() != 'No Pass')
      {
        Pa = MLogPass();
        print('Student login success XYZ\n User Id = $UserID');
        if(UserID.toString() == 2.toString()){
          await Find_Stu();
          await Dummy();
        }
        else if(UserID.toString() == 1.toString()){
          await Find_Sta();
        }
        else if(UserID.toString() == 3.toString()){
          await Find_Admin();
        }
        else if(UserID.toString() == 0.toString()){
          await Fluttertoast.showToast(
              backgroundColor: Colors.red,
              msg: "Wrong User ID or Password",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.SNACKBAR,
              textColor: Colors.white,
              fontSize: 16.0
          );
        }
      }
    else
      {
        if(form!.validate()){
          form.save();
          if(UserID.toString() == 2.toString()){
            await Find_Stu();
            await Dummy();
          }
          else if(UserID.toString() == 1.toString()){
            await Find_Sta();
          }
          else if(UserID.toString() == 3.toString()){
            await Find_Admin();
          }
          else if(UserID.toString() == 0.toString()){
            await Fluttertoast.showToast(
                backgroundColor: Colors.red,
                msg: "Wrong User ID or Password",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.SNACKBAR,
                textColor: Colors.white,
                fontSize: 16.0
            );
          }
        }
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
   if (mounted) return; setState(() {

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

  Server_Check()async{
    final serve = await http.get(Uri.parse("http://${ip}"));
    if(serve.statusCode != 200){
    if(mounted) return;  setState(() {
        Serve = true;
      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkInternet();
  }
  @override
  Widget build(BuildContext context) {
    if(MLogin() == true)
    {
      valid();
      Future.delayed(Duration(seconds: 2),(){
        validPa();
      });
      Server_Check();
      return Scaffold(
        body: Center(
          child: Serve?Lottie.asset("images/introscreen/Internal_Server_Error.json"):SearchingDataLottie(context),
        ),
      );
    }
    else
      {
        return Scaffold(
            body: Container(
                child: SingleChildScrollView(
                  child: Padding(
                      padding: EdgeInsets.only(top: 0),
                      child: Column(children: [
                        Image.asset(
                            'images/introscreen/logo.png',
                            height: sHeight(20, context),
                            width: sWidth(20, context)
                        ),
                        Text(
                          "LET'S GET STARTED",
                          style:TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        log_type == 2.toString() || log_type == 1.toString()?
                        Container(
                          child:Column(
                              children:[
                                Text(
                                  "Sign in with User ID",
                                  style:TextStyle(fontSize: 15, color: Colors.grey),
                                ),
                                SizedBox(
                                  height: sHeight(3, context),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 40, right: 40),
                                  child: Form(
                                    key: _keyFind,
                                    child: TextFormField(
                                      inputFormatters: [FilteringTextInputFormatter.deny(' ')],
                                      cursorColor: Colors.black,
                                      onChanged: (String value) => _setvalueUsername(value),
                                      validator: (e){
                                        if(e!.isEmpty){
                                          return "Please Enter Your User Id";
                                        }
                                      },
                                      onSaved: (e)=>  Fi =  e ,
                                      style:
                                      TextStyle(color: Colors.black.withOpacity(0.9)),
                                      decoration: InputDecoration(
                                        labelText: ('User ID'),
                                        labelStyle: TextStyle(
                                            color: Colors.grey.withOpacity(0.9),
                                            fontSize: 10),
                                        filled: true,
                                        suffixIcon: Icon(Icons.person_pin),
                                        floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                        fillColor: Colors.white.withOpacity(0.3),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10.0),
                                            borderSide: BorderSide(
                                                width: 5, style: BorderStyle.none)),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    height: sHeight(2, context)
                                ),
                                Padding(
                                    padding: EdgeInsets.only(left: 40, right: 40),
                                    child: Form(
                                      key: _keyPA,
                                      child: TextFormField(
                                        // obscureText: true,
                                        inputFormatters: [FilteringTextInputFormatter.deny(' ')],
                                        cursorColor: Colors.black,
                                        onChanged: (String value) => _setvaluePassword(value),
                                        onSaved: (e)=>  Pa =  e,
                                        obscureText: _obscureText,
                                        validator: (e){
                                          if(e!.isEmpty){
                                            return ("Please Enter Your Password");
                                          }
                                        },
                                        style:
                                        TextStyle(color: Colors.black.withOpacity(0.9)),
                                        decoration: InputDecoration(
                                          labelText: ('Password'),
                                          labelStyle: TextStyle(
                                              color: Colors.grey.withOpacity(0.9),
                                              fontSize: 10),
                                          filled: true,
                                          suffixIcon: GestureDetector(onTap: (){
                                          if(mounted) { setState(() {
                                              _obscureText =! _obscureText;
                                            });}
                                          },
                                            child: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                                          ),
                                          floatingLabelBehavior:
                                          FloatingLabelBehavior.never,
                                          fillColor: Colors.white.withOpacity(0.3),
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                              borderSide: BorderSide(
                                                  width: 5, style: BorderStyle.none)),
                                        ),
                                      ),
                                    )),
                                // Row(
                                //   children: <Widget>[
                                //     SizedBox(
                                //       width: sWidth(8, context),
                                //     ),
                                //     Checkbox(
                                //       value:  savePass,
                                //         onChanged: (newbool) {
                                //           savePass = !savePass;
                                //           print(savePass);
                                //           setState(() {
                                //           });
                                //         }),
                                //     Text('Save Password',style:TextStyle(),)
                                //   ],
                                // ),
                                SizedBox(height: sHeight(3, context),),
                                DelayedDisplay(
                                  slidingCurve: Curves.easeIn,
                                  delay: Duration(milliseconds: 500,),
                                  child:
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 50,
                                    margin: const EdgeInsets.fromLTRB(40, 10, 40, 20),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30)),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        checkInternet();
                                        await valid();
                                        await validPa();
                                        // await Dummy_Sta();
                                      },
                                      style: ButtonStyle(
                                          backgroundColor:
                                          MaterialStateProperty.resolveWith((states) {
                                            if (states.contains(MaterialState.pressed)) {
                                              return Color.fromRGBO(255, 52, 62, 1);
                                            }
                                            return Color.fromRGBO(255, 52, 62, 1);
                                          }),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(10)))),
                                      child: Text(
                                        'Sign In',
                                        style:TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ),
                                // LogB?
                                // Container(
                                //   width: MediaQuery.of(context).size.width,
                                //   height: 50,
                                //   margin: const EdgeInsets.fromLTRB(40, 10, 40, 20),
                                //   decoration: BoxDecoration(
                                //       borderRadius: BorderRadius.circular(30)),
                                //   child: ElevatedButton(
                                //     onPressed: () async {
                                //       if(savePass == true){
                                //         Navigator.push(context,
                                //             MaterialPageRoute(builder: (context)=>
                                //                 StudentHomePage
                                //                   (username: ID,
                                //                     password: Code)));
                                //       }
                                //       else{
                                //         Fluttertoast.showToast(
                                //           backgroundColor: Colors.red,
                                //           msg: "You Did Not Save Your Password",
                                //           toastLength: Toast.LENGTH_SHORT,
                                //           gravity: ToastGravity.CENTER,
                                //           textColor: Colors.white,
                                //           fontSize: 16.0,
                                //         );
                                //       }
                                //     },
                                //     style: ButtonStyle(
                                //         backgroundColor:
                                //         MaterialStateProperty.resolveWith((states) {
                                //           if (states.contains(MaterialState.pressed)) {
                                //             return Colors.green;
                                //           }
                                //           return Colors.green;
                                //         }),
                                //         shape: MaterialStateProperty.all<
                                //             RoundedRectangleBorder>(
                                //             RoundedRectangleBorder(
                                //                 borderRadius:
                                //                 BorderRadius.circular(10)))),
                                //     child: Text(
                                //       'Log In',
                                //       style:TextStyle(
                                //           color: Colors.white,
                                //           fontWeight: FontWeight.bold,
                                //           fontSize: 16),
                                //     ),
                                //   ),
                                // ):new Container(),



                              ]),): new Container(),
                        log_type == 1.toString()?  Text(
                          '-----------  or,sign in with  ----------',
                          style:TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ):Container(),
                        log_type == 3.toString()|| log_type == 1.toString()?
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          margin: const EdgeInsets.fromLTRB(40, 10, 40, 20),
                          decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(10)),
                          child: ElevatedButton(
                              onPressed: () {
                                showDialog<void>(context: context,
                                    builder: (BuildContext context){
                                      return AlertDialog(
                                        title: Text("",style: TextStyle(fontSize: 0.3),),
                                        content: Container(
                                          height: sHeight(55, context),
                                          width: sWidth(100, context),
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: Column(
                                              children: [
                                                Image.asset("images/intro_img/small_logo.png"),
                                                Text("Enter Your Mobile Number",style:TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
                                                Text("We Will Send a Confirmation Code",style:TextStyle(fontSize: 12),),
                                                SizedBox(height: sHeight(3, context),),
                                                Container(
                                                  height: sHeight(10, context),width: sWidth(80, context),
                                                  child: Form(
                                                    key: _keyPhone,
                                                    child: TextFormField(
                                                      maxLength: 10,
                                                      controller: Mycontrol1,
                                                      decoration: InputDecoration(
                                                        hintStyle:TextStyle(color: Colors.black),
                                                        labelText: "Enter Mobile Number",
                                                        labelStyle:TextStyle(color: Colors.black),
                                                        border: OutlineInputBorder(),
                                                        hintText: "Mobile Number",
                                                      ),
                                                      keyboardType: TextInputType.number,
                                                      validator: (e){
                                                        if(e!.isEmpty){
                                                          return "please enter your Mobile number";
                                                        }
                                                        if(e.length < 10){
                                                          return "phone Number Character Should 10";
                                                        }
                                                      },
                                                      style: TextStyle(color: Colors.black),
                                                      onSaved: (e)=>  number =  e ,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: sHeight(2, context),),
                                                InkWell(
                                                  onTap: ()async{
                                                    await GenerateOTP();
                                                    checkOTP();
                                                    showDialog<void>(
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return AlertDialog(
                                                              title: Text(
                                                                "",
                                                                style: TextStyle(
                                                                    fontSize: 0.3),
                                                              ),
                                                              content: Container(
                                                                  height:
                                                                  sHeight(55, context),
                                                                  width:
                                                                  sWidth(100, context),
                                                                  child: SingleChildScrollView(
                                                                      scrollDirection:
                                                                      Axis.vertical,
                                                                      child: Column(
                                                                          children: [
                                                                            Image.asset(
                                                                                "images/introscreen/small_logo.png"),
                                                                            Text('We are automatically detecting a SMS\nSend to you mobile number  ${Mycontrol1.text} ',
                                                                              style:TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 13),
                                                                            ),
                                                                            SizedBox(height: sHeight(5, context),),
                                                                            Container(
                                                                              height: sHeight(10, context),width: sWidth(60, context),
                                                                              child:
                                                                              TextFormField(
                                                                                controller: Mycontrol2,
                                                                                decoration: InputDecoration(
                                                                                  hintStyle:TextStyle(color: Colors.green),
                                                                                  labelText: "Enter OTP",
                                                                                  labelStyle:TextStyle(color: Colors.green),
                                                                                  border: OutlineInputBorder(),
                                                                                  hintText: "OTP",
                                                                                ),
                                                                                keyboardType: TextInputType.number,
                                                                                validator: (e){
                                                                                  if(e!.isEmpty){
                                                                                    return "please enter validate OTP";
                                                                                  }
                                                                                },
                                                                                style: TextStyle(color: Colors.black),
                                                                              ),
                                                                            ),
                                                                            Row(
                                                                              children: [
                                                                                Text("Didn't receive the OTP? ",style:TextStyle(fontSize: 12),),
                                                                                TextButton(onPressed: (){

                                                                                }, child: Text('Resend again',style:TextStyle(fontSize:12,color: Colors.green,),))
                                                                              ],
                                                                            ),
                                                                            SizedBox(
                                                                              height: sHeight(5, context),
                                                                            ),
                                                                            InkWell(
                                                                              onTap: ()async{
                                                                                await Validate_OTP();
                                                                              },
                                                                              child: Container(
                                                                                height: sHeight(8, context),
                                                                                width: sWidth(50, context),
                                                                                decoration: BoxDecoration(
                                                                                  color: Colors.grey,
                                                                                  borderRadius: BorderRadius.all(
                                                                                    Radius.circular(10),
                                                                                  ),
                                                                                ),
                                                                                child: Center(
                                                                                  child: Text(
                                                                                    "Verify OTP",
                                                                                    style:TextStyle(
                                                                                        color: Colors.white,
                                                                                        fontWeight: FontWeight.w700),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            )

                                                                          ]))));
                                                        });
                                                  },
                                                  child: Container(
                                                    height: sHeight(8, context),width: sWidth(50, context),
                                                    decoration: BoxDecoration(
                                                      color: Change,
                                                      borderRadius: BorderRadius.all(Radius.circular(10),),
                                                    ),
                                                    child: Center(child: Text("Send OTP",style:TextStyle(color: Colors.white,fontWeight: FontWeight.w700),),),
                                                  ),
                                                ),
                                                SizedBox(height: sHeight(4, context),),
                                                Text("By Continuing you agree to Reading Challenge",style:TextStyle(fontSize: 10,fontWeight: FontWeight.w600),),
                                                TextButton(onPressed: ()async{

                                                }, child:
                                                Text("Terms and Conditions & Privacy Policy",style:TextStyle(fontSize: 11,
                                                    fontWeight: FontWeight.w700,decoration: TextDecoration.underline,color: Colors.black),))
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                              },
                              style: ButtonStyle(
                                  backgroundColor:
                                  MaterialStateProperty.resolveWith((states) {
                                    if (states.contains(MaterialState.pressed)) {
                                      return Color.fromRGBO(8, 197, 110,1);
                                    }
                                    return Color.fromRGBO(8, 197, 110,1);
                                  }),
                                  shape:
                                  MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10)))),
                              child: Row(
                                children: [
                                  Image.asset('images/introscreen/mobilr_number.png',
                                    height: sHeight(10, context),
                                    width: sWidth(10, context),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Login with Mobile number',
                                    style:TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ],
                              )
                          ),
                        ):new Container(),
                        log_type == 4.toString() || log_type == 1.toString()?
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          margin: const EdgeInsets.fromLTRB(40, 10, 40, 20),
                          decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.black)
                          ),
                          child: ElevatedButton(
                            onPressed: ()async {
                              UserCredential user = await signInWithGoogle();
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                MaterialStateProperty.resolveWith((states) {
                                  if (states.contains(MaterialState.pressed)) {
                                    return Colors.grey;
                                  }
                                  return Colors.white;
                                }),
                                shape:
                                MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)))),
                            child: Row(
                              children: [
                                Image.asset("images/intro_img/google_login.png"),
                                SizedBox(width: sWidth(4, context),),
                                Text(
                                  'Continue with Google',
                                  style:TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                )
                              ],
                            ),
                          ),
                        ):new Container(),
                        // Row(
                        //   children: [
                        //     SizedBox(
                        //       width: sWidth(25, context),
                        //     ),
                        //     Text('New here?',style:TextStyle(),),
                        //     InkWell(
                        //       child: Text('Create a new one',style:TextStyle(color: Colors.green,decoration: TextDecoration.underline),),
                        //       onTap: (){},
                        //     )
                        //   ],
                        // ),
                        SizedBox(
                          height: sHeight(2, context),
                        ),
                        // Text(
                        //   'By continuing you agree to Reading Challenge ', style:TextStyle(fontSize: 12, fontWeight: FontWeight.w300),),
                        // TextButton(onPressed: (){}, child: Text('Terms and Condition & Privacy Policy',style:TextStyle(fontSize: 12,decoration: TextDecoration.underline,color: Colors.black),))
                      ])),
                ))
        );
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