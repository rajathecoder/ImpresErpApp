import 'dart:convert';
import 'package:add_dev_dolphin/Model/Staff_Screen/Staff_screen_c_2.dart';
import 'package:add_dev_dolphin/Style_font/Staff_Screen_Design.dart';
import 'package:add_dev_dolphin/Style_font/designs.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../Data/Staff_Data.dart';
import '../../intro_screen/staffdrawer.dart';

double sHeight(double per, BuildContext context) {
  double h = MediaQuery.of(context).size.height;
  return h * per / 100;
}

double sWidth(double per, BuildContext context) {
  double w = MediaQuery.of(context).size.width;
  return w * per / 100;
}

//Staff leave apply

class Staff_Leave_Apply extends StatefulWidget {
  const Staff_Leave_Apply(
      {Key? key, required this.username, required this.password})
      : super(key: key);
  final String username;
  final String password;

  @override
  State<Staff_Leave_Apply> createState() => _Staff_Leave_ApplyState();
}

class _Staff_Leave_ApplyState extends State<Staff_Leave_Apply> {
  late Future<LeaveBalanceData_List> LeaveBalanceAPIData;
  late Future<FindHodDataList> HOD_Find_API_Data;
  late Future<FacultyorHod_List> FacultyorHOD_Api_Data;
  late List<String> RecordType = [];
  late List<String> HOD_Staff_List = [];
  late List<String> HOD_Staff_Id = [];
  late List<String> Active_Acadamic_Year = [];
  late List<String> Acadamic_Year = [];
  late List<String> Type_Id = [];
  late List<String> Session_Type_FRom = ['FN', 'AN'];
  int? One_Fn = 1;
  int? One_An = 1;

  //int? One_Both = 1;
  //int? Multi_From_Both = 1;
  int? Multi_From_FN = 1;
  int? Multi_From_AN = 1;

  //int? Multi_TO_Both = 1;
  int? Multi_TO_FN = 1;
  int? Multi_TO_AN = 1;
  late List<String> Session_Type_TO = ['FN', 'AN'];
  late List<String> Leave_Category = [];
  bool isChecked = false;
  int? LeaveGetIndex = 0;
  bool checkboxValue1 = true;
  bool OneDay_Select = true;
  bool checkboxValue2 = false;
  String? LeaveFromDate;
  String? LeaveTODate;
  String? Multi_TO_Date;
  String? Multi_From_Date;
  String? LeaveName;
  String? fromdateuh;
  String? HOD_ID;
  String? Type_id;
  final Addreason = TextEditingController();

  bool Multiday_select = false;
  DateTime? Add_Date;
  DateTime? From_To_Pass;
  final _ReasonValid = GlobalKey<FormState>();


  MultipleDay_Date_validation() async {
    if (Multiday_select == true) {
      if (Multi_From_Date == null ||
          Multi_TO_Date == null ||
          Multi_From_FN == 1.toInt() ||
          //Multi_From_Both == 1.toInt() ||
          Multi_From_AN == 1.toInt() ||
          Multi_TO_FN == 1.toInt() ||
          //Multi_TO_Both == 1.toInt() ||
          Multi_TO_AN == 1.toInt()) {
        await Fluttertoast.showToast(
            backgroundColor: Colors.red,
            msg: "Kindly! Select From and TO Date and Session",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.SNACKBAR,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Reason_Leave_valid();
      }
    } else {}
  }

  Reason_Leave_valid() async {
    final form = _ReasonValid.currentState;
    if (form!.validate()) {
      form.save();
      if (OneDay_Select == true) {
        /* if (One_Both != -1) {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Staff_Leave_Apply_Alter_List(
                        username: widget.username,
                        password: widget.password,
                        fromdateuh: LeaveFromDate.toString(),
                        TOdateuh: LeaveTODate.toString(),
                        FromSesion: One_Both!.toInt(),
                        TOSessin: One_Both!.toInt(),
                        F_T_M: From_To_Pass as DateTime,
                      )));
        }*/
        if (One_An != -1) {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Staff_Leave_Apply_Alter_List(
                        username: widget.username,
                        password: widget.password,
                        fromdateuh: LeaveFromDate.toString(),
                        TOdateuh: LeaveTODate.toString(),
                        FromSesion: One_An!.toInt(),
                        TOSessin: One_An!.toInt(),
                        F_T_M: From_To_Pass as DateTime,
                        Reason: Addreason.text,
                        Hodid: HOD_ID.toString(),
                    Typeid: Type_id.toString(),
                      )));
        } else if (One_Fn != -1) {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Staff_Leave_Apply_Alter_List(
                        username: widget.username,
                        password: widget.password,
                        fromdateuh: LeaveFromDate.toString(),
                        TOdateuh: LeaveTODate.toString(),
                        FromSesion: One_Fn!.toInt(),
                        TOSessin: One_Fn!.toInt(),
                        F_T_M: From_To_Pass as DateTime,
                    Reason: Addreason.text,
                    Hodid: HOD_ID.toString(),
                    Typeid: Type_id.toString(),
                      )));
        }
      }
      if (Multiday_select == true) {
        /* if (Multi_From_Both != -1 && Multi_TO_Both != -1) {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Staff_Leave_Apply_Alter_List(
                        username: widget.username,
                        password: widget.password,
                        fromdateuh: Multi_From_Date.toString(),
                        TOdateuh: Multi_TO_Date.toString(),
                        FromSesion: Multi_From_Both!.toInt(),
                        TOSessin: Multi_TO_Both!.toInt(),
                        F_T_M: From_To_Pass as DateTime,
                      )));
        } */
        if (Multi_From_AN != -1 && Multi_TO_AN != -1) {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Staff_Leave_Apply_Alter_List(
                        username: widget.username,
                        password: widget.password,
                        fromdateuh: Multi_From_Date.toString(),
                        TOdateuh: Multi_TO_Date.toString(),
                        FromSesion: Multi_From_AN!.toInt(),
                        TOSessin: Multi_TO_AN!.toInt(),
                        F_T_M: From_To_Pass as DateTime,
                        Reason: Addreason.text,
                        Hodid: HOD_ID.toString(),
                        Typeid: Type_id.toString(),
                      )));
        }
        else if (Multi_From_FN != -1 && Multi_TO_FN != -1) {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Staff_Leave_Apply_Alter_List(
                        username: widget.username,
                        password: widget.password,
                        fromdateuh: Multi_From_Date.toString(),
                        TOdateuh: Multi_TO_Date.toString(),
                        FromSesion: Multi_From_FN!.toInt(),
                        TOSessin: Multi_From_FN!.toInt(),
                        F_T_M: From_To_Pass as DateTime,
                    Reason: Addreason.text,
                    Hodid: HOD_ID.toString(),
                    Typeid: Type_id.toString(),
                      )));
        }
        else if (Multi_From_FN != -1 && Multi_TO_AN != -1) {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Staff_Leave_Apply_Alter_List(
                        username: widget.username,
                        password: widget.password,
                        fromdateuh: Multi_From_Date.toString(),
                        TOdateuh: Multi_TO_Date.toString(),
                        FromSesion: Multi_From_FN!.toInt(),
                        TOSessin: Multi_TO_AN!.toInt(),
                        F_T_M: From_To_Pass as DateTime,
                    Reason: Addreason.text,
                    Hodid: HOD_ID.toString(),
                    Typeid: Type_id.toString(),
                      )));
        }
        /*else if (Multi_From_FN != -1 && Multi_TO_Both != -1) {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Staff_Leave_Apply_Alter_List(
                        username: widget.username,
                        password: widget.password,
                        fromdateuh: Multi_From_Date.toString(),
                        TOdateuh: Multi_TO_Date.toString(),
                        FromSesion: Multi_From_FN!.toInt(),
                        TOSessin: Multi_TO_Both!.toInt(),
                        F_T_M: From_To_Pass as DateTime,
                      )));
        } */
        else if (Multi_From_AN != -1 && Multi_TO_FN != -1) {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Staff_Leave_Apply_Alter_List(
                        username: widget.username,
                        password: widget.password,
                        fromdateuh: Multi_From_Date.toString(),
                        TOdateuh: Multi_TO_Date.toString(),
                        FromSesion: Multi_From_AN!.toInt(),
                        TOSessin: Multi_TO_FN!.toInt(),
                        F_T_M: From_To_Pass as DateTime,
                    Reason: Addreason.text,
                    Hodid: HOD_ID.toString(),
                    Typeid: Type_id.toString(),
                      )));
        }
        /*  else if (Multi_From_AN != -1 && Multi_TO_Both != -1) {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Staff_Leave_Apply_Alter_List(
                        username: widget.username,
                        password: widget.password,
                        fromdateuh: Multi_From_Date.toString(),
                        TOdateuh: Multi_TO_Date.toString(),
                        FromSesion: Multi_From_AN!.toInt(),
                        TOSessin: Multi_TO_Both!.toInt(),
                        F_T_M: From_To_Pass as DateTime,
                      )));
        }
        else if (Multi_From_Both != -1 && Multi_TO_FN != -1) {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Staff_Leave_Apply_Alter_List(
                        username: widget.username,
                        password: widget.password,
                        fromdateuh: Multi_From_Date.toString(),
                        TOdateuh: Multi_TO_Date.toString(),
                        FromSesion: Multi_From_Both!.toInt(),
                        TOSessin: Multi_TO_FN!.toInt(),
                        F_T_M: From_To_Pass as DateTime,
                      )));
        }
        else if (Multi_From_Both != -1 && Multi_TO_AN != -1) {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Staff_Leave_Apply_Alter_List(
                        username: widget.username,
                        password: widget.password,
                        fromdateuh: Multi_From_Date.toString(),
                        TOdateuh: Multi_TO_Date.toString(),
                        FromSesion: Multi_From_Both!.toInt(),
                        TOSessin: Multi_TO_AN!.toInt(),
                        F_T_M: From_To_Pass as DateTime,
                      )));
        }*/
      }
    }
  }

  Date_Validation1() async {
    if (checkboxValue1 == true && LeaveFromDate == null ||
            One_An == 1.toInt() ||
            One_Fn == 1.toInt()
        /*One_Both == 1.toInt()*/
        ) {
      await Fluttertoast.showToast(
          backgroundColor: Colors.red,
          msg: "Kindly! Select From Date and Session",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Leave_NONTeaching();
    }
  }

  MultipleDay_Date_validation1() async {
    if (Multiday_select == true) {
      if (Multi_From_Date == null ||
          Multi_TO_Date == null ||
          Multi_From_FN == 1.toInt() ||
          //Multi_From_Both == 1.toInt() ||
          Multi_From_AN == 1.toInt() ||
          Multi_TO_FN == 1.toInt() ||
          //Multi_TO_Both == 1.toInt() ||
          Multi_TO_AN == 1.toInt()) {
        await Fluttertoast.showToast(
            backgroundColor: Colors.red,
            msg: "Kindly! Select From and TO Date and Session",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.SNACKBAR,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Leave_NONTeaching();
      }
    } else {}
  }

  Leave_NONTeaching() async {
    final form = _ReasonValid.currentState;
    if (form!.validate()) {
      form.save();
      if (OneDay_Select == true) {
        /*if (One_Both != -1) {
              print("http://$StaticIP/api/StaffLeaveApply?StaffCode=${widget.username}&leaveFrom=${LeaveFromDate.toString()}&leaveTill=${LeaveTODate.toString()}&reason=${Addreason.text}&leaveTypeId=${Type_id.toString()}&forwardedPers1=${HOD_ID}&frSessionId=19&toSessionId=20&Password=${widget.password}");
          final resp = await http.get(Uri.parse(
              "http://$StaticIP/api/StaffLeaveApply?StaffCode=${widget.username}&leaveFrom=${LeaveFromDate.toString()}&leaveTill=${LeaveTODate.toString()}&reason=${Addreason.text}&leaveTypeId=${Type_id.toString()}&forwardedPers1=${HOD_ID}&frSessionId=19&toSessionId=20&Password=${widget.password}"));
          if (resp.statusCode == 200) {
            Responce_For_Facultyorhod = json.decode(resp.body);
            print("${Responce_For_Facultyorhod[0]['Msg'].toString()}");
            Leave_Apply_MSG = (Responce_For_Facultyorhod[0]['Msg'].toString());
            Fluttertoast.showToast(
                backgroundColor: Colors.deepPurple,
                msg: "${Responce_For_Facultyorhod[0]['Msg']}",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.SNACKBAR,
                textColor: Colors.white,
                fontSize: 16.0);
          }
          else {
            print("");
            await Fluttertoast.showToast(
                backgroundColor: Colors.grey,
                msg: "Leave Request is Not Sent",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.SNACKBAR,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        } */
        if (One_An != -1) {
          print(
              "http://$StaticIP/api/StaffLeaveApply?StaffCode=${widget.username}&leaveFrom=${LeaveFromDate.toString()}&leaveTill=${LeaveTODate.toString()}&reason=${Addreason.text}&leaveTypeId=${Type_id.toString()}&forwardedPers1=$HOD_ID&frSessionId=$One_An&toSessionId=$One_An&Password=${widget.password}");
          final resp = await http.get(Uri.parse(
              "http://$StaticIP/api/StaffLeaveApply?StaffCode=${widget.username}&leaveFrom=${LeaveFromDate.toString()}&leaveTill=${LeaveTODate.toString()}&reason=${Addreason.text}&leaveTypeId=${Type_id.toString()}&forwardedPers1=$HOD_ID&frSessionId=$One_An&toSessionId=$One_An&Password=${widget.password}"));
          if (resp.statusCode == 200) {
            Responce_For_Facultyorhod = json.decode(resp.body);
            print(Responce_For_Facultyorhod[0]['Msg'].toString());
            Leave_Apply_MSG = (Responce_For_Facultyorhod[0]['Msg'].toString());
            Fluttertoast.showToast(
                backgroundColor: Colors.deepPurple,
                msg: "${Responce_For_Facultyorhod[0]['Msg']}",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.SNACKBAR,
                textColor: Colors.white,
                fontSize: 16.0);
          } else {
            print("");
            await Fluttertoast.showToast(
                backgroundColor: Colors.grey,
                msg: "Leave Request is Not Sent",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.SNACKBAR,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        } else if (One_Fn != -1) {
          print(
              "http://$StaticIP/api/StaffLeaveApply?StaffCode=${widget.username}&leaveFrom=${LeaveFromDate.toString()}&leaveTill=${LeaveTODate.toString()}&reason=${Addreason.text}&leaveTypeId=${Type_id.toString()}&forwardedPers1=$HOD_ID&frSessionId=$One_Fn&toSessionId=$One_Fn&Password=${widget.password}");
          final resp = await http.get(Uri.parse(
              "http://$StaticIP/api/StaffLeaveApply?StaffCode=${widget.username}&leaveFrom=${LeaveFromDate.toString()}&leaveTill=${LeaveTODate.toString()}&reason=${Addreason.text}&leaveTypeId=${Type_id.toString()}&forwardedPers1=$HOD_ID&frSessionId=$One_Fn&toSessionId=$One_Fn&Password=${widget.password}"));
          if (resp.statusCode == 200) {
            Responce_For_Facultyorhod = json.decode(resp.body);
            print(Responce_For_Facultyorhod[0]['Msg'].toString());
            Leave_Apply_MSG = (Responce_For_Facultyorhod[0]['Msg'].toString());
            Fluttertoast.showToast(
                backgroundColor: Colors.deepPurple,
                msg: "${Responce_For_Facultyorhod[0]['Msg']}",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.SNACKBAR,
                textColor: Colors.white,
                fontSize: 16.0);
          } else {
            print("");
            await Fluttertoast.showToast(
                backgroundColor: Colors.grey,
                msg: "Leave Request is Not Sent",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.SNACKBAR,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        }
      }
      if (Multiday_select == true) {
        if (Multi_From_AN != -1 && Multi_TO_AN != -1) {
          print(
              "http://$StaticIP/api/StaffLeaveApply?StaffCode=${widget.username}&leaveFrom=${Multi_From_Date.toString()}&leaveTill=${Multi_TO_Date.toString()}&reason=${Addreason.text}&leaveTypeId=${Type_id.toString()}&forwardedPers1=$HOD_ID&frSessionId=20&toSessionId=20&Password=${widget.password}");
          final resp = await http.get(Uri.parse(
              "http://$StaticIP/api/StaffLeaveApply?StaffCode=${widget.username}&leaveFrom=${Multi_From_Date.toString()}&leaveTill=${Multi_TO_Date.toString()}&reason=${Addreason.text}&leaveTypeId=${Type_id.toString()}&forwardedPers1=$HOD_ID&frSessionId=20&toSessionId=20&Password=${widget.password}"));
          if (resp.statusCode == 200) {
            Responce_For_Facultyorhod = json.decode(resp.body);
            print(Responce_For_Facultyorhod[0]['Msg'].toString());
            Leave_Apply_MSG = (Responce_For_Facultyorhod[0]['Msg'].toString());
            Fluttertoast.showToast(
                backgroundColor: Colors.deepPurple,
                msg: "${Responce_For_Facultyorhod[0]['Msg']}",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.SNACKBAR,
                textColor: Colors.white,
                fontSize: 16.0);
          } else {
            print("");
            await Fluttertoast.showToast(
                backgroundColor: Colors.grey,
                msg: "Leave Request is Not Sent",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.SNACKBAR,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        } else if (Multi_From_FN != -1 && Multi_TO_FN != -1) {
          print(
              "http://$StaticIP/api/StaffLeaveApply?StaffCode=${widget.username}&leaveFrom=${Multi_From_Date.toString()}&leaveTill=${Multi_TO_Date.toString()}&reason=${Addreason.text}&leaveTypeId=${Type_id.toString()}&forwardedPers1=$HOD_ID&frSessionId=19&toSessionId=19&Password=${widget.password}");
          final resp = await http.get(Uri.parse(
              "http://$StaticIP/api/StaffLeaveApply?StaffCode=${widget.username}&leaveFrom=${Multi_From_Date.toString()}&leaveTill=${Multi_TO_Date.toString()}&reason=${Addreason.text}&leaveTypeId=${Type_id.toString()}&forwardedPers1=$HOD_ID&frSessionId=19&toSessionId=19&Password=${widget.password}"));
          if (resp.statusCode == 200) {
            Responce_For_Facultyorhod = json.decode(resp.body);
            print(Responce_For_Facultyorhod[0]['Msg'].toString());
            Leave_Apply_MSG = (Responce_For_Facultyorhod[0]['Msg'].toString());
            Fluttertoast.showToast(
                backgroundColor: Colors.deepPurple,
                msg: "${Responce_For_Facultyorhod[0]['Msg']}",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.SNACKBAR,
                textColor: Colors.white,
                fontSize: 16.0);
          } else {
            print("");
            await Fluttertoast.showToast(
                backgroundColor: Colors.grey,
                msg: "Leave Request is Not Sent",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.SNACKBAR,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        } else if (Multi_From_FN != -1 && Multi_TO_AN != -1) {
          print(
              "http://$StaticIP/api/StaffLeaveApply?StaffCode=${widget.username}&leaveFrom=${Multi_From_Date.toString()}&leaveTill=${Multi_TO_Date.toString()}&reason=${Addreason.text}&leaveTypeId=${Type_id.toString()}&forwardedPers1=$HOD_ID&frSessionId=${Multi_From_FN!.toInt()}&toSessionId=20&Password=${widget.password}");
          final resp = await http.get(Uri.parse(
              "http://$StaticIP/api/StaffLeaveApply?StaffCode=${widget.username}&leaveFrom=${Multi_From_Date.toString()}&leaveTill=${Multi_TO_Date.toString()}&reason=${Addreason.text}&leaveTypeId=${Type_id.toString()}&forwardedPers1=$HOD_ID&frSessionId=${Multi_From_FN!.toInt()}&toSessionId=20&Password=${widget.password}"));
          if (resp.statusCode == 200) {
            Responce_For_Facultyorhod = json.decode(resp.body);
            print(Responce_For_Facultyorhod[0]['Msg'].toString());
            Leave_Apply_MSG = (Responce_For_Facultyorhod[0]['Msg'].toString());
            Fluttertoast.showToast(
                backgroundColor: Colors.deepPurple,
                msg: "${Responce_For_Facultyorhod[0]['Msg']}",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.SNACKBAR,
                textColor: Colors.white,
                fontSize: 16.0);
          } else {
            print("");
            await Fluttertoast.showToast(
                backgroundColor: Colors.grey,
                msg: "Leave Request is Not Sent",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.SNACKBAR,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        } else if (Multi_From_AN != -1 && Multi_TO_FN != -1) {
          print(
              "http://$StaticIP/api/StaffLeaveApply?StaffCode=${widget.username}&leaveFrom=${Multi_From_Date.toString()}&leaveTill=${Multi_TO_Date.toString()}&reason=${Addreason.text}&leaveTypeId=${Type_id.toString()}&forwardedPers1=$HOD_ID&frSessionId=20&toSessionId=19&Password=${widget.password}");
          final resp = await http.get(Uri.parse(
              "http://$StaticIP/api/StaffLeaveApply?StaffCode=${widget.username}&leaveFrom=${Multi_From_Date.toString()}&leaveTill=${Multi_TO_Date.toString()}&reason=${Addreason.text}&leaveTypeId=${Type_id.toString()}&forwardedPers1=$HOD_ID&frSessionId=20&toSessionId=19&Password=${widget.password}"));
          if (resp.statusCode == 200) {
            Responce_For_Facultyorhod = json.decode(resp.body);
            print(Responce_For_Facultyorhod[0]['Msg'].toString());
            Leave_Apply_MSG = (Responce_For_Facultyorhod[0]['Msg'].toString());
            Fluttertoast.showToast(
                backgroundColor: Colors.deepPurple,
                msg: "${Responce_For_Facultyorhod[0]['Msg']}",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.SNACKBAR,
                textColor: Colors.white,
                fontSize: 16.0);
          } else {
            print("");
            await Fluttertoast.showToast(
                backgroundColor: Colors.grey,
                msg: "Leave Request is Not Sent",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.SNACKBAR,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        }
        /*else if (Multi_From_FN != -1 && Multi_TO_Both != -1) {
          print(
              "http://$StaticIP/api/StaffLeaveApply?StaffCode=${widget.username}&leaveFrom=${Multi_From_Date.toString()}&leaveTill=${Multi_TO_Date.toString()}&reason=${Addreason.text}&leaveTypeId=${Type_id.toString()}&forwardedPers1=${HOD_ID}&frSessionId=19&toSessionId=20&Password=${widget.password}");
          final resp = await http.get(Uri.parse(
              "http://$StaticIP/api/StaffLeaveApply?StaffCode=${widget.username}&leaveFrom=${Multi_From_Date.toString()}&leaveTill=${Multi_TO_Date.toString()}&reason=${Addreason.text}&leaveTypeId=${Type_id.toString()}&forwardedPers1=${HOD_ID}&frSessionId=19&toSessionId=20&Password=${widget.password}"));
          if (resp.statusCode == 200) {
            Responce_For_Facultyorhod = json.decode(resp.body);
            print("${Responce_For_Facultyorhod[0]['Msg'].toString()}");
            Leave_Apply_MSG = (Responce_For_Facultyorhod[0]['Msg'].toString());
            Fluttertoast.showToast(
                backgroundColor: Colors.deepPurple,
                msg: "${Responce_For_Facultyorhod[0]['Msg']}",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.SNACKBAR,
                textColor: Colors.white,
                fontSize: 16.0);
          } else {
            print("");
            await Fluttertoast.showToast(
                backgroundColor: Colors.grey,
                msg: "Leave Request is Not Sent",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.SNACKBAR,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        }*/
        /* if (Multi_From_Both != -1 && Multi_TO_Both != -1) {
          print(
              "http://$StaticIP/api/StaffLeaveApply?StaffCode=${widget.username}&leaveFrom=${Multi_From_Date.toString()}&leaveTill=${Multi_TO_Date.toString()}&reason=${Addreason.text}&leaveTypeId=${Type_id.toString()}&forwardedPers1=${HOD_ID}&frSessionId=19&toSessionId=20&Password=${widget.password}");
          final resp = await http.get(Uri.parse(
              "http://$StaticIP/api/StaffLeaveApply?StaffCode=${widget.username}&leaveFrom=${Multi_From_Date.toString()}&leaveTill=${Multi_TO_Date.toString()}&reason=${Addreason.text}&leaveTypeId=${Type_id.toString()}&forwardedPers1=${HOD_ID}&frSessionId=19&toSessionId=20&Password=${widget.password}"));
          if (resp.statusCode == 200) {
            Responce_For_Facultyorhod = json.decode(resp.body);
            print("${Responce_For_Facultyorhod[0]['Msg'].toString()}");
            Leave_Apply_MSG = (Responce_For_Facultyorhod[0]['Msg'].toString());
            Fluttertoast.showToast(
                backgroundColor: Colors.deepPurple,
                msg: "${Responce_For_Facultyorhod[0]['Msg']}",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.SNACKBAR,
                textColor: Colors.white,
                fontSize: 16.0);
          } else {
            print("");
            await Fluttertoast.showToast(
                backgroundColor: Colors.grey,
                msg: "Leave Request is Not Sent",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.SNACKBAR,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        }*/
        /*else if (Multi_From_AN != -1 && Multi_TO_Both != -1) {
          print(
              "http://$StaticIP/api/StaffLeaveApply?StaffCode=${widget.username}&leaveFrom=${Multi_From_Date.toString()}&leaveTill=${Multi_TO_Date.toString()}&reason=${Addreason.text}&leaveTypeId=${Type_id.toString()}&forwardedPers1=${HOD_ID}&frSessionId=20&toSessionId=19&Password=${widget.password}");
          final resp = await http.get(Uri.parse(
              "http://$StaticIP/api/StaffLeaveApply?StaffCode=${widget.username}&leaveFrom=${Multi_From_Date.toString()}&leaveTill=${Multi_TO_Date.toString()}&reason=${Addreason.text}&leaveTypeId=${Type_id.toString()}&forwardedPers1=${HOD_ID}&frSessionId=20&toSessionId=19&Password=${widget.password}"));
          if (resp.statusCode == 200) {
            Responce_For_Facultyorhod = json.decode(resp.body);
            print("${Responce_For_Facultyorhod[0]['Msg'].toString()}");
            Leave_Apply_MSG = (Responce_For_Facultyorhod[0]['Msg'].toString());
            Fluttertoast.showToast(
                backgroundColor: Colors.deepPurple,
                msg: "${Responce_For_Facultyorhod[0]['Msg']}",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.SNACKBAR,
                textColor: Colors.white,
                fontSize: 16.0);
          } else {
            print("");
            await Fluttertoast.showToast(
                backgroundColor: Colors.grey,
                msg: "Leave Request is Not Sent",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.SNACKBAR,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        }
        else if (Multi_From_Both != -1 && Multi_TO_FN != -1) {
          print(
              "http://$StaticIP/api/StaffLeaveApply?StaffCode=${widget.username}&leaveFrom=${Multi_From_Date.toString()}&leaveTill=${Multi_TO_Date.toString()}&reason=${Addreason.text}&leaveTypeId=${Type_id.toString()}&forwardedPers1=${HOD_ID}&frSessionId=20&toSessionId=19&Password=${widget.password}");
          final resp = await http.get(Uri.parse(
              "http://$StaticIP/api/StaffLeaveApply?StaffCode=${widget.username}&leaveFrom=${Multi_From_Date.toString()}&leaveTill=${Multi_TO_Date.toString()}&reason=${Addreason.text}&leaveTypeId=${Type_id.toString()}&forwardedPers1=${HOD_ID}&frSessionId=20&toSessionId=19&Password=${widget.password}"));
          if (resp.statusCode == 200) {
            Responce_For_Facultyorhod = json.decode(resp.body);
            print("${Responce_For_Facultyorhod[0]['Msg'].toString()}");
            Leave_Apply_MSG = (Responce_For_Facultyorhod[0]['Msg'].toString());
            Fluttertoast.showToast(
                backgroundColor: Colors.deepPurple,
                msg: "${Responce_For_Facultyorhod[0]['Msg']}",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.SNACKBAR,
                textColor: Colors.white,
                fontSize: 16.0);
          } else {
            print("");
            await Fluttertoast.showToast(
                backgroundColor: Colors.grey,
                msg: "Leave Request is Not Sent",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.SNACKBAR,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        }
        else if (Multi_From_Both != -1 && Multi_TO_AN != -1) {
          print(
              "http://$StaticIP/api/StaffLeaveApply?StaffCode=${widget.username}&leaveFrom=${Multi_From_Date.toString()}&leaveTill=${Multi_TO_Date.toString()}&reason=${Addreason.text}&leaveTypeId=${Type_id.toString()}&forwardedPers1=${HOD_ID}&frSessionId=19&toSessionId=20&Password=${widget.password}");
          final resp = await http.get(Uri.parse(
              "http://$StaticIP/api/StaffLeaveApply?StaffCode=${widget.username}&leaveFrom=${Multi_From_Date.toString()}&leaveTill=${Multi_TO_Date.toString()}&reason=${Addreason.text}&leaveTypeId=${Type_id.toString()}&forwardedPers1=${HOD_ID}&frSessionId=19&toSessionId=20&Password=${widget.password}"));
          if (resp.statusCode == 200) {
            Responce_For_Facultyorhod = json.decode(resp.body);
            print("${Responce_For_Facultyorhod[0]['Msg'].toString()}");
            Leave_Apply_MSG = (Responce_For_Facultyorhod[0]['Msg'].toString());
            Fluttertoast.showToast(
                backgroundColor: Colors.deepPurple,
                msg: "${Responce_For_Facultyorhod[0]['Msg']}",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.SNACKBAR,
                textColor: Colors.white,
                fontSize: 16.0);
          } else {
            print("");
            await Fluttertoast.showToast(
                backgroundColor: Colors.grey,
                msg: "Leave Request is Not Sent",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.SNACKBAR,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        }*/
      }
    }
  }

  late List Responce_For_Facultyorhod = [];
  String? Leave_Apply_MSG;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LeaveBalanceNetwork LeaveBalancenetwork = LeaveBalanceNetwork(
        "StaffLeaves?StaffCode=${widget.username}&Password=${widget.password}");
    LeaveBalanceAPIData = LeaveBalancenetwork.LeaveBalanceloadData();
    Hod_Find_Network hodFindNetwork = Hod_Find_Network(
        "FindHodForLeave?StaffCode=${widget.username}&Password=${widget.password}");
    HOD_Find_API_Data = hodFindNetwork.HODloadData();
    Faculty_Network facultyNetwork = Faculty_Network(
        "Faclutyorhod?StaffCode=${widget.username}&Password=${widget.password}");
    FacultyorHOD_Api_Data = facultyNetwork.Faculty_Data();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Leave Apply",
          style: PrimaryText(context),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(255, 98, 118, 1),
      ),
      backgroundColor: const Color.fromRGBO(242, 249, 250, 0.9),
      body: FutureBuilder(
          future: HOD_Find_API_Data,
          builder: (context, AsyncSnapshot<FindHodDataList> HodFindsnapshot) {
            if (HodFindsnapshot.hasError) {
              ErrorShowingWidget(context);
            }
            List<FindHodData> hodFindApiData;
            if (HodFindsnapshot.hasData) {
              hodFindApiData = HodFindsnapshot.data!.HOD_list;
              HOD_Staff_List = [
                for (int i = hodFindApiData.length - 1; i >= 0; i--)
                  hodFindApiData[i].staffName
              ];
              HOD_Staff_Id = [
                for (int i = hodFindApiData.length - 1; i >= 0; i--)
                  "${hodFindApiData[i].staffId}"
              ];
              return FutureBuilder(
                  future: LeaveBalanceAPIData,
                  builder: (context,
                      AsyncSnapshot<LeaveBalanceData_List>
                          LeaveBalancesnapshot) {
                    if (LeaveBalancesnapshot.hasError) {
                      ErrorShowingWidget(context);
                    }
                    List<LeaveBalanceAPI_data> LeaveBalancedata;
                    if (LeaveBalancesnapshot.hasData) {
                      LeaveBalancedata =
                          LeaveBalancesnapshot.data!.LeaveBalancedata_list;
                      Leave_Category = [
                        for (int i = LeaveBalancedata.length - 1; i >= 0; i--)
                          LeaveBalancedata[i].LeaveName
                      ].reversed.toList();
                      Acadamic_Year = [
                        for (int i = Active_Acadamic_Year.length - 1;
                            i >= 0;
                            i--)
                          LeaveBalancedata[i].acadYear
                      ];
                      Type_Id = [
                        for (int i = LeaveBalancedata.length - 1; i >= 0; i--)
                          "${LeaveBalancedata[i].Typeid}"
                      ].reversed.toList();

                      Active_Acadamic_Year = [LeaveBalancedata[0].acadYear];
                      if (LeaveBalancedata.length > 0) {
                        return FutureBuilder(
                            future: FacultyorHOD_Api_Data,
                            builder: (context,
                                AsyncSnapshot<FacultyorHod_List>
                                    HodorFacultysnapshot) {
                              if (HodorFacultysnapshot.hasError) {
                                ErrorShowingWidget(context);
                              }
                              List<FacultyorHod_Data> Facultyorhod;
                              if (HodorFacultysnapshot.hasData) {
                                Facultyorhod =
                                    HodorFacultysnapshot.data!.Staff_List;
                                if (Facultyorhod.length > 0) {
                                  return Scaffold(
                                      body: Container(
                                        margin: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: Column(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height:
                                                        sHeight(1.5, context),
                                                  ),
                                                  const Text(
                                                    "APPLYING FOR :",
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  SizedBox(
                                                    height: sHeight(1, context),
                                                  ),
                                                  Container(
                                                    height: sHeight(5, context),
                                                    width: sWidth(95, context),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(7),
                                                        color: Colors.white),
                                                    child: FormField<String>(
                                                      builder: (FormFieldState<
                                                              String>
                                                          state) {
                                                        return DropdownButtonHideUnderline(
                                                          child: DropdownSearch<
                                                              String>(
                                                            popupProps:
                                                                const PopupProps
                                                                    .menu(),
                                                            dropdownDecoratorProps:
                                                                const DropDownDecoratorProps(),
                                                            dropdownButtonProps:
                                                                const DropdownButtonProps(
                                                                    // padding: EdgeInsets.symmetric(horizontal: 20.0),
                                                                    icon: Icon(Icons
                                                                        .arrow_drop_down_circle_rounded),
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            255,
                                                                            98,
                                                                            118,
                                                                            1)),
                                                            items:
                                                                Leave_Category,
                                                            selectedItem:
                                                                "Select Catergory",
                                                            onChanged: (value) {
                                                              int passingLeave =
                                                                  Leave_Category
                                                                          .indexOf(
                                                                              value.toString())
                                                                      .toInt();
                                                              Type_id = Type_Id[
                                                                      passingLeave]
                                                                  .toString();
                                                              print(Type_id);
                                                            },
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              /*Row(
                                                children: [
                                                  SizedBox(
                                                    height: sHeight(2, context),
                                                    child: const Text(
                                                      "* Permission will be Consider for one hour",
                                                      style: TextStyle(color: Colors.red,fontSize: 10,),textAlign: TextAlign.left,
                                                    ),
                                                  ),
                                                ],
                                              ),*/
                                              SizedBox(
                                                height: sHeight(1, context),
                                              ),
                                              Column(
                                                children: [
                                                  Container(
                                                    width: sWidth(95, context),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(7),
                                                        color: Colors.white),
                                                    child: Container(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            height: sHeight(
                                                                1, context),
                                                          ),
                                                          const Text(
                                                            "LEAVE DURATION : ",
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Checkbox(
                                                                          value:
                                                                              checkboxValue1,
                                                                          onChanged:
                                                                              (value) {
                                                                            setState(() {
                                                                              checkboxValue1 = value!;
                                                                              OneDay_Select = true;
                                                                              checkboxValue2 = false;
                                                                              Multiday_select = false;
                                                                            });
                                                                          },
                                                                          activeColor: const Color.fromRGBO(
                                                                              255,
                                                                              98,
                                                                              118,
                                                                              1),
                                                                        ),
                                                                        const Text(
                                                                          "ONE SESSION",
                                                                          style: TextStyle(
                                                                              fontSize: 11,
                                                                              color: Color.fromRGBO(31, 16, 148, 1.0),
                                                                              fontWeight: FontWeight.w600),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        Checkbox(
                                                                          value:
                                                                              checkboxValue2,
                                                                          onChanged:
                                                                              (value) {
                                                                            setState(() {
                                                                              checkboxValue2 = value!;
                                                                              checkboxValue1 = false;
                                                                              Multiday_select = true;
                                                                              OneDay_Select = false;
                                                                            });
                                                                          },
                                                                          activeColor: const Color.fromRGBO(
                                                                              255,
                                                                              98,
                                                                              118,
                                                                              1),
                                                                        ),
                                                                        const Text(
                                                                          "MULTIPLE SESSION/DAY",
                                                                          style: TextStyle(
                                                                              fontSize: 10,
                                                                              color: Color.fromRGBO(31, 16, 148, 1.0),
                                                                              fontWeight: FontWeight.w600),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                                OneDay_Select ==
                                                                        true
                                                                    ? Column(
                                                                        children: [
                                                                          Container(
                                                                            width:
                                                                                sWidth(95, context),
                                                                            decoration:
                                                                                BoxDecoration(borderRadius: BorderRadius.circular(7), color: Colors.white),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      const Text(
                                                                                        "FROM DATE : ",
                                                                                        style: TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.w600),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        height: sHeight(0.7, context),
                                                                                      ),
                                                                                      Container(
                                                                                        height: 40,
                                                                                        width: 150,
                                                                                        decoration: BoxDecoration(
                                                                                          border: Border.all(color: Colors.black),
                                                                                          borderRadius: const BorderRadius.all(
                                                                                            Radius.circular(7),
                                                                                          ),
                                                                                        ),
                                                                                        child: Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                          children: [
                                                                                            LeaveFromDate == null ? const Text("Select") : Text("$LeaveFromDate"),
                                                                                            IconButton(
                                                                                              onPressed: () async {
                                                                                                showDatePicker(
                                                                                                  context: context,
                                                                                                  initialDate: DateTime.now(),
                                                                                                  firstDate: DateTime.now(),
                                                                                                  lastDate: DateTime(2100),
                                                                                                ).then((value) async {
                                                                                                  LeaveFromDate = DateFormat('dd/MM/yyyy').format(value!);
                                                                                                  if (checkboxValue1 == true) {
                                                                                                    LeaveFromDate = DateFormat('dd/MM/yyyy').format(value);
                                                                                                    LeaveTODate = DateFormat('dd/MM/yyyy').format(value);
                                                                                                    From_To_Pass = value;
                                                                                                  }
                                                                                                  setState(() {});
                                                                                                });
                                                                                              },
                                                                                              icon: const Icon(Icons.calendar_month, color: Color.fromRGBO(255, 98, 118, 1)),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        height: sHeight(2, context),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      const Text(
                                                                                        "SESSION : ",
                                                                                        style: TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.w600),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        height: sHeight(0.7, context),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        height: 40,
                                                                                        width: 150,
                                                                                        child: FormField<String>(
                                                                                          builder: (FormFieldState<String> state) {
                                                                                            return DropdownButtonHideUnderline(
                                                                                              child: DropdownSearch<String>(
                                                                                                popupProps: const PopupProps.menu(),
                                                                                                dropdownDecoratorProps: const DropDownDecoratorProps(),
                                                                                                dropdownButtonProps: const DropdownButtonProps(
                                                                                                    // padding: EdgeInsets.symmetric(horizontal: 20.0),
                                                                                                    icon: Icon(Icons.arrow_drop_down_circle_rounded),
                                                                                                    color: Color.fromRGBO(255, 98, 118, 1)),
                                                                                                items: Session_Type_FRom,
                                                                                                selectedItem: 'SESSION',
                                                                                                onChanged: (value) {
                                                                                                  if (value.toString() == 'FN'.toString()) {
                                                                                                    One_Fn = 19.toInt();
                                                                                                    One_An = -1;
                                                                                                    //One_Both = -1;
                                                                                                    print(One_Fn);
                                                                                                  }
                                                                                                  if (value.toString() == 'AN'.toString()) {
                                                                                                    One_An = 20.toInt();
                                                                                                    One_Fn = -1;
                                                                                                    //One_Both = -1;
                                                                                                    print(One_An);
                                                                                                  }
                                                                                                  /*if (value.toString() == 'BOTH'.toString()) {
                                                                                                    One_Both = 0.toInt();
                                                                                                    One_Fn = -1;
                                                                                                    One_An = -1;
                                                                                                  }*/
                                                                                                },
                                                                                              ),
                                                                                            );
                                                                                          },
                                                                                        ),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        height: sHeight(2, context),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      )
                                                                    : new Container(),
                                                                Multiday_select ==
                                                                        true
                                                                    ? Column(
                                                                        children: [
                                                                          Container(
                                                                            width:
                                                                                sWidth(95, context),
                                                                            decoration:
                                                                                BoxDecoration(borderRadius: BorderRadius.circular(7), color: Colors.white),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      const Text(
                                                                                        "FROM DATE : ",
                                                                                        style: TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.w600),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        height: sHeight(0.7, context),
                                                                                      ),
                                                                                      Container(
                                                                                        height: 40,
                                                                                        width: 150,
                                                                                        decoration: BoxDecoration(
                                                                                          border: Border.all(color: Colors.black),
                                                                                          borderRadius: const BorderRadius.all(
                                                                                            Radius.circular(7),
                                                                                          ),
                                                                                        ),
                                                                                        child: Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                          children: [
                                                                                            Multi_From_Date == null ? const Text("Select") : Text("$Multi_From_Date"),
                                                                                            IconButton(
                                                                                              onPressed: () async {
                                                                                                showDatePicker(
                                                                                                  context: context,
                                                                                                  initialDate: DateTime.now(),
                                                                                                  firstDate: DateTime.now(),
                                                                                                  lastDate: DateTime(2100),
                                                                                                ).then((value) async {
                                                                                                  Multi_From_Date = DateFormat('dd/MM/yyyy').format(value!);
                                                                                                  Add_Date = value;

                                                                                                  setState(() {});
                                                                                                });
                                                                                              },
                                                                                              icon: const Icon(Icons.calendar_month, color: Color.fromRGBO(255, 98, 118, 1)),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        height: sHeight(2, context),
                                                                                      ),
                                                                                      Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          const Text(
                                                                                            "TO DATE:",
                                                                                            style: TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.w600),
                                                                                          ),
                                                                                          SizedBox(
                                                                                            height: sHeight(0.7, context),
                                                                                          ),
                                                                                          Container(
                                                                                            height: 40,
                                                                                            width: 150,
                                                                                            decoration: BoxDecoration(
                                                                                              border: Border.all(color: Colors.black),
                                                                                              borderRadius: const BorderRadius.all(
                                                                                                Radius.circular(7),
                                                                                              ),
                                                                                            ),
                                                                                            child: Row(
                                                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                              children: [
                                                                                                Multi_TO_Date == null ? const Text("Select") : Text("$Multi_TO_Date"),
                                                                                                IconButton(
                                                                                                  onPressed: () async {
                                                                                                    showDatePicker(
                                                                                                      context: context,
                                                                                                      initialDate: DateTime.parse(Add_Date.toString()).add(const Duration(days: 0)),
                                                                                                      firstDate: DateTime.parse(Add_Date.toString()).add(const Duration(days: 0)),
                                                                                                      lastDate: DateTime(2100),
                                                                                                    ).then((value) async {
                                                                                                      Multi_TO_Date = DateFormat('dd/MM/yyyy').format(value!);
                                                                                                      From_To_Pass = value;
                                                                                                      setState(() {});
                                                                                                    });
                                                                                                  },
                                                                                                  icon: const Icon(Icons.calendar_month, color: Color.fromRGBO(255, 98, 118, 1)),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      const Text(
                                                                                        "SESSION : ",
                                                                                        style: TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.w600),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        height: sHeight(0.7, context),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        height: 40,
                                                                                        width: 150,
                                                                                        child: FormField<String>(
                                                                                          builder: (FormFieldState<String> state) {
                                                                                            return DropdownButtonHideUnderline(
                                                                                              child: DropdownSearch<String>(
                                                                                                popupProps: const PopupProps.menu(),
                                                                                                dropdownDecoratorProps: const DropDownDecoratorProps(),
                                                                                                dropdownButtonProps: const DropdownButtonProps(
                                                                                                    // padding: EdgeInsets.symmetric(horizontal: 20.0),
                                                                                                    icon: Icon(Icons.arrow_drop_down_circle_rounded),
                                                                                                    color: Color.fromRGBO(255, 98, 118, 1)),
                                                                                                items: Session_Type_FRom,
                                                                                                selectedItem: 'SESSION',
                                                                                                onChanged: (value) {
                                                                                                  if (value.toString() == 'FN'.toString()) {
                                                                                                    Multi_From_FN = 19.toInt();
                                                                                                    Multi_From_AN = -1;
                                                                                                    //Multi_From_Both = -1;
                                                                                                  }
                                                                                                  if (value.toString() == 'AN'.toString()) {
                                                                                                    Multi_From_AN = 20.toInt();
                                                                                                    Multi_From_FN = -1;
                                                                                                    // Multi_From_Both = -1;
                                                                                                  }
                                                                                                  /*if (value.toString() == 'BOTH'.toString()) {
                                                                                                    Multi_From_Both = 0.toInt();
                                                                                                    Multi_From_AN = -1;
                                                                                                    Multi_From_FN = -1;
                                                                                                  }*/
                                                                                                },
                                                                                              ),
                                                                                            );
                                                                                          },
                                                                                        ),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        height: sHeight(2, context),
                                                                                      ),
                                                                                      Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          const Text(
                                                                                            "SESSION : ",
                                                                                            style: TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.w600),
                                                                                          ),
                                                                                          SizedBox(
                                                                                            height: sHeight(0.7, context),
                                                                                          ),
                                                                                          SizedBox(
                                                                                            height: 40,
                                                                                            width: 150,
                                                                                            child: FormField<String>(
                                                                                              builder: (FormFieldState<String> state) {
                                                                                                return DropdownButtonHideUnderline(
                                                                                                  child: DropdownSearch<String>(
                                                                                                    popupProps: const PopupProps.menu(),
                                                                                                    dropdownDecoratorProps: const DropDownDecoratorProps(),
                                                                                                    dropdownButtonProps: const DropdownButtonProps(
                                                                                                        // padding: EdgeInsets.symmetric(horizontal: 20.0),
                                                                                                        icon: Icon(Icons.arrow_drop_down_circle_rounded),
                                                                                                        color: Color.fromRGBO(255, 98, 118, 1)),
                                                                                                    items: Session_Type_TO,
                                                                                                    selectedItem: 'SESSION',
                                                                                                    onChanged: (value) {
                                                                                                      if (value.toString() == 'FN'.toString()) {
                                                                                                        Multi_TO_FN = 19.toInt();
                                                                                                        Multi_TO_AN = -1;
                                                                                                        // Multi_TO_Both = -1;
                                                                                                      }
                                                                                                      if (value.toString() == 'AN'.toString()) {
                                                                                                        Multi_TO_AN = 20.toInt();
                                                                                                        Multi_TO_FN = -1;
                                                                                                        // Multi_TO_Both = -1;
                                                                                                      }
                                                                                                      /*if (value.toString() == 'BOTH'.toString()) {
                                                                                                        Multi_TO_Both = 0.toInt();
                                                                                                        Multi_TO_AN = -1;
                                                                                                        Multi_TO_FN = -1;
                                                                                                      }*/
                                                                                                    },
                                                                                                  ),
                                                                                                );
                                                                                              },
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      )
                                                                    : new Container(),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        height: sHeight(
                                                            1.5, context),
                                                      ),
                                                      const Text(
                                                        "REASON TYPE :",
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      SizedBox(
                                                        height:
                                                            sHeight(1, context),
                                                      ),
                                                      Container(
                                                        width:
                                                            sWidth(95, context),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        7),
                                                            color:
                                                                Colors.white),
                                                        child: Form(
                                                          key: _ReasonValid,
                                                          child: TextFormField(
                                                            controller:
                                                                Addreason,
                                                            cursorColor:
                                                                Colors.black,
                                                            inputFormatters: [
                                                              FilteringTextInputFormatter
                                                                  .deny(RegExp(
                                                                      r'^\s')),
                                                            ],
                                                            validator: (e) {
                                                              if (e!.isEmpty) {
                                                                return "Kindly Enter the Reason Type";
                                                              }
                                                              return null;
                                                            },
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.9)),
                                                            decoration:
                                                                InputDecoration(
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                horizontal: 5.0,
                                                              ),
                                                              labelStyle: TextStyle(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.9),
                                                                  fontSize: 10),
                                                              border: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              7.0),
                                                                  borderSide:
                                                                      const BorderSide(
                                                                          width:
                                                                              5,
                                                                          style:
                                                                              BorderStyle.none)),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        height: sHeight(
                                                            1.5, context),
                                                      ),
                                                      const Text(
                                                        "FORWARD LEAVE REQUEST TO:",
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      SizedBox(
                                                        height:
                                                            sHeight(1, context),
                                                      ),
                                                      Container(
                                                        width:
                                                            sWidth(95, context),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        7),
                                                            color:
                                                                Colors.white),
                                                        child:
                                                            FormField<String>(
                                                          builder:
                                                              (FormFieldState<
                                                                      String>
                                                                  state) {
                                                            return DropdownButtonHideUnderline(
                                                              child:
                                                                  DropdownSearch<
                                                                      String>(
                                                                popupProps:
                                                                    const PopupProps
                                                                        .menu(),
                                                                dropdownDecoratorProps:
                                                                    const DropDownDecoratorProps(),
                                                                dropdownButtonProps:
                                                                    const DropdownButtonProps(
                                                                        // padding: EdgeInsets.symmetric(horizontal: 20.0),
                                                                        icon: Icon(Icons
                                                                            .arrow_drop_down_circle_rounded),
                                                                        color: Color.fromRGBO(
                                                                            255,
                                                                            98,
                                                                            118,
                                                                            1)),
                                                                items: hodFindApiData
                                                                            .length ==
                                                                        0
                                                                    ? RecordType
                                                                    : HOD_Staff_List,
                                                                selectedItem:
                                                                    "Select HOD or Principal ",
                                                                //? "Not Specified" : HOD_Staff_List[0],
                                                                onChanged:
                                                                    (value) {
                                                                  int passingClub =
                                                                      HOD_Staff_List.indexOf(
                                                                              value.toString())
                                                                          .toInt();
                                                                  HOD_ID = HOD_Staff_Id[
                                                                      passingClub
                                                                          .toInt()];
                                                                  print(HOD_ID);
                                                                },
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        sHeight(2.5, context),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      bottomNavigationBar: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 50,
                                        margin: const EdgeInsets.fromLTRB(
                                            40, 10, 40, 20),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            for (int i = 0; i < Facultyorhod.length; i++) {
                                              if (Facultyorhod[i].lawah == 0) {
                                                if (checkboxValue1 == true) {
                                                  if (Type_id == null ||
                                                      HOD_ID == null ||
                                                      LeaveFromDate == null ||
                                                      One_An == 1 ||
                                                      One_Fn == 1) {
                                                    await Fluttertoast
                                                        .showToast(
                                                        backgroundColor:
                                                        Colors.red,
                                                        msg:
                                                        "Kindly! Enter Required Details",
                                                        toastLength:
                                                        Toast.LENGTH_SHORT,
                                                        gravity: ToastGravity
                                                            .SNACKBAR,
                                                        textColor: Colors.white,
                                                        fontSize: 16.0);
                                                  } else {
                                                    await showDialog(
                                                        context: context,
                                                        barrierDismissible:
                                                            true,
                                                        builder: (context) =>
                                                            AlertDialog(
                                                                content:
                                                                    SizedBox(
                                                              height: sHeight(
                                                                  15, context),
                                                              width: sWidth(
                                                                  60, context),
                                                              child: Column(
                                                                children: [
                                                                  const Text(
                                                                      "Do you want to Apply Leave?"),
                                                                  SizedBox(
                                                                    height: sHeight(
                                                                        5,
                                                                        context),
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      InkWell(
                                                                        child:
                                                                            Container(
                                                                          height: sHeight(
                                                                              5,
                                                                              context),
                                                                          width: sWidth(
                                                                              17,
                                                                              context),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                            color:
                                                                                Colors.red,
                                                                          ),
                                                                          child: Center(
                                                                              child: Text(
                                                                            "NO",
                                                                            style:
                                                                                ErrorText(),
                                                                          )),
                                                                        ),
                                                                        onTap:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                      ),
                                                                      InkWell(
                                                                        child:
                                                                            Container(
                                                                          height: sHeight(
                                                                              5,
                                                                              context),
                                                                          width: sWidth(
                                                                              17,
                                                                              context),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                            color:
                                                                                Colors.green,
                                                                          ),
                                                                          child: Center(
                                                                              child: Text(
                                                                            "Yes",
                                                                            style:
                                                                                ErrorText(),
                                                                          )),
                                                                        ),
                                                                        onTap:
                                                                            () async {
                                                                          if (checkboxValue1 ==
                                                                              true) {
                                                                            print(Addreason);
                                                                            Date_Validation1();
                                                                          }
                                                                          if (Multiday_select ==
                                                                              true) {
                                                                            MultipleDay_Date_validation1();
                                                                          }
                                                                          Navigator.pop(context);
                                                                          Navigator.pop(context);
                                                                          Navigator.pop(context);
                                                                          Navigator.push(context, MaterialPageRoute(builder: (context)=> ApplyScreen
                                                                            (username: widget.username, password: widget.password,)));
                                                                        },
                                                                      )
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            )));
                                                  }
                                                }
                                                if (Multiday_select == true) {
                                                  if (Type_id == null ||
                                                      HOD_ID == null ||
                                                      Multi_From_Date == null ||
                                                      Multi_TO_Date == null ||
                                                      Multi_From_AN == 1 ||
                                                      Multi_From_FN == 1 ||
                                                      Multi_TO_AN == 1 ||
                                                      Multi_TO_FN == 1) {
                                                    await Fluttertoast.showToast(
                                                        backgroundColor:
                                                            Colors.red,
                                                        timeInSecForIosWeb: 3,
                                                        msg:
                                                            "Kindly! Enter Required Details",
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity: ToastGravity
                                                            .SNACKBAR,
                                                        textColor: Colors.white,
                                                        fontSize: 16.0);
                                                  } else {
                                                    showDialog(
                                                        context: context,
                                                        barrierDismissible:
                                                            true,
                                                        builder: (context) =>
                                                            AlertDialog(
                                                                content:
                                                                    SizedBox(
                                                              height: sHeight(
                                                                  15, context),
                                                              width: sWidth(
                                                                  60, context),
                                                              child: Column(
                                                                children: [
                                                                  const Text(
                                                                      "Do you want to Apply Leave?"),
                                                                  SizedBox(
                                                                    height: sHeight(
                                                                        5,
                                                                        context),
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      InkWell(
                                                                        child:
                                                                            Container(
                                                                          height: sHeight(
                                                                              5,
                                                                              context),
                                                                          width: sWidth(
                                                                              17,
                                                                              context),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                            color:
                                                                                Colors.red,
                                                                          ),
                                                                          child: Center(
                                                                              child: Text(
                                                                            "NO",
                                                                            style:
                                                                                ErrorText(),
                                                                          )),
                                                                        ),
                                                                        onTap:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                      ),
                                                                      InkWell(
                                                                        child:
                                                                            Container(
                                                                          height: sHeight(
                                                                              5,
                                                                              context),
                                                                          width: sWidth(
                                                                              17,
                                                                              context),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                            color:
                                                                                Colors.green,
                                                                          ),
                                                                          child: Center(
                                                                              child: Text(
                                                                            "Yes",
                                                                            style:
                                                                                ErrorText(),
                                                                          )),
                                                                        ),
                                                                        onTap:
                                                                            () async {
                                                                          await MultipleDay_Date_validation1();
                                                                          Navigator.pop(
                                                                              context);
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                      )
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            )));
                                                  }
                                                }
                                              }
                                              else {
                                                  if (checkboxValue1 == true) {
                                                    if (Type_id == null ||
                                                        HOD_ID == null ||
                                                        LeaveFromDate == null ||
                                                        One_An == 1 ||
                                                        One_Fn == 1) {
                                                      await Fluttertoast.showToast(
                                                          backgroundColor:
                                                              Colors.red,
                                                          msg:
                                                              "Kindly! Enter Required Details",
                                                          toastLength: Toast
                                                              .LENGTH_SHORT,
                                                          gravity: ToastGravity
                                                              .SNACKBAR,
                                                          textColor:
                                                              Colors.white,
                                                          fontSize: 16.0);
                                                    } else {
                                                      await showDialog(
                                                          context: context,
                                                          barrierDismissible:
                                                              true,
                                                          builder: (context) =>
                                                              AlertDialog(
                                                                  content:
                                                                      SizedBox(
                                                                height: sHeight(
                                                                    15,
                                                                    context),
                                                                width: sWidth(
                                                                    60,
                                                                    context),
                                                                child: Column(
                                                                  children: [
                                                                    const Text(
                                                                        " Send Alternative.  "),
                                                                    SizedBox(
                                                                      height: sHeight(
                                                                          5,
                                                                          context),
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        InkWell(
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                sHeight(5, context),
                                                                            width:
                                                                                sWidth(17, context),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                              color: Colors.red,
                                                                            ),
                                                                            child: Center(
                                                                                child: Text(
                                                                              "NO",
                                                                              style: ErrorText(),
                                                                            )),
                                                                          ),
                                                                          onTap:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                        ),
                                                                        InkWell(
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                sHeight(5, context),
                                                                            width:
                                                                                sWidth(17, context),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                              color: Colors.green,
                                                                            ),
                                                                            child: Center(
                                                                                child: Text(
                                                                              "Yes",
                                                                              style: ErrorText(),
                                                                            )),
                                                                          ),
                                                                          onTap:
                                                                              () async {
                                                                            await Reason_Leave_valid();
                                                                          },
                                                                        )
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              )));
                                                    }
                                                  }
                                                  else {
                                                    if (Multiday_select == true) {
                                                      if (Type_id == null ||
                                                          HOD_ID == null ||
                                                          Multi_From_Date == null ||
                                                          Multi_TO_Date == null ||
                                                          Multi_From_AN == 1 ||
                                                          Multi_From_FN == 1 ||
                                                          Multi_TO_AN == 1 ||
                                                          Multi_TO_FN == 1) {
                                                        await Fluttertoast.showToast(
                                                            backgroundColor:
                                                                Colors.red,
                                                            timeInSecForIosWeb:
                                                                3,
                                                            msg:
                                                                "Kindly! Enter Required Details",
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                ToastGravity
                                                                    .SNACKBAR,
                                                            textColor:
                                                                Colors.white,
                                                            fontSize: 16.0);
                                                      } else {
                                                        showDialog(
                                                            context: context,
                                                            barrierDismissible:
                                                                true,
                                                            builder: (context) =>
                                                                AlertDialog(
                                                                    content:
                                                                        SizedBox(
                                                                  height: sHeight(
                                                                      15,
                                                                      context),
                                                                  width: sWidth(
                                                                      60,
                                                                      context),
                                                                  child: Column(
                                                                    children: [
                                                                      const Text(
                                                                          "Send Alternative. "),
                                                                      SizedBox(
                                                                        height: sHeight(
                                                                            5,
                                                                            context),
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          InkWell(
                                                                            child:
                                                                                Container(
                                                                              height: sHeight(5, context),
                                                                              width: sWidth(17, context),
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(10),
                                                                                color: Colors.red,
                                                                              ),
                                                                              child: Center(
                                                                                  child: Text(
                                                                                "NO",
                                                                                style: ErrorText(),
                                                                              )),
                                                                            ),
                                                                            onTap:
                                                                                () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                          ),
                                                                          InkWell(
                                                                            child:
                                                                                Container(
                                                                              height: sHeight(5, context),
                                                                              width: sWidth(17, context),
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(10),
                                                                                color: Colors.green,
                                                                              ),
                                                                              child: Center(
                                                                                  child: Text(
                                                                                "Yes",
                                                                                style: ErrorText(),
                                                                              )),
                                                                            ),
                                                                            onTap:
                                                                                () async {
                                                                                 await Reason_Leave_valid();
                                                                            },
                                                                          )
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                )));
                                                      }
                                                    }
                                                  }
                                                }
                                            }
                                            //Navigator.pop(context);
                                          },
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty
                                                      .resolveWith((states) {
                                                if (states.contains(
                                                    MaterialState.pressed)) {
                                                  return const Color.fromRGBO(
                                                      255, 52, 62, 1);
                                                }
                                                return const Color.fromRGBO(
                                                    255, 52, 62, 1);
                                              }),
                                              shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)))),
                                          child: const Text(
                                            'APPLY FOR LEAVE',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ));
                                } else {
                                  return Container(
                                    color: Colors.white,
                                    child: Center(
                                        child: SearchingDataLottie(context)),
                                  );
                                }
                              } else {
                                return Container(
                                  color: Colors.white,
                                  child: Center(
                                      child: SearchingDataLottie(context)),
                                );
                              }
                            });
                      } else {
                        return Scaffold(
                          body: Builder(
                              builder: (BuildContext context) => ListView(
                                    scrollDirection: Axis.vertical,
                                    children: <Widget>[
                                      Image.asset(
                                        'images/Dataimg/data_not_found.png',
                                      )
                                    ],
                                  )),
                        );
                      }
                    } else {
                      return Container(
                        color: Colors.white,
                        child: Center(child: SearchingDataLottie(context)),
                      );
                    }
                  });
            } else {
              return Container(
                color: Colors.white,
                child: Center(child: SearchingDataLottie(context)),
              );
            }
          }),
    );
  }
}

//Staff Leave apply alternate Hours list
class Staff_Leave_Apply_Alter_List extends StatefulWidget {
  const Staff_Leave_Apply_Alter_List(
      {Key? key,
      required this.username,
      required this.password,
      required this.fromdateuh,
      required this.Reason,
      required this.Hodid,
      required this.Typeid,
      required this.TOdateuh,
      required this.FromSesion,
      required this.TOSessin,
      required this.F_T_M})
      : super(key: key);
  final String username;
  final String password;
  final String fromdateuh;
  final String Reason;
  final String Hodid;
  final String Typeid;
  final String TOdateuh;
  final int FromSesion;
  final int TOSessin;
  final DateTime F_T_M;

  @override
  State<Staff_Leave_Apply_Alter_List> createState() =>
      _Staff_Leave_Apply_Alter_ListState();
}

class _Staff_Leave_Apply_Alter_ListState
    extends State<Staff_Leave_Apply_Alter_List> {
  late Future<Staff_Alter_Hours_Data_List> Staff_Alter_Hours_API_Data;
  bool checkboxValue1 = false;
  bool isChecked = false;
  int? selectedIndexID;
  int requestCount = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Staff_Alter_Hours_Network staffAlterHoursNetwork = Staff_Alter_Hours_Network(
        "StaffAlternateHour?StaffCode=${widget.username}&FromDate=${widget.fromdateuh}&FrSess=${widget.FromSesion.toInt()}&ToDate=${widget.TOdateuh}&ToSess=${widget.TOSessin.toInt()}&Password=${widget.password}"
        );
    //19 fn session 20 AN session
    Staff_Alter_Hours_API_Data =
        staffAlterHoursNetwork.Staff_Alter_Hours_loadData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Staff_Alter_Hours_API_Data,
        builder: (context,
            AsyncSnapshot<Staff_Alter_Hours_Data_List> AlterHoursnapshot) {
          if (AlterHoursnapshot.hasError) {
            ErrorShowingWidget(context);
          }
          List<Staff_Alter_Hours_Data> alterHours;
          if (AlterHoursnapshot.hasData) {
            alterHours = AlterHoursnapshot.data!.S_A_H_list;
            // print(selectedIndexID);
            if (alterHours.length > 0) {
              return Scaffold(
                backgroundColor: const Color.fromRGBO(242, 249, 250, 0.9),
                appBar: AppBar(
                  title: Text(
                    "Alternate Hours List",
                    style: PrimaryText(context),
                  ),
                  centerTitle: true,
                  backgroundColor: const Color.fromRGBO(255, 98, 118, 1),
                  elevation: 20.0,
                ),
                body: Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        SizedBox(
                          height: sHeight(1, context),
                        ),
                        for (int i = 0; i < alterHours.length; i++)
                          Column(
                            children: [
                              SizedBox(
                                height: sHeight(2, context),
                              ),
                              Container(
                                padding: const EdgeInsets.only(left: 10, right: 10),
                                width: sWidth(95, context),
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: sHeight(1, context),
                                    ),
                                    const Text(
                                      "Subject Name",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black45),
                                    ),
                                    SizedBox(
                                      height: sHeight(1, context),
                                    ),
                                    Text(
                                      alterHours[i].subjectplan,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w900,
                                      ),
                                      maxLines: 3,
                                    ),
                                    SizedBox(
                                      height: sHeight(1, context),
                                    ),
                                    Text(
                                      alterHours[i].classfullname,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    SizedBox(
                                      height: sHeight(1, context),
                                    ),
                                    const Divider(
                                      thickness: 0.5,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Date : ${alterHours[i].date}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black54),
                                        ),
                                        SizedBox(
                                          width: sWidth(40, context),
                                        ),
                                        alterHours[i].rqst == 1 ?
                                        Container():
                                        Checkbox(
                                          value: selectedIndexID ==
                                              alterHours[i].id,
                                          onChanged: (value) {
                                            setState(() {
                                              if (selectedIndexID ==
                                                  alterHours[i].id) {
                                                selectedIndexID = null;
                                                print("1$selectedIndexID");
                                              } else {
                                                selectedIndexID =
                                                    alterHours[i].id;
                                                print("2---$selectedIndexID");
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Staff_Alternate_Dialogbox(
                                                              fromID:
                                                                  selectedIndexID
                                                                      .toString(),
                                                              username: widget
                                                                  .username,
                                                              password: widget
                                                                  .password,
                                                              Future_Date_one:
                                                                  widget.F_T_M,
                                                              fromdateuh: widget
                                                                  .fromdateuh,
                                                              TOdateuh: widget
                                                                  .TOdateuh,
                                                              FromSesion: widget
                                                                  .FromSesion,
                                                              TOSessin: widget.TOSessin,
                                                              Reason: widget.Reason,
                                                              Typeid: widget.Typeid,
                                                              Hodid: widget.Hodid,
                                                            )));
                                              }
                                            });
                                          },
                                          activeColor:
                                              const Color.fromRGBO(255, 98, 118, 1),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Hour : ${alterHours[i].hour}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black54),
                                        ),
                                        alterHours[i].rqst == 1
                                            ? const Text(
                                                "Request Sent Successfully",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.green),
                                              )
                                            : const Text(
                                                "Request not Sent",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.red),
                                              ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: sHeight(2.5, context),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        SizedBox(
                          height: sHeight(3, context),
                        ),
                      ],
                    ),
                  ),
                ),
                bottomNavigationBar: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    margin: const EdgeInsets.fromLTRB(40, 10, 40, 20),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(30)),
                    child: ElevatedButton(onPressed: ()
                    //int requestCount = 0;

                    async{
                      for (int i = alterHours.length - 1; i >= 0; i--)
                        {
                          if(alterHours[i].rqst == 0) {
                            requestCount += 1;
                          }
                          else {
                            await Fluttertoast.showToast(
                                backgroundColor: Colors.red,
                                msg: "kindly! Send an alternative to the class ",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.SNACKBAR,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        /*  if(alterHours[i].rqst == requestCount){
                           await Fluttertoast.showToast(
                                backgroundColor: Colors.red,
                                msg: "kindly! Send a Alternative the class ",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.SNACKBAR,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                          else {
                              final resp = await http.get(Uri.parse("http://$StaticIP/api/StaffLeaveApply?StaffCode=${widget.username}&leaveFrom=${widget.fromdateuh}&leaveTill=${widget.TOdateuh }&reason=${widget.Reason}&leaveTypeId=${widget.Typeid}&forwardedPers1=${widget.Hodid}&frSessionId=${widget.FromSesion}&toSessionId=${widget.TOSessin}&Password=${widget.password}"),);
                              print("http://$StaticIP/api/StaffLeaveApply?StaffCode=${widget.username}&leaveFrom=${widget.fromdateuh}&leaveTill=${widget.TOdateuh }&reason=${widget.Reason}&leaveTypeId=${widget.Typeid}&forwardedPers1=${widget.Hodid}&frSessionId=${widget.FromSesion}&toSessionId=${widget.TOSessin}&Password=${widget.password}");
                              if (resp.statusCode == 200) {
                                await Fluttertoast.showToast(
                                    backgroundColor: Colors.green,
                                    msg: "Your Request been Send Successfully!",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.SNACKBAR,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                );
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> ApplyScreen
                                  (username: widget.username, password: widget.password,)));
                              } else {
                                // print('Request failed with status: ${resp.statusCode}.');
                                await Fluttertoast.showToast(
                                    backgroundColor: Colors.red,
                                    msg: "Send alternative for all classes ",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.SNACKBAR,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                );
                              }
                              // Navigator.pop(context, _selectedItems);
                          }*/
                        }
                      if(requestCount == 0){
                          /*for (int i = alterHours.length - 1; i >= 0; i--)
                          {*/
                            final resp = await http.get(Uri.parse("http://$StaticIP/api/StaffLeaveApply?StaffCode=${widget.username}&leaveFrom=${widget.fromdateuh}&leaveTill=${widget.TOdateuh }&reason=${widget.Reason}&leaveTypeId=${widget.Typeid}&forwardedPers1=${widget.Hodid}&frSessionId=${widget.FromSesion}&toSessionId=${widget.TOSessin}&Password=${widget.password}"),);
                            print("http://$StaticIP/api/StaffLeaveApply?StaffCode=${widget.username}&leaveFrom=${widget.fromdateuh}&leaveTill=${widget.TOdateuh }&reason=${widget.Reason}&leaveTypeId=${widget.Typeid}&forwardedPers1=${widget.Hodid}&frSessionId=${widget.FromSesion}&toSessionId=${widget.TOSessin}&Password=${widget.password}");
                            if (resp.statusCode == 200) {
                              await Fluttertoast.showToast(
                                  backgroundColor: Colors.green,
                                  msg: "Your request been sent Successfully!",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.SNACKBAR,
                                  textColor: Colors.white,
                                  fontSize: 16.0
                              );
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> ApplyScreen
                                (username: widget.username, password: widget.password,)));
                            } else {
                              // print('Request failed with status: ${resp.statusCode}.');
                              await Fluttertoast.showToast(
                                  backgroundColor: Colors.red,
                                  msg: "Send alternative for all classes ",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.SNACKBAR,
                                  textColor: Colors.white,
                                  fontSize: 16.0
                              );
                            }
                          //}
                      }
                      else
                        {
                          await Fluttertoast.showToast(
                              backgroundColor: Colors.red,
                              msg: "kindly! Send a Alternative the class ",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.SNACKBAR,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                    },
            style: ButtonStyle(
                backgroundColor:
                MaterialStateProperty
                    .resolveWith((states) {
                  if (states.contains(
                      MaterialState.pressed)) {
                    return const Color.fromRGBO(
                        255, 52, 62, 1);
                  }
                  return const Color.fromRGBO(
                      255, 52, 62, 1);
                }),
                shape: MaterialStateProperty.all<
                    RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(
                            10)))),
          child: const Text("Apply Leave"),
          )),
              );
            } else {
              return Scaffold(
                appBar: AppBar(
                  title: Text(
                    "Alternate Hours List",
                    style: PrimaryText(context),
                  ),
                  centerTitle: true,
                  backgroundColor: const Color.fromRGBO(255, 98, 118, 1),
                  elevation: 20.0,
                ),
                body: Builder(
                    builder: (BuildContext context) => ListView(
                          scrollDirection: Axis.vertical,
                          children: <Widget>[
                            Image.asset(
                              'images/Dataimg/data_not_found.png',
                            )
                          ],
                        )),
                  bottomNavigationBar: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      margin: const EdgeInsets.fromLTRB(40, 10, 40, 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30)),
                      child: ElevatedButton(
                        onPressed: () async {
                          final resp = await http.get(Uri.parse("http://$StaticIP/api/StaffLeaveApply?StaffCode=${widget.username}&leaveFrom=${widget.fromdateuh}&leaveTill=${widget.TOdateuh}&reason=${widget.Reason.toString()}&leaveTypeId=${widget.Typeid.toString()}&forwardedPers1=${widget.Hodid.toString()}&frSessionId=${widget.FromSesion.toString()}&toSessionId=${widget.TOSessin.toString()}&Password=${widget.password}"),);
                                                          print("http://$StaticIP/api/StaffLeaveApply?StaffCode=${widget.username}&leaveFrom=${widget.fromdateuh}&leaveTill=${widget.TOdateuh}&reason=${widget.Reason}&leaveTypeId=${widget.Typeid.toString()}&forwardedPers1=${widget.Hodid.toString()}&frSessionId=${widget.FromSesion.toString()}&toSessionId=${widget.TOSessin.toString()}&Password=${widget.password}");
                          if (resp.statusCode == 200) {
                            await Fluttertoast.showToast(
                                backgroundColor: Colors.green,
                                msg: "Your Request been Send Successfully!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.SNACKBAR,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> ApplyScreen
                              (username: widget.username, password: widget.password,)));
                          } else {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> ApplyScreen
                              (username: widget.username, password: widget.password,)));
                            // print('Request failed with status: ${resp.statusCode}.');
                            await Fluttertoast.showToast(
                                backgroundColor: Colors.red,
                                msg: "Your Request been Send Successfully!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.SNACKBAR,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                          }
                          //print("Nothing");
                          // Navigator.pop(context, _selectedItems);
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith((states) {
                              if (states.contains(MaterialState.pressed)) {
                                return const Color.fromRGBO(255, 52, 62, 1);
                              }
                              return const Color.fromRGBO(255, 52, 62, 1);
                            }),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)))),
                        child: const Text("Apply Leave"),
                      )));
            }
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  "Alternate Hours List",
                  style: PrimaryText(context),
                ),
                centerTitle: true,
                backgroundColor: const Color.fromRGBO(255, 98, 118, 1),
                elevation: 20.0,
              ),
              body: Container(
                color: Colors.white,
                child: Center(child: SearchingDataLottie(context)),
              ),
            );
          }
        });
  }
}

//leave Alters send Request AlertDialog
class Staff_Alternate_Dialogbox extends StatefulWidget {
  const Staff_Alternate_Dialogbox(
      {Key? key,
      required this.username,
      required this.password,
      required this.fromID,
      required this.Future_Date_one,
      required this.fromdateuh,
      required this.TOdateuh,
      required this.FromSesion,
      required this.TOSessin,
        required this.Reason,
        required this.Hodid,
        required this.Typeid,})
      : super(key: key);
  final String fromID;
  final String username;
  final String password;
  final DateTime Future_Date_one;
  final String fromdateuh;
  final String TOdateuh;
  final int FromSesion;
  final int TOSessin;
  final String Reason;
  final String Hodid;
  final String Typeid;

  @override
  State<Staff_Alternate_Dialogbox> createState() =>
      _Staff_Alternate_DialogboxState();
}

class _Staff_Alternate_DialogboxState extends State<Staff_Alternate_Dialogbox> {
  late Future<StaffAlternateHourRequest_List> Staff_Alter_Req_API_Data;
  late Future<StaffAlternateHourRequest_List>Staff_Alter_Req_API_Data_For_Future;
  late Future<Department_List_Data_List> Department_API_Data;
  late Future<Staff_List_Data_List> Staff_API_Data;
  int? selectedIndexID2;
  int? selectedIndex_Future = 0;
  String? Dept_Id = '0';
  String? Staff_ID;
  String? Department_Name;
  String? Staff_Name;
  int? Passing_Dep = 0;
  int? Passing_Staff = 0;
  bool Selected_checkBox = true;
  bool Future_checkBox = false;
  bool OtherType_checkBox = false;
  bool Future_List = false;
  String? Future_Date = '';
  String? Selected_MSG;
  String? Other_Type_MSG;
  String? Selected_MSG_Future;

  Future_Date_Functions() async {
    StaffAlternateHourRequestNetwork staffAlternateHourRequestNetwork =
        StaffAlternateHourRequestNetwork(
            "StaffAlternateHourRequest?StaffCode=${widget.username}&Password=${widget.password}&FromTimeTableId=${widget.fromID}&AlterDate=$Future_Date");
    Staff_Alter_Req_API_Data_For_Future =
        staffAlternateHourRequestNetwork.StaffAlternateHourRequestloadData();
  }

  late List Responce_Details_SelectedDate = [];
  late List Responce_OtherT_Engaged = [];
  late List Responce_Details_Future_Date = [];
  late List<String> Departments_List = [];
  late List<String> Departments_List_Check = [];
  late List<String> Staffs_List_Check = [];
  late List<String> Staffs_List = [];
  bool Show_DS_Name = false;

  Responce_Function_SelectedDate() async {
    final resp = await http.get(
      Uri.parse(
          "http://$StaticIP/api/StaffAlternateRequestSend?StaffCode=${widget.username}&FromTimetableId=${widget.fromID}&ToTimetableId=$selectedIndexID2&ReqStaffId=$Staff_ID&ChangeType=11&Password=${widget.password}"), // server login url
    );
    print("http://$StaticIP/api/StaffAlternateRequestSend?StaffCode=${widget.username}&FromTimetableId=${widget.fromID}&ToTimetableId=$selectedIndexID2&ReqStaffId=$Staff_ID&ChangeType=11&Password=${widget.password}");
    if (resp.statusCode == 200) {
      Responce_Details_SelectedDate = json.decode(resp.body);
      Selected_MSG = (Responce_Details_SelectedDate[0]['msg'].toString());
      print(Selected_MSG);
      if (Selected_MSG == "Request Already Sent.") {
        await Fluttertoast.showToast(
            backgroundColor: Colors.indigo,
            msg: "Request Already Sent to Staff",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.SNACKBAR,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pop(context);


      } else {
        await Fluttertoast.showToast(
            backgroundColor: Colors.green,
            msg: "Your Request has been sent to staff",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.SNACKBAR,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pop(context);
      }
    } else {
      await Fluttertoast.showToast(
          backgroundColor: Colors.red,
          msg: "Kindly, Click Any Alternate Class",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pop(context);


    }
  }

  Responce_Function_Future_Date() async {
    final resp = await http.get(
      Uri.parse(
          "http://$StaticIP/api/StaffAlternateRequestSend?StaffCode=${widget.username}&FromTimetableId=${widget.fromID}&ToTimetableId=$selectedIndex_Future&ReqStaffId=$Staff_ID&ChangeType=13&Password=${widget.password}"), // server login url
    );
    print("http://$StaticIP/api/StaffAlternateRequestSend?StaffCode=${widget.username}&FromTimetableId=${widget.fromID}&ToTimetableId=$selectedIndex_Future&ReqStaffId=$Staff_ID&ChangeType=13&Password=${widget.password}");
    if (resp.statusCode == 200) {
      Responce_Details_Future_Date = json.decode(resp.body);
      Selected_MSG_Future = (Responce_Details_Future_Date[0]['msg'].toString());
      print(Selected_MSG_Future);
      if (Selected_MSG_Future == "Request Already Sent.") {
        await Fluttertoast.showToast(
            backgroundColor: Colors.indigo,
            msg: "Request Already Sent to Staff",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.SNACKBAR,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pop(context);


      } else if (Selected_MSG_Future == "Request Sent successfully.") {
        await Fluttertoast.showToast(
            backgroundColor: Colors.green,
            msg: "Your Request has been sent to staff",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.SNACKBAR,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pop(context);

      }
    } else {
      await Fluttertoast.showToast(
          backgroundColor: Colors.red,
          msg: "Kindly, Click Any Alternate Class",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pop(context);

    }
  }
  Staff_Lists_Get_Function() async {
    All_Staff_Network allStaffNetwork =
        All_Staff_Network("StaffList?StaffCode=${widget.username}&Password=${widget.password}&DeptId=$Dept_Id");
    Staff_API_Data = allStaffNetwork.Staffss_loadData();
  }

  Responce_Function_OtherType_Engaged() async {
    final resp = await http.get(
      Uri.parse("http://$StaticIP/api/StaffAlterOtherType?StaffCode=${widget.username}&Password=${widget.password}&FromTimetableId=${widget.fromID}&ReqStaffId=$Staff_ID&ChangeType=14"), // server login url
    );
    print("http://$StaticIP/api/StaffAlterOtherType?StaffCode=${widget.username}&Password=${widget.password}&FromTimetableId=${widget.fromID}&ReqStaffId=$Staff_ID&ChangeType=14");
    if (resp.statusCode == 200) {
      Responce_OtherT_Engaged = json.decode(resp.body);
      Other_Type_MSG = (Responce_OtherT_Engaged[0]['msg'].toString());
      print(Other_Type_MSG);
      if (Other_Type_MSG == "Request Already Sent.") {
        await Fluttertoast.showToast(
            backgroundColor: Colors.indigo,
            msg: "Request Already Sent to Staff",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.SNACKBAR,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pop(context);
      } else {
        await Fluttertoast.showToast(
            backgroundColor: Colors.green,
            msg: "Your Request has been sent to staff",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.SNACKBAR,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pop(context);
      }
    } else {
      await Fluttertoast.showToast(
          backgroundColor: Colors.red,
          msg: "Kindly, Select Alternate Staff",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StaffAlternateHourRequestNetwork staffAlternateHourRequestNetwork = StaffAlternateHourRequestNetwork("StaffAlternateHourRequest?StaffCode=${widget.username}&Password=${widget.password}&FromTimeTableId=${widget.fromID}&AlterDate=");
    Staff_Alter_Req_API_Data = staffAlternateHourRequestNetwork.StaffAlternateHourRequestloadData();
    Future_Date_Functions();
    Staff_Lists_Get_Function();
    Department_Network departmentNetwork = Department_Network(
        "DepartmentList?StaffCode=${widget.username}&Password=${widget.password}");
    Department_API_Data = departmentNetwork.Department_loadData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Staff_Alter_Req_API_Data,
        builder: (context,
            AsyncSnapshot<StaffAlternateHourRequest_List>
                alterhourRequestsnapshot) {
          if (alterhourRequestsnapshot.hasError) {
            ErrorShowingWidget(context);
          }
          List<StaffAlternateHourRequestAPI_data> alterHoursReq;
          if (alterhourRequestsnapshot.hasData) {
            alterHoursReq =
                alterhourRequestsnapshot.data!.StaffAlternateHourrequest_List;
            return FutureBuilder(
                future: Department_API_Data,
                builder: (context,
                    AsyncSnapshot<Department_List_Data_List>
                        departmentSnapshot) {
                  if (departmentSnapshot.hasError) {
                    ErrorShowingWidget(context);
                  }
                  List<Department_List_Data> departmentData;
                  if (departmentSnapshot.hasData) {
                    departmentData = departmentSnapshot.data!.Leave_dept_list;
                    Departments_List = [
                      for (int i = departmentData.length - 1; i >= 0; i--)
                        departmentData[i].dept
                    ].reversed.toList();
                    Departments_List_Check = [
                      for (int i = departmentData.length - 1; i >= 0; i--)
                        "${departmentData[i].deptId}"
                    ].reversed.toList();
                    return FutureBuilder(
                        future: Staff_API_Data,
                        builder: (context,
                            AsyncSnapshot<Staff_List_Data_List>
                                staffsSnapshot) {
                          if (staffsSnapshot.hasError) {
                            ErrorShowingWidget(context);
                          }
                          List<Staff_List_Data> stafData;
                          if (staffsSnapshot.hasData) {
                            stafData = staffsSnapshot.data!.Leave_Sta_list;
                            Staffs_List = [
                              for (int i = stafData.length - 1; i >= 0; i--)
                                "${stafData[i].staffname} - ${stafData[i].staffcode}"
                            ].reversed.toList();
                            Staffs_List_Check = [
                              for (int i = stafData.length - 1; i >= 0; i--)
                                "${stafData[i].uid}"
                            ].reversed.toList();
                            return FutureBuilder(
                                future: Staff_Alter_Req_API_Data_For_Future,
                                builder: (context,
                                    AsyncSnapshot<
                                            StaffAlternateHourRequest_List>
                                        datesnapshot) {
                                  if (datesnapshot.hasError) {
                                    ErrorShowingWidget(context);
                                  }
                                  List<StaffAlternateHourRequestAPI_data>Alterdata;
                                  if (datesnapshot.hasData) {
                                    Alterdata = datesnapshot.data!.StaffAlternateHourrequest_List;
                                    print("sucess");
                                     if (departmentData.length > 0) {
                                      print("sucess");
                                      return WillPopScope(
                                        onWillPop: () async => _onBackButtonPressed(),
                                        child: Scaffold(
                                          /*backgroundColor: Color.fromRGBO(
                                              242, 249, 250, 0.9),*/
                                          appBar: AppBar(
                                            title: Text(
                                              "Alternate Types",
                                              style: PrimaryText(context),
                                            ),
                                            backgroundColor:
                                                const Color.fromRGBO(255, 98, 118, 1),
                                            centerTitle: true,
                                          ),
                                          body: SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: sHeight(2, context),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    margin: const EdgeInsets.only(
                                                        left: 10, right: 10),
                                                    padding: const EdgeInsets.only(
                                                        left: 10, right: 10),
                                                    width: sWidth(95, context),
                                                    decoration: const BoxDecoration(
                                                      color: Color(0xFFECFFF4),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(10),
                                                      ),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Alternate Types",
                                                              style:
                                                                  PrimaryText2(),
                                                            ),
                                                          ],
                                                        ),
                                                        const Divider(
                                                          thickness: 0.5,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Checkbox(
                                                              value:
                                                                  Selected_checkBox,
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  Selected_checkBox =
                                                                      value!;
                                                                });
                                                                Future_checkBox =
                                                                    false;
                                                                OtherType_checkBox =
                                                                    false;
                                                                Future_List =
                                                                    false;
                                                              },
                                                              activeColor: const Color
                                                                  .fromRGBO(
                                                                      255,
                                                                      98,
                                                                      118,
                                                                      1),
                                                            ),
                                                            const Text(
                                                              "Selected Date",
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Checkbox(
                                                              value:
                                                                  Future_checkBox,
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  Future_checkBox =
                                                                      value!;
                                                                });
                                                                Selected_checkBox =
                                                                    false;
                                                                OtherType_checkBox =
                                                                    false;
                                                                Future_List =
                                                                    false;
                                                              },
                                                              activeColor: const Color
                                                                  .fromRGBO(
                                                                      255,
                                                                      98,
                                                                      118,
                                                                      1),
                                                            ),
                                                            const Text(
                                                              "Future Date",
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              child: Row(
                                                                children: [
                                                                  Checkbox(
                                                                    value:
                                                                        OtherType_checkBox,
                                                                    onChanged:
                                                                        (value) {
                                                                      setState(
                                                                          () {
                                                                        OtherType_checkBox =
                                                                            value!;
                                                                      });
                                                                      Selected_checkBox = false;
                                                                      Future_checkBox = false;
                                                                      Future_List = false;
                                                                    },
                                                                    activeColor:
                                                                        const Color.fromRGBO(255, 98,118, 1),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            const Text(
                                                              "Other Type Engaged",
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.w700,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              /*  Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      child: Row(
                                                        children: [
                                                          Checkbox(
                                                            value:
                                                                Selected_checkBox,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                Selected_checkBox =
                                                                    value!;
                                                              });
                                                              Future_checkBox =
                                                                  false;
                                                              OtherType_checkBox =
                                                                  false;
                                                              Future_List =
                                                                  false;
                                                            },
                                                            activeColor:
                                                                Color.fromRGBO(
                                                                    255,
                                                                    98,
                                                                    118,
                                                                    1),
                                                          ),
                                                          Text(
                                                            "Selected Date",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: Colors
                                                                    .blue),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      child: Row(
                                                        children: [
                                                          Checkbox(
                                                            value:
                                                                Future_checkBox,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                Future_checkBox =
                                                                    value!;
                                                              });
                                                              Selected_checkBox =
                                                                  false;
                                                              OtherType_checkBox =
                                                                  false;
                                                              Future_List =
                                                                  false;
                                                            },
                                                            activeColor:
                                                                Color.fromRGBO(
                                                                    255,
                                                                    98,
                                                                    118,
                                                                    1),
                                                          ),
                                                          Text(
                                                            "Future Date",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: Colors
                                                                    .blue),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),*/
                                                /*Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      child: Row(
                                                        children: [
                                                          Checkbox(
                                                            value:
                                                                OtherType_checkBox,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                OtherType_checkBox =
                                                                    value!;
                                                              });
                                                              Selected_checkBox =
                                                                  false;
                                                              Future_checkBox =
                                                                  false;
                                                              Future_List =
                                                                  false;
                                                            },
                                                            activeColor:
                                                                Color.fromRGBO(
                                                                    255,
                                                                    98,
                                                                    118,
                                                                    1),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Text(
                                                      "Other Type Engaged",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: Colors.blue),
                                                    ),
                                                  ],
                                                ),*/
                                                Future_checkBox == true
                                                    ? Container(
                                                        height: 40,
                                                        width: 150,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color:
                                                                  Colors.black),
                                                          borderRadius:
                                                              const BorderRadius.all(
                                                            Radius.circular(7),
                                                          ),
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            Future_Date == ""
                                                                ? const Text("Select")
                                                                : Text(
                                                                    "$Future_Date"),
                                                            IconButton(
                                                              onPressed:
                                                                  () async {
                                                                showDatePicker(
                                                                  context:
                                                                      context,
                                                                  initialDate: DateTime.parse(
                                                                          widget.Future_Date_one
                                                                              .toString())
                                                                      .add(const Duration(
                                                                          days:
                                                                              1)),
                                                                  firstDate: DateTime.parse(
                                                                          widget.Future_Date_one
                                                                              .toString())
                                                                      .add(const Duration(
                                                                          days:
                                                                              1)),
                                                                  lastDate:
                                                                      DateTime(
                                                                          2100),
                                                                ).then(
                                                                    (value) async {
                                                                  Future_Date = DateFormat(
                                                                          'dd/MM/yyyy')
                                                                      .format(
                                                                          value!);
                                                                  Future_List =
                                                                      true;
                                                                  await Future_Date_Functions();
                                                                  setState(
                                                                      () {});
                                                                });
                                                              },
                                                              icon: const Icon(
                                                                  Icons
                                                                      .calendar_month,
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          255,
                                                                          98,
                                                                          118,
                                                                          1)),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    : Container(),
                                                SizedBox(
                                                  height: sHeight(3, context),
                                                ),
                                                Future_List == true && Future_checkBox == true
                                                    ? Column(
                                                        children: [
                                                          SizedBox(
                                                            height: sHeight(
                                                                3, context),
                                                          ),
                                                          Alterdata.length > 0
                                                              ? Column(
                                                                  children: [
                                                                    for (int i = 0; i < Alterdata.length; i++)
                                                                      Column(
                                                                        children: [
                                                                          SizedBox(
                                                                            height: sHeight(1, context),
                                                                          ),
                                                                          Container(
                                                                            margin:
                                                                                const EdgeInsets.only(left: 10, right: 10),
                                                                            padding:
                                                                                const EdgeInsets.only(left: 10, right: 10),
                                                                            width:
                                                                                sWidth(95, context),
                                                                            decoration:
                                                                                const BoxDecoration(
                                                                              color: Color(0xFFECFFF4),
                                                                              borderRadius: BorderRadius.all(
                                                                                Radius.circular(10),
                                                                              ),
                                                                            ),
                                                                            child:
                                                                                Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                SizedBox(
                                                                                  height: sHeight(1, context),
                                                                                ),
                                                                                const Text(
                                                                                  "Staff Name",
                                                                                  style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black45),
                                                                                ),
                                                                                SizedBox(
                                                                                  height: sHeight(1, context),
                                                                                ),
                                                                                Text(
                                                                                  Alterdata[i].sn1,
                                                                                  style: const TextStyle(
                                                                                    fontWeight: FontWeight.w900,
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  height: sHeight(0.5, context),
                                                                                ),
                                                                                const Divider(
                                                                                  thickness: 0.5,
                                                                                ),
                                                                                Text(
                                                                                  "Subject Name : ${Alterdata[i].sbn}",
                                                                                  style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black54),
                                                                                ),
                                                                                SizedBox(
                                                                                  height: sHeight(1, context),
                                                                                ),
                                                                                Text(
                                                                                  "Subject Code : ${Alterdata[i].sbc}",
                                                                                  style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black54),
                                                                                ),
                                                                                SizedBox(
                                                                                  height: sHeight(1, context),
                                                                                ),
                                                                                Text(
                                                                                  "Hour  : ${Alterdata[i].hour}",
                                                                                  style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black54),
                                                                                ),
                                                                                SizedBox(
                                                                                  height: sHeight(1, context),
                                                                                ),
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [
                                                                                    Container(
                                                                                      height: sHeight(3, context),
                                                                                      width: sWidth(35, context),
                                                                                      decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: Color(0xFFFF6276)),
                                                                                      child: Center(
                                                                                        child: Text(
                                                                                          Alterdata[i].s,
                                                                                          style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    Checkbox(
                                                                                      value: selectedIndex_Future == Alterdata[i].fId,
                                                                                      onChanged: (value) {
                                                                                        if (selectedIndex_Future == Alterdata[i].fId) {
                                                                                          selectedIndex_Future = 0;
                                                                                          print("$selectedIndex_Future");
                                                                                        } else {
                                                                                          selectedIndex_Future = Alterdata[i].fId;
                                                                                          print("2---$selectedIndex_Future");
                                                                                        }
                                                                                        setState(() {});
                                                                                      },
                                                                                      activeColor: const Color.fromRGBO(255, 98, 118, 1),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                SizedBox(
                                                                                  height: sHeight(1.5, context),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    SizedBox(
                                                                      height: sHeight(
                                                                          2,
                                                                          context),
                                                                    ),
                                                                    ElevatedButton(
                                                                      onPressed:
                                                                          () async {
                                                                            showDialog(
                                                                                context: context,
                                                                                barrierDismissible:
                                                                                true,
                                                                                builder: (context) =>
                                                                                    AlertDialog(
                                                                                        content:
                                                                                        SizedBox(
                                                                                          height: sHeight(15, context),
                                                                                          width: sWidth(60, context),
                                                                                          child: Column(
                                                                                            children: [
                                                                                              const Text("Do you want to Send Alternative to this Staff?"),
                                                                                              SizedBox(height: sHeight(5,context),
                                                                                              ),
                                                                                              Row(
                                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                children: [
                                                                                                  InkWell(
                                                                                                    child:
                                                                                                    Container(
                                                                                                      height: sHeight(5, context),
                                                                                                      width: sWidth(17, context),
                                                                                                      decoration:
                                                                                                      BoxDecoration(
                                                                                                        borderRadius:
                                                                                                        BorderRadius.circular(10),
                                                                                                        color:
                                                                                                        Colors.red,
                                                                                                      ),
                                                                                                      child: Center(
                                                                                                          child: Text(
                                                                                                            "NO",
                                                                                                            style:
                                                                                                            ErrorText(),
                                                                                                          )),
                                                                                                    ),
                                                                                                    onTap:
                                                                                                        () {
                                                                                                      Navigator.pop(context);
                                                                                                    },
                                                                                                  ),
                                                                                                  InkWell(
                                                                                                    child:
                                                                                                    Container(
                                                                                                      height: sHeight(
                                                                                                          5,
                                                                                                          context),
                                                                                                      width: sWidth(
                                                                                                          17,
                                                                                                          context),
                                                                                                      decoration:
                                                                                                      BoxDecoration(
                                                                                                        borderRadius:
                                                                                                        BorderRadius.circular(10),
                                                                                                        color:
                                                                                                        Colors.green,
                                                                                                      ),
                                                                                                      child: Center(
                                                                                                          child: Text(
                                                                                                            "Yes",
                                                                                                            style:
                                                                                                            ErrorText(),
                                                                                                          )),
                                                                                                    ),
                                                                                                    onTap:
                                                                                                        () async {
                                                                                                          Responce_Function_Future_Date();
                                                                                                        })
                                                                                                ],
                                                                                              )
                                                                                            ],
                                                                                          ),
                                                                                        )));
                                                                      },
                                                                      style: ButtonStyle(
                                                                          backgroundColor: MaterialStateProperty.resolveWith((states) {
                                                                            if (states.contains(MaterialState.pressed)) {
                                                                              return const Color(0xff01BE84);
                                                                            }
                                                                            return const Color(0xff01BE84);
                                                                          }),
                                                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
                                                                      child:
                                                                          const Text(
                                                                        'SEND ALTERNATE HOUR REQUEST',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 13),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                              : Container(
                                                                  child: Image
                                                                      .asset(
                                                                    'images/Dataimg/data_not_found.png',
                                                                  ),
                                                                ),
                                                        ],
                                                      )
                                                    : Container(),
                                                Selected_checkBox == true
                                                    ? Column(
                                                        children: [
                                                          SizedBox(
                                                            height: sHeight(
                                                                3, context),
                                                          ),
                                                          for (int i = 0; i < alterHoursReq.length; i++)
                                                            Column(
                                                              children: [
                                                                Container(
                                                                  margin: const EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              10,
                                                                          right:
                                                                              10),
                                                                  padding: const EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              10,
                                                                          right:
                                                                              10),
                                                                  width: sWidth(
                                                                      95,
                                                                      context),
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                    color: Color(
                                                                        0xFFECFFF4),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .all(
                                                                      Radius.circular(
                                                                          10),
                                                                    ),
                                                                  ),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      SizedBox(
                                                                        height: sHeight(
                                                                            1,
                                                                            context),
                                                                      ),
                                                                      const Text(
                                                                        "Staff Name",
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w700,
                                                                            color: Colors.black45),
                                                                      ),
                                                                      SizedBox(
                                                                        height: sHeight(
                                                                            1,
                                                                            context),
                                                                      ),
                                                                      Text(
                                                                        alterHoursReq[i].sn1,
                                                                        style:
                                                                            const TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.w900,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height: sHeight(
                                                                            0.5,
                                                                            context),
                                                                      ),
                                                                      const Divider(
                                                                        thickness:
                                                                            0.5,
                                                                      ),
                                                                      Text(
                                                                        "Subject Name : ${alterHoursReq[i].sbn}",
                                                                        style: const TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            color: Colors.black54),
                                                                      ),
                                                                      SizedBox(
                                                                        height: sHeight(
                                                                            1,
                                                                            context),
                                                                      ),
                                                                      Text(
                                                                        "Subject Code : ${alterHoursReq[i].sbc}",
                                                                        style: const TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            color: Colors.black54),
                                                                      ),
                                                                      SizedBox(
                                                                        height: sHeight(
                                                                            1,
                                                                            context),
                                                                      ),
                                                                      Text(
                                                                        "Hour  : ${alterHoursReq[i].hour}",
                                                                        style: const TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            color: Colors.black54),
                                                                      ),
                                                                      SizedBox(
                                                                        height: sHeight(
                                                                            1,
                                                                            context),
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Container(
                                                                            height:
                                                                                sHeight(3, context),
                                                                            width:
                                                                                sWidth(35, context),
                                                                            decoration:
                                                                                const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: Color(0xFFFF6276)),
                                                                            child:
                                                                                Center(
                                                                              child: Text(
                                                                                alterHoursReq[i].s,
                                                                                style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Checkbox(
                                                                            value:
                                                                                selectedIndexID2 == alterHoursReq[i].fId,
                                                                            onChanged:
                                                                                (value) {
                                                                              setState(() {
                                                                                if (selectedIndexID2 == alterHoursReq[i].fId) {
                                                                                  selectedIndexID2 = null;
                                                                                  print("1$selectedIndexID2");
                                                                                } else {
                                                                                  selectedIndexID2 = alterHoursReq[i].fId;
                                                                                  print("2---$selectedIndexID2");
                                                                                }
                                                                              });
                                                                            },
                                                                            activeColor: const Color.fromRGBO(
                                                                                255,
                                                                                98,
                                                                                118,
                                                                                1),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height: sHeight(
                                                                            1.5,
                                                                            context),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: sHeight(
                                                                      2,
                                                                      context),
                                                                ),
                                                              ],
                                                            ),
                                                          ElevatedButton(
                                                            onPressed:
                                                                () async {
                                                                  showDialog(
                                                                      context: context,
                                                                      barrierDismissible:
                                                                      true,
                                                                      builder: (context) =>
                                                                          AlertDialog(
                                                                              content:
                                                                              SizedBox(
                                                                                height: sHeight(15, context),
                                                                                width: sWidth(60, context),
                                                                                child: Column(
                                                                                  children: [
                                                                                    const Text("Do you want Send Alternative to this Staff?"),
                                                                                    SizedBox(height: sHeight(5,context),
                                                                                    ),
                                                                                    Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        InkWell(
                                                                                          child:
                                                                                          Container(
                                                                                            height: sHeight(5, context),
                                                                                            width: sWidth(17, context),
                                                                                            decoration:
                                                                                            BoxDecoration(
                                                                                              borderRadius:
                                                                                              BorderRadius.circular(10),
                                                                                              color:
                                                                                              Colors.red,
                                                                                            ),
                                                                                            child: Center(
                                                                                                child: Text(
                                                                                                  "NO",
                                                                                                  style:
                                                                                                  ErrorText(),
                                                                                                )),
                                                                                          ),
                                                                                          onTap:
                                                                                              () {
                                                                                            Navigator.pop(context);
                                                                                          },
                                                                                        ),
                                                                                        InkWell(
                                                                                          child:
                                                                                          Container(
                                                                                            height: sHeight(
                                                                                                5,
                                                                                                context),
                                                                                            width: sWidth(
                                                                                                17,
                                                                                                context),
                                                                                            decoration:
                                                                                            BoxDecoration(
                                                                                              borderRadius:
                                                                                              BorderRadius.circular(10),
                                                                                              color:
                                                                                              Colors.green,
                                                                                            ),
                                                                                            child: Center(
                                                                                                child: Text(
                                                                                                  "Yes",
                                                                                                  style:
                                                                                                  ErrorText(),
                                                                                                )),
                                                                                          ),
                                                                                          onTap:
                                                                                              () async {
                                                                                            await Responce_Function_SelectedDate();
                                                                                          },
                                                                                        )
                                                                                      ],
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              )));

                                                            },
                                                            style: ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStateProperty
                                                                        .resolveWith(
                                                                            (states) {
                                                                  if (states.contains(
                                                                      MaterialState
                                                                          .pressed)) {
                                                                    return const Color(
                                                                        0xff01BE84);
                                                                  }
                                                                  return const Color(
                                                                      0xff01BE84);
                                                                }),
                                                                shape: MaterialStateProperty.all<
                                                                        RoundedRectangleBorder>(
                                                                    RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10)))),
                                                            child: const Text(
                                                              'SEND ALTERNATE HOUR REQUEST',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 13),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : Container(),
                                                OtherType_checkBox == true
                                                    ? Column(
                                                        children: [
                                                          Container(
                                                            height: sHeight(
                                                                5, context),
                                                            width: sWidth(
                                                                95, context),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            7),
                                                                color: Colors
                                                                    .white),
                                                            child:
                                                                DropdownSearch<
                                                                    String>(
                                                              popupProps:
                                                                  const PopupProps
                                                                      .menu(),
                                                              dropdownDecoratorProps:
                                                                  const DropDownDecoratorProps(),
                                                              dropdownButtonProps:
                                                                  const DropdownButtonProps(
                                                                // padding: EdgeInsets.symmetric(horizontal: 20.0),
                                                                icon: Icon(Icons
                                                                    .arrow_drop_down_circle_rounded),
                                                                color: Color
                                                                    .fromRGBO(
                                                                        255,
                                                                        98,
                                                                        118,
                                                                        1),
                                                              ),
                                                              items:
                                                                  Departments_List,
                                                              selectedItem:
                                                                  "Select Department",
                                                              onChanged:
                                                                  (value) async {
                                                                Department_Name =
                                                                    value!
                                                                        .toString();
                                                                Passing_Dep =
                                                                    Departments_List.indexOf(
                                                                            value.toString())
                                                                        .toInt();
                                                                Dept_Id = Departments_List_Check[
                                                                    Passing_Dep!
                                                                        .toInt()];
                                                                Staff_Lists_Get_Function();
                                                                Show_DS_Name =
                                                                    false;
                                                                setState(() {});
                                                              },
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: sHeight(
                                                                3, context),
                                                          ),
                                                          Container(
                                                            height: sHeight(
                                                                5, context),
                                                            width: sWidth(
                                                                95, context),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            7),
                                                                color: Colors
                                                                    .white),
                                                            child:
                                                                DropdownSearch<
                                                                    String>(
                                                              popupProps:
                                                                  const PopupProps
                                                                      .menu(),
                                                              dropdownDecoratorProps:
                                                                  const DropDownDecoratorProps(),
                                                              dropdownButtonProps:
                                                                  const DropdownButtonProps(
                                                                // padding: EdgeInsets.symmetric(horizontal: 20.0),
                                                                icon: Icon(Icons
                                                                    .arrow_drop_down_circle_rounded),
                                                                color: Color
                                                                    .fromRGBO(
                                                                        255,
                                                                        98,
                                                                        118,
                                                                        1),
                                                              ),
                                                              items:
                                                                  Staffs_List,
                                                              selectedItem:
                                                                  "Select Staff",
                                                              onChanged:
                                                                  (value) async {
                                                                Staff_Name = value!
                                                                    .toString();
                                                                print(
                                                                    Staffs_List_Check);
                                                                Passing_Staff = Staffs_List.indexOf(value.toString()).toInt();
                                                                Staff_ID = Staffs_List_Check[Passing_Staff!.toInt()];
                                                                print(Staff_ID);
                                                                Show_DS_Name = true;
                                                                setState(() {});
                                                              },
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: sHeight(
                                                                3, context),
                                                          ),
                                                          Show_DS_Name == true
                                                              ? Column(
                                                                  children: [
                                                                    Container(
                                                                      margin: const EdgeInsets.only(
                                                                          left:
                                                                              10,
                                                                          right:
                                                                              10),
                                                                      padding: const EdgeInsets.only(
                                                                          left:
                                                                              10,
                                                                          right:
                                                                              10),
                                                                      width: sWidth(
                                                                          95,
                                                                          context),
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                        color: Color(
                                                                            0xFFECFFF4),
                                                                        borderRadius:
                                                                            BorderRadius.all(
                                                                          Radius.circular(
                                                                              10),
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          SizedBox(
                                                                            height:
                                                                                sHeight(1, context),
                                                                          ),
                                                                          const Text(
                                                                            "Department Name",
                                                                            style:
                                                                                TextStyle(fontWeight: FontWeight.w700, color: Colors.black45),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                sHeight(1, context),
                                                                          ),
                                                                          Text(
                                                                            "$Department_Name",
                                                                            style:
                                                                                const TextStyle(
                                                                              fontWeight: FontWeight.w900,
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                sHeight(0.5, context),
                                                                          ),
                                                                          const Divider(
                                                                            thickness:
                                                                                0.5,
                                                                          ),
                                                                          const Text(
                                                                            "Staff Name",
                                                                            style:
                                                                                TextStyle(fontWeight: FontWeight.w700, color: Colors.black45),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                sHeight(1, context),
                                                                          ),
                                                                          Text(
                                                                            "$Staff_Name",
                                                                            style:
                                                                                const TextStyle(
                                                                              fontWeight: FontWeight.w900,
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                sHeight(0.5, context),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                sHeight(1.5, context),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: sHeight(
                                                                          3,
                                                                          context),
                                                                    ),
                                                                    ElevatedButton(
                                                                      onPressed:
                                                                          () async {
                                                                            showDialog(
                                                                                context: context,
                                                                                barrierDismissible:
                                                                                true,
                                                                                builder: (context) =>
                                                                                    AlertDialog(
                                                                                        content:
                                                                                        SizedBox(
                                                                                          height: sHeight(15, context),
                                                                                          width: sWidth(60, context),
                                                                                          child: Column(
                                                                                            children: [
                                                                                              const Text("Do you want Send Alternative to this Staff?"),
                                                                                              SizedBox(height: sHeight(5,context),
                                                                                              ),
                                                                                              Row(
                                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                children: [
                                                                                                  InkWell(
                                                                                                    child:
                                                                                                    Container(
                                                                                                      height: sHeight(5, context),
                                                                                                      width: sWidth(17, context),
                                                                                                      decoration:
                                                                                                      BoxDecoration(
                                                                                                        borderRadius:
                                                                                                        BorderRadius.circular(10),
                                                                                                        color:
                                                                                                        Colors.red,
                                                                                                      ),
                                                                                                      child: Center(
                                                                                                          child: Text(
                                                                                                            "NO",
                                                                                                            style:
                                                                                                            ErrorText(),
                                                                                                          )),
                                                                                                    ),
                                                                                                    onTap:
                                                                                                        () {
                                                                                                      Navigator.pop(context);
                                                                                                    },
                                                                                                  ),
                                                                                                  InkWell(
                                                                                                    child:
                                                                                                    Container(
                                                                                                      height: sHeight(
                                                                                                          5,
                                                                                                          context),
                                                                                                      width: sWidth(
                                                                                                          17,
                                                                                                          context),
                                                                                                      decoration:
                                                                                                      BoxDecoration(
                                                                                                        borderRadius:
                                                                                                        BorderRadius.circular(10),
                                                                                                        color:
                                                                                                        Colors.green,
                                                                                                      ),
                                                                                                      child: Center(
                                                                                                          child: Text(
                                                                                                            "Yes",
                                                                                                            style:
                                                                                                            ErrorText(),
                                                                                                          )),
                                                                                                    ),
                                                                                                    onTap:
                                                                                                        () async {
                                                                                                          await Responce_Function_OtherType_Engaged();
                                                                                                        },
                                                                                                  )
                                                                                                ],
                                                                                              )
                                                                                            ],
                                                                                          ),
                                                                                        )));

                                                                      },
                                                                      style: ButtonStyle(
                                                                          backgroundColor: MaterialStateProperty.resolveWith((states) {
                                                                            if (states.contains(MaterialState.pressed)) {
                                                                              return const Color(0xff01BE84);
                                                                            }
                                                                            return const Color(0xff01BE84);
                                                                          }),
                                                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
                                                                      child:
                                                                          const Text(
                                                                        'SEND ALTERNATE HOUR REQUEST',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 13),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                              : Container(),
                                                        ],
                                                      )
                                                    : Container(),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  else {
                                      return WillPopScope(
                                        onWillPop: () async =>
                                            _onBackButtonPressed(),
                                        child: Scaffold(
                                          appBar: AppBar(
                                            title: Text(
                                              "Alternate Types",
                                              style: PrimaryText(context),
                                            ),
                                            centerTitle: true,
                                            backgroundColor:
                                                const Color.fromRGBO(255, 98, 118, 1),
                                            elevation: 20.0,
                                          ),
                                          body: Center(
                                              child: SearchingDataLottie(context)),
                                        ),
                                      );
                                    }
                                  } else {
                                    return Container(
                                      color: Colors.white,
                                      child: Center(
                                          child: SearchingDataLottie(context)),
                                    );
                                  }
                                });
                          } else {
                            return Container(
                              color: Colors.white,
                              child:
                                  Center(child: SearchingDataLottie(context)),
                            );
                          }
                        });
                  } else {
                    return Container(
                      color: Colors.white,
                      child: Center(child: SearchingDataLottie(context)),
                    );
                  }
                });
          } else {
            return Container(
              color: Colors.white,
              child: Center(child: SearchingDataLottie(context)),
            );
          }
        });
  }

  _onBackButtonPressed() async {
    await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Staff_Leave_Apply_Alter_List(
                  username: widget.username,
                  password: widget.password,
                  fromdateuh: widget.fromdateuh,
                  TOdateuh: widget.TOdateuh,
                  FromSesion: widget.FromSesion,
                  TOSessin: widget.TOSessin,
                  F_T_M: widget.Future_Date_one,
              Reason: widget.Reason,
              Hodid: widget.Hodid,
              Typeid: widget.Typeid,
                )));
  }
}

//Staff Inbox State

class Staff_Request_Inbox extends StatefulWidget {
  const Staff_Request_Inbox(
      {Key? key, required this.username, required this.password})
      : super(key: key);
  final String username;
  final String password;

  @override
  State<Staff_Request_Inbox> createState() => _Staff_Request_InboxState();
}

class _Staff_Request_InboxState extends State<Staff_Request_Inbox> {
  late Future<Staff_Inbox_Data_List> Inbox_API_Data;
  int? Acce_R_rejeID;
  String? Normal_Accept_MSG;
  late List Responce_Normal_Accept_List = [];
  String? Normal_Reject_MSG;
  late List Responce_Reject__List = [];

  void initState() {
    // TODO: implement initState
    super.initState();
    Staffs_Inbox_Network staffsInboxNetwork = Staffs_Inbox_Network(
        "StaffAlternateInbox?StaffCode=${widget.username}&InstId=1&LoadType=0&Password=${widget.password}");
    Inbox_API_Data = staffsInboxNetwork.Inbox_loadData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Inbox_API_Data,
        builder: (context, AsyncSnapshot<Staff_Inbox_Data_List> snapshot) {
          if (snapshot.hasError) {
            ErrorShowingWidget(context);
          }
          List<Staff_Inbox_Data> inbData;
          if (snapshot.hasData) {
            inbData = snapshot.data!.Inbox_Sta_list;
            if (inbData.length > 0) {
              return WillPopScope(
                onWillPop: () async => _onBackButtonPressed(),
                child: Scaffold(
                  backgroundColor: const Color.fromRGBO(242, 249, 255, 0.9),
                  appBar: AppBar(
                    title: Text("Inbox", style: PrimaryText(context)),
                    backgroundColor: const Color.fromRGBO(255, 98, 118, 1),
                  ),
                  body: Builder(
                    builder: (BuildContext context) => SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Center(
                        child: Column(
                          children: [
                            for (int i = 0; i < inbData.length; i++)
                              Column(
                                children: [
                                  SizedBox(
                                    height: sHeight(2, context),
                                  ),
                                  Container(
                                    padding:
                                        const EdgeInsets.only(left: 10, right: 10),
                                    width: sWidth(95, context),
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: sHeight(1, context),
                                        ),
                                        const Text(
                                          "Request From",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black45),
                                        ),
                                        SizedBox(
                                          height: sHeight(1, context),
                                        ),
                                        Text(
                                          inbData[i].reqFrom,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w900,
                                            color: Color(0xFF6762FF),
                                          ),
                                          maxLines: 1,
                                        ),
                                        SizedBox(
                                          height: sHeight(1, context),
                                        ),
                                        const Text(
                                          "Class Name",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black45),
                                        ),
                                        SizedBox(
                                          height: sHeight(1, context),
                                        ),
                                        Text(
                                          inbData[i].clname,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w900,
                                            color: Color(0xFF6762FF),
                                          ),
                                          maxLines: 1,
                                        ),
                                        SizedBox(
                                          height: sHeight(1, context),
                                        ),
                                        const Divider(
                                          thickness: 0.5,
                                        ),
                                        Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  "Subject Name",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.black45),
                                                ),
                                                SizedBox(
                                                  height: sHeight(1, context),
                                                ),
                                                const Text(
                                                  "Subject Code",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.black45),
                                                ),
                                                SizedBox(
                                                  height: sHeight(1, context),
                                                ),
                                                const Text(
                                                  "Date",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.black45),
                                                ),
                                                SizedBox(
                                                  height: sHeight(1, context),
                                                ),
                                                const Text(
                                                  "Send Date",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.black45),
                                                ),
                                                SizedBox(
                                                  height: sHeight(1, context),
                                                ),
                                                const Text(
                                                  "Actual Hour",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.black45),
                                                ),
                                                SizedBox(
                                                  height: sHeight(1, context),
                                                ),
                                                const Text(
                                                  "Request Hour",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.black45),
                                                ),
                                                SizedBox(
                                                  height: sHeight(2, context),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  " : ",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.black45),
                                                ),
                                                SizedBox(
                                                  height: sHeight(1, context),
                                                ),
                                                const Text(
                                                  " : ",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.black45),
                                                ),
                                                SizedBox(
                                                  height: sHeight(1, context),
                                                ),
                                                const Text(
                                                  " : ",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.black45),
                                                ),
                                                SizedBox(
                                                  height: sHeight(1, context),
                                                ),
                                                const Text(
                                                  " : ",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.black45),
                                                ),
                                                SizedBox(
                                                  height: sHeight(1, context),
                                                ),
                                                const Text(
                                                  " : ",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.black45),
                                                ),
                                                SizedBox(
                                                  height: sHeight(1, context),
                                                ),
                                                const Text(
                                                  " : ",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.black45),
                                                ),
                                                SizedBox(
                                                  height: sHeight(2, context),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: sHeight(2.5, context),
                                                  width: sWidth(60, context),
                                                  child: FittedBox(
                                                    fit:  BoxFit.contain,
                                                    child: Text(
                                                      inbData[i].subjectName,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: Colors.black),
                                                      maxLines: 2,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: sHeight(1, context),
                                                ),
                                                Text(
                                                  inbData[i].subjectCode,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.black),
                                                ),
                                                SizedBox(
                                                  height: sHeight(1, context),
                                                ),
                                                Text(
                                                  inbData[i].date.replaceAll(RegExp(r"\([^()]*\)"), ""),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.black),
                                                ),
                                                SizedBox(
                                                  height: sHeight(1, context),
                                                ),
                                                Text(
                                                  inbData[i].sendDate,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.black),
                                                ),
                                                SizedBox(
                                                  height: sHeight(1, context),
                                                ),
                                                inbData[i].actualHr == ""
                                                    ? const Text(
                                                        " -",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color:
                                                                Colors.black),
                                                      )
                                                    : Text(
                                                        inbData[i].actualHr,
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                SizedBox(
                                                  height: sHeight(1, context),
                                                ),
                                                Text(
                                                  inbData[i].requestHr,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.black),
                                                ),
                                                SizedBox(
                                                  height: sHeight(2, context),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              children: [
                                                inbData[i].stCode == 1
                                                    ? Container(
                                                        height:
                                                            sHeight(3, context),
                                                        width:
                                                            sWidth(35, context),
                                                        decoration: const BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            5)),
                                                            color:
                                                                Colors.green),
                                                        child: Center(
                                                          child: Text(
                                                            inbData[i].status,
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      )
                                                    : Container(),
                                                inbData[i].stCode == 2
                                                    ? Container(
                                                        height:
                                                            sHeight(3, context),
                                                        width:
                                                            sWidth(35, context),
                                                        decoration: const BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            5)),
                                                            color: Colors.red),
                                                        child: Center(
                                                          child: Text(
                                                            inbData[i].status,
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      )
                                                    : Container(),
                                                inbData[i].stCode == 3
                                                    ? Container(
                                                        height:
                                                            sHeight(3, context),
                                                        width:
                                                            sWidth(35, context),
                                                        decoration: const BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            5)),
                                                            color:
                                                                Colors.brown),
                                                        child: Center(
                                                          child: Text(
                                                            inbData[i].status,
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      )
                                                    : Container(),
                                                inbData[i].stCode == 0
                                                    ? Container(
                                                        height:
                                                            sHeight(3, context),
                                                        width:
                                                            sWidth(35, context),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5)),
                                                          color: PrimaryColor(),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            inbData[i].status,
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      )
                                                    : Container(),
                                              ],
                                            ),
                                            // SizedBox(width: sWidth(40, context),),
                                            inbData[i].stCode == 0 ?
                                            Container(
                                              width: sWidth(40, context),
                                              child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                              ElevatedButton(
                                              onPressed: () async {
                                                if (inbData[i].subjectCode ==
                                                    'Other Staff') {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return Find_Staffs_Subject(
                                                        username:
                                                        widget.username,
                                                        password:
                                                        widget.password,
                                                        classID: inbData[i]
                                                            .clsid
                                                            .toInt(),
                                                        TimetableID: inbData[i]
                                                            .timeid
                                                            .toInt(),
                                                        From_Alt_id: inbData[i]
                                                            .id
                                                            .toInt(),
                                                      );
                                                    },
                                                  );
                                                  // Find_Staffs_Subject();
                                                } else {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        backgroundColor:
                                                        Colors.white,
                                                        content:
                                                        SingleChildScrollView(
                                                          child: SizedBox(
                                                            height: sHeight(
                                                                8, context),
                                                            width: sWidth(
                                                                90, context),
                                                            child: Column(
                                                                children: [
                                                                  const Text(
                                                                    "Do you confirm accept this Request?",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .indigo,
                                                                        fontWeight:
                                                                        FontWeight.w700),
                                                                  ),
                                                                  SizedBox(
                                                                    height: sHeight(
                                                                        3,
                                                                        context),
                                                                  ),
                                                                ]),
                                                          ),
                                                        ),
                                                        actions: [
                                                          ElevatedButton(
                                                            onPressed:
                                                                () async {
                                                              final resp = await http.get(
                                                                Uri.parse("http://$StaticIP/api/InboxAlternateHourAcceptancy?StaffCode=${widget.username}&AlternateId=${inbData[i].id}&Type=1&StaffSubject=0&Password=${widget.password}"), // server login url
                                                              );
                                                              if (resp.statusCode == 200) {
                                                                Responce_Normal_Accept_List = json.decode(resp.body);
                                                                Normal_Accept_MSG = (Responce_Normal_Accept_List[0]['Msg'].toString());
                                                                await Fluttertoast.showToast(
                                                                    backgroundColor: Colors.teal,
                                                                    msg: "$Normal_Accept_MSG",
                                                                    toastLength: Toast.LENGTH_SHORT,
                                                                    gravity: ToastGravity.SNACKBAR,
                                                                    textColor: Colors.white,
                                                                    fontSize: 16.0);
                                                                Navigator.pushReplacement(context,
                                                                    MaterialPageRoute(builder: (context) => Staff_Request_Inbox(username: widget.username, password: widget.password,)));
                                                              } else {
                                                                print("Nothing");
                                                              }
                                                            },
                                                            style: ElevatedButton
                                                                .styleFrom(
                                                                primary: Colors
                                                                    .green),
                                                            child: const Text("yes"),
                                                          ),
                                                          ElevatedButton(
                                                            onPressed:
                                                                () async {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            style: ElevatedButton
                                                                .styleFrom(
                                                                primary:
                                                                Colors
                                                                    .red),
                                                            child: const Text("No"),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  shape: const StadiumBorder(),
                                                  primary: Colors.green),
                                              child: const Icon(Icons.check),
                                            ),
                                              ElevatedButton(
                                                  onPressed: () async {
                                                    showDialog(
                                                      context: context,
                                                      builder:
                                                          (BuildContext context) {
                                                        return AlertDialog(
                                                          backgroundColor:
                                                          Colors.white,
                                                          content:
                                                          SingleChildScrollView(
                                                            child: SizedBox(
                                                              height: sHeight(
                                                                  8, context),
                                                              width: sWidth(
                                                                  90, context),
                                                              child: Column(
                                                                  children: [
                                                                    const Text(
                                                                      "Do you confirm Reject this Request?",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .red,
                                                                          fontWeight:
                                                                          FontWeight.w700),
                                                                    ),
                                                                    SizedBox(
                                                                      height: sHeight(
                                                                          3,
                                                                          context),
                                                                    ),
                                                                  ]),
                                                            ),
                                                          ),
                                                          actions: [
                                                            ElevatedButton(
                                                              onPressed:
                                                                  () async {
                                                                final resp =
                                                                await http
                                                                    .get(
                                                                  Uri.parse(
                                                                      "http://$StaticIP/api/InboxAlternateHourAcceptancy?StaffCode=${widget.username}&AlternateId=${inbData[i].id}&Type=0&StaffSubject=0&Password=${widget.password}"), // server login url
                                                                );
                                                                if (resp.statusCode ==
                                                                    200) {
                                                                  Responce_Reject__List =
                                                                      json.decode(
                                                                          resp.body);
                                                                  Normal_Reject_MSG =
                                                                  (Responce_Reject__List[0]
                                                                  [
                                                                  'Msg']
                                                                      .toString());
                                                                  await Fluttertoast.showToast(
                                                                      backgroundColor:
                                                                      Colors
                                                                          .blueAccent,
                                                                      msg:
                                                                      "$Normal_Reject_MSG",
                                                                      toastLength:
                                                                      Toast
                                                                          .LENGTH_SHORT,
                                                                      gravity:
                                                                      ToastGravity
                                                                          .SNACKBAR,
                                                                      textColor:
                                                                      Colors
                                                                          .white,
                                                                      fontSize:
                                                                      16.0);
                                                                  await Navigator.pushReplacement(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => Staff_Request_Inbox(
                                                                            username: widget.username,
                                                                            password: widget.password,
                                                                          )));
                                                                } else {}
                                                              },
                                                              style: ElevatedButton
                                                                  .styleFrom(
                                                                  primary: Colors
                                                                      .green),
                                                              child: const Text("yes"),
                                                            ),
                                                            ElevatedButton(
                                                              onPressed:
                                                                  () async {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              style: ElevatedButton
                                                                  .styleFrom(
                                                                  backgroundColor: Colors
                                                                      .red),
                                                              child: const Text("No"),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                      shape:
                                                      RoundedRectangleBorder(
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              20)),
                                                      primary: Colors.red),
                                                  child: const Icon(Icons.close)),
                                              ],
                                            ),
                                            ):
                                                Container(),
                                          ],
                                        ),
                                        SizedBox(
                                          height: sHeight(1, context),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            SizedBox(
                              height: sHeight(3, context),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // bottomNavigationBar: Row(
                  //   children: [
                  //     InkWell(
                  //       onTap: () {
                  //         print('Reject');
                  //       },
                  //       child:  Container(
                  //         decoration: BoxDecoration(
                  //             color: Colors.red,
                  //             borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                  //         ),
                  //         height: kToolbarHeight,
                  //         width: sWidth(50, context),
                  //         child: Center(
                  //           child: Text(
                  //             'Reject',
                  //             textAlign: TextAlign.center,
                  //             style: TextStyle(
                  //               fontWeight: FontWeight.bold,
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //     InkWell(
                  //       onTap: () {
                  //         print('Accept');
                  //       },
                  //       child:  Container(
                  //         height: kToolbarHeight,
                  //         width: sWidth(50, context),
                  //         decoration: BoxDecoration(
                  //             color: Colors.green,
                  //             borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                  //         ),
                  //         child: Center(
                  //           child: Text(
                  //             'Accept',
                  //             style: TextStyle(
                  //               fontWeight: FontWeight.bold,
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ),
              );
            } else {
              return Scaffold(
                //backgroundColor: const Color.fromRGBO(242, 249, 255, 0.9),
                appBar: AppBar(
                  title: Text("Inbox", style: PrimaryText(context)),
                  backgroundColor: const Color.fromRGBO(255, 98, 118, 1),
                ),
                body: Center(
                  child: Image.asset("images/Dataimg/data_not_found.png"),
                ),
              );
            }
          } else {
            return Container(
              color: Colors.white,
              child: Center(child: StudentsSearching(context)),
            );
          }
        });
  }

  _onBackButtonPressed() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => StaffDrawerScreen(
                username: widget.username, password: widget.password)));
  }
}

//Find Staff Subject AlertDialog

class Find_Staffs_Subject extends StatefulWidget {
  const Find_Staffs_Subject(
      {Key? key,
      required this.username,
      required this.password,
      required this.classID,
      required this.TimetableID,
      required this.From_Alt_id})
      : super(key: key);
  final String username;
  final String password;
  final int classID;
  final int TimetableID;
  final int From_Alt_id;

  @override
  State<Find_Staffs_Subject> createState() => _Find_Staffs_SubjectState();
}

class _Find_Staffs_SubjectState extends State<Find_Staffs_Subject> {
  late Future<Staff_Inbox_Lesson_Data_List> Inbox_Lesson_API_Data;
  late List<String> Lesson_List = [];
  late List<String> Lesson_List_Check = [];
  String? Lesson_Id;
  late List Responce_Accept_With_Subject = [];
  late List Responce_Accept_WithOUT_Subject = [];
  String? Accept_withSubject_MSG;
  String? Accept_withOUTSubject_MSG;

  Responce_Function_Accept_With_SUb() async {
    final resp = await http.get(
      Uri.parse(
          "http://$StaticIP/api/InboxAlternateHourAcceptancy?StaffCode=${widget.username}&Password=${widget.password}&AlternateId=${widget.From_Alt_id}&Type=1&StaffSubject=$Lesson_Id"), // server login url
    );
    if (resp.statusCode == 200) {
      Responce_Accept_With_Subject = json.decode(resp.body);
      Accept_withSubject_MSG =
          (Responce_Accept_With_Subject[0]['Msg'].toString());
      await Fluttertoast.showToast(
          backgroundColor: Colors.deepPurple,
          msg: "$Accept_withSubject_MSG",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          textColor: Colors.white,
          fontSize: 16.0);
      await Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Staff_Request_Inbox(
                    username: widget.username,
                    password: widget.password,
                  )));
    } else {}
  }

  Responce_Function_Accept_WithOUT_SUb() async {
    final resp = await http.get(
      Uri.parse(
          "http://$StaticIP/api/InboxAlternateHourAcceptancy?StaffCode=${widget.username}&Password=${widget.password}&AlternateId=${widget.From_Alt_id}&Type=1&StaffSubject=0"), // server login url
    );
    if (resp.statusCode == 200) {
      Responce_Accept_WithOUT_Subject = json.decode(resp.body);
      Accept_withOUTSubject_MSG =
          (Responce_Accept_WithOUT_Subject[0]['Msg'].toString());
      await Fluttertoast.showToast(
          backgroundColor: Colors.blue,
          msg: "$Accept_withOUTSubject_MSG",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          textColor: Colors.white,
          fontSize: 16.0);
      await Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Staff_Request_Inbox(
                    username: widget.username,
                    password: widget.password,
                  )));
    } else {}
  }

  String? Normal_Accept_SUB_MSG;
  late List Responce_Normal_Accept_SUB_List = [];

  void initState() {
    // TODO: implement initState
    super.initState();
    Staff_Inbox_Lesson_Network staffInboxLessonNetwork =
        Staff_Inbox_Lesson_Network("AlterHoursSubjectFind?StaffCode=${widget.username}&classId=${widget.classID}&TimetableId=${widget.TimetableID}&Password=${widget.password}");
    Inbox_Lesson_API_Data = staffInboxLessonNetwork.Inbox_Lesson_loadData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Inbox_Lesson_API_Data,
        builder:
            (context, AsyncSnapshot<Staff_Inbox_Lesson_Data_List> snapshot) {
          if (snapshot.hasError) {
            ErrorShowingWidget(context);
          }
          List<Staff_Inbox_Lesson_Data> lessonData;
          if (snapshot.hasData) {
            lessonData = snapshot.data!.Inbox_Leson_list;
            Lesson_List = [
              for (int i = lessonData.length - 1; i >= 0; i--)
                lessonData[i].lesson
            ].reversed.toList();
            Lesson_List_Check = [
              for (int i = lessonData.length - 1; i >= 0; i--)
                "${lessonData[i].id}"
            ].reversed.toList();
            if (lessonData.length > 0) {
              return AlertDialog(
                backgroundColor: Colors.white,
                content: SingleChildScrollView(
                  child: SizedBox(
                    height: sHeight(20, context),
                    width: sWidth(90, context),
                    child: Column(children: [
                      const Text(
                        "*If any Subject(s) is allocated for you this class, click this checkbox & Select the Subject from the below List",
                        style: TextStyle(
                            color: Colors.indigo, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: sHeight(3, context),
                      ),
                      Container(
                        child: FormField<String>(
                          builder: (FormFieldState<String> state) {
                            return DropdownButtonHideUnderline(
                              child: DropdownSearch<String>(
                                popupProps: const PopupProps.menu(),
                                dropdownDecoratorProps:
                                    const DropDownDecoratorProps(),
                                dropdownButtonProps: const DropdownButtonProps(
                                    // padding: EdgeInsets.symmetric(horizontal: 20.0),
                                    icon: Icon(
                                        Icons.arrow_drop_down_circle_rounded),
                                    color: Color.fromRGBO(255, 98, 118, 1)),
                                items: Lesson_List,
                                selectedItem: "Select a Subject",
                                onChanged: (value) {
                                  int passingDep =
                                      Lesson_List.indexOf(value.toString())
                                          .toInt();
                                  Lesson_Id =
                                      Lesson_List_Check[passingDep.toInt()];
                                  print(Lesson_Id);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ]),
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () async {
                      if (Lesson_Id == null) {
                        await Fluttertoast.showToast(
                            backgroundColor: Colors.red,
                            msg: "Kindly! Select Subject",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.SNACKBAR,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      } else {
                        Responce_Function_Accept_With_SUb();
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                    child: const Text("Accept with Subject"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await Responce_Function_Accept_WithOUT_SUb();
                    },
                    style: ElevatedButton.styleFrom(primary: Colors.teal),
                    child: const Text("Accept without Subject"),
                  ),
                ],
              );
            } else {
              return AlertDialog(
                backgroundColor: Colors.white,
                content: SingleChildScrollView(
                  child: SizedBox(
                    height: sHeight(8, context),
                    width: sWidth(90, context),
                    child: Column(children: [
                      const Text(
                        "Do you confirm accept this Request?",
                        style: TextStyle(
                            color: Colors.indigo, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: sHeight(3, context),
                      ),
                    ]),
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () async {
                      final resp = await http.get(
                        Uri.parse(
                            "http://$StaticIP/api/InboxAlternateHourAcceptancy?StaffCode=${widget.username}&AlternateId=${widget.From_Alt_id}&Type=1&StaffSubject=0&Password=${widget.password}"), // server login url
                      );
                      if (resp.statusCode == 200) {
                        Responce_Normal_Accept_SUB_List =
                            json.decode(resp.body);
                        Normal_Accept_SUB_MSG =
                            (Responce_Normal_Accept_SUB_List[0]['Msg']
                                .toString());
                        await Fluttertoast.showToast(
                            backgroundColor: Colors.teal,
                            msg: "$Normal_Accept_SUB_MSG",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.SNACKBAR,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        await Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Staff_Request_Inbox(
                                      username: widget.username,
                                      password: widget.password,
                                    )));
                      } else {
                        print("nothing line 4953");
                      }
                    },
                    style: ElevatedButton.styleFrom(primary: Colors.green),
                    child: const Text("yes"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                    child: const Text("No"),
                  ),
                ],
              );
            }
          } else {
            return Container(
              color: Colors.white,
              child: Center(child: StudentsSearching(context)),
            );
          }
        });
  }
}

//club Activity
class Club_Activity extends StatefulWidget {
  const Club_Activity({
    Key? key,
    required this.username,
    required this.password,
  }) : super(key: key);
  final String username;
  final String password;

  @override
  State<Club_Activity> createState() => _Club_ActivityState();
}

class _Club_ActivityState extends State<Club_Activity> {
  late Future<Staff_List_Data_List> Staff_API_Data;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Club Activities',
            style: PrimaryText(context),
          ),
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(255, 98, 118, 1),
          elevation: 05.0,
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            TabBar(
              indicator: BoxDecoration(
                  color: const Color(0xFFF84259),
                  borderRadius: BorderRadius.circular(10)),
              tabs: [
                const Tab(
                  child: Text(
                    'Function',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                const Tab(
                  child: Text(
                    'Attendance',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
            Expanded(
                child: TabBarView(children: [
              Club_Function(
                username: widget.username,
                password: widget.password,
              ),
              Club_Attendance(
                username: widget.username,
                password: widget.password,
              ),
            ]))
          ],
        ),
      ),
    );
  }
}

//Club Function
class Club_Function extends StatefulWidget {
  const Club_Function(
      {Key? key, required this.username, required this.password})
      : super(key: key);
  final String username;
  final String password;

  @override
  State<Club_Function> createState() => _Club_FunctionState();
}

class _Club_FunctionState extends State<Club_Function> {
  late Future<Club_Fun_Data_List> Club_Fun_API_Data;
  late Future<AddClubFun_List> ADD_Club_Data;
  late Future<Staff_List_Data_List> Staff_API_Data;

  //final _keyFind = GlobalKey<FormState>();
  late List<String> Clubs = [];
  late List<String> Club_id = [];
  String? ClubToDate;
  String? ClubFromDate;
  String? From_To_Pass;
  String? txt;
  String? Clubid;
  bool checkboxValue1 = true;
  bool allnull = true;
  int? ClubFunIndex = 0;
  final _addFunname = GlobalKey<FormState>();
  final _addPrograme = GlobalKey<FormState>();
  final _addGuest = GlobalKey<FormState>();
  final _addLevel = GlobalKey<FormState>();
  final _addhigh = GlobalKey<FormState>();

  //String? addFunname;
  final addhigh = TextEditingController();
  final addFunname = TextEditingController();
  final addPrograme = TextEditingController();
  final addGuest = TextEditingController();
  final addLevel = TextEditingController();

  String? Accept_ClubFun_MSG;

  _addFun() {
    final form = _addFunname.currentState;
    if (form!.validate()) {
      form.save();
    }
  }

  _addPro() {
    final form = _addPrograme.currentState;
    if (form!.validate()) {
      form.save();
    }
  }

  _addLev() {
    final form = _addGuest.currentState;
    if (form!.validate()) {
      form.save();
    }
  }

  _addgue() {
    final form = _addLevel.currentState;
    if (form!.validate()) {
      form.save();
    }
  }

  _high() {
    final form = _addhigh.currentState;
    if (form!.validate()) {
      form.save();
    }
  }

  _fromdate() {
    final form = _addhigh.currentState;
    if (form!.validate()) {
      form.save();
    }
  }

  late List Responce_For_AddClubFun = [];

  Responce_ClubFunAdd() async {
    print(
        "http://$StaticIP/api/AddClubFun?StaffCode=${widget.username}&ClubFunId=0&ClubId=$Clubid&FunctionName=${addFunname.text}&FromDate=$ClubFromDate&ToDate=$ClubToDate&ProgrammeFor=${addPrograme.text}&Levels=${addLevel.text}&Highlights=${addhigh.text}&GuestDetails=${addGuest.text}&Password=${widget.password}");
    final resp = await http.get(Uri.parse(
        "http://$StaticIP/api/AddClubFun?StaffCode=${widget.username}&ClubFunId=0&ClubId=$Clubid&FunctionName=${addFunname.text}&FromDate=$ClubFromDate&ToDate=$ClubToDate&ProgrammeFor=${addPrograme.text}&Levels=${addLevel.text}&Highlights=${addhigh.text}&GuestDetails=${addGuest.text}&Password=${widget.password}"));
    if (resp.statusCode == 200) {
      Responce_For_AddClubFun = json.decode(resp.body);
      print('Send Succesfully');
      Accept_ClubFun_MSG = (Responce_For_AddClubFun[0]['msg'].toString());
      Fluttertoast.showToast(
          backgroundColor: Colors.deepPurple,
          msg: "Saved Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      print(
          "http://$StaticIP/api/AddClubFun?StaffCode=${widget.username}&ClubFunId=0&ClubId=$Clubid&FunctionName=${addFunname.text}&FromDate=$ClubFromDate&ToDate=$ClubToDate&ProgrammeFor=${addPrograme.text}&Levels=${addLevel.text}&Highlights=${addhigh.text}&GuestDetails=${addGuest.text}&Password=${widget.password}");
      await Fluttertoast.showToast(
          backgroundColor: Colors.grey,
          msg: "Already have a Same function Name",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void ClearText() {
    addFunname.clear();
    addPrograme.clear();
    addLevel.clear();
    addGuest.clear();
    addhigh.clear();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Club_Fun_Network clubFunNetwork = Club_Fun_Network(
        "ClubFunction?StaffCode=${widget.username}&Password=${widget.password}");
    Club_Fun_API_Data = clubFunNetwork.Fun_club_Data();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Club_Fun_API_Data,
        builder: (context,
            AsyncSnapshot<Club_Fun_Data_List> clubfunRequestsnapshot) {
          if (clubfunRequestsnapshot.hasError) {
            ErrorShowingWidget(context);
          }
          List<Club_Fun_Data> clubFun;
          if (clubfunRequestsnapshot.hasData) {
            clubFun = clubfunRequestsnapshot.data!.Club_fu_list;
            Clubs = [
              for (int i = clubFun.length - 1; i >= 0; i--) clubFun[i].txt
            ];
            Club_id = [
              for (int i = clubFun.length - 1; i >= 0; i--) "${clubFun[i].id}"
            ].reversed.toList();
            return Scaffold(
              backgroundColor: const Color.fromRGBO(242, 249, 250, 0.9),
              body: Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: sHeight(1.5, context),
                          ),
                          const Text(
                            "Club",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: sHeight(1, context),
                          ),
                          SizedBox(
                            width: sWidth(100, context),
                            height: sHeight(5, context),
                            child: FormField<String>(
                              builder: (FormFieldState<String> state) {
                                return DropdownButtonHideUnderline(
                                  child: DropdownSearch<String>(
                                    popupProps: const PopupProps.menu(),
                                    dropdownDecoratorProps:
                                        const DropDownDecoratorProps(),
                                    dropdownButtonProps: const DropdownButtonProps(
                                        // padding: EdgeInsets.symmetric(horizontal: 20.0),
                                        icon: Icon(Icons
                                            .arrow_drop_down_circle_rounded),
                                        color: Color.fromRGBO(255, 98, 118, 1)),
                                    items: Clubs,
                                    selectedItem: "Select clubs",
                                    onChanged: (value) {
                                      int passingClub =
                                          Clubs.indexOf(value.toString())
                                              .toInt();
                                      Clubid = Club_id[passingClub.toInt()];
                                      print(Clubid);
                                      // txt = value.toString();
                                      // print(txt);
                                      // ClubFunIndex = Clubs.indexOf(value!).toInt();
                                      // setState(() {
                                      // });
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: sHeight(2, context),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("From Date:",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600)),
                                  Container(
                                    height: 40,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(7),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // Text("From Date"),
                                        ClubFromDate == null
                                            ? const Text("Select")
                                            : Text("$ClubFromDate"),
                                        IconButton(
                                          onPressed: () async {
                                            showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime.now(),
                                              lastDate: DateTime(2026),
                                            ).then((value) async {
                                              ClubFromDate =
                                                  DateFormat('dd/MM/yyyy')
                                                      .format(value!);
                                              print(ClubFromDate);
                                              setState(() {});
                                            });
                                          },
                                          icon: const Icon(Icons.calendar_month,
                                              color: Color.fromRGBO(
                                                  255, 98, 118, 1)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("To Date:",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600)),
                                  Container(
                                    height: 40,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(7),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ClubToDate == null
                                            ? const Text("Select")
                                            : Text("$ClubToDate"),
                                        IconButton(
                                          onPressed: () async {
                                            showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime.now(),
                                              lastDate: DateTime(2026),
                                            ).then((value) async {
                                              ClubToDate =
                                                  DateFormat('dd/MM/yyyy')
                                                      .format(value!);
                                              setState(() {});
                                            });
                                            validator:
                                            (e) {
                                              if (e!.isEmpty) {
                                                return "From Date";
                                              }
                                              return null;
                                            };
                                          },
                                          icon: const Icon(Icons.calendar_month,
                                              color: Color.fromRGBO(
                                                  255, 98, 118, 1)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: sHeight(2, context),
                          ),
                          const Text(
                            "Function Name:",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: sHeight(1, context),
                          ),
                          Form(
                            key: _addFunname,
                            child: TextFormField(
                              controller: addFunname,
                              cursorColor: Colors.black,
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(
                                    RegExp(r'^\s')),
                              ],
                              validator: (e) {
                                if (e!.isEmpty) {
                                  return "Enter the Funtion Type";
                                }
                                return null;
                              },
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.9)),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 5.0,
                                ),
                                labelStyle: TextStyle(
                                    color: Colors.black.withOpacity(0.9),
                                    fontSize: 10),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                        width: 5, style: BorderStyle.none)),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: sHeight(2, context),
                          ),
                          const Text(
                            "Programme For: ",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: sHeight(1, context),
                          ),
                          Form(
                            key: _addPrograme,
                            child: TextFormField(
                              controller: addPrograme,
                              cursorColor: Colors.black,
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(
                                    RegExp(r'^\s')),
                              ],
                              validator: (e) {
                                if (e!.isEmpty) {
                                  return "Enter the Program For";
                                }
                                return null;
                              },
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.9)),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 5.0,
                                ),
                                labelStyle: TextStyle(
                                    color: Colors.black.withOpacity(0.9),
                                    fontSize: 10),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                        width: 5, style: BorderStyle.none)),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: sHeight(2, context),
                          ),
                          const Text(
                            "Level: ",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: sHeight(1, context),
                          ),
                          Form(
                            key: _addLevel,
                            child: TextFormField(
                              controller: addLevel,
                              cursorColor: Colors.black,
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(
                                    RegExp(r'^\s')),
                              ],
                              validator: (e) {
                                if (e!.isEmpty) {
                                  return "Enter the Level";
                                }
                                return null;
                              },
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.9)),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 5.0,
                                ),
                                labelStyle: TextStyle(
                                    color: Colors.black.withOpacity(0.9),
                                    fontSize: 10),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                        width: 5, style: BorderStyle.none)),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: sHeight(2, context),
                          ),
                          const Text(
                            "Guest Details: ",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: sHeight(1, context),
                          ),
                          Form(
                            key: _addGuest,
                            child: TextFormField(
                              controller: addGuest,
                              cursorColor: Colors.black,
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(
                                    RegExp(r'^\s')),
                              ],
                              validator: (e) {
                                if (e!.isEmpty) {
                                  return "Enter the Guest Details";
                                }
                                return null;
                              },
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.9)),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 5.0,
                                ),
                                labelStyle: TextStyle(
                                    color: Colors.black.withOpacity(0.9),
                                    fontSize: 10),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                        width: 5, style: BorderStyle.none)),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: sHeight(2, context),
                          ),
                          const Text(
                            "Highlights:",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: sHeight(1, context),
                          ),
                          Form(
                            key: _addhigh,
                            child: TextFormField(
                              controller: addhigh,
                              cursorColor: Colors.black,
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(
                                    RegExp(r'^\s')),
                              ],
                              validator: (e) {
                                if (e!.isEmpty) {
                                  return "Enter the Highlights";
                                }
                                return null;
                              },
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.9)),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 5.0,
                                ),
                                labelStyle: TextStyle(
                                    color: Colors.black.withOpacity(0.9),
                                    fontSize: 10),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                        width: 5, style: BorderStyle.none)),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: sHeight(2, context),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                height: sHeight(6, context),
                                width: sWidth(33, context),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    // background (button) color
                                    foregroundColor:
                                        Colors.white, // foreground (text) color
                                  ),
                                  onPressed: () async {
                                    // bool allnull = allnull([_addFun, _addPro, _addLev, _addgue, _high]);
                                    await _addFun();
                                    await _addPro();
                                    await _addLev();
                                    await _addgue();
                                    await _high();
                                    await _fromdate();
                                    if (_addFun == false &&
                                        _addPro == false &&
                                        _addLev == false &&
                                        _addgue == false &&
                                        _high == false) {
                                      /*  return  showDialog(
                                          context: context,
                                          barrierDismissible: true,
                                          builder: (context)=> AlertDialog(
                                            */ /* title: Row(
                                              children: [
                                                Text("")
                                              ],
                                            ),*/
                                      /*
                                              content: Container(
                                                height: sHeight(15, context),
                                                width: sWidth(60, context),
                                                child: Column(
                                                  children: [
                                                    Text("Pleace Select Session or Attendance type"),
                                                    SizedBox(height: sHeight(5, context),),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        InkWell(
                                                          child: Container(
                                                            height: sHeight(5, context),
                                                            width: sWidth(17, context),
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(10),
                                                              color: Colors.red,
                                                            ),
                                                            child: Center(child: Text("Back",style: ErrorText(),)),
                                                          ),
                                                          onTap: (){
                                                            Navigator.pop(context);
                                                          },
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              )
                                          )
                                      );*/
                                      await Fluttertoast.showToast(
                                          backgroundColor: Colors.red,
                                          msg: "Enter The Valid Information",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.SNACKBAR,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    } else {
                                      showDialog(
                                          context: context,
                                          barrierDismissible: true,
                                          builder: (context) => AlertDialog(
                                                  /* title: Row(
                                              children: [
                                                Text("")
                                              ],
                                            ),*/
                                                  content: SizedBox(
                                                height: sHeight(15, context),
                                                width: sWidth(60, context),
                                                child: Column(
                                                  children: [
                                                    const Text(
                                                        "Do you want to Create the club function?"),
                                                    SizedBox(
                                                      height:
                                                          sHeight(5, context),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        InkWell(
                                                          child: Container(
                                                            height: sHeight(
                                                                5, context),
                                                            width: sWidth(
                                                                17, context),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color: Colors.red,
                                                            ),
                                                            child: Center(
                                                                child: Text(
                                                              "NO",
                                                              style:
                                                                  ErrorText(),
                                                            )),
                                                          ),
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                        InkWell(
                                                          child: Container(
                                                            height: sHeight(
                                                                5, context),
                                                            width: sWidth(
                                                                17, context),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color:
                                                                  Colors.green,
                                                            ),
                                                            child: Center(
                                                                child: Text(
                                                              "Yes",
                                                              style:
                                                                  ErrorText(),
                                                            )),
                                                          ),
                                                          onTap: () async {
                                                            await Responce_ClubFunAdd();
                                                            ClearText();
                                                          },
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              )));
                                      //Navigator.pop(context);
                                    }
                                  },
                                  child: const Text(
                                    "Save",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: sHeight(6, context),
                                width: sWidth(33, context),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey,
                                    // background (button) color
                                    foregroundColor:
                                        Colors.white, // foreground (text) color
                                  ),
                                  onPressed: ClearText,
                                  child: const Text(
                                    "Reset",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: sHeight(3, context),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Container(
              color: Colors.white,
              child: Center(child: SearchingDataLottie(context)),
            );
          }
        });
  }
}

//Club Attendance
class Club_Attendance extends StatefulWidget {
  const Club_Attendance(
      {Key? key, required this.username, required this.password})
      : super(key: key);
  final String username;
  final String password;

  @override
  State<Club_Attendance> createState() => _Club_AttendanceState();
}

class _Club_AttendanceState extends State<Club_Attendance> {
  late Future<ClubAttend_List> ClubAttend_API;
  String CirATdate = DateFormat('dd/MM/yyyy').format(DateTime.now());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Clun_Attend_Network clunAttendNetwork = Clun_Attend_Network(
        "SelectClub?StaffCode=${widget.username}&FromDate=$CirATdate&ToDate=$CirATdate&Password=${widget.password}");
    ClubAttend_API = clunAttendNetwork.ClubA_loadData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ClubAttend_API,
      builder: (context, AsyncSnapshot<ClubAttend_List> ClubClassnapshot) {
        if (ClubClassnapshot.hasError) {
          ErrorShowingWidget(context);
        }
        List<ClubAttend_Data> Selectclub;
        print(ClubClassnapshot.error);
        if (ClubClassnapshot.hasData) {
          Selectclub = ClubClassnapshot.data!.Club_A_List;
          if (Selectclub.length > 0) {
            return Scaffold(
              backgroundColor: const Color.fromRGBO(242, 249, 250, 0.9),
              body: Builder(
                builder: (BuildContext context) => SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int i = 0; i <= Selectclub.length - 1; i++)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              child: Container(
                                //width: sWidth(90, context),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(7.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              Selectclub[i].ClubName,
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w800),
                                            ),
                                            Text(
                                              "From Date : ${Selectclub[i].FromDate}",
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w200),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 7.0),
                                        child: Row(
                                          children: [
                                            const Text(
                                              "Function Name : ",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                            Text(
                                              Selectclub[i].FunctionName,
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(7.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Guest : ${Selectclub[i].Guestname}",
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                            Text(
                                              "To Date : ${Selectclub[i].ToDate}",
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w200),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              onTap: () {
                                print("${Selectclub[i].Clubid}");
                                print("${Selectclub[i].id}");
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ClubAttend_Page(
                                              username: widget.username,
                                              password: widget.password,
                                              id: Selectclub[i].Clubid,
                                              Funtionid: Selectclub[i].id,
                                            )));
                              },
                            ),
                          )
                      ],
                    )),
              ),
            );
          } else {
            return Container(
              color: Colors.white,
              child: const Center(child: Text("No clubs found")),
            );
          }
        } else {
          return Container(
            color: Colors.white,
            child: Center(child: StudentsSearching(context)),
          );
        }
      },
    );
  }
}


//Club Attendance Select Page
class ClubAttend_Page extends StatefulWidget {
  const ClubAttend_Page(
      {Key? key,
      required this.id,
      required this.Funtionid,
      required this.username,
      required this.password})
      : super(key: key);
  final String username;
  final String password;
  final int id;
  final int Funtionid;

  @override
  State<ClubAttend_Page> createState() => _ClubAttend_PageState();
}

class _ClubAttend_PageState extends State<ClubAttend_Page> {
  late Future<ClubStud_List> Stud_Club_API;
  late Future<AttendTerms_List> Attendterms_API;

  //late ClubStud_Data ClubAt_API = widget.ClubAt_API;
  String CirATdate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  bool isClicked = false;
  int? One_Fn = 1;
  int? One_An = 1;
  String? Studentid;
  int? One_Both = 1;
  late List<String> Session_Type_FRom = ['FN', 'AN', 'BOTH'];
  late List<int> StudentNoList = [0];
  late List<LessonPlanPracticalAPI_data> FinalList = [];
  String? Accept_ClubFun_MSG;
  late List Responce_For_AddClubFun = [];
  late List<String> Terms = [];
  late List<String> AttendanceIds = [];
  String? Term;
  String? AttendId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ClubStud_Network clubstudNetwork = ClubStud_Network(
        "ClubAttend?StaffCode=${widget.username}&ClubId=${widget.id}&InstId=1&FunctionId=${widget.Funtionid}&SemSettingId=9&Date=$CirATdate&Password=${widget.password}");
    Stud_Club_API = clubstudNetwork.ClubStud_loadData();
    AttendTerms_Network attendtermsNetwork = AttendTerms_Network(
        "AttendanceTerms?StaffCode=${widget.username}&Password=${widget.password}");
    Attendterms_API = attendtermsNetwork.FinalTerms_LoadData();
  }

  @override
  Widget build(BuildContext context) {
    String list = "";
    for (int i = 0; i <= StudentNoList.length - 1; i++) {
      list = list + StudentNoList[i].toString();
      if (i != StudentNoList.length - 1) list = list + ",";
    }
    print(list);
    return FutureBuilder(
        future: Stud_Club_API,
        builder: (context, AsyncSnapshot<ClubStud_List> clubstudsnapshot) {
          if (clubstudsnapshot.hasError) {
            ErrorShowingWidget(context);
          }
          List<ClubStud_Data> data;
          if (clubstudsnapshot.hasData) {
            data = clubstudsnapshot.data!.Club_Stud_List;
            return FutureBuilder(
                future: Attendterms_API,
                builder:
                    (context, AsyncSnapshot<AttendTerms_List> termssnapshot) {
                  if (termssnapshot.hasError) {
                    ErrorShowingWidget(context);
                  }
                  List<Attend_data> terms;
                  if (termssnapshot.hasData) {
                    terms = termssnapshot.data!.AttendTerm_List;
                    Terms = [
                      for (int i = terms.length - 1; i >= 0; i--) terms[i].Term
                    ].reversed.toList();
                    AttendanceIds = [
                      for (int i = terms.length - 1; i >= 0; i--)
                        "${terms[i].AttendanceId}"
                    ].reversed.toList();
                    /*AttendanceIds = [
                     for (int i = terms.length - 1; i >= 0; i--) "${terms[i].AttendanceId}"
                   ].reversed.toList();*/
                    if (data.length > 0) {
                      return Scaffold(
                        appBar: AppBar(
                          title: Text(
                            'Club Attendance',
                            style: PrimaryText(context),
                          ),
                          centerTitle: true,
                          backgroundColor: const Color.fromRGBO(255, 98, 118, 1),
                          elevation: 05.0,
                        ),
                        body: Builder(
                            builder: (BuildContext context) =>
                                SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: sHeight(2, context),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          SizedBox(
                                            height: sHeight(6, context),
                                            width: sWidth(40, context),
                                            child: FormField<String>(
                                              builder: (FormFieldState<String>
                                                  state) {
                                                return DropdownButtonHideUnderline(
                                                  child: DropdownSearch<String>(
                                                    popupProps:
                                                        const PopupProps.menu(),
                                                    dropdownDecoratorProps:
                                                        const DropDownDecoratorProps(),
                                                    dropdownButtonProps:
                                                        const DropdownButtonProps(
                                                            // padding: EdgeInsets.symmetric(horizontal: 20.0),
                                                            icon: Icon(Icons
                                                                .arrow_drop_down_circle_rounded),
                                                            color:
                                                                Color.fromRGBO(
                                                                    255,
                                                                    98,
                                                                    118,
                                                                    1)),
                                                    items: Session_Type_FRom,
                                                    selectedItem: 'SESSION',
                                                    onChanged: (value) {
                                                      if (value.toString() ==
                                                          'FN'.toString()) {
                                                        One_Fn = 0.toInt();
                                                        One_An = -1;
                                                        One_Both = -1;
                                                        print(One_Fn);
                                                      }
                                                      if (value.toString() ==
                                                          'AN'.toString()) {
                                                        One_An = 1.toInt();
                                                        One_Fn = -1;
                                                        One_Both = -1;
                                                        print(One_An);
                                                      }
                                                      if (value.toString() ==
                                                          'BOTH'.toString()) {
                                                        One_Both = 2.toInt();
                                                        One_An = -1;
                                                        One_Fn = -1;
                                                        print(One_Both);
                                                      }
                                                    },
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            height: sHeight(6, context),
                                            width: sWidth(40, context),
                                            child: FormField<String>(
                                              builder: (FormFieldState<String>
                                                  state) {
                                                return DropdownButtonHideUnderline(
                                                  child: DropdownSearch<String>(
                                                    popupProps:
                                                        const PopupProps.menu(),
                                                    dropdownDecoratorProps:
                                                        const DropDownDecoratorProps(),
                                                    dropdownButtonProps:
                                                        const DropdownButtonProps(
                                                            // padding: EdgeInsets.symmetric(horizontal: 20.0),
                                                            icon: Icon(Icons
                                                                .arrow_drop_down_circle_rounded),
                                                            color:
                                                                Color.fromRGBO(
                                                                    255,
                                                                    98,
                                                                    118,
                                                                    1)),
                                                    items: Terms,
                                                    selectedItem: Terms[1],
                                                    //selectedItem: "Type",
                                                    onChanged: (value) {
                                                      int passingTerm =
                                                          Terms.indexOf(value
                                                                  .toString())
                                                              .toInt();
                                                      AttendId = AttendanceIds[
                                                          passingTerm.toInt()];
                                                      print(AttendId);
                                                      // txt = value.toString();
                                                      // print(txt);
                                                      // ClubFunIndex = Clubs.indexOf(value!).toInt();
                                                      // setState(() {
                                                      // });
                                                    },
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      for (int i = 0; i <= data.length - 1; i++)
                                        InkWell(
                                          child: ClubStudentListGenerator(
                                              context, data[i], StudentNoList),
                                          onTap: () {
                                            setState(() {});
                                            if (StudentNoList.contains(
                                                data[i].Studentid)) {
                                              StudentNoList.remove(
                                                  data[i].Studentid);
                                              FinalList.remove(data[i]);
                                            } else {
                                              StudentNoList.add(
                                                  data[i].Studentid);
                                              // FinalList.add(data[i]);
                                            }
                                            print("${data[i].Studentid}");
                                          },
                                        )
                                    ],
                                  ),
                                )),
                        floatingActionButton: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              child: Container(
                                width: 55,
                                height: 55,
                                margin: const EdgeInsets.only(left: 10.0),
                                decoration: PrimaryRoundBox(),
                                child: const Icon(
                                  Icons.check_sharp,
                                  color: Colors.white,
                                ),
                              ),
                              onTap: () async {
                                /*Navigator.pop(context);
                        Navigator.pop(context);*/
                                if (Terms == -1.toInt() &&
                                        One_An == 2.toInt() ||
                                    One_Fn == 1.toInt() ||
                                    One_Both == 1.toInt()) {
                                  return showDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (context) => AlertDialog(
                                              /* title: Row(
                                              children: [
                                                Text("")
                                              ],
                                            ),*/
                                              content: SizedBox(
                                            height: sHeight(15, context),
                                            width: sWidth(60, context),
                                            child: Column(
                                              children: [
                                                const Text(
                                                    "Pleace Select Session or Attendance type"),
                                                SizedBox(
                                                  height: sHeight(5, context),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    InkWell(
                                                      child: Container(
                                                        height:
                                                            sHeight(5, context),
                                                        width:
                                                            sWidth(17, context),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: Colors.red,
                                                        ),
                                                        child: Center(
                                                            child: Text(
                                                          "Back",
                                                          style: ErrorText(),
                                                        )),
                                                      ),
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          )));
                                  /*await Fluttertoast.showToast(
                                     backgroundColor: Colors.red,
                                     msg: "Kindly! Select From Date and Session",
                                     toastLength: Toast.LENGTH_SHORT,
                                     gravity: ToastGravity.SNACKBAR,
                                     textColor: Colors.white,
                                     fontSize: 16.0);*/
                                } else {
                                  showDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (context) => AlertDialog(
                                              /* title: Row(
                                              children: [
                                                Text("")
                                              ],
                                            ),*/
                                              content: SizedBox(
                                            height: sHeight(15, context),
                                            width: sWidth(60, context),
                                            child: Column(
                                              children: [
                                                const Text(
                                                    "Do you want to Submit the Attendance?"),
                                                SizedBox(
                                                  height: sHeight(5, context),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    InkWell(
                                                      child: Container(
                                                        height:
                                                            sHeight(5, context),
                                                        width:
                                                            sWidth(17, context),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: Colors.red,
                                                        ),
                                                        child: Center(
                                                            child: Text(
                                                          "NO",
                                                          style: ErrorText(),
                                                        )),
                                                      ),
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    InkWell(
                                                      child: Container(
                                                        height:
                                                            sHeight(5, context),
                                                        width:
                                                            sWidth(17, context),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: Colors.green,
                                                        ),
                                                        child: Center(
                                                            child: Text(
                                                          "Yes",
                                                          style: ErrorText(),
                                                        )),
                                                      ),
                                                      onTap: () async {
                                                        if (One_Fn != -1) {
                                                          print(
                                                              "${One_Fn!.toInt()}");
                                                          await Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) => ClubAttfinal(
                                                                      username:
                                                                          widget
                                                                              .username,
                                                                      Session:
                                                                          One_Fn!
                                                                              .toInt(),
                                                                      password:
                                                                          widget
                                                                              .password,
                                                                      id: widget
                                                                          .id,
                                                                      Studentid:
                                                                          list,
                                                                      Terms: AttendId
                                                                          .toString(),
                                                                      Funtionid:
                                                                          widget
                                                                              .Funtionid)));
                                                          print(One_Both);
                                                        } else if (One_An !=
                                                            -1) {
                                                          await Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) => ClubAttfinal(
                                                                      username:
                                                                          widget
                                                                              .username,
                                                                      password:
                                                                          widget
                                                                              .password,
                                                                      Session:
                                                                          One_An!
                                                                              .toInt(),
                                                                      id: widget
                                                                          .id,
                                                                      Studentid:
                                                                          list,
                                                                      Terms: AttendId
                                                                          .toString(),
                                                                      Funtionid:
                                                                          widget
                                                                              .Funtionid)));
                                                          print(One_An);
                                                        } else if (One_Both !=
                                                            -1) {
                                                          await Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) => ClubAttfinal(
                                                                      username:
                                                                          widget
                                                                              .username,
                                                                      password:
                                                                          widget
                                                                              .password,
                                                                      Session:
                                                                          One_Both!
                                                                              .toInt(),
                                                                      id: widget
                                                                          .id,
                                                                      Studentid:
                                                                          list,
                                                                      Terms: AttendId
                                                                          .toString(),
                                                                      Funtionid:
                                                                          widget
                                                                              .Funtionid)));
                                                          print(One_Fn);
                                                        } else if (One_Both !=
                                                            -1) {
                                                          await Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) => ClubAttfinal(
                                                                      username:
                                                                          widget
                                                                              .username,
                                                                      password:
                                                                          widget
                                                                              .password,
                                                                      Session:
                                                                          One_Both!
                                                                              .toInt(),
                                                                      id: widget
                                                                          .id,
                                                                      Studentid:
                                                                          list,
                                                                      Terms: AttendId
                                                                          .toString(),
                                                                      Funtionid:
                                                                          widget
                                                                              .Funtionid)));
                                                          print(One_Fn);
                                                        }
                                                      },
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          )));
                                  //Reason_Club_valid();
                                }
                                print(list);
                              },
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const Scaffold();
                    }
                  } else {
                    return const Scaffold();
                  }
                });
          } else {
            return Container(
              color: Colors.white,
              child: Center(child: StudentsSearching(context)),
            );
          }
        });
  }
}

// Final Send Attendance
class ClubAttfinal extends StatefulWidget {
  const ClubAttfinal(
      {Key? key,
      required this.Terms,
      required this.Session,
      required this.username,
      required this.password,
      required this.id,
      required this.Studentid,
      required this.Funtionid})
      : super(key: key);
  final String username;
  final String password;
  final int id;
  final int Funtionid;
  final String Studentid;
  final int Session;
  final String Terms;

  @override
  State<ClubAttfinal> createState() => _ClubAttfinalState();
}

class _ClubAttfinalState extends State<ClubAttfinal> {
  late Future<ClubFinalAttend_List> AttendFinalClub;
  late Future<ClubAttend_List> ClubAttend_API;
  String CirATdate = DateFormat('dd/MM/yyyy').format(DateTime.now());


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Club_Final_Network attendclubnetwork = Club_Final_Network(
        "clubstudattend?StaffCode=${widget.username}&SettingId=0&ClubId=${widget.Funtionid}&Date=$CirATdate&SemSettingId=9&StudId=${widget.Studentid.toString()}&AttendanceId=${widget.Terms}&Session=${widget.Session.toInt()}&Password=${widget.password}");
    AttendFinalClub = attendclubnetwork.FinalClub_LoadData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AttendFinalClub,
        builder: (context, AsyncSnapshot<ClubFinalAttend_List> Finalsnapshot) {
          if (Finalsnapshot.hasError) {
            ErrorShowingWidget(context);
          }
          print(Finalsnapshot.hasError);
          List<ClubFinalAttend_Data> dataClub;
          if (Finalsnapshot.hasData) {
            dataClub = Finalsnapshot.data!.ClubAtted_List;
            if (dataClub.length > 0) {
              return Scaffold(
                appBar: AppBar(
                  title: Text(
                    'Club Attendance',
                    style: PrimaryText(context),
                  ),
                  centerTitle: true,
                  backgroundColor: const Color.fromRGBO(255, 98, 118, 1),
                  elevation: 05.0,
                ),
                backgroundColor: const Color.fromRGBO(242, 249, 250, 0.9),
                body: Builder(
                    builder: (BuildContext context) => SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Center(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: sHeight(20, context),
                                ),
                                for (int i = dataClub.length - 1; i >= 0; i--)
                                  Text(
                                    dataClub[i].msg,
                                    style: PrimaryText2Big(),
                                  ),
                                InkWell(
                                  child: Container(
                                      margin: const EdgeInsets.only(top: 50.0),
                                      width: sWidth(50, context),
                                      height: sHeight(7, context),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      child: const Center(
                                        child: Text("OK",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20)),
                                      )),
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                        )),
              );
            } else {
              return Scaffold(
                appBar: AppBar(
                  title: Text(
                    'Club Attendance',
                    style: PrimaryText(context),
                  ),
                  centerTitle: true,
                  backgroundColor: const Color.fromRGBO(255, 98, 118, 1),
                  elevation: 05.0,
                ),
                body: Container(
                  color: Colors.white,
                  child: Center(
                      child: Image.asset("images/Dataimg/data_not_found.png")),
                ),
              );
            }
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  'Club Attendance',
                  style: PrimaryText(context),
                ),
                centerTitle: true,
                backgroundColor: const Color.fromRGBO(255, 98, 118, 1),
                elevation: 05.0,
              ),
              body: Container(
                color: Colors.white,
                child: Center(child: StudentsSearching(context)),
              ),
            );
          }
        });
  }
}


