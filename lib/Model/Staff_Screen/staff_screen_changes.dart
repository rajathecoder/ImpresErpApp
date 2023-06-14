import 'dart:async';
import 'dart:convert';

import 'package:add_dev_dolphin/Data/Staff_Data.dart';
import 'package:add_dev_dolphin/Data/Student_Data.dart';
import 'package:add_dev_dolphin/Model/Staff_Screen/staff_main.dart';
import 'package:add_dev_dolphin/Style_font/Staff_Screen_Design.dart';
import 'package:add_dev_dolphin/Style_font/designs.dart';
import 'package:add_dev_dolphin/UI/main_ui.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../../main.dart';
double sHeight(double per, BuildContext context){
  double h = MediaQuery.of(context).size.height;
  return h * per / 100;
}

double sWidth(double per, BuildContext context){
  double w = MediaQuery.of(context).size.width;
  return w * per / 100;
}
class StaffAttendanceTimetable extends StatefulWidget {
  const StaffAttendanceTimetable(
      {Key? key, required this.staffID, required this.StaffAPI})
      : super(key: key);
  final String staffID;
  final StaffAPI_data StaffAPI;

  @override
  _StaffAttendanceTimetableState createState() =>
      _StaffAttendanceTimetableState();
}

class _StaffAttendanceTimetableState extends State<StaffAttendanceTimetable> {
  late Future<StaffAttendanceTableData_List> AttendanceAPIData;
  late StaffAPI_data StaffAPI = widget.StaffAPI;
  void initState() {
    // TODO: implement initState
    super.initState();
    StaffAttendanceTableNetwork attendancenetwork = StaffAttendanceTableNetwork(
        "StaffHours?StaffCode=${StaffAPI.StaffCode}&ShowPrevDays=1&Password=${widget.staffID}");
    AttendanceAPIData = attendancenetwork.StaffAttendanceTableloadData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AttendanceAPIData,
        builder: (context,
            AsyncSnapshot<StaffAttendanceTableData_List> Attendancesnapshot) {
          if(Attendancesnapshot.hasError){
            ErrorShowingWidget(context);
          }
          List<StaffAttendanceTableAPI_data> Attendancedata;
          print(Attendancesnapshot.error);
          if (Attendancesnapshot.hasData) {
            Attendancedata =
                Attendancesnapshot.data!.StaffAttendanceTabledata_list;
            if (Attendancedata.length > 0) {
              return Scaffold(
                backgroundColor:  Color.fromRGBO(242, 249, 250, 0.9),
                appBar: AppBar(
                  title: Text(
                    "My Class",
                    style: PrimaryText(context),
                  ),
                  backgroundColor: Color(0xFFF84259),
                  elevation: 20.0,
                  centerTitle: true,
                ),
                body: Builder(
                    builder: (BuildContext context) => SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(height: sHeight(2, context),),
                                  Container(
                                    width: sWidth(90, context),
                                    padding: EdgeInsets.only(left: 20),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.all(Radius.circular(13),),),
                                    child: Column(
                                      children: [
                                        SizedBox(height: sHeight(1.5, context),),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                         Icon(Icons.date_range,color: Color.fromRGBO(150, 250, 195, 1),),
                                            SizedBox(width: sWidth(2, context),),
                                            Text("Date                :",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 16),),
                                            Text("   ${Attendancedata[0].Date}",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 16),)
                                          ],
                                        ),
                                        SizedBox(height: sHeight(1.5, context),),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Icon(Icons.school_sharp,color: Color.fromRGBO(150, 250, 195, 1),),
                                            SizedBox(width: sWidth(2, context),),
                                            Text("Sem Period   :",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 16),),
                                            Text("   ${Attendancedata[0].SemPeriodName}",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 16),)
                                          ],
                                        ),
                                        SizedBox(height: sHeight(2, context),),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: sHeight(2, context),),
                    Center(
                      child: Container(
                        height: sHeight(75, context),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              for (int i = 0;i <= Attendancedata.length -1;i++)
                                AttendanceClassList(context, Attendancedata, i, StaffAPI, widget.staffID),
                              //...
                            ],
                          ),
                        ),
                      ),
                    ),
                                ],
                              )
                            ],
                          ),
                    )),
              );
            } else {
              return Scaffold(
                appBar: AppBar(
                  title: Text(
                    "My Class",
                    style: PrimaryText(context),
                  ),
                  centerTitle: true,
                  backgroundColor: Color.fromRGBO(255, 98, 118, 1),
                  elevation: 20.0,
                ),
                body: Builder(
                    builder: (BuildContext context) => ListView(
                      scrollDirection: Axis.vertical,
                      children: <Widget>[
                        Image.asset('images/Dataimg/class_not_found.png',)
                      ],
                    )),
              );
            }
          } else {
            return Container(
              child: Center(child: SearchingDataLottie(context)),
              color: Colors.white,
            );
          }
        });
  }
}

class StaffAttendanceList extends StatefulWidget {
  const StaffAttendanceList(
      {Key? key, required this.StaffAPI, required this.AttendanceClassAPI, required this.staffID})
      : super(key: key);
  final StaffAPI_data StaffAPI;
  final StaffAttendanceTableAPI_data AttendanceClassAPI;
  final String staffID;

  @override
  _StaffAttendanceListState createState() => _StaffAttendanceListState();
}

class _StaffAttendanceListState extends State<StaffAttendanceList> {
  late Future<StudentListData_List> StudentListData;
  late StaffAttendanceTableAPI_data AttendanceClassAPI =
      widget.AttendanceClassAPI;
  late StaffAPI_data StaffAPI = widget.StaffAPI;
  late List <int> StudentNoList = [0];
  late List <StudentListAPI_data> FinalList = [];

  void initState() {
    // TODO: implement initState
    super.initState();
    StudentListNetwork attendancenetwork = StudentListNetwork(
        "StudentAttendance?FinalTimetableId=${AttendanceClassAPI.TimeTableId}&StaffCode=${StaffAPI.StaffCode}&Password=${widget.staffID}");
    StudentListData = attendancenetwork.StudentListloadData();
  }

  @override
  Widget build(BuildContext context) {
    int present = AttendanceClassAPI.Total -FinalList.length;
    int absent = FinalList.length;
    String list = "";
    for(int i = 0; i<=StudentNoList.length-1; i++)
    {
      list = list+StudentNoList[i].toString();
      if(i !=StudentNoList.length-1)
        list = list+",";
    }
    return FutureBuilder(
        future: StudentListData,
        builder:
            (context, AsyncSnapshot<StudentListData_List> Attendancesnapshot) {
              if(Attendancesnapshot.hasError){
                ErrorShowingWidget(context);
              }
          List<StudentListAPI_data> data;
          if (Attendancesnapshot.hasData) {
            data = Attendancesnapshot.data!.StudentListdata_list;
            if (data.length > 0) {
              return Scaffold(
                backgroundColor:  Color.fromRGBO(242, 249, 250, 0.9),
                appBar: AppBar(
                  title: Text(
                    "Attendance",
                    style: PrimaryText(context),
                  ),
                  backgroundColor: Color(0xFFF84259),
                  elevation: 20.0,
                ),
                body: Builder(
                    builder: (BuildContext context) => SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(height: sHeight(3, context),),
                                  Container(
                                    padding: EdgeInsets.only(left: 10,top: 30,right: 10),
                                    width: sWidth(90, context),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(Radius.circular(15),),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Date :  ${AttendanceClassAPI.Date}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w800),),
                                            Text("Total :  ${AttendanceClassAPI.Total.toString()} Students",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w800),),
                                          ],
                                        ),
                                        SizedBox(height: sHeight(1.5, context),),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Class     :  ${AttendanceClassAPI.ClassName}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w800),),
                                          ],
                                        ),
                                        SizedBox(height: sHeight(1.5, context),),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Present :  ${present.toString()}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w800),),
                                            Text("Absent :  ${absent.toString()}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w800),),
                                          ],
                                        ),
                                        SizedBox(height: sHeight(1.5, context),),
                                      ],
                                    ),
                                  ),
                                 SizedBox(height: sHeight(2, context),),
                    Center(
                      child: Container(
                        height: sHeight(75, context),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              for (int i = 0; i <= data.length - 1; i++)
                                InkWell(
                                  child: StudentListGenerator(context, data[i], StudentNoList),
                                  onTap: () {
                                    setState(() {});
                                    if(StudentNoList.contains(data[i].StudentId))
                                    {
                                      StudentNoList.remove(data[i].StudentId);
                                      FinalList.remove(data[i]);
                                    }
                                    else{
                                      StudentNoList.add(data[i].StudentId);
                                      FinalList.add(data[i]);
                                    }
                                  },),
                            ],
                          ),
                        ),
                      ),
                    ),

                                  SizedBox(height: sHeight(8, context),),
                                ],
                              )
                            ],
                          ),
                    )),
                //bottomNavigationBar: BottomNavigationBar(items: [],),
                floatingActionButton: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      child: Container(
                        width: 55,
                        height: 55,
                        decoration: PrimaryRoundBox(),
                        child: Icon(Icons.fact_check_outlined, color: Colors.white,),
                      ),
                      onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=>AttendanceCheck(
                        StaffAPI: StaffAPI, AttendanceClassAPI: AttendanceClassAPI, StudentList: FinalList, StudentNoList: StudentNoList,staffID: widget.staffID,))),
                    ),
                    InkWell(
                      child: Container(
                        width: 55,
                        height: 55,
                        margin: EdgeInsets.only(left: 10.0),
                        decoration: PrimaryRoundBox(),
                        child: Icon(Icons.check_sharp, color: Colors.white,),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>AttendanceMark(

                        StaffAPI: StaffAPI, AttendanceClassAPI: AttendanceClassAPI, list: list,staffID: widget.staffID,)));
                      },
                    ),
                  ],
                ),
              );
            } else {
              return Scaffold(
                appBar: AppBar(
                  title: Text(
                    "Attendance",
                    style: PrimaryText(context),
                  ),
                  backgroundColor: Color(0xFFF84259),
                  elevation: 20.0,
                ),
                body: Builder(
                    builder:(BuildContext context) => ListView(
                      scrollDirection: Axis.vertical,
                      children: <Widget>[
                        Image.asset('images/Dataimg/data_not_found.png',)
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
  }

}

class StaffAttendanceView extends StatefulWidget {
  const StaffAttendanceView(
      {Key? key, required this.StaffAPI, required this.AttendanceClassAPI, required this.staffID})
      : super(key: key);
  final StaffAPI_data StaffAPI;
  final StaffAttendanceTableAPI_data AttendanceClassAPI;
  final String staffID;


  @override
  _StaffAttendanceViewState createState() => _StaffAttendanceViewState();
}

class _StaffAttendanceViewState extends State<StaffAttendanceView> {
  late Future<StudentListData_List> StudentListData;
  late StaffAttendanceTableAPI_data AttendanceClassAPI =
      widget.AttendanceClassAPI;
  late StaffAPI_data StaffAPI = widget.StaffAPI;
  late List <String> StudentList = [""];
  late List <StudentListAPI_data> FinalList = [];

  void initState() {
    // TODO: implement initState
    super.initState();
    StudentListNetwork attendancenetwork = StudentListNetwork(
        "StudentAttendance?FinalTimetableId=${AttendanceClassAPI.TimeTableId}&StaffCode=${StaffAPI.StaffCode}&Password=${widget.staffID}");
    StudentListData = attendancenetwork.StudentListloadData();
  }

  @override
  Widget build(BuildContext context) {
    int present = AttendanceClassAPI.Total -FinalList.length;
    return FutureBuilder(
        future: StudentListData,
        builder:
            (context, AsyncSnapshot<StudentListData_List> Attendancesnapshot) {
              if(Attendancesnapshot.hasError){
                ErrorShowingWidget(context);
              }
          List<StudentListAPI_data> data;
          if (Attendancesnapshot.hasData) {
            data = Attendancesnapshot.data!.StudentListdata_list;
            if (data.length > 0) {
              return Scaffold(
                appBar: AppBar(
                  title: Text(
                    "Attendance",
                    style: PrimaryText(context),
                  ),
                  centerTitle: true,
                  backgroundColor: PrimaryColor(),
                  elevation: 20.0,
                ),
                body: Builder(
                    builder: (BuildContext context) => ListView(
                      scrollDirection: Axis.vertical,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.only(bottom: 20.0)),
                            StaffProfile1(context, StaffAPI.StaffImg, StaffAPI.StaffName),
                            StaffInfoDesign(context, "", "Staff Code", StaffAPI.StaffCode, "Designation", StaffAPI.Designation, "", ""),
                            Container(margin: EdgeInsets.only(bottom: 10.0)),
                            DividerDesign(3.0),
                            Container(margin: EdgeInsets.only(bottom: 10.0)),
                            StaffInfoDesign(context, "Attendance", "Hour", AttendanceClassAPI.Hour.toString(), "Date", AttendanceClassAPI.Date, "Class", AttendanceClassAPI.ClassName),
                            Container(margin: EdgeInsets.only(bottom: 10.0)),
                            for (int i = 0; i <= data.length - 1; i++)
                              StudentListViewer(context, data[i]),
                            StaffInfoDesign(context, "Summary", "Total", AttendanceClassAPI.Total.toString(),
                                "Present", present.toString(), "Absent", AttendanceClassAPI.Absent.toString()),
                            Container(
                                margin: EdgeInsets.only(bottom: 10.0)),
                          ],
                        )
                      ],
                    )),
              );
            } else {
              return Scaffold(
                appBar: AppBar(
                  title: Text(
                    "Attendance",
                    style: PrimaryText(context),
                  ),
                  backgroundColor: Color(0xFFF84259),
                  elevation: 20.0,
                ),
                body: Builder(
                    builder: (BuildContext context) => ListView(
                      children: <Widget>[
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
  }
}

class AttendanceCheck extends StatefulWidget {
  const AttendanceCheck({Key? key, required this.StaffAPI, required this.AttendanceClassAPI, required this.StudentList, required this.StudentNoList, required this.staffID}) : super(key: key);
  final StaffAPI_data StaffAPI;
  final StaffAttendanceTableAPI_data AttendanceClassAPI;
  final List<StudentListAPI_data> StudentList;
  final List<int>StudentNoList;
  final String staffID;
  @override
  _AttendanceCheckState createState() => _AttendanceCheckState();
}

class _AttendanceCheckState extends State<AttendanceCheck> {
  late StaffAttendanceTableAPI_data AttendanceClassAPI =
      widget.AttendanceClassAPI;
  late StaffAPI_data StaffAPI = widget.StaffAPI;
  late List <StudentListAPI_data> StudentList = widget.StudentList;
  late List <int> StudentNoList = widget.StudentNoList;
  @override
  Widget build(BuildContext context) {
    int present = AttendanceClassAPI.Total-StudentList.length;
    String list = "";
    for(int i = 0; i<=StudentNoList.length-1; i++)
    {
      list = list+StudentNoList[i].toString();
      if(i !=StudentNoList.length-1)
        list = list+",";
    }
    if (StudentList.length>0)
      return Scaffold(
        backgroundColor:  Color.fromRGBO(242, 249, 250, 0.9),
        appBar: AppBar(
          title: Text(
            "Attendance Check",
            style: TextStyle(fontSize: 25,fontWeight: FontWeight.w900,color: Colors.white),
          ),
          backgroundColor: Color(0xFFF84259),
          elevation: 20.0,
        ),
      body: Builder(
          builder: (BuildContext context) => SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: sHeight(2, context),),
                    Container(
                      width: sWidth(90, context),
                      decoration: BoxDecoration(
                        color: Color(0xFF7C6AFF),
                        borderRadius: BorderRadius.all(Radius.circular(10),),
                      ),
                      child: Container(
                        padding: EdgeInsets.only(left: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: sHeight(1, context),),
                            Text("Hour   :  ${AttendanceClassAPI.Hour}",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w800,color: Colors.white),) ,
                            SizedBox(height: sHeight(0.5, context),),
                            Text("Date    :  ${AttendanceClassAPI.Date}",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w800,color: Colors.white),),
                            SizedBox(height: sHeight(0.5, context),),
                            Text("Class  :   ${AttendanceClassAPI.ClassName}",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w800,color: Colors.white),),
                            SizedBox(height: sHeight(1, context),),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: sHeight(2, context),),
                    Container(
                      width: sWidth(90, context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: sHeight(5, context),
                            decoration: BoxDecoration(
                              color: Color(0xFF1977F3),
                              borderRadius: BorderRadius.all(Radius.circular(5),)
                            ),
                            child: Center(child: Text("  Total : ${AttendanceClassAPI.Total}  ",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.white),),),
                          ),
                          Container(
                            height: sHeight(5, context),
                            decoration: BoxDecoration(
                              color: Color(0xFF2FB869),
                              borderRadius: BorderRadius.all(Radius.circular(5),)
                            ),
                            child: Center(child: Text("  Present : ${present.toString()}  ",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.white),),),
                          ),
                          Container(
                            height: sHeight(5, context),
                            decoration: BoxDecoration(
                              color: Color(0xFFF31954),
                              borderRadius: BorderRadius.all(Radius.circular(5),)
                            ),
                            child: Center(child: Text("  Absent : ${StudentList.length.toString()}  ",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.white),),),
                          ),

                        ],
                      ),
                    ),
                    SizedBox(height: sHeight(2, context),),
          Container(
              height: sHeight(75, context) ,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (int i = 0; i <= StudentList.length - 1; i++)
                    StudentListGenerator(context, StudentList[i], StudentNoList),
                ],
              ),
            ),
          ),

                    Container(
                        margin: EdgeInsets.only(bottom: 10.0)),
                  ],
                )
              ],
            ),
          )),
      floatingActionButton: InkWell(
        child: Container(
          width: 55,
          height: 55,
          decoration: PrimaryRoundBox(),
          child: Icon(Icons.check_sharp, color: Colors.white,),
        ),
        onTap: () {
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context)=>AttendanceMark(
          StaffAPI: StaffAPI, AttendanceClassAPI: AttendanceClassAPI, list: list, staffID: widget.staffID,)));
        },
      ),
    );
    else
      return Scaffold(
        backgroundColor: Color.fromRGBO(242, 249, 250, 0.9),
        appBar: AppBar(
          title: Text(
            "Attendance Check",
            style: TextStyle(fontSize: 25,fontWeight: FontWeight.w900,color: Colors.white),
          ),
          backgroundColor: Color(0xFFF84259),
          elevation: 20.0,
        ),
        body: Builder(
            builder: (BuildContext context) => ListView(
              scrollDirection: Axis.vertical,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: sHeight(2, context),),
                    Container(
                      width: sWidth(90, context),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10),),
                      ),
                      child: Container(
                        padding: EdgeInsets.only(left: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: sHeight(1, context),),
                            Text("Hour   :  ${AttendanceClassAPI.Hour}",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w800,),) ,
                            SizedBox(height: sHeight(0.5, context),),
                            Text("Date    :  ${AttendanceClassAPI.Date}",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w800,),),
                            SizedBox(height: sHeight(0.5, context),),
                            Text("Class  :   ${AttendanceClassAPI.ClassName}",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w800,),),
                            SizedBox(height: sHeight(1, context),),
                            Container(
                              height: sHeight(5, context),
                              width: sWidth(80, context),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.all(Radius.circular(10),),
                              ),
                              child: Center(child: Text("   All Present   ",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w700,color: Colors.white),)),
                            ),
                            SizedBox(height: sHeight(1, context),),
                          ],
                        ),
                      ),
                    ),

                    Container(
                        margin: EdgeInsets.only(bottom: 10.0)),
                  ],
                )
              ],
            )),
        floatingActionButton: InkWell(
          child: Container(
            width: 55,
            height: 55,
            decoration: PrimaryRoundBox(),
            child: Icon(Icons.check_sharp, color: Colors.white,),
          ),
          onTap: () {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context)=>AttendanceMark(
            StaffAPI: StaffAPI, AttendanceClassAPI: AttendanceClassAPI, list: list, staffID: widget.staffID,)));
          },
        ),
      );
  }
}

class AttendanceMark extends StatefulWidget {
  const AttendanceMark({Key? key, required this.StaffAPI, required this.AttendanceClassAPI, required this.list, required this.staffID}) : super(key: key);
  final StaffAPI_data StaffAPI;
  final StaffAttendanceTableAPI_data AttendanceClassAPI;
  final String list;
  final String staffID;
  @override
  @override
  _AttendanceMarkState createState() => _AttendanceMarkState();
}

class _AttendanceMarkState extends State<AttendanceMark> {
  late StaffAttendanceTableAPI_data AttendanceClassAPI =
      widget.AttendanceClassAPI;
  late StaffAPI_data StaffAPI = widget.StaffAPI;
  late String list = widget.list;
  late Future <MarkingData_List> MarkingAPIData;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    MarkingNetwork network = MarkingNetwork(
        "AttendanceEntry?FinalTimeTableId=${AttendanceClassAPI.TimeTableId}&AttenStatusId=0&StudList=${list}&StaffCode=${StaffAPI.StaffCode}&Password=${widget.staffID}");
    MarkingAPIData = network.MarkingloadData();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: MarkingAPIData,
        builder:
            (context, AsyncSnapshot<MarkingData_List> Attendancesnapshot) {
          List<MarkingAPI_data> data;
          print(Attendancesnapshot.error);
          if(Attendancesnapshot.hasError){
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  "Attendance",
                  style: PrimaryText(context),
                ),
                centerTitle: true,
                backgroundColor: Color(0xFFF84259),
                elevation: 20.0,
              ),
              body: Builder(
                  builder: (BuildContext context) => ListView(
                    children: <Widget>[
                      SizedBox(
                        height: sHeight(10, context),
                      ),
                      Center(
                          child: Text(
                            "Error\nPlease try again later",
                            style: ErrorText2Big(),
                            textAlign: TextAlign.center,
                          )),
                      SizedBox(
                        height: sHeight(10, context),
                      ),
                      InkWell(
                        child: Container(
                            margin: EdgeInsets.only(top: 50.0),
                            width: 200,
                            height: 70,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Center(
                              child: Text("OK", style: TextStyle(color: Colors.white,fontSize: 20)),
                            )),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => StaffLessonPlan(staffID: widget.staffID, StaffAPI: StaffAPI)));
                        },
                      ),
                    ],
                  )),
            );
          }
          else{
            if (Attendancesnapshot.hasData) {
              data = Attendancesnapshot.data!.Markingdata_list;
              if (data.length > 0) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text(
                      "Attendance",
                      style: PrimaryText(context),
                    ),
                    centerTitle: true,
                    backgroundColor: Color(0xFFF84259),
                    elevation: 20.0,
                  ),
                  body: Builder(
                      builder: (BuildContext context) => SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: sHeight(10, context),
                              ),
                              Center(child: Text(data[0].msg, style: PrimaryText2Big(),),),
                              InkWell(
                                child: Container(
                                    margin: EdgeInsets.only(top: 50.0),
                                    width: 200,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Center(
                                      child: Text("OK", style: TextStyle(color: Colors.white,fontSize: 20)),
                                    )),
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => StaffLessonPlan(staffID: widget.staffID, StaffAPI: StaffAPI)));
                                },
                              ),
                            ],
                          )
                        ],
                        )
                      )),
                );
              } else {
                return Scaffold(
                  appBar: AppBar(
                    title: Text(
                      "Attendance",
                      style: PrimaryText(context),
                    ),
                    centerTitle: true,
                    backgroundColor: Color(0xFFF84259),
                    elevation: 20.0,
                  ),
                  body: Builder(
                      builder: (BuildContext context) => ListView(
                        children: <Widget>[
                          SizedBox(
                            height: sHeight(10, context),
                          ),
                          Center(
                              child: Text(
                                "Please try again later",
                                style: ErrorText2Big(),
                                textAlign: TextAlign.center,
                              )),
                          InkWell(
                            child: Container(
                                margin: EdgeInsets.only(top: 50.0),
                                width: 200,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Center(
                                  child: Text("OK", style: TextStyle(color: Colors.white,fontSize: 20)),
                                )),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => StaffLessonPlan(staffID: widget.staffID, StaffAPI: StaffAPI)));
                            },
                          ),
                        ],
                      )),
                );
              }
            }
            else {
              return Container(
                child: Center(child: CircularProgressIndicator()),
                color: Colors.white,
              );
            }
          }

        });

  }
}

class StaffTimetable extends StatefulWidget {
  const StaffTimetable({Key? key, required this.staffID, required this.StaffAPI,}) : super(key: key);
  final String staffID;
  final StaffAPI_data StaffAPI;

  @override
  _StaffTimetableState createState() => _StaffTimetableState();
}

class _StaffTimetableState extends State<StaffTimetable> {
  late Future<StaffTimetableData_List> AttendanceAPIData;
  late StaffAPI_data StaffAPI = widget.StaffAPI;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StaffTimetableNetwork attendancenetwork = StaffTimetableNetwork(
        "TimeTableStaff?StaffCode=${StaffAPI.StaffCode}&Password=${widget.staffID}");
    AttendanceAPIData = attendancenetwork.StaffTimetableloadData();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AttendanceAPIData,
        builder: (context,
            AsyncSnapshot<StaffTimetableData_List> Attendancesnapshot) {
          if(Attendancesnapshot.hasError){
            ErrorShowingWidget(context);
          }
          List<StaffTimetableAPI_data> Attendancedata;
          print(Attendancesnapshot.error);
          if (Attendancesnapshot.hasData) {
            Attendancedata =
                Attendancesnapshot.data!.StaffTimetabledata_list;
            if (Attendancedata.length > 0) {
              return Scaffold(
                backgroundColor: Color.fromRGBO(239, 242, 252, 0.9),
                appBar: AppBar(
                  title: Text(
                    "Time Table",
                    style: PrimaryText(context),
                  ),
                  centerTitle: true,
                  backgroundColor: Color.fromRGBO(255, 98, 118, 1),
                  elevation: 20.0,
                ),
                body: Builder(
                    builder: (BuildContext context) => SingleChildScrollView(
                      child: Column(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            SizedBox(height: sHeight(3, context),),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),),),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Column(
                                  children: <Widget> [
                                    StaffDisplayTimetable(context, Attendancedata)
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    )),),
              );
            } else {
              return Scaffold(
                appBar: AppBar(
                  title: Text(
                    "My Class",
                    style: PrimaryText(context),
                  ),
                  centerTitle: true,
                  backgroundColor: Color.fromRGBO(255, 98, 118, 1),
                  elevation: 20.0,
                ),
                body: Builder(
                    builder: (BuildContext context) => ListView(
                      scrollDirection: Axis.vertical,
                      children: <Widget>[
                        Image.asset('images/Dataimg/class_not_found.png',)
                      ],
                    )),
              );
            }
          } else {
            return Container(
              child: Center(child: SearchingDataLottie(context)),
              color: Colors.white,
            );
          }
        });
  }
}

class StaffHoliday extends StatefulWidget {
  const StaffHoliday({Key? key, required this.staffID, required this.StaffAPI}) : super(key: key);
  final String staffID;
  final StaffAPI_data StaffAPI;

  @override
  _StaffHolidayState createState() => _StaffHolidayState();
}

class _StaffHolidayState extends State<StaffHoliday> {
  late Future<StaffHolidayData_List> StaffHolidayAPIData;
  late StaffAPI_data StaffAPI = widget.StaffAPI;
  DateTime today = DateTime.now();
  void  _onDaySelected(DateTime day, DateTime focusedday){
    setState(() {
      today=day;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StaffHolidayNetwork StaffHolidaynetwork = StaffHolidayNetwork(
        "Holiday?StaffCode=${StaffAPI.StaffCode}&Password=${widget.staffID}");
    StaffHolidayAPIData = StaffHolidaynetwork.StaffHolidayloadData();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: StaffHolidayAPIData,
        builder: (context,
            AsyncSnapshot<StaffHolidayData_List> StaffHolidaysnapshot) {
          print(StaffHolidaysnapshot.error);
          if(StaffHolidaysnapshot.hasError){
            ErrorShowingWidget(context);
          }
          List<StaffHolidayAPI_data> StaffHolidaydata;
          print(StaffHolidaysnapshot.error);
          if (StaffHolidaysnapshot.hasData) {
            StaffHolidaydata =
                StaffHolidaysnapshot.data!.StaffHolidaydata_list;
            if (StaffHolidaydata.length > 0) {
              return Scaffold(
                backgroundColor:  Color.fromRGBO(242, 249, 250, 0.9),
                appBar: AppBar(
                  title: Text(
                    "Holidays",
                    style: PrimaryText(context),
                  ),
                  centerTitle: true,
                  backgroundColor: Color.fromRGBO(255, 98, 118, 1),
                  elevation: 20.0,
                ),
                body: Builder(
                    builder: (BuildContext context) => SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Container(
                                width: sWidth(90, context),
                                margin: EdgeInsets.only(left: 15,right: 15),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                              ),

                              SizedBox(height: sHeight(2, context),),
                              for(int i = 0; i<= StaffHolidaydata.length-1; i++)
                                StaffHolidayGenerator(context, StaffHolidaydata[i]),
                              Container(
                                  margin: EdgeInsets.only(bottom: 15.0)),
                              // Container(
                              //   margin: EdgeInsets.only(left: 15.0),
                              //   child: Text("Summary", style: PrimaryText2Big()),
                              // ),
                              // Container(
                              //   width: MediaQuery.of(context).size.width,
                              //   height: 60,
                              //   child: ListView(
                              //     scrollDirection: Axis.horizontal,
                              //     children: <Widget>[
                              //       Container(
                              //         margin: EdgeInsets.only(top: 15.0, bottom: 15.0),
                              //         child: Row(
                              //           crossAxisAlignment: CrossAxisAlignment.start,
                              //           children: <Widget>[
                              //             Container(
                              //               margin: EdgeInsets.only(left: 20),
                              //               child: Text("Total Holidays :", style: PrimaryText2(), textAlign: TextAlign.center,),
                              //             ),
                              //             Container(
                              //               margin: EdgeInsets.only(left: 20, right: 20.0),
                              //               child: Text(StaffHolidaydata.length.toString(), style: SecondaryText2(), textAlign: TextAlign.center),
                              //             ),
                              //           ],
                              //         ),
                              //       )
                              //     ],
                              //   ),
                              // ),
                              // Container(
                              //     margin: EdgeInsets.only(bottom: 15.0)),
                            ],
                          )
                        ],
                      ),
                    )),
              );
            } else {
              return Scaffold(
                appBar: AppBar(
                  title: Text(
                    "Holidays",
                    style: PrimaryText(context),
                  ),
                  centerTitle: true,
                  backgroundColor: Color.fromRGBO(255, 98, 118, 1),
                  elevation: 20.0,
                ),
                body: Builder(
                    builder:(BuildContext context) => ListView(
                      scrollDirection: Axis.vertical,
                      children: <Widget>[
                        Image.asset('images/Dataimg/data_not_found.png',),
                      ],
                    )),
              );
            }
          } else {
            return Container(
              child: Center(child: SearchingDataLottie(context)),
              color: Colors.white,
            );
          }
        });
  }
}

class StaffCircular extends StatefulWidget {
  const StaffCircular({Key? key, required this.staffID, required this.StaffAPI}) : super(key: key);
  final String staffID;
  final StaffAPI_data StaffAPI;

  @override
  _StaffCircularState createState() => _StaffCircularState();
}

class _StaffCircularState extends State<StaffCircular> {
  late Future<StaffCircularData_List> StaffCircularAPIData;
  late StaffAPI_data StaffAPI = widget.StaffAPI;
  String CirATdate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StaffCircularNetwork StaffCircularnetwork = StaffCircularNetwork(
        "Circular?StaffCode=${StaffAPI.StaffCode}&FromDateStr=01/01/2020&ToDateStr=${CirATdate}&Password=${widget.staffID}");
    StaffCircularAPIData = StaffCircularnetwork.StaffCircularloadData();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: StaffCircularAPIData,
        builder: (context,
            AsyncSnapshot<StaffCircularData_List> StaffCircularsnapshot) {
          if(StaffCircularsnapshot.hasError){
            ErrorShowingWidget(context);
          }
          List<StaffCircularAPI_data> StaffCirculardata;
          print(StaffCircularsnapshot.error);
          if (StaffCircularsnapshot.hasData) {
            StaffCirculardata =
                StaffCircularsnapshot.data!.StaffCirculardata_list;
            if (StaffCirculardata.length > 0) {
              return Scaffold(
                backgroundColor:  Color.fromRGBO(242, 249, 250, 0.9),
                appBar: AppBar(
                  title: Text(
                    "Circulars",
                    style: PrimaryText(context),
                  ),
                  centerTitle: true,
                  backgroundColor: Color.fromRGBO(255, 98, 118, 1),
                  elevation: 20.0,
                ),
                body: Builder(
                    builder: (BuildContext context) => SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              for(int i = 0; i<= StaffCirculardata.length-1; i++)
                                StaffCircularGenerator(context, StaffCirculardata[i]),
                              Container(
                                  margin: EdgeInsets.only(bottom: 15.0)),
                            ],
                          )
                        ],
                      ),
                    )),
              );
            } else {
              return Scaffold(
                body: Builder(
                    builder:(BuildContext context) => ListView(
                      scrollDirection: Axis.vertical,
                      children: <Widget>[
                        Image.asset('images/Dataimg/data_not_found.png',)
                      ],
                    )),
              );
            }
          } else {
            return Container(
              child: Center(child: SearchingDataLottie(context)),
              color: Colors.white,
            );
          }
        });
  }
}

class StaffOpac extends StatefulWidget {
  const StaffOpac({Key? key, required this.staffID, required this.StaffAPI}) : super(key: key);
  final String staffID;
  final StaffAPI_data StaffAPI;

  @override
  _StaffOpacState createState() => _StaffOpacState();
}

class _StaffOpacState extends State<StaffOpac> {
  late Future<StaffOPACData_List> StaffOPACAPIData;
  late StaffAPI_data StaffAPI = widget.StaffAPI;
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
  final _StaBookFind = GlobalKey<FormState>();
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
    StaffOPACNetwork StaffOPACnetwork = StaffOPACNetwork(
        "opac");
    StaffOPACAPIData = StaffOPACnetwork.StaffOPACloadData();
    checkInternet();
  }
  Sta_Search_Book(){
    final form =_StaBookFind.currentState;
    if(form!.validate()){
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => StaffOpacSearch(
        staffID: widget.staffID, StaffAPI: StaffAPI, Search: Search,
        RecordIndex: RecordIndex, ItemID: ItemID, SearchTypeIndex: SearchTypeIndex,)));
    }
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: StaffOPACAPIData,
        builder: (context,
            AsyncSnapshot<StaffOPACData_List> StaffOPACsnapshot) {
          if(StaffOPACsnapshot.hasError){
            ErrorShowingWidget(context);
          }
          List<StaffOPACAPI_data> StaffOPACdata;
          if (StaffOPACsnapshot.hasData) {
            StaffOPACdata =
                StaffOPACsnapshot.data!.StaffOPACdata_list;
            if (StaffOPACdata.length > 0) {
              if(done == false)
                {
                  for(int i =0; i<= StaffOPACdata.length-1; i++){
                    ItemListName.add(StaffOPACdata[i].Name);
                    ItemListID.add(StaffOPACdata[i].LibararyId);}
                  done = true;
                }
              return Scaffold(
                // backgroundColor:  Color.fromRGBO(242, 249, 250, 0.9),
                body: Builder(
                    builder: (BuildContext context) => SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.only(bottom: 10.0)),
                            Container(
                              padding: EdgeInsets.only(left: 10,right: 10),
                              child: Column(
                                children: [
                                  SizedBox(height: sHeight(3, context),),
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
                                      Text("Select Library",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w900,)),
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
                                            child: ClipRRect(
                                                borderRadius: BorderRadius.all(Radius.circular(15),),
                                                child: Image.asset("images/introscreen/libary_pic.png",fit: BoxFit.cover,)),
                                          ),
                                          Container(
                                              margin: EdgeInsets.only(top: 110,left: 10),
                                              child: Text(
                                                'Library',
                                                style: TextStyle(color: Colors.white,
                                                    fontWeight: FontWeight.w900,
                                                    fontSize: 23.0),
                                              )),
                                          Container(
                                            margin: EdgeInsets.only(left: 45),
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
                                     dropdownButtonProps: DropdownButtonProps(
                                       // padding: EdgeInsets.symmetric(horizontal: 20.0),
                                         icon: Icon(Icons.arrow_drop_down_circle_rounded),
                                         color: Colors.green
                                     ),
                                      items: SearchType,
                                    selectedItem: 'Search by',
                                        onChanged: (value) {
                                        SearchTypeIndex = 1+SearchType.indexOf(value.toString());
                                      },
                                    ),
                                     ),
                                  SizedBox(height: sHeight(2, context),),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text("Book Search",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w900,),),
                                      Text("  * ",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w900,color: Colors.red),),
                                    ],
                                  ),
                                  SizedBox(height: sHeight(2, context),),
                                  Container(
                                    child: Form(
                                      key: _StaBookFind,
                                      child: TextFormField(
                                        autovalidateMode: AutovalidateMode.onUserInteraction,
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
                                            Search = value;
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
                                      Sta_Search_Book();
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
                                ],
                              ),
                            ),
                            ],
                          )
                        ],
                      ),
                    )),
              );
            } else {
              return Scaffold(
                body: Builder(
                    builder:(BuildContext context) => ListView(
                      scrollDirection: Axis.vertical,
                      children: <Widget>[
                        Image.asset('images/Dataimg/data_not_found.png',)
                      ],
                    )),
              );
            }
          } else {
            return Container(
              child: Center(child: SearchingDataLottie(context)),
              color: Colors.white,
            );
          }
        });
  }
}

class StaffOpacSearch extends StatefulWidget {
  const StaffOpacSearch({Key? key, required this.staffID, required this.StaffAPI, required this.ItemID, required this.SearchTypeIndex, required this.RecordIndex, required this.Search,}) : super(key: key);
  final String staffID;
  final StaffAPI_data StaffAPI;
  final int ItemID;
  final int SearchTypeIndex;
  final int RecordIndex;
  final String Search;

  @override
  State<StaffOpacSearch> createState() => _StaffOpacSearchState();
}

class _StaffOpacSearchState extends State<StaffOpacSearch> {
  late Future<StaffOPACSearchData_List> StaffOPACSearchAPIData;
  late StaffAPI_data StaffAPI = widget.StaffAPI;
  late int start = 0;
  late int end = widget.RecordIndex-1;
  late int page = 1;
  late bool front = true;
  late bool back = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StaffOPACSearchNetwork StaffOPACSearchnetwork = StaffOPACSearchNetwork(
        "opac?SearchValue=${widget.Search}&SearchType=${widget.SearchTypeIndex}&Library=${widget.ItemID}&Show=0&From=1&TO=1&ResId=1");
    StaffOPACSearchAPIData = StaffOPACSearchnetwork.StaffOPACSearchloadData();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: StaffOPACSearchAPIData,
        builder: (context,
            AsyncSnapshot<StaffOPACSearchData_List> StaffOPACSearchsnapshot) {
          if(StaffOPACSearchsnapshot.hasError){
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
                  title: Text(
                    "OPAC Search",
                    style: PrimaryText(context),
                  ),
                  centerTitle: true,
                  backgroundColor: Color.fromRGBO(255, 98, 118, 1),
                  elevation: 20.0,
                ),
                body: Builder(
                    builder: (BuildContext context) => ListView(
                      scrollDirection: Axis.vertical,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            for(int i = start; i<=end; i++)
                              StaffOPACGenerator(context,StaffOPACSearchdata, i),
                            Container(
                                margin: EdgeInsets.only(bottom: 15.0)),
                            Container(
                              width: sWidth(90, context),
                              height: sHeight(13, context),
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
                                margin: EdgeInsets.only(bottom: 15.0)),
                          ],
                        )
                      ],
                    )),
              );
            } else {
              return Scaffold(
                appBar: AppBar(
                  title: Text(
                    "Library Search",
                    style: PrimaryText(context),
                  ),
                  centerTitle: true,
                  backgroundColor: Color.fromRGBO(255, 98, 118, 1),
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
          } else {
            return Container(
              child: Center(child: CircularProgressIndicator()),
              color: Colors.white,
            );
          }
        });
  }
}

class StaffLibraryHistory extends StatefulWidget {
  const StaffLibraryHistory({Key? key, required this.staffID, required this.StaffAPI}) : super(key: key);
  final String staffID;
  final StaffAPI_data StaffAPI;

  @override
  _StaffLibraryHistoryState createState() => _StaffLibraryHistoryState();
}

class _StaffLibraryHistoryState extends State<StaffLibraryHistory> {
  late Future<LibraryData_List> LibraryAPIData;
  late StaffAPI_data StaffAPI = widget.StaffAPI;
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
    LibraryNetwork Librarynetwork = LibraryNetwork(
        "Library?StaffCode=${StaffAPI.StaffCode}&Method=3&Password=${widget.staffID}");
    LibraryAPIData = Librarynetwork.LibraryloadData();
    checkInternet();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: LibraryAPIData,
        builder: (context,
            AsyncSnapshot<LibraryData_List> Librarysnapshot) {
          if(Librarysnapshot.hasError){
            ErrorShowingWidget(context);
          }
          List<LibraryAPI_data> Librarydata;
          if (Librarysnapshot.hasData) {
            Librarydata =
                Librarysnapshot.data!.Librarydata_list;
            if (Librarydata.length > 0) {
              print(Librarysnapshot.error);
              return Scaffold(
                backgroundColor:  Color.fromRGBO(242, 249, 250, 0.9),
                body: Builder(
                    builder: (BuildContext context) => SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.only(bottom: 15.0)),
                              for(int i = 0; i<=Librarydata.length-1; i++)
                                StaffLibraryGenerator(context,Librarydata, i),
                              Container(
                                  margin: EdgeInsets.only(bottom: 15.0)),
                            ],
                          )
                        ],
                      ),
                    )),
              );
            } else {
              return Scaffold(
                body: Builder(
                    builder: (BuildContext context) => ListView(
                      scrollDirection: Axis.vertical,
                      children: <Widget>[
                        Image.asset('images/Dataimg/data_not_found.png',)
                      ],
                    )),
              );
            }
          } else {
            return Container(
              child: Center(child: SearchingDataLottie(context)),
              color: Colors.white,
            );
          }
        });
  }
}

class StaffLibraryOverdue extends StatefulWidget {
  const StaffLibraryOverdue({Key? key, required this.staffID, required this.StaffAPI}) : super(key: key);
  final String staffID;
  final StaffAPI_data StaffAPI;

  @override
  _StaffLibraryOverdueState createState() => _StaffLibraryOverdueState();
}

class _StaffLibraryOverdueState extends State<StaffLibraryOverdue> {
  late Future<LibraryData_List> LibraryAPIData;
  late StaffAPI_data StaffAPI = widget.StaffAPI;
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
    LibraryNetwork Librarynetwork = LibraryNetwork(
        "Library?StaffCode=${StaffAPI.StaffCode}&Method=1&Password=${widget.staffID}");
    LibraryAPIData = Librarynetwork.LibraryloadData();
    checkInternet();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: LibraryAPIData,
        builder: (context,
            AsyncSnapshot<LibraryData_List> Librarysnapshot) {
          if(Librarysnapshot.hasError){
            ErrorShowingWidget(context);
          }
          List<LibraryAPI_data> Librarydata;
          if (Librarysnapshot.hasData) {
            Librarydata =
                Librarysnapshot.data!.Librarydata_list;
            if (Librarydata.length > 0) {
              return Scaffold(
                backgroundColor:  Color.fromRGBO(242, 249, 250, 0.9),
                body: Builder(
                    builder: (BuildContext context) => SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.only(bottom: 15.0)),
                              for(int i = 0; i<=Librarydata.length-1; i++)
                                StaffLibraryGenerator(context,Librarydata, i),
                              Container(
                                  margin: EdgeInsets.only(bottom: 15.0)),
                            ],
                          )
                        ],
                      ),
                    )),
              );
            } else {
              return Scaffold(
                body: Builder(
                    builder:(BuildContext context) => ListView(
                      scrollDirection: Axis.vertical,
                      children: <Widget>[
                        Image.asset('images/Dataimg/data_not_found.png',)
                      ],
                    )),
              );
            }
          } else {
            return Container(
              child: Center(child: SearchingDataLottie(context)),
              color: Colors.white,
            );
          }
        });
  }
}

class StaffAttendaceRecord extends StatefulWidget {
  const StaffAttendaceRecord({Key? key, required this.staffID, required this.StaffAPI, required this.Date}) : super(key: key);
  final String staffID;
  final StaffAPI_data StaffAPI;
  final DateTime Date;

  @override
  _StaffAttendaceRecordState createState() => _StaffAttendaceRecordState();
}

class _StaffAttendaceRecordState extends State<StaffAttendaceRecord> {
  late Future<StaffAttendanceRecordData_List> StaffAttendanceRecordAPIData;
  late StaffAPI_data StaffAPI = widget.StaffAPI;
  DateTime SelectedDate = DateTime.now();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StaffAttendanceRecordNetwork StaffAttendanceRecordnetwork = StaffAttendanceRecordNetwork(
        "StaffAttendace?StaffCode=${StaffAPI.StaffCode}&MonthId=${widget.Date.month}&YearId=${widget.Date.year}&Password=${widget.staffID}");
    StaffAttendanceRecordAPIData = StaffAttendanceRecordnetwork.StaffAttendanceRecordloadData();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: StaffAttendanceRecordAPIData,
        builder: (context,
            AsyncSnapshot<StaffAttendanceRecordData_List> StaffAttendanceRecordsnapshot) {
          if(StaffAttendanceRecordsnapshot.hasError){
            ErrorShowingWidget(context);
          }
          List<StaffAttendanceRecordAPI_data> StaffAttendanceRecorddata;
          if (StaffAttendanceRecordsnapshot.hasData) {
            StaffAttendanceRecorddata =
                StaffAttendanceRecordsnapshot.data!.StaffAttendanceRecorddata_list;
            if (StaffAttendanceRecorddata.length > 0) {
              return Scaffold(
                backgroundColor: Color.fromRGBO(239, 242, 252, 0.9),
                appBar: AppBar(
                  title: Text(
                    "My Attendance",
                    style: PrimaryText(context),
                  ),
                  centerTitle: true,
                  backgroundColor: Color.fromRGBO(255, 98, 118, 1),
                  elevation: 20.0,
                  actions: [
                    IconButton(
                      icon: Icon(Icons.calendar_month_sharp),
                      onPressed: () {
                        showDatePicker(context: context,
                          initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100),
                        ).then((value) {
                          SelectedDate = value!;
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> StaffAttendaceRecord(
                            staffID: widget.staffID, StaffAPI: widget.StaffAPI, Date: SelectedDate,)));
                        });
                      },
                    ),
                  ],
                ),
                body: Builder(
                    builder: (BuildContext context) => ListView(
                      scrollDirection: Axis.vertical,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            SizedBox(height: sHeight(1, context),),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget> [
                                  Container(
                                    width: sWidth(90, context),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    margin: EdgeInsets.only(bottom: 5.0, top: 15.0),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: sHeight(1, context),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(" ${DateFormat('LLL y').format(widget.Date)}", style: PrimaryText2()),
                                           /* InkWell(
                                              child: Icon(Icons.date_range, size: 40, color: Colors.red,),
                                              onTap: (){
                                                showDatePicker(context: context,
                                                  initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100),
                                                ).then((value) {
                                                  SelectedDate = value!;
                                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> StaffAttendaceRecord(
                                                    staffID: widget.staffID, StaffAPI: widget.StaffAPI, Date: SelectedDate,)));
                                                });
                                              },
                                            ),*/
                                          ],
                                        ),
                                        SizedBox(
                                          height: sHeight(1, context),
                                        ),
                                        Column(
                                          children: [
                                            Container(
                                            decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(15),
                                              topRight: Radius.circular(15),)),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(15.0),
                                                    child: StaffAttendaceRecordTitleGeterator(context),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            for(int i = 0; i<=StaffAttendanceRecorddata.length-1; i++)
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(10.0),
                                                      child: StaffAttendaceRecordGeterator(context,StaffAttendanceRecorddata[i]),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                          ],
                                        )
                                      ],
                                    ),

                                  ),

                                ],
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.only(bottom: 15.0)),
                          ],
                        )
                      ],
                    )),
              );
            } else {
              return Scaffold(
                body: Builder(
                    builder:(BuildContext context) => ListView(
                      scrollDirection: Axis.vertical,
                      children: <Widget>[
                        Image.asset('images/Dataimg/data_not_found.png',)
                      ],
                    )),
              );
            }
          } else {
            return Container(
              child: Center(child: SearchingDataLottie(context)),
              color: Colors.white,
            );
          }
        });
  }
}

class StaffLeaveBalance extends StatefulWidget {
  const StaffLeaveBalance({Key? key, required this.staffID, required this.StaffAPI}) : super(key: key);
  final String staffID;
  final StaffAPI_data StaffAPI;

  @override
  _StaffLeaveBalanceState createState() => _StaffLeaveBalanceState();
}

class _StaffLeaveBalanceState extends State<StaffLeaveBalance> {
  late Future<LeaveBalanceData_List> LeaveBalanceAPIData;
  late StaffAPI_data StaffAPI = widget.StaffAPI;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LeaveBalanceNetwork LeaveBalancenetwork = LeaveBalanceNetwork(
        "StaffLeaves?StaffCode=${StaffAPI.StaffCode}&Password=${widget.staffID}");
    LeaveBalanceAPIData = LeaveBalancenetwork.LeaveBalanceloadData();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: LeaveBalanceAPIData,
        builder: (context,
            AsyncSnapshot<LeaveBalanceData_List> LeaveBalancesnapshot) {
          if(LeaveBalancesnapshot.hasError){
            ErrorShowingWidget(context);
          }
          List<LeaveBalanceAPI_data> LeaveBalancedata;
          if (LeaveBalancesnapshot.hasData) {
            LeaveBalancedata =
                LeaveBalancesnapshot.data!.LeaveBalancedata_list;
            if (LeaveBalancedata.length > 0) {
              return Scaffold(
                backgroundColor:  Color.fromRGBO(242, 249, 250, 0.9),
                appBar: AppBar(
                  title: Text(
                    "Leave Balance",
                    style: PrimaryText(context),
                  ),
                  centerTitle: true,
                  backgroundColor: Color.fromRGBO(255, 98, 118, 1),
                  elevation: 20.0,
                ),
                body: Builder(
                    builder: (BuildContext context) => ListView(
                      scrollDirection: Axis.vertical,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            SizedBox(height: sHeight(1, context),),
                            Container(
                                margin: EdgeInsets.only(top: 2, left: 0),
                                child: SizedBox(
                                    child: Text("${LeaveBalancedata[0].MonthName} ${LeaveBalancedata[0].YearName}",
                                      style: PrimaryText2(), textAlign: TextAlign.center,))),
                            for(int i = LeaveBalancedata.length-1; i>=0; i--)
                              SizedBox(
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: StaffLeaveBalanceGenerator(context,LeaveBalancedata[i]),
                                ),
                              ),
                            Container(
                                margin: EdgeInsets.only(bottom: 15.0)),
                          ],
                        )
                      ],
                    )),
              );
            } else {
              return Scaffold(
                body: Builder(
                    builder:(BuildContext context) => ListView(
                      scrollDirection: Axis.vertical,
                      children: <Widget>[
                        Image.asset('images/Dataimg/data_not_found.png',)
                      ],
                    )),
              );
            }
          } else {
            return Container(
              child: Center(child: SearchingDataLottie(context)),
              color: Colors.white,
            );
          }
        });
  }
}

class StaffProforma extends StatefulWidget {
  const StaffProforma({Key? key, required this.staffID, required this.StaffAPI}) : super(key: key);
  final String staffID;
  final StaffAPI_data StaffAPI;

  @override
  _StaffProformaState createState() => _StaffProformaState();
}

class _StaffProformaState extends State<StaffProforma> {
  late Future<StaffProformaData_List> StaffProformaAPIData;
  late StaffAPI_data StaffAPI = widget.StaffAPI;
  var Activities = [];
  String? Item_Name;
  int GName = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StaffProformaNetwork StaffProformanetwork = StaffProformaNetwork(
        "Proforma?StaffCode=${StaffAPI.StaffCode}&Password=${widget.staffID}");
    StaffProformaAPIData = StaffProformanetwork.StaffProformaloadData();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: StaffProformaAPIData,
        builder: (context,
            AsyncSnapshot<StaffProformaData_List> StaffProformasnapshot) {
          if(StaffProformasnapshot.hasError){
            ErrorShowingWidget(context);
          }
          List<StaffProformaAPI_data> StaffProformadata;
          print(StaffProformasnapshot.error);
          if (StaffProformasnapshot.hasData) {
            StaffProformadata =
                StaffProformasnapshot.data!.StaffProformadata_list;
            Activities = [for(int i = StaffProformadata.length-1; i>=0; i--)
              StaffProformadata[i].GroupName,
              ];
            if (StaffProformadata.length > 0) {
              return Scaffold(
                backgroundColor:  Color.fromRGBO(242, 249, 250, 0.9),
                appBar: AppBar(
                  title: Text(
                    "Proforma",
                    style: PrimaryText(context),
                  ),
                  centerTitle: true,
                  backgroundColor: Color.fromRGBO(255, 98, 118, 1),
                  elevation: 20.0,
                ),
                body: Builder(
                    builder: (BuildContext context) => ListView(
                      scrollDirection: Axis.vertical,
                      children: <Widget>[
                        // Container(
                        //   margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                        //   child: DropdownSearch<dynamic>(
                        //     popupProps: PopupProps.modalBottomSheet(
                        //       showSearchBox: true,
                        //       searchFieldProps: TextFieldProps(
                        //         enableSuggestions: false,
                        //       ),
                        //     ),
                        //     dropdownDecoratorProps: DropDownDecoratorProps(
                        //       dropdownSearchDecoration: PrimaryInputDecor('active'),
                        //     ),
                        //     dropdownButtonProps: DropdownButtonProps(
                        //         padding: EdgeInsets.symmetric(horizontal: 20.0),
                        //         icon: Icon(Icons.arrow_drop_down_sharp),
                        //         color: Colors.black
                        //     ),
                        //     items: Activities,
                        //     selectedItem: 'Select Activities',
                        //     onChanged: (value) {
                        //       name = value.toString();
                        //       GName = Activities.indexOf(name);
                        //       // print(name);
                        //       print(GName);
                        //       // print(StaffProformadata[GName].Name);
                        //       setState(() {
                        //       });
                        //     },
                        //   ),
                        // ),
                        Column(
                          children: <Widget>[
                            SizedBox(height: sHeight(1, context),),
                            for(int i = StaffProformadata.length-1; i>=0; i--)
                              SizedBox(
                                child: Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: StaffProformaGenerator(context,StaffProformadata[i]),
                                ),
                              ),
                            Container(
                                margin: EdgeInsets.only(bottom: 15.0)),
                          ],
                        )
                      ],
                    )),
              );
            } else {
              return Scaffold(
                body: Builder(
                    builder:(BuildContext context) => ListView(
                      scrollDirection: Axis.vertical,
                      children: <Widget>[
                        Image.asset('images/Dataimg/data_not_found.png',)
                      ],
                    )),
              );
            }
          } else {
            return Container(
              child: Center(child: SearchingDataLottie(context)),
              color: Colors.white,
            );
          }
        });
  }
}

class StaffLessonPlan extends StatefulWidget {
  const StaffLessonPlan({Key? key, required this.staffID, required this.StaffAPI}) : super(key: key);
  final String staffID;
  final StaffAPI_data StaffAPI;

  @override
  _StaffLessonPlanState createState() => _StaffLessonPlanState();
}

class _StaffLessonPlanState extends State<StaffLessonPlan> {
  late Future<StaffAttendanceTableData_List> AttendanceAPIData;
  late StaffAPI_data StaffAPI = widget.StaffAPI;

  void initState() {
    // TODO: implement initState
    super.initState();
    StaffAttendanceTableNetwork attendancenetwork = StaffAttendanceTableNetwork(
        "StaffHours?StaffCode=${StaffAPI.StaffCode}&ShowPrevDays=1&Password=${widget.staffID}");
    AttendanceAPIData = attendancenetwork.StaffAttendanceTableloadData();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AttendanceAPIData,
        builder: (context,
            AsyncSnapshot<StaffAttendanceTableData_List> Attendancesnapshot) {
          if(Attendancesnapshot.hasError){
            ErrorShowingWidget(context);
          }
          List<StaffAttendanceTableAPI_data> Attendancedata;
          print(Attendancesnapshot.error);
          if (Attendancesnapshot.hasData) {
            Attendancedata = Attendancesnapshot.data!.StaffAttendanceTabledata_list;
            if (Attendancedata.length > 0) {
              return Scaffold(
                backgroundColor: Color.fromRGBO(239, 242, 252, 0.9),
                appBar: AppBar(
                  title: Text(
                    "Notes of Lesson",
                    style: PrimaryText(context),
                  ),
                  centerTitle: true,
                  backgroundColor: Color.fromRGBO(255, 98, 118, 1),
                  elevation: 20.0,
                ),
                body: Builder(
                    builder: (BuildContext context) => SingleChildScrollView(
                      child: Column(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: sHeight(2, context),
                          ),
                          Container(
                            width: sWidth(90, context),
                            padding: EdgeInsets.only(left: 20),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.all(Radius.circular(13),),),
                            child: Column(
                              children: [
                                SizedBox(height: sHeight(1.5, context),),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.date_range,color: Color.fromRGBO(150, 250, 195, 1),),
                                    SizedBox(width: sWidth(2, context),),
                                    Text("Date                :",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 16),),
                                    Text("   ${Attendancedata[0].Date}",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 16),)
                                  ],
                                ),
                                SizedBox(height: sHeight(1.5, context),),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.school_sharp,color: Color.fromRGBO(150, 250, 195, 1),),
                                    SizedBox(width: sWidth(2, context),),
                                    Text("Sem Period   :",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 16),),
                                    Text("   ${Attendancedata[0].SemPeriodName}",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 16),)
                                  ],
                                ),
                                SizedBox(height: sHeight(2, context),),
                              ],
                            ),
                          ),
                          SizedBox(height: sHeight(2, context),),
                    Center(
                      child: Container(
                        height: sHeight(75, context),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              for (int i = 0;
                              i <= Attendancedata.length -1;
                              i++)
                                StaffLessonPlanGenerator(
                                    context, Attendancedata[i], StaffAPI, widget.staffID),
                              //...
                            ],
                          ),
                        ),
                      ),
                    ),
                   /* Row(),
                          for (int i = 0;
                          i <= Attendancedata.length -1;
                          i++)
                            StaffLessonPlanGenerator(
                                context, Attendancedata[i], StaffAPI, widget.staffID),*/
                        ],
                      )),)
              );
            } else {
              return  Scaffold(
                appBar: AppBar(
                  title: Text(
                    "Notes Of Lesson",
                    style: PrimaryText(context),
                  ),
                  centerTitle: true,
                  backgroundColor: Color.fromRGBO(255, 98, 118, 1),
                  elevation: 20.0,
                ),
                body: Builder(
                    builder: (BuildContext context) => ListView(
                      scrollDirection: Axis.vertical,
                      children: <Widget>[
                        Image.asset('images/Dataimg/class_not_found.png',)
                      ],
                    )),
              );
            }
          } else {
            return Container(
              child: Center(child: SearchingDataLottie(context)),
              color: Colors.white,
            );
          }
        });
  }
}

class StaffLessonPlanList extends StatefulWidget {
  const StaffLessonPlanList({Key? key, required this.StaffAPI, required this.AttendanceClassAPI, required this.staffID,}) : super(key: key);
  final StaffAPI_data StaffAPI;
  final StaffAttendanceTableAPI_data AttendanceClassAPI;
  final String staffID;


  @override
  _StaffLessonPlanListState createState() => _StaffLessonPlanListState();
}

class _StaffLessonPlanListState extends State<StaffLessonPlanList> {
  late Future<LessonPlanTheoryData_List> LessonPlanTheoryAPIData;
  late StaffAPI_data StaffAPI = widget.StaffAPI;
  String type = '';

  void initState() {
    // TODO: implement initState
    super.initState();
    LessonPlanTheoryNetwork LessonPlanTheorynetwork = LessonPlanTheoryNetwork(
        "LessonPlanner?StaffCode=${StaffAPI.StaffCode}&FinalTimeTableId=${widget.AttendanceClassAPI.TimeTableId}&Password=${widget.staffID}");
    LessonPlanTheoryAPIData = LessonPlanTheorynetwork.LessonPlanTheoryloadData();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.AttendanceClassAPI.sbt.toLowerCase() == 'p'){
      type = 'Practical';
    }
    else{
      type = 'Theory';
    }
    return FutureBuilder(
        future: LessonPlanTheoryAPIData,
        builder: (context,
            AsyncSnapshot<LessonPlanTheoryData_List> LessonPlanTheorysnapshot) {
          if(LessonPlanTheorysnapshot.hasError){
            ErrorShowingWidget(context);
          }
          List<LessonPlanTheoryAPI_data> LessonPlanTheorydata;
          print(LessonPlanTheorysnapshot.error);
          if (LessonPlanTheorysnapshot.hasData) {
            LessonPlanTheorydata =
                LessonPlanTheorysnapshot.data!.LessonPlanTheorydata_list;
            if (LessonPlanTheorydata.length > 0) {
              return Scaffold(
                backgroundColor: Color.fromRGBO(239, 242, 252, 0.9),
                appBar: AppBar(
                  title: Text(
                    "Lesson Planner",
                    style: PrimaryText(context),
                  ),
                  centerTitle: true,
                  backgroundColor: Color.fromRGBO(255, 98, 118, 1),
                  elevation: 20.0,
                ),
                body: Builder(
                    builder: (BuildContext context) => SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                           SizedBox(
                             height: sHeight(2, context),
                           ),
                            Container(
                                width: sWidth(90, context),
                                padding: EdgeInsets.only(left: 20),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.all(Radius.circular(13),),),

                            ),
                            Container(margin: EdgeInsets.only(bottom: 15.0)),
                            for (int i = 0; i <= LessonPlanTheorydata.length -1; i++)
                              StaffLessonPlanListGenerator(context, LessonPlanTheorydata[i], StaffAPI, widget.staffID, widget.AttendanceClassAPI)
                          ],
                        )
                      ],
                    )),
                )
              );
            } else {
              return Scaffold(
                appBar: AppBar(
                  title: Text(
                    "Lesson Planner",
                    style: PrimaryText(context),
                  ),
                  centerTitle: true,
                  backgroundColor: Color.fromRGBO(255, 98, 118, 1),
                  elevation: 20.0,
                ),
                body: Builder(
                    builder:(BuildContext context) => ListView(
                      scrollDirection: Axis.vertical,
                      children: <Widget>[
                        Image.asset('images/Dataimg/data_not_found.png',)
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
  }
}

class StaffLessonPlanPracticals extends StatefulWidget {
  const StaffLessonPlanPracticals({Key? key, required this.StaffAPI, required this.AttendanceClassAPI, required this.staffID, required this.PlannerID, required this.ExptNo}) : super(key: key);
  final StaffAPI_data StaffAPI;
  final StaffAttendanceTableAPI_data AttendanceClassAPI;
  final String staffID;
  final int PlannerID;
  final String ExptNo;

  @override
  _StaffLessonPlanPracticalsState createState() => _StaffLessonPlanPracticalsState();
}

class _StaffLessonPlanPracticalsState extends State<StaffLessonPlanPracticals> {
  late Future<LessonPlanPracticalData_List> LessonPlanPracticalData;
  late StaffAttendanceTableAPI_data AttendanceClassAPI =
      widget.AttendanceClassAPI;
  late StaffAPI_data StaffAPI = widget.StaffAPI;
  late List <int> StudentNoList = [0];
  late List <LessonPlanPracticalAPI_data> FinalList = [];

  void initState() {
    // TODO: implement initState
    super.initState();
    LessonPlanPracticalNetwork attendancenetwork = LessonPlanPracticalNetwork(
        "LassonPlannerPractical?StaffCode=${widget.StaffAPI.StaffCode}&FinalTimeTableIds=${widget.AttendanceClassAPI.TimeTableId}&Password=${widget.staffID}");
    LessonPlanPracticalData = attendancenetwork.LessonPlanPracticalloadData();
  }
  @override
  Widget build(BuildContext context) {
    String list = "";
    for(int i = 0; i<=StudentNoList.length-1; i++)
    {
      list = list+StudentNoList[i].toString();
      if(i !=StudentNoList.length-1)
        list = list+",";
    }
    print(list);
    return FutureBuilder(
        future: LessonPlanPracticalData,
        builder:
            (context, AsyncSnapshot<LessonPlanPracticalData_List> Attendancesnapshot) {
              if(Attendancesnapshot.hasError){
                ErrorShowingWidget(context);
              }
          List<LessonPlanPracticalAPI_data> data;
          if (Attendancesnapshot.hasData) {
            data = Attendancesnapshot.data!.LessonPlanPracticaldata_list;
            if (data.length > 0) {
              return Scaffold(
                appBar: AppBar(
                  title: Text(
                    "Lesson Planner Practicals",
                    style: PrimaryText(context),
                  ),
                  backgroundColor: Color(0xFFF84259),
                  elevation: 20.0,
                  centerTitle: true,
                ),
                backgroundColor: Color.fromRGBO(239, 242, 252, 0.9),
                body: Builder(
                    builder: (BuildContext context) => SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(bottom: 20.0)),
                          //StaffProfile1(context, StaffAPI.StaffImg, StaffAPI.StaffName),
                          //StaffInfoDesign(context, "", "Staff Code", StaffAPI.StaffCode, "Designation", StaffAPI.Designation, "", ""),
                          //Container(margin: EdgeInsets.only(bottom: 10.0)),
                          //DividerDesign(3.0),
                          //Container(margin: EdgeInsets.only(bottom: 10.0)),
                          //StaffInfoDesign(context, "Notes of Lesson Practicals", 'Experiment', widget.ExptNo, "Date", AttendanceClassAPI.Date, "Class", AttendanceClassAPI.ClassName),
                          //Container(margin: EdgeInsets.only(bottom: 10.0)),
                          for (int i = 0; i <= data.length - 1; i++)
                            InkWell(
                              child: StaffLessonPlanPracticalsGenerator(context, data[i], StudentNoList),
                              onTap: () {
                                setState(() {});
                                if(StudentNoList.contains(data[i].id))
                                {
                                  StudentNoList.remove(data[i].id);
                                  FinalList.remove(data[i]);
                                }
                                else{
                                  StudentNoList.add(data[i].id);
                                  FinalList.add(data[i]);
                                }
                              },
                            ),
                          Container(
                              margin: EdgeInsets.only(bottom: 10.0)),
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
                        margin: EdgeInsets.only(left: 10.0),
                        decoration: PrimaryRoundBox(),
                        child: Icon(Icons.check_sharp, color: Colors.white,),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>
                          StaffLessonPlanPracticalsMark(StaffAPI: StaffAPI, AttendanceClassAPI: AttendanceClassAPI, list: list, staffID: widget.staffID, PlannerID: widget.PlannerID)));
                      },
                    ),
                  ],
                ),
              );
            } else {
              return Scaffold(
                appBar: AppBar(
                  title: Text("Attendance", style: PrimaryText(context)),
                  centerTitle: true,
                  backgroundColor: PrimaryColor(),
                ),
                body: Builder(
                    builder: (BuildContext context) => ListView(
                      children: <Widget>[
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
  }
}

class StaffLessonPlanMark extends StatefulWidget {
  const StaffLessonPlanMark({Key? key, required this.StaffAPI, required this.AttendanceClassAPI, required this.list, required this.staffID, required this.PlannerID}) : super(key: key);
  final StaffAPI_data StaffAPI;
  final StaffAttendanceTableAPI_data AttendanceClassAPI;
  final String list;
  final String staffID;
  final int PlannerID;

  @override
  _StaffLessonPlanMarkState createState() => _StaffLessonPlanMarkState();
}

class _StaffLessonPlanMarkState extends State<StaffLessonPlanMark> {
  late StaffAttendanceTableAPI_data AttendanceClassAPI =
      widget.AttendanceClassAPI;
  late StaffAPI_data StaffAPI = widget.StaffAPI;
  late String list = widget.list;
  late Future <MarkingData_List> MarkingAPIData;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    MarkingNetwork network = MarkingNetwork(
        "NotesOfLessonTheory?FinalTimeTableIds=${widget.AttendanceClassAPI.TimeTableId}&PlannerId=${widget.PlannerID}&Notes=${widget.list}&StaffCode=${StaffAPI.StaffCode}&Password=${widget.staffID}");
    MarkingAPIData = network.MarkingloadData();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: MarkingAPIData,
        builder:
            (context, AsyncSnapshot<MarkingData_List> Attendancesnapshot) {
          List<MarkingAPI_data> data;
          print(Attendancesnapshot.error);
          if(Attendancesnapshot.hasError){
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  "Notes of Lesson",
                  style: PrimaryText(context),
                ),
                centerTitle: true,
                backgroundColor: Color.fromRGBO(255, 98, 118, 1),
                elevation: 20.0,
              ),
              body: Builder(
                  builder: (BuildContext context) => SingleChildScrollView(
                    child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: sHeight(10, context),
                      ),
                      Center(
                          child: Text(
                            "Please try again later",
                            style: ErrorText2Big(),
                            textAlign: TextAlign.center,
                          )),
                      SizedBox(
                        height: 70,
                      ),
                      InkWell(
                        child: Container(
                            width: sWidth(20, context),
                            height: sHeight(6.5, context),
                            decoration: BoxDecoration(
                              color: Colors.red,
                                borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Center(
                              child: Text("OK", style: TextStyle(color: Colors.white,fontSize: 20)),
                            )),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  )),)
            );
          }
          else{
            if (Attendancesnapshot.hasData) {
              data = Attendancesnapshot.data!.Markingdata_list;
              if (data.length > 0) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text(
                      "Notes of Lesson",
                      style: PrimaryText(context),
                    ),
                    centerTitle: true,
                    backgroundColor: Color.fromRGBO(255, 98, 118, 1),
                    elevation: 20.0,
                  ),
                  body: Builder(
                      builder: (BuildContext context) => SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child:  Column(
                        children: <Widget>[
                          SizedBox(
                            height: sHeight(10, context),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Center(child: Text(data[0].msg, style: PrimaryText2Big(),),),
                              SizedBox(height: sHeight(6.5, context),),
                              SizedBox(height: sHeight(6.5, context),),
                              InkWell(
                                child: Container(
                                    width: sWidth(20, context),
                                    height: sHeight(6.5, context),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Center(
                                      child: Text("OK", style: TextStyle(color: Colors.white,fontSize: 20)),
                                    )),
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          )
                        ],
                      )),
                  )
                );
              } else {
                return Scaffold(
                  appBar: AppBar(
                    title: Text(
                      "Notes of Lesson",
                      style: PrimaryText(context),
                    ),
                    centerTitle: true,
                    backgroundColor: Color.fromRGBO(255, 98, 118, 1),
                    elevation: 20.0,
                  ),
                  body: Builder(
                      builder: (BuildContext context) => SingleChildScrollView(
                        child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: sHeight(10, context),
                          ),
                          Center(
                              child: Text(
                                "Please try again later",
                                style: ErrorText2Big(),
                                textAlign: TextAlign.center,
                              )),
                          InkWell(
                            child: Container(
                                width: sWidth(20, context),
                                height: sHeight(6.5, context),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Center(
                                  child: Text("OK", style: TextStyle(color: Colors.white,fontSize: 20)),
                                )),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      )),)
                );
              }
            }
            else {
              return Container(
                child: Center(child: CircularProgressIndicator()),
                color: Colors.white,
              );
            }
          }

        });

  }
}

class StaffLessonPlanPracticalsMark extends StatefulWidget {
  const StaffLessonPlanPracticalsMark({Key? key, required this.StaffAPI, required this.AttendanceClassAPI, required this.list, required this.staffID, required this.PlannerID}) : super(key: key);
  final StaffAPI_data StaffAPI;
  final StaffAttendanceTableAPI_data AttendanceClassAPI;
  final String list;
  final String staffID;
  final int PlannerID;

  @override
  _StaffLessonPlanPracticalsMarkState createState() => _StaffLessonPlanPracticalsMarkState();
}

class _StaffLessonPlanPracticalsMarkState extends State<StaffLessonPlanPracticalsMark> {
  late StaffAttendanceTableAPI_data AttendanceClassAPI =
      widget.AttendanceClassAPI;
  late StaffAPI_data StaffAPI = widget.StaffAPI;
  late String list = widget.list;
  late Future <MarkingData_List> MarkingAPIData;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    MarkingNetwork network = MarkingNetwork(
        "NotesOfLessonPractical?FinalTimeTableIds=${widget.AttendanceClassAPI.TimeTableId}&PlannerId=${widget.PlannerID}&StudList=${widget.list}&StaffCode=${StaffAPI.StaffCode}&Password=${widget.staffID}");
    MarkingAPIData = network.MarkingloadData();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: MarkingAPIData,
        builder:
            (context, AsyncSnapshot<MarkingData_List> Attendancesnapshot) {
          List<MarkingAPI_data> data;
          print(Attendancesnapshot.error);
          if(Attendancesnapshot.hasError){
            return Scaffold(
              appBar: AppBar(
                leading: Container(),
                title: Text("Notes Of Lesson", style: PrimaryText(context)),
                centerTitle: true,
                backgroundColor: Color.fromRGBO(255, 98, 118, 1),
              ),
              body: Builder(
                  builder: (BuildContext context) => ListView(
                    children: <Widget>[
                      Center(
                          child: Text(
                            "Please try again later",
                            style: ErrorText2Big(),
                            textAlign: TextAlign.center,
                          )),
                      InkWell(
                        child: Container(
                            width: sWidth(20, context),
                            height: sHeight(6.5, context),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Center(
                              child: Text("OK", style: TextStyle(color: Colors.white,fontSize: 20)),
                            )),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  )),
            );
          }
          else{
            if (Attendancesnapshot.hasData) {
              data = Attendancesnapshot.data!.Markingdata_list;
              if (data.length > 0) {
                return Scaffold(
                  appBar: AppBar(
                    leading: Container(),
                    title: Text(
                      "Notes Of Lesson",
                      style: PrimaryText(context),
                    ),
                    centerTitle: true,
                    backgroundColor: Color.fromRGBO(255, 98, 118, 1),
                    elevation: 20.0,
                  ),
                  body: Builder(
                      builder: (BuildContext context) => ListView(
                        scrollDirection: Axis.vertical,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Center(child: Text(_DisplayMessage(data[0].msg), style: PrimaryText2Big(), textAlign: TextAlign.center,),),
                              InkWell(
                                child: Container(
                                    width: sWidth(20, context),
                                    height: sHeight(6.5, context),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Center(
                                      child: Text("OK", style: TextStyle(color: Colors.white,fontSize: 20)),
                                    )),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          )
                        ],
                      )),
                );
              } else {
                return Scaffold(
                  appBar: AppBar(
                    leading: Container(),
                    title: Text("Notes Of Lesson", style: PrimaryText(context)),
                    centerTitle: true,
                    backgroundColor: Color.fromRGBO(255, 98, 118, 1),
                  ),
                  body: Builder(
                      builder: (BuildContext context) => ListView(
                        children: <Widget>[
                          Center(
                              child: Text(
                                "Please try again later",
                                style: ErrorText2Big(),
                                textAlign: TextAlign.center,
                              )),
                          InkWell(
                            child: Container(
                                width: sWidth(20, context),
                                height: sHeight(6.5, context),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Center(
                                  child: Text("OK", style: TextStyle(color: Colors.white,fontSize: 20)),
                                )),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      )),
                );
              }
            }
            else {
              return Container(
                child: Center(child: CircularProgressIndicator()),
                color: Colors.white,
              );
            }
          }

        });

  }

  _DisplayMessage(String message){
    if(message == '0'){
      return 'Experiment Already assigned to\none or more selected students';
    }
    else{
      return message;
    }
  }
}



class Staff_Lib_Home extends StatefulWidget {
  const Staff_Lib_Home({Key? key,required this.staffID, required this.StaffAPI, }) : super(key: key);
  final String staffID;
  final StaffAPI_data StaffAPI;


  @override
  State<Staff_Lib_Home> createState() => _HomePageState();
}

class _HomePageState extends State<Staff_Lib_Home> {
  late Future<LibraryData_List> LibraryAPIData;
  late StaffAPI_data StaffAPI = widget.StaffAPI;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LibraryNetwork Librarynetwork = LibraryNetwork(
        "Library?StaffCode=${StaffAPI.StaffCode}&Method=3&Password=${widget.staffID}");
    LibraryAPIData = Librarynetwork.LibraryloadData();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title:   Text('OPAC - Library Search',
          style: PrimaryText(context),
        ),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(255, 98, 118, 1),
        elevation: 20.0,
        ),
        body: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            TabBar(
              indicator: BoxDecoration(
                  color: Color(0xFFF84259),
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
                      StaffOpac(staffID: widget.staffID, StaffAPI:StaffAPI ,),
                      StaffLibraryHistory(staffID: widget.staffID, StaffAPI: StaffAPI,),
                      StaffLibraryOverdue(staffID: widget.staffID, StaffAPI: StaffAPI),
                    ]))
          ],
        ),
      ),
    );
  }
}








