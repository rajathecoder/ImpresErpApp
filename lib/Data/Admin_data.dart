import 'dart:convert';
import 'dart:ffi';
import 'package:add_dev_dolphin/Data/Student_Data.dart';
import 'package:add_dev_dolphin/UI/main_ui.dart';
import 'package:http/http.dart';

//Admin Profile
class Admin_Profile_Data {
  final int staffId;
  final int userId;
  final String staffCode;
  final String staffName;
  final String departmentShortName;
  final String designation;
  final String contact1;
  final String contact2;
  final String staffImg;
  final String login;
  Admin_Profile_Data({
    required this.staffId,
    required this.userId,
    required this.staffCode,
    required this.staffName,
    required this.departmentShortName,
    required this.designation,
    required this.contact1,
    required this.contact2,
    required this.staffImg,
    required this.login,
  });

  factory Admin_Profile_Data.fromJson(Map<String, dynamic> Profile_test) {
    return Admin_Profile_Data(
      staffId: Profile_test["StaffId"],
      userId: Profile_test["UserId"],
      staffCode: Profile_test["StaffCode"],
      staffName: Profile_test["StaffName"],
      departmentShortName: Profile_test["DepartmentShortName"],
      designation: Profile_test["Designation"],
      contact1: Profile_test["Contact1"],
      contact2: Profile_test["Contact2"],
      staffImg: Profile_test["StaffImg"],
      login: Profile_test["login"],
    );
  }
}

class  Admin_Profile_Data_List {
  final List<Admin_Profile_Data> Ad_Prof_list;

  Admin_Profile_Data_List({required this.Ad_Prof_list});

  factory Admin_Profile_Data_List.fromJson(List<dynamic> Admi_Prof_Data_List) {
    List<Admin_Profile_Data> Adprof_cdata = <Admin_Profile_Data>[];
    Adprof_cdata = Admi_Prof_Data_List.map((i) => Admin_Profile_Data.fromJson(i)).toList();
    return new Admin_Profile_Data_List(Ad_Prof_list: Adprof_cdata);
  }
}

class Admin_Profile_Network {
  final String url;

  Admin_Profile_Network(this.url);

  Future<Admin_Profile_Data_List> Admin_Profile_loadData() async {
    final response = await get(Uri.parse("http://$IpAddress/api/$url"));
    if (response.statusCode == 200) {
      return Admin_Profile_Data_List.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load data");
    }
  }
}

//academic year data API
class AcadyearData {
  final String acadYear;

  AcadyearData({
    required this.acadYear,
  });

  factory AcadyearData.fromJson(Map<String, dynamic> dep_test) {
    return AcadyearData(
      acadYear: dep_test["AcadYear"],
    );
  }
}

class Acad_DataList {
  final List<AcadyearData> acad_list;

  Acad_DataList({required this.acad_list});

  factory Acad_DataList.fromJson(List<dynamic> CData_List) {
    List<AcadyearData> dep_cdata = <AcadyearData>[];
    dep_cdata = CData_List.map((i) => AcadyearData.fromJson(i)).toList();
    return new Acad_DataList(acad_list: dep_cdata);
  }
}

class Acad_Network {
  final String url;

  Acad_Network(this.url);

  Future<Acad_DataList> Acad_loadData() async {
    final response = await get(Uri.parse("http://$IpAddress/api/$url"));
    if (response.statusCode == 200) {
      return Acad_DataList.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load data");
    }
  }
}

//Department Collection Details
class Dep_DataList {
  final List<Dep_Cdata> dep_list;

  Dep_DataList({required this.dep_list});

  factory Dep_DataList.fromJson(List<dynamic> CData_List) {
    List<Dep_Cdata> dep_cdata = <Dep_Cdata>[];
    dep_cdata = CData_List.map((i) => Dep_Cdata.fromJson(i)).toList();
    return new Dep_DataList(dep_list: dep_cdata);
  }
}

class Dep_Cdata {
  final String instId;
  final String instName;
  final int demand;
  final int collection;
  final int concession;
  final int balance;
  final int fg;
  final int instCon;
  final int st;
  final String deptName;
  final int classId;
  final String welcomeClass;
  final String feeMain;
  final String feeSub;

  Dep_Cdata({
    required this.instId,
    required this.instName,
    required this.demand,
    required this.collection,
    required this.concession,
    required this.balance,
    required this.fg,
    required this.instCon,
    required this.st,
    required this.deptName,
    required this.classId,
    required this.welcomeClass,
    required this.feeMain,
    required this.feeSub,
  });

  factory Dep_Cdata.fromJson(Map<String, dynamic> dep_test) {
    return Dep_Cdata(
      instId: dep_test["InstId"],
      instName: dep_test["InstName"],
      demand: dep_test["Demand"],
      collection: dep_test["Collection"],
      concession: dep_test["Concession"],
      balance: dep_test["Balance"],
      fg: dep_test["FG"],
      instCon: dep_test["InstCon"],
      st: dep_test["ST"],
      deptName: dep_test["DeptName"],
      classId: dep_test["ClassId"],
      welcomeClass: dep_test["Class"],
      feeMain: dep_test["FeeMain"],
      feeSub: dep_test["FeeSub"],
    );
  }
}

class Collection_Network {
  final String url;

  Collection_Network(this.url);

  Future<Dep_DataList> DC_loadData() async {
    final response = await get(Uri.parse("http://$IpAddress/api/$url"));
    if (response.statusCode == 200) {
      return Dep_DataList.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load data");
    }
  }
}

//Institute Collection and Class Collection network
class InstCollection_Network {
  final String url;

  InstCollection_Network(this.url);

  Future<Dep_DataList> IC_loadData() async {
    final response = await get(Uri.parse("http://$IpAddress/api/$url"));
    if (response.statusCode == 200) {
      return Dep_DataList.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load data");
    }
  }
}

class ClassCollection_Network {
  final String url;

  ClassCollection_Network(this.url);

  Future<Dep_DataList> CL_loadData() async {
    final response = await get(Uri.parse("http://$IpAddress/api/$url"));
    if (response.statusCode == 200) {
      return Dep_DataList.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load data");
    }
  }
}

class Feecate_Network {
  final String url;

  Feecate_Network(this.url);

  Future<Dep_DataList> Fee_loadData() async {
    final response = await get(Uri.parse("http://$IpAddress/api/$url"));
    if (response.statusCode == 200) {
      return Dep_DataList.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load data");
    }
  }
}

//Search student and fee collection API
class StuSearch_List {
  final List<SearchStu> stusearch_list;

  StuSearch_List({required this.stusearch_list});

  factory StuSearch_List.fromJson(
      List<dynamic> AttendanceDetailsAPI_Data_List) {
    List<SearchStu> searchstu_data = <SearchStu>[];
    searchstu_data =
        AttendanceDetailsAPI_Data_List.map((i) => SearchStu.fromJson(i))
            .toList();
    return new StuSearch_List(stusearch_list: searchstu_data);
  }
}

class SearchStu {
  final String studentName;
  final String rollNum;
  final String regNo;
  final String impresCode;
  final String quota;
  final String community;
  final String studentType;
  final String firstGraduate;
  final String gender;
  final String status;
  final String admissionType;
  final String hostel;
  final String transport;
  final String password;
  final String dateOfBirth;
  final String bloodGroup;
  final String hostelName;
  final String hostelRoom;
  final String transportRoute;
  final String transportStage;
  final String batchYear;
  final String fatherName;
  final String motherName;
  final String guardianName;
  final String eMailId;
  final String studentMobileNo;
  final String fatherMobileNo;
  final String motherMobileNo;
  final String guardianMobileNo;
  final String courseFullName;
  final String picture;
  final String insurance;
  final String motherTongue;
  final String currentYear;
  final dynamic test;
  List<FeeHistory> feeHistoryAcadYear;
  List<FeeHistory> feeHistorySemester;

  SearchStu({
    required this.studentName,
    required this.rollNum,
    required this.regNo,
    required this.impresCode,
    required this.quota,
    required this.community,
    required this.studentType,
    required this.firstGraduate,
    required this.gender,
    required this.status,
    required this.admissionType,
    required this.hostel,
    required this.transport,
    required this.password,
    required this.dateOfBirth,
    required this.bloodGroup,
    required this.hostelName,
    required this.hostelRoom,
    required this.transportRoute,
    required this.transportStage,
    required this.batchYear,
    required this.fatherName,
    required this.motherName,
    required this.guardianName,
    required this.eMailId,
    required this.studentMobileNo,
    required this.fatherMobileNo,
    required this.motherMobileNo,
    required this.guardianMobileNo,
    required this.courseFullName,
    required this.picture,
    required this.insurance,
    required this.motherTongue,
    required this.currentYear,
    required this.test,
    required this.feeHistoryAcadYear,
    required this.feeHistorySemester,
  });

  factory SearchStu.fromJson(Map<String, dynamic> SearchStu_test) {
    return SearchStu(
      studentName: SearchStu_test["StudentName"],
      rollNum: SearchStu_test["RollNum"],
      regNo: SearchStu_test["RegNo"],
      impresCode: SearchStu_test["ImpresCode"],
      quota: SearchStu_test["Quota"],
      community: SearchStu_test["Community"],
      studentType: SearchStu_test["StudentType"],
      firstGraduate: SearchStu_test["FirstGraduate"],
      gender: SearchStu_test["Gender"],
      status: SearchStu_test["Status"],
      admissionType: SearchStu_test["AdmissionType"],
      hostel: SearchStu_test["Hostel"],
      transport: SearchStu_test["Transport"],
      password: SearchStu_test["Password"],
      dateOfBirth: SearchStu_test["DateOfBirth"],
      bloodGroup: SearchStu_test["BloodGroup"],
      hostelName: SearchStu_test["HostelName"],
      hostelRoom: SearchStu_test["HostelRoom"],
      transportRoute: SearchStu_test["TransportRoute"],
      transportStage: SearchStu_test["TransportStage"],
      batchYear: SearchStu_test["BatchYear"],
      fatherName: SearchStu_test["FatherName"],
      motherName: SearchStu_test["MotherName"],
      guardianName: SearchStu_test["GuardianName"],
      eMailId: SearchStu_test["EMailID"],
      studentMobileNo: SearchStu_test["StudentMobileNo"],
      fatherMobileNo: SearchStu_test["FatherMobileNo"],
      motherMobileNo: SearchStu_test["MotherMobileNo"],
      guardianMobileNo: SearchStu_test["GuardianMobileNo"],
      courseFullName: SearchStu_test["CourseFullName"],
      picture: SearchStu_test["Picture"],
      insurance: SearchStu_test["Insurance"],
      motherTongue: SearchStu_test["MotherTongue"],
      currentYear: SearchStu_test["CurrentYear"],
      test: SearchStu_test["Test"],
      feeHistoryAcadYear: List<FeeHistory>.from(
          SearchStu_test["FeeHistoryAcadYear"]
              .map((x) => FeeHistory.fromJson(x))),
      feeHistorySemester: List<FeeHistory>.from(
          SearchStu_test["FeeHistorySemester"]
              .map((x) => FeeHistory.fromJson(x))),
    );
  }
}

class FeeHistory {
  FeeHistory({
    required this.acadYear,
    required this.demand,
    required this.collection,
    required this.concession,
    required this.balance,
    required this.fine,
    required this.feeHistoryClass,
    required this.yr,
    required this.semester,
  });

  String acadYear;
  int demand;
  int collection;
  int concession;
  int balance;
  int fine;
  String feeHistoryClass;
  int yr;
  String semester;

  factory FeeHistory.fromJson(Map<String, dynamic> json) => FeeHistory(
        acadYear: json["AcadYear"],
        demand: json["Demand"],
        collection: json["Collection"],
        concession: json["Concession"],
        balance: json["Balance"],
        fine: json["Fine"],
        feeHistoryClass: json["Class"],
        yr: json["Yr"],
        semester: json["Semester"] == null ? null : json["Semester"],
      );

  Map<String, dynamic> toJson() => {
        "AcadYear": acadYear,
        "Demand": demand,
        "Collection": collection,
        "Concession": concession,
        "Balance": balance,
        "Fine": fine,
        "Class": feeHistoryClass,
        "Yr": yr,
        "Semester": semester == null ? null : semester,
      };
}

class Search_Network {
  final String url;

  Search_Network(this.url);

  Future<StuSearch_List> S_loadData() async {
    final response =
        await get(Uri.parse("http://$ip/api/${url}"));
    if (response.statusCode == 200) {
      return StuSearch_List.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load data");
    }
  }
}

// Hostel data
class Host_DataList {
  final List<Host_Cdata> dep_list;

  Host_DataList({required this.dep_list});

  factory Host_DataList.fromJson(List<dynamic> CData_List) {
    List<Host_Cdata> dep_cdata = <Host_Cdata>[];
    dep_cdata = CData_List.map((i) => Host_Cdata.fromJson(i)).toList();
    return new Host_DataList(dep_list: dep_cdata);
  }
}

class Host_Cdata {
  final String hostelName;
  final String district;
  final int count;

  Host_Cdata({
    required this.hostelName,
    required this.district,
    required this.count,
  });

  factory Host_Cdata.fromJson(Map<String, dynamic> hos_test) {
    return Host_Cdata(
      hostelName: hos_test["HostelName"],
      district: hos_test["District"],
      count: hos_test["Count"],
    );
  }
}

class Hostel_Network {
  final String url;

  Hostel_Network(this.url);

  Future<Host_DataList> Hos_loadData() async {
    final response = await get(Uri.parse("http://$IpAddress/api/$url"));
    if (response.statusCode == 200) {
      return Host_DataList.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load data");
    }
  }
}

//Student Transports API
class Trans_DataList {
  final List<Trans_Cdata> dep_list;

  Trans_DataList({required this.dep_list});

  factory Trans_DataList.fromJson(List<dynamic> CData_List) {
    List<Trans_Cdata> dep_cdata = <Trans_Cdata>[];
    dep_cdata = CData_List.map((i) => Trans_Cdata.fromJson(i)).toList();
    return new Trans_DataList(dep_list: dep_cdata);
  }
}

class Trans_Cdata {
  final String routeName;
  final String routeShortName;
  final int count;

  Trans_Cdata({
    required this.routeName,
    required this.routeShortName,
    required this.count,
  });

  factory Trans_Cdata.fromJson(Map<String, dynamic> trans_test) {
    return Trans_Cdata(
      routeName: trans_test["RouteName"],
      routeShortName: trans_test["RouteShortName"],
      count: trans_test["Count"],
    );
  }
}

class Trans_Network {
  final String url;

  Trans_Network(this.url);

  Future<Trans_DataList> Trans_loadData() async {
    final response = await get(Uri.parse("http://$IpAddress/api/$url"));
    if (response.statusCode == 200) {
      return Trans_DataList.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load data");
    }
  }
}

// Date Wise Collection data
class Date_Collection_Data_list {
  final List<Date_Collection_Data> Datec_list;

  Date_Collection_Data_list({required this.Datec_list});

  factory Date_Collection_Data_list.fromJson(List<dynamic> CData_List) {
    List<Date_Collection_Data> dep_cdata = <Date_Collection_Data>[];
    dep_cdata = CData_List.map((i) => Date_Collection_Data.fromJson(i)).toList();
    return new Date_Collection_Data_list(Datec_list: dep_cdata);
  }
}

class Date_Collection_Data{
 final double bank;
 final double cash;
 final double total;
 final double fineBank;
 final double fineCash;
 final double fineTotal;
 final double bankTotal;
 final double cashTotal;
 final double grandTotal;
 final String fee;
 Date_Collection_Data({
   required this.bank,
   required this.cash,
   required this.total,
   required this.fineBank,
   required this.fineCash,
   required this.fineTotal,
   required this.bankTotal,
   required this.cashTotal,
   required this.grandTotal,
   required this.fee,
 });
 factory Date_Collection_Data.fromJson(Map<String, dynamic> date_c) {
   return Date_Collection_Data(
     bank: date_c["Bank"],
     cash: date_c["Cash"],
     total: date_c["Total"],
     fineBank: date_c["FineBank"],
     fineCash: date_c["FineCash"],
     fineTotal: date_c["FineTotal"],
     bankTotal: date_c["BankTotal"],
     cashTotal: date_c["CashTotal"],
     grandTotal: date_c["GrandTotal"],
     fee: date_c["Fee"],
   );
 }

}

class Date_Collect_Network {
  final String url;

  Date_Collect_Network(this.url);

  Future<Date_Collection_Data_list> DateCol_loadData() async {
    final response = await get(Uri.parse("http://$IpAddress/api/$url"));
    if (response.statusCode == 200) {
      return Date_Collection_Data_list.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load data");
    }
  }
}

// Date Wise Collection Total Data
class Date_collect_Total_Data_list {
  final List<Date_collect_Total_Data> Datec_Tolist;

  Date_collect_Total_Data_list({required this.Datec_Tolist});

  factory Date_collect_Total_Data_list.fromJson(List<dynamic> CData_List) {
    List<Date_collect_Total_Data> dep_Tcdata = <Date_collect_Total_Data>[];
    dep_Tcdata = CData_List.map((i) => Date_collect_Total_Data.fromJson(i)).toList();
    return new Date_collect_Total_Data_list(Datec_Tolist: dep_Tcdata);
  }
}

class Date_collect_Total_Data{
  final double bank;
  final double cash;
  final double total;
  final double fineBank;
  final double fineCash;
  final double fineTotal;
  final double bankTotal;
  final double cashTotal;
  final double grandTotal;
  Date_collect_Total_Data({
    required this.bank,
    required this.cash,
    required this.total,
    required this.fineBank,
    required this.fineCash,
    required this.fineTotal,
    required this.bankTotal,
    required this.cashTotal,
    required this.grandTotal,
  });
  factory Date_collect_Total_Data.fromJson(Map<String, dynamic> date_T) {
    return Date_collect_Total_Data(
      bank: date_T["Bank"],
      cash: date_T["Cash"],
      total: date_T["Total"],
      fineBank: date_T["FineBank"],
      fineCash: date_T["FineCash"],
      fineTotal: date_T["FineTotal"],
      bankTotal: date_T["BankTotal"],
      cashTotal: date_T["CashTotal"],
      grandTotal: date_T["GrandTotal"],
    );
  }

}

class Date_Collect_Total_Network {
  final String url;

  Date_Collect_Total_Network(this.url);

  Future<Date_collect_Total_Data_list> DateCol_Total_loadData() async {
    final response = await get(Uri.parse("http://$IpAddress/api/$url"));
    if (response.statusCode == 200) {
      return Date_collect_Total_Data_list.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load data for Internal Server Error");
    }
  }
}

//Admission Report
class Admin_ReportList {
  final List<Admin_Rdata> AdminReport_list;

  Admin_ReportList({required this.AdminReport_list});

  factory Admin_ReportList.fromJson(List<dynamic> APData_List) {
    List<Admin_Rdata> Admin_Reportdata = <Admin_Rdata>[];
    Admin_Reportdata = APData_List.map((i) => Admin_Rdata.fromJson(i)).toList();
    return new Admin_ReportList(AdminReport_list: Admin_Reportdata);
  }
}

class Admin_Rdata {
  final int id;
  final String course;
  final int totalseats;
  final int additionalseats;
  final int enquirymale;
  final int enquiryfemale;
  final int totalenquiry;
  final int admissionmale;
  final int admissionfemale;
  final int totaladmission;
  final int disconmale;
  final int disconfemale;
  final int totaldiscon;
  final int grandmale;
  final int grandfemale;
  final int grandtotal;
  final int vacancy;
  Admin_Rdata({
    required this.id,
    required this.course,
    required this.totalseats,
    required this.additionalseats,
    required this.enquirymale,
    required this.enquiryfemale,
    required this.totalenquiry,
    required this.admissionmale,
    required this.admissionfemale,
    required this.totaladmission,
    required this.disconmale,
    required this.disconfemale,
    required this.totaldiscon,
    required this.grandmale,
    required this.grandfemale,
    required this.grandtotal,
    required this.vacancy,
  });

  factory Admin_Rdata.fromJson(Map<String, dynamic> Admin_test) {
    return Admin_Rdata(
      id: Admin_test["id"],
      course: Admin_test["course"],
      totalseats: Admin_test["totalseats"],
      additionalseats: Admin_test["additionalseats"],
      enquirymale: Admin_test["enquirymale"],
      enquiryfemale: Admin_test["enquiryfemale"],
      totalenquiry: Admin_test["totalenquiry"],
      admissionmale: Admin_test["admissionmale"],
      admissionfemale: Admin_test["admissionfemale"],
      totaladmission: Admin_test["totaladmission"],
      disconmale: Admin_test["disconmale"],
      disconfemale: Admin_test["disconfemale"],
      totaldiscon: Admin_test["totaldiscon"],
      grandmale: Admin_test["grandmale"],
      grandfemale: Admin_test["grandfemale"],
      grandtotal: Admin_test["grandtotal"],
      vacancy: Admin_test["vacancy"],
    );
  }
}

class AdminReport_Network {
  final String url;

  AdminReport_Network(this.url);

  Future<Admin_ReportList> AdminRep_loadData() async {
    final response = await get(Uri.parse("http://$IpAddress/api/$url"));
    if (response.statusCode == 200) {
      return Admin_ReportList.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load data");
    }
  }
}






