import 'dart:convert';
import 'package:add_dev_dolphin/Style_font/designs.dart';
import 'package:add_dev_dolphin/Style_font/student_screen_design.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

String StaticIP = "";

SetStaffIP(String value){
  StaticIP = value;
}

/*
Live Site API IP Address
VET IAS: http://121.200.54.216:89/api/

Training Site API IP Address
VET IAS: http://121.200.54.216:96/api/

VET IAS with Security: http://121.200.54.216:99/api/
*/

// Staff Profile
class StaffData_List{
  final List<StaffAPI_data> Staffdata_list;

  StaffData_List({required this.Staffdata_list});

  factory StaffData_List.fromJson(List<dynamic>StaffAPI_Data_List){
    List <StaffAPI_data> staffapiData = <StaffAPI_data>[];
    staffapiData = StaffAPI_Data_List.map((i)=> StaffAPI_data.fromJson(i)).toList();
    return StaffData_List(Staffdata_list: staffapiData);
  }
}

class StaffAPI_data {
  final String StaffName;
  final String StaffCode;
  final int StaffId;
  final int UserId;
  final String DateOfBirth;
  final String DepartmentShortName;
  final String Designation;
  final String Contact1;
  final String Contact2;
  final String StaffImg;

  StaffAPI_data({required this.StaffName, required this.StaffCode, required this.StaffId, required this.UserId
    , required this.DateOfBirth, required this.DepartmentShortName, required this.Designation, required this.Contact1
    , required this.Contact2, required this.StaffImg});

  factory StaffAPI_data.fromJson (Map<String, dynamic> Staffapi_test){
    return StaffAPI_data(
      StaffName: Staffapi_test['StaffName'], StaffCode: Staffapi_test['StaffCode'],
      StaffId: Staffapi_test['StaffId'], UserId: Staffapi_test['UserId'],
      DateOfBirth: Staffapi_test['DateOfBirth'], DepartmentShortName: Staffapi_test['DepartmentShortName'],
      Designation: Staffapi_test['Designation'], Contact1: Staffapi_test['Contact1'],
      Contact2: Staffapi_test['Contact2'], StaffImg: Staffapi_test['StaffImg'],
    );
  }
}

class StaffNetwork {
  final String url;

  StaffNetwork(this.url);

  Future <StaffData_List> StaffloadData() async {
    final response = await get(Uri.parse("http://$StaticIP/api/$url"));
    if (response.statusCode == 200) {
      return StaffData_List.fromJson(json.decode(response.body));
    }
    else {
      throw Exception("Failed to load data");
    }
  }
}

// Staff Attendance TimeTable
class StaffAttendanceTableData_List{
  final List<StaffAttendanceTableAPI_data> StaffAttendanceTabledata_list;

  StaffAttendanceTableData_List({required this.StaffAttendanceTabledata_list});

  factory StaffAttendanceTableData_List.fromJson(List<dynamic>StaffAttendanceTableAPI_Data_List){
    List <StaffAttendanceTableAPI_data> staffattendancetableapiData = <StaffAttendanceTableAPI_data>[];
    staffattendancetableapiData = StaffAttendanceTableAPI_Data_List.map((i)=> StaffAttendanceTableAPI_data.fromJson(i)).toList();
    return StaffAttendanceTableData_List(StaffAttendanceTabledata_list: staffattendancetableapiData );
  }
}

class StaffAttendanceTableAPI_data {
  final String Date;
  final String ClassName;
  final String SemPeriodName;
  final int TimeTableId;
  final int Hour;
  final String SubjectCode;
  final int Total;
  final int sem;
  final int AttedanceStatus;
  final String SubjectFullName;
  final int Absent;
  final String sbt;
  final int spnol;
  final int NotesStatus;

  StaffAttendanceTableAPI_data({required this.Date, required this.ClassName, required this.SemPeriodName, required this.TimeTableId
    , required this.Hour, required this.SubjectCode, required this.Total, required this.sem, required this.NotesStatus,
    required this.AttedanceStatus, required this.Absent, required this.sbt, required this.spnol,required this.SubjectFullName});

  factory StaffAttendanceTableAPI_data.fromJson (Map<String, dynamic> StaffAttendanceTableapi_test){
    return StaffAttendanceTableAPI_data(
        Date: StaffAttendanceTableapi_test['Date'], ClassName: StaffAttendanceTableapi_test['ClassName'],
        SemPeriodName: StaffAttendanceTableapi_test['SemPeriodName'], TimeTableId: StaffAttendanceTableapi_test['TimeTableId'],
        Hour: StaffAttendanceTableapi_test['Hour'], SubjectCode: StaffAttendanceTableapi_test['SubjectCode'],
        Total: StaffAttendanceTableapi_test['Total'], sem: StaffAttendanceTableapi_test['sem'],NotesStatus: StaffAttendanceTableapi_test['NotesStatus'],
        AttedanceStatus: StaffAttendanceTableapi_test['AttedanceStatus'], Absent: StaffAttendanceTableapi_test['Absent'],
        sbt: StaffAttendanceTableapi_test['sbt'], spnol: StaffAttendanceTableapi_test['spnol'],SubjectFullName: StaffAttendanceTableapi_test['SubjectFullName']
    );
  }
}

class StaffAttendanceTableNetwork{
  final String url;

  StaffAttendanceTableNetwork(this.url);

  Future <StaffAttendanceTableData_List> StaffAttendanceTableloadData () async {
    print("http://$StaticIP/api/$url");
    final response = await get(Uri.parse("http://$StaticIP/api/$url"));
    if (response.statusCode == 200){
      return StaffAttendanceTableData_List.fromJson(json.decode(response.body));
    }
    else{
      throw Exception("Failed to load data");
    }
  }
}

// Staff AttendanceStudents List
class StudentListData_List{
  final List<StudentListAPI_data> StudentListdata_list;

  StudentListData_List({required this.StudentListdata_list});

  factory StudentListData_List.fromJson(List<dynamic>StudentListAPI_Data_List){
    List <StudentListAPI_data> studentlistapiData = <StudentListAPI_data>[];
    studentlistapiData = StudentListAPI_Data_List.map((i)=> StudentListAPI_data.fromJson(i)).toList();
    return StudentListData_List(StudentListdata_list: studentlistapiData );
  }
}

class StudentListAPI_data {
  final String StudentName;
  final String RollNo;
  final String StudentImg;
  final String RegNumber;
  final String AttednaceStatus;
  final int StudentId;
  StudentListAPI_data({required this.StudentName, required this.RollNo, required this.StudentImg, required this.RegNumber, required this.AttednaceStatus, required this.StudentId});

  factory StudentListAPI_data.fromJson (Map<String, dynamic> StudentListapi_test){
    return StudentListAPI_data(
      StudentName: StudentListapi_test['StudentName'], RollNo: StudentListapi_test['RollNo'],
      StudentImg: StudentListapi_test['StudentImg'], RegNumber: StudentListapi_test['RegNumber'],
      AttednaceStatus: StudentListapi_test['AttednaceStatus'], StudentId: StudentListapi_test['StudentId'],
    );
  }
}

class StudentListNetwork{
  final String url;

  StudentListNetwork(this.url);

  Future <StudentListData_List> StudentListloadData () async {
    print("http://$StaticIP/api/$url");
    final response = await get(Uri.parse("http://$StaticIP/api/$url"));
    if (response.statusCode == 200){
      return StudentListData_List.fromJson(json.decode(response.body));
    }
    else{
      throw Exception("Failed to load data");
    }
  }
}

//Staff Attendance Entry
class MarkingData_List{
  final List<MarkingAPI_data> Markingdata_list;

  MarkingData_List({required this.Markingdata_list});

  factory MarkingData_List.fromJson(List<dynamic>MarkingAPI_Data_List){
    List <MarkingAPI_data> markingapiData = <MarkingAPI_data>[];
    markingapiData = MarkingAPI_Data_List.map((i)=> MarkingAPI_data.fromJson(i)).toList();
    return MarkingData_List(Markingdata_list: markingapiData );
  }
}

class MarkingAPI_data {
  final String msg;

  MarkingAPI_data({required this.msg});

  factory MarkingAPI_data.fromJson (Map<String, dynamic> Markingapi_test){
    return MarkingAPI_data(
      msg: Markingapi_test['msg'],
    );
  }
}

class MarkingNetwork{
  final String url;

  MarkingNetwork(this.url);

  Future <MarkingData_List> MarkingloadData () async {
    final response = await get(Uri.parse("http://$StaticIP/api/$url"));
    print("http://$StaticIP/api/$url");
    if (response.statusCode == 200){
      return MarkingData_List.fromJson(json.decode(response.body));
    }
    else{
      throw Exception("Failed to load data");
    }
  }
}

// Staff Timetable
class StaffTimetableData_List{
  final List<StaffTimetableAPI_data> StaffTimetabledata_list;

  StaffTimetableData_List({required this.StaffTimetabledata_list});

  factory StaffTimetableData_List.fromJson(List<dynamic>StaffTimetableAPI_Data_List){
    List <StaffTimetableAPI_data> stafftimetableapiData = <StaffTimetableAPI_data>[];
    stafftimetableapiData = StaffTimetableAPI_Data_List.map((i)=> StaffTimetableAPI_data.fromJson(i)).toList();
    return StaffTimetableData_List(StaffTimetabledata_list: stafftimetableapiData );
  }
}

class StaffTimetableAPI_data {
  final String dy;
  final String b1;
  final String b2;
  final String b3;
  final String b4;
  final String b5;
  final String b6;
  final String b7;
  final String b8;
  final String b9;
  final String b10;
  final String c1;
  final String c2;
  final String c3;
  final String c4;
  final String c5;
  final String c6;
  final String c7;
  final String c8;
  final String c9;
  final String c10;



  StaffTimetableAPI_data({required this.dy, required this.b1, required this.b2, required this.b3
    , required this.b4, required this.b5, required this.b6, required this.b7
    , required this.b8, required this.b9, required this.b10, required this.c1
    , required this.c2, required this.c3, required this.c4, required this.c5
    , required this.c6, required this.c7, required this.c8, required this.c9
    , required this.c10});

  factory StaffTimetableAPI_data.fromJson (Map<String, dynamic> Timetableapi_test){
    return StaffTimetableAPI_data(
      dy: Timetableapi_test['dy'], b1: Timetableapi_test['b1'],
      b2: Timetableapi_test['b2'], b3: Timetableapi_test['b3'],
      b4: Timetableapi_test['b4'], b5: Timetableapi_test['b5'],
      b6: Timetableapi_test['b6'], b7: Timetableapi_test['b7'],
      b8: Timetableapi_test['b8'], b9: Timetableapi_test['b9'],
      b10: Timetableapi_test['b10'], c1: Timetableapi_test['c1'],
      c2: Timetableapi_test['c2'], c3: Timetableapi_test['c3'],
      c4: Timetableapi_test['c4'], c5: Timetableapi_test['c5'],
      c6: Timetableapi_test['c6'], c7: Timetableapi_test['c7'],
      c8: Timetableapi_test['c8'], c9: Timetableapi_test['c9'],
      c10: Timetableapi_test['c10'],
    );
  }
}

class StaffTimetableNetwork{
  final String url;

  StaffTimetableNetwork(this.url);

  Future <StaffTimetableData_List> StaffTimetableloadData () async {
    final response = await get(Uri.parse("http://$StaticIP/api/$url"));
    print("http://$StaticIP/api/$url");
    if (response.statusCode == 200){
      return StaffTimetableData_List.fromJson(json.decode(response.body));
    }
    else{
      throw Exception("Failed to load data");
    }
  }
}
// Staff Holiday

class StaffHolidayData_List{
  final List<StaffHolidayAPI_data> StaffHolidaydata_list;

  StaffHolidayData_List({required this.StaffHolidaydata_list});

  factory StaffHolidayData_List.fromJson(List<dynamic>StaffHolidayAPI_Data_List){
    List <StaffHolidayAPI_data> staffholidayapiData = <StaffHolidayAPI_data>[];
    staffholidayapiData = StaffHolidayAPI_Data_List.map((i)=> StaffHolidayAPI_data.fromJson(i)).toList();
    return StaffHolidayData_List(StaffHolidaydata_list: staffholidayapiData );
  }
}

class StaffHolidayAPI_data {
  final String Date;
  final String Day;
  final String Name;
  final String Remark;

  StaffHolidayAPI_data({required this.Date, required this.Day, required this.Name, required this.Remark});

  factory StaffHolidayAPI_data.fromJson (Map<String, dynamic> StaffHolidayapi_test){
    return StaffHolidayAPI_data(
      Date: StaffHolidayapi_test['Date'], Day: StaffHolidayapi_test['Day'],
      Name: StaffHolidayapi_test['Name'], Remark: StaffHolidayapi_test['Remark'],
    );
  }
}

class StaffHolidayNetwork{
  final String url;

  StaffHolidayNetwork(this.url);

  Future <StaffHolidayData_List> StaffHolidayloadData () async {
    final response = await get(Uri.parse("http://$StaticIP/api/$url"));
    if (response.statusCode == 200){
      return StaffHolidayData_List.fromJson(json.decode(response.body));
    }
    else{
      throw Exception("Failed to load data");
    }
  }
}

// Staff Circular
class StaffCircularData_List{
  final List<StaffCircularAPI_data> StaffCirculardata_list;

  StaffCircularData_List({required this.StaffCirculardata_list});

  factory StaffCircularData_List.fromJson(List<dynamic>StaffCircularAPI_Data_List){
    List <StaffCircularAPI_data> staffcircularapiData = <StaffCircularAPI_data>[];
    staffcircularapiData = StaffCircularAPI_Data_List.map((i)=> StaffCircularAPI_data.fromJson(i)).toList();
    return StaffCircularData_List(StaffCirculardata_list: staffcircularapiData );
  }
}

class StaffCircularAPI_data {
  final String CircularDate;
  final String Discription;
  final String CreatedBy;
  final String CreatedDateTime;
  final String Remark;
  final String File;
  final String Day;


  StaffCircularAPI_data({required this.CircularDate, required this.Discription, required this.CreatedBy, required this.CreatedDateTime
    , required this.Remark, required this.File, required this.Day});

  factory StaffCircularAPI_data.fromJson (Map<String, dynamic> Circularapi_test){
    return StaffCircularAPI_data(
      CircularDate: Circularapi_test['CircularDate'],
        Discription: Circularapi_test['Discription'],
      CreatedBy: Circularapi_test['CreatedBy'],
        CreatedDateTime: Circularapi_test['CreatedDateTime'],
      Remark: Circularapi_test['Remark'],
        File: Circularapi_test['File'],
        Day: Circularapi_test['Day']
    );
  }
}

// Applvl: leave_status['Applvl'].replaceAll('<b><font color=Blue>', '')
//           .replaceAll('</font></b>', ''),

class StaffCircularNetwork{
  final String url;

  StaffCircularNetwork(this.url);

  Future <StaffCircularData_List> StaffCircularloadData () async {
    final response = await get(Uri.parse("http://$StaticIP/api/$url"));
    print("http://$StaticIP/api/$url");
    if (response.statusCode == 200){
      return StaffCircularData_List.fromJson(json.decode(response.body));
    }
    else{
      throw Exception("Failed to load data");
    }
  }
}

// Staff OPAC Library
class StaffOPACData_List{
  final List<StaffOPACAPI_data> StaffOPACdata_list;

  StaffOPACData_List({required this.StaffOPACdata_list});

  factory StaffOPACData_List.fromJson(List<dynamic>StaffOPACAPI_Data_List){
    List <StaffOPACAPI_data> staffopacapiData = <StaffOPACAPI_data>[];
    staffopacapiData = StaffOPACAPI_Data_List.map((i)=> StaffOPACAPI_data.fromJson(i)).toList();
    return StaffOPACData_List(StaffOPACdata_list: staffopacapiData );
  }
}

class StaffOPACAPI_data {
  final int LibararyId;
  final String Name;

  StaffOPACAPI_data({required this.LibararyId, required this.Name});

  factory StaffOPACAPI_data.fromJson (Map<String, dynamic> StaffOPACapi_test){
    return StaffOPACAPI_data(
      LibararyId: StaffOPACapi_test['LibararyId'], Name: StaffOPACapi_test['Name'],
    );
  }
}

class StaffOPACNetwork{
  final String url;

  StaffOPACNetwork(this.url);

  Future <StaffOPACData_List> StaffOPACloadData () async {
    final response = await get(Uri.parse("http://$StaticIP/api/$url"));
    print("http://$StaticIP/api/$url");
    if (response.statusCode == 200){
      return StaffOPACData_List.fromJson(json.decode(response.body));
    }
    else{
      throw Exception("Failed to load data");
    }
  }
}

// Staff OPAC Search
class StaffOPACSearchData_List{
  final List<StaffOPACSearchAPI_data> StaffOPACSearchdata_list;

  StaffOPACSearchData_List({required this.StaffOPACSearchdata_list});

  factory StaffOPACSearchData_List.fromJson(List<dynamic>StaffOPACSearchAPI_Data_List){
    List <StaffOPACSearchAPI_data> staffopacsearchapiData = <StaffOPACSearchAPI_data>[];
    staffopacsearchapiData = StaffOPACSearchAPI_Data_List.map((i)=> StaffOPACSearchAPI_data.fromJson(i)).toList();
    return StaffOPACSearchData_List(StaffOPACSearchdata_list: staffopacsearchapiData );
  }
}

class StaffOPACSearchAPI_data {
  final String Title;
  final String Author;
  final String AccNo;
  final String Publisher;
  final String PublisherYear;
  final String Circular;
  final String CallNo;
  final String Edition;
  final String Location;
  final String RowNo;
  final String ResourseType;
  final String Subject;
  final String Library;
  final String Department;
  final String DepartmentShortName;

  StaffOPACSearchAPI_data({required this.Title, required this.Author, required this.AccNo, required this.Publisher
    , required this.PublisherYear, required this.Circular, required this.CallNo, required this.Edition
    , required this.Location, required this.RowNo, required this.ResourseType, required this.Subject
    , required this.Library, required this.Department, required this.DepartmentShortName});

  factory StaffOPACSearchAPI_data.fromJson (Map<String, dynamic> StaffOPACSearchapi_test){
    return StaffOPACSearchAPI_data(
        Title: StaffOPACSearchapi_test['Title'], Author: StaffOPACSearchapi_test['Author'],
        AccNo: StaffOPACSearchapi_test['AccNo'], Publisher: StaffOPACSearchapi_test['Publisher'],
        PublisherYear: StaffOPACSearchapi_test['PublisherYear'], Circular: StaffOPACSearchapi_test['Circular'],
        CallNo: StaffOPACSearchapi_test['CallNo'], Edition: StaffOPACSearchapi_test['Edition'],
        Location: StaffOPACSearchapi_test['Location'], RowNo: StaffOPACSearchapi_test['RowNo'],
        ResourseType: StaffOPACSearchapi_test['ResourseType'], Subject: StaffOPACSearchapi_test['Subject'],
        Library: StaffOPACSearchapi_test['Library'], Department: StaffOPACSearchapi_test['Department'],
        DepartmentShortName: StaffOPACSearchapi_test['DepartmentShortName']
    );
  }
}

class StaffOPACSearchNetwork{
  final String url;

  StaffOPACSearchNetwork(this.url);

  Future <StaffOPACSearchData_List> StaffOPACSearchloadData () async {
    final response = await get(Uri.parse("http://$StaticIP/api/$url"));
    print("http://$StaticIP/api/$url");
    if (response.statusCode == 200){
      return StaffOPACSearchData_List.fromJson(json.decode(response.body));
    }
    else{
      throw Exception("Failed to load data");
    }
  }
}

// Library Transaction
class LibraryData_List{
  final List<LibraryAPI_data> Librarydata_list;

  LibraryData_List({required this.Librarydata_list});

  factory LibraryData_List.fromJson(List<dynamic>LibraryAPI_Data_List){
    List <LibraryAPI_data> libraryapiData = <LibraryAPI_data>[];
    libraryapiData = LibraryAPI_Data_List.map((i)=> LibraryAPI_data.fromJson(i)).toList();
    return LibraryData_List(Librarydata_list: libraryapiData );
  }
}

class LibraryAPI_data {
  final String LibraryName;
  final String MatrialType;
  final String Title;
  final String Author;
  final String IssueDate;
  final String DueDate;
  final String OverDueDays;
  final String OverDueAmount;
  final String ReturnDate;
  final String Remark;
  final String OverDue;
  final String Subject;
  final String Paid;
  final String Balance;
  final String TransactionType;

  LibraryAPI_data({required this.LibraryName, required this.MatrialType, required this.Title, required this.Author
    , required this.IssueDate, required this.DueDate, required this.OverDueDays, required this.OverDueAmount
    , required this.ReturnDate, required this.Remark, required this.OverDue, required this.Subject
    , required this.Paid, required this.Balance, required this.TransactionType});

  factory LibraryAPI_data.fromJson (Map<String, dynamic> StaffOPACSearchapi_test){
    return LibraryAPI_data(
        LibraryName: StaffOPACSearchapi_test['LibraryName'].toString(), MatrialType: StaffOPACSearchapi_test['MatrialType'].toString(),
        Title: StaffOPACSearchapi_test['Title'].toString(), Author: StaffOPACSearchapi_test['Author'].toString(),
        IssueDate: StaffOPACSearchapi_test['IssueDate'].toString(), DueDate: StaffOPACSearchapi_test['DueDate'].toString(),
        OverDueDays: StaffOPACSearchapi_test['OverDueDays'].toString(), OverDueAmount: StaffOPACSearchapi_test['OverDueAmount'].toString(),
        ReturnDate: StaffOPACSearchapi_test['ReturnDate'].toString(), Remark: StaffOPACSearchapi_test['Remark'].toString(),
        OverDue: StaffOPACSearchapi_test['OverDue'].toString(), Subject: StaffOPACSearchapi_test['Subject'].toString(),
        Paid: StaffOPACSearchapi_test['Paid'].toString(), Balance: StaffOPACSearchapi_test['Balance'].toString(),
        TransactionType: StaffOPACSearchapi_test['TransactionType'].toString()
    );
  }
}

class LibraryNetwork{
  final String url;

  LibraryNetwork(this.url);

  Future <LibraryData_List> LibraryloadData () async {
    final response = await get(Uri.parse("http://$StaticIP/api/$url"));
    print("http://$StaticIP/api/$url");
    if (response.statusCode == 200){
      return LibraryData_List.fromJson(json.decode(response.body));
    }
    else{
      throw Exception("Failed to load data");
    }
  }
}

// Staff Attendance record
class StaffAttendanceRecordData_List{
  final List<StaffAttendanceRecordAPI_data> StaffAttendanceRecorddata_list;

  StaffAttendanceRecordData_List({required this.StaffAttendanceRecorddata_list});

  factory StaffAttendanceRecordData_List.fromJson(List<dynamic>StaffAttendanceRecordAPI_Data_List){
    List <StaffAttendanceRecordAPI_data> staffattendancerecordapiData = <StaffAttendanceRecordAPI_data>[];
    staffattendancerecordapiData = StaffAttendanceRecordAPI_Data_List.map((i)=> StaffAttendanceRecordAPI_data.fromJson(i)).toList();
    return StaffAttendanceRecordData_List(StaffAttendanceRecorddata_list: staffattendancerecordapiData );
  }
}

class StaffAttendanceRecordAPI_data {
  final String Date;
  final String WeekDay;
  final String FN;
  final String AN;
  final String Time;

  StaffAttendanceRecordAPI_data({required this.Date, required this.WeekDay, required this.FN, required this.AN, required this.Time});

  factory StaffAttendanceRecordAPI_data.fromJson (Map<String, dynamic> StaffAttendanceRecordapi_test){
    return StaffAttendanceRecordAPI_data(
      Date: StaffAttendanceRecordapi_test['Date'], WeekDay: StaffAttendanceRecordapi_test['WeekDay'],
      FN: StaffAttendanceRecordapi_test['FN'].toString(), AN: StaffAttendanceRecordapi_test['AN'].toString(),
      Time: StaffAttendanceRecordapi_test['Time'],
    );
  }
}

class StaffAttendanceRecordNetwork{
  final String url;

  StaffAttendanceRecordNetwork(this.url);

  Future <StaffAttendanceRecordData_List> StaffAttendanceRecordloadData () async {
    final response = await get(Uri.parse("http://$StaticIP/api/$url"));
    if (response.statusCode == 200){
      return StaffAttendanceRecordData_List.fromJson(json.decode(response.body));
    }
    else{
      throw Exception("Failed to load data");
    }
  }
}

// Staff Leave Balance
class LeaveBalanceData_List{
  final List<LeaveBalanceAPI_data> LeaveBalancedata_list;

  LeaveBalanceData_List({required this.LeaveBalancedata_list});

  factory LeaveBalanceData_List.fromJson(List<dynamic>LeaveBalanceAPI_Data_List){
    List <LeaveBalanceAPI_data> leavebalanceapiData = <LeaveBalanceAPI_data>[];
    leavebalanceapiData = LeaveBalanceAPI_Data_List.map((i)=> LeaveBalanceAPI_data.fromJson(i)).toList();
    return LeaveBalanceData_List(LeaveBalancedata_list: leavebalanceapiData );
  }
}

class LeaveBalanceAPI_data {
  final String ShortName;
  final double Balance;
  final int Eligible;
  final int Typeid;
  final String MonthName;
  final String YearName;
  final String LeaveName;
  final double day;
  final double month;
  final double year;
  final String acadYear;


  LeaveBalanceAPI_data({required this.ShortName, required this.Balance, required this.Eligible, required this.MonthName
    , required this.YearName, required this.LeaveName,
    required this.day,
    required this.month,
    required this.Typeid,
    required this.year, required this.acadYear,
  });

  factory LeaveBalanceAPI_data.fromJson (Map<String, dynamic> LeaveBalanceapi_test){
    return LeaveBalanceAPI_data(
      ShortName: LeaveBalanceapi_test['ShortName'], Balance: LeaveBalanceapi_test['Balance'],
      Eligible: LeaveBalanceapi_test['Eligible'], MonthName: LeaveBalanceapi_test['MonthName'],
      YearName: LeaveBalanceapi_test['YearName'], LeaveName: LeaveBalanceapi_test['LeaveName'],
      day: LeaveBalanceapi_test['Day'],
      month: LeaveBalanceapi_test["Month"],
      year: LeaveBalanceapi_test["Year"],
      Typeid: LeaveBalanceapi_test["Typeid"],
      acadYear: LeaveBalanceapi_test['AcadYear'],
    );
  }
}

class LeaveBalanceNetwork{
  final String url;

  LeaveBalanceNetwork(this.url);

  Future <LeaveBalanceData_List> LeaveBalanceloadData () async {
    print("http://$StaticIP/api/$url");
    final response = await get(Uri.parse("http://$StaticIP/api/$url"));
    if (response.statusCode == 200){
      return LeaveBalanceData_List.fromJson(json.decode(response.body));
    }
    else{
      throw Exception("Failed to load data");
    }
  }
}

//Staff StaffAlternateHourRequest

class StaffAlternateHourRequest_List{
  final List<StaffAlternateHourRequestAPI_data> StaffAlternateHourrequest_List;

  StaffAlternateHourRequest_List({required this.StaffAlternateHourrequest_List});

  factory StaffAlternateHourRequest_List.fromJson(List<dynamic>StaffAlternateHourRequest_data_List){
    List <StaffAlternateHourRequestAPI_data> staffalternatehourrequestapiData = <StaffAlternateHourRequestAPI_data>[];
    staffalternatehourrequestapiData = StaffAlternateHourRequest_data_List.map((i)=> StaffAlternateHourRequestAPI_data.fromJson(i)).toList();
    return StaffAlternateHourRequest_List(StaffAlternateHourrequest_List: staffalternatehourrequestapiData );
  }
}

class StaffAlternateHourRequestAPI_data {
  final int fId;
  final int id;
  final int cslid;
  final int sid;
  final int sbid;
  final String sbc;
  final String sbn;
  final String s;
  final String sn1;
  final String sn;
  final String semester;
  final int hourid;
  final int hour;
  final String hourtxt;
  final String date;
  final int st;
  final int alt;
  final int st1;


  StaffAlternateHourRequestAPI_data({required this.alt,required this.cslid,required this.date,required this.fId,required this.hour,required this.hourid,
    required this.hourtxt,required this.id,required this.s,required this.sbc,required this.sbid,
    required this.sbn,required this.semester,required this.sid,required this.sn,required this.st1,required this.st,required this.sn1,
  });

  factory StaffAlternateHourRequestAPI_data.fromJson (Map<String, dynamic> StaffAlternateHourRequest_test){
    return StaffAlternateHourRequestAPI_data(
      alt: StaffAlternateHourRequest_test['alt'], cslid: StaffAlternateHourRequest_test['cslid'],
      date: StaffAlternateHourRequest_test['date'], fId: StaffAlternateHourRequest_test['fId'],
      hour: StaffAlternateHourRequest_test['hour'], hourid: StaffAlternateHourRequest_test['hourid'],
      hourtxt: StaffAlternateHourRequest_test['hourtxt'],
      id: StaffAlternateHourRequest_test["id"],
      s: StaffAlternateHourRequest_test["s"],
      sbc: StaffAlternateHourRequest_test['sbc'],
      sbid: StaffAlternateHourRequest_test['sbid'],
      sbn: StaffAlternateHourRequest_test['sbn'],
      semester: StaffAlternateHourRequest_test['semester'],
      sid: StaffAlternateHourRequest_test['sid'],
      sn: StaffAlternateHourRequest_test['sn'],
      st1: StaffAlternateHourRequest_test['st1'],
      st: StaffAlternateHourRequest_test['st'],
      sn1: StaffAlternateHourRequest_test['sn1'],
    );
  }
}

class StaffAlternateHourRequestNetwork{
  final String url;

  StaffAlternateHourRequestNetwork(this.url);

  Future <StaffAlternateHourRequest_List> StaffAlternateHourRequestloadData () async {
    final response = await get(Uri.parse("http://$StaticIP/api/$url"));
    print("http://$StaticIP/api/$url");
    if (response.statusCode == 200){
      return StaffAlternateHourRequest_List.fromJson(json.decode(response.body));
    }
    else{
      throw Exception("Failed to load data");
    }
  }
}


// Staff Proforma

class StaffProformaData_List{
  final List<StaffProformaAPI_data> StaffProformadata_list;

  StaffProformaData_List({required this.StaffProformadata_list});

  factory StaffProformaData_List.fromJson(List<dynamic>StaffProformaAPI_Data_List){
    List <StaffProformaAPI_data> staffproformaapiData = <StaffProformaAPI_data>[];
    staffproformaapiData = StaffProformaAPI_Data_List.map((i)=> StaffProformaAPI_data.fromJson(i)).toList();
    return StaffProformaData_List(StaffProformadata_list: staffproformaapiData );
  }
}

class StaffProformaAPI_data {
  final String GroupName;
  final String Name;

  StaffProformaAPI_data({required this.GroupName, required this.Name});

  factory StaffProformaAPI_data.fromJson (Map<String, dynamic> StaffProformaapi_test){
    return StaffProformaAPI_data(
      GroupName: StaffProformaapi_test['GroupName'], Name: StaffProformaapi_test['Name'],
    );
  }
}

class StaffProformaNetwork{
  final String url;

  StaffProformaNetwork(this.url);

  Future <StaffProformaData_List> StaffProformaloadData () async {
    final response = await get(Uri.parse("http://$StaticIP/api/$url"));
    print("http://$StaticIP/api/$url");
    if (response.statusCode == 200){
      return StaffProformaData_List.fromJson(json.decode(response.body));
    }
    else{
      throw Exception("Failed to load data");
    }
  }
}

// Lesson Plan Theory

class LessonPlanTheoryData_List{
  final List<LessonPlanTheoryAPI_data> LessonPlanTheorydata_list;

  LessonPlanTheoryData_List({required this.LessonPlanTheorydata_list});

  factory LessonPlanTheoryData_List.fromJson(List<dynamic>LessonPlanTheoryAPI_Data_List){
    List <LessonPlanTheoryAPI_data> lessonplantheoryapiData = <LessonPlanTheoryAPI_data>[];
    lessonplantheoryapiData = LessonPlanTheoryAPI_Data_List.map((i)=> LessonPlanTheoryAPI_data.fromJson(i)).toList();
    return LessonPlanTheoryData_List(LessonPlanTheorydata_list: lessonplantheoryapiData);
  }
}

class LessonPlanTheoryAPI_data {
  final String Notes;
  final int IsCompleted;
  final int id;
  final String ExpNo;
  final String dt;
  final String wk;

  LessonPlanTheoryAPI_data({required this.wk, required this.dt, required this.Notes, required this.IsCompleted, required this.id, required this.ExpNo});

  factory LessonPlanTheoryAPI_data.fromJson (Map<String, dynamic> LessonPlanTheoryapi_test){
    return LessonPlanTheoryAPI_data(
      dt: LessonPlanTheoryapi_test['dt'],
      wk: LessonPlanTheoryapi_test['wk'],
      Notes: LessonPlanTheoryapi_test['Notes'], IsCompleted: LessonPlanTheoryapi_test['IsCompleted'],
      id: LessonPlanTheoryapi_test['id'], ExpNo: LessonPlanTheoryapi_test['ExpNo'],
    );
  }
}

class LessonPlanTheoryNetwork{
  final String url;
  LessonPlanTheoryNetwork(this.url);

  Future <LessonPlanTheoryData_List> LessonPlanTheoryloadData () async {
    print('http://$StaticIP/api/$url');
    final response = await get(Uri.parse("http://$StaticIP/api/$url"));
    if (response.statusCode == 200){
      return LessonPlanTheoryData_List.fromJson(json.decode(response.body));
    }
    else{
      throw Exception("Failed to load data");
    }
  }
}

//Lesson Plan Practical

class LessonPlanPracticalData_List{
  final List<LessonPlanPracticalAPI_data> LessonPlanPracticaldata_list;

  LessonPlanPracticalData_List({required this.LessonPlanPracticaldata_list});

  factory LessonPlanPracticalData_List.fromJson(List<dynamic>LessonPlanPracticalAPI_Data_List){
    List <LessonPlanPracticalAPI_data> lessonplanpracticalapiData = <LessonPlanPracticalAPI_data>[];
    lessonplanpracticalapiData = LessonPlanPracticalAPI_Data_List.map((i)=> LessonPlanPracticalAPI_data.fromJson(i)).toList();
    return LessonPlanPracticalData_List(LessonPlanPracticaldata_list: lessonplanpracticalapiData );
  }
}

class LessonPlanPracticalAPI_data {
  final String ic;
  final int id;
  final String exp;
  final String sig;
  final String fn;

  LessonPlanPracticalAPI_data({required this.ic, required this.id, required this.exp, required this.sig, required this.fn});

  factory LessonPlanPracticalAPI_data.fromJson (Map<String, dynamic> LessonPlanPracticalapi_test){
    return LessonPlanPracticalAPI_data(
      ic: LessonPlanPracticalapi_test['ic'], id: LessonPlanPracticalapi_test['id'],
      exp: LessonPlanPracticalapi_test['exp'], sig: LessonPlanPracticalapi_test['sig'],
      fn: LessonPlanPracticalapi_test['fn'],
    );
  }
}

class LessonPlanPracticalNetwork{
  final String url;
  LessonPlanPracticalNetwork(this.url);

  Future <LessonPlanPracticalData_List> LessonPlanPracticalloadData () async {
    print('http://$StaticIP/api/$url');
    final response = await get(Uri.parse("http://$StaticIP/api/$url"));
    if (response.statusCode == 200){
      return LessonPlanPracticalData_List.fromJson(json.decode(response.body));
    }
    else{
      throw Exception("Failed to load data");
    }
  }
}

// Module Display

class ModuleData_List{
  final List<ModuleAPI_data> Moduledata_list;

  ModuleData_List({required this.Moduledata_list});

  factory ModuleData_List.fromJson(List<dynamic>ModuleAPI_Data_List){
    List <ModuleAPI_data> moduleapiData = <ModuleAPI_data>[];
    moduleapiData = ModuleAPI_Data_List.map((i)=> ModuleAPI_data.fromJson(i)).toList();
    return ModuleData_List(Moduledata_list: moduleapiData );
  }
}

class ModuleAPI_data {
  final String MenuName;
  final String Status;

  ModuleAPI_data({required this.MenuName, required this.Status});

  factory ModuleAPI_data.fromJson (Map<String, dynamic> Moduleapi_test){
    return ModuleAPI_data(
      MenuName: Moduleapi_test['MenuName'], Status: Moduleapi_test['Status'],
    );
  }
}

class ModuleNetwork{
  final String url;

  ModuleNetwork(this.url);

  Future <ModuleData_List> ModuleloadData () async {
    // final response = await get(Uri.parse("http://3.108.194.101/impapi/api/$url"));
    final response = await get(Uri.parse("http://$StaticIP/api/$url"));
    if (response.statusCode == 200){
      return ModuleData_List.fromJson(json.decode(response.body));
    }
    else{
      throw Exception("Failed to load data");
    }
  }
}

//Widget Creation Format
/*
FutureBuilder(
future: APIData,
builder: (context, AsyncSnapshot<Data_List> snapshot){
List <API_data> data;
if(snapshot.hasData){
data = snapshot.data!.data_list;
if (data.length > 0){
return Container();
}
else{
return Center(child: Text("!\nNo Data Found", style: PrimaryText2Big(),textAlign: TextAlign.center,));
}
}
else{
return Container(child: Center(child: CircularProgressIndicator()), color: Colors.white,);
}
});

    Network network = Network("http://121.200.54.218:89/api/billing?RollNum=${widget.username.toLowerCase()}");
    APIData = network.loadData();

      late Future <Data_List> APIData;

class Data_List{
  final List<API_data> data_list;

  Data_List({required this.data_list});

  factory Data_List.fromJson(List<dynamic>API_Data_List){
    List <API_data> api_data = <API_data>[];
    api_data = API_Data_List.map((i)=> API_data.fromJson(i)).toList();
    return new Data_List(data_list: api_data );
  }
}

class API_data {
  final String StudentName;
  final String RollNum;

  API_data({required this.StudentName, required this.RollNum});

  factory API_data.fromJson (Map<String, dynamic> api_test){
    return API_data(
      StudentName: api_test['StudentName'], RollNum: api_test['RollNum'],
    );
  }
}

class Network{
  final String url;

  Network(this.url);

  Future <Data_List> loadData () async {
    final response = await get(Uri.parse("http://$StaticIP/api/$url"));
    if (response.statusCode == 200){
      return Data_List.fromJson(json.decode(response.body));
    }
    else{
      throw Exception("Failed to load data");
    }
  }
}*/

// For Testing data Input
Future TestGetData() async{
  var data;
  String url = "http://121.200.54.218:89/api/StaffHours?StaffId=8&ShowPrevDays=0";
  TestNetwork network = TestNetwork(url);
  data = network.TestFetchData();
  data.then((value){
    print (value[0]['Date']);
  });
  return data;
}

class TestNetwork{
  final String url;

  TestNetwork(this.url);

  Future TestFetchData() async {
    Response response = await get(Uri.parse(url));
    if (response.statusCode == 200)
    {
      return json.decode(response.body);
    }
    else
      throw Exception("Failed to load data");
  }
}

class StaffLoginCheck extends StatefulWidget {
  const StaffLoginCheck({Key? key,}) : super(key: key);

  @override
  _StaffLoginCheckState createState() => _StaffLoginCheckState();
}

class _StaffLoginCheckState extends State<StaffLoginCheck> {
  late Future <StudentListData_List> APIData;
  late Future testData;
  late int i = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    testData = TestGetData();
    StudentListNetwork network = StudentListNetwork("StudentAttendance?FinalTimetableId=17162");
    APIData = network.StudentListloadData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            child: Container(
              child: Icon(Icons.arrow_back, color: LineColor1(),),
            ),
            onTap: ()=> Navigator.pop(context)
        ),
      ),
      body: FutureBuilder(
          future: APIData,
          builder: (context, AsyncSnapshot<StudentListData_List> snapshot){
            List <StudentListAPI_data> data;
            if(snapshot.hasData){
              data = snapshot.data!.StudentListdata_list;
              if (data.length > 0){
                return Builder(
                    builder: (BuildContext context) => ListView(
                      scrollDirection: Axis.vertical,
                      children: <Widget>[
                        for (int a = 0; a <= data.length-1; a++)
                          StudentProfileContainer("Name : ${data[a].StudentName}", "RollNo : ${data[a].RollNo}", context),
                        StudentProfileContainer("RegNo :", data[i].RegNumber, context),
                        StudentProfileContainer("RollNo :", data[i].RollNo, context),
                        // StudentProfileContainer("TimeTable ID:", data[i].TimeTableId.toString(), context),
                      ],
                    ));
              }
              else{
                return Center(child: Text("!\nNo Data Found", style: ErrorText2Big(),textAlign: TextAlign.center,));
              }
            }
            else{
              return Center(child: CircularProgressIndicator());

            }
          }),
    );
  }
}

//Staff's HOD Data Find API

class FindHodData {

  final int staffId;
  final String staffName;

  FindHodData({
    required this.staffId,
    required this.staffName,
  });

  factory FindHodData.fromJson (Map<String, dynamic> Find_HOD){
    return FindHodData(
      staffId: Find_HOD["staff_id"],
      staffName: Find_HOD["staff_name"],
    );
  }
}

class FindHodDataList {
  final List<FindHodData> HOD_list;

  FindHodDataList({required this.HOD_list});

  factory FindHodDataList.fromJson(List<dynamic> HOData_List) {
    List<FindHodData> hodReportdata = <FindHodData>[];
    hodReportdata = HOData_List.map((i) => FindHodData.fromJson(i)).toList();
    return FindHodDataList(HOD_list: hodReportdata);
  }
}

class Hod_Find_Network{

  final String url;

  Hod_Find_Network(this.url);

  Future <FindHodDataList> HODloadData () async {
    print("http://$StaticIP/api/$url");
    final response = await get(Uri.parse("http://$StaticIP/api/$url"));
    if (response.statusCode == 200){
      return FindHodDataList.fromJson(json.decode(response.body));
    }
    else{
      throw Exception("Failed to Internal server Error");
    }
  }
}

//staff Alter Hours Other Staffs Listed data_API
class Staff_Alter_Hours_Data {
  final int id;
  final String semname;
  final int classid;
  final String classfullname;
  final String classshortname;
  final int dateid;
  final String date;
  final int hourid;
  final int hour;
  final String session;
  final String subjectplan;
  final int isaltar;
  final int said;
  final int altid;
  final int rqst;

  Staff_Alter_Hours_Data({
    required this.id,
    required this.semname,
    required this.classid,
    required this.classfullname,
    required this.classshortname,
    required this.dateid,
    required this.date,
    required this.hourid,
    required this.hour,
    required this.session,
    required this.subjectplan,
    required this.isaltar,
    required this.said,
    required this.altid,
    required this.rqst,
  });

  factory Staff_Alter_Hours_Data.fromJson (Map<String, dynamic> Find_Hours_List_Data){
    return Staff_Alter_Hours_Data(
      id: Find_Hours_List_Data["Id"],
      semname: Find_Hours_List_Data["semname"],
      classid: Find_Hours_List_Data["classid"],
      classfullname: Find_Hours_List_Data["classfullname"],
      classshortname: Find_Hours_List_Data["classshortname"],
      dateid: Find_Hours_List_Data["dateid"],
      date: Find_Hours_List_Data["date"],
      hourid: Find_Hours_List_Data["hourid"],
      hour: Find_Hours_List_Data["hour"],
      session: Find_Hours_List_Data["session"],
      subjectplan: Find_Hours_List_Data["subjectplan"],
      isaltar: Find_Hours_List_Data["isaltar"],
      said: Find_Hours_List_Data["said"],
      altid: Find_Hours_List_Data["altid"],
      rqst: Find_Hours_List_Data["rqst"],
    );
  }
}

class Staff_Alter_Hours_Data_List {
  final List<Staff_Alter_Hours_Data> S_A_H_list;

  Staff_Alter_Hours_Data_List({required this.S_A_H_list});

  factory Staff_Alter_Hours_Data_List.fromJson(List<dynamic> Find_Hours_List) {
    List<Staff_Alter_Hours_Data> staffHaList = <Staff_Alter_Hours_Data>[];
    staffHaList = Find_Hours_List.map((i) => Staff_Alter_Hours_Data.fromJson(i)).toList();
    return Staff_Alter_Hours_Data_List(S_A_H_list: staffHaList);
  }
}

class Staff_Alter_Hours_Network{
  final String url;

  Staff_Alter_Hours_Network(this.url);

  Future <Staff_Alter_Hours_Data_List> Staff_Alter_Hours_loadData () async {
    final response = await get(Uri.parse("http://$StaticIP/api/$url"));
    print("http://$StaticIP/api/$url");
    if (response.statusCode == 200){
      return Staff_Alter_Hours_Data_List.fromJson(json.decode(response.body));
    }
    else{
      throw Exception("Failed to Internal server Error");
    }
  }
}

//Department List_API
class Department_List_Data {
  final int deptId;
  final String dept;
  final int ftxt;
  Department_List_Data({
    required this.deptId,
    required this.dept,
    required this.ftxt,
  });

  factory Department_List_Data.fromJson (Map<String, dynamic> Dept_List_Data){
    return Department_List_Data(
      deptId: Dept_List_Data["dept_id"],
      dept: Dept_List_Data["dept"],
      ftxt: Dept_List_Data["ftxt"],
    );
  }
}

class Department_List_Data_List {
  final List<Department_List_Data> Leave_dept_list;

  Department_List_Data_List({required this.Leave_dept_list});

  factory Department_List_Data_List.fromJson(List<dynamic> Find_Dept_List) {
    List<Department_List_Data> leaveDepList = <Department_List_Data>[];
    leaveDepList = Find_Dept_List.map((i) =>Department_List_Data.fromJson(i)).toList();
    return Department_List_Data_List(Leave_dept_list: leaveDepList);
  }
}

class Department_Network{
  final String url;

  Department_Network(this.url);

  Future <Department_List_Data_List> Department_loadData () async {
    print("http://$StaticIP/api/$url");
    final response = await get(Uri.parse("http://$StaticIP/api/$url"));
    if (response.statusCode == 200){
      return Department_List_Data_List.fromJson(json.decode(response.body));
    }
    else{
      throw Exception("Failed to Internal server Error");
    }
  }
}

//All Staff list_API
class Staff_List_Data {
  final int id;
  final String staffcode;
  final String staffname;
  final String gender;
  final int uid;
  Staff_List_Data({
    required this.id,
    required this.staffcode,
    required this.staffname,
    required this.gender,
    required this.uid,
  });

  factory Staff_List_Data.fromJson (Map<String, dynamic> ALL_S_List_Data_json){
    return Staff_List_Data(
      id: ALL_S_List_Data_json["id"],
      staffcode: ALL_S_List_Data_json["staffcode"],
      staffname: ALL_S_List_Data_json["staffname"],
      gender: ALL_S_List_Data_json["gender"],
      uid: ALL_S_List_Data_json["uid"],
    );
  }
}

class Staff_List_Data_List {
  final List<Staff_List_Data> Leave_Sta_list;

  Staff_List_Data_List({required this.Leave_Sta_list});

  factory Staff_List_Data_List.fromJson(List<dynamic> Find_Staff_List) {
    List<Staff_List_Data> leaveStaffList = <Staff_List_Data>[];
    leaveStaffList = Find_Staff_List.map((i) =>Staff_List_Data.fromJson(i)).toList();
    return Staff_List_Data_List(Leave_Sta_list: leaveStaffList);
  }
}

class All_Staff_Network{
  final String url;

  All_Staff_Network(this.url);

  Future <Staff_List_Data_List> Staffss_loadData () async {
    final response = await get(Uri.parse("http://$StaticIP/api/$url"));
    print("http://$StaticIP/api/$url");
    if (response.statusCode == 200){
      return Staff_List_Data_List.fromJson(json.decode(response.body));
    }
    else{
      throw Exception("Staffs List Failed to Internal server Error");
    }
  }
}

//Staff Reqest inbox API Data

class Staff_Inbox_Data {
  final int id;
  final int clsid;
  final int timeid;
  final String clname;
  final String subjectCode;
  final String subjectName;
  final String actualHr;
  final String requestHr;
  final int sem;
  final String date;
  final String sendDate;
  final String reqFrom;
  final int stCode;
  final String status;
  Staff_Inbox_Data({
    required this.id,
    required this.clsid,
    required this.clname,
    required this.timeid,
    required this.subjectCode,
    required this.subjectName,
    required this.actualHr,
    required this.requestHr,
    required this.sem,
    required this.date,
    required this.sendDate,
    required this.reqFrom,
    required this.stCode,
    required this.status,
  });

  factory Staff_Inbox_Data.fromJson (Map<String, dynamic> Inbox_Json){
    return Staff_Inbox_Data(
      id: Inbox_Json["id"],
      clsid: Inbox_Json["clsid"],
      timeid: Inbox_Json["timeid"],
      clname: Inbox_Json["clname"],
      subjectCode: Inbox_Json["subject_code"],
      subjectName: Inbox_Json["subject_name"],
      actualHr: Inbox_Json["Actual_Hr"],
      requestHr: Inbox_Json["Request_Hr"],
      sem: Inbox_Json["sem"],
      date: Inbox_Json["date"],
      sendDate: Inbox_Json["send_Date"],
      reqFrom: Inbox_Json["req_from"],
      stCode: Inbox_Json["st_code"],
      status: Inbox_Json["status"],
    );
  }
}

class Staff_Inbox_Data_List {
  final List<Staff_Inbox_Data> Inbox_Sta_list;

  Staff_Inbox_Data_List({required this.Inbox_Sta_list});

  factory Staff_Inbox_Data_List.fromJson(List<dynamic> INBXS_List) {
    List<Staff_Inbox_Data> inbStaffList = <Staff_Inbox_Data>[];
    inbStaffList = INBXS_List.map((i) =>Staff_Inbox_Data.fromJson(i)).toList();
    return Staff_Inbox_Data_List(Inbox_Sta_list: inbStaffList);
  }
}

class Staffs_Inbox_Network{
  final String url;

  Staffs_Inbox_Network(this.url);

  Future <Staff_Inbox_Data_List> Inbox_loadData () async {
    print("http://$StaticIP/api/$url");
    final response = await get(Uri.parse("http://$StaticIP/api/$url"));
    if (response.statusCode == 200){
      return Staff_Inbox_Data_List.fromJson(json.decode(response.body));
    }
    else{
      throw Exception("Staffs Inbox List Internal server Error");
    }
  }
}

//Staff LessonFind Data API
class Staff_Inbox_Lesson_Data {
  final int id;
  final String lesson;
  Staff_Inbox_Lesson_Data({
    required this.id,
    required this.lesson,
  });

  factory Staff_Inbox_Lesson_Data.fromJson (Map<String, dynamic> Inbox_Lsn_Json){
    return Staff_Inbox_Lesson_Data(
      id: Inbox_Lsn_Json["Id"],
      lesson: Inbox_Lsn_Json["Lesson"],
    );
  }
}

class Staff_Inbox_Lesson_Data_List {
  final List<Staff_Inbox_Lesson_Data> Inbox_Leson_list;

  Staff_Inbox_Lesson_Data_List({required this.Inbox_Leson_list});

  factory Staff_Inbox_Lesson_Data_List.fromJson(List<dynamic> INB_LES_List) {
    List<Staff_Inbox_Lesson_Data> inbLesList = <Staff_Inbox_Lesson_Data>[];
    inbLesList = INB_LES_List.map((i) =>Staff_Inbox_Lesson_Data.fromJson(i)).toList();
    return Staff_Inbox_Lesson_Data_List(Inbox_Leson_list: inbLesList);
  }
}

class Staff_Inbox_Lesson_Network{
  final String url;

  Staff_Inbox_Lesson_Network(this.url);

  Future <Staff_Inbox_Lesson_Data_List> Inbox_Lesson_loadData () async {
    final response = await get(Uri.parse("http://$StaticIP/api/$url"));
    print("http://$StaticIP/api/$url");
    if (response.statusCode == 200){
      return Staff_Inbox_Lesson_Data_List.fromJson(json.decode(response.body));
    }
    else{
      throw Exception("Staffs Inbox Lesson Find server Error");
    }
  }
}

//FacultyorHOD
class FacultyorHod_List{
  final List<FacultyorHod_Data> Staff_List;

  FacultyorHod_List({required this.Staff_List});

  factory FacultyorHod_List.fromJson(List<dynamic> Faculty_List){
    List<FacultyorHod_Data> facultyList = <FacultyorHod_Data>[];
    facultyList = Faculty_List.map((i) =>FacultyorHod_Data.fromJson(i)).toList();
    return FacultyorHod_List(Staff_List: facultyList);
  }
}

class FacultyorHod_Data{
  final int abm;
  final int lawah;
  final String P;
  final int t;
  final int isadm;
  FacultyorHod_Data({required this.abm,required this.isadm, required this.lawah, required this.P, required this.t});
  factory FacultyorHod_Data.fromJson (Map<String, dynamic> FacultyHod){
    return FacultyorHod_Data(
      isadm: FacultyHod["isadm"],
      lawah: FacultyHod["lawah"],
      abm: FacultyHod["abm"],
      P: FacultyHod["P"],
      t: FacultyHod["t"],
    );
  }
}

class Faculty_Network{
  final String url;
  Faculty_Network(this.url);
  Future<FacultyorHod_List> Faculty_Data () async{
    final response = await get(Uri.parse(("http://$StaticIP/api/$url")));
    if(response.statusCode == 200){
      return FacultyorHod_List.fromJson(json.decode(response.body));
    }
    else{
      throw Exception("Staffs Inbox List Internal server Error");
    }
  }
}

//Club Function
class Club_Fun_Data {
  final int id;
  final int uid;
  final String s;
  final String IsSDPPn;
  final String txt;
  Club_Fun_Data({
    required this.id,required this.uid,required this.s, required this.IsSDPPn, required this.txt
  });
  factory Club_Fun_Data.fromJson (Map<String, dynamic> Club_Json){
    return Club_Fun_Data(
      id: Club_Json["id"],
      uid: Club_Json["uid"],
      s: Club_Json["s"],
      IsSDPPn: Club_Json["IsSDPPn"],
      txt: Club_Json["txt"],
    );
  }
}

class Club_Fun_Data_List {
  final List<Club_Fun_Data> Club_fu_list;
  Club_Fun_Data_List({required this.Club_fu_list});
  factory Club_Fun_Data_List.fromJson(List<dynamic> Fun_List) {
    List<Club_Fun_Data> clubFunList = <Club_Fun_Data>[];
    clubFunList = Fun_List.map((i) =>Club_Fun_Data.fromJson(i)).toList();
    return Club_Fun_Data_List(Club_fu_list: clubFunList);
  }
}

class Club_Fun_Network{
  final String url;
  Club_Fun_Network(this.url);
  Future <Club_Fun_Data_List> Fun_club_Data () async {
    final response = await get(Uri.parse("http://$StaticIP/api/$url"));
    print("http://$StaticIP/api/$url");
    if (response.statusCode == 200){
      return Club_Fun_Data_List.fromJson(json.decode(response.body));
    }
    else{
      throw Exception("Staffs Inbox List Internal server Error");
    }
  }
}

//Leave Status
class Leave_Status_Data {
  final String Reason;
  final String LeaveApplied;
  final double Days;
  final String Date;
  final String Forword;
  final int LeaveId;
  final String Forword2;
  final String Approved;
  final String Status;
  final String Applvl;
  Leave_Status_Data({
    required this.Applvl,
    required this.Approved,
    required this.Date,
    required this.Days,
    required this.LeaveId,
    required this.Forword,
    required this.Forword2,
    required this.LeaveApplied,
    required this.Reason,
    required this.Status,
  });
  factory Leave_Status_Data.fromJson(Map<String, dynamic> leave_status) {
    return Leave_Status_Data(
      Applvl: leave_status['Applvl'].replaceAll('<b><font color=Blue>', '')
          .replaceAll('</font></b>', ''),
      Approved: leave_status['Approved'],
      Date: leave_status['Date'],
      Days: leave_status['Days'],
      LeaveId: leave_status['LeaveId'],
      Forword: leave_status['Forword'],
      Forword2: leave_status['Forword2'],
      LeaveApplied: leave_status['LeaveApplied'],
      Reason: leave_status['Reason'],
      Status: leave_status['Status'],
    );
  }
}

class Leave_Status_List {
  final List<Leave_Status_Data> Leave_sts_List;
  Leave_Status_List({required this.Leave_sts_List});
  factory Leave_Status_List.fromJson(List<dynamic> leavest_list) {
    List<Leave_Status_Data> leaveStsList = <Leave_Status_Data>[];
    leaveStsList = leavest_list.map((i) => Leave_Status_Data.fromJson(i)).toList();
    return Leave_Status_List(Leave_sts_List: leaveStsList);
  }
}

class Leave_Status_Network {
  final String url;
  Leave_Status_Network(this.url);
  Future<Leave_Status_List> Leave_st_data() async {
    final response = await get(Uri.parse("http://$StaticIP/api/$url"));
    print("http://$StaticIP/api/$url");
    if (response.statusCode == 200) {
      return Leave_Status_List.fromJson(json.decode(response.body));
    } else {
      throw Exception("Staffs Inbox List Internal server Error");
    }
  }
}

//LeaveApplyCancel

class Leave_Cancel_data{
  final String msg;
  Leave_Cancel_data({required this.msg});
  factory Leave_Cancel_data.fromJson(Map<String, dynamic> leave_cancel){
    return Leave_Cancel_data(
      msg: leave_cancel['msg'],
    );
  }
}

class Leave_Cancel_List{
  final List<Leave_Cancel_data> Leave_cnl_List;
  Leave_Cancel_List({required this.Leave_cnl_List});
  factory Leave_Cancel_List.fromJson(List<dynamic>leaveclc_list){
    List<Leave_Cancel_data> leaveCnlList = <Leave_Cancel_data>[];
    leaveCnlList = leaveclc_list.map((i) => Leave_Cancel_data.fromJson(i)).toList();
    return Leave_Cancel_List(Leave_cnl_List: leaveCnlList);
  }
}

class Leave_Cancel_Network{
  final String url;
  Leave_Cancel_Network(this.url);
  Future<Leave_Cancel_List> Leave_cl_data() async{
    final response = await get(Uri.parse("http://$StaticIP/api/$url"));
    print("http://$StaticIP/api/$url");
    if(response.statusCode == 200){
      return Leave_Cancel_List.fromJson(json.decode(response.body));
    }
    else{
      throw Exception("Staff cancel Internal server error");
    }
  }
}


//Staff Add Club Function

class AddClubFun_List{
  final List<AddClubAPI_data> AddClubFundata_List;
  AddClubFun_List({required this.AddClubFundata_List});
  factory AddClubFun_List.fromJson(List<dynamic>AddClubAPI_data_List){
    List <AddClubAPI_data> addclubapiData = <AddClubAPI_data>[];
    addclubapiData = AddClubAPI_data_List.map((i)=> AddClubAPI_data.fromJson(i)).toList();
    return AddClubFun_List(AddClubFundata_List: addclubapiData );
  }
}

class AddClubAPI_data {
  final String msg;
  AddClubAPI_data({required this.msg
  });
  factory AddClubAPI_data.fromJson (Map<String, dynamic> AddClubFunapi_test){
    return AddClubAPI_data(
      msg: AddClubFunapi_test['msg'],
    );
  }
}

class AddClubFunNetwork{
  final String url;
  AddClubFunNetwork(this.url);
  Future <AddClubFun_List> AddClubFunloadData () async {
    final response = await get(Uri.parse("http://$StaticIP/api/$url"));
    if (response.statusCode == 200){
      return AddClubFun_List.fromJson(json.decode(response.body));
    }
    else{
      throw Exception("Failed to AddClubFunNetwork load data");
    }
  }
}

//SelectClub

class ClubAttend_List{
  final List<ClubAttend_Data> Club_A_List;

  ClubAttend_List({required this.Club_A_List});

  factory ClubAttend_List.fromJson(List<dynamic> ClubAttend_Data_List){
    List<ClubAttend_Data> clubAtData = <ClubAttend_Data>[];
    clubAtData = ClubAttend_Data_List.map((i) => ClubAttend_Data.fromJson(i)).toList();
    return ClubAttend_List(Club_A_List: clubAtData);
    }
}

class ClubAttend_Data{

  final int id;
  final int Clubid;
  final String FunctionName;
  final String FromDate;
  final String ToDate;
  final String Guestname;
  final String ClubName;
  final String CreatedStaff;
  final String Program;

  ClubAttend_Data({ required this.id ,required this.CreatedStaff,required this.Program,required this.ClubName, required this.Clubid, required this.FunctionName, required this.FromDate, required this.Guestname, required this.ToDate});

  factory ClubAttend_Data.fromJson(Map<String, dynamic> Club_Attend){
    return ClubAttend_Data(

      Clubid: Club_Attend["Clubid"],
      id: Club_Attend["id"],
      FunctionName: Club_Attend["FuntionName"],
      FromDate: Club_Attend["Fromdate"],
      ToDate: Club_Attend["Todate"],
      Guestname: Club_Attend["Guestname"],
      ClubName: Club_Attend["ClubName"],
      CreatedStaff: Club_Attend["CreatedStaff"],
      Program: Club_Attend["Program"]
    );
  }
}

class Clun_Attend_Network{
  final String url;

  Clun_Attend_Network(this.url);

  Future<ClubAttend_List> ClubA_loadData() async {
    print("http://$StaticIP/api/$url");
    final response = await get(Uri.parse("http://$StaticIP/api/$url"));
    if (response.statusCode == 200){
      return ClubAttend_List.fromJson(json.decode(response.body));
    }
    else {
      throw Exception("Failed to load club attendance details");
    }
  }
}


//Club Students List

class ClubStud_List{
  final List<ClubStud_Data> Club_Stud_List;
  ClubStud_List({required this.Club_Stud_List});

  factory ClubStud_List.fromJson(List<dynamic>ClubStud_Data_List){
    List<ClubStud_Data> clubStData = <ClubStud_Data>[];
    clubStData = ClubStud_Data_List.map((i) => ClubStud_Data.fromJson(i)).toList();
    return ClubStud_List(Club_Stud_List: clubStData);
  }
}

class ClubStud_Data{
  final int id;
  final int Clubid;
  final int Studentid;
  final String StudentName;
  final String Rollno;
  final String Mattend;
  final String Mses;
  final String Eattend;
  final String Eses;
  final String simg;

  ClubStud_Data({required this.Mattend,required this.Mses, required this.Eattend, required this.Eses, required this.simg,required this.id,required this.Clubid,required this.Studentid, required this.StudentName, required this.Rollno,});

  factory ClubStud_Data.fromJson(Map<String, dynamic> Club_Student){
    return ClubStud_Data(
      id: Club_Student["id"],
        Clubid: Club_Student["Clubid"],
        Studentid: Club_Student["Studentid"],
        StudentName: Club_Student["StudentName"],
        Rollno: Club_Student["Rollno"],
        Mattend: Club_Student["Mattend"],
        Mses: Club_Student["Mses"],
        Eattend: Club_Student["Eattend"],
        Eses: Club_Student["Eses"],
        simg: Club_Student["simg"]
    );
  }

}

class ClubStud_Network{
  final String url;

  ClubStud_Network(this.url);

  Future<ClubStud_List>  ClubStud_loadData() async{
  print("http://$StaticIP/api/$url");
  final response = await get(Uri.parse("http://$StaticIP/api/$url"));
  if (response.statusCode == 200){
  return ClubStud_List.fromJson(json.decode(response.body));
  }
  else {
  throw Exception("Failed to load club attendance details");
  }
}
}

// FinalClubAttend

class ClubFinalAttend_List{
  final List<ClubFinalAttend_Data> ClubAtted_List;

  ClubFinalAttend_List({required this.ClubAtted_List});

  factory ClubFinalAttend_List.fromJson(List<dynamic> FinalClub_List){
    List<ClubFinalAttend_Data> clubattendfinalData = <ClubFinalAttend_Data>[];
    clubattendfinalData = FinalClub_List.map((i) => ClubFinalAttend_Data.fromJson(i)).toList();
    return ClubFinalAttend_List(ClubAtted_List: clubattendfinalData);
  }
}

class ClubFinalAttend_Data{
  final String msg;
  ClubFinalAttend_Data({
    required this.msg
});
  factory ClubFinalAttend_Data.fromJson(Map<String, dynamic> FinalClub){
    return ClubFinalAttend_Data(
      msg: FinalClub["msg"]
    );
  }
}

class Club_Final_Network{
  final String url;

  Club_Final_Network(this.url);
  Future<ClubFinalAttend_List> FinalClub_LoadData()async{
    print("http://$StaticIP/api/$url");
    final response = await get(Uri.parse("http://$StaticIP/api/$url"));
    if (response.statusCode == 200) {
      return ClubFinalAttend_List.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load data for Internal Server Error");
    }  }
}

//Attendance Terms

class AttendTerms_List{
  final List<Attend_data> AttendTerm_List;
  AttendTerms_List({required this.AttendTerm_List});

  factory AttendTerms_List.fromJson(List<dynamic> Attend_List){
    List<Attend_data> attendtermsfinalData = <Attend_data>[];
    attendtermsfinalData = Attend_List.map((i) => Attend_data.fromJson(i)).toList();
    return AttendTerms_List(AttendTerm_List: attendtermsfinalData);
  }

}

class Attend_data{
final String Term;
final int AttendanceId;
final String ShortName;

Attend_data({required this.AttendanceId, required this.ShortName, required this.Term});

factory Attend_data.fromJson(Map<String, dynamic> FinalTerms){
  return Attend_data(
    Term: FinalTerms["Term"],
    AttendanceId: FinalTerms["AttendanceId"],
    ShortName: FinalTerms["ShortName"],
  );
}
}

class AttendTerms_Network{
  final String url;
  AttendTerms_Network(this.url);
  Future<AttendTerms_List> FinalTerms_LoadData()async{
    print("http://$StaticIP/api/$url");
    final response = await get(Uri.parse("http://$StaticIP/api/$url"));
    if (response.statusCode == 200) {
      return AttendTerms_List.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load data for Internal Server Error");
    }  }
}
