import 'dart:convert';
import 'package:add_dev_dolphin/Style_font/designs.dart';
import 'package:add_dev_dolphin/Style_font/student_screen_design.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Student_Data.dart';
import 'Student_Data.dart';

String IpAddress = "";
String Img = "";
/*
Live Site API IP Address
VET IAS: http://121.200.54.216:89/api/

Training Site API IP Address
VET IAS: http://121.200.54.216:96/api/
VET IAS: http://121.200.54.216:99/api/
*/

SetStudentIP(String value){
  IpAddress = value;
}

// Profile API
class Data_List{
  final List<API_data> data_list;

  Data_List({required this.data_list});

  factory Data_List.fromJson(List<dynamic>API_Data_List){
    List <API_data> api_data = <API_data>[];
    api_data = API_Data_List.map((i)=> API_data.fromJson(i)).toList();
    return new Data_List(data_list: api_data);
  }
}

class API_data {
  final String StudentName;
  final String RollNum;
  final String RegNo;
  final String ImpresCode;
  final String Quota;
  final String Community;
  final String StudentType;
  final String FirstGraduate;
  final String Gender;
  final String Status;
  final String AdmissionType;
  final String Hostel;
  final String Transport;
  final String Password;
  final String DateOfBirth;
  final String BloodGroup;
  final String HostelName;
  final String HostelRoom;
  final String TransportRoute;
  final String TransportStage;
  final String BatchYear;
  final String FatherName;
  final String MotherName;
  final String GuardianName;
  final String EMailID;
  final String StudentMobileNo;
  final String FatherMobileNo;
  final String MotherMobileNo;
  final String GuardianMobileNo;
  final String CourseFullName;
  final String Picture;
  final String Insurance;
  final String MotherTongue;


  API_data({required this.StudentName, required this.RollNum, required this.RegNo, required this.ImpresCode
    , required this.Quota, required this.Community, required this.StudentType, required this.FirstGraduate
    , required this.Gender, required this.Status, required this.AdmissionType, required this.Hostel
    , required this.Transport, required this.Password, required this.DateOfBirth, required this.BloodGroup
    , required this.HostelName, required this.HostelRoom, required this.TransportRoute, required this.TransportStage
    , required this.BatchYear, required this.FatherName, required this.MotherName, required this.GuardianName
    , required this.EMailID, required this.StudentMobileNo, required this.FatherMobileNo, required this.MotherMobileNo
    , required this.GuardianMobileNo, required this.CourseFullName, required this.Picture, required this.Insurance
    , required this.MotherTongue});

  factory API_data.fromJson (Map<String, dynamic> api_test){
    return API_data(
      StudentName: api_test['StudentName'], RollNum: api_test['RollNum'],
      RegNo: api_test['RegNo'], ImpresCode: api_test['ImpresCode'],
      Quota: api_test['Quota'],Community: api_test['Community'],
      StudentType: api_test['StudentType'],FirstGraduate: api_test['FirstGraduate'],
      Gender: api_test['Gender'],Status: api_test['Status'],
      AdmissionType: api_test['AdmissionType'],Hostel: api_test['Hostel'],
      Transport: api_test['Transport'],Password: api_test['Password'],
      DateOfBirth: api_test['DateOfBirth'],BloodGroup: api_test['BloodGroup'],
      HostelName: api_test['HostelName'],HostelRoom: api_test['HostelRoom'],
      TransportRoute: api_test['TransportRoute'],TransportStage: api_test['TransportStage'],
      BatchYear: api_test['BatchYear'],FatherName: api_test['FatherName'],
      MotherName: api_test['MotherName'],GuardianName: api_test['GuardianName'],
      EMailID: api_test['EMailID'],StudentMobileNo: api_test['StudentMobileNo'],
      FatherMobileNo: api_test['FatherMobileNo'],MotherMobileNo: api_test['MotherMobileNo'],
      GuardianMobileNo: api_test['GuardianMobileNo'],CourseFullName: api_test['CourseFullName'],
      Picture: api_test['Picture'],Insurance: api_test['Insurance'],
      MotherTongue: api_test['MotherTongue'],
    );
  }
}

class Network{
  final String url;

  Network(this.url);

  Future <Data_List> loadData () async {
    final response = await get(Uri.parse("http://$IpAddress/api/$url"));
    // final response = await get(Uri.parse("http://3.108.194.101/impapi/api/$url"));
    if (response.statusCode == 200){
      return Data_List.fromJson(json.decode(response.body));
    }
    else{
      throw Exception("Failed to load data");
    }
  }
}

// Attendance API
class AttendanceData_List{
  final List<AttendanceAPI_data> Attendancedata_list;

  AttendanceData_List({required this.Attendancedata_list});

  factory AttendanceData_List.fromJson(List<dynamic>AttendanceAPI_Data_List){
    List <AttendanceAPI_data> Attendanceapi_data = <AttendanceAPI_data>[];
    Attendanceapi_data = AttendanceAPI_Data_List.map((i)=> AttendanceAPI_data.fromJson(i)).toList();
    return new AttendanceData_List(Attendancedata_list: Attendanceapi_data);
  }
}

class AttendanceAPI_data {
  final String AttendanceFromDate;
  final String AttendanceToDate;
  final String SemesterName;
  final int ClassId;
  final int Year;
  final int AcadYearId;
  final int SemesterId;
  final int SemesterNumber;
  final int TotalDays;
  final double DaysPresent;
  final double DayAbsent;
  final double DaysPresentPercentage;
  final int TotalHours;
  final double HoursPresent;
  final double HoursAbsent;
  final double HoursPercentage;
  final int AttendanceHours;

  AttendanceAPI_data({ required this.AttendanceFromDate, required this.AttendanceToDate, required this.SemesterName
    ,required this.ClassId, required this.Year, required this.AcadYearId, required this.SemesterId
    , required this.SemesterNumber, required this.TotalDays, required this.DaysPresent, required this.DayAbsent
    , required this.DaysPresentPercentage, required this.TotalHours, required this.HoursPresent, required this.HoursAbsent
    , required this.HoursPercentage, required this.AttendanceHours });

  factory AttendanceAPI_data.fromJson (Map<String, dynamic> Attendanceapi_test){
    return AttendanceAPI_data(
        AttendanceFromDate: Attendanceapi_test['AttendanceFromDate'],AttendanceToDate: Attendanceapi_test['AttendanceToDate'],
        SemesterName: Attendanceapi_test['SemesterName'], ClassId: Attendanceapi_test['ClassId'],
        Year: Attendanceapi_test['Year'], AcadYearId: Attendanceapi_test['AcadYearId'],
        SemesterId: Attendanceapi_test['SemesterId'], SemesterNumber: Attendanceapi_test['SemesterNumber'],
        TotalDays: Attendanceapi_test['TotalDays'], DaysPresent: Attendanceapi_test['DaysPresent'],
        DayAbsent: Attendanceapi_test['DayAbsent'], DaysPresentPercentage: Attendanceapi_test['DaysPresentPercentage'],
        TotalHours: Attendanceapi_test['TotalHours'], HoursPresent: Attendanceapi_test['HoursPresent'],
        HoursAbsent: Attendanceapi_test['HoursAbsent'], HoursPercentage: Attendanceapi_test['HoursPercentage'],
        AttendanceHours: Attendanceapi_test['AttendanceHours']
    );
  }
}

class AttendanceNetwork{
  final String url;

  AttendanceNetwork(this.url);

  Future <AttendanceData_List> AttendanceloadData () async {
    final response = await get(Uri.parse("http://$IpAddress/api/$url"));
    print("http://$IpAddress/api/$url");
    if (response.statusCode == 200){
      return AttendanceData_List.fromJson(json.decode(response.body));
    }
    else{
      throw Exception("Failed to load data");
    }
  }
}

// Attendance Details API
class AttendanceDetailsData_List{
  final List<AttendanceDetailsAPI_data> AttendanceDetailsdata_list;

  AttendanceDetailsData_List({required this.AttendanceDetailsdata_list});

  factory AttendanceDetailsData_List.fromJson(List<dynamic>AttendanceDetailsAPI_Data_List){
    List <AttendanceDetailsAPI_data> AttendanceDetailsapi_data = <AttendanceDetailsAPI_data>[];
    AttendanceDetailsapi_data = AttendanceDetailsAPI_Data_List.map((i)=> AttendanceDetailsAPI_data.fromJson(i)).toList();
    return new AttendanceDetailsData_List(AttendanceDetailsdata_list: AttendanceDetailsapi_data );
  }
}

class AttendanceDetailsAPI_data {
  final int DateId;
  final String Weekday;
  final String Date;
  final int Semester;
  final String H1;
  final String H2;
  final String H3;
  final String H4;
  final String H5;
  final String H6;
  final String H7;
  final String H8;
  final String H9;
  final String H10;
  final String WeekdaySmall;


  AttendanceDetailsAPI_data({required this.DateId, required this.Weekday, required this.Date, required this.Semester
    , required this.H1, required this.H2, required this.H3, required this.H4
    , required this.H5, required this.H6, required this.H7, required this.H8
    , required this.H9, required this.H10,required this.WeekdaySmall});

  factory AttendanceDetailsAPI_data.fromJson (Map<String, dynamic> AttendanceDetailsapi_test){
    return AttendanceDetailsAPI_data(
      DateId: AttendanceDetailsapi_test['DateId'], Weekday: AttendanceDetailsapi_test['Weekday'],
      Date: AttendanceDetailsapi_test['Date'], Semester: AttendanceDetailsapi_test['Semester'],
      H1: AttendanceDetailsapi_test['H1'], H2: AttendanceDetailsapi_test['H2'],
      H3: AttendanceDetailsapi_test['H3'], H4: AttendanceDetailsapi_test['H4'],
      H5: AttendanceDetailsapi_test['H5'], H6: AttendanceDetailsapi_test['H6'],
      H7: AttendanceDetailsapi_test['H7'], H8: AttendanceDetailsapi_test['H8'],
      H9: AttendanceDetailsapi_test['H9'], H10: AttendanceDetailsapi_test['H10'],
      WeekdaySmall: AttendanceDetailsapi_test['WeekdaySmall'],
    );
  }
}

class AttendanceDetailsNetwork{
  final String url;

  AttendanceDetailsNetwork(this.url);

  Future <AttendanceDetailsData_List> AttendanceDetailsloadData () async {
    final response = await get(Uri.parse("http://$IpAddress/api/$url"));
    if (response.statusCode == 200){
      return AttendanceDetailsData_List.fromJson(json.decode(response.body));
    }
    else{
      throw Exception("Failed to load data");
    }
  }
}

// Attendance Abstansia API
class AttendanceAbstansiaData_List{
  final List<AttendanceAbstansiaAPI_data> AttendanceAbstansiadata_list;

  AttendanceAbstansiaData_List({required this.AttendanceAbstansiadata_list});

  factory AttendanceAbstansiaData_List.fromJson(List<dynamic>AttendanceAbstansiaAPI_Data_List){
    List <AttendanceAbstansiaAPI_data> AttendanceAbstansiaapi_data = <AttendanceAbstansiaAPI_data>[];
    AttendanceAbstansiaapi_data = AttendanceAbstansiaAPI_Data_List.map((i)=> AttendanceAbstansiaAPI_data.fromJson(i)).toList();
    return new AttendanceAbstansiaData_List(AttendanceAbstansiadata_list: AttendanceAbstansiaapi_data );
  }
}

class AttendanceAbstansiaAPI_data {
  final String Weekday;
  final String Date;
  final String Month;
  final String AttedanceFullName;
  final String AttedanceShortName;
  final String AbsentHours;
  final int TotalHours;
  final int CumulativeHours;

  AttendanceAbstansiaAPI_data({required this.Weekday, required this.Date, required this.Month, required this.AttedanceFullName
    , required this.AttedanceShortName, required this.AbsentHours, required this.TotalHours, required this.CumulativeHours});

  factory AttendanceAbstansiaAPI_data.fromJson (Map<String, dynamic> AttendanceAbstansiaapi_test){
    return AttendanceAbstansiaAPI_data(
      Weekday: AttendanceAbstansiaapi_test['Weekday'], Date: AttendanceAbstansiaapi_test['Date'],
      Month: AttendanceAbstansiaapi_test['Month'],AttedanceFullName: AttendanceAbstansiaapi_test['AttedanceFullName'],
      AttedanceShortName: AttendanceAbstansiaapi_test['AttedanceShortName'],AbsentHours: AttendanceAbstansiaapi_test['AbsentHours'],
      TotalHours: AttendanceAbstansiaapi_test['TotalHours'],CumulativeHours: AttendanceAbstansiaapi_test['CumulativeHours'],
    );
  }
}

class AttendanceAbstansiaNetwork{
  final String url;

  AttendanceAbstansiaNetwork(this.url);

  Future <AttendanceAbstansiaData_List> AttendanceAbstansialoadData () async {
    final response = await get(Uri.parse("http://$IpAddress/api/$url"));
    if (response.statusCode == 200){
      return AttendanceAbstansiaData_List.fromJson(json.decode(response.body));
    }
    else{
      throw Exception("Failed to load data");
    }
  }
}

// Internal Mark API
class InternalMarkData_List{
  final List<InternalMarkAPI_data> InternalMarkdata_list;

  InternalMarkData_List({required this.InternalMarkdata_list});

  factory InternalMarkData_List.fromJson(List<dynamic>InternalMarkAPI_Data_List){
    List <InternalMarkAPI_data> InternalMarkapi_data = <InternalMarkAPI_data>[];
    InternalMarkapi_data = InternalMarkAPI_Data_List.map((i)=> InternalMarkAPI_data.fromJson(i)).toList();
    return new InternalMarkData_List(InternalMarkdata_list: InternalMarkapi_data );
  }
}

class InternalMarkAPI_data {
  final int SemesterNo;
  final List <InternalMarkTestList> TestNameList;

  InternalMarkAPI_data({required this.SemesterNo, required this.TestNameList,});

  factory InternalMarkAPI_data.fromJson (Map<dynamic, dynamic> InternalMarkapi_test){
    var TestList = InternalMarkapi_test['TestNameList'] as List;
    List <InternalMarkTestList>InternalTestList = TestList.map((Testname) => InternalMarkTestList.fromJson(Testname)).toList();
    return InternalMarkAPI_data(
        SemesterNo: InternalMarkapi_test['SemesterNo'],
        TestNameList: InternalTestList
    );
  }
}

class InternalMarkTestList {
  final String TestName;
  final List <InternalMarkDetails> Mark;

  InternalMarkTestList({required this.TestName, required this.Mark, });

  factory InternalMarkTestList.fromJson (Map<String, dynamic> InternalMarkTestList_test){
    var MarkDetails = InternalMarkTestList_test['Mark'] as List;
    List <InternalMarkDetails> Mark = MarkDetails.map((i) => InternalMarkDetails.fromJson(i)).toList();
    return InternalMarkTestList(
        TestName: InternalMarkTestList_test['TestName'], Mark: Mark
    );
  }
}

class InternalMarkDetails {
  final String SubjectCode;
  final String SubjectFullName;
  final String SubjectShortName;
  final double Mark;
  final double MaxMark;
  final String Result;

  InternalMarkDetails({required this.SubjectCode, required this.SubjectFullName, required this.SubjectShortName, required this.Mark,
    required this.MaxMark, required this.Result,});

  factory InternalMarkDetails.fromJson (Map<String, dynamic> InternalMarkDetail){
    return InternalMarkDetails(
      SubjectCode: InternalMarkDetail['SubjectCode'], SubjectFullName: InternalMarkDetail['SubjectFullName'],
      SubjectShortName: InternalMarkDetail['SubjectShortName'], Mark: InternalMarkDetail['Mark'],
      MaxMark: InternalMarkDetail['MaxMark'], Result: InternalMarkDetail['Result'],
    );
  }
}

class InternalMarkNetwork{
  final String url;

  InternalMarkNetwork(this.url);

  Future <InternalMarkData_List> InternalMarkloadData () async {
    final response = await get(Uri.parse("http://$IpAddress/api/$url"));
    if (response.statusCode == 200){
      return InternalMarkData_List.fromJson(json.decode(response.body));
    }
    else{
      throw Exception("Failed to load data");
    }
  }
}

// University Mark
class UniversityData_List{
  final List<UniversityAPI_data> Universitydata_list;

  UniversityData_List({required this.Universitydata_list});

  factory UniversityData_List.fromJson(List<dynamic>UniversityAPI_Data_List){
    List <UniversityAPI_data> Universityapi_data = <UniversityAPI_data>[];
    Universityapi_data = UniversityAPI_Data_List.map((i)=> UniversityAPI_data.fromJson(i)).toList();
    return new UniversityData_List(Universitydata_list: Universityapi_data );
  }
}

class UniversityAPI_data {
  final int SemesterNo;
  final List <UniversityMarkDetails> UniversityMarksList;


  UniversityAPI_data({required this.SemesterNo, required this.UniversityMarksList,});

  factory UniversityAPI_data.fromJson (Map<String, dynamic> Universityapi_test){
    var MarkDetails = Universityapi_test['UniversityMarksList'] as List;
    List <UniversityMarkDetails> UniversityMarkDetailsList = MarkDetails.map((e) => UniversityMarkDetails.fromJson(e)).toList();
    return UniversityAPI_data(
      SemesterNo: Universityapi_test['SemesterNo'], UniversityMarksList: UniversityMarkDetailsList,
    );
  }
}

class UniversityMarkDetails {
  final String SubjectShortName;
  final String InternalMark;
  final String ExternalMark;
  final String SubjectCode;
  final String TotalMark;
  final String Result;
  final String GradeShortName;
  final String GradePoint;
  final String AttemptNo;
  final String SGPA;
  final String CGPA;
  final String Credit;
  final String SubjectType;

  UniversityMarkDetails({required this.SubjectShortName, required this.InternalMark, required this.ExternalMark, required this.SubjectCode
    , required this.TotalMark, required this.Result, required this.GradeShortName, required this.GradePoint
    , required this.AttemptNo, required this.SGPA, required this.CGPA, required this.Credit, required this.SubjectType});

  factory UniversityMarkDetails.fromJson (Map<String, dynamic> UniversityMarkDetailsapi_test){
    return UniversityMarkDetails(
      SubjectShortName: UniversityMarkDetailsapi_test['SubjectShortName'], InternalMark: UniversityMarkDetailsapi_test['InternalMark'],
      ExternalMark: UniversityMarkDetailsapi_test['ExternalMark'], SubjectCode: UniversityMarkDetailsapi_test['SubjectCode'],
      TotalMark: UniversityMarkDetailsapi_test['TotalMark'], Result: UniversityMarkDetailsapi_test['Result'],
      GradeShortName: UniversityMarkDetailsapi_test['GradeShortName'], GradePoint: UniversityMarkDetailsapi_test['GradePoint'],
      AttemptNo: UniversityMarkDetailsapi_test['AttemptNo'], SGPA: UniversityMarkDetailsapi_test['SGPA'],
      CGPA: UniversityMarkDetailsapi_test['CGPA'], Credit: UniversityMarkDetailsapi_test['Credit'],
      SubjectType: UniversityMarkDetailsapi_test['SubjectType'],
    );
  }
}

class UniversityNetwork{
  final String url;

  UniversityNetwork(this.url);

  Future <UniversityData_List> UniversityloadData () async {
    final response = await get(Uri.parse("http://$IpAddress/api/$url"));
    if (response.statusCode == 200){
      return UniversityData_List.fromJson(json.decode(response.body));
    }
    else{
      throw Exception("Failed to load data");
    }
  }
}

// Timetable
class TimetableData_List{
  final List<TimetableAPI_data> Timetabledata_list;

  TimetableData_List({required this.Timetabledata_list});

  factory TimetableData_List.fromJson(List<dynamic>TimetableAPI_Data_List){
    List <TimetableAPI_data> Timetableapi_data = <TimetableAPI_data>[];
    Timetableapi_data = TimetableAPI_Data_List.map((i)=> TimetableAPI_data.fromJson(i)).toList();
    return new TimetableData_List(Timetabledata_list: Timetableapi_data );
  }
}

class TimetableAPI_data {
  final String dy;
  final String s1;
  final String s2;
  final String s3;
  final String s4;
  final String s5;
  final String s6;
  final String s7;
  final String s8;
  final String s9;
  final String s10;
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



  TimetableAPI_data({required this.dy, required this.s1, required this.s2, required this.s3
  , required this.s4, required this.s5, required this.s6, required this.s7
    , required this.s8, required this.s9, required this.s10, required this.c1
    , required this.c2, required this.c3, required this.c4, required this.c5
    , required this.c6, required this.c7, required this.c8, required this.c9
    , required this.c10});

  factory TimetableAPI_data.fromJson (Map<String, dynamic> Timetableapi_test){
    return TimetableAPI_data(
      dy: Timetableapi_test['dy'], s1: Timetableapi_test['s1'],
      s2: Timetableapi_test['s2'], s3: Timetableapi_test['s3'],
      s4: Timetableapi_test['s4'], s5: Timetableapi_test['s5'],
      s6: Timetableapi_test['s6'], s7: Timetableapi_test['s7'],
      s8: Timetableapi_test['s8'], s9: Timetableapi_test['s9'],
      s10: Timetableapi_test['s10'], c1: Timetableapi_test['c1'],
      c2: Timetableapi_test['c2'], c3: Timetableapi_test['c3'],
      c4: Timetableapi_test['c4'], c5: Timetableapi_test['c5'],
      c6: Timetableapi_test['c6'], c7: Timetableapi_test['c7'],
      c8: Timetableapi_test['c8'], c9: Timetableapi_test['c9'],
      c10: Timetableapi_test['c10'],
    );
  }
}

class TimetableNetwork{

  final String url;

  TimetableNetwork(this.url);

  Future <TimetableData_List> TimetableloadData () async {
    final response = await get(Uri.parse("http://$IpAddress/api/$url"));
    print("http://$IpAddress/api/$url");
    if (response.statusCode == 200){
      return TimetableData_List.fromJson(json.decode(response.body));

    }
    else{
      throw Exception("Failed to load data");
    }
  }
}

// Holiday
class HolidayData_List{
  final List<HolidayAPI_data> Holidaydata_list;

  HolidayData_List({required this.Holidaydata_list});

  factory HolidayData_List.fromJson(List<dynamic>HolidayAPI_Data_List){
    List <HolidayAPI_data> Holidayapi_data = <HolidayAPI_data>[];
    Holidayapi_data = HolidayAPI_Data_List.map((i)=> HolidayAPI_data.fromJson(i)).toList();
    return new HolidayData_List(Holidaydata_list: Holidayapi_data );
  }
}

class HolidayAPI_data {
  final String Date;
  final String Day;
  final String Name;
  final String Remark;
  final String Year;

  HolidayAPI_data({required this.Date, required this.Day, required this.Name, required this.Remark, required this.Year});

  factory HolidayAPI_data.fromJson (Map<String, dynamic> Holidayapi_test){
    return HolidayAPI_data(
      Date: Holidayapi_test['Date'], Day: Holidayapi_test['Day'],
      Name: Holidayapi_test['Name'], Remark: Holidayapi_test['Remark'],
      Year: Holidayapi_test['Year'],
    );
  }
}

class HolidayNetwork{
  final String url;

  HolidayNetwork(this.url);

  Future <HolidayData_List> HolidayloadData () async {
    final response = await get(Uri.parse("http://$IpAddress/api/$url"));
    print("http://$IpAddress/api/$url");
    if (response.statusCode == 200){
      return HolidayData_List.fromJson(json.decode(response.body));
    }
    else{
      throw Exception("Failed to load data");
    }
  }
}

// Circular
class CircularData_List{
  final List<CircularAPI_data> Circulardata_list;

  CircularData_List({required this.Circulardata_list});

  factory CircularData_List.fromJson(List<dynamic>CircularAPI_Data_List){
    List <CircularAPI_data> Circularapi_data = <CircularAPI_data>[];
    Circularapi_data = CircularAPI_Data_List.map((i)=> CircularAPI_data.fromJson(i)).toList();
    return new CircularData_List(Circulardata_list: Circularapi_data );
  }
}

class CircularAPI_data {
  final String CircularDate;
  final String Discription;
  final String CreatedBy;
  final String CreatedDateTime;
  final String Remark;
  final String File;
  final String Day;


  CircularAPI_data({required this.CircularDate, required this.Discription, required this.CreatedBy, required this.CreatedDateTime
    , required this.Remark, required this.File, required this.Day});

  factory CircularAPI_data.fromJson (Map<String, dynamic> Circularapi_test){
    return CircularAPI_data(
      CircularDate: Circularapi_test['CircularDate'], Discription: Circularapi_test['Discription'],
      CreatedBy: Circularapi_test['CreatedBy'], CreatedDateTime: Circularapi_test['CreatedDateTime'],
      Remark: Circularapi_test['Remark'], File: Circularapi_test['File'], Day: Circularapi_test['Day'],
    );
  }
}

class CircularNetwork{
  final String url;

  CircularNetwork(this.url);

  Future <CircularData_List> CircularloadData () async {
    final response = await get(Uri.parse("http://$IpAddress/api/$url"));
    print("http://$IpAddress/api/$url");
    if (response.statusCode == 200){
      return CircularData_List.fromJson(json.decode(response.body));
    }
    else{
      throw Exception("Failed to load data");
    }
  }
}

// Exam Cretificate

class ExamCertificateData_List{
  final List<ExamCertificateAPI_data> ExamCertificatedata_list;

  ExamCertificateData_List({required this.ExamCertificatedata_list});

  factory ExamCertificateData_List.fromJson(List<dynamic>ExamCertificateAPI_Data_List){
    List <ExamCertificateAPI_data> ExamCertificateapi_data = <ExamCertificateAPI_data>[];
    ExamCertificateapi_data = ExamCertificateAPI_Data_List.map((i)=> ExamCertificateAPI_data.fromJson(i)).toList();
    return new ExamCertificateData_List(ExamCertificatedata_list: ExamCertificateapi_data );
  }
}

class ExamCertificateAPI_data {
  final String CertificateName;
  final String FileName;

  ExamCertificateAPI_data({required this.CertificateName, required this.FileName});

  factory ExamCertificateAPI_data.fromJson (Map<String, dynamic> ExamCertificateapi_test){
    return ExamCertificateAPI_data(
      CertificateName: ExamCertificateapi_test['CertificateName'], FileName: ExamCertificateapi_test['FileName'],
    );
  }
}

class ExamCertificateNetwork{
  final String url;

  ExamCertificateNetwork(this.url);

  Future <ExamCertificateData_List> ExamCertificateloadData () async {
    final response = await get(Uri.parse("http://$IpAddress/api/$url"));
    print("http://$IpAddress/api/$url");
    if (response.statusCode == 200){
      return ExamCertificateData_List.fromJson(json.decode(response.body));
    }
    else{
      throw Exception("Failed to load data");
    }
  }
}

// Students DCB
class StudentDCBData_List{
  final List<StudentDCBAPI_data> StudentDCBdata_list;

  StudentDCBData_List({required this.StudentDCBdata_list});

  factory StudentDCBData_List.fromJson(List<dynamic>StudentDCBAPI_Data_List){
    List <StudentDCBAPI_data> StudentDCBapi_data = <StudentDCBAPI_data>[];
    StudentDCBapi_data = StudentDCBAPI_Data_List.map((i)=> StudentDCBAPI_data.fromJson(i)).toList();
    return new StudentDCBData_List(StudentDCBdata_list: StudentDCBapi_data );
  }
}

class StudentDCBAPI_data {
  final String Semester;
  final String Class;
  final double Demand;
  final double Concession;
  final double Paid;
  final double Balance;
  final double Fine;

  StudentDCBAPI_data({required this.Semester, required this.Class, required this.Demand, required this.Concession
    , required this.Paid, required this.Balance, required this.Fine});

  factory StudentDCBAPI_data.fromJson (Map<String, dynamic> StudentDCBapi_test){
    return StudentDCBAPI_data(
      Semester: StudentDCBapi_test['Semester'], Class: StudentDCBapi_test['Class'],
        Demand: StudentDCBapi_test['Demand'], Concession: StudentDCBapi_test['Concession'],
        Paid: StudentDCBapi_test['Paid'], Balance: StudentDCBapi_test['Balance'],
        Fine: StudentDCBapi_test['Fine']
    );
  }
}

class StudentDCBNetwork{

  final String url;

  StudentDCBNetwork(this.url);

  Future <StudentDCBData_List> StudentDCBloadData () async {
    final response = await get(Uri.parse("http://$IpAddress/api/$url"));
    print("http://$IpAddress/api/$url");
    if (response.statusCode == 200){
      return StudentDCBData_List.fromJson(json.decode(response.body));
    }
    else{
      throw Exception("Failed to load data");
    }
  }
}

// Students DCB History
class StudentDCBHistoryData_List{
  final List<StudentDCBHistoryAPI_data> StudentDCBHistorydata_list;

  StudentDCBHistoryData_List({required this.StudentDCBHistorydata_list});

  factory StudentDCBHistoryData_List.fromJson(List<dynamic>StudentDCBHistoryAPI_Data_List){
    List <StudentDCBHistoryAPI_data> StudentDCBHistoryapi_data = <StudentDCBHistoryAPI_data>[];
    StudentDCBHistoryapi_data = StudentDCBHistoryAPI_Data_List.map((i)=> StudentDCBHistoryAPI_data.fromJson(i)).toList();
    return new StudentDCBHistoryData_List(StudentDCBHistorydata_list: StudentDCBHistoryapi_data);
  }
}

class StudentDCBHistoryAPI_data {
  final String Semester;
  final String FeeMainHead;
  final double Demand;
  final double Concession;
  final double Paid;
  final double Balance;
  final String LastDate;
  final String ReceiptNo;
  final String ReceiptDate;
  final String Fine;

  StudentDCBHistoryAPI_data({required this.Semester, required this.FeeMainHead, required this.Demand, required this.Concession
    , required this.Paid,required this.Fine, required this.Balance, required this.LastDate ,required this.ReceiptNo,required this.ReceiptDate});

  factory StudentDCBHistoryAPI_data.fromJson (Map<String, dynamic> StudentDCBHistoryapi_test){
    return StudentDCBHistoryAPI_data(
        Semester: StudentDCBHistoryapi_test['Semester'], FeeMainHead: StudentDCBHistoryapi_test['FeeMainHead'],
        Demand: StudentDCBHistoryapi_test['Demand'], Concession: StudentDCBHistoryapi_test['Concession'],
        Paid: StudentDCBHistoryapi_test['Paid'], Balance: StudentDCBHistoryapi_test['Balance'],
        Fine: StudentDCBHistoryapi_test['Fine'],
        LastDate: StudentDCBHistoryapi_test['LastDate'],ReceiptNo: StudentDCBHistoryapi_test['ReceiptNo'],ReceiptDate: StudentDCBHistoryapi_test['ReceiptDate']
    );
  }
}

class StudentDCBHistoryNetwork{
  final String url;

  StudentDCBHistoryNetwork(this.url);

  Future <StudentDCBHistoryData_List> StudentDCBHistoryloadData () async {
    final response = await get(Uri.parse("http://$IpAddress/api/$url"));
    print("http://$IpAddress/api/$url");
    if (response.statusCode == 200){
      return StudentDCBHistoryData_List.fromJson(json.decode(response.body));
    }
    else{
      throw Exception("Failed to load data");
    }
  }
}

// CV Home Page
class CVHomeData_List{
  final List<CVHomeAPI_data> CVHomedata_list;

  CVHomeData_List({required this.CVHomedata_list});

  factory CVHomeData_List.fromJson(List<dynamic>CVHomeAPI_Data_List){
    List <CVHomeAPI_data> CVHomeapi_data = <CVHomeAPI_data>[];
    CVHomeapi_data = CVHomeAPI_Data_List.map((i)=> CVHomeAPI_data.fromJson(i)).toList();
    return new CVHomeData_List(CVHomedata_list: CVHomeapi_data );
  }
}

class CVHomeAPI_data {
  final String WebPath;
  final String ImagePath;
  final String AttendanceHour;

  CVHomeAPI_data({required this.WebPath, required this.ImagePath, required this.AttendanceHour});

  factory CVHomeAPI_data.fromJson (Map<String, dynamic> CVHomeapi_test){
    return CVHomeAPI_data(
      WebPath: CVHomeapi_test['WebPath'], ImagePath: CVHomeapi_test['ImagePath'],
      AttendanceHour: CVHomeapi_test['AttendanceHour'],
    );
  }
}

class CVHomeNetwork{
  final String url;

  CVHomeNetwork(this.url);

  Future <CVHomeData_List> CVHomeloadData () async {
    final response = await get(Uri.parse("http://$IpAddress/api/$url"));
    if (response.statusCode == 200){
      return CVHomeData_List.fromJson(json.decode(response.body));
    }
    else{
      throw Exception("Failed to load data");
    }
  }
}

// For Testing data Input
Future TestGetData() async{
  var data;
  String url = "http://121.200.54.216:89/api/TimeTableStudent?studentcODE=20COA01&Password=20/05/2003";
  TestNetwork network = TestNetwork(url);
  data = network.TestFetchData();
  data.then((value){
    print (value);
  });
  return data;
}

class TestNetwork{
  final String url;

  TestNetwork(this.url);

  Future TestFetchData() async {
    print(url);
    Response response = await get(Uri.parse(url));
    if (response.statusCode == 200)
    {
      return json.decode(response.body);
    }
    else
      throw Exception("Failed to load data");
  }
}

class TestingData_List{
  final List<TestingAPI_data> Testingdata_list;

  TestingData_List({required this.Testingdata_list});

  factory TestingData_List.fromJson(List<dynamic>TestingAPI_Data_List){
    List <TestingAPI_data> Testingapi_data = <TestingAPI_data>[];
    Testingapi_data = TestingAPI_Data_List.map((i)=> TestingAPI_data.fromJson(i)).toList();
    return new TestingData_List(Testingdata_list: Testingapi_data );
  }
}

class TestingAPI_data {
  final String LibraryName;
  final String Title;
  final String Author;
  final String IssueDate;

  TestingAPI_data({required this.LibraryName, required this.Title, required this.Author, required this.IssueDate});

  factory TestingAPI_data.fromJson (Map<String, dynamic> Testingapi_test){
    return TestingAPI_data(
      LibraryName: Testingapi_test['LibraryName'], Title: Testingapi_test['Title'],
      Author: Testingapi_test['Author'], IssueDate: Testingapi_test['IssueDate'],
    );
  }
}

class TestingNetwork{
  final String url;

  TestingNetwork(this.url);

  Future <TestingData_List> TestingloadData () async {
    final response = await get(Uri.parse("http://$IpAddress/api/$url"));
    if (response.statusCode == 200){
      return TestingData_List.fromJson(json.decode(response.body));
    }
    else{
      throw Exception("Failed to load data");
    }
  }
}

//Certificate Request Data

class Cer_Req_List {
  final List<Cer_Req_Data> Cer_RR_List;

  Cer_Req_List({required this.Cer_RR_List});

  factory Cer_Req_List.fromJson(List<dynamic> ReqData_List) {
    List<Cer_Req_Data> CerReq_Tcdata = <Cer_Req_Data>[];
    CerReq_Tcdata = ReqData_List.map((i) => Cer_Req_Data.fromJson(i)).toList();
    return new Cer_Req_List(Cer_RR_List: CerReq_Tcdata);
  }
}

class Cer_Req_Data{
  final int id;
  final String txt;
  final String s;
  final double amt;
  final String p;
  Cer_Req_Data({
    required this.id,
    required this.txt,
    required this.s,
    required this.amt,
    required this.p,
  });
  factory Cer_Req_Data.fromJson(Map<String, dynamic> Cer_T) {
    return Cer_Req_Data(
      id: Cer_T["id"],
      txt: Cer_T["txt"],
      s: Cer_T["s"],
      amt: Cer_T["amt"],
      p: Cer_T["p"],
    );
  }
}

class Cer_Req_Network{
  final String url;

  Cer_Req_Network(this.url);

  Future<Cer_Req_List> CerR_loadData() async {
    final response = await get(Uri.parse("http://$IpAddress/api/$url"));
    if (response.statusCode == 200) {
      return Cer_Req_List.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load data for Internal Server Error");
    }
  }
}

//Certificate Status Data
class Cer_Status_List {
  final List<Cer_Status_Data> Cer_S_List;

  Cer_Status_List({required this.Cer_S_List});

  factory Cer_Status_List.fromJson(List<dynamic> Cer_Status_Data_List) {
    List<Cer_Status_Data> Cer_Stat_Tcdata = <Cer_Status_Data>[];
    Cer_Stat_Tcdata = Cer_Status_Data_List.map((i) => Cer_Status_Data.fromJson(i)).toList();
    return new Cer_Status_List(Cer_S_List: Cer_Stat_Tcdata);
  }
}

class Cer_Status_Data{
  final int id;
  final String certificaterequest;
  final double amount;
  final int requestno;
  final int issueno;
  final String issuedby;
  final String readyby;
  final String requestdate;
  final String issuedate;
  final String needdate;
  final String readydate;
  final String post;
  Cer_Status_Data({
    required this.id,
    required this.certificaterequest,
    required this.amount,
    required this.requestno,
    required this.issueno,
    required this.issuedby,
    required this.readyby,
    required this.requestdate,
    required this.needdate,
    required this.readydate,
    required this.issuedate,
    required this.post,
  });
  factory Cer_Status_Data.fromJson(Map<String, dynamic> Cer_Sta) {
    return Cer_Status_Data(
      id: Cer_Sta["id"],
      certificaterequest: Cer_Sta["certificaterequest"],
      amount: Cer_Sta["amount"],
      requestno: Cer_Sta["requestno"],
      issueno: Cer_Sta["issueno"],
      issuedby: Cer_Sta["issuedby"],
      readyby: Cer_Sta["readyby"],
      requestdate: Cer_Sta["requestdate"],
      needdate: Cer_Sta["needdate"],
      readydate: Cer_Sta["readydate"],
      issuedate: Cer_Sta["issuedate"],
      post: Cer_Sta["post"],
    );
  }
}

class Cer_Status_Req_Network{
  final String url;

  Cer_Status_Req_Network(this.url);

  Future<Cer_Status_List> CerS_loadData() async {
    final response = await get(Uri.parse("http://$IpAddress/api/$url"));
    if (response.statusCode == 200) {
      return Cer_Status_List.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load data for Internal Server Error");
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
    final response = await get(Uri.parse("http://$IpAddress/api/$url"));
    if (response.statusCode == 200){
      return Data_List.fromJson(json.decode(response.body));
    }
    else{
      throw Exception("Failed to load data");
    }
  }
}*/


class StudentLoginCheck extends StatefulWidget {
  const StudentLoginCheck({Key? key,}) : super(key: key);

  @override
  _StudentLoginCheckState createState() => _StudentLoginCheckState();
}

class _StudentLoginCheckState extends State<StudentLoginCheck> {
  late Future <TestingData_List> TestingAPIData;
  late Future testData;
  late int i = 0;
   String item = '';
   List <String> itemList = ['item', 'Item name', 'Item Number'];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    testData = TestGetData();
    TestingNetwork Testingnetwork = TestingNetwork("Library?StudentCode=19PA24&Password=07/09/2001&Method=1&Student=1");
    TestingAPIData = Testingnetwork.TestingloadData();
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
          future: TestingAPIData,
          builder: (context, AsyncSnapshot<TestingData_List> snapshot){
            List <TestingAPI_data> data;
            print(snapshot.error);
            if(snapshot.hasData){
              data = snapshot.data!.Testingdata_list;
              if (data.length > 0){
                return Builder(
                    builder: (BuildContext context) => ListView(
                      scrollDirection: Axis.vertical,
                      children: <Widget>[
                        StudentProfileContainer(
                            "Name :", data[i].Author, context),
                        StudentProfileContainer(
                            "Roll No :", data[i].Title, context),
                        StudentProfileContainer(
                            "Batch :", data[i].IssueDate, context),
                        StudentProfileContainer(
                            "Student Type:", data[i].LibraryName, context),
                        DropdownSearch(
                          items: itemList,
                          selectedItem: 'Selected Item',
                          onChanged: (value)=> Navigator.push(context, MaterialPageRoute(builder: (context)=> Sample(sample: value.toString(),))),
                        )
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
class Sample extends StatelessWidget {
  const Sample({Key? key, required this.sample}) : super(key: key);
  final String sample;

  @override
  Widget build(BuildContext context) {
    return Text(sample);
  }
}

class RestartWidget extends StatefulWidget {
  RestartWidget({this.child});

  final Widget? child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()?.restartApp();
  }

  @override
  State<StatefulWidget> createState() {
    return _RestartWidgetState();
  }
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }


  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child ?? Container(),
    );
  }
}
int template = 0;
void setTemplate(int templateSelect){
  template = templateSelect;
}
// class Template extends StatefulWidget {
//   const Template({Key? key, required this.username, required this.password,}) : super(key: key);
//   final String username;
//   final String password;
//
//   @override
//   State<Template> createState() => _TemplateState();
// }
// class _TemplateState extends State<Template> {
//   @override
//   Widget build(BuildContext context) {
//     // print("selected template $template");
//     // setup();
//     return Scaffold(
//       appBar:  NewGradientAppBar(
//         title: Text("Select Your Themes",style: TextStyle(fontFamily: "Yaahowu"),),
//         gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [Colors.purple,Colors.orange]
//         ),
//         leading: IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back)),
//       ),
//       body: SingleChildScrollView(scrollDirection: Axis.vertical,
//         child: Column(
//           children: [
//             SizedBox(height: sHeight(4, context),),
//             Row(
//               children: [
//                 SizedBox(width: sWidth(6, context),),
//                 Text("Theme1 : With flying colours",style: TextStyle(fontFamily: "Yaahowu"),),
//               ],
//             ),
//             SizedBox(height: sHeight(4, context),),
//             SingleChildScrollView(scrollDirection: Axis.horizontal,
//               child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   SizedBox(width: sWidth(6, context),),
//                   Container(
//                     height: sHeight(50, context),width: sWidth(60, context),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.all(Radius.circular(15),),
//                     ),
//                     child: Image.asset('images/themes_images/rearange1.jpg',height: sHeight(49, context),width: sWidth(69, context),),
//                   ),
//                   SizedBox(width: sWidth(6, context),),
//                   Container(
//                     height: sHeight(50, context),width: sWidth(60, context),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.all(Radius.circular(15),),
//                     ),
//                     child: Image.asset('images/themes_images/rearange2.jpg',height: sHeight(49, context),width: sWidth(69, context),),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: sHeight(4, context),),
//             Row(
//               children: [
//                 SizedBox(width: sWidth(80, context),),
//                 InkWell(
//                   onTap: ()async{
//                     SharedPreferences prefs = await SharedPreferences.getInstance();
//                     st_temp == prefs.setInt('student', 1);
//                     print("student ${st_temp}");
//                     Navigator.push(context, MaterialPageRoute(builder: (context)=>
//                         My_Template1(username: widget.username, password: widget.password)));
//                     final snackbar4 = SnackBar(
//                       backgroundColor: Colors.green,
//                       content: const Text('Activate This UI once you exit And enter the app'),
//                       action: SnackBarAction(
//                         label: '',
//                         onPressed: () {
//                           // Some code to undo the change.
//                         },
//                       ),
//                     );
//                     ScaffoldMessenger.of(context).showSnackBar(snackbar4);
//                   },
//                   child: CircleAvatar(
//                     radius: 25,
//                     child: Icon(Icons.arrow_forward_ios,color: Colors.yellow,),
//                   ),
//                 ),
//               ],
//             ),   SizedBox(height: sHeight(4, context),),
//             Row(
//               children: [
//                 SizedBox(width: sWidth(6, context),),
//                 Text("Theme2 : Moon Light",style: TextStyle(fontFamily: "Yaahowu"),),
//               ],
//             ),
//             SizedBox(height: sHeight(4, context),),
//             SingleChildScrollView(scrollDirection: Axis.horizontal,
//               child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   SizedBox(width: sWidth(6, context),),
//                   Container(
//                     height: sHeight(50, context),width: sWidth(60, context),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.all(Radius.circular(15),),
//                     ),
//                     child: Image.asset('images/themes_images/staff2_temp1.jpeg',height: sHeight(49, context),width: sWidth(69, context),),
//                   ),
//                   SizedBox(width: sWidth(6, context),),
//                   Container(
//                     height: sHeight(50, context),width: sWidth(60, context),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.all(Radius.circular(15),),
//                     ),
//                     child: Image.asset('images/themes_images/staff2_temp2.jpeg',height: sHeight(49, context),width: sWidth(69, context),),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: sHeight(4, context),),
//             Row(
//               children: [
//                 SizedBox(width: sWidth(80, context),),
//                 InkWell(
//                   onTap: ()async{
//                     SharedPreferences prefs = await SharedPreferences.getInstance();
//                     st_temp== prefs.setInt('student', 2);
//                     print("student ${st_temp}");
//                     Navigator.push(context, MaterialPageRoute(builder: (context)=>
//                         profile(username: widget.username, password: widget.password)));
//                     final snackbar4 = SnackBar(
//                       backgroundColor: Colors.green,
//                       content: const Text('Activate This UI once you exit And enter the app'),
//                       action: SnackBarAction(
//                         label: '',
//                         onPressed: () {
//                           // Some code to undo the change.
//                         },
//                       ),
//                     );
//                     ScaffoldMessenger.of(context).showSnackBar(snackbar4);
//                   },
//                   child: CircleAvatar(
//                     radius: 25,
//                     child: Icon(Icons.arrow_forward_ios,color: Colors.yellow,),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//   double sHeight(double per, BuildContext context){
//     double h = MediaQuery.of(context).size.height;
//     return h * per / 100;
//   }
//   double sWidth(double per, BuildContext context){
//     double w = MediaQuery.of(context).size.width;
//     return w * per / 100;
//   }
// }
void setup()async{
  final prefs = await SharedPreferences.getInstance();
  template = prefs.getInt('template')?? 0;
  print('debugging ${prefs.getInt('template')?? 0} and test template $template');
}
void ChangeTemplate( int change)async{
  final prefs = await SharedPreferences.getInstance();
  prefs.setInt('template', change);
  template = change;
}



// setup
SetSetupDone(value)async{
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool('SetupDone', value);
}
GetSetupDone()async{
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('SetupDone') ?? false;
}


