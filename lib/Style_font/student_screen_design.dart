import 'package:add_dev_dolphin/Data/Student_Data.dart';
import 'package:add_dev_dolphin/Model/Student_Screen/student_screen_changes.dart';
import 'package:add_dev_dolphin/Style_font/designs.dart';
import 'package:add_dev_dolphin/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

var indiaFormat =NumberFormat.currency(
  symbol: '₹ ',
  locale: "HI",
  decimalDigits: 2,
);

int AttendanceHours = AttendanceHou!;
double sHeight(double per, BuildContext context){
  double h = MediaQuery.of(context).size.height;
  return h * per / 100;
}

double sWidth(double per, BuildContext context){
  double w = MediaQuery.of(context).size.width;
  return w * per / 100;
}

void SetAttendanceHours(int value){
  AttendanceHou = value;
}

int GetAttencanceHours(){
  return AttendanceHou!;
}

Widget StudentProfileContainer(
    String leftString, String rightString, BuildContext context) =>
    SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 15.0, bottom: 15.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(
                    leftString,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 20.0),
                  child: Text(rightString,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center),
                ),
              ],
            ),
          )
        ],
      ),
    );

Widget StudentProfileContainerInt(
    String leftString, String rightString, BuildContext context) {
  if (rightString == '0') {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 15.0, bottom: 15.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(leftString, style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w700)),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20.0),
                  child: const Text("No", style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  } else {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 60,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 15.0, bottom: 15.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(leftString, style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w700)),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20.0),
                  child: const Text("Yes", style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

Widget AttendanceProfile(String content, double topMar, double leftMar) =>
    Container(
        margin: EdgeInsets.only(top: topMar, left: leftMar),
        height: 25.0,
        child: SizedBox(child: Text(content, style: const TextStyle())));

//custom code for latest summary details as per plan 2
Widget AttendanceSummaryDetails(
    BuildContext context,
    AttendanceAPI_data Attendancedata,
    String username,
    String SemNo,
    String password) =>
    Column(
      children: [
        SizedBox(height: sHeight(1.5, context),),
        Container(
          margin: const EdgeInsets.only(left: 18,right: 15,),
          width: sWidth(90, context),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15),),
          ),
          child: Column(
            children: [
              SizedBox(height: sHeight(2, context),),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("       ${Attendancedata.SemesterName}",style: const TextStyle(fontSize: 18,color: Colors.green,fontWeight: FontWeight.w900),),
                ],
              ),
              SizedBox(height: sHeight(2.5, context),),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      const Text("Sem  ",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                      SizedBox(height: sHeight(1, context),),
                      Text("${Attendancedata.SemesterNumber}",style: const TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
                      SizedBox(height: sHeight(1, context),),
                      Container(
                        width: sWidth(15, context),
                        decoration: const BoxDecoration(
                            color: Color(0xFFE23F8B),
                            borderRadius: BorderRadius.all(Radius.circular(5),)),
                        child: Column(
                          children: [
                            SizedBox(height: sHeight(1, context),),
                            const Center(
                              child: Text("Days",style: TextStyle(fontSize: 10,color: Colors.white,fontWeight: FontWeight.w600),),
                            ),
                            Center(
                              child: Text("${Attendancedata.TotalDays}",style: const TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.w900),),
                            ),
                            SizedBox(height: sHeight(1, context),),
                          ],
                        ),
                      ),
                      SizedBox(height: sHeight(1, context),),
                      Container(
                        width: sWidth(15, context),
                        decoration: const BoxDecoration(
                            color: Color(0xFFE23F8B),
                            borderRadius: BorderRadius.all(Radius.circular(5),)),
                        child: Column(
                          children: [
                            SizedBox(height: sHeight(1, context),),
                            const Center(
                              child: Text("Hours",style: TextStyle(fontSize: 10,color: Colors.white,fontWeight: FontWeight.w600),),
                            ),
                            Center(
                              child: Text("${Attendancedata.TotalHours}",style: const TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.w900),),
                            ),
                            SizedBox(height: sHeight(1, context),),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text("Year  ",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                      SizedBox(height: sHeight(1, context),),
                      Text("${Attendancedata.Year}",style: const TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
                      SizedBox(height: sHeight(1, context),),
                      Container(
                        width: sWidth(15, context),
                        decoration: const BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.all(Radius.circular(5),)),
                        child: Column(
                          children: [
                            SizedBox(height: sHeight(1, context),),
                            const Center(
                              child: Text("Pre",style: TextStyle(fontSize: 10,color: Colors.white,fontWeight: FontWeight.w600),),
                            ),
                            Center(
                              child: Text("${Attendancedata.DaysPresent}",style: const TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.w900),),
                            ),
                            SizedBox(height: sHeight(1, context),),
                          ],
                        ),
                      ),
                      SizedBox(height: sHeight(1, context),),
                      Container(
                        width: sWidth(15, context),
                        decoration: const BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.all(Radius.circular(5),)),
                        child: Column(
                          children: [
                            SizedBox(height: sHeight(1, context),),
                            const Center(
                              child: Text("Pre",style: TextStyle(fontSize: 10,color: Colors.white,fontWeight: FontWeight.w600),),
                            ),
                            Center(
                              child: Text("${Attendancedata.HoursPresent}",style: const TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.w900),),
                            ),
                            SizedBox(height: sHeight(1, context),),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text("From  ",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                      SizedBox(height: sHeight(1, context),),
                      Text(Attendancedata.AttendanceFromDate,style: const TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
                      SizedBox(height: sHeight(1, context),),
                      Container(
                        width: sWidth(15, context),
                        decoration: const BoxDecoration(
                            color: Color(0xfff5badf2),
                            borderRadius: BorderRadius.all(Radius.circular(5),)),
                        child: Column(
                          children: [
                            SizedBox(height: sHeight(1, context),),
                            const Center(
                              child: Text("Abs",style: TextStyle(fontSize: 10,color: Colors.white,fontWeight: FontWeight.w600),),
                            ),
                            Center(
                              child: Text("${Attendancedata.DayAbsent}",style: const TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.w900),),
                            ),
                            SizedBox(height: sHeight(1, context),),
                          ],
                        ),
                      ),
                      SizedBox(height: sHeight(1, context),),
                      Container(
                        width: sWidth(15, context),
                        decoration: const BoxDecoration(
                            color: Color(0xfff5badf2),
                            borderRadius: BorderRadius.all(Radius.circular(5),)),
                        child: Column(
                          children: [
                            SizedBox(height: sHeight(1, context),),
                            const Center(
                              child: Text("Abs",style: TextStyle(fontSize: 10,color: Colors.white,fontWeight: FontWeight.w600),),
                            ),
                            Center(
                              child: Text("${Attendancedata.HoursAbsent}",style: const TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.w900),),
                            ),
                            SizedBox(height: sHeight(1, context),),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text("To  ",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                      SizedBox(height: sHeight(1, context),),
                      Text(Attendancedata.AttendanceToDate,style: const TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
                      SizedBox(height: sHeight(1, context),),
                      Container(
                        width: sWidth(15, context),
                        decoration: const BoxDecoration(
                            color: Color(0XFFF97A52),
                            borderRadius: BorderRadius.all(Radius.circular(5),)),
                        child: Column(
                          children: [
                            SizedBox(height: sHeight(1, context),),
                            const Center(
                              child: Text("Per%",style: TextStyle(fontSize: 10,color: Colors.white,fontWeight: FontWeight.w600),),
                            ),
                            Center(
                              child: Text("${Attendancedata.DaysPresentPercentage}",style: const TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.w900),),
                            ),
                            SizedBox(height: sHeight(1, context),),
                          ],
                        ),
                      ),
                      SizedBox(height: sHeight(1, context),),
                      Container(
                        width: sWidth(15, context),
                        decoration: const BoxDecoration(
                            color: Color(0XFFF97A52),
                            borderRadius: BorderRadius.all(Radius.circular(5),)),
                        child: Column(
                          children: [
                            SizedBox(height: sHeight(1, context),),
                            const Center(
                              child: Text("Per%",style: TextStyle(fontSize: 10,color: Colors.white,fontWeight: FontWeight.w600),),
                            ),
                            Center(
                              child: Text("${Attendancedata.HoursPercentage}",style: const TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.w900),),
                            ),
                            SizedBox(height: sHeight(1, context),),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: sHeight(2.5, context),),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    child: Container(
                      margin: const EdgeInsets.only(right: 25),
                      height: sHeight(5, context),
                      width: sWidth(30, context),
                      decoration: const BoxDecoration(
                        color:
                        Color(0XFF7C6AFF),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'View More',
                          style: TextStyle(
                              color: Colors.white),
                        ),
                      ),
                    ),
                    onTap: () {

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => StudentAttendanceAbstansia(
                                username: username,
                                SemestedID: Attendancedata.SemesterId.toString(),
                                SemNo: SemNo,
                                password: password,
                              )));
                    },
                  ),
                ],
              ),
              SizedBox(height: sHeight(2, context),),
            ],
          ),
        ),
      ],
    );
// custom code for full summary details as per plan 1
Widget AttendanceFullSummary(BuildContext context, List<AttendanceAPI_data> data, String username, String password) =>
    Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // for (int i = data.length - 1; i >= 0; i--)
          AttendanceSummaryDetails(context, data[Stu], username,
              data[Stu].SemesterNumber.toString(), password),
      ],
    );

Widget AttendanceProfile1(BuildContext context, API_data data) => Container(
      margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.02,
          left: MediaQuery.of(context).size.width * 0.02,
          right: MediaQuery.of(context).size.width * 0.05),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: LeedingProfile(data.Picture),
          ),
          Container(
              margin: const EdgeInsets.only(left: 5.0, top: 10.0),
              width: sWidth(62.5, context),
              height: sHeight(10, context),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Text(
                    data.StudentName,
                    style: PrimaryText2Big(),
                  ),
                ],
              )),
        ],
      ),
    );

Widget AttendanceProfile2(BuildContext context, API_data data, AttendanceAPI_data Attendancedata) =>
    Container(
      margin: const EdgeInsets.only(left: 15.0),
      width: MediaQuery.of(context).size.width,
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
            ],
          ),
        ],
      ),
    );

Widget AttendanceProfileDivider() => Divider(
      height: 20,
      thickness: 3,
      indent: 20.0,
      endIndent: 20.0,
      color: LineColor2(),
    );

Widget AttendanceProfileDivider1() => Divider(
  height: 20,
  thickness: 3,
  indent: 20.0,
  endIndent: 20.0,
  color: LineColor2(),
);

Widget InfoDesign(BuildContext context, UniversityAPI_data data, String title) =>
    const Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // SizedBox(height: sHeight(1.5, context),),
        Row(
          children: <Widget>[

          ],
        ),
      ],
    );

Widget InfoDesignAttendance(BuildContext context, String title,
    String semesterID, String username, String SemNo, String password) =>
    Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(left: 15.0),
          child: Text(title, style: PrimaryText2Big()),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Semester : $SemNo", style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w800)),
              InkWell(
                child: Container(
                  margin: const EdgeInsets.only(
                    right: 20.0,
                    // bottom: 20.0,
                  ),
                  width: sWidth(28, context),
                  height: sHeight(6, context),
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(8, 197, 110, 1),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Full Details',
                      style: TextStyle(color: Colors.white, fontSize: 14,fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            StudentAttendanceDetails(
                              username: username,
                              SemestedID: semesterID,
                              password: password,
                              SemNo: SemNo,
                            ))),
              ),
            ],
          ),
        ),
      ],
    );

Widget InfoDesignDetails(BuildContext context, InternalMarkAPI_data data) =>
    const Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[

      ],
    );

Widget DisplayAttendanceDetails(
    BuildContext context, List<AttendanceDetailsAPI_data> detailsdata) {
  if (GetAttencanceHours() <= 10) {
    return Column(
      children: <Widget>[
        AttendanceDetailsDesignTitle(context),
        for (int i = detailsdata.length - 1; i >= 0; i--)
          AttendanceDetailsDesign(context, detailsdata, i),
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

Widget AttendanceDetailsDesign(BuildContext context, List<AttendanceDetailsAPI_data> data, int i) {
  switch (AttendanceHou){
    case 4 : return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 70.0,
          decoration: BoxDecoration(
            gradient: LineColorGradient(),
          ),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 110.0,
                    child: Center(
                        child: Text(
                            "${data[i].Date}\n(${data[i].WeekdaySmall})",
                            textAlign: TextAlign.center,
                            style: SecondaryText3())),
                  ),
                  Container(
                    width: 30.0,
                    margin: const EdgeInsets.only(left: 50.0),
                    child: Text(data[i].H1,
                        style: ColorText(data[i].H1.toLowerCase())),
                  ),
                  Container(
                    width: 30.0,
                    margin: const EdgeInsets.only(left: 20.0),
                    child: Text(data[i].H2,
                        style: ColorText(data[i].H2.toLowerCase())),
                  ),
                  Container(
                    width: 30.0,
                    margin: const EdgeInsets.only(left: 20.0),
                    child: Text(data[i].H3,
                        style: ColorText(data[i].H3.toLowerCase())),
                  ),
                  Container(
                    width: 30.0,
                    margin: const EdgeInsets.only(left: 20.0),
                    child: Text(data[i].H4,
                        style: ColorText(data[i].H4.toLowerCase())),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
    case 5 : return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 70.0,
          decoration: BoxDecoration(
            gradient: LineColorGradient(),
          ),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 80.0,
                    child: Center(
                        child: Text(
                            "${data[i].Date}\n(${data[i].WeekdaySmall})",
                            textAlign: TextAlign.center,
                            style: SecondaryText3())),
                  ),
                  Container(
                    width: 20.0,
                    margin: const EdgeInsets.only(left: 50.0),
                    child: Text(data[i].H1,
                        style: ColorText(data[i].H1.toLowerCase())),
                  ),
                  Container(
                    width: 20.0,
                    margin: const EdgeInsets.only(left: 20.0),
                    child: Text(data[i].H2,
                        style: ColorText(data[i].H2.toLowerCase())),
                  ),
                  Container(
                    width: 20.0,
                    margin: const EdgeInsets.only(left: 20.0),
                    child: Text(data[i].H3,
                        style: ColorText(data[i].H3.toLowerCase())),
                  ),
                  Container(
                    width: 20.0,
                    margin: const EdgeInsets.only(left: 20.0),
                    child: Text(data[i].H4,
                        style: ColorText(data[i].H4.toLowerCase())),
                  ),
                  Container(
                    width: 20.0,
                    margin: const EdgeInsets.only(left: 20.0),
                    child: Text(data[i].H5,
                        style: ColorText(data[i].H5.toLowerCase())),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
     case 6 : return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 70.0,
          decoration: BoxDecoration(
            gradient: LineColorGradient(),
          ),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 80.0,
                    child: Center(
                        child: Text(
                            "${data[i].Date}\n(${data[i].WeekdaySmall})",
                            textAlign: TextAlign.center,
                            style: SecondaryText3())),
                  ),
                  Container(
                    width: 20.0,
                    margin: const EdgeInsets.only(left: 50.0),
                    child: Text(data[i].H1,
                        style: ColorText(data[i].H1.toLowerCase())),
                  ),
                  Container(
                    width: 20.0,
                    margin: const EdgeInsets.only(left: 20.0),
                    child: Text(data[i].H2,
                        style: ColorText(data[i].H2.toLowerCase())),
                  ),
                  Container(
                    width: 20.0,
                    margin: const EdgeInsets.only(left: 20.0),
                    child: Text(data[i].H3,
                        style: ColorText(data[i].H3.toLowerCase())),
                  ),
                  Container(
                    width: 20.0,
                    margin: const EdgeInsets.only(left: 20.0),
                    child: Text(data[i].H4,
                        style: ColorText(data[i].H4.toLowerCase())),
                  ),
                  Container(
                    width: 20.0,
                    margin: const EdgeInsets.only(left: 20.0),
                    child: Text(data[i].H5,
                        style: ColorText(data[i].H5.toLowerCase())),
                  ),
                  Container(
                    width: 20.0,
                    margin: const EdgeInsets.only(left: 20.0),
                    child: Text(data[i].H6,
                        style: ColorText(data[i].H6.toLowerCase())),
                  ),
                ],
              ),
            ],
          ),
        ),

      ],
    );
    case 7 : return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 70.0,
          decoration: BoxDecoration(
            gradient: LineColorGradient(),
          ),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 80.0,
                    child: Center(
                        child: Text(
                            "${data[i].Date}\n(${data[i].WeekdaySmall})",
                            textAlign: TextAlign.center,
                            style: SecondaryText3())),
                  ),
                  Container(
                    width: 20.0,
                    margin: const EdgeInsets.only(left: 50.0),
                    child: Text(data[i].H1,
                        style: ColorText(data[i].H1.toLowerCase())),
                  ),
                  Container(
                    width: 20.0,
                    margin: const EdgeInsets.only(left: 20.0),
                    child: Text(data[i].H2,
                        style: ColorText(data[i].H2.toLowerCase())),
                  ),
                  Container(
                    width: 20.0,
                    margin: const EdgeInsets.only(left: 20.0),
                    child: Text(data[i].H3,
                        style: ColorText(data[i].H3.toLowerCase())),
                  ),
                  Container(
                    width: 20.0,
                    margin: const EdgeInsets.only(left: 20.0),
                    child: Text(data[i].H4,
                        style: ColorText(data[i].H4.toLowerCase())),
                  ),
                  Container(
                    width: 20.0,
                    margin: const EdgeInsets.only(left: 20.0),
                    child: Text(data[i].H5,
                        style: ColorText(data[i].H5.toLowerCase())),
                  ),
                  Container(
                    width: 20.0,
                    margin: const EdgeInsets.only(left: 20.0),
                    child: Text(data[i].H6,
                        style: ColorText(data[i].H6.toLowerCase())),
                  ),
                  Container(
                    width: 20.0,
                    margin: const EdgeInsets.only(left: 20.0),
                    child: Text(data[i].H7,
                        style: ColorText(data[i].H7.toLowerCase())),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
    case 8 : return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 70.0,
          decoration: BoxDecoration(
            gradient: LineColorGradient(),
          ),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 80.0,
                    child: Center(
                        child: Text(
                            "${data[i].Date}\n(${data[i].WeekdaySmall})",
                            textAlign: TextAlign.center,
                            style: SecondaryText3())),
                  ),
                  Container(
                    width: 20.0,
                    margin: const EdgeInsets.only(left: 50.0),
                    child: Text(data[i].H1,
                        style: ColorText(data[i].H1.toLowerCase())),
                  ),
                  Container(
                    width: 20.0,
                    margin: const EdgeInsets.only(left: 20.0),
                    child: Text(data[i].H2,
                        style: ColorText(data[i].H2.toLowerCase())),
                  ),
                  Container(
                    width: 20.0,
                    margin: const EdgeInsets.only(left: 20.0),
                    child: Text(data[i].H3,
                        style: ColorText(data[i].H3.toLowerCase())),
                  ),
                  Container(
                    width: 20.0,
                    margin: const EdgeInsets.only(left: 20.0),
                    child: Text(data[i].H4,
                        style: ColorText(data[i].H4.toLowerCase())),
                  ),
                  Container(
                    width: 20.0,
                    margin: const EdgeInsets.only(left: 20.0),
                    child: Text(data[i].H5,
                        style: ColorText(data[i].H5.toLowerCase())),
                  ),
                  Container(
                    width: 20.0,
                    margin: const EdgeInsets.only(left: 20.0),
                    child: Text(data[i].H6,
                        style: ColorText(data[i].H6.toLowerCase())),
                  ),
                  Container(
                    width: 20.0,
                    margin: const EdgeInsets.only(left: 20.0),
                    child: Text(data[i].H7,
                        style: ColorText(data[i].H7.toLowerCase())),
                  ),
                  Container(
                    width: 20.0,
                    margin: const EdgeInsets.only(left: 20.0),
                    child: Text(data[i].H8,
                        style: ColorText(data[i].H8.toLowerCase())),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
    case 9 : return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 70.0,
          decoration: BoxDecoration(
            gradient: LineColorGradient(),
          ),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 80.0,
                    child: Center(
                        child: Text(
                            "${data[i].Date}\n(${data[i].WeekdaySmall})",
                            textAlign: TextAlign.center,
                            style: SecondaryText3())),
                  ),
                  Container(
                    width: 20.0,
                    margin: const EdgeInsets.only(left: 50.0),
                    child: Text(data[i].H1,
                        style: ColorText(data[i].H1.toLowerCase())),
                  ),
                  Container(
                    width: 20.0,
                    margin: const EdgeInsets.only(left: 20.0),
                    child: Text(data[i].H2,
                        style: ColorText(data[i].H2.toLowerCase())),
                  ),
                  Container(
                    width: 20.0,
                    margin: const EdgeInsets.only(left: 20.0),
                    child: Text(data[i].H3,
                        style: ColorText(data[i].H3.toLowerCase())),
                  ),
                  Container(
                    width: 20.0,
                    margin: const EdgeInsets.only(left: 20.0),
                    child: Text(data[i].H4,
                        style: ColorText(data[i].H4.toLowerCase())),
                  ),
                  Container(
                    width: 20.0,
                    margin: const EdgeInsets.only(left: 20.0),
                    child: Text(data[i].H5,
                        style: ColorText(data[i].H5.toLowerCase())),
                  ),
                  Container(
                    width: 20.0,
                    margin: const EdgeInsets.only(left: 20.0),
                    child: Text(data[i].H6,
                        style: ColorText(data[i].H6.toLowerCase())),
                  ),
                  Container(
                    width: 20.0,
                    margin: const EdgeInsets.only(left: 20.0),
                    child: Text(data[i].H7,
                        style: ColorText(data[i].H7.toLowerCase())),
                  ),
                  Container(
                    width: 20.0,
                    margin: const EdgeInsets.only(left: 20.0),
                    child: Text(data[i].H8,
                        style: ColorText(data[i].H8.toLowerCase())),
                  ),
                  Container(
                    width: 20.0,
                    margin: const EdgeInsets.only(left: 20.0),
                    child: Text(data[i].H9,
                        style: ColorText(data[i].H9.toLowerCase())),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
    case 10 : return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 70.0,
          decoration: BoxDecoration(
            gradient: LineColorGradient(),
          ),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 80.0,
                    child: Center(
                        child: Text(
                            "${data[i].Date}\n(${data[i].WeekdaySmall})",
                            textAlign: TextAlign.center,
                            style: SecondaryText3())),
                  ),
                  Container(
                    width: 20.0,
                    margin: const EdgeInsets.only(left: 50.0),
                    child: Text(data[i].H1,
                        style: ColorText(data[i].H1.toLowerCase())),
                  ),
                  Container(
                    width: 20.0,
                    margin: const EdgeInsets.only(left: 20.0),
                    child: Text(data[i].H2,
                        style: ColorText(data[i].H2.toLowerCase())),
                  ),
                  Container(
                    width: 20.0,
                    margin: const EdgeInsets.only(left: 20.0),
                    child: Text(data[i].H3,
                        style: ColorText(data[i].H3.toLowerCase())),
                  ),
                  Container(
                    width: 20.0,
                    margin: const EdgeInsets.only(left: 20.0),
                    child: Text(data[i].H4,
                        style: ColorText(data[i].H4.toLowerCase())),
                  ),
                  Container(
                    width: 20.0,
                    margin: const EdgeInsets.only(left: 20.0),
                    child: Text(data[i].H5,
                        style: ColorText(data[i].H5.toLowerCase())),
                  ),
                  Container(
                    width: 20.0,
                    margin: const EdgeInsets.only(left: 20.0),
                    child: Text(data[i].H6,
                        style: ColorText(data[i].H6.toLowerCase())),
                  ),
                  Container(
                    width: 20.0,
                    margin: const EdgeInsets.only(left: 20.0),
                    child: Text(data[i].H7,
                        style: ColorText(data[i].H7.toLowerCase())),
                  ),
                  Container(
                    width: 20.0,
                    margin: const EdgeInsets.only(left: 20.0),
                    child: Text(data[i].H8,
                        style: ColorText(data[i].H8.toLowerCase())),
                  ),
                  Container(
                    width: 20.0,
                    margin: const EdgeInsets.only(left: 20.0),
                    child: Text(data[i].H9,
                        style: ColorText(data[i].H9.toLowerCase())),
                  ),
                  Container(
                    width: 20.0,
                    margin: const EdgeInsets.only(left: 20.0),
                    child: Text(data[i].H10,
                        style: ColorText(data[i].H10.toLowerCase())),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
    default : return Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(top: 20),
        child: Center(child: Text("Sorry Something went wrong!", style: ErrorText2Big(),textAlign: TextAlign.center,)));
  }
}

Widget AttendanceDetailsDesignTitle(BuildContext context) {
  switch (AttendanceHou){
    case 4 : return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      height: 70.0,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 110.0,
            child: Center(child: Text("Date", style: PrimaryText2())),
          ),
          Container(
            width: 30,
            margin: const EdgeInsets.only(left: 50.0),
            child: Text("1", style: PrimaryText2()),
          ),
          Container(
            width: 30,
            margin: const EdgeInsets.only(left: 20.0),
            child: Text("2", style: PrimaryText2()),
          ),
          Container(
            width: 30,
            margin: const EdgeInsets.only(left: 20.0),
            child: Text("3", style: PrimaryText2()),
          ),
          Container(
            width: 30,
            margin: const EdgeInsets.only(left: 20.0),
            child: Text("4", style: PrimaryText2()),
          ),
        ],
      ),
    );
    case 5 : return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      height: 70.0,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 80.0,
            child: Center(child: Text("Date", style: PrimaryText2())),
          ),
          Container(
            width: 20,
            margin: const EdgeInsets.only(left: 50.0),
            child: Text("1", style: PrimaryText2()),
          ),
          Container(
            width: 20,
            margin: const EdgeInsets.only(left: 20.0),
            child: Text("2", style: PrimaryText2()),
          ),
          Container(
            width: 20,
            margin: const EdgeInsets.only(left: 20.0),
            child: Text("3", style: PrimaryText2()),
          ),
          Container(
            width: 20,
            margin: const EdgeInsets.only(left: 20.0),
            child: Text("4", style: PrimaryText2()),
          ),
          Container(
            width: 20,
            margin: const EdgeInsets.only(left: 20.0),
            child: Text("5", style: PrimaryText2()),
          ),
        ],
      ),
    );
    case 6 : return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      height: 70.0,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 80.0,
            child: Center(child: Text("Date", style: PrimaryText2())),
          ),
          Container(
            width: 20,
            margin: const EdgeInsets.only(left: 50.0),
            child: Text("1", style: PrimaryText2()),
          ),
          Container(
            width: 20,
            margin: const EdgeInsets.only(left: 20.0),
            child: Text("2", style: PrimaryText2()),
          ),
          Container(
            width: 20,
            margin: const EdgeInsets.only(left: 20.0),
            child: Text("3", style: PrimaryText2()),
          ),
          Container(
            width: 20,
            margin: const EdgeInsets.only(left: 20.0),
            child: Text("4", style: PrimaryText2()),
          ),
          Container(
            width: 20,
            margin: const EdgeInsets.only(left: 20.0),
            child: Text("5", style: PrimaryText2()),
          ),
          Container(
            width: 20,
            margin: const EdgeInsets.only(left: 20.0),
            child: Text("6", style: PrimaryText2()),
          ),
        ],
      ),
    );
    case 7 : return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      height: 70.0,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 80.0,
            child: Center(child: Text("Date", style: PrimaryText2())),
          ),
          Container(
            width: 20,
            margin: const EdgeInsets.only(left: 50.0),
            child: Text("1", style: PrimaryText2()),
          ),
          Container(
            width: 20,
            margin: const EdgeInsets.only(left: 20.0),
            child: Text("2", style: PrimaryText2()),
          ),
          Container(
            width: 20,
            margin: const EdgeInsets.only(left: 20.0),
            child: Text("3", style: PrimaryText2()),
          ),
          Container(
            width: 20,
            margin: const EdgeInsets.only(left: 20.0),
            child: Text("4", style: PrimaryText2()),
          ),
          Container(
            width: 20,
            margin: const EdgeInsets.only(left: 20.0),
            child: Text("5", style: PrimaryText2()),
          ),
          Container(
            width: 20,
            margin: const EdgeInsets.only(left: 20.0),
            child: Text("6", style: PrimaryText2()),
          ),
          Container(
            width: 20,
            margin: const EdgeInsets.only(left: 20.0),
            child: Text("7", style: PrimaryText2()),
          ),
        ],
      ),
    );
    case 8 : return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      height: 70.0,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 80.0,
            child: Center(child: Text("Date", style: PrimaryText2())),
          ),
          Container(
            width: 20,
            margin: const EdgeInsets.only(left: 50.0),
            child: Text("1", style: PrimaryText2()),
          ),
          Container(
            width: 20,
            margin: const EdgeInsets.only(left: 20.0),
            child: Text("2", style: PrimaryText2()),
          ),
          Container(
            width: 20,
            margin: const EdgeInsets.only(left: 20.0),
            child: Text("3", style: PrimaryText2()),
          ),
          Container(
            width: 20,
            margin: const EdgeInsets.only(left: 20.0),
            child: Text("4", style: PrimaryText2()),
          ),
          Container(
            width: 20,
            margin: const EdgeInsets.only(left: 20.0),
            child: Text("5", style: PrimaryText2()),
          ),
          Container(
            width: 20,
            margin: const EdgeInsets.only(left: 20.0),
            child: Text("6", style: PrimaryText2()),
          ),
          Container(
            width: 20,
            margin: const EdgeInsets.only(left: 20.0),
            child: Text("7", style: PrimaryText2()),
          ),
          Container(
            width: 20,
            margin: const EdgeInsets.only(left: 20.0),
            child: Text("8", style: PrimaryText2()),
          ),
        ],
      ),
    );
    case 9 : return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      height: 70.0,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 80.0,
            child: Center(child: Text("Date", style: PrimaryText2())),
          ),
          Container(
            width: 20,
            margin: const EdgeInsets.only(left: 50.0),
            child: Text("1", style: PrimaryText2()),
          ),
          Container(
            width: 20,
            margin: const EdgeInsets.only(left: 20.0),
            child: Text("2", style: PrimaryText2()),
          ),
          Container(
            width: 20,
            margin: const EdgeInsets.only(left: 20.0),
            child: Text("3", style: PrimaryText2()),
          ),
          Container(
            width: 20,
            margin: const EdgeInsets.only(left: 20.0),
            child: Text("4", style: PrimaryText2()),
          ),
          Container(
            width: 20,
            margin: const EdgeInsets.only(left: 20.0),
            child: Text("5", style: PrimaryText2()),
          ),
          Container(
            width: 20,
            margin: const EdgeInsets.only(left: 20.0),
            child: Text("6", style: PrimaryText2()),
          ),
          Container(
            width: 20,
            margin: const EdgeInsets.only(left: 20.0),
            child: Text("7", style: PrimaryText2()),
          ),
          Container(
            width: 20,
            margin: const EdgeInsets.only(left: 20.0),
            child: Text("8", style: PrimaryText2()),
          ),
          Container(
            width: 20,
            margin: const EdgeInsets.only(left: 20.0),
            child: Text("9", style: PrimaryText2()),
          ),
        ],
      ),
    );
    case 10 : return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      height: 70.0,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 80.0,
            child: Center(child: Text("Date", style: PrimaryText2())),
          ),
          Container(
            width: 20,
            margin: const EdgeInsets.only(left: 50.0),
            child: Text("1", style: PrimaryText2()),
          ),
          Container(
            width: 20,
            margin: const EdgeInsets.only(left: 20.0),
            child: Text("2", style: PrimaryText2()),
          ),
          Container(
            width: 20,
            margin: const EdgeInsets.only(left: 20.0),
            child: Text("3", style: PrimaryText2()),
          ),
          Container(
            width: 20,
            margin: const EdgeInsets.only(left: 20.0),
            child: Text("4", style: PrimaryText2()),
          ),
          Container(
            width: 20,
            margin: const EdgeInsets.only(left: 20.0),
            child: Text("5", style: PrimaryText2()),
          ),
          Container(
            width: 20,
            margin: const EdgeInsets.only(left: 20.0),
            child: Text("6", style: PrimaryText2()),
          ),
          Container(
            width: 20,
            margin: const EdgeInsets.only(left: 20.0),
            child: Text("7", style: PrimaryText2()),
          ),
          Container(
            width: 20,
            margin: const EdgeInsets.only(left: 20.0),
            child: Text("8", style: PrimaryText2()),
          ),
          Container(
            width: 20,
            margin: const EdgeInsets.only(left: 20.0),
            child: Text("9", style: PrimaryText2()),
          ),
          Container(
            width: 20,
            margin: const EdgeInsets.only(left: 20.0),
            child: Text("10", style: PrimaryText2()),
          ),
        ],
      ),
    );
    default : return Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(top: 20),
        child: Center(child: Text("Sorry Something went wrong!", style: ErrorText2Big(),textAlign: TextAlign.center,)));
  }
}

Widget AbstantiaDetailsDesign(BuildContext context, String date, String day,
    String hours, String total, String grandTotal) =>
    Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10.0),
          height: 70.0,
          child: Column(
            children: <Widget>[
              Divider(
                height: 10,
                thickness: 1,
                indent: 5.0,
                endIndent: 5.0,
                color: LineColor2(),
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: sWidth(30, context),
                    child: Center(
                        child: Text("$date\n$day",
                            textAlign: TextAlign.center,
                            style: PrimaryText4())),
                  ),
                 // VerticalDivider(width: 10,),
                  Container(
                    width: sWidth(15, context),
                    margin: const EdgeInsets.only(left: 10.0),
                    child: Center(child: Text(hours, style: PrimaryText4())),
                  ),
                  Container(
                    width: sWidth(15, context),
                    margin: const EdgeInsets.only(left: 10.0),
                    child: Center(child: Text(total, style: PrimaryText4())),
                  ),
                  Container(
                    width: sWidth(15, context),
                    margin: const EdgeInsets.only(left: 10.0),
                    child: Center(
                        child: Text(grandTotal, style: PrimaryText4())),
                  ),

                ],
              ),
              /*Divider(
                height: 10,
                thickness: 1,
                indent: 5.0,
                endIndent: 5.0,
                color: LineColor2(),
              ),*/
            ],
          ),
        ),
      ],
    );

Widget AbstantiaDetailsDesignTitle(BuildContext context) => Container(
  margin: const EdgeInsets.symmetric(horizontal: 10.0),
  height: 70.0,
  child: Row(
    children: <Widget>[
      SizedBox(
        width: sWidth(30, context),
        child: Center(child: Text("Date", style: PrimaryText4())),
      ),
      Container(
        width: sWidth(15, context),
        margin: const EdgeInsets.only(left: 10.0),
        child: Center(child: Text("Hours", style: PrimaryText4())),
      ),
      Container(
        width: sWidth(15, context),
        margin: const EdgeInsets.only(left: 10.0),
        child: Center(child: Text("Total", style: PrimaryText4())),
      ),
      Container(
        width: sWidth(15, context),
        margin: const EdgeInsets.only(left: 10.0),
        child: Center(
            child: Text("Grand\nTotal",
                textAlign: TextAlign.center, style: PrimaryText4())),
      ),
    ],
  ),
);


Widget TestNameBuilder(
        BuildContext context, InternalMarkAPI_data data, int index) =>
    Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      padding: const EdgeInsets.all(15),
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15),),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 90,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text("Test Name", style: TextStyle(fontSize: 19,fontWeight: FontWeight.w700)),
                Container(
                  height: 50,
                  margin: const EdgeInsets.only(top: 3.0),
                  child: Center(
                    child: Text(
                      data.TestNameList[index].TestName,
                      style: const TextStyle(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: <Widget>[
                const Text("--------------------------------------------------------------------",style: TextStyle(),),
                for (int i = 0;
                    i <= data.TestNameList[index].Mark.length - 1;
                    i++)
                  InternalTestMarkBuilder(context, data, index, i),
              ],
            ),
          ),
        ],
      ),
    );

Widget InternalTestMarkBuilder(BuildContext context, InternalMarkAPI_data data, int ListIndex, int MarkIndex) =>
    Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5.0),
          height: 75,
          decoration: BoxDecoration(gradient: LineColorGradient()),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 50.0,
                    child: Center(
                        child: Text(
                            data.TestNameList[ListIndex].Mark[MarkIndex]
                                .SubjectCode,
                            style: SecondaryText3())),
                  ),
                  Container(
                    width: 130.0,
                    margin: const EdgeInsets.only(left: 10.0),
                    child: Center(
                        child: Text(
                            data.TestNameList[ListIndex].Mark[MarkIndex]
                                .SubjectFullName,
                            style: SecondaryText3())),
                  ),
                  Container(
                    width: 70.0,
                    margin: const EdgeInsets.only(left: 10.0),
                    child: Center(
                        child: Text(
                            "${data.TestNameList[ListIndex].Mark[MarkIndex].Mark} / "
                            "${data.TestNameList[ListIndex].Mark[MarkIndex].MaxMark}",
                            style: SecondaryText3())),
                  ),
                  Container(
                    width: 50.0,
                    margin: const EdgeInsets.only(left: 10.0),
                    child: Center(
                        child: Text(
                            data.TestNameList[ListIndex].Mark[MarkIndex].Result,
                            style: ColorText1(data
                                .TestNameList[ListIndex].Mark[MarkIndex].Result
                                .toLowerCase()))),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );

Widget UniversityTestTitle(UniversityAPI_data data, int minus) => Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Text("UNIVERSITY EXAM MARKS", style: TextStyle(fontSize: 20,fontWeight: FontWeight.w900,color: Colors.deepPurple)),
        const SizedBox(height: 5,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("Semester : ${data.SemesterNo}", style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );

Widget UniversityTestMarkBuilder(BuildContext context, UniversityAPI_data data, int minus, int indexMark) =>
    Column(
      children: <Widget>[
        Container(
          // margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
          height: 25.0,
          decoration: const BoxDecoration(color: Colors.white,),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(height: sHeight(0.5, context),),
                  SizedBox(
                    width: 130.0,
                    child: Center(
                        child: Text(
                            data.UniversityMarksList[indexMark].SubjectCode,
                            textAlign: TextAlign.center,
                            style: SecondaryText3())),
                  ),
                  Container(
                    width: 70.0,
                    margin: const EdgeInsets.only(left: 10.0),
                    child: Center(
                        child: Text(data.UniversityMarksList[indexMark].Result,
                            textAlign: TextAlign.center,
                            style: ColorText(data
                                .UniversityMarksList[indexMark].Result
                                .toLowerCase()))),
                  ),
                  Container(
                    width: 70.0,
                    margin: const EdgeInsets.only(left: 10.0),
                    child: Center(
                        child: Text(
                            data.UniversityMarksList[indexMark].TotalMark,
                            textAlign: TextAlign.center,
                            style: SecondaryText3())),
                  ),
                  Container(
                    width: 70.0,
                    margin: const EdgeInsets.only(left: 10.0),
                    child: Center(
                        child: Text(
                            data.UniversityMarksList[indexMark].InternalMark,
                            textAlign: TextAlign.center,
                            style: SecondaryText3())),
                  ),
                  Container(
                    width: 80.0,
                    margin: const EdgeInsets.only(left: 10.0),
                    child: Center(
                        child: Text(
                            data.UniversityMarksList[indexMark].ExternalMark,
                            textAlign: TextAlign.center,
                            style: SecondaryText3())),
                  ),
                  Container(
                    width: 100.0,
                    margin: const EdgeInsets.only(left: 10.0),
                    child: Center(
                        child: Text(
                            data.UniversityMarksList[indexMark].AttemptNo,
                            textAlign: TextAlign.center,
                            style: SecondaryText3())),
                  ),
                  Container(
                    width: 70.0,
                    margin: const EdgeInsets.only(left: 10.0),
                    child: Center(
                        child: Text(data.UniversityMarksList[indexMark].Credit,
                            textAlign: TextAlign.center,
                            style: SecondaryText3())),
                  ),
                  Container(
                    width: 100.0,
                    margin: const EdgeInsets.only(left: 10.0),
                    child: Center(
                        child: Text(
                            data.UniversityMarksList[indexMark].SubjectType,
                            textAlign: TextAlign.center,
                            style: SecondaryText3())),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Text("-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"),
      ],
    );

Widget UniversityMarkDisplayTitle(BuildContext context) => Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
          height: 50.0,
          decoration: const BoxDecoration(color: Colors.white),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  const SizedBox(
                    width: 130.0,
                    child: Center(
                        child: Text("Subject Name",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15,fontWeight: FontWeight.w900))),
                  ),
                  Container(
                    width: 70.0,
                    margin: const EdgeInsets.only(left: 10.0),
                    child: const Center(
                        child: Text("Result",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15,fontWeight: FontWeight.w900))),
                  ),
                  Container(
                    width: 70.0,
                    margin: const EdgeInsets.only(left: 10.0),
                    child: const Center(
                        child: Text("Total",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15,fontWeight: FontWeight.w900))),
                  ),
                  Container(
                    width: 70.0,
                    margin: const EdgeInsets.only(left: 10.0),
                    child: const Center(
                        child: Text("Internal",
                            textAlign: TextAlign.center,
                            style:  TextStyle(fontSize: 15,fontWeight: FontWeight.w900))),
                  ),
                  Container(
                    width: 80.0,
                    margin: const EdgeInsets.only(left: 10.0),
                    child: const Center(
                        child: Text("External",
                            textAlign: TextAlign.center,
                            style:TextStyle(fontSize: 15,fontWeight: FontWeight.w900))),
                  ),
                  Container(
                    width: 100.0,
                    margin: const EdgeInsets.only(left: 10.0),
                    child: const Center(
                        child: Text("Attempt No",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15,fontWeight: FontWeight.w900))),
                  ),
                  Container(
                    width: 70.0,
                    margin: const EdgeInsets.only(left: 10.0),
                    child: const Center(
                        child: Text("Credits",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15,fontWeight: FontWeight.w900))),
                  ),
                  Container(
                    width: 100.0,
                    margin: const EdgeInsets.only(left: 10.0),
                    child: const Center(
                        child: Text("Subject Type",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15,fontWeight: FontWeight.w900))),
                  ),
                ],
              ),
              SizedBox(height: sHeight(1, context),),
              const Text("-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"),
            ],
          ),
        ),
      ],
    );

Widget UniversityMarkIteration(BuildContext context, int i, List<UniversityAPI_data> data) =>
    Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5.0),
          ),
          UniversityTestTitle(data[i], 1),//title
          Container(
            margin: const EdgeInsets.symmetric(vertical: 2.0),
            child: const Text("---------------------------------------------------------------------------------------"),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: <Widget>[
                UniversityMarkDisplayTitle(context),
                for (int indexMark = 0;
                    indexMark <= data[i].UniversityMarksList.length - 1; //marks data
                    indexMark++)
                  UniversityTestMarkBuilder(context, data[i], 1, indexMark),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5.0),
          ),
        ],
      ),
    );

Widget DisplayTimetable(BuildContext context, List <TimetableAPI_data> detailsdata){
  if(GetAttencanceHours() <= 10){
    return Column(
      children: <Widget> [
        StudentsTimetableGeneratorTitle(context),
        for (int i = 0; i <= detailsdata.length-1; i++ )
          StudentsTimetableGenerator(context, detailsdata[i]),
      ],
    );
  }
  else {
    print('Attendance Greater than 10');
  }
  return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 20),
      child: Center(child: Text("Sorry Something went wrong!", style: ErrorText2Big(),textAlign: TextAlign.center,)));
}

Widget StudentsTimetableGeneratorTitle(BuildContext context) {
  switch (AttendanceHou){
    case 4 : return Container(
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
                      style: PrimaryText4(), textAlign: TextAlign.center)),
            ),
          ),
          Container(
            width: 130,
            height: 30,
            margin: const EdgeInsets.only(left: 50.0),
            child:
            Text("1", style: PrimaryText4(), textAlign: TextAlign.center),
          ),
          Container(
            width: 130,
            height: 30,
            margin: const EdgeInsets.only(left: 20.0),
            child:
            Text("2", style: PrimaryText4(), textAlign: TextAlign.center),
          ),
          Container(
            width: 130,
            height: 30,
            margin: const EdgeInsets.only(left: 20.0),
            child:
            Text("3", style: PrimaryText4(), textAlign: TextAlign.center),
          ),
          Container(
            width: 130,
            height: 30,
            margin: const EdgeInsets.only(left: 20.0),
            child:
            Text("4", style: PrimaryText4(), textAlign: TextAlign.center),
          ),
        ],
      ),
    );
    case 5 : return Container(
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
            width: 130,
            height: 30,
            margin: const EdgeInsets.only(left: 50.0),
            child:
            Text("1", style: PrimaryText4(), textAlign: TextAlign.center),
          ),
          Container(
            width: 130,
            height: 30,
            margin: const EdgeInsets.only(left: 20.0),
            child:
            Text("2", style: PrimaryText4(), textAlign: TextAlign.center),
          ),
          Container(
            width: 130,
            height: 30,
            margin: const EdgeInsets.only(left: 20.0),
            child:
            Text("3", style: PrimaryText4(), textAlign: TextAlign.center),
          ),
          Container(
            width: 130,
            height: 30,
            margin: const EdgeInsets.only(left: 20.0),
            child:
            Text("4", style: PrimaryText4(), textAlign: TextAlign.center),
          ),
          Container(
            width: 130,
            height: 30,
            margin: const EdgeInsets.only(left: 20.0),
            child:
            Text("5", style: PrimaryText4(), textAlign: TextAlign.center),
          ),
        ],
      ),
    );
    case 6 : return Container(
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
                      style: PrimaryText4(), textAlign: TextAlign.center)),
            ),
          ),
          Container(
            width: 130,
            height: 30,
            margin: const EdgeInsets.only(left: 50.0),
            child:
            Text("1", style: PrimaryText4(), textAlign: TextAlign.center),
          ),
          Container(
            width: 130,
            height: 30,
            margin: const EdgeInsets.only(left: 20.0),
            child:
            Text("2", style: PrimaryText4(), textAlign: TextAlign.center),
          ),
          Container(
            width: 130,
            height: 30,
            margin: const EdgeInsets.only(left: 20.0),
            child:
            Text("3", style: PrimaryText4(), textAlign: TextAlign.center),
          ),
          Container(
            width: 130,
            height: 30,
            margin: const EdgeInsets.only(left: 20.0),
            child:
            Text("4", style: PrimaryText4(), textAlign: TextAlign.center),
          ),
          Container(
            width: 130,
            height: 30,
            margin: const EdgeInsets.only(left: 20.0),
            child:
            Text("5", style: PrimaryText4(), textAlign: TextAlign.center),
          ),
          Container(
            width: 130,
            height: 30,
            margin: const EdgeInsets.only(left: 20.0),
            child:
            Text("6", style: PrimaryText4(), textAlign: TextAlign.center),
          ),
        ],
      ),
    );
    case 7 : return Container(
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
                      style: PrimaryText4(), textAlign: TextAlign.center)),
            ),
          ),
          Container(
            width: 130,
            height: 30,
            margin: const EdgeInsets.only(left: 50.0),
            child:
            Text("1", style: PrimaryText4(), textAlign: TextAlign.center),
          ),
          Container(
            width: 130,
            height: 30,
            margin: const EdgeInsets.only(left: 20.0),
            child:
            Text("2", style: PrimaryText4(), textAlign: TextAlign.center),
          ),
          Container(
            width: 130,
            height: 30,
            margin: const EdgeInsets.only(left: 20.0),
            child:
            Text("3", style: PrimaryText4(), textAlign: TextAlign.center),
          ),
          Container(
            width: 130,
            height: 30,
            margin: const EdgeInsets.only(left: 20.0),
            child:
            Text("4", style: PrimaryText4(), textAlign: TextAlign.center),
          ),
          Container(
            width: 130,
            height: 30,
            margin: const EdgeInsets.only(left: 20.0),
            child:
            Text("5", style: PrimaryText4(), textAlign: TextAlign.center),
          ),
          Container(
            width: 130,
            height: 30,
            margin: const EdgeInsets.only(left: 20.0),
            child:
            Text("6", style: PrimaryText4(), textAlign: TextAlign.center),
          ),
          Container(
            width: 130,
            height: 30,
            margin: const EdgeInsets.only(left: 20.0),
            child:
            Text("7", style: PrimaryText4(), textAlign: TextAlign.center),
          ),
        ],
      ),
    );
    case 8 : return Container(
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
                      style: PrimaryText4(), textAlign: TextAlign.center)),
            ),
          ),
          Container(
            width: 130,
            height: 30,
            margin: const EdgeInsets.only(left: 50.0),
            child:
            Text("1", style: PrimaryText4(), textAlign: TextAlign.center),
          ),
          Container(
            width: 130,
            height: 30,
            margin: const EdgeInsets.only(left: 20.0),
            child:
            Text("2", style: PrimaryText4(), textAlign: TextAlign.center),
          ),
          Container(
            width: 130,
            height: 30,
            margin: const EdgeInsets.only(left: 20.0),
            child:
            Text("3", style: PrimaryText4(), textAlign: TextAlign.center),
          ),
          Container(
            width: 130,
            height: 30,
            margin: const EdgeInsets.only(left: 20.0),
            child:
            Text("4", style: PrimaryText4(), textAlign: TextAlign.center),
          ),
          Container(
            width: 130,
            height: 30,
            margin: const EdgeInsets.only(left: 20.0),
            child:
            Text("5", style: PrimaryText4(), textAlign: TextAlign.center),
          ),
          Container(
            width: 130,
            height: 30,
            margin: const EdgeInsets.only(left: 20.0),
            child:
            Text("6", style: PrimaryText4(), textAlign: TextAlign.center),
          ),
          Container(
            width: 130,
            height: 30,
            margin: const EdgeInsets.only(left: 20.0),
            child:
            Text("7", style: PrimaryText4(), textAlign: TextAlign.center),
          ),
          Container(
            width: 130,
            height: 30,
            margin: const EdgeInsets.only(left: 20.0),
            child:
            Text("8", style: PrimaryText4(), textAlign: TextAlign.center),
          ),
        ],
      ),
    );
    case 9 : return Container(
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
                      style: PrimaryText4(), textAlign: TextAlign.center)),
            ),
          ),
          Container(
            width: 130,
            height: 30,
            margin: const EdgeInsets.only(left: 50.0),
            child:
            Text("1", style: PrimaryText4(), textAlign: TextAlign.center),
          ),
          Container(
            width: 130,
            height: 30,
            margin: const EdgeInsets.only(left: 20.0),
            child:
            Text("2", style: PrimaryText4(), textAlign: TextAlign.center),
          ),
          Container(
            width: 130,
            height: 30,
            margin: const EdgeInsets.only(left: 20.0),
            child:
            Text("3", style: PrimaryText4(), textAlign: TextAlign.center),
          ),
          Container(
            width: 130,
            height: 30,
            margin: const EdgeInsets.only(left: 20.0),
            child:
            Text("4", style: PrimaryText4(), textAlign: TextAlign.center),
          ),
          Container(
            width: 130,
            height: 30,
            margin: const EdgeInsets.only(left: 20.0),
            child:
            Text("5", style: PrimaryText4(), textAlign: TextAlign.center),
          ),
          Container(
            width: 130,
            height: 30,
            margin: const EdgeInsets.only(left: 20.0),
            child:
            Text("6", style: PrimaryText4(), textAlign: TextAlign.center),
          ),
          Container(
            width: 130,
            height: 30,
            margin: const EdgeInsets.only(left: 20.0),
            child:
            Text("7", style: PrimaryText4(), textAlign: TextAlign.center),
          ),
          Container(
            width: 130,
            height: 30,
            margin: const EdgeInsets.only(left: 20.0),
            child:
            Text("8", style: PrimaryText4(), textAlign: TextAlign.center),
          ),
          Container(
            width: 130,
            height: 30,
            margin: const EdgeInsets.only(left: 20.0),
            child:
            Text("9", style: PrimaryText4(), textAlign: TextAlign.center),
          ),
        ],
      ),
    );
    case 10 : return Container(
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
                      style: PrimaryText4(), textAlign: TextAlign.center)),
            ),
          ),
          Container(
            width: 130,
            height: 30,
            margin: const EdgeInsets.only(left: 50.0),
            child:
            Text("1", style: PrimaryText4(), textAlign: TextAlign.center),
          ),
          Container(
            width: 130,
            height: 30,
            margin: const EdgeInsets.only(left: 20.0),
            child:
            Text("2", style: PrimaryText4(), textAlign: TextAlign.center),
          ),
          Container(
            width: 130,
            height: 30,
            margin: const EdgeInsets.only(left: 20.0),
            child:
            Text("3", style: PrimaryText4(), textAlign: TextAlign.center),
          ),
          Container(
            width: 130,
            height: 30,
            margin: const EdgeInsets.only(left: 20.0),
            child:
            Text("4", style: PrimaryText4(), textAlign: TextAlign.center),
          ),
          Container(
            width: 130,
            height: 30,
            margin: const EdgeInsets.only(left: 20.0),
            child:
            Text("5", style: PrimaryText4(), textAlign: TextAlign.center),
          ),
          Container(
            width: 130,
            height: 30,
            margin: const EdgeInsets.only(left: 20.0),
            child:
            Text("6", style: PrimaryText4(), textAlign: TextAlign.center),
          ),
          Container(
            width: 130,
            height: 30,
            margin: const EdgeInsets.only(left: 20.0),
            child:
            Text("7", style: PrimaryText4(), textAlign: TextAlign.center),
          ),
          Container(
            width: 130,
            height: 30,
            margin: const EdgeInsets.only(left: 20.0),
            child:
            Text("8", style: PrimaryText4(), textAlign: TextAlign.center),
          ),
          Container(
            width: 130,
            height: 30,
            margin: const EdgeInsets.only(left: 20.0),
            child:
            Text("9", style: PrimaryText4(), textAlign: TextAlign.center),
          ),
          Container(
            width: 130,
            height: 30,
            margin: const EdgeInsets.only(left: 20.0),
            child:
            Text("10", style: PrimaryText4(), textAlign: TextAlign.center),
          ),
        ],
      ),
    );
    default : return Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(top: 20),
        child: Center(child: Text("Sorry Something went wrong!", style: ErrorText2Big(),textAlign: TextAlign.center,)));
  }
}

Widget StudentsTimetableGenerator(BuildContext context, TimetableAPI_data data) {
  switch (AttendanceHou){
    case 4 : return Column(
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
                          style: PrimaryText4(),
                          textAlign: TextAlign.center)),
                ),
              ),
              if(data.c1 == '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 40,
                        margin: const EdgeInsets.only(left: 50.0),
                        child: Text(
                          "__",
                          style: PrimaryText4(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              if(data.c1 != '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
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
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 50.0, top: 10),
                        child: Text(data.s1,
                            style: PrimaryText8(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
              if(data.c2 == '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 40,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          "__",
                          style: PrimaryText4(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              if(data.c2 != '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 30,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(data.c2,
                            style: PrimaryText4(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0, top: 10),
                        child: Text(data.s2,
                            style: PrimaryText8(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
              if(data.c3 == '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 40,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          "__",
                          style: PrimaryText4(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              if(data.c3 != '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(data.c3,
                            style: PrimaryText4(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0, top: 10),
                        child: Text(data.s3,
                            style: PrimaryText8(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
              if(data.c4 == '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 40,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          "__",
                          style: PrimaryText4(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              if(data.c4 != '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(data.c4,
                            style: PrimaryText4(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0, top: 10),
                        child: Text(data.s4,
                            style: PrimaryText8(),
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
    case 5 : return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10.0),
          height: 70.0,
          child: Row(
            children: <Widget>[
              SizedBox(
                child: SizedBox(
                  width: 40.0,
                  height: 20,
                  child: Center(
                      child: Text(data.dy,
                          style: PrimaryText4(),
                          textAlign: TextAlign.center)),
                ),
              ),
              if(data.c1 == '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 150,
                        height: 40,
                        margin: const EdgeInsets.only(left: 25.0,top: 21),
                        child: Text(
                          "__",
                          style: PrimaryText4(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              if(data.c1 != '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
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
                        width: 130,
                        height: 30,
                        margin: const EdgeInsets.only(left: 50.0, top: 10),
                        child: Text(data.s1,
                            style: PrimaryText8(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
              if(data.c2 == '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 40,
                        margin: const EdgeInsets.only(left: 22.0,top: 21),
                        child: Text(
                          "__",
                          style: PrimaryText4(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              if(data.c2 != '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(data.c2,
                            style: PrimaryText4(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 30,
                        margin: const EdgeInsets.only(left: 20.0, top: 10),
                        child: Text(data.s2,
                            style: PrimaryText8(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
              if(data.c3 == '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 40,
                        margin: const EdgeInsets.only(left: 22.0,top: 21),
                        child: Text(
                          "__",
                          style: PrimaryText4(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              if(data.c3 != '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(data.c3,
                            style: PrimaryText4(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 30,
                        margin: const EdgeInsets.only(left: 20.0, top: 10),
                        child: Text(data.s3,
                            style: PrimaryText8(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
              if(data.c4 == '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 40,
                        margin: const EdgeInsets.only(left: 22.0,top: 21),
                        child: Text(
                          "__",
                          style: PrimaryText4(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              if(data.c4 != '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(data.c4,
                            style: PrimaryText4(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 30,
                        margin: const EdgeInsets.only(left: 20.0, top: 10),
                        child: Text(data.s4,
                            style: PrimaryText8(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
              if(data.c5 == '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 40,
                        margin: const EdgeInsets.only(left: 22.0,top: 21),
                        child: Text(
                          "__",
                          style: PrimaryText4(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              if(data.c5 != '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(data.c5,
                            style: PrimaryText4(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 30,
                        margin: const EdgeInsets.only(left: 20.0, top: 10),
                        child: Text(data.s5,
                            style: PrimaryText8(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        const Divider(height: 0, thickness: 0, indent: 3, endIndent: 3),
      ],
    );
    case 6 : return Column(
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
                          style: PrimaryText4(),
                          textAlign: TextAlign.center)),
                ),
              ),
              if(data.c1 == '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 40,
                        margin: const EdgeInsets.only(left: 50.0),
                        child: Text(
                          "__",
                          style: PrimaryText4(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              if(data.c1 != '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
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
                        width: 130,
                        height: 30,
                        margin: const EdgeInsets.only(left: 50.0, top: 10),
                        child: Text(data.s1,
                            style: PrimaryText8(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
              if(data.c2 == '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 40,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          "__",
                          style: PrimaryText4(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              if(data.c2 != '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(data.c2,
                            style: PrimaryText4(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 30,
                        margin: const EdgeInsets.only(left: 20.0, top: 10),
                        child: Text(data.s2,
                            style: PrimaryText8(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
              if(data.c3 == '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 40,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          "__",
                          style: PrimaryText4(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              if(data.c3 != '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(data.c3,
                            style: PrimaryText4(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 30,
                        margin: const EdgeInsets.only(left: 20.0, top: 10),
                        child: Text(data.s3,
                            style: PrimaryText8(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
              if(data.c4 == '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 40,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          "__",
                          style: PrimaryText4(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              if(data.c4 != '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(data.c4,
                            style: PrimaryText4(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 30,
                        margin: const EdgeInsets.only(left: 20.0, top: 10),
                        child: Text(data.s4,
                            style: PrimaryText8(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
              if(data.c5 == '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 40,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          "__",
                          style: PrimaryText4(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              if(data.c5 != '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(data.c5,
                            style: PrimaryText4(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 30,
                        margin: const EdgeInsets.only(left: 20.0, top: 10),
                        child: Text(data.s5,
                            style: PrimaryText8(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
              if(data.c6 == '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 40,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          "__",
                          style: PrimaryText4(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              if(data.c6 != '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(data.c6,
                            style: PrimaryText4(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 30,
                        margin: const EdgeInsets.only(left: 20.0, top: 10),
                        child: Text(data.s6,
                            style: PrimaryText8(),
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
    case 7 : return Column(
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
                          style: PrimaryText4(),
                          textAlign: TextAlign.center)),
                ),
              ),
              if(data.c1 == '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 40,
                        margin: const EdgeInsets.only(left: 50.0),
                        child: Text(
                          "__",
                          style: PrimaryText4(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              if(data.c1 != '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
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
                        width: 130,
                        height: 30,
                        margin: const EdgeInsets.only(left: 50.0, top: 10),
                        child: Text(data.s1,
                            style: PrimaryText8(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
              if(data.c2 == '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 40,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          "__",
                          style: PrimaryText4(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              if(data.c2 != '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(data.c2,
                            style: PrimaryText4(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0, top: 10),
                        child: Text(data.s2,
                            style: PrimaryText8(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
              if(data.c3 == '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 40,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          "__",
                          style: PrimaryText4(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              if(data.c3 != '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(data.c3,
                            style: PrimaryText4(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0, top: 10),
                        child: Text(data.s3,
                            style: PrimaryText8(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
              if(data.c4 == '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 40,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          "__",
                          style: PrimaryText4(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              if(data.c4 != '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(data.c4,
                            style: PrimaryText4(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0, top: 10),
                        child: Text(data.s4,
                            style: PrimaryText8(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
              if(data.c5 == '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 40,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          "__",
                          style: PrimaryText4(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              if(data.c5 != '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(data.c5,
                            style: PrimaryText4(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0, top: 10),
                        child: Text(data.s5,
                            style: PrimaryText8(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
              if(data.c6 == '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 40,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          "__",
                          style: PrimaryText4(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              if(data.c6 != '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(data.c6,
                            style: PrimaryText4(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0, top: 10),
                        child: Text(data.s6,
                            style: PrimaryText8(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
              if(data.c7 == '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 40,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          "__",
                          style: PrimaryText4(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              if(data.c7 != '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(data.c7,
                            style: PrimaryText4(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0, top: 10),
                        child: Text(data.s7,
                            style: PrimaryText8(),
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
    case 8 : return Column(
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
                          style: PrimaryText4(),
                          textAlign: TextAlign.center)),
                ),
              ),
              if(data.c1 == '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 40,
                        margin: const EdgeInsets.only(left: 50.0),
                        child: Text(
                          "__",
                          style: PrimaryText4(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              if(data.c1 != '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
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
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 50.0, top: 10),
                        child: Text(data.s1,
                            style: PrimaryText8(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
              if(data.c2 == '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 40,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          "__",
                          style: PrimaryText4(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              if(data.c2 != '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(data.c2,
                            style: PrimaryText4(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0, top: 10),
                        child: Text(data.s2,
                            style: PrimaryText8(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
              if(data.c3 == '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 40,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          "__",
                          style: PrimaryText4(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              if(data.c3 != '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(data.c3,
                            style: PrimaryText4(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0, top: 10),
                        child: Text(data.s3,
                            style: PrimaryText8(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
              if(data.c4 == '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 40,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          "__",
                          style: PrimaryText4(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              if(data.c4 != '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(data.c4,
                            style: PrimaryText4(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0, top: 10),
                        child: Text(data.s4,
                            style: PrimaryText8(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
              if(data.c5 == '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 40,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          "__",
                          style: PrimaryText4(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              if(data.c5 != '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(data.c5,
                            style: PrimaryText4(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0, top: 10),
                        child: Text(data.s5,
                            style: PrimaryText8(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
              if(data.c6 == '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 40,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          "__",
                          style: PrimaryText4(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              if(data.c6 != '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(data.c6,
                            style: PrimaryText4(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0, top: 10),
                        child: Text(data.s6,
                            style: PrimaryText8(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
              if(data.c7 == '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 40,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          "__",
                          style: PrimaryText4(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              if(data.c7 != '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(data.c7,
                            style: PrimaryText4(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0, top: 10),
                        child: Text(data.s7,
                            style: PrimaryText8(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
              if(data.c8 == '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 40,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          "__",
                          style: PrimaryText4(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              if(data.c8 != '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(data.c8,
                            style: PrimaryText4(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0, top: 10),
                        child: Text(data.s8,
                            style: PrimaryText8(),
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
    case 9 : return Column(
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
                          style: PrimaryText4(),
                          textAlign: TextAlign.center)),
                ),
              ),
              if(data.c1 == '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 40,
                        margin: const EdgeInsets.only(left: 50.0),
                        child: Text(
                          "__",
                          style: PrimaryText4(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              if(data.c1 != '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
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
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 50.0, top: 10),
                        child: Text(data.s1,
                            style: PrimaryText8(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
              if(data.c2 == '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 40,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          "__",
                          style: PrimaryText4(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              if(data.c2 != '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(data.c2,
                            style: PrimaryText4(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0, top: 10),
                        child: Text(data.s2,
                            style: PrimaryText8(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
              if(data.c3 == '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 40,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          "__",
                          style: PrimaryText4(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              if(data.c3 != '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(data.c3,
                            style: PrimaryText4(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0, top: 10),
                        child: Text(data.s3,
                            style: PrimaryText8(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
              if(data.c4 == '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 40,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          "__",
                          style: PrimaryText4(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              if(data.c4 != '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(data.c4,
                            style: PrimaryText4(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0, top: 10),
                        child: Text(data.s4,
                            style: PrimaryText8(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
              if(data.c5 == '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 40,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          "__",
                          style: PrimaryText4(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              if(data.c5 != '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(data.c5,
                            style: PrimaryText4(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0, top: 10),
                        child: Text(data.s5,
                            style: PrimaryText8(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
              if(data.c6 == '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 40,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          "__",
                          style: PrimaryText4(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              if(data.c6 != '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(data.c6,
                            style: PrimaryText4(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0, top: 10),
                        child: Text(data.s6,
                            style: PrimaryText8(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
              if(data.c7 == '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 40,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          "__",
                          style: PrimaryText4(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              if(data.c7 != '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(data.c7,
                            style: PrimaryText4(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0, top: 10),
                        child: Text(data.s7,
                            style: PrimaryText8(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
              if(data.c8 == '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 40,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          "__",
                          style: PrimaryText4(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              if(data.c8 != '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(data.c8,
                            style: PrimaryText4(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0, top: 10),
                        child: Text(data.s8,
                            style: PrimaryText8(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
              if(data.c9 == '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 40,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          "__",
                          style: PrimaryText4(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              if(data.c9 != '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(data.c9,
                            style: PrimaryText4(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0, top: 10),
                        child: Text(data.s9,
                            style: PrimaryText8(),
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
    case 10 : return Column(
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
                          style: PrimaryText4(),
                          textAlign: TextAlign.center)),
                ),
              ),
              if(data.c1 == '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 40,
                        margin: const EdgeInsets.only(left: 50.0),
                        child: Text(
                          "__",
                          style: PrimaryText4(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              if(data.c1 != '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
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
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 50.0, top: 10),
                        child: Text(data.s1,
                            style: PrimaryText8(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
              if(data.c2 == '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 40,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          "__",
                          style: PrimaryText4(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              if(data.c2 != '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(data.c2,
                            style: PrimaryText4(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0, top: 10),
                        child: Text(data.s2,
                            style: PrimaryText8(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
              if(data.c3 == '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 40,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          "__",
                          style: PrimaryText4(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              if(data.c3 != '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(data.c3,
                            style: PrimaryText4(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0, top: 10),
                        child: Text(data.s3,
                            style: PrimaryText8(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
              if(data.c4 == '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 40,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          "__",
                          style: PrimaryText4(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              if(data.c4 != '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(data.c4,
                            style: PrimaryText4(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0, top: 10),
                        child: Text(data.s4,
                            style: PrimaryText8(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
              if(data.c5 == '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 40,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          "__",
                          style: PrimaryText4(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              if(data.c5 != '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(data.c5,
                            style: PrimaryText4(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0, top: 10),
                        child: Text(data.s5,
                            style: PrimaryText8(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
              if(data.c6 == '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 40,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          "__",
                          style: PrimaryText4(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              if(data.c6 != '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(data.c6,
                            style: PrimaryText4(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0, top: 10),
                        child: Text(data.s6,
                            style: PrimaryText8(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
              if(data.c7 == '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 40,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          "__",
                          style: PrimaryText4(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              if(data.c7 != '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(data.c7,
                            style: PrimaryText4(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0, top: 10),
                        child: Text(data.s7,
                            style: PrimaryText8(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
              if(data.c8 == '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 40,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          "__",
                          style: PrimaryText4(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              if(data.c8 != '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(data.c8,
                            style: PrimaryText4(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0, top: 10),
                        child: Text(data.s8,
                            style: PrimaryText8(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
              if(data.c9 == '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 40,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          "__",
                          style: PrimaryText4(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              if(data.c9 != '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(data.c9,
                            style: PrimaryText4(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0, top: 10),
                        child: Text(data.s9,
                            style: PrimaryText8(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
              if(data.c10 == '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 40,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          "__",
                          style: PrimaryText4(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              if(data.c10 != '- N/A -')
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0),
                        child: Text(data.c10,
                            style: PrimaryText4(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    SizedBox(
                      child: Container(
                        width: 130,
                        height: 20,
                        margin: const EdgeInsets.only(left: 20.0, top: 10),
                        child: Text(data.s10,
                            style: PrimaryText8(),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        const Divider(height: 0, thickness: 10, indent: 3, endIndent: 3),
      ],
    );
    default : return Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(top: 20),
        child: Center(child: Text("Sorry Something went wrong!", style: ErrorText2Big(),textAlign: TextAlign.center,)));
  }
}

Widget StudentsHolidayGenerator(BuildContext context, HolidayAPI_data data) =>
    Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(left: 15.0,top: 8, right: 15.0),
          padding: const EdgeInsets.only(right: 10.0, left: 10.0),
          width: sWidth(90, context),
          decoration: const BoxDecoration(
            color: Color.fromRGBO(233,239,255, 1),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: [
                SizedBox(height: sHeight(1, context),),
                Row(
                    children: <Widget>[
                      SizedBox(
                        height: sHeight(2, context),
                      ),
                      SizedBox(
                        width: sWidth(60, context),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                     data.Name.length < 20 ?Text("${data.Name.characters.take(20)}",style:
                                    const TextStyle(fontSize: 16,fontWeight: FontWeight.w800,color: Color.fromRGBO(26,63,148,1)),):Text("${data.Name.characters.take(18)}...",style:
                                    const TextStyle(fontSize: 16,fontWeight: FontWeight.w800),),
                                SizedBox(
                                  height: sHeight(1, context),
                                ),
                               Text(data.Date,maxLines: 1,overflow: TextOverflow.ellipsis,textAlign: TextAlign.right,style:const TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
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
                          ],
                        ),
                      ),
                      SizedBox(
                        width: sWidth(8, context),
                      ),
                      Container(
                        height: sHeight(4, context),
                        width: sWidth(15, context),
                        decoration: const BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.all(
                            Radius.circular(3),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "${data.Day.characters.take(3).toUpperCase()}",maxLines: 1,overflow: TextOverflow.ellipsis,textAlign: TextAlign.right,
                            style: const TextStyle(fontSize: 13,fontWeight: FontWeight.w700,color: Colors.white),
                          ),
                        ),
                      )
                    ]),
                SizedBox(height: sHeight(1, context),),
              ],
            ),
          ),
        )
      ],
    );

Widget StudentsCircularGenerator(BuildContext context, CircularAPI_data data) {
  if (data.Discription.length <28){
    return
      Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(left: 15.0, top: 10.0, right: 15.0),
            padding: const EdgeInsets.only(right: 15.0, left: 15.0),
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(15),)
            ),
            child: Column(
              children: <Widget>[
                SizedBox(height: sHeight(1, context),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        width: sWidth(20, context),
                        height: sHeight(5, context),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(10),),),
                        child: Center(
                            child: Text(data.Remark,
                                style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w800)))),
                    InkWell(
                      onTap: ()=> LaunchTheFile(data.File),
                      child: Container(
                        height: sHeight(4, context),
                        width: sWidth(15, context),
                        decoration: const BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        child: const Center(child: Icon(Icons.cloud_download_outlined,color: Colors.white,)),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: sHeight(1, context),),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                          width: sWidth(85, context),
                          child: Text("${data.Discription}- ${data.CreatedBy}",style: const TextStyle(fontSize: 17,fontWeight: FontWeight.w900),maxLines: 1,overflow: TextOverflow.ellipsis,textAlign: TextAlign.left)
                      ),
                    ],
                  ),
                ),
                SizedBox(height: sHeight(1.5, context),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        margin: const EdgeInsets.only(top: 2, left: 0),
                        height: 20.0,
                        child: SizedBox(
                            child: Row(
                              children: [
                                const Text("Date :",style: TextStyle(color: Colors.black54),),
                                Text(" ${data.CircularDate}",
                                    style: const TextStyle(fontWeight: FontWeight.w700)),
                              ],
                            ))), Container(
                        margin: const EdgeInsets.only(top: 2, left: 0),
                        height: 20.0,
                        child: SizedBox(
                            child: Row(
                              children: [
                                const Text("Day :",style: TextStyle(color: Colors.black54),),
                                Text(data.Day,
                                    style: const TextStyle(fontWeight: FontWeight.w700)),
                              ],
                            ))),
                  ],
                ),
                SizedBox(height: sHeight(1.5, context),),
              ],
            ),
          ),
        ],
      );
  }
  else{
    return
      Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(left: 15.0, top: 10.0, right: 15.0),
            padding: const EdgeInsets.only(right: 15.0, left: 15.0),
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(15),)
            ),
            child: Column(
              children: <Widget>[
                SizedBox(height: sHeight(3, context),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        width: sWidth(20, context),
                        height: sHeight(5, context),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(10),),),
                        child: Center(
                            child: Text(data.Remark,
                                style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w800)))),
                    InkWell(
                      onTap: ()=> LaunchTheFile(data.File),
                      child: Container(
                        height: sHeight(4, context),
                        width: sWidth(15, context),
                        decoration: const BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        child: const Center(child: Icon(Icons.cloud_download_outlined,color: Colors.white,),),
                      ),
                    ),

                  ],
                ),
                SizedBox(height: sHeight(1.5, context),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: sWidth(80, context),
                        child: Text("${data.Discription}- ${data.CreatedBy}",style: const TextStyle(fontSize: 17,fontWeight: FontWeight.w900),maxLines: 1,overflow: TextOverflow.ellipsis,textAlign: TextAlign.left
                        )),
                  ],
                ),
                SizedBox(height: sHeight(1.5, context),),
                Row(
                  children: [
                    const Text("Date :",style: TextStyle(color: Colors.black54),),
                    Container(
                        margin: const EdgeInsets.only(top: 2, left: 0),
                        height: 20.0,
                        child: SizedBox(
                            child: Text(" ${data.CircularDate}",
                                style: const TextStyle(fontWeight: FontWeight.w700)))),
                  ],
                ),
                SizedBox(height: sHeight(1.5, context),),
              ],
            ),
          ),
        ],
      );
  }
}

Widget StudentExamCertificateGenerator(
    BuildContext context, ExamCertificateAPI_data data,) =>
    InkWell(
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.symmetric(horizontal: 15.0),
            width: MediaQuery.of(context).size.width,
            height: 50.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(data.CertificateName,
                    style: const TextStyle(fontSize: 19,fontWeight: FontWeight.w900), textAlign: TextAlign.center),
                InkWell(
                  onTap: ()=> LaunchUniversityMarkFile(data.FileName),
                  child: Container(
                    height: sHeight(4, context),
                    width: sWidth(15, context),
                    decoration: const BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(5 ))
                    ),
                    child: const Center(child: Icon(Icons.cloud_download_outlined,color: Colors.white,)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      onTap: () => LaunchUniversityMarkFile(data.FileName),
    );

Widget StudentsDCBGenerator(BuildContext context, StudentDCBAPI_data data) =>
    Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(left: 15.0, top: 10.0, right: 15.0),
          padding: const EdgeInsets.only(right: 0.0, left: 0.0),
          width: MediaQuery.of(context).size.width,
          // height: 240,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius:
            BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: sHeight(2, context),
              ),
              Container(
                  margin: const EdgeInsets.only(top: 5, left: 0),
                  height: 25.0,
                  child: SizedBox(
                      child: Center(child: Text(data.Semester, style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w800),textAlign: TextAlign.center,)))),
              AttendanceProfileDivider1(),
              Container(
                  margin: const EdgeInsets.only(top: 5, left: 0),
                  height: 20.0,
                  child: SizedBox(
                      child: Text("  Fee Payable         :      ${indiaFormat.format(data.Demand)}",
                          style: PrimaryText5()))),
              Container(
                  margin: const EdgeInsets.only(top: 5, left: 0),
                  height: 20.0,
                  child: SizedBox(
                      child: Text("  Fee Concession  :      ${indiaFormat.format(data.Concession)}",
                          style: PrimaryText5()))),
              Container(
                  margin: const EdgeInsets.only(top: 5, left: 0),
                  height: 20.0,
                  child: SizedBox(
                      child: Text("  Fee Paid               :      ${indiaFormat.format(data.Paid)}",
                          style: PrimaryText5()))),
              Container(
                  margin: const EdgeInsets.only(top: 5, left: 0),
                  height: 20.0,
                  child: SizedBox(
                      child: Text("  Fine                       :      ${indiaFormat.format(data.Fine)}",
                          style: PrimaryText5()))),

              Container(
                  margin: const EdgeInsets.only(top: 5, left: 0),
                  height: sHeight(7, context),
                  width: sWidth(100, context),
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(220,248,221,1),
                    borderRadius:
                    BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                  ),
                  child: SizedBox(
                      child: Center(
                        child: Text("Balance       :      ${indiaFormat.format(data.Balance)}",textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 19,color: Colors.black,fontWeight: FontWeight.bold),),
                      ))),
              // AttendanceProfile(
              //     "${data.Day}", 10, 0),
            ],
          ),
        ),
      ],
    );

Widget StudentsDCBHistoryGenerator(
    BuildContext context, List<StudentDCBHistoryAPI_data> data, int index) {
  double y = 7;
  if (index % 2 == 0) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: <Widget>[
                Container(
                  width: sWidth(95, context),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        child: Container(
                          margin: EdgeInsets.only(top: y),
                          child: Text(data[index].FeeMainHead,
                              style: PrimaryText2(),
                              textAlign: TextAlign.start),
                        ),
                      ),
                      SizedBox(
                        child: Text(
                          data[index].Semester,
                          style: PrimaryText2(),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      AttendanceProfileDivider1(),
                      SizedBox(
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: y),
                              child: Row(
                                children: [
                                 data[index].ReceiptNo.toString() == "".toString()? Text(
                                  "  Receipt no             : -",
                                    style: PrimaryText5(),
                                    textAlign: TextAlign.start,
                                  ):Text(
                              "  Receipt no             : ${data[index].ReceiptNo}",                                     style: PrimaryText5(),
                                   textAlign: TextAlign.start,
                                 ),
                                ],
                              ),
                            ),
                            SizedBox(
                              child: Container(
                                margin: EdgeInsets.only(top: y),
                                child: Row(
                                  children: [
                                    data[index].ReceiptDate.toString() == "".toString()? Text(
                                      "  Receipt date          : -",
                                      style: PrimaryText5(),
                                      textAlign: TextAlign.start,
                                    ):Text(
                                      "  Receipt date          : ${data[index].ReceiptDate}",                                     style: PrimaryText5(),
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            /*SizedBox(
                              child: Container(
                                margin: EdgeInsets.only(top: y),
                                child: Row(
                                  children: [
                                    Text(
                                      "  Last Date        : ${data[index].LastDate}",
                                      style: PrimaryText5(),
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                              ),
                            ),*/
                            SizedBox(
                              child: Container(
                                margin: EdgeInsets.only(top: y),
                                child: Row(
                                  children: [
                                    Text(
                                      "  Fee Payable           : ${indiaFormat.format(data[index].Demand)}",
                                      style: PrimaryText5(),
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              child: Container(
                                margin: EdgeInsets.only(top: y),
                                child: Row(
                                  children: [
                                    Text(
                                        "  Fee Concession    : ${indiaFormat.format(data[index].Concession)}",
                                        style: PrimaryText5(),
                                        textAlign: TextAlign.start),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              child: Container(
                                margin: EdgeInsets.only(top: y),
                                child: Row(
                                  children: [
                                    Text("  Fine                         : ${data[index].Fine}",
                                        style: PrimaryText5(),
                                        textAlign: TextAlign.start),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              child: Container(
                                margin: EdgeInsets.only(top: y),
                                child: Row(
                                  children: [
                                    Text("  Fee Paid                 : ${indiaFormat.format(data[index].Paid)}",
                                        style: PrimaryText5(),
                                        textAlign: TextAlign.start),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        child: Container(
                          height: sHeight(7, context),
                          width: sWidth(100, context),
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(220,248,221,1),
                            borderRadius:
                            BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                          ),
                          margin: EdgeInsets.only(top: y),
                          child: Center(
                            child: Text(
                                "Balance : ${indiaFormat.format(data[index].Balance)}",
                                style: const TextStyle(fontSize: 19,color: Colors.black,fontWeight: FontWeight.bold),
                                textAlign: TextAlign.start),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (index + 1 <= data.length - 1)
            Padding(
              padding: const EdgeInsets.all(0),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(0),
                    width: sWidth(95, context),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          child: Container(
                            margin: EdgeInsets.only(top: y),
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: [
                                Text(data[index + 1].FeeMainHead,
                                    style: PrimaryText2(),
                                    textAlign: TextAlign.start),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                              child: Text(
                                data[index + 1].Semester,
                                style: PrimaryText2(),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ),
                        ),
                        AttendanceProfileDivider1(),
                        SizedBox(
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: y),
                                child: Row(
                                  children: [
                                    data[index + 1].ReceiptNo.toString() == "".toString()? Text(
                                      "  Receipt no              : -",
                                      style: PrimaryText5(),
                                      textAlign: TextAlign.start,
                                    ):Text(
                                      "  Receipt no              : ${data[index+ 1].ReceiptNo}",                                     style: PrimaryText5(),
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                child: Container(
                                  margin: EdgeInsets.only(top: y),
                                  child: Row(
                                    children: [
                                      data[index+1].ReceiptDate.toString() == "".toString()? Text(
                                        "  Receipt date          : -",
                                        style: PrimaryText5(),
                                        textAlign: TextAlign.start,
                                      ):Text(
                                        "  Receipt date          : ${data[index+1].ReceiptDate}",                                     style: PrimaryText5(),
                                        textAlign: TextAlign.start,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              /*SizedBox(
                                child: Container(
                                  margin: EdgeInsets.only(top: y),
                                  width: MediaQuery.of(context).size.width,
                                  child: Center(
                                    child: Row(
                                      children: [
                                        Text(
                                          "  Last Date       : ${data[index + 1].LastDate}",
                                          style: PrimaryText5(),
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),*/
                              SizedBox(
                                child: Container(
                                  margin: EdgeInsets.only(top: y),
                                  width: MediaQuery.of(context).size.width,
                                  child: Center(
                                    child: Row(
                                      children: [
                                        Text(
                                          "  Fee Payable           : ${indiaFormat.format(data[index + 1].Demand)}",
                                          style: PrimaryText5(),
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                child: Container(
                                  margin: EdgeInsets.only(top: y),
                                  width: MediaQuery.of(context).size.width,
                                  child: Center(
                                    child: Row(
                                      children: [
                                        Text(
                                            "  Fee Concession    : ${indiaFormat.format(data[index + 1].Concession)}",
                                            style: PrimaryText5(),
                                            textAlign: TextAlign.start),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                child: Container(
                                  margin: EdgeInsets.only(top: y),
                                  width: MediaQuery.of(context).size.width,
                                  child: Center(
                                    child: Row(
                                      children: [
                                        Text(
                                            "  Fine                         : ${data[index + 1].Fine}",
                                            style: PrimaryText5(),
                                            textAlign: TextAlign.start),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                child: Container(
                                  margin: EdgeInsets.only(top: y),
                                  width: MediaQuery.of(context).size.width,
                                  child: Center(
                                    child: Row(
                                      children: [
                                        Text(
                                            "  Fee Paid                 : ${indiaFormat.format(data[index + 1].Paid)}",
                                            style: PrimaryText5(),
                                            textAlign: TextAlign.start),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(
                          child: Container(
                            height: sHeight(7, context),
                            width: sWidth(100, context),
                            decoration: const BoxDecoration(
                              color: Color.fromRGBO(220,248,221,1),
                              borderRadius:
                              BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                            ),
                            margin: EdgeInsets.only(top: y),
                            child: Center(
                              child: Text(
                                  "Balance : ${indiaFormat.format(data[index + 1].Balance)}",
                                  style: const TextStyle(fontSize: 19,color: Colors.black,fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.start),
                            ),
                          ),
                        ),
                      ],
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