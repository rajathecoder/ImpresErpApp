import 'package:add_dev_dolphin/Data/Staff_Data.dart';
import 'package:add_dev_dolphin/Model/Staff_Screen/staff_screen_changes.dart';
import 'package:add_dev_dolphin/Style_font/student_screen_design.dart';
import 'package:add_dev_dolphin/UI/main_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'designs.dart';

double sHeight(double per, BuildContext context) {
  double h = MediaQuery.of(context).size.height;
  return h * per / 100;
}

double sWidth(double per, BuildContext context) {
  double w = MediaQuery.of(context).size.width;
  return w * per / 100;
}

Widget DividerDesign(double thickness) => Divider(
      height: 20,
      thickness: thickness,
      indent: 20.0,
      endIndent: 20.0,
      color: LineColor2(),
    );

Widget StaffInfoDesign(
        BuildContext context,
        String title,
        String fTitle,
        String fString,
        String sTitle,
        String sString,
        String tTitle,
        String tString) =>
    Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (title != "")
          Text(title,textAlign: TextAlign.left,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
        if (fString != "")
          Row(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only( left:10,top: 10.0),
                child: Text("$fTitle : ",textAlign: TextAlign.left,
                    style:
                        const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              ),
              Container(
                margin: const EdgeInsets.only( top: 10.0),
                child: Text(fString,textAlign: TextAlign.left,
                    style:
                        const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              ),
            ],
          ),
        if (sString != "")
          Row(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(left: 30.0, top: 10.0),
                child: Text("$sTitle : ",
                    style:
                        const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              ),
              Container(
                margin: const EdgeInsets.only(left: 5.0, top: 10.0),
                child: Text(sString,
                    style:
                        const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              ),
            ],
          ),
        if (tString != "")
          Row(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(left: 30.0, top: 10.0),
                child: Text("$tTitle : ",
                    style:
                        const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              ),
              Container(
                margin: const EdgeInsets.only(left: 5.0, top: 10.0),
                child: Text(tString,
                    style:
                        const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              ),
            ],
          ),
      ],
    );

Widget StaffProfile1(BuildContext context, String picture, String Name) =>
    Container(
      margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.02,
          left: MediaQuery.of(context).size.width * 0.02,
          right: MediaQuery.of(context).size.width * 0.05),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: LeedingProfile(picture),
          ),
          Container(
              margin: const EdgeInsets.only(left: 5.0, top: 10.0),
              width: sWidth(62.5, context),
              height: sHeight(10, context),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Text(
                    Name,
                    style: PrimaryText2Big(),
                  ),
                ],
              )),
        ],
      ),
    );

Widget AttendanceClassList(
    BuildContext context,
    List<StaffAttendanceTableAPI_data> data,
    int i,
    StaffAPI_data StaffAPI,
    String staffID) {
  if (data[i].AttedanceStatus == 0) {
    return Column(
      children: [
        Container(
          width: sWidth(90, context),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: sHeight(2, context),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    data[i].ClassName,
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.w800),
                  ),
                  Text(
                    "Hour  :  ${data[i].Hour}",
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.indigo),
                  ),
                ],
              ),
              SizedBox(
                height: sHeight(0.6, context),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: sWidth(60, context),
                    child: Text(
                      data[i].SubjectFullName,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600),maxLines: 2,
                    ),
                  ),
                  data[i].AttedanceStatus == 0.toInt() ?
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StaffAttendanceList(
                                    StaffAPI: StaffAPI,
                                    AttendanceClassAPI: data[i],
                                    staffID: staffID,
                                  )));
                    },
                    child: const CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Icon(
                          Icons.arrow_forward_ios_sharp,
                          color: Colors.white,
                        )),
                  ) :
                  InkWell(
                    child: const CircleAvatar(
                        backgroundColor: Colors.grey,
                        child: Icon(
                          Icons.arrow_forward_ios_sharp,
                          color: Colors.white,
                        )),
                    onTap: (){
                      Fluttertoast.showToast(
                          msg: "Attendance has been Registered",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.grey[700],
                          textColor: Colors.white,
                          fontSize: 16.0);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StaffAttendanceList(
                                StaffAPI: StaffAPI,
                                AttendanceClassAPI: data[i],
                                staffID: staffID,
                              )));
                    },
                  ),
                ],
              ),
              SizedBox(
                height: sHeight(0.6, context),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  data[i].AttedanceStatus == 0.toInt() ?
                  const Row(
                    children: [
                      Text('Attendance Status : '),
                      Text('Not Done ',style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.red),)
                    ],
                  ) : const Row(
                    children: [
                      Text('Attendance Status : '),
                      Text('Done ',style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.green),)
                    ],
                  ),
                  Text(
                    "Strength  :  ${data[i].Total.toString()}",
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.black),
                  ),
                ],
              ),
              SizedBox(
                height: sHeight(2, context),
              ),
            ],
          ),
        ),
        SizedBox(
          height: sHeight(2, context),
        ),
      ],
    );
  } else {

    return Column(
      children: [
        Container(
          width: sWidth(90, context),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: sHeight(2, context),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    data[i].ClassName,
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.w800),
                  ),
                  Text(
                    "Hour  :  ${data[i].Hour.toString()}",
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.indigo),
                  ),
                ],
              ),
              SizedBox(
                height: sHeight(0.6, context),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: sWidth(60, context),
                    child: Text(
                      data[i].SubjectFullName,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600),maxLines: 2,
                    ),
                  ),
                  data[i].AttedanceStatus == 0.toInt() ?
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StaffAttendanceList(
                                    StaffAPI: StaffAPI,
                                    AttendanceClassAPI: data[i],
                                    staffID: staffID,
                                  )));
                    },
                    child: const CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Icon(
                          Icons.arrow_forward_ios_sharp,
                          color: Colors.white,
                        )),
                  ):
                  InkWell(
                    child: const CircleAvatar(
                        backgroundColor: Colors.grey,
                        child: Icon(
                          Icons.arrow_forward_ios_sharp,
                          color: Colors.white,
                        )),
                    onTap: (){
                      Fluttertoast.showToast(
                          msg: "Attendance has been Registered!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.grey[700],
                          textColor: Colors.white,
                          fontSize: 16.0);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StaffAttendanceList(
                                StaffAPI: StaffAPI,
                                AttendanceClassAPI: data[i],
                                staffID: staffID,
                              )));
                    },
                  ),
                ],
              ),
              SizedBox(
                height: sHeight(0.6, context),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  data[i].AttedanceStatus == 0.toInt() ?
                  const Row(
                    children: [
                      Text('Attendance Status : '),
                      Text('Not Done ',style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.red),)
                    ],
                  ) : const Row(
                    children: [
                      Text('Attendance Status : '),
                      Text('Done ',style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.green),)
                    ],
                  ),
                  Text(
                    "Strength  :  ${data[i].Total.toString()}",
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.black),
                  ),
                ],
              ),
              SizedBox(
                height: sHeight(0.6, context),
              ),
            ],
          ),
        ),
        SizedBox(
          height: sHeight(2, context),
        ),
      ],
    );
  }
    }

Widget StudentListGenerator(BuildContext context, StudentListAPI_data data,
        List<int> StudentList) =>
    Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: 100.0,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.2,
                height: 75.0,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(left: 10.0),
                      child: CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.white,
                        child: LeadingCircleImageContent(data.StudentImg),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10.0,left: 10),
                      child: Column(
                      children: <Widget>[
                          Row(
                            children: [
                              Text(
                                data.StudentName,textAlign: TextAlign.left,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w800,),
                              ),
                            ],
                          ),
                        Row(
                          children: [
                            StaffInfoDesign(context, "", "Roll No", data.RollNo,
                                "", "", "", ""),
                          ],
                        )

                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (StudentList.contains(data.StudentId))
                SizedBox(
                  width: MediaQuery.of(context).size.width / 9,
                  height: 100.0,
                  child: const CircleAvatar(
                    backgroundColor: Colors.red,
                    child: Center(
                      child: Text(
                        "A",
                        style: TextStyle(
                            fontWeight: FontWeight.w800, color: Colors.white),
                      ),
                    ),
                  ),
                )
              else
                SizedBox(
                  width: MediaQuery.of(context).size.width / 9,
                  height: 100.0,
                  child: const CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Center(
                      child: Text(
                        "P",
                        style: TextStyle(
                            fontWeight: FontWeight.w800, color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
          ),
        ),
        SizedBox(
          height: sHeight(1, context),
        ),
      ],
    );

Widget ClubStudentListGenerator(BuildContext context, ClubStud_Data data,
        List<int> StudentList) =>
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 10.0),
                      child: const CircleAvatar(
                        //child: LeadingCircleImageContent2(Club_st[i].simg),
                        radius: 35,
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: sWidth(53, context),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(data.StudentName),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(data.Rollno,),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (StudentList.contains(data.Studentid))
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 9,
                        height: 100.0,
                        child: const CircleAvatar(
                          backgroundColor: Colors.red,
                          child: Center(
                            child: Text(
                              "A",
                              style: TextStyle(
                                  fontWeight: FontWeight.w800, color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    else
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 9,
                        height: 100.0,
                        child: const CircleAvatar(
                          backgroundColor: Colors.green,
                          child: Center(
                            child: Text(
                              "P",
                              style: TextStyle(
                                  fontWeight: FontWeight.w800, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    /*Center(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      if(StudentNoList.contains(data[i].id))
                                                      {
                                                        StudentNoList.remove(Club_st[i].id);
                                                        FinalList.remove(Club_st[i]);
                                                      }
                                                      else{
                                                        StudentNoList.add(Club_st[i].id);
                                                        //FinalList.add(Club_st[i]);
                                                      }
                                                      setState(() {
                                                        isClicked = !isClicked;
                                                      });
                                                      print("${Club_st[i].Studentid}");
                                                    },
                                                    child: CircleAvatar(
                                                      radius: 20,
                                                      backgroundColor: isClicked ? Colors.red : Colors.green,
                                                      child: Text(
                                                        isClicked ? "A" : "P",
                                                        style: TextStyle(color: Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ),*/
                    /* Container(
                                                  child: Row(
                                                    children: [
                                                      InkWell(
                                                        child: CircleAvatar(
                                                          radius: 15,
                                                          child: Text('P'),
                                                          backgroundColor: _pColor,
                                                        ),
                                                        onTap: () {
                                                          setState(() {
                                                            _pColor = Colors.green;
                                                            _aColor = Colors.black;
                                                            print("${Club_st[i].Studentid}");
                                                          });
                                                        },
                                                      ),
                                                      SizedBox(width: sWidth(3, context),),
                                                      InkWell(
                                                        child: CircleAvatar(
                                                          radius: 15,
                                                          child: Text('A'),
                                                          backgroundColor: _aColor,
                                                        ),
                                                        onTap: () {
                                                          setState(() {
                                                            _pColor = Colors.black;
                                                            _aColor = Colors.red;
                                                            print("${Club_st[i].Studentid}");
                                                          });
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),*/
                  ],
                ),
              ],
            ),
          )),
    );

Widget StudentListViewer(BuildContext context, StudentListAPI_data data) =>
    Column(
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 100.0,
          child: Row(
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.2,
                height: 75.0,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(left: 10.0),
                      child: CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.white,
                        child: LeadingCircleImageContent(data.StudentImg),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(margin: const EdgeInsets.only(bottom: 10.0)),
                          Text(
                            data.StudentName,
                            style: PrimaryText2(),
                          ),
                          StaffInfoDesign(context, "", "Roll No", data.RollNo,
                              "", "", "", "")
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width / 9,
                  height: 100.0,
                  child: Center(
                      child: Text(
                    data.AttednaceStatus,
                    style: ColorText(data.AttednaceStatus),
                  )))
            ],
          ),
        ),
        DividerDesign(1.0)
      ],
    );

Widget StaffDisplayTimetable(
    BuildContext context, List<StaffTimetableAPI_data> detailsdata) {
  if (GetAttencanceHours() <= 10) {
    return Column(
      children: <Widget>[
        StaffTimetableGeneratorTitle(context),
        for (int i = 0; i <= detailsdata.length - 1; i++)
          StaffTimetableGenerator(context, detailsdata[i]),
      ],
    );
  } else {
    print('Attendance Greater than 10');
  }
  return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 20),
      child: Center(
          child: Text(
        "Sorry Something went wrong!",
        style: ErrorText2Big(),
        textAlign: TextAlign.center,
      )));
}

Widget StaffTimetableGeneratorTitle(BuildContext context) {
  switch (GetAttencanceHours()) {
    case 4:
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        height: 70.0,
        child: Row(
          children: <Widget>[
            SizedBox(
              child: SizedBox(
                width: 60.0,
                height: 30,
                child: Center(
                    child: Text("Day order",
                        style: PrimaryText2(), textAlign: TextAlign.center)),
              ),
            ),
            Container(
              width: 60,
              height: 30,
              margin: const EdgeInsets.only(left: 50.0),
              child:
                  Text("1", style: PrimaryText2(), textAlign: TextAlign.center),
            ),
            Container(
              width: 60,
              height: 30,
              margin: const EdgeInsets.only(left: 20.0),
              child:
                  Text("2", style: PrimaryText2(), textAlign: TextAlign.center),
            ),
            Container(
              width: 60,
              height: 30,
              margin: const EdgeInsets.only(left: 20.0),
              child:
                  Text("3", style: PrimaryText2(), textAlign: TextAlign.center),
            ),
            Container(
              width: 60,
              height: 30,
              margin: const EdgeInsets.only(left: 20.0),
              child:
                  Text("4", style: PrimaryText2(), textAlign: TextAlign.center),
            ),
          ],
        ),
      );
    case 5:
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        height: 70.0,
        child: Row(
          children: <Widget>[
            SizedBox(
              child: SizedBox(
                width: 60.0,
                height: 30,
                child: Center(
                    child: Text("Day order",
                        style: PrimaryText4(), textAlign: TextAlign.center)),
              ),
            ),
            Container(
              width: 60,
              height: 30,
              margin: const EdgeInsets.only(left: 50.0),
              child:
                  Text("1", style: PrimaryText4(), textAlign: TextAlign.center),
            ),
            Container(
              width: 60,
              height: 30,
              margin: const EdgeInsets.only(left: 20.0),
              child:
                  Text("2", style: PrimaryText4(), textAlign: TextAlign.center),
            ),
            Container(
              width: 60,
              height: 30,
              margin: const EdgeInsets.only(left: 20.0),
              child:
                  Text("3", style: PrimaryText4(), textAlign: TextAlign.center),
            ),
            Container(
              width: 60,
              height: 30,
              margin: const EdgeInsets.only(left: 20.0),
              child:
                  Text("4", style: PrimaryText4(), textAlign: TextAlign.center),
            ),
            Container(
              width: 60,
              height: 30,
              margin: const EdgeInsets.only(left: 20.0),
              child:
                  Text("5", style: PrimaryText4(), textAlign: TextAlign.center),
            ),
          ],
        ),
      );
    case 6:
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        height: 70.0,
        child: Row(
          children: <Widget>[
            SizedBox(
              child: SizedBox(
                width: 100.0,
                height: 30,
                child: Center(
                    child: Text("Day order",
                        style: PrimaryText2(), textAlign: TextAlign.center)),
              ),
            ),
            Container(
              width: 130,
              height: 30,
              margin: const EdgeInsets.only(left: 50.0),
              child:
                  Text("1", style: PrimaryText2(), textAlign: TextAlign.center),
            ),
            Container(
              width: 130,
              height: 30,
              margin: const EdgeInsets.only(left: 20.0),
              child:
                  Text("2", style: PrimaryText2(), textAlign: TextAlign.center),
            ),
            Container(
              width: 130,
              height: 30,
              margin: const EdgeInsets.only(left: 20.0),
              child:
                  Text("3", style: PrimaryText2(), textAlign: TextAlign.center),
            ),
            Container(
              width: 130,
              height: 30,
              margin: const EdgeInsets.only(left: 20.0),
              child:
                  Text("4", style: PrimaryText2(), textAlign: TextAlign.center),
            ),
            Container(
              width: 130,
              height: 30,
              margin: const EdgeInsets.only(left: 20.0),
              child:
                  Text("5", style: PrimaryText2(), textAlign: TextAlign.center),
            ),
            Container(
              width: 130,
              height: 30,
              margin: const EdgeInsets.only(left: 20.0),
              child:
                  Text("6", style: PrimaryText2(), textAlign: TextAlign.center),
            ),
          ],
        ),
      );
    case 7:
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        height: 70.0,
        child: Row(
          children: <Widget>[
            SizedBox(
              child: SizedBox(
                width: 100.0,
                height: 30,
                child: Center(
                    child: Text("Day order",
                        style: PrimaryText2(), textAlign: TextAlign.center)),
              ),
            ),
            Container(
              width: 130,
              height: 30,
              margin: const EdgeInsets.only(left: 50.0),
              child:
                  Text("1", style: PrimaryText2(), textAlign: TextAlign.center),
            ),
            Container(
              width: 130,
              height: 30,
              margin: const EdgeInsets.only(left: 20.0),
              child:
                  Text("2", style: PrimaryText2(), textAlign: TextAlign.center),
            ),
            Container(
              width: 130,
              height: 30,
              margin: const EdgeInsets.only(left: 20.0),
              child:
                  Text("3", style: PrimaryText2(), textAlign: TextAlign.center),
            ),
            Container(
              width: 130,
              height: 30,
              margin: const EdgeInsets.only(left: 20.0),
              child:
                  Text("4", style: PrimaryText2(), textAlign: TextAlign.center),
            ),
            Container(
              width: 130,
              height: 30,
              margin: const EdgeInsets.only(left: 20.0),
              child:
                  Text("5", style: PrimaryText2(), textAlign: TextAlign.center),
            ),
            Container(
              width: 130,
              height: 30,
              margin: const EdgeInsets.only(left: 20.0),
              child:
                  Text("6", style: PrimaryText2(), textAlign: TextAlign.center),
            ),
            Container(
              width: 130,
              height: 30,
              margin: const EdgeInsets.only(left: 20.0),
              child:
                  Text("7", style: PrimaryText2(), textAlign: TextAlign.center),
            ),
          ],
        ),
      );
    case 8:
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        height: 70.0,
        child: Row(
          children: <Widget>[
            SizedBox(
              child: SizedBox(
                width: 100.0,
                height: 30,
                child: Center(
                    child: Text("Day order",
                        style: PrimaryText2(), textAlign: TextAlign.center)),
              ),
            ),
            Container(
              width: 130,
              height: 30,
              margin: const EdgeInsets.only(left: 50.0),
              child:
                  Text("1", style: PrimaryText2(), textAlign: TextAlign.center),
            ),
            Container(
              width: 130,
              height: 30,
              margin: const EdgeInsets.only(left: 20.0),
              child:
                  Text("2", style: PrimaryText2(), textAlign: TextAlign.center),
            ),
            Container(
              width: 130,
              height: 30,
              margin: const EdgeInsets.only(left: 20.0),
              child:
                  Text("3", style: PrimaryText2(), textAlign: TextAlign.center),
            ),
            Container(
              width: 130,
              height: 30,
              margin: const EdgeInsets.only(left: 20.0),
              child:
                  Text("4", style: PrimaryText2(), textAlign: TextAlign.center),
            ),
            Container(
              width: 130,
              height: 30,
              margin: const EdgeInsets.only(left: 20.0),
              child:
                  Text("5", style: PrimaryText2(), textAlign: TextAlign.center),
            ),
            Container(
              width: 130,
              height: 30,
              margin: const EdgeInsets.only(left: 20.0),
              child:
                  Text("6", style: PrimaryText2(), textAlign: TextAlign.center),
            ),
            Container(
              width: 130,
              height: 30,
              margin: const EdgeInsets.only(left: 20.0),
              child:
                  Text("7", style: PrimaryText2(), textAlign: TextAlign.center),
            ),
            Container(
              width: 130,
              height: 30,
              margin: const EdgeInsets.only(left: 20.0),
              child:
                  Text("8", style: PrimaryText2(), textAlign: TextAlign.center),
            ),
          ],
        ),
      );
    case 9:
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        height: 70.0,
        child: Row(
          children: <Widget>[
            SizedBox(
              child: SizedBox(
                width: 100.0,
                height: 30,
                child: Center(
                    child: Text("Day order",
                        style: PrimaryText2(), textAlign: TextAlign.center)),
              ),
            ),
            Container(
              width: 130,
              height: 30,
              margin: const EdgeInsets.only(left: 50.0),
              child:
                  Text("1", style: PrimaryText2(), textAlign: TextAlign.center),
            ),
            Container(
              width: 130,
              height: 30,
              margin: const EdgeInsets.only(left: 20.0),
              child:
                  Text("2", style: PrimaryText2(), textAlign: TextAlign.center),
            ),
            Container(
              width: 130,
              height: 30,
              margin: const EdgeInsets.only(left: 20.0),
              child:
                  Text("3", style: PrimaryText2(), textAlign: TextAlign.center),
            ),
            Container(
              width: 130,
              height: 30,
              margin: const EdgeInsets.only(left: 20.0),
              child:
                  Text("4", style: PrimaryText2(), textAlign: TextAlign.center),
            ),
            Container(
              width: 130,
              height: 30,
              margin: const EdgeInsets.only(left: 20.0),
              child:
                  Text("5", style: PrimaryText2(), textAlign: TextAlign.center),
            ),
            Container(
              width: 130,
              height: 30,
              margin: const EdgeInsets.only(left: 20.0),
              child:
                  Text("6", style: PrimaryText2(), textAlign: TextAlign.center),
            ),
            Container(
              width: 130,
              height: 30,
              margin: const EdgeInsets.only(left: 20.0),
              child:
                  Text("7", style: PrimaryText2(), textAlign: TextAlign.center),
            ),
            Container(
              width: 130,
              height: 30,
              margin: const EdgeInsets.only(left: 20.0),
              child:
                  Text("8", style: PrimaryText2(), textAlign: TextAlign.center),
            ),
            Container(
              width: 130,
              height: 30,
              margin: const EdgeInsets.only(left: 20.0),
              child:
                  Text("9", style: PrimaryText2(), textAlign: TextAlign.center),
            ),
          ],
        ),
      );
    case 10:
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        height: 70.0,
        child: Row(
          children: <Widget>[
            SizedBox(
              child: SizedBox(
                width: 100.0,
                height: 30,
                child: Center(
                    child: Text("Day order",
                        style: PrimaryText2(), textAlign: TextAlign.center)),
              ),
            ),
            Container(
              width: 130,
              height: 30,
              margin: const EdgeInsets.only(left: 50.0),
              child:
                  Text("1", style: PrimaryText2(), textAlign: TextAlign.center),
            ),
            Container(
              width: 130,
              height: 30,
              margin: const EdgeInsets.only(left: 20.0),
              child:
                  Text("2", style: PrimaryText2(), textAlign: TextAlign.center),
            ),
            Container(
              width: 130,
              height: 30,
              margin: const EdgeInsets.only(left: 20.0),
              child:
                  Text("3", style: PrimaryText2(), textAlign: TextAlign.center),
            ),
            Container(
              width: 130,
              height: 30,
              margin: const EdgeInsets.only(left: 20.0),
              child:
                  Text("4", style: PrimaryText2(), textAlign: TextAlign.center),
            ),
            Container(
              width: 130,
              height: 30,
              margin: const EdgeInsets.only(left: 20.0),
              child:
                  Text("5", style: PrimaryText2(), textAlign: TextAlign.center),
            ),
            Container(
              width: 130,
              height: 30,
              margin: const EdgeInsets.only(left: 20.0),
              child:
                  Text("6", style: PrimaryText2(), textAlign: TextAlign.center),
            ),
            Container(
              width: 130,
              height: 30,
              margin: const EdgeInsets.only(left: 20.0),
              child:
                  Text("7", style: PrimaryText2(), textAlign: TextAlign.center),
            ),
            Container(
              width: 130,
              height: 30,
              margin: const EdgeInsets.only(left: 20.0),
              child:
                  Text("8", style: PrimaryText2(), textAlign: TextAlign.center),
            ),
            Container(
              width: 130,
              height: 30,
              margin: const EdgeInsets.only(left: 20.0),
              child:
                  Text("9", style: PrimaryText2(), textAlign: TextAlign.center),
            ),
            Container(
              width: 130,
              height: 30,
              margin: const EdgeInsets.only(left: 20.0),
              child: Text("10",
                  style: PrimaryText2(), textAlign: TextAlign.center),
            ),
          ],
        ),
      );
    default:
      return Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(top: 20),
          child: Center(
              child: Text(
            "Sorry Something went wrong!",
            style: ErrorText2Big(),
            textAlign: TextAlign.center,
          )));
  }
}

Widget StaffTimetableGenerator(
    BuildContext context, StaffTimetableAPI_data data) {
  switch (GetAttencanceHours()) {
    case 4:
      return Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            height: 70.0,
            child: Row(
              children: <Widget>[
                SizedBox(
                  child: SizedBox(
                    width: 100.0,
                    height: 40,
                    child: Center(
                        child: Text(data.dy,
                            style: PrimaryText2Small(),
                            textAlign: TextAlign.center)),
                  ),
                ),
                if (data.c1 == '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          alignment: Alignment.center,
                          width: 130,
                          height: 40,
                          margin: const EdgeInsets.only(left: 50.0),
                          child: Text(
                            '__',
                            style: PrimaryText2Small(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (data.c1 != '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 50.0),
                          child: Text(
                            data.c1,
                            style: PrimaryText2Small(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 50.0, top: 10),
                          child: Text(data.b1,
                              style: SecondaryTextSmall(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
                if (data.c2 == '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          alignment: Alignment.center,
                          width: 130,
                          height: 40,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            '__',
                            style: PrimaryText2Small(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (data.c2 != '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(data.c2,
                              style: PrimaryText2Small(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0, top: 10),
                          child: Text(data.b2,
                              style: SecondaryTextSmall(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
                if (data.c3 == '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          alignment: Alignment.center,
                          width: 130,
                          height: 40,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            '__',
                            style: PrimaryText2Small(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (data.c3 != '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(data.c3,
                              style: PrimaryText2Small(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0, top: 10),
                          child: Text(data.b3,
                              style: SecondaryTextSmall(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
                if (data.c4 == '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          alignment: Alignment.center,
                          width: 130,
                          height: 40,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            '__',
                            style: PrimaryText2Small(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (data.c4 != '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(data.c4,
                              style: PrimaryText2Small(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0, top: 10),
                          child: Text(data.b4,
                              style: SecondaryTextSmall(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          const Divider(height: 10, thickness: 10, indent: 3, endIndent: 3),
        ],
      );
    case 5:
      return Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            height: 60.0,
            child: Row(
              children: <Widget>[
                SizedBox(
                  child: SizedBox(
                    width: 60.0,
                    height: 40,
                    child: Center(
                        child: Text(data.dy,
                            style: PrimaryText4(),
                            textAlign: TextAlign.center)),
                  ),
                ),
                if (data.c1 == '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          alignment: Alignment.center,
                          width: 60,
                          height: 45,
                          margin: const EdgeInsets.only(left: 50.0),
                          child: Text(
                            '__',
                            style: PrimaryText4(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (data.c1 != '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          width: 60,
                          height: 15,
                          margin: const EdgeInsets.only(left: 50.0),
                          child: Text(
                            data.c1,
                            style: PrimaryText4(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(
                        child: Container(
                          width: 60,
                          height: 30,
                          margin: const EdgeInsets.only(left: 50.0, top: 10),
                          child: Text(data.b1,
                              style: PrimaryText4(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
                if (data.c2 == '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          alignment: Alignment.center,
                          width: 60,
                          height: 42,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            '__',
                            style: PrimaryText4(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (data.c2 != '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          width: 60,
                          height: 15,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(data.c2,
                              style: PrimaryText4(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                      SizedBox(
                        child: Container(
                          width: 60,
                          height: 30,
                          margin: const EdgeInsets.only(left: 20.0, top: 10),
                          child: Text(data.b2,
                              style: PrimaryText4(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
                if (data.c3 == '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          alignment: Alignment.center,
                          width: 60,
                          height: 40,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            '__',
                            style: PrimaryText4(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (data.c3 != '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          width: 60,
                          height: 15,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(data.c3,
                              style: PrimaryText4(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                      SizedBox(
                        child: Container(
                          width: 60,
                          height: 30,
                          margin: const EdgeInsets.only(left: 20.0, top: 10),
                          child: Text(data.b3,
                              style: PrimaryText4(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
                if (data.c4 == '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          alignment: Alignment.center,
                          width: 60,
                          height: 40,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            '__',
                            style: PrimaryText4(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (data.c4 != '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          width: 60,
                          height: 15,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(data.c4,
                              style: PrimaryText4(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                      SizedBox(
                        child: Container(
                          width: 60,
                          height: 30,
                          margin: const EdgeInsets.only(left: 20.0, top: 10),
                          child: Text(data.b4,
                              style: PrimaryText4(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
                if (data.c5 == '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          alignment: Alignment.center,
                          width: 60,
                          height: 40,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            '__',
                            style: PrimaryText4(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (data.c5 != '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          width: 60,
                          height: 15,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(data.c5,
                              style: PrimaryText4(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                      SizedBox(
                        child: Container(
                          width: 60,
                          height: 30,
                          margin: const EdgeInsets.only(left: 20.0, top: 10),
                          child: Text(data.b5,
                              style: PrimaryText4(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          const Divider(height: 10, thickness: 10, indent: 3, endIndent: 3),
        ],
      );
    case 6:
      return Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            height: 70.0,
            child: Row(
              children: <Widget>[
                SizedBox(
                  child: SizedBox(
                    width: 100.0,
                    height: 40,
                    child: Center(
                        child: Text(data.dy,
                            style: PrimaryText2Small(),
                            textAlign: TextAlign.center)),
                  ),
                ),
                if (data.c1 == '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          alignment: Alignment.center,
                          width: 130,
                          height: 40,
                          margin: const EdgeInsets.only(left: 50.0),
                          child: Text(
                            '__',
                            style: PrimaryText2Small(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (data.c1 != '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 50.0),
                          child: Text(
                            data.c1,
                            style: PrimaryText2Small(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 50.0, top: 10),
                          child: Text(data.b1,
                              style: SecondaryTextSmall(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
                if (data.c2 == '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          alignment: Alignment.center,
                          width: 130,
                          height: 40,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            '__',
                            style: PrimaryText2Small(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (data.c2 != '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(data.c2,
                              style: PrimaryText2Small(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0, top: 10),
                          child: Text(data.b2,
                              style: SecondaryTextSmall(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
                if (data.c3 == '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          alignment: Alignment.center,
                          width: 130,
                          height: 40,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            '__',
                            style: PrimaryText2Small(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (data.c3 != '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(data.c3,
                              style: PrimaryText2Small(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0, top: 10),
                          child: Text(data.b3,
                              style: SecondaryTextSmall(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
                if (data.c4 == '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          alignment: Alignment.center,
                          width: 130,
                          height: 40,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            '__',
                            style: PrimaryText2Small(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (data.c4 != '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(data.c4,
                              style: PrimaryText2Small(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0, top: 10),
                          child: Text(data.b4,
                              style: SecondaryTextSmall(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
                if (data.c5 == '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          alignment: Alignment.center,
                          width: 130,
                          height: 40,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            '__',
                            style: PrimaryText2Small(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (data.c5 != '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(data.c5,
                              style: PrimaryText2Small(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0, top: 10),
                          child: Text(data.b5,
                              style: SecondaryTextSmall(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
                if (data.c6 == '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          alignment: Alignment.center,
                          width: 130,
                          height: 40,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            '__',
                            style: PrimaryText2Small(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (data.c6 != '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(data.c6,
                              style: PrimaryText2Small(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0, top: 10),
                          child: Text(data.b6,
                              style: SecondaryTextSmall(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          const Divider(height: 10, thickness: 10, indent: 3, endIndent: 3),
        ],
      );
    case 7:
      return Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            height: 70.0,
            child: Row(
              children: <Widget>[
                SizedBox(
                  child: SizedBox(
                    width: 100.0,
                    height: 40,
                    child: Center(
                        child: Text(data.dy,
                            style: PrimaryText2Small(),
                            textAlign: TextAlign.center)),
                  ),
                ),
                if (data.c1 == '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          alignment: Alignment.center,
                          width: 130,
                          height: 40,
                          margin: const EdgeInsets.only(left: 50.0),
                          child: Text(
                            '__',
                            style: PrimaryText2Small(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (data.c1 != '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 50.0),
                          child: Text(
                            data.c1,
                            style: PrimaryText2Small(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 50.0, top: 10),
                          child: Text(data.b1,
                              style: SecondaryTextSmall(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
                if (data.c2 == '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          alignment: Alignment.center,
                          width: 130,
                          height: 40,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            '__',
                            style: PrimaryText2Small(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (data.c2 != '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(data.c2,
                              style: PrimaryText2Small(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0, top: 10),
                          child: Text(data.b2,
                              style: SecondaryTextSmall(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
                if (data.c3 == '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          alignment: Alignment.center,
                          width: 130,
                          height: 40,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            '__',
                            style: PrimaryText2Small(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (data.c3 != '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(data.c3,
                              style: PrimaryText2Small(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0, top: 10),
                          child: Text(data.b3,
                              style: SecondaryTextSmall(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
                if (data.c4 == '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          alignment: Alignment.center,
                          width: 130,
                          height: 40,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            '__',
                            style: PrimaryText2Small(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (data.c4 != '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(data.c4,
                              style: PrimaryText2Small(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0, top: 10),
                          child: Text(data.b4,
                              style: SecondaryTextSmall(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
                if (data.c5 == '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          alignment: Alignment.center,
                          width: 130,
                          height: 40,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            '__',
                            style: PrimaryText2Small(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (data.c5 != '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(data.c5,
                              style: PrimaryText2Small(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0, top: 10),
                          child: Text(data.b5,
                              style: SecondaryTextSmall(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
                if (data.c6 == '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          alignment: Alignment.center,
                          width: 130,
                          height: 40,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            '__',
                            style: PrimaryText2Small(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (data.c6 != '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(data.c6,
                              style: PrimaryText2Small(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0, top: 10),
                          child: Text(data.b6,
                              style: SecondaryTextSmall(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
                if (data.c7 == '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          alignment: Alignment.center,
                          width: 130,
                          height: 40,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            '__',
                            style: PrimaryText2Small(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (data.c7 != '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(data.c7,
                              style: PrimaryText2Small(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0, top: 10),
                          child: Text(data.b7,
                              style: SecondaryTextSmall(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          const Divider(height: 10, thickness: 10, indent: 3, endIndent: 3),
        ],
      );
    case 8:
      return Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            height: 70.0,
            child: Row(
              children: <Widget>[
                SizedBox(
                  child: SizedBox(
                    width: 100.0,
                    height: 40,
                    child: Center(
                        child: Text(data.dy,
                            style: PrimaryText2Small(),
                            textAlign: TextAlign.center)),
                  ),
                ),
                if (data.c1 == '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          alignment: Alignment.center,
                          width: 130,
                          height: 40,
                          margin: const EdgeInsets.only(left: 50.0),
                          child: Text(
                            '__',
                            style: PrimaryText2Small(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (data.c1 != '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 50.0),
                          child: Text(
                            data.c1,
                            style: PrimaryText2Small(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 50.0, top: 10),
                          child: Text(data.b1,
                              style: SecondaryTextSmall(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
                if (data.c2 == '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          alignment: Alignment.center,
                          width: 130,
                          height: 40,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            '__',
                            style: PrimaryText2Small(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (data.c2 != '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(data.c2,
                              style: PrimaryText2Small(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0, top: 10),
                          child: Text(data.b2,
                              style: SecondaryTextSmall(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
                if (data.c3 == '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          alignment: Alignment.center,
                          width: 130,
                          height: 40,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            '__',
                            style: PrimaryText2Small(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (data.c3 != '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(data.c3,
                              style: PrimaryText2Small(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0, top: 10),
                          child: Text(data.b3,
                              style: SecondaryTextSmall(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
                if (data.c4 == '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          alignment: Alignment.center,
                          width: 130,
                          height: 40,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            '__',
                            style: PrimaryText2Small(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (data.c4 != '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(data.c4,
                              style: PrimaryText2Small(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0, top: 10),
                          child: Text(data.b4,
                              style: SecondaryTextSmall(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
                if (data.c5 == '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          alignment: Alignment.center,
                          width: 130,
                          height: 40,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            '__',
                            style: PrimaryText2Small(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (data.c5 != '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(data.c5,
                              style: PrimaryText2Small(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0, top: 10),
                          child: Text(data.b5,
                              style: SecondaryTextSmall(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
                if (data.c6 == '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          alignment: Alignment.center,
                          width: 130,
                          height: 40,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            '__',
                            style: PrimaryText2Small(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (data.c6 != '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(data.c6,
                              style: PrimaryText2Small(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0, top: 10),
                          child: Text(data.b6,
                              style: SecondaryTextSmall(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
                if (data.c7 == '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          alignment: Alignment.center,
                          width: 130,
                          height: 40,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            '__',
                            style: PrimaryText2Small(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (data.c7 != '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(data.c7,
                              style: PrimaryText2Small(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0, top: 10),
                          child: Text(data.b7,
                              style: SecondaryTextSmall(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
                if (data.c8 == '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          alignment: Alignment.center,
                          width: 130,
                          height: 40,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            '__',
                            style: PrimaryText2Small(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (data.c8 != '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(data.c8,
                              style: PrimaryText2Small(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0, top: 10),
                          child: Text(data.b8,
                              style: SecondaryTextSmall(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          const Divider(height: 10, thickness: 10, indent: 3, endIndent: 3),
        ],
      );
    case 9:
      return Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            height: 70.0,
            child: Row(
              children: <Widget>[
                SizedBox(
                  child: SizedBox(
                    width: 100.0,
                    height: 40,
                    child: Center(
                        child: Text(data.dy,
                            style: PrimaryText2Small(),
                            textAlign: TextAlign.center)),
                  ),
                ),
                if (data.c1 == '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          alignment: Alignment.center,
                          width: 130,
                          height: 40,
                          margin: const EdgeInsets.only(left: 50.0),
                          child: Text(
                            '__',
                            style: PrimaryText2Small(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (data.c1 != '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 50.0),
                          child: Text(
                            data.c1,
                            style: PrimaryText2Small(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 50.0, top: 10),
                          child: Text(data.b1,
                              style: SecondaryTextSmall(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
                if (data.c2 == '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          alignment: Alignment.center,
                          width: 130,
                          height: 40,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            '__',
                            style: PrimaryText2Small(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (data.c2 != '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(data.c2,
                              style: PrimaryText2Small(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0, top: 10),
                          child: Text(data.b2,
                              style: SecondaryTextSmall(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
                if (data.c3 == '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          alignment: Alignment.center,
                          width: 130,
                          height: 40,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            '__',
                            style: PrimaryText2Small(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (data.c3 != '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(data.c3,
                              style: PrimaryText2Small(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0, top: 10),
                          child: Text(data.b3,
                              style: SecondaryTextSmall(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
                if (data.c4 == '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          alignment: Alignment.center,
                          width: 130,
                          height: 40,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            '__',
                            style: PrimaryText2Small(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (data.c4 != '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(data.c4,
                              style: PrimaryText2Small(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0, top: 10),
                          child: Text(data.b4,
                              style: SecondaryTextSmall(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
                if (data.c5 == '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          alignment: Alignment.center,
                          width: 130,
                          height: 40,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            '__',
                            style: PrimaryText2Small(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (data.c5 != '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(data.c5,
                              style: PrimaryText2Small(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0, top: 10),
                          child: Text(data.b5,
                              style: SecondaryTextSmall(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
                if (data.c6 == '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          alignment: Alignment.center,
                          width: 130,
                          height: 40,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            '__',
                            style: PrimaryText2Small(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (data.c6 != '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(data.c6,
                              style: PrimaryText2Small(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0, top: 10),
                          child: Text(data.b6,
                              style: SecondaryTextSmall(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
                if (data.c7 == '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          alignment: Alignment.center,
                          width: 130,
                          height: 40,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            '__',
                            style: PrimaryText2Small(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (data.c7 != '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(data.c7,
                              style: PrimaryText2Small(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0, top: 10),
                          child: Text(data.b7,
                              style: SecondaryTextSmall(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
                if (data.c8 == '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          alignment: Alignment.center,
                          width: 130,
                          height: 40,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            '__',
                            style: PrimaryText2Small(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (data.c8 != '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(data.c8,
                              style: PrimaryText2Small(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0, top: 10),
                          child: Text(data.b8,
                              style: SecondaryTextSmall(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
                if (data.c9 == '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          alignment: Alignment.center,
                          width: 130,
                          height: 40,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            '__',
                            style: PrimaryText2Small(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (data.c9 != '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(data.c9,
                              style: PrimaryText2Small(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0, top: 10),
                          child: Text(data.b9,
                              style: SecondaryTextSmall(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          const Divider(height: 10, thickness: 10, indent: 3, endIndent: 3),
        ],
      );
    case 10:
      return Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            height: 70.0,
            child: Row(
              children: <Widget>[
                SizedBox(
                  child: SizedBox(
                    width: 100.0,
                    height: 40,
                    child: Center(
                        child: Text(data.dy,
                            style: PrimaryText2Small(),
                            textAlign: TextAlign.center)),
                  ),
                ),
                if (data.c1 == '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          alignment: Alignment.center,
                          width: 130,
                          height: 40,
                          margin: const EdgeInsets.only(left: 50.0),
                          child: Text(
                            '__',
                            style: PrimaryText2Small(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (data.c1 != '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 50.0),
                          child: Text(
                            data.c1,
                            style: PrimaryText2Small(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 50.0, top: 10),
                          child: Text(data.b1,
                              style: SecondaryTextSmall(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
                if (data.c2 == '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          alignment: Alignment.center,
                          width: 130,
                          height: 40,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            '__',
                            style: PrimaryText2Small(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (data.c2 != '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(data.c2,
                              style: PrimaryText2Small(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0, top: 10),
                          child: Text(data.b2,
                              style: SecondaryTextSmall(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
                if (data.c3 == '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          alignment: Alignment.center,
                          width: 130,
                          height: 40,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            '__',
                            style: PrimaryText2Small(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (data.c3 != '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(data.c3,
                              style: PrimaryText2Small(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0, top: 10),
                          child: Text(data.b3,
                              style: SecondaryTextSmall(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
                if (data.c4 == '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          alignment: Alignment.center,
                          width: 130,
                          height: 40,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            '__',
                            style: PrimaryText2Small(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (data.c4 != '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(data.c4,
                              style: PrimaryText2Small(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0, top: 10),
                          child: Text(data.b4,
                              style: SecondaryTextSmall(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
                if (data.c5 == '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          alignment: Alignment.center,
                          width: 130,
                          height: 40,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            '__',
                            style: PrimaryText2Small(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (data.c5 != '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(data.c5,
                              style: PrimaryText2Small(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0, top: 10),
                          child: Text(data.b5,
                              style: SecondaryTextSmall(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
                if (data.c6 == '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          alignment: Alignment.center,
                          width: 130,
                          height: 40,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            '__',
                            style: PrimaryText2Small(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (data.c6 != '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(data.c6,
                              style: PrimaryText2Small(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0, top: 10),
                          child: Text(data.b6,
                              style: SecondaryTextSmall(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
                if (data.c7 == '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          alignment: Alignment.center,
                          width: 130,
                          height: 40,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            '__',
                            style: PrimaryText2Small(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (data.c7 != '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(data.c7,
                              style: PrimaryText2Small(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0, top: 10),
                          child: Text(data.b7,
                              style: SecondaryTextSmall(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
                if (data.c8 == '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          alignment: Alignment.center,
                          width: 130,
                          height: 40,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            '__',
                            style: PrimaryText2Small(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (data.c8 != '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(data.c8,
                              style: PrimaryText2Small(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0, top: 10),
                          child: Text(data.b8,
                              style: SecondaryTextSmall(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
                if (data.c9 == '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          alignment: Alignment.center,
                          width: 130,
                          height: 40,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            '__',
                            style: PrimaryText2Small(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (data.c9 != '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(data.c9,
                              style: PrimaryText2Small(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0, top: 10),
                          child: Text(data.b9,
                              style: SecondaryTextSmall(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
                if (data.c10 == '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          alignment: Alignment.center,
                          width: 130,
                          height: 40,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            '__',
                            style: PrimaryText2Small(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (data.c10 != '- N/A -')
                  Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Text(data.c10,
                              style: PrimaryText2Small(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                      SizedBox(
                        child: Container(
                          width: 130,
                          height: 20,
                          margin: const EdgeInsets.only(left: 20.0, top: 10),
                          child: Text(data.b10,
                              style: SecondaryTextSmall(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          const Divider(height: 10, thickness: 10, indent: 3, endIndent: 3),
        ],
      );
    default:
      return Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(top: 20),
          child: Center(
              child: Text(
            "Sorry Something went wrong!",
            style: ErrorText2Big(),
            textAlign: TextAlign.center,
          )));
  }
}

Widget StaffHolidayGenerator(BuildContext context, StaffHolidayAPI_data data) =>
    Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(left: 15.0, top: 8, right: 15.0),
          padding: const EdgeInsets.only(right: 10.0, left: 10.0),
          width: sWidth(90, context),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: sHeight(1, context),
              ),
              Row(children: <Widget>[
                SizedBox(
                  height: sHeight(2, context),
                ),
                SizedBox(
                  width: sWidth(60, context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      data.Name.length < 20 ?Text("${data.Name.characters.take(20)}",style:
                      const TextStyle(fontSize: 20,fontWeight: FontWeight.w800),):Text("${data.Name.characters.take(18)}...",style:
                      const TextStyle(fontSize: 20,fontWeight: FontWeight.w800),),
                      SizedBox(
                        height: sHeight(1, context),
                      ),
                      Text(
                        data.Date,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: sHeight(1, context),
                      ),
                      /*Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.all(
                                Radius.circular(3),
                              ),
                            ),
                            child: Text(
                              "${data.Day}",
                              style: SecondaryText(),
                            ),
                          ),*/

                      /* mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.only(top: 5, left: 0),
                            height: 25.0,
                            child: SizedBox(
                                child: Text("${data.Name} - ${data.Remark} ",
                                    style: PrimaryText5()))),
                        AttendanceProfile("${data.Date} (${data.Day})", 10, 0),*/
                      // AttendanceProfile(
                      //     "${data.Day}", 10, 0),
                    ],
                  ),
                ),
                SizedBox(
                  width: sWidth(8, context),
                ),
                Container(
                  height: sHeight(4, context),
                  width: sWidth(15, context),
                  alignment: Alignment.centerRight,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(
                      Radius.circular(3),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "${data.Day.characters.take(3).toUpperCase()}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                  ),
                ),
              ]),
              SizedBox(
                height: sHeight(1, context),
              ),
            ],
          ),
        ),
      ],
    );

Widget StaffCircularGenerator(
    BuildContext context, StaffCircularAPI_data data) {
  if (data.Discription.length < 28) {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(left: 15.0, top: 10.0, right: 15.0),
          padding: const EdgeInsets.only(right: 15.0, left: 15.0),
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              )),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: sHeight(1.5, context),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      width: sWidth(25, context),
                      height: sHeight(5, context),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: Center(
                          child: Text(data.Remark,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800)))),
                  InkWell(
                    onTap: () => LaunchTheFile(data.File),
                    child: Container(
                      width: sWidth(15, context),
                      height: sHeight(5, context),
                      decoration: const BoxDecoration(
                          color: Color(0xFFF84259),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Icon(
                              Icons.cloud_download_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: sHeight(2, context),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: sWidth(80, context),
                    child: Text(
                      "${data.Discription} - ${data.CreatedBy}",textAlign: TextAlign.left, maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w900),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: sHeight(2, context),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      margin: const EdgeInsets.only(top: 2, left: 0),
                      height: 20.0,
                      child: SizedBox(
                          child: Row(
                            children: [
                              const Text(
                                "Date :",
                                style: TextStyle(color: Colors.black54),
                              ),
                              Text(" ${data.CircularDate}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700)),
                            ],
                          ),
                      )
                  ), Container(
                      margin: const EdgeInsets.only(top: 2, left: 0),
                      height: 20.0,
                      child: SizedBox(
                          child: Row(
                            children: [
                              const Text(
                                "Day :",
                                style: TextStyle(color: Colors.black54),
                              ),
                              Text(" ${data.Day}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700)),
                            ],
                          ),
                      )
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
    );
  }
  else {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(left: 15.0, top: 10.0, right: 15.0),
          padding: const EdgeInsets.only(right: 15.0, left: 15.0),
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              )),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: sHeight(1.5, context),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      width: sWidth(25, context),
                      height: sHeight(5, context),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: Center(
                          child: Text(data.Remark,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800)))),
                  InkWell(
                    onTap: () => LaunchTheFile(data.File),
                    child: Container(
                      width: sWidth(15, context),
                      height: sHeight(5, context),
                      decoration: const BoxDecoration(
                          color: Color(0xFFF84259),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Icon(
                              Icons.cloud_download_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: sHeight(2, context),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: sWidth(80, context),
                    child: Text(
                      "${data.Discription} - ${data.CreatedBy}",textAlign: TextAlign.left, maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w900),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: sHeight(2, context),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      margin: const EdgeInsets.only(top: 2, left: 0),
                      height: 20.0,
                      child: SizedBox(
                          child: Row(
                            children: [
                              const Text(
                                "Date :",
                                style: TextStyle(color: Colors.black54),
                              ),
                              Text(" ${data.CircularDate}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700)),
                            ],
                          ))),Container(
                      margin: const EdgeInsets.only(top: 2, left: 0),
                      height: 20.0,
                      child: SizedBox(
                          child: Row(
                            children: [
                              const Text(
                                "Day :",
                                style: TextStyle(color: Colors.black54),
                              ),
                              Text(" ${data.Day}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700)),
                            ],
                          ))),
                ],
              ),
              SizedBox(
                height: sHeight(1.5, context),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Widget StaffOPACGenerator(
    BuildContext context, List<StaffOPACSearchAPI_data> data, int index) {
  if (index % 2 == 0) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                padding: const EdgeInsets.all(15),
                width: sWidth(90, context),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: sHeight(4, context),
                          width: sWidth(33, context),
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.all(
                              Radius.circular(7),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Row No : ${data[index].RowNo}",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800),
                            ),
                          ),
                        ),
                        Container(
                          height: sHeight(4, context),
                          width: sWidth(33, context),
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.all(
                              Radius.circular(7),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "ACC No : ${data[index].AccNo}",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: sHeight(3, context),
                    ),
                    Container(
                        child: Row(
                          children: [
                            SizedBox(
                                width: sWidth(10, context),
                                child: const Icon(CupertinoIcons.book)),
                            Container(
                                child: Text(
                                  "Title          :  ",
                                  style: PrimaryText5(),
                                )),
                            SizedBox(
                              width: sWidth(48, context),
                              child: Text(
                                data[index].Title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: PrimaryText5(),
                              ),
                            ),
                          ],
                        )),
                    SizedBox(
                      height: sHeight(2, context),
                    ),
                    Container(
                      child: Row(
                        children: [
                          SizedBox(
                              width: sWidth(10, context),
                              child: const Icon(Icons.people_alt_rounded)),
                          Container(
                              child: Text(
                                "Author      :  ",
                                style: PrimaryText5(),
                              )),
                          SizedBox(
                            width: sWidth(48, context),
                            child: Text(
                              data[index].Author,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: PrimaryText5(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: sHeight(2, context),
                    ),
                    Container(
                        child: Row(
                          children: [
                            SizedBox(
                                width: sWidth(10, context),
                                child: const Icon(Icons.local_library_rounded)),
                            Container(
                                child: Text(
                                  "Publisher :  ",
                                  style: PrimaryText5(),
                                )),
                            SizedBox(
                              width: sWidth(48, context),
                              child: Text(
                                data[index].Publisher,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: PrimaryText5(),
                              ),
                            ),
                          ],
                        )),
                    SizedBox(
                      height: sHeight(2, context),
                    ),
                    Row(
                      children: [
                        SizedBox(
                            width: sWidth(10, context),
                            child: const Icon(Icons.book_rounded)),
                        Container(
                          child: Text(
                            " Edition     :  ",
                            style: PrimaryText5(),
                          ),
                        ),
                        Container(
                          child: Text(data[index].Edition,
                              style: PrimaryText5(),
                              textAlign: TextAlign.start),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: sHeight(2, context),
                    ),
                    Row(
                      children: [
                        SizedBox(
                            width: sWidth(10, context),
                            child: const Icon(Icons.location_city_outlined)),
                        Container(
                          child: Text(
                            " Depart     :  ",
                            style: PrimaryText5(),
                          ),
                        ),
                        Container(
                          child: Text(data[index].DepartmentShortName,
                              style: PrimaryText5(),
                              textAlign: TextAlign.start),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: sHeight(2, context),
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: sWidth(10, context),
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          data[index].Library,
                          style: PrimaryText5(),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: sHeight(2, context),
                    ),
                  ],
                ),
              ),
            ),
            if (index + 1 <= data.length - 1)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(15),
                      width: sWidth(90, context),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: sHeight(4, context),
                                width: sWidth(33, context),
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(7),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "Row No : ${data[index].RowNo}",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ),
                              ),
                              Container(
                                height: sHeight(4, context),
                                width: sWidth(33, context),
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(7),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "ACC No : ${data[index + 1].AccNo}",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: sHeight(3, context),
                          ),
                          Container(
                              child: Row(
                                children: [
                                  SizedBox(
                                      width: sWidth(10, context),
                                      child: const Icon(CupertinoIcons.book)),
                                  Container(
                                      child: Text(
                                        "Title          :  ",
                                        style: PrimaryText5(),
                                      )),
                                  SizedBox(
                                    width: sWidth(48, context),
                                    child: Text(
                                      data[index + 1].Title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: PrimaryText5(),
                                    ),
                                  ),
                                ],
                              )),
                          SizedBox(
                            height: sHeight(2, context),
                          ),
                          Container(
                            child: Row(
                              children: [
                                SizedBox(
                                    width: sWidth(10, context),
                                    child: const Icon(Icons.people_alt_rounded)),
                                Container(
                                    child: Text(
                                      "Author      :  ",
                                      style: PrimaryText5(),
                                    )),
                                SizedBox(
                                  width: sWidth(48, context),
                                  child: Text(
                                    data[index + 1].Author,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: PrimaryText5(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: sHeight(2, context),
                          ),
                          Container(
                              child: Row(
                                children: [
                                  SizedBox(
                                      width: sWidth(10, context),
                                      child: const Icon(Icons.local_library_rounded)),
                                  Container(
                                      child: Text(
                                        "Publisher :  ",
                                        style: PrimaryText5(),
                                      )),
                                  SizedBox(
                                    width: sWidth(48, context),
                                    child: Text(
                                      data[index +1].Publisher,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: PrimaryText5(),
                                    ),
                                  ),
                                ],
                              )),
                          SizedBox(
                            height: sHeight(2, context),
                          ),
                          Row(
                            children: [
                              SizedBox(
                                  width: sWidth(10, context),
                                  child: const Icon(Icons.book_rounded)),
                              Container(
                                child: Text(
                                  " Edition     :  ",
                                  style: PrimaryText5(),
                                ),
                              ),
                              Container(
                                child: Text(data[index + 1].Edition,
                                    style: PrimaryText5(),
                                    textAlign: TextAlign.start),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: sHeight(2, context),
                          ),
                          Row(
                            children: [
                              SizedBox(
                                  width: sWidth(10, context),
                                  child: const Icon(Icons.location_city_outlined)),
                              Container(
                                child: Text(
                                  " Depart     :  ",
                                  style: PrimaryText5(),
                                ),
                              ),
                              Container(
                                child: Text(
                                    data[index + 1].DepartmentShortName,
                                    style: PrimaryText5(),
                                    textAlign: TextAlign.start),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: sHeight(2, context),
                          ),
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: sWidth(10, context),
                                child: const Icon(
                                  Icons.location_on,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                data[index + 1].Library,
                                style: PrimaryText5(),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: sHeight(2, context),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  } else {
    return Container();
  }
}

Widget StaffLibraryGenerator(
    BuildContext context, List<LibraryAPI_data> data, int index) {
  if (index % 2 == 0) {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: sHeight(1, context),
          ),
          Container(
            width: sWidth(90, context),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                )),
            child:  Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      SizedBox(
                        height: sHeight(2, context),
                      ),
                      Container(
                        child: Row(
                          children: [
                            SizedBox(
                              width: sWidth(20, context),
                              child: Text(
                                "Type  ",
                                style: SecondaryText(),
                              ),
                            ),
                            const Text(":"),
                            Container(
                              child: Text(
                                "   ${data[index].MatrialType}",
                                style: SecondaryText4(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: sHeight(3, context),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: sWidth(18, context),
                              child: Text(
                                "Title ",
                                style: SecondaryText(),
                              ),
                            ),
                            const Text(":"),
                            SizedBox(
                              width: sWidth(59, context),
                              child: Text(
                                data[index].Title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: SecondaryText4(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: sHeight(3, context),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: sWidth(18, context),
                              child: Text(
                                "Author",
                                style: SecondaryText(),
                              ),
                            ),
                            const Text(":"),
                            SizedBox(
                              width: sWidth(60, context),
                              child: Text(
                                " ${data[index].Author}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: SecondaryText4(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: sHeight(2, context),
                      ),
                      const Divider(
                        thickness: 0.5,
                        color: Colors.black,
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text(
                                "Status  ",
                                style: SecondaryText(),
                              ),
                            ),
                            Container(
                              child: Text(
                                data[index].TransactionType,
                                style: SecondaryText4(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    print(ID);
                    print(Code);
                    showDialog<void>(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            title: const Text("More Details"),
                            content: SizedBox(
                              // height: sHeight(100, context),
                              width: sWidth(90, context),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                  children: [

                                    SizedBox(
                                      height: sHeight(1, context),
                                    ),
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            child: Text(
                                              "Issue Date",
                                              style: SecondaryText(),
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              data[index].IssueDate,
                                              style: SecondaryText4(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: sHeight(1, context),
                                    ),
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            child: Text(
                                              "Due Date",
                                              style: SecondaryText(),
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              data[index].DueDate,
                                              style: SecondaryText4(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: sHeight(1, context),
                                    ),
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            child: Text(
                                              "Return Date ",
                                              style: SecondaryText(),
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              data[index].ReturnDate,
                                              style: SecondaryText4(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: sHeight(1, context),
                                    ),
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            child: Text(
                                              "Remark ",
                                              style: SecondaryText(),
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              " ${data[index].Remark}",
                                              style: SecondaryText4(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: sHeight(1, context),
                                    ),Container(
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            child: Text(
                                              "Over Due ",
                                              style: SecondaryText(),
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              " ₹ ${data[index].OverDueAmount}",
                                              style: SecondaryText4(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: sHeight(1, context),
                                    ),
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            child: Text(
                                              "Paid ",
                                              style: SecondaryText(),
                                            ),
                                          ),
                                          Container(
                                            child:
                                           data[index].Paid == '-'.toString() ? Text(
                                              data[index].Paid,
                                              style: SecondaryText4(),
                                            ): Text(
                                             "₹ ${data[index].Paid}",
                                             style: SecondaryText4(),
                                           ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: sHeight(1, context),
                                    ),
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            child:
                                            Text(
                                              "Balance",
                                              style: SecondaryText(),
                                            ),
                                          ),
                                          Container(
                                            child: data[index].Balance == '-'.toString() ? Text(
                                              data[index].Balance,
                                              style: SecondaryText4(),
                                            ): Text(
                                              "₹ ${data[index].Balance}",
                                              style: SecondaryText4(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  },
                  child: Container(
                    height: sHeight(5, context),
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        )),
                    child: const Center(
                      child: Text(
                        "Show More",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ),
              ],
            ),

          ),
          SizedBox(
            height: sHeight(1, context),
          ),
          if (index + 1 <= data.length - 1)
            Container(
              width: sWidth(90, context),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  )),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        SizedBox(
                          height: sHeight(2, context),
                        ),
                        Container(
                          child: Row(
                            children: [
                              SizedBox(
                                width: sWidth(20, context),
                                child: Text(
                                  "Type         ",
                                  style: SecondaryText(),
                                ),
                              ),
                              const Text(":"),
                              Container(
                                child: Text(
                                  "   ${data[index+1].MatrialType}",
                                  style: SecondaryText4(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: sHeight(3, context),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: sWidth(18, context),
                                child: Text(
                                  "Title ",
                                  style: SecondaryText(),
                                ),
                              ),
                              const Text(":"),
                              SizedBox(
                                width: sWidth(59, context),
                                child: Text(
                                  data[index+1].Title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: SecondaryText4(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: sHeight(3, context),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: sWidth(18, context),
                                child: Text(
                                  "Author",
                                  style: SecondaryText(),
                                ),
                              ),
                              const Text(":"),
                              SizedBox(
                                width: sWidth(60, context),
                                child: Text(
                                  " ${data[index+1].Author}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: SecondaryText4(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: sHeight(2, context),
                        ),
                        const Divider(
                          thickness: 0.5,
                          color: Colors.black,
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Text(
                                  "Status  ",
                                  style: SecondaryText(),
                                ),
                              ),
                              Container(
                                child: Text(
                                  data[index+1].TransactionType,
                                  style: SecondaryText4(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      print(ID);
                      print(Code);
                      showDialog<void>(
                          context: context,
                          barrierDismissible: true,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: Colors.white,
                              title: const Text("More Details"),
                              content: SizedBox(
                                // height: sHeight(100, context),
                                width: sWidth(90, context),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: sHeight(1, context),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Issue Date",
                                            style: SecondaryText(),
                                          ),
                                          Text(
                                            data[index+1].IssueDate,
                                            style: SecondaryText4(),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: sHeight(1, context),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Due Date  ",
                                            style: SecondaryText(),
                                          ),
                                          Text(
                                            data[index+1].DueDate,
                                            style: SecondaryText4(),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: sHeight(1, context),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            child: Text(
                                              "Return Date ",
                                              style: SecondaryText(),
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              data[index+1].ReturnDate,
                                              style: SecondaryText4(),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: sHeight(1, context),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Remark ",
                                            style: SecondaryText(),
                                          ),
                                          Text(
                                            data[index + 1].Remark,
                                            style: SecondaryText4(),
                                          ),
                                        ],
                                      ),SizedBox(
                                        height: sHeight(1, context),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            child: Text(
                                              "Amount ",
                                              style: SecondaryText(),
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              "₹ ${data[index + 1].OverDueAmount}",
                                              style: SecondaryText4(),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: sHeight(1, context),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Paid ",
                                            style: SecondaryText(),
                                          ),
                                          Container(
                                            child:
                                            data[index + 1].Paid == '-'.toString() ? Text(
                                              data[index + 1].Paid,
                                              style: SecondaryText4(),
                                            ): Text(
                                              "₹ ${data[index + 1].Paid}",
                                              style: SecondaryText4(),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: sHeight(1, context),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Balance",
                                            style: SecondaryText(),
                                          ),
                                          Container(
                                            child:
                                            data[index+1].Balance == '-'.toString() ? Text(
                                              data[index+1].Balance,
                                              style: SecondaryText4(),
                                            ): Text(
                                              "₹ ${data[index+1].Balance}",
                                              style: SecondaryText4(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                    child: Container(
                      height: sHeight(5, context),
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          )),
                      child: const Center(
                        child: Text(
                          "Show More",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  } else {
    return Container();
  }
}

Widget StaffAttendaceRecordTitleGeterator(BuildContext context) => Column(
  children: <Widget>[
    Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 1),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: sWidth(30, context),
                child: Center(
                    child: Text(
                      'Date',
                      style: PrimaryText2(),
                      textAlign: TextAlign.center,
                    )),
              ),
              Container(
                width: sWidth(22, context),
                margin: const EdgeInsets.only(left: 10.0),
                child: Center(
                    child: Text(
                      'FN',
                      style: PrimaryText2(),
                      textAlign: TextAlign.center,
                    )),
              ),
              Container(
                width: sWidth(22, context),
                margin: const EdgeInsets.only(left: 10.0),
                child: Center(
                    child: Text(
                      'AN',
                      style: PrimaryText2(),
                      textAlign: TextAlign.center,
                    )),
              ),
            ],
          ),
        ],
      ),
    ),
  ],
);

Widget StaffAttendaceRecordGeterator(
    BuildContext context, StaffAttendanceRecordAPI_data data) {
  if (data.AN != '' && data.FN != '') {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(top: 1),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    width: sWidth(30, context),
                    child: Center(
                        child: Text(
                          "${data.Date}\n(${data.WeekDay})",
                          style: SecondaryText1(),
                          textAlign: TextAlign.center,
                        )),
                  ),
                  Container(
                    width: sWidth(22, context),
                    margin: const EdgeInsets.only(left: 10.0),
                    child: Center(
                        child: Text(
                          data.FN,
                          style: ColorText(data.FN[0]),
                          textAlign: TextAlign.center,
                        )),
                  ),
                  Container(
                    width: sWidth(22, context),
                    margin: const EdgeInsets.only(left: 10.0),
                    child: Center(
                        child: Text(
                          data.AN,
                          style: ColorText(data.AN[0]),
                          textAlign: TextAlign.center,
                        )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  } else {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    width: sWidth(30, context),
                    child: Center(
                        child: Text(
                          "${data.Date}\n(${data.WeekDay})",
                          style: SecondaryText1(),
                          textAlign: TextAlign.center,
                        )),
                  ),
                  Container(
                    width: sWidth(22, context),
                    margin: const EdgeInsets.only(left: 10.0),
                    child: Center(
                        child: Text(
                          "NA",
                          style: ColorText(''),
                          textAlign: TextAlign.center,
                        )),
                  ),
                  Container(
                    width: sWidth(22, context),
                    margin: const EdgeInsets.only(left: 10.0),
                    child: Center(
                        child: Text(
                          "NA",
                          style: ColorText(''),
                          textAlign: TextAlign.center,
                        )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Widget StaffLeaveBalanceGenerator(
    BuildContext context, LeaveBalanceAPI_data data) {
  return Column(
    children: <Widget>[
      Container(
        /*margin: EdgeInsets.only(left: 3.0, right: 3.0),
        padding: EdgeInsets.only(right: 30.0, left: 30.0),*/
        width: MediaQuery.of(context).size.width,
        // height: 100,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: sHeight(1.5, context),),
            SizedBox(
                height: 30.0,
                child: SizedBox(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        "${data.LeaveName}  (${data.ShortName})",
                        style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ))),
            Divider(
              height: 10,
              thickness: 1,
              indent: 5.0,
              endIndent: 5.0,
              color: LineColor2(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /*Container(
                    decoration: LeaveBalanceRoundBox(data.Balance),
                    height: 45.0,
                    width: sWidth(20, context),
                    child: Center(
                        child: Text(
                          "Eligible \n ${data.Eligible.toString()}  ",
                          style: SecondaryTextSmall01(),
                          textAlign: TextAlign.center,
                        ))),*/
                Container(
                    decoration: LeaveBalanceRoundBox(data.Balance),
                    height: 45.0,
                    width: sWidth(20, context),
                    child: Center(
                        child: Text("Allocated \n ${data.day.toString()}  ",
                          style: SecondaryTextSmall01(),textAlign: TextAlign.center,))),
                Container(
                    decoration: LeaveBalanceRoundBox(data.Balance),
                    height: 45.0,
                    width: sWidth(20, context),
                    child: Center(
                        child: Text("Month\n ${data.month.toString()}  ",
                          style: SecondaryTextSmall01(),textAlign: TextAlign.center,))),
                Container(
                    decoration: LeaveBalanceRoundBox(data.Balance),
                    height: 45.0,
                    width: sWidth(20, context),
                    child: Center(
                        child: Text("Year\n ${data.year.toString()}  ",
                          style: SecondaryTextSmall01(),textAlign: TextAlign.center,))),
                Container(
                    decoration: LeaveBalanceRoundBox(data.Balance),
                    height: 45.0,
                    width: sWidth(20, context),
                    child: Center(
                        child: Text("Balance \n ${data.Balance.toString()}  ",
                          style: SecondaryTextSmall01(),textAlign: TextAlign.center,))),
              ],
            ),
            SizedBox(height: sHeight(1.5, context),),
          ],
        ),
      ),
    ],
  );
}

Widget StaffProformaGenerator(
    BuildContext context, StaffProformaAPI_data data) {
  double containerHeight = 75;
  double sectionHeight = 25;
  if (data.Name.length >= 35) {
    containerHeight = 95;
    sectionHeight = 45;
  }
  if (data.Name.length >= 68) {
    containerHeight = 115;
    sectionHeight = 65;
  }
  if (data.Name.length >= 98) {
    containerHeight = 135;
    sectionHeight = 85;
  }
  return Column(
    children: <Widget>[
      Container(
        margin: const EdgeInsets.only(left: 15.0, top: 10.0, right: 15.0),
        padding: const EdgeInsets.only(right: 40.0, left: 40.0),
        width: MediaQuery.of(context).size.width,
        height: containerHeight,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
                margin: const EdgeInsets.only(top: 5, left: 0),
                height: 25.0,
                child: SizedBox(
                    child: Text(data.GroupName, //general activities
                        style: PrimaryText7()))),
            Container(
                margin: const EdgeInsets.only(top: 10, left: 0),
                height: sectionHeight,
                child: SizedBox(
                    child: Text(
                  data.Name,
                  style: PrimaryText4(),
                  textAlign: TextAlign.center,
                ))),
          ],
        ),
      ),
    ],
  );
}

Widget StaffLessonPlanGenerator(BuildContext context,
    StaffAttendanceTableAPI_data data, StaffAPI_data StaffAPI, String staffID) {
  return InkWell(
    child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Container(
            width: sWidth(93, context),
            height: sHeight(14, context),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LeadingCircleBoxContent(data.sbt, data.sbt),
                ),
                SizedBox(width: sWidth(0.6, context),),
                SizedBox(
                  width: sWidth(59, context),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //SizedBox(height: sHeight(3, context),),
                    Text( "${data.ClassName}\nHour :  ${data.Hour.toString()}\n${data.SubjectFullName.toString()}",maxLines: 5,
                    style: const TextStyle(
                    fontWeight:
                        FontWeight.bold,
                        color: Colors.black,
                        fontSize: 15)),
                  /*  Text("Hour :  ${data.Hour.toString()}\n",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight:
                            FontWeight.bold,
                            fontSize: 15),
                    ),
                    Text("${data.SubjectFullName.toString()}",
                        style: TextStyle(
                        color: Colors.black,
                        fontWeight:
                        FontWeight.bold,
                        fontSize: 15)
                )*/
                  ],
                ),
                ),
                Row(
                  children: [
                    //    Text("Sem , ${data.sem.toString()}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700),),
                    SizedBox(
                      width: sWidth(2, context),
                    ),
                    data.NotesStatus == 0.toInt() ?
                    const CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Icon(
                          Icons.arrow_forward_ios_sharp,
                          color: Colors.white,
                        )):
                    const CircleAvatar(
                        backgroundColor: Colors.grey,
                        child: Icon(
                          Icons.arrow_forward_ios_sharp,
                          color: Colors.white,
                        )),
                  ],
                ),

              ],
            ),
          ),
          SizedBox(
            height: sHeight(2, context),
          )
        ],
      ),
    ),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => StaffLessonPlanList(
                  StaffAPI: StaffAPI,
                  AttendanceClassAPI: data,
                  staffID: staffID,
                )));
      data.NotesStatus == 1.toInt() ?
      Fluttertoast.showToast(
          msg: "Lesson Planner has been Entered!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey[700],
          textColor: Colors.white,
          fontSize: 16.0): Container();
    }
  );
}

Widget StaffLessonPlanListGenerator(
    BuildContext context,
    LessonPlanTheoryAPI_data data,
    StaffAPI_data StaffAPI,
    String staffID,
    StaffAttendanceTableAPI_data timetable) {
  Widget ShowStatus(String status) {
    if (timetable.spnol == 1 && timetable.sbt.toLowerCase() == 'p') {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          radius: 30,
          child: Text(
            data.ExpNo,
            style: SecondaryTextSmall01(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    } else {
      if (status == '0') {
        return Container(
            alignment: Alignment.center,
            width: 20,
            height: 20,
            margin: const EdgeInsets.all(10.0),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(60.0)),
              color: Colors.deepOrange,
            ),
            child: const Icon(
              Icons.highlight_remove,
              color: Colors.white,
              size: 20,
            ));
      } else {
        return Container(
            alignment: Alignment.center,
            width: 20,
            height: 20,
            margin: const EdgeInsets.all(10.0),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(60.0)),
              color: Colors.green,
            ),
            child: const Icon(
              Icons.verified,
              color: Colors.white,
              size: 20,
            ));
      }
    }
  }

  TextEditingController controler = TextEditingController(text: data.Notes);
  return InkWell(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              width: sWidth(93, context),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.26,
                    height: 80,
                    child: Row(
                      children: <Widget>[
                        ShowStatus(data.IsCompleted.toString()),
                        Expanded(
                          child: Text(
                           " ${data.Notes} ",
                            style: SecondaryText1(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 1),
                    width: MediaQuery.of(context).size.width / 13,
                    child: const Icon(Icons.arrow_forward_ios),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: sHeight(2, context),
          ),
        ],
      ),
      onTap: () {
        if (timetable.spnol == 1 && timetable.sbt.toLowerCase() == 'p') {
          showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) => AlertDialog(
                    backgroundColor: Colors.white,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("More Info"),
                        Container(
                          margin: const EdgeInsets.only(right: 30),
                          child: InkWell(
                            child: const Icon(
                              Icons.close,
                              color: Colors.black,
                              size: 25,
                            ),
                            onTap: () => Navigator.pop(context),
                          ),
                        ),
                      ],
                    ),
                    content: SizedBox(
                      height: sHeight(30, context),
                      width: sWidth(70, context),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(top: 15),
                          ),
                          Text(
                            'Notes :',
                            style: SecondaryText(),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 5),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Text(
                                data.Notes,
                                style: SecondaryText(),
                              ),
                            ),
                          ),
                          Container(
                            height: sHeight(5, context),
                            width: sWidth(17, context),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.green,
                            ),
                            child: InkWell(
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Select',style: TextStyle(color: Colors.white),),
                                ],
                              ),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            StaffLessonPlanPracticals(
                                              StaffAPI: StaffAPI,
                                              AttendanceClassAPI:
                                              timetable,
                                              staffID: staffID,
                                              PlannerID: data.id,
                                              ExptNo: data.ExpNo,
                                            )));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ));
        } else {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(
                  'Planner',
                  style: SecondaryText1(),
                  textAlign: TextAlign.start,
                ),
                content: Container(
                  margin: const EdgeInsets.only(
                      top: 20.0),
                  child: TextField(
                    decoration:
                    PrimaryInputDecor(
                        " Edit your Planner"),
                    style: SecondaryText1(),
                    controller: controler,
                    maxLines: 2,
                  ),
                ),
                actionsAlignment:
                MainAxisAlignment
                    .spaceBetween,
                actionsPadding: const EdgeInsets.only(
                    left: 30,
                    right: 30,
                    bottom: 15),
                actions: [
                  InkWell(
                    child: Text(
                      'OK',
                      style: PrimaryText2(),
                      textAlign:
                      TextAlign.start,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StaffLessonPlanMark(
                                  StaffAPI:
                                  StaffAPI,
                                  AttendanceClassAPI:
                                  timetable,
                                  list:
                                  controler
                                      .text,
                                  staffID:
                                  staffID,
                                  PlannerID:
                                  data.id)));
                    },
                  ),
                  InkWell(
                    child: Text(
                      'Cancel',
                      style: PrimaryText2(),
                      textAlign:
                      TextAlign.start,
                    ),
                    onTap: () =>
                        Navigator.pop(context),
                  ),
                ],
                elevation: 20.0,
                shape: const RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.all(
                        Radius.circular(
                            20.0))),
              ));
        }
      });
}

Widget StaffLessonPlanPracticalsGenerator(BuildContext context,
        LessonPlanPracticalAPI_data data, List<int> StudentList) =>
    Column(
      children: <Widget>[
        Container(
          width: sWidth(90, context),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(left: 10.0),
                  child: CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    child: LeadingCircleImageContent1(data.sig),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.fn,
                        style: const TextStyle(
                            fontWeight:
                            FontWeight.bold,
                            color: Colors.black,
                            fontSize: 15)
                    ),
                    Text(
                      data.ic,
                        style: const TextStyle(
                            fontWeight:
                            FontWeight.bold,
                            color: Colors.black,
                            fontSize: 15)
                    ),
                    Text(
                      "Experiment: ${data.exp}",
                        style: const TextStyle(
                            fontWeight:
                            FontWeight.bold,
                            color: Colors.black,
                            fontSize: 15)
                    ),
                  ],
                ),
                if (StudentList.contains(data.id))
                  const SizedBox(
                    height: 100.0,
                    child: Icon(
                      Icons.toggle_on,
                      color: Colors.green,
                      size: 45,
                    ),
                  )
                else
                  const SizedBox(
                    height: 100.0,
                    child: Icon(
                      Icons.toggle_off,
                      color: Colors.black54,
                      size: 45,
                    ),
                  )

              ],
            ),
          ),
        ),
        SizedBox(
          height: sHeight(1, context),
        ),
      ],
    );
