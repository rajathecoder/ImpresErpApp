import 'package:add_dev_dolphin/Data/Admin_data.dart';
import 'package:add_dev_dolphin/Style_font/designs.dart';
import 'package:add_dev_dolphin/main.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
//search student
class Search_Students extends StatefulWidget {
  const Search_Students({Key? key, required this.username, required this.password,required this.regno}) : super(key: key);
  final String username;
  final String password;
  final String regno;
  @override
  State<Search_Students> createState() => _Search_StudentsState();
}

class _Search_StudentsState extends State<Search_Students> {
  late Future<StuSearch_List> HisData;
  void initState() {
    // TODO: implement initState
    super.initState();
    Search_Network search_network = Search_Network(
        "StudentSearch?StaffCode=${widget.username}&StudentCode=${widget.regno}&Password=RG9scGhpbkFkbWluMTIzIUA=");
    HisData = search_network.S_loadData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: HisData,
        builder: (context, AsyncSnapshot<StuSearch_List> snapshot) {
          if (snapshot.hasError) {
            ErrorShowingWidget(context);
          }
          List<SearchStu> data;
          if (snapshot.hasData) {
            data = snapshot.data!.stusearch_list;
            if (data.length > 0) {
              return Scaffold(
                backgroundColor: const Color.fromRGBO(242, 249, 255, 0.9),
                appBar: AppBar(
                  title: Text("Student Details", style: PrimaryText(context)),
                  backgroundColor: const Color(0xFF6762FF),
                ),
                body: Builder(
                  builder: (BuildContext context) => SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: sHeight(3, context),
                        ),
                        Container(
                          width: sWidth(90, context),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: sHeight(2, context),
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: sWidth(4, context),
                                    ),
                                    CircleAvatar(
                                      radius: 55,
                                      child: Stack(
                                        children: [
                                          const Center(
                                              child:
                                              CircularProgressIndicator()),
                                          CircleAvatar(
                                            backgroundColor: const Color.fromRGBO(218, 239, 245, 0.1),
                                            radius: 55,
                                            backgroundImage: NetworkImage(
                                                "${StudentImageIP}${data[0].picture}"),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: sWidth(4, context),
                                    ),
                                    Column(
                                      children: [
                                        RichText(
                                          text: new TextSpan(
                                            children: <TextSpan>[
                                              new TextSpan(
                                                  text:
                                                  "${data[0].studentName}",
                                                  style: const TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                      FontWeight.w900,
                                                      fontSize: 20)),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: sHeight(1, context),
                                        ),
                                        Container(
                                          child: Row(
                                            children: [
                                              Text(
                                                "Course : ${data[0].courseFullName}",
                                                style: const TextStyle(fontSize: 13),
                                              ),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              Text(
                                                "Year : ${data[0].currentYear}",
                                                style: const TextStyle(fontSize: 13),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: sHeight(2, context),
                                        ),
                                        Text(
                                          "Regno : ${data[0].regNo}",
                                          style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.black),
                                        ),
                                      ],
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
                        SizedBox(
                          height: sHeight(2, context),
                        ),
                        for (int i = data[0].feeHistoryAcadYear.length - 1;
                        i >= 0;
                        i--)
                          Container(
                            child: Column(
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
                                    children: [
                                      SizedBox(
                                        height: sHeight(1.5, context),
                                      ),
                                      const Text(
                                        "FEE HISTORY ACADEMIC YEAR",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF6762FF)),
                                      ),
                                      Text(
                                          "${data[0].feeHistoryAcadYear[i].acadYear}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF6762FF))),
                                      SizedBox(
                                        height: sHeight(1.5, context),
                                      ),
                                      Container(
                                        width: sWidth(80, context),
                                        child: DataTable(
                                            border: TableBorder.all(
                                              //style: BorderStyle.solid,
                                              width: 1,
                                            ),
                                            showBottomBorder: true,
                                            showCheckboxColumn: true,
                                            sortAscending: true,
                                            dividerThickness: 2,
                                            columns: [
                                              const DataColumn(
                                                label: Text("Detail"),
                                              ),
                                              const DataColumn(
                                                label: Text('Amount'),
                                              ),
                                              /* DataColumn(
                                                      label: Text('Amount'),
                                                    ),*/
                                            ],
                                            rows: [
                                              DataRow(cells: [
                                                const DataCell(Text("Demand")),
                                                DataCell(
                                                  Text(
                                                    NumberFormat.currency(
                                                      symbol: '₹ ',
                                                      locale: "HI",
                                                      decimalDigits: 2,
                                                    ).format(data[0].feeHistoryAcadYear[i].demand),
                                                  ),
                                                ),
                                                // DataCell(Text("${data[i].balance}")),
                                              ]),
                                              DataRow(cells: [
                                                const DataCell(Text("Collection")),
                                                DataCell(  Text(
                                                  NumberFormat.currency(
                                                    symbol: '₹ ',
                                                    locale: "HI",
                                                    decimalDigits: 2,
                                                  ).format(data[0].feeHistoryAcadYear[i].collection),
                                                ),),
                                                // DataCell(Text("${data[i].balance}")),
                                              ]),
                                              DataRow(cells: [
                                                const DataCell(Text("Concession")),
                                                DataCell(  Text(
                                                  NumberFormat.currency(
                                                    symbol: '₹ ',
                                                    locale: "HI",
                                                    decimalDigits: 2,
                                                  ).format(data[0].feeHistoryAcadYear[i].concession),
                                                ),),
                                              ]),
                                              DataRow(cells: [
                                                const DataCell(Text("Balance")),
                                                DataCell(  Text(
                                                  NumberFormat.currency(
                                                    symbol: '₹ ',
                                                    locale: "HI",
                                                    decimalDigits: 2,
                                                  ).format(data[0].feeHistoryAcadYear[i].balance),
                                                ),),
                                              ]),
                                              DataRow(cells: [
                                                const DataCell(Text("Fine")),
                                                DataCell(  Text(
                                                  NumberFormat.currency(
                                                    symbol: '₹ ',
                                                    locale: "HI",
                                                    decimalDigits: 2,
                                                  ).format(data[0].feeHistoryAcadYear[i].fine),
                                                ),),

                                                // DataCell(Text("${data[i].balance}")),
                                              ]),
                                            ]),
                                      ),
                                      SizedBox(
                                        height: sHeight(1.5, context),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        SizedBox(
                          height: sHeight(2, context),
                        ),
                        for (int i = data[0].feeHistorySemester.length - 1;
                        i >= 0;
                        i--)
                          Container(
                            child: Column(
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
                                    children: [
                                      SizedBox(
                                        height: sHeight(1.5, context),
                                      ),
                                      const Text(
                                        "FEE HISTORY SEMESTER WISE",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF6762FF)),
                                      ),
                                      SizedBox(
                                        height: sHeight(1.5, context),
                                      ),
                                      Container(
                                          width: sWidth(80, context),
                                          decoration: const BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(5),
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Center(
                                                  child: Text(
                                                      "${data[0].feeHistorySemester[i].semester}",
                                                      style: const TextStyle(
                                                          fontWeight:
                                                          FontWeight.w600,
                                                          color:
                                                          Colors.white))),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          )),
                                      SizedBox(
                                        height: sHeight(1.5, context),
                                      ),
                                      Container(
                                        width: sWidth(80, context),
                                        child: DataTable(
                                            border: TableBorder.all(
                                              //style: BorderStyle.solid,
                                              width: 1,
                                            ),
                                            showBottomBorder: true,
                                            showCheckboxColumn: true,
                                            sortAscending: true,
                                            dividerThickness: 2,
                                            columns: [
                                              const DataColumn(
                                                label: Text("Detail"),
                                              ),
                                              const DataColumn(
                                                label: Text('Amount'),
                                              ),
                                              /* DataColumn(
                                                        label: Text('Amount'),
                                                      ),*/
                                            ],
                                            rows: [
                                              DataRow(cells: [
                                                const DataCell(Text("Demand")),
                                                DataCell(  Text(
                                                  NumberFormat.currency(
                                                    symbol: '₹ ',
                                                    locale: "HI",
                                                    decimalDigits: 2,
                                                  ).format(data[0].feeHistorySemester[i].demand),
                                                ),),
                                                // DataCell(Text("${data[i].balance}")),
                                              ]),
                                              DataRow(cells: [
                                                const DataCell(Text("Collection")),
                                                DataCell(Text(
                                                  NumberFormat.currency(
                                                    symbol: '₹ ',
                                                    locale: "HI",
                                                    decimalDigits: 2,
                                                  ).format(data[0].feeHistorySemester[i].collection),
                                                ),),
                                                // DataCell(Text("${data[i].balance}")),
                                              ]),
                                              DataRow(cells: [
                                                const DataCell(Text("Concession")),
                                                DataCell(Text(
                                                  NumberFormat.currency(
                                                    symbol: '₹ ',
                                                    locale: "HI",
                                                    decimalDigits: 2,
                                                  ).format(data[0].feeHistorySemester[i].concession),
                                                ),),
                                                // DataCell(Text("${data[i].balance}")),
                                              ]),
                                              DataRow(cells: [
                                                const DataCell(Text("Balance")),
                                                DataCell(Text(
                                                  NumberFormat.currency(
                                                    symbol: '₹ ',
                                                    locale: "HI",
                                                    decimalDigits: 2,
                                                  ).format(data[0].feeHistorySemester[i].balance),
                                                ),),

                                                // DataCell(Text("${data[i].balance}")),
                                              ]),
                                              DataRow(cells: [
                                                const DataCell(Text("Fine")),
                                                DataCell(Text(
                                                  NumberFormat.currency(
                                                    symbol: '₹ ',
                                                    locale: "HI",
                                                    decimalDigits: 2,
                                                  ).format(data[0].feeHistorySemester[i].fine),
                                                ),),

                                                // DataCell(Text("${data[i].balance}")),
                                              ]),
                                            ]),
                                      ),
                                      SizedBox(
                                        height: sHeight(1.5, context),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        Container(
                          margin: const EdgeInsets.only(top: 20.0),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Scaffold(
                backgroundColor: const Color.fromRGBO(242, 249, 255, 0.9),
                appBar: AppBar(
                  title: Text("Student Details", style: PrimaryText(context)),
                  backgroundColor: const Color(0xFF6762FF),
                ),
                body: Center(
                  child: Image.asset("images/Dataimg/data_not_found.png"),
                ),
              );
            }
          } else {
            return Container(
              child: Center(child: StudentsSearching(context)),
              color: Colors.white,
            );
          }
        });
  }
}

//Inst Fee Collections
class Department_Colection extends StatefulWidget {
  const Department_Colection(
      {Key? key, required this.username, required this.password})
      : super(key: key);
  final String username;
  final String password;

  @override
  State<Department_Colection> createState() => _Department_ColectionState();
}

class _Department_ColectionState extends State<Department_Colection> {
  DateTime now = DateTime.now();
  late Future<Dep_DataList> APID_Data;
  late Future<Dep_DataList> APP_Data;
  late Future<Acad_DataList> APIacad_Data;
  String? first;
  String? last;
  late List<String> SearchType1 = ['Department wise','Class wise'];
  late List<String> AcadamicYearList = [];
  bool cla = false;
  bool dept = false;
  Col_net() async {
    Collection_Network collection_network = Collection_Network(
        "InstdCB?StaffCode=${widget.username}&AcadYear=${first}%20-%20${last}&Type=DEPT&InstId=0&Password=${widget.password}");
    APID_Data = collection_network.DC_loadData();
  }
  cla_net() async {
    ClassCollection_Network classCollection_Network = ClassCollection_Network(
        "InstdCB?StaffCode=${widget.username}&AcadYear=${first}%20-%20${last}&Type=CLASS&InstId=0&Password=${widget.password}");
    APP_Data = classCollection_Network.CL_loadData();
  }
  bool Cla_De_DR = false;
  // category total Collection Data
  late List<String> Select_Method = ['Total Collection','Category wise collection','Class wise/Department wise'];
  late Future<Date_Collection_Data_list> APIDate_Data;
  late Future<Date_collect_Total_Data_list> APITotal_Data;
  bool dateB = false;
  bool dateDro = false;
  bool partDro = false;
  bool partDro_To = false;
  bool Cate_Dro1 = false;
  bool Date_T_B = true;
  bool Cate_Dro2 = true;
  bool Date_sel_To = false;
  String ATdate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  String? PartDate = 'Choose';
  String? PartDate_Total = 'Choose';
  String frDate =  DateFormat('dd/MM/yyyy').format(DateTime.now().subtract(const Duration(days: 365)));
  String ToDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  String frDate2 =  DateFormat('dd/MM/yyyy').format(DateTime.now().subtract(const Duration(days: 365)));
  String ToDate2 = DateFormat('dd/MM/yyyy').format(DateTime.now());
  String Total_Col_Yester = DateFormat('dd/MM/yyyy').format(DateTime.now().subtract(const Duration(days: 1)));
  String Total_Col_LMdate = DateFormat('dd/MM/yyyy').format(DateTime.now().subtract(const Duration(days: 31)));
  late List<String> DateCheck = [
    'Today($ATdate)','Yesterday($Total_Col_Yester)','This Month($Total_Col_LMdate) to ($ATdate)','This Academic Year (01/06/${academicYear.toString().characters.take(4).toString()}) to (31/05/${academicYear.toString().characters.takeLast(4).toString()})','Particular Date','From to date',
  ];
  late List<String> DateCheck2 = [
    'Today($ATdate)','Yesterday($Total_Col_Yester)','This Month($Total_Col_LMdate) to ($ATdate)','This Academic Year (01/06/${academicYear.toString().characters.take(4).toString()}) to (31/05/${academicYear.toString().characters.takeLast(4).toString()})','Particular Date','From to Date',
  ];
  late List<String> Date_Select_Drop = [
    'Total Collection','Category Wise Collection',
  ];
  DateWise_Collect()async{
    Date_Collect_Network date_collect_network = Date_Collect_Network(
        "FeeCollectionName?InstId=1&FromDateStr=${frDate}&ToDateStr=${ToDate}&IntervalType=2&StaffCode=${widget.username}&Password=${widget.password}"
    );
    APIDate_Data = date_collect_network.DateCol_loadData();
  }
  Today_Collection()async{
    Date_Collect_Network date_collect_network = Date_Collect_Network(
        "FeeCollectionName?InstId=1&FromDateStr=${ATdate}&ToDateStr=${ToDate}&IntervalType=1&StaffCode=${widget.username}&Password=${widget.password}"
    );
    APIDate_Data = date_collect_network.DateCol_loadData();
  }
  PartiCular_Collection()async{
    Date_Collect_Network date_collect_network = Date_Collect_Network(
        "FeeCollectionName?InstId=1&FromDateStr=${PartDate}&ToDateStr=${ToDate}&IntervalType=1&StaffCode=${widget.username}&Password=${widget.password}"
    );
    APIDate_Data = date_collect_network.DateCol_loadData();
  }
  particular_Collection_Total()async{
    Date_Collect_Total_Network date_collect_total_network = Date_Collect_Total_Network(
        "FeeCollection?InstId=1&FromDateStr=${PartDate_Total}&ToDateStr=${ToDate2}&IntervalType=1&StaffCode=${widget.username}&Password=${widget.password}"
    );
    APITotal_Data = date_collect_total_network.DateCol_Total_loadData();
  }
  Today_Collection_Total()async{
    Date_Collect_Total_Network date_collect_total_network = Date_Collect_Total_Network(
        "FeeCollection?InstId=1&FromDateStr=${ATdate}&ToDateStr=${ToDate2}&IntervalType=1&StaffCode=${widget.username}&Password=${widget.password}"
    );
    APITotal_Data = date_collect_total_network.DateCol_Total_loadData();
  }
  Yester_Collection_Total()async{
    Date_Collect_Total_Network date_collect_total_network = Date_Collect_Total_Network(
        "FeeCollection?InstId=1&FromDateStr=${Total_Col_Yester}&ToDateStr=${ToDate2}&IntervalType=1&StaffCode=${widget.username}&Password=${widget.password}"
    );
    APITotal_Data = date_collect_total_network.DateCol_Total_loadData();
  }
  DateWise_Total_collection()async{
    Date_Collect_Total_Network date_collect_total_network = Date_Collect_Total_Network(
        "FeeCollection?InstId=1&FromDateStr=${frDate2}&ToDateStr=${ToDate2}&IntervalType=2&StaffCode=${widget.username}&Password=${widget.password}"
    );
    APITotal_Data = date_collect_total_network.DateCol_Total_loadData();
  }
  Month_Total_Collection()async{
    Date_Collect_Total_Network date_collect_total_network = Date_Collect_Total_Network(
        "FeeCollection?InstId=1&FromDateStr=${Total_Col_LMdate}&ToDateStr=${ATdate}&IntervalType=2&StaffCode=${widget.username}&Password=${widget.password}"
    );
    APITotal_Data = date_collect_total_network.DateCol_Total_loadData();
  }
  Academic_Total_Collection()async{
    Date_Collect_Total_Network date_collect_total_network = Date_Collect_Total_Network(
        "FeeCollection?InstId=1&FromDateStr=01/06/${academicYear.toString().characters.take(4).toString()}&ToDateStr=31/05/${academicYear.toString().characters.takeLast(4).toString()}&IntervalType=2&StaffCode=${widget.username}&Password=${widget.password}"
    );
    APITotal_Data = date_collect_total_network.DateCol_Total_loadData();
  }
  String? academicYear;
  Get_Acdamic_year()async{
    int academicYearStart;
    if (now.month >= 6) {
      academicYearStart = now.year;
    } else {
      academicYearStart = now.year - 1;
    }
    int academicYearEnd = academicYearStart + 1;
   academicYear = '$academicYearStart-$academicYearEnd';
    first = academicYear.toString().characters.take(4).toString();
    last = academicYear.toString().characters.takeLast(4).toString();
  }
  // category Collect New
  Yester_Category_Collect()async{
    Date_Collect_Network date_collect_network = Date_Collect_Network(
        "FeeCollectionName?InstId=1&FromDateStr=${Total_Col_Yester}&ToDateStr=${ToDate}&IntervalType=1&StaffCode=${widget.username}&Password=${widget.password}"
    );
    APIDate_Data = date_collect_network.DateCol_loadData();
  }
  Month_Category_Collect()async{
    Date_Collect_Network date_collect_network = Date_Collect_Network(
        "FeeCollectionName?InstId=1&FromDateStr=${Total_Col_LMdate}&ToDateStr=${ATdate}&IntervalType=2&StaffCode=${widget.username}&Password=${widget.password}"
    );
    APIDate_Data = date_collect_network.DateCol_loadData();
  }
  Acadamic_Category_Collect()async{
    Date_Collect_Network date_collect_network = Date_Collect_Network(
        "FeeCollectionName?InstId=1&FromDateStr=01/06/${academicYear.toString().characters.take(4).toString()}&ToDateStr=31/05/${academicYear.toString().characters.takeLast(4).toString()}&IntervalType=2&StaffCode=${widget.username}&Password=${widget.password}"
    );
    APIDate_Data = date_collect_network.DateCol_loadData();
  }
  void initState() {
    // TODO: implement initState
    super.initState();
    Get_Acdamic_year();
    Col_net();
    cla_net();
    DateWise_Collect();
    Today_Collection_Total();
    // DateWise_Total_collection();
    Acad_Network acad_network = Acad_Network(
        "acadyear?StaffCode=${widget.username}&Password=${widget.password}");
    APIacad_Data = acad_network.Acad_loadData();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: APIacad_Data,
        builder: (context, AsyncSnapshot<Acad_DataList> acadsnapshot) {
          if (acadsnapshot.hasError) {
            ErrorShowingWidget(context);
          }
          List<AcadyearData> acaddata;
          if (acadsnapshot.hasData) {
            acaddata = acadsnapshot.data!.acad_list;
            AcadamicYearList = [
              for (int i = acaddata.length - 1; i >= 0; i--)
                acaddata[i].acadYear
            ];
            return FutureBuilder(
                future: APID_Data,
                builder: (context, AsyncSnapshot<Dep_DataList> apidsnapshot) {
                  if (apidsnapshot.hasError) {
                    ErrorShowingWidget(context);
                  }
                  List<Dep_Cdata> deptdata;
                  if (apidsnapshot.hasData) {
                    deptdata = apidsnapshot.data!.dep_list;
                    return FutureBuilder(
                        future: APITotal_Data,
                        builder: (context, AsyncSnapshot<Date_collect_Total_Data_list> feeTotalsnapshot) {
                          if (feeTotalsnapshot.hasError) {
                            ErrorShowingWidget(context);
                          }
                          List<Date_collect_Total_Data> feeTotaldata;
                          if (feeTotalsnapshot.hasData) {
                            feeTotaldata = feeTotalsnapshot.data!.Datec_Tolist;
                            return FutureBuilder(
                                future: APIDate_Data,
                                builder: (context, AsyncSnapshot<
                                    Date_Collection_Data_list> datesnapshot) {
                                  if (datesnapshot.hasError) {
                                    ErrorShowingWidget(context);
                                  }
                                  List<Date_Collection_Data> dateCdata;
                                  if (datesnapshot.hasData) {
                                    dateCdata = datesnapshot.data!.Datec_list;
                                   return FutureBuilder(
                                      future: APP_Data,
                                           builder:
                                        (context, AsyncSnapshot<Dep_DataList> snapshot) {
                                           if (snapshot.hasError) {
                                           ErrorShowingWidget(context);
                                         }
                                        List<Dep_Cdata> classdata;
                                          if (snapshot.hasData) {
                                          classdata = snapshot.data!.dep_list;
                                           return Scaffold(
                                           backgroundColor:
                                               const Color.fromRGBO(242, 249, 255, 0.9),
                                              appBar: AppBar(
                                                   title: Text("Collections",
                                                          style: PrimaryText(context)),
                                                backgroundColor: const Color(0xFF6762FF),
                                                         ),
                                                      body: Builder(
                                           builder: (BuildContext context) =>
                                          SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: Center(
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    height: sHeight(2, context),
                                                  ),
                                                  Container(
                                                    height: sHeight(5, context),
                                                    width: sWidth(90, context),
                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(7),color: Colors.white),

                                                    child:
                                                    DropdownSearch<String>(
                                                      popupProps: const PopupProps.menu(),
                                                      dropdownDecoratorProps: const DropDownDecoratorProps(),
                                                      dropdownButtonProps:
                                                      const DropdownButtonProps(
                                                        // padding: EdgeInsets.symmetric(horizontal: 20.0),
                                                          icon: Icon(Icons
                                                              .arrow_drop_down_circle_rounded),
                                                          color: Color(0xff6762FF)),
                                                      items: Select_Method,
                                                      selectedItem: Select_Method[0],
                                                      onChanged: (value) {
                                                        if (value.toString() == 'Class wise/Department wise'.toString()) {
                                                          Cla_De_DR = true;
                                                          dept = true;
                                                          cla = false;
                                                           dateB = false;
                                                           dateDro = false;
                                                           partDro = false;
                                                           partDro_To = false;
                                                           Cate_Dro1 = false;
                                                           Date_T_B = false;
                                                           Cate_Dro2 = false;
                                                           Date_sel_To = false;
                                                          setState(() {});
                                                        }
                                                        if (value.toString() == 'Category wise collection'.toString()) {
                                                          Cla_De_DR = false;
                                                          dept = false;
                                                          cla = false;
                                                          dateB = false;
                                                          dateDro = false;
                                                          partDro = false;
                                                          partDro_To = false;
                                                          Date_T_B = false;
                                                          Cate_Dro2 = false;
                                                          Date_sel_To = false;
                                                          Cate_Dro1 = true;
                                                          setState(() {});
                                                        }
                                                        if (value.toString() == 'Total Collection'.toString()) {
                                                          Cla_De_DR = false;
                                                          dept = false;
                                                          cla = false;
                                                          dateB = false;
                                                          dateDro = false;
                                                          partDro = false;
                                                          partDro_To = false;
                                                          Date_T_B = false;
                                                          Date_sel_To = false;
                                                          Cate_Dro1 = false;
                                                          Cate_Dro2 = true;
                                                          Cla_De_DR = false;
                                                          setState(() {});
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: sHeight(3, context),
                                                  ),
                                                  Cla_De_DR == true ? Column(
                                                  children: [
                                                    Container(
                                                      height: sHeight(5, context),
                                                      width: sWidth(90, context),
                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(7),color: Colors.white),

                                                      child:
                                                      DropdownSearch<String>(
                                                        popupProps: const PopupProps.menu(),
                                                        dropdownDecoratorProps: const DropDownDecoratorProps(),
                                                        dropdownButtonProps:
                                                        const DropdownButtonProps(
                                                          // padding: EdgeInsets.symmetric(horizontal: 20.0),
                                                            icon: Icon(Icons
                                                                .arrow_drop_down_circle_rounded),
                                                            color: Color(0xff6762FF)),
                                                        items: SearchType1,
                                                        selectedItem: SearchType1[0],
                                                        onChanged: (value) {
                                                          if (value.toString() == 'Department wise'.toString()) {
                                                            dept = true;
                                                            cla = false;
                                                            setState(() {});
                                                          }
                                                          if (value.toString() ==
                                                              'Class wise'
                                                                  .toString()) {
                                                            cla = true;
                                                            dept = false;
                                                            setState(() {});
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: sHeight(2, context),
                                                    ),
                                                    Container(
                                                      height: sHeight(5, context),
                                                      width: sWidth(90, context),
                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(7),color: Colors.white),

                                                      child:
                                                      DropdownSearch<String>(
                                                        popupProps:
                                                        const PopupProps.menu(),
                                                        dropdownDecoratorProps:
                                                        const DropDownDecoratorProps(),
                                                        dropdownButtonProps:
                                                        const DropdownButtonProps(
                                                          // padding: EdgeInsets.symmetric(horizontal: 20.0),
                                                            icon: Icon(Icons
                                                                .arrow_drop_down_circle_rounded),
                                                            color: Color(
                                                                0xff6762FF)),
                                                        items: AcadamicYearList,
                                                        selectedItem: academicYear,
                                                        onChanged: (value) async {
                                                          first = value.toString().characters.take(4).toString();
                                                          last = value.toString().characters.takeLast(4).toString();
                                                          await Col_net();
                                                          await cla_net();
                                                          setState(() {});
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ): new Container(),
                                                  SizedBox(height: sHeight(1, context),),
                                                  Cate_Dro1 == true?  Container(
                                                    height: sHeight(5, context),
                                                    width: sWidth(90, context),
                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(7),color: Colors.white),

                                                    child: DropdownSearch<
                                                        String>(
                                                      popupProps: const PopupProps
                                                          .menu(),
                                                      dropdownDecoratorProps: const DropDownDecoratorProps(),
                                                      dropdownButtonProps: const DropdownButtonProps(
                                                        // padding: EdgeInsets.symmetric(horizontal: 20.0),
                                                          icon: Icon(Icons
                                                              .arrow_drop_down_circle_rounded),
                                                          color: Color(
                                                              0xff6762FF)),
                                                      items: DateCheck,
                                                      selectedItem: 'Select Date Types',
                                                      onChanged: (
                                                          value) async {
                                                        if (value.toString() == 'Today($ATdate)'.toString()) {
                                                          Date_T_B = false;
                                                          partDro = false;
                                                          dateDro = false;
                                                          dateB = true;
                                                          Cate_Dro2 = false;
                                                          Date_sel_To = false;
                                                          await Today_Collection();
                                                          setState(() {});
                                                        }
                                                        if (value.toString() == 'Yesterday($Total_Col_Yester)'.toString()) {
                                                          Date_T_B = false;
                                                          partDro = false;
                                                          dateDro = false;
                                                          dateB = true;
                                                          Cate_Dro2 = false;
                                                          Date_sel_To = false;
                                                          await Yester_Category_Collect();
                                                          setState(() {});
                                                        }
                                                        if (value.toString() == 'This Month($Total_Col_LMdate) to ($ATdate)'.toString()) {
                                                          Date_T_B = false;
                                                          partDro = false;
                                                          dateDro = false;
                                                          dateB = true;
                                                          Cate_Dro2 = false;
                                                          Date_sel_To = false;
                                                          await Month_Category_Collect();
                                                          setState(() {});
                                                        }
                                                        if (value.toString() == 'This Academic Year (01/06/${academicYear.toString().characters.take(4).toString()}) to (31/05/${academicYear.toString().characters.takeLast(4).toString()})'.toString()) {
                                                          Date_T_B = false;
                                                          partDro = false;
                                                          dateDro = false;
                                                          dateB = true;
                                                          Cate_Dro2 = false;
                                                          Date_sel_To = false;
                                                          await Acadamic_Category_Collect();
                                                          setState(() {});
                                                        }
                                                        if (value
                                                            .toString() == 'Particular Date'.toString()) {
                                                          Date_T_B = false;
                                                          dateB = false;
                                                          dateDro = false;
                                                          partDro = true;
                                                          Cate_Dro2 = false;
                                                          Date_sel_To = false;
                                                          setState(() {});
                                                        }
                                                        if (value
                                                            .toString() == 'From to date'.toString()) {
                                                          Date_T_B = false;
                                                          dateB = false;
                                                          partDro = false;
                                                          dateDro = true;
                                                          Date_sel_To = false;
                                                          await DateWise_Collect();
                                                          setState(() {});
                                                        }
                                                      },
                                                    ),
                                                  ):new Container(),
                                                  Cate_Dro2 == true?  Container(
                                                    height: sHeight(5, context),
                                                    width: sWidth(90, context),
                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(7),color: Colors.white),

                                                    child: DropdownSearch<
                                                        String>(
                                                      popupProps: const PopupProps
                                                          .menu(),
                                                      dropdownDecoratorProps: const DropDownDecoratorProps(),
                                                      dropdownButtonProps: const DropdownButtonProps(
                                                        // padding: EdgeInsets.symmetric(horizontal: 20.0),
                                                          icon: Icon(Icons
                                                              .arrow_drop_down_circle_rounded),
                                                          color: Color(
                                                              0xff6762FF)),
                                                      items: DateCheck2,
                                                      selectedItem: DateCheck2[0],
                                                      onChanged: (
                                                          value) async {
                                                        if (value.toString() == 'Today($ATdate)'.toString()) {
                                                          Date_T_B = true;
                                                          partDro = false;
                                                          dateDro = false;
                                                          dateB = false;
                                                          Date_sel_To = false;
                                                          partDro_To = false;
                                                          await Today_Collection_Total();
                                                          setState(() {});
                                                        }
                                                        if (value
                                                            .toString() == 'Particular Date'.toString()) {
                                                          Date_T_B = false;
                                                          partDro = false;
                                                          dateDro = false;
                                                          dateB = false;
                                                          Date_sel_To = false;
                                                          partDro_To = true;
                                                          setState(() {});
                                                        }
                                                        if (value
                                                            .toString() == 'From to Date'.toString()) {
                                                          Date_T_B = false;
                                                          dateB = false;
                                                          partDro = false;
                                                          dateDro = false;
                                                          Date_sel_To = true;
                                                          partDro_To = false;
                                                          setState(() {});
                                                        }
                                                        if (value
                                                            .toString() == 'Yesterday($Total_Col_Yester)'.toString()) {
                                                          Date_T_B = true;
                                                          partDro = false;
                                                          dateDro = false;
                                                          dateB = false;
                                                          Date_sel_To = false;
                                                          partDro_To = false;
                                                          await Yester_Collection_Total();
                                                          setState(() {});
                                                        }
                                                        if (value
                                                            .toString() == 'This Month($Total_Col_LMdate) to ($ATdate)'.toString()) {
                                                          Date_T_B = true;
                                                          partDro = false;
                                                          dateDro = false;
                                                          dateB = false;
                                                          Date_sel_To = false;
                                                          partDro_To = false;
                                                          await Month_Total_Collection();
                                                          setState(() {});
                                                        }if (value
                                                            .toString() == 'This Academic Year (01/06/${academicYear.toString().characters.take(4).toString()}) to (31/05/${academicYear.toString().characters.takeLast(4).toString()})'.toString()) {
                                                          Date_T_B = true;
                                                          partDro = false;
                                                          dateDro = false;
                                                          dateB = false;
                                                          Date_sel_To = false;
                                                          partDro_To = false;
                                                          await Academic_Total_Collection();
                                                          setState(() {});
                                                        }
                                                      },
                                                    ),
                                                  ):new Container(),
                                                  SizedBox(
                                                    height: sHeight(
                                                        2, context),
                                                  ),
                                                  partDro == true && Cate_Dro1 == true ? Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                         height: sHeight(5, context),
                                                        width: sWidth(40, context),
                                                        decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: Colors
                                                                  .black),
                                                          borderRadius: const BorderRadius
                                                              .all(
                                                            Radius.circular(
                                                                7),),
                                                            color: Colors.white
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment
                                                              .spaceEvenly,
                                                          children: [
                                                            Text("${PartDate}"),
                                                            IconButton(
                                                              onPressed: () {
                                                                showDatePicker(
                                                                  context: context,
                                                                  initialDate: DateTime.now(),
                                                                  firstDate: DateTime(2000),
                                                                  lastDate: DateTime.now(),
                                                                ).then((
                                                                    value) async {
                                                                  PartDate = DateFormat('dd/MM/yyyy').format(value!) as String;
                                                                  await PartiCular_Collection();
                                                                  dateB = true;
                                                                  setState(() {});
                                                                });
                                                              },
                                                              icon: const Icon(Icons
                                                                  .calendar_month,
                                                                  color: Color(
                                                                      0xff6762FF)),),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ): new Container(),
                                                  partDro_To == true && Cate_Dro2? Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                        height: sHeight(5, context),
                                                        width: sWidth(40, context),
                                                       decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: Colors
                                                                  .black),
                                                          borderRadius: const BorderRadius
                                                              .all(
                                                            Radius.circular(
                                                                7),),
                                                            color: Colors.white
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment
                                                              .spaceEvenly,
                                                          children: [
                                                            Text("${PartDate_Total}"),
                                                            IconButton(
                                                              onPressed: () {
                                                                showDatePicker(
                                                                  context: context,
                                                                  initialDate: DateTime.now(),
                                                                  firstDate: DateTime(2000),
                                                                  lastDate: DateTime.now(),
                                                                ).then((
                                                                    value) async {
                                                                  PartDate_Total = DateFormat('dd/MM/yyyy').format(value!) as String;
                                                                  await particular_Collection_Total();
                                                                  Date_T_B = true;
                                                                  setState(() {});
                                                                });
                                                              },
                                                              icon: const Icon(Icons
                                                                  .calendar_month,
                                                                  color: Color(
                                                                      0xff6762FF)),),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ): new Container(),
                                                  dateDro == true && Cate_Dro1 == true? Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                    children: [
                                                      Container(
                                                        height: sHeight(5, context),
                                                        width: sWidth(40, context),
                                                         decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: Colors
                                                                  .black),
                                                          borderRadius: const BorderRadius
                                                              .all(
                                                            Radius.circular(
                                                                7),),
                                                             color: Colors.white
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment
                                                              .spaceEvenly,
                                                          children: [
                                                            Text("${frDate}"),
                                                            IconButton(
                                                              onPressed: () {
                                                                showDatePicker(
                                                                  context: context,
                                                                  initialDate: DateTime
                                                                      .now(),
                                                                  firstDate: DateTime(2000),
                                                                  lastDate: DateTime.now(),
                                                                ).then((
                                                                    value) async {
                                                                  frDate = DateFormat('dd/MM/yyyy').format(value!) as String;
                                                                  dateB = false;
                                                                  setState(() {});
                                                                });
                                                              },
                                                              icon: const Icon(Icons
                                                                  .calendar_month,
                                                                  color: Color(
                                                                      0xff6762FF)),),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        height: sHeight(5, context),
                                                        width: sWidth(40, context),
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .black),
                                                            borderRadius: const BorderRadius
                                                                .all(
                                                              Radius.circular(
                                                                  7),),
                                                            color: Colors.white
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment
                                                              .spaceEvenly,
                                                          children: [
                                                            Text("${ToDate}"),
                                                            IconButton(
                                                              onPressed: () async{
                                                                showDatePicker(
                                                                  context: context,
                                                                  initialDate: DateTime
                                                                      .now(),
                                                                  firstDate: DateTime(
                                                                      2000),
                                                                  lastDate: DateTime.now(),
                                                                ).then((
                                                                    value) async {
                                                                  ToDate =
                                                                  DateFormat(
                                                                      'dd/MM/yyyy')
                                                                      .format(
                                                                      value!) as String;
                                                                  dateB = false;
                                                                  setState(() {});
                                                                });
                                                              },
                                                              icon: const Icon(Icons
                                                                  .calendar_month,
                                                                  color: Color(
                                                                      0xff6762FF)),),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ) : new Container(),
                                                  dateDro == true && Cate_Dro1 == true ?   ElevatedButton(onPressed: () async{
                                                    dateB = true;
                                                    await DateWise_Collect();
                                                    setState(() {
                                                    });
                                                  }, child: const Text("Search")) : new Container(),
                                                  Cate_Dro2 == true &&  Date_sel_To == true ? Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                    children: [
                                                      Container(
                                                        height: sHeight(5, context),
                                                        width: sWidth(40, context),
                                                         decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: Colors
                                                                  .black),
                                                          borderRadius: const BorderRadius
                                                              .all(
                                                            Radius.circular(
                                                                7),),color: Colors.white
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment
                                                              .spaceEvenly,
                                                          children: [
                                                            Text("${frDate2}"),
                                                            IconButton(
                                                              onPressed: () {
                                                                showDatePicker(
                                                                  context: context,
                                                                  initialDate: DateTime.now(),
                                                                  firstDate: DateTime(2000),
                                                                  lastDate: DateTime.now(),
                                                                ).then((value) async {
                                                                  frDate2 = DateFormat('dd/MM/yyyy').format(value!) as String;
                                                                  Date_T_B = false;
                                                                  setState(() {});
                                                                });
                                                              },
                                                              icon: const Icon(Icons
                                                                  .calendar_month,
                                                                  color: Color(
                                                                      0xff6762FF)),),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        height: sHeight(5, context),
                                                        width: sWidth(40, context),
                                                        decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: Colors
                                                                  .black),
                                                          borderRadius: const BorderRadius
                                                              .all(
                                                            Radius.circular(
                                                                7),),
                                                            color: Colors.white
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment
                                                              .spaceEvenly,
                                                          children: [
                                                            Text("${ToDate2}"),
                                                            IconButton(
                                                              onPressed: () async{
                                                                showDatePicker(
                                                                  context: context,
                                                                  initialDate: DateTime
                                                                      .now(),
                                                                  firstDate: DateTime(
                                                                      2000),
                                                                  lastDate: DateTime.now(),
                                                                ).then((
                                                                    value) async {
                                                                  ToDate2 =
                                                                  DateFormat(
                                                                      'dd/MM/yyyy')
                                                                      .format(
                                                                      value!) as String;
                                                                  Date_T_B = false;
                                                                  setState(() {});
                                                                });
                                                              },
                                                              icon: const Icon(Icons
                                                                  .calendar_month,
                                                                  color: Color(
                                                                      0xff6762FF)),),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ) : new Container(),
                                                  Cate_Dro2 == true &&  Date_sel_To == true ?   ElevatedButton(onPressed: () async{
                                                    dateB = false;
                                                    Date_T_B = true;
                                                    await DateWise_Total_collection();
                                                    setState(() {
                                                    });
                                                  }, child: const Text("Search")) : new Container(),
                                                  SizedBox(
                                                    height: sHeight(
                                                        2, context),
                                                  ),
                                                  dateCdata.length == 0 && dateB == true? Container(
                                                    child: Image.asset(
                                                        "images/Dataimg/data_not_found.png"),
                                                  ) : Container(
                                                    child:  Column(
                                                      children: [
                                                          dateB == true ?
                                                          FutureBuilder(future: Future.delayed(const Duration(seconds: 1)),
                                                            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                                                              if (snapshot.connectionState == ConnectionState.waiting) {
                                                                return const CircularProgressIndicator();
                                                              } else {
                                                                return  Column(
                                                                  children: [
                                                                    for (int i = dateCdata.length -1; i>= 0; i--)
                                                                    Container(
                                                                      width: sWidth(90, context),
                                                                      margin: const EdgeInsets.only(
                                                                          bottom: 10),
                                                                      decoration: const BoxDecoration(
                                                                        color: Colors
                                                                            .white,
                                                                        borderRadius:
                                                                        BorderRadius.all(
                                                                          Radius.circular(
                                                                              15),
                                                                        ),
                                                                      ),
                                                                      child: Column(
                                                                        children: [
                                                                          SizedBox(
                                                                            height: sHeight(
                                                                                1.5,
                                                                                context),
                                                                          ),
                                                                          Container(
                                                                              width: sWidth(
                                                                                  80,
                                                                                  context),
                                                                              decoration:
                                                                              const BoxDecoration(
                                                                                color: Colors
                                                                                    .green,
                                                                                borderRadius:
                                                                                BorderRadius
                                                                                    .all(
                                                                                  Radius
                                                                                      .circular(
                                                                                      5),
                                                                                ),
                                                                              ),
                                                                              child: Column(
                                                                                children: [
                                                                                  const SizedBox(
                                                                                    height: 10,
                                                                                  ),
                                                                                  Center(
                                                                                      child:
                                                                                      Text(
                                                                                          "${dateCdata[i].fee}",
                                                                                          style: const TextStyle(
                                                                                              fontWeight: FontWeight
                                                                                                  .w600,
                                                                                              color: Colors
                                                                                                  .white))),
                                                                                  const SizedBox(
                                                                                    height: 10,
                                                                                  ),
                                                                                ],
                                                                              )),
                                                                          SizedBox(
                                                                            height: sHeight(
                                                                                1.5,
                                                                                context),
                                                                          ),
                                                                          Container(
                                                                            width: sWidth(
                                                                                80,
                                                                                context),
                                                                            child: DataTable(
                                                                                border:
                                                                                TableBorder
                                                                                    .all(
                                                                                  //style: BorderStyle.solid,
                                                                                  width: 1,
                                                                                ),
                                                                                showBottomBorder:
                                                                                true,
                                                                                showCheckboxColumn:
                                                                                true,
                                                                                sortAscending:
                                                                                true,
                                                                                dividerThickness:
                                                                                2,
                                                                                columns: [
                                                                                  const DataColumn(
                                                                                    label: Text(
                                                                                        "Detail"),
                                                                                  ),
                                                                                  const DataColumn(
                                                                                    label: Text(
                                                                                        'Amount'),
                                                                                  ),
                                                                                  /* DataColumn(
                                                          label: Text('Amount'),
                                                        ),*/
                                                                                ],
                                                                                rows: [
                                                                                  DataRow(
                                                                                      cells: [
                                                                                        const DataCell(
                                                                                            Text(
                                                                                                "Bank")),
                                                                                        DataCell(
                                                                                          Text(
                                                                                            NumberFormat
                                                                                                .currency(
                                                                                              symbol: '₹ ',
                                                                                              locale: "HI",
                                                                                              decimalDigits: 2,
                                                                                            )
                                                                                                .format(
                                                                                                dateCdata[i].bank),
                                                                                          ),
                                                                                        ),
                                                                                      ]),
                                                                                  DataRow(
                                                                                      cells: [
                                                                                        const DataCell(
                                                                                            Text(
                                                                                                "Cash")),
                                                                                        DataCell(
                                                                                          Text(
                                                                                            NumberFormat
                                                                                                .currency(
                                                                                              symbol: '₹ ',
                                                                                              locale: "HI",
                                                                                              decimalDigits: 2,
                                                                                            )
                                                                                                .format(
                                                                                                dateCdata[i].cash),
                                                                                          ),
                                                                                        ),
                                                                                      ]),
                                                                                  DataRow(
                                                                                      cells: [
                                                                                        const DataCell(
                                                                                            Text(
                                                                                                "Total")),
                                                                                        DataCell(
                                                                                          Text(
                                                                                            NumberFormat
                                                                                                .currency(
                                                                                              symbol: '₹ ',
                                                                                              locale: "HI",
                                                                                              decimalDigits: 2,
                                                                                            )
                                                                                                .format(
                                                                                                dateCdata[i].total),
                                                                                          ),
                                                                                        ),
                                                                                        // DataCell(Text("${data[i].balance}")),
                                                                                      ]),
                                                                                  DataRow(
                                                                                      cells: [
                                                                                        const DataCell(
                                                                                            Text(
                                                                                                "Fine Bank")),
                                                                                        DataCell(
                                                                                          Text(
                                                                                            NumberFormat
                                                                                                .currency(
                                                                                              symbol: '₹ ',
                                                                                              locale: "HI",
                                                                                              decimalDigits: 2,
                                                                                            )
                                                                                                .format(
                                                                                                dateCdata[i].fineBank),
                                                                                          ),
                                                                                        ),
                                                                                      ]),
                                                                                  DataRow(
                                                                                      cells: [
                                                                                        const DataCell(
                                                                                            Text(
                                                                                                "Fine Cash")),
                                                                                        DataCell(
                                                                                          Text(
                                                                                            NumberFormat
                                                                                                .currency(
                                                                                              symbol: '₹ ',
                                                                                              locale: "HI",
                                                                                              decimalDigits: 2,
                                                                                            )
                                                                                                .format(
                                                                                                dateCdata[i].fineCash),
                                                                                          ),
                                                                                        ),
                                                                                      ]),
                                                                                  DataRow(
                                                                                      cells: [
                                                                                        const DataCell(
                                                                                            Text(
                                                                                                "Fine Total")),
                                                                                        DataCell(
                                                                                          Text(
                                                                                            NumberFormat
                                                                                                .currency(
                                                                                              symbol: '₹ ',
                                                                                              locale: "HI",
                                                                                              decimalDigits: 2,
                                                                                            )
                                                                                                .format(
                                                                                                dateCdata[i].fineTotal),
                                                                                          ),
                                                                                        ),
                                                                                      ]),
                                                                                  DataRow(
                                                                                      cells: [
                                                                                        const DataCell(
                                                                                            Text(
                                                                                                "Bank Total")),
                                                                                        DataCell(
                                                                                          Text(
                                                                                            NumberFormat
                                                                                                .currency(
                                                                                              symbol: '₹ ',
                                                                                              locale: "HI",
                                                                                              decimalDigits: 2,
                                                                                            )
                                                                                                .format(
                                                                                                dateCdata[i].bankTotal),
                                                                                          ),
                                                                                        ),
                                                                                      ]),
                                                                                  DataRow(
                                                                                      cells: [
                                                                                        const DataCell(
                                                                                            Text(
                                                                                                "Cash Total")),
                                                                                        DataCell(
                                                                                          Text(
                                                                                            NumberFormat
                                                                                                .currency(
                                                                                              symbol: '₹ ',
                                                                                              locale: "HI",
                                                                                              decimalDigits: 2,
                                                                                            )
                                                                                                .format(
                                                                                                dateCdata[i].cashTotal),
                                                                                          ),
                                                                                        ),
                                                                                      ]),
                                                                                  DataRow(
                                                                                      cells: [
                                                                                        const DataCell(
                                                                                            Text(
                                                                                                "Grand Total")),
                                                                                        DataCell(
                                                                                          Text(
                                                                                            NumberFormat
                                                                                                .currency(
                                                                                              symbol: '₹ ',
                                                                                              locale: "HI",
                                                                                              decimalDigits: 2,
                                                                                            )
                                                                                                .format(
                                                                                                dateCdata[i].grandTotal),
                                                                                          ),
                                                                                        ),
                                                                                        // DataCell(Text("${data[i].balance}")),
                                                                                      ]),
                                                                                ]),
                                                                          ),
                                                                          SizedBox(
                                                                            height: sHeight(
                                                                                1.5,
                                                                                context),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                );
                                                              }
                                                            },
                                                          ) : new Container(),
                                                      ],
                                                    ),
                                                  ),
                                                  feeTotaldata.length == 0 && Date_T_B == true ? Container(
                                                    child: Image.asset(
                                                        "images/Dataimg/data_not_found.png"),
                                                  ) : Column(
                                                    children: [
                                                      for (int i = feeTotaldata.length -1; i>= 0; i--)
                                                        Date_T_B == true ?   FutureBuilder(future: Future.delayed(const Duration(seconds: 1)),
                                                           builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                                 return const CircularProgressIndicator();
                                               } else {
                                                           return  Container(
                                                             width: sWidth(90, context),
                                                   margin: const EdgeInsets.only(
                                                       bottom: 10),
                                                   decoration: const BoxDecoration(
                                                     color: Colors
                                                         .white,
                                                     borderRadius:
                                                     BorderRadius.all(
                                                       Radius.circular(
                                                           15),
                                                     ),
                                                   ),
                                                 child :
                                                   Column(
                                                   children: [
                                                     SizedBox(
                                                       height: sHeight(
                                                           1.5,
                                                           context),
                                                     ),
                                                     const Text(
                                                       "TOTAL COLLECTION",
                                                       style: TextStyle(
                                                           fontWeight:
                                                           FontWeight
                                                               .w600,
                                                           color: Color(
                                                               0xFF6762FF)),
                                                     ),
                                                     SizedBox(
                                                       height: sHeight(
                                                           1.5,
                                                           context),
                                                     ),
                                                     SizedBox(
                                                       height: sHeight(
                                                           1.5,
                                                           context),
                                                     ),
                                                     Container(
                                                       width: sWidth(
                                                           80,
                                                           context),
                                                       child: DataTable(
                                                           border:
                                                           TableBorder.all(width: 1,),
                                                           showBottomBorder: true,
                                                           showCheckboxColumn: true,
                                                           sortAscending: true,
                                                           dividerThickness: 2,
                                                           columns: const [
                                                             DataColumn(
                                                               label: Text(
                                                                   "Detail"),
                                                             ),
                                                             DataColumn(
                                                               label: Text(
                                                                   'Amount'),
                                                             ),
                                                           ],
                                                           rows: [
                                                             DataRow(
                                                                 cells: [
                                                                   const DataCell(
                                                                       Text(
                                                                           "Bank")),
                                                                   DataCell(
                                                                     Text(
                                                                       NumberFormat
                                                                           .currency(
                                                                         symbol: '₹ ',
                                                                         locale: "HI",
                                                                         decimalDigits: 2,
                                                                       )
                                                                           .format(
                                                                           feeTotaldata[i].bank),
                                                                     ),
                                                                   ),
                                                                 ]),
                                                             DataRow(
                                                                 cells: [
                                                                   const DataCell(
                                                                       Text(
                                                                           "Cash")),
                                                                   DataCell(
                                                                     Text(
                                                                       NumberFormat
                                                                           .currency(
                                                                         symbol: '₹ ',
                                                                         locale: "HI",
                                                                         decimalDigits: 2,
                                                                       )
                                                                           .format(
                                                                           feeTotaldata[i].cash),
                                                                     ),
                                                                   ),
                                                                 ]),
                                                             DataRow(
                                                                 cells: [
                                                                   const DataCell(
                                                                       Text(
                                                                           "Total")),
                                                                   DataCell(
                                                                     Text(
                                                                       NumberFormat
                                                                           .currency(
                                                                         symbol: '₹ ',
                                                                         locale: "HI",
                                                                         decimalDigits: 2,
                                                                       )
                                                                           .format(
                                                                           feeTotaldata[i].total),
                                                                     ),
                                                                   ),
                                                                 ]),
                                                             DataRow(
                                                                 cells: [
                                                                   const DataCell(
                                                                       Text(
                                                                           "Fine Bank")),
                                                                   DataCell(
                                                                     Text(
                                                                       NumberFormat
                                                                           .currency(
                                                                         symbol: '₹ ',
                                                                         locale: "HI",
                                                                         decimalDigits: 2,
                                                                       )
                                                                           .format(
                                                                           feeTotaldata[i].fineBank),
                                                                     ),
                                                                   ),
                                                                 ]),
                                                             DataRow(
                                                                 cells: [
                                                                   const DataCell(
                                                                       Text(
                                                                           "Fine Cash")),
                                                                   DataCell(
                                                                     Text(
                                                                       NumberFormat
                                                                           .currency(
                                                                         symbol: '₹ ',
                                                                         locale: "HI",
                                                                         decimalDigits: 2,
                                                                       )
                                                                           .format(
                                                                           feeTotaldata[i].fineCash),
                                                                     ),
                                                                   ),
                                                                 ]),
                                                             DataRow(
                                                                 cells: [
                                                                   const DataCell(
                                                                       Text(
                                                                           "Fine Total")),
                                                                   DataCell(
                                                                     Text(
                                                                       NumberFormat
                                                                           .currency(
                                                                         symbol: '₹ ',
                                                                         locale: "HI",
                                                                         decimalDigits: 2,
                                                                       )
                                                                           .format(
                                                                           feeTotaldata[i].fineTotal),
                                                                     ),
                                                                   ),
                                                                 ]),
                                                             DataRow(
                                                                 cells: [
                                                                   const DataCell(
                                                                       Text(
                                                                           "Bank Total")),
                                                                   DataCell(
                                                                     Text(
                                                                       NumberFormat
                                                                           .currency(
                                                                         symbol: '₹ ',
                                                                         locale: "HI",
                                                                         decimalDigits: 2,
                                                                       )
                                                                           .format(
                                                                           feeTotaldata[i].bankTotal),
                                                                     ),
                                                                   ),
                                                                 ]),
                                                             DataRow(
                                                                 cells: [
                                                                   const DataCell(
                                                                       Text("Cash Total")),
                                                                   DataCell(
                                                                     Text(
                                                                       NumberFormat
                                                                           .currency(
                                                                         symbol: '₹ ',
                                                                         locale: "HI",
                                                                         decimalDigits: 2,
                                                                       )
                                                                           .format(
                                                                           feeTotaldata[i].cashTotal),
                                                                     ),
                                                                   ),
                                                                 ]),
                                                             DataRow(
                                                                 cells: [
                                                                   const DataCell(
                                                                       Text(
                                                                           "Grand Total")),
                                                                   DataCell(
                                                                     Text(
                                                                       NumberFormat
                                                                           .currency(
                                                                         symbol: '₹ ',
                                                                         locale: "HI",
                                                                         decimalDigits: 2,
                                                                       )
                                                                           .format(
                                                                           feeTotaldata[i].grandTotal),
                                                                     ),
                                                                   ),
                                                                 ]),
                                                           ]),
                                                     ),
                                                     SizedBox(
                                                       height: sHeight(1.5, context),
                                                     ),
                                                   ],
                                                 ));
                                                     }
                                                    },
                                                ) : new Container(),
                                                    ],
                                                  ),
                                                  Cla_De_DR == true ? Column(
                                                    children: [
                                                      classdata.length > 0  ?  Column(
                                                        children: [
                                                          cla == true ? FutureBuilder(future: Future.delayed(const Duration(seconds: 1)),
                                                            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                                                              if (snapshot.connectionState == ConnectionState.waiting) {
                                                                return const CircularProgressIndicator();
                                                              } else {
                                                                return Column(
                                                                  children: [
                                                                    for (int i = classdata.length - 1; i >= 0; i--)
                                                                      Container(padding:
                                                                      const EdgeInsets.only(
                                                                          top: 10,
                                                                          bottom: 10),
                                                                        width: sWidth(
                                                                            90, context),
                                                                        decoration:
                                                                        const BoxDecoration(
                                                                            borderRadius:
                                                                            BorderRadius
                                                                                .all(
                                                                              Radius.circular(
                                                                                  10),
                                                                            )),
                                                                        child: Column(
                                                                          mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                          children: [
                                                                            Container(
                                                                              child: Text(
                                                                                  " Class : ${classdata[i].welcomeClass}"),
                                                                            ),
                                                                            SizedBox(
                                                                              height: sHeight(
                                                                                  2,
                                                                                  context),
                                                                            ),
                                                                            Container(
                                                                              width: sWidth(
                                                                                  90,
                                                                                  context),
                                                                              child: DataTable(
                                                                                  border:
                                                                                  TableBorder
                                                                                      .all(
                                                                                    //style: BorderStyle.solid,
                                                                                    width: 1,
                                                                                  ),
                                                                                  showBottomBorder:
                                                                                  true,
                                                                                  showCheckboxColumn:
                                                                                  true,
                                                                                  sortAscending:
                                                                                  true,
                                                                                  dividerThickness:
                                                                                  2,
                                                                                  columns: [
                                                                                    const DataColumn(
                                                                                      label: Text(
                                                                                          "Detail"),
                                                                                    ),
                                                                                    const DataColumn(
                                                                                      label: Text(
                                                                                          'Amount'),
                                                                                    ),
                                                                                    /* DataColumn(
                                                  label: Text('Amount'),
                                                ),*/
                                                                                  ],
                                                                                  rows: [
                                                                                    DataRow(
                                                                                        cells: [
                                                                                          const DataCell(
                                                                                              Text("Demand")),
                                                                                          DataCell(
                                                                                            Text(
                                                                                              NumberFormat.currency(
                                                                                                symbol: '₹ ',
                                                                                                locale: "HI",
                                                                                                decimalDigits: 2,
                                                                                              ).format(classdata[i].demand),
                                                                                            ),
                                                                                          ),
                                                                                          // DataCell(Text("${data[i].balance}")),
                                                                                        ]),
                                                                                    DataRow(
                                                                                        cells: [
                                                                                          const DataCell(
                                                                                              Text("Collection")),
                                                                                          DataCell(
                                                                                            Text(
                                                                                              NumberFormat.currency(
                                                                                                symbol: '₹ ',
                                                                                                locale: "HI",
                                                                                                decimalDigits: 2,
                                                                                              ).format(classdata[i].collection),
                                                                                            ),),
                                                                                          // DataCell(Text("${data[i].balance}")),
                                                                                        ]),
                                                                                    DataRow(
                                                                                        cells: [
                                                                                          const DataCell(
                                                                                              Text("Concession")),
                                                                                          DataCell(
                                                                                            Text(
                                                                                              NumberFormat.currency(
                                                                                                symbol: '₹ ',
                                                                                                locale: "HI",
                                                                                                decimalDigits: 2,
                                                                                              ).format(classdata[i].concession),
                                                                                            ),),
                                                                                          // DataCell(Text("${data[i].balance}")),
                                                                                        ]),
                                                                                    DataRow(
                                                                                        cells: [
                                                                                          const DataCell(
                                                                                              Text("Balance")),
                                                                                          DataCell(
                                                                                            Text(
                                                                                              NumberFormat.currency(
                                                                                                symbol: '₹ ',
                                                                                                locale: "HI",
                                                                                                decimalDigits: 2,
                                                                                              ).format(classdata[i].balance),
                                                                                            ),),

                                                                                          // DataCell(Text("${data[i].balance}")),
                                                                                        ]),
                                                                                  ]),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                  ],
                                                                );
                                                              }
                                                            },
                                                          ) : new Container(),
                                                          dept == true ? FutureBuilder(future: Future.delayed(const Duration(seconds: 1)),
                                                            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                                                              if (snapshot.connectionState == ConnectionState.waiting) {
                                                                return const CircularProgressIndicator();
                                                              } else {
                                                                return Column(
                                                                  children: [
                                                                    for (int i = deptdata.length - 1; i >= 0; i--)
                                                                      Container(padding:
                                                                      const EdgeInsets.only(
                                                                          top: 10,
                                                                          bottom: 10),
                                                                        width: sWidth(90, context),
                                                                        margin: const EdgeInsets.only(
                                                                            bottom: 10),
                                                                        decoration: const BoxDecoration(
                                                                          color: Colors
                                                                              .white,
                                                                          borderRadius:
                                                                          BorderRadius.all(
                                                                            Radius.circular(
                                                                                15),
                                                                          ),
                                                                        ),
                                                                        child: Column(
                                                                          mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                          children: [
                                                                            Container(
                                                                              child: Text(
                                                                                  " Department : ${deptdata[i].deptName}",style: TextStyle(
                                                                                  fontWeight:
                                                                                  FontWeight
                                                                                      .w600,
                                                                                  color: Color(
                                                                                      0xFF6762FF)),),
                                                                            ),
                                                                            SizedBox(
                                                                              height: sHeight(
                                                                                  2,
                                                                                  context),
                                                                            ),
                                                                            Container(
                                                                              width: sWidth(
                                                                                  80,
                                                                                  context),
                                                                              child: DataTable(
                                                                                  border: TableBorder.all(
                                                                                    //style: BorderStyle.solid,
                                                                                    width:
                                                                                    1,
                                                                                  ),
                                                                                  showBottomBorder: true,
                                                                                  showCheckboxColumn: true,
                                                                                  sortAscending: true,
                                                                                  dividerThickness: 2,
                                                                                  columns: [
                                                                                    const DataColumn(
                                                                                      label:
                                                                                      Text("Detail"),
                                                                                    ),
                                                                                    const DataColumn(
                                                                                      label:
                                                                                      Text('Amount'),
                                                                                    ),
                                                                                    /* DataColumn(
                                                label: Text('Amount'),
                                              ),*/
                                                                                  ],
                                                                                  rows: [
                                                                                    DataRow(
                                                                                        cells: [
                                                                                          const DataCell(Text("Demand")),
                                                                                          DataCell(
                                                                                            Text(
                                                                                              NumberFormat.currency(
                                                                                                symbol: '₹ ',
                                                                                                locale: "HI",
                                                                                                decimalDigits: 2,
                                                                                              ).format(deptdata[i].demand),
                                                                                            ),
                                                                                          ),
                                                                                          // DataCell(Text("${data[i].balance}")),
                                                                                        ]),
                                                                                    DataRow(
                                                                                        cells: [
                                                                                          const DataCell(Text("Collection")),
                                                                                          DataCell(
                                                                                            Text(
                                                                                              NumberFormat.currency(
                                                                                                symbol: '₹ ',
                                                                                                locale: "HI",
                                                                                                decimalDigits: 2,
                                                                                              ).format(deptdata[i].collection),
                                                                                            ),
                                                                                          ),
                                                                                          // DataCell(Text("${data[i].balance}")),
                                                                                        ]),
                                                                                    DataRow(
                                                                                        cells: [
                                                                                          const DataCell(Text("Concession")),
                                                                                          DataCell(
                                                                                            Text(
                                                                                              NumberFormat.currency(
                                                                                                symbol: '₹ ',
                                                                                                locale: "HI",
                                                                                                decimalDigits: 2,
                                                                                              ).format(deptdata[i].concession),
                                                                                            ),
                                                                                          ),
                                                                                          // DataCell(Text("${data[i].balance}")),
                                                                                        ]),
                                                                                    DataRow(
                                                                                        cells: [
                                                                                          const DataCell(Text("Balance")),
                                                                                          DataCell(
                                                                                            Text(
                                                                                              NumberFormat.currency(
                                                                                                symbol: '₹ ',
                                                                                                locale: "HI",
                                                                                                decimalDigits: 2,
                                                                                              ).format(deptdata[i].balance),
                                                                                            ),
                                                                                          ),
                                                                                          // DataCell(Text("${data[i].balance}")),
                                                                                        ]),
                                                                                  ]),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                  ],
                                                                );
                                                              }
                                                            },
                                                          ) : new Container(),
                                                        ],
                                                      ) : new Container(
                                                        child:  Image.asset("images/Dataimg/data_not_found.png"),
                                                      ),
                                                    ],
                                                  ) : Container(

                                                  ),
                                                ],
                                              ),
                                            ),
                                          )),
                            );
                          }
                          else {
                            return Container(
                              child: Center(child: StudentsSearching(context)),
                              color: Colors.white,
                            );
                          }
                        });
                  } else {
                    return Container(
                      child: Center(child: StudentsSearching(context)),
                      color: Colors.white,
                    );
                  }
                });
          } else {
            return Container(
              child: Center(child: StudentsSearching(context)),
              color: Colors.white,
            );
          }
        });
          } else {
            return Container(
              child: Center(child: StudentsSearching(context)),
              color: Colors.white,
            );
          }
        });
          } else {
            return Container(
              child: Center(child: StudentsSearching(context)),
              color: Colors.white,
            );
          }
        });
  }
}

//Inst Fee Balance
class Inst_Colection extends StatefulWidget {
  const Inst_Colection(
      {Key? key, required this.username, required this.password})
      : super(key: key);
  final String username;
  final String password;

  @override
  State<Inst_Colection> createState() => _Inst_ColectionState();
}

class _Inst_ColectionState extends State<Inst_Colection> {
  DateTime now = DateTime.now();
  late Future<Dep_DataList> APID_Data;
  late Future<Dep_DataList> FEE_Data;
  late Future<Acad_DataList> APIacad_Data;
  late List<String> SearchType = [
    'All',
  ];
  late List<String> SearchType1 = [
    'Balance',
    'D-C-C-B',
    'Fee Category',
  ];
  String? fir;
  String? las;
  String? main_f;
  late List<String> AcadamicYears = [];
  bool bal1 = true;
  bool dccb = false;
  bool mainf = false;
  bool subf = false;
  Inst_Collect() async {
    InstCollection_Network instCollection_Network = InstCollection_Network(
        "InstdCB?StaffCode=${widget.username}&AcadYear=${fir}%20-%20${las}&Type=INST&InstId=0&Password=${widget.password}");
    APID_Data = instCollection_Network.IC_loadData();
  }
  FeemainRhead() async {
    Feecate_Network feecate_network = Feecate_Network(
        "InstdCB?StaffCode=${widget.username}&AcadYear=${fir}%20-%20${las}&Type=${main_f}&InstId=0&Password=${widget.password}");
    FEE_Data = feecate_network.Fee_loadData();
  }
  String? academicYearUH;
  Get_Acdamic_yearUH()async{
    int academicYearStart;
    if (now.month >= 6) {
      academicYearStart = now.year;
    } else {
      academicYearStart = now.year - 1;
    }
    int academicYearEnd = academicYearStart + 1;
    academicYearUH = '$academicYearStart-$academicYearEnd';
    // print(academicYearUH);
    fir = academicYearUH.toString().characters.take(4).toString();
    las =academicYearUH.toString().characters.takeLast(4).toString();
  }
  void initState() {
    // TODO: implement initState
    super.initState();
    Get_Acdamic_yearUH();
    Inst_Collect();
    FeemainRhead();
    Acad_Network acad_network = Acad_Network(
        "acadyear?StaffCode=${widget.username}&Password=${widget.password}");
    APIacad_Data = acad_network.Acad_loadData();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: APIacad_Data,
        builder: (context, AsyncSnapshot<Acad_DataList> acadsnapshot) {
          if (acadsnapshot.hasError) {
            ErrorShowingWidget(context);
          }
          List<AcadyearData> acaddata;
          if (acadsnapshot.hasData) {
            acaddata = acadsnapshot.data!.acad_list;
            AcadamicYears = [
              for (int i = acaddata.length - 1; i >= 0; i--)
                acaddata[i].acadYear
            ];
            return FutureBuilder(
                future: FEE_Data,
                builder: (context, AsyncSnapshot<Dep_DataList> feesnapshot) {
                  if (feesnapshot.hasError) {
                    ErrorShowingWidget(context);
                  }
                  List<Dep_Cdata> feedata;
                  if (feesnapshot.hasData) {
                    feedata = feesnapshot.data!.dep_list;
                            return FutureBuilder(
                                future: APID_Data,
                                builder:
                                    (context, AsyncSnapshot<
                                    Dep_DataList> snapshot) {
                                  if (snapshot.hasError) {
                                    ErrorShowingWidget(context);
                                  }
                                  List<Dep_Cdata> data;
                                  if (snapshot.hasData) {
                                    data = snapshot.data!.dep_list;
                                    return Scaffold(
                                      backgroundColor:
                                      const Color.fromRGBO(242, 249, 255, 0.9),
                                      appBar: AppBar(
                                        title: Text("Fee Balance",
                                            style: PrimaryText(context)),
                                        backgroundColor: const Color(0xFF6762FF),
                                      ),
                                      body: Builder(
                                          builder: (BuildContext context) =>
                                              SingleChildScrollView(
                                                scrollDirection: Axis.vertical,
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: sHeight(
                                                          3, context),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                      children: [
                                                        Container(
                                                         height: sHeight(5, context),
                                                          width: sWidth(40, context),
                                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(7),color: Colors.white),
                                                          child: DropdownSearch<
                                                              String>(
                                                            popupProps:
                                                            const PopupProps.menu(),
                                                            dropdownDecoratorProps:
                                                            const DropDownDecoratorProps(),
                                                            dropdownButtonProps:
                                                            const DropdownButtonProps(
                                                              // padding: EdgeInsets.symmetric(horizontal: 20.0),
                                                                icon: Icon(Icons
                                                                    .arrow_drop_down_circle_rounded),
                                                                color: Color(
                                                                    0xff6762FF)),
                                                            items: SearchType,
                                                            selectedItem: SearchType[0],
                                                            onChanged: (value) {
                                                              // SearchTypeIndex = 1 + SearchType.indexOf(value.toString());
                                                            },
                                                          ),
                                                        ),
                                                        Container(
                                                          height: sHeight(5, context),
                                                          width: sWidth(40, context),
                                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(7),color: Colors.white),
                                                          child: DropdownSearch<
                                                              String>(
                                                            popupProps: const PopupProps
                                                                .menu(),
                                                            dropdownDecoratorProps: const DropDownDecoratorProps(),
                                                            dropdownButtonProps:
                                                            const DropdownButtonProps(
                                                              // padding: EdgeInsets.symmetric(horizontal: 20.0),
                                                                icon: Icon(Icons
                                                                    .arrow_drop_down_circle_rounded),
                                                                color: Color(
                                                                    0xff6762FF)),
                                                            items: AcadamicYears,
                                                            selectedItem: academicYearUH,
                                                            onChanged: (
                                                                value) async {
                                                              fir = value.toString().characters.take(4).toString();
                                                              las = value.toString().characters.takeLast(4).toString();
                                                              await Inst_Collect();
                                                              await FeemainRhead();
                                                              setState(() {});
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: sHeight(2, context),
                                                    ),
                                                    Container(
                                                      height: sHeight(5, context),
                                                      width: sWidth(90, context),
                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(7),color: Colors.white),

                                                      child: DropdownSearch<
                                                          String>(
                                                        popupProps: const PopupProps
                                                            .menu(),
                                                        dropdownDecoratorProps: const DropDownDecoratorProps(),
                                                        dropdownButtonProps: const DropdownButtonProps(
                                                          // padding: EdgeInsets.symmetric(horizontal: 20.0),
                                                            icon: Icon(Icons
                                                                .arrow_drop_down_circle_rounded),
                                                            color: Color(
                                                                0xff6762FF)),
                                                        items: SearchType1,
                                                        selectedItem: SearchType1[0],
                                                        onChanged: (
                                                            value) async {
                                                          print(value);
                                                          if (value
                                                              .toString() ==
                                                              'Balance'
                                                                  .toString()) {
                                                            bal1 = true;
                                                            dccb = false;
                                                            mainf = false;
                                                            await Inst_Collect();
                                                            setState(() {});
                                                          }
                                                          if (value
                                                              .toString() ==
                                                              'D-C-C-B'
                                                                  .toString()) {
                                                            dccb = true;
                                                            bal1 = false;
                                                            mainf = false;
                                                            await Inst_Collect();
                                                            setState(() {});
                                                          }
                                                          if (value
                                                              .toString() ==
                                                              'Fee Category'
                                                                  .toString()) {
                                                            mainf = true;
                                                            dccb = false;
                                                            bal1 = false;
                                                            main_f = 'FEEMAIN'
                                                                .toString();
                                                            await FeemainRhead();
                                                            setState(() {});
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: sHeight(
                                                          4, context),
                                                    ),
                                                    data.length > 0?
                                                    FutureBuilder(future: Future.delayed(const Duration(seconds: 1)),
                                                      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                                          return const CircularProgressIndicator();
                                                        } else {
                                                          return Column(
                                                            children: [
                                                              for (int i = data.length - 1; i >= 0; i--)
                                                                bal1 == true ? Container(
                                                                  margin: const EdgeInsets
                                                                      .only(
                                                                      left: 15.0,
                                                                      top: 8,
                                                                      right: 15.0),
                                                                  padding: const EdgeInsets
                                                                      .only(
                                                                      right: 10.0,
                                                                      left: 10.0),
                                                                  width:
                                                                  sWidth(90, context),
                                                                  decoration: const BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    borderRadius:
                                                                    BorderRadius.all(
                                                                      Radius.circular(
                                                                          10),
                                                                    ),
                                                                  ),
                                                                  child:
                                                                  SingleChildScrollView(
                                                                    scrollDirection:
                                                                    Axis.vertical,
                                                                    child: Column(
                                                                      children: [
                                                                        SizedBox(
                                                                          height: sHeight(
                                                                              2,
                                                                              context),
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceEvenly,
                                                                          children: [
                                                                            Text(
                                                                                "${data[i]
                                                                                    .instName}"),
                                                                            Text(
                                                                              NumberFormat
                                                                                  .currency(
                                                                                symbol: '₹ ',
                                                                                locale: "HI",
                                                                                decimalDigits: 2,
                                                                              )
                                                                                  .format(
                                                                                  data[i]
                                                                                      .balance),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          height: sHeight(
                                                                              2,
                                                                              context),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ) : new Container(),
                                                              for (int i = data.length - 1; i >= 0; i--)
                                                                dccb == true ? Container(
                                                                  width:
                                                                  sWidth(90, context),
                                                                  margin: const EdgeInsets
                                                                      .only(
                                                                      bottom: 10),
                                                                  decoration: const BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    borderRadius:
                                                                    BorderRadius.all(
                                                                      Radius.circular(
                                                                          15),
                                                                    ),
                                                                  ),
                                                                  child: Column(
                                                                    children: [
                                                                      SizedBox(
                                                                        height: sHeight(
                                                                            1.5,
                                                                            context),
                                                                      ),
                                                                      Container(
                                                                          width: sWidth(
                                                                              80,
                                                                              context),
                                                                          decoration:
                                                                          const BoxDecoration(
                                                                            color: Colors
                                                                                .green,
                                                                            borderRadius:
                                                                            BorderRadius
                                                                                .all(
                                                                              Radius
                                                                                  .circular(
                                                                                  5),
                                                                            ),
                                                                          ),
                                                                          child: Column(
                                                                            children: [
                                                                              const SizedBox(
                                                                                height: 10,
                                                                              ),
                                                                              Center(
                                                                                  child:
                                                                                  Text(
                                                                                      "${data[i]
                                                                                          .instName}",
                                                                                      style: const TextStyle(
                                                                                          fontWeight: FontWeight
                                                                                              .w600,
                                                                                          color: Colors
                                                                                              .white))),
                                                                              const SizedBox(
                                                                                height: 10,
                                                                              ),
                                                                            ],
                                                                          )),
                                                                      SizedBox(
                                                                        height: sHeight(
                                                                            1.5,
                                                                            context),
                                                                      ),
                                                                      Container(
                                                                        width: sWidth(
                                                                            80,
                                                                            context),
                                                                        child: DataTable(
                                                                            border:
                                                                            TableBorder
                                                                                .all(
                                                                              //style: BorderStyle.solid,
                                                                              width: 1,
                                                                            ),
                                                                            showBottomBorder:
                                                                            true,
                                                                            showCheckboxColumn:
                                                                            true,
                                                                            sortAscending:
                                                                            true,
                                                                            dividerThickness:
                                                                            2,
                                                                            columns: [
                                                                              const DataColumn(
                                                                                label: Text(
                                                                                    "Detail"),
                                                                              ),
                                                                              const DataColumn(
                                                                                label: Text(
                                                                                    'Amount'),
                                                                              ),
                                                                              /* DataColumn(
                                                        label: Text('Amount'),
                                                      ),*/
                                                                            ],
                                                                            rows: [
                                                                              DataRow(
                                                                                  cells: [
                                                                                    const DataCell(
                                                                                        Text(
                                                                                            "Demand")),
                                                                                    DataCell(
                                                                                      Text(
                                                                                        NumberFormat
                                                                                            .currency(
                                                                                          symbol: '₹ ',
                                                                                          locale: "HI",
                                                                                          decimalDigits: 2,
                                                                                        )
                                                                                            .format(
                                                                                            data[i]
                                                                                                .demand),
                                                                                      ),
                                                                                    ),
                                                                                  ]),
                                                                              DataRow(
                                                                                  cells: [
                                                                                    const DataCell(
                                                                                        Text(
                                                                                            "Collection")),
                                                                                    DataCell(
                                                                                      Text(
                                                                                        NumberFormat
                                                                                            .currency(
                                                                                          symbol: '₹ ',
                                                                                          locale: "HI",
                                                                                          decimalDigits: 2,
                                                                                        )
                                                                                            .format(
                                                                                            data[i]
                                                                                                .collection),
                                                                                      ),
                                                                                    ),
                                                                                  ]),
                                                                              DataRow(
                                                                                  cells: [
                                                                                    const DataCell(
                                                                                        Text(
                                                                                            "Concession")),
                                                                                    DataCell(
                                                                                      Text(
                                                                                        NumberFormat
                                                                                            .currency(
                                                                                          symbol: '₹ ',
                                                                                          locale: "HI",
                                                                                          decimalDigits: 2,
                                                                                        )
                                                                                            .format(
                                                                                            data[i]
                                                                                                .concession),
                                                                                      ),
                                                                                    ),
                                                                                    // DataCell(Text("${data[i].balance}")),
                                                                                  ]),
                                                                              DataRow(
                                                                                  cells: [
                                                                                    const DataCell(
                                                                                        Text(
                                                                                            "Balance")),
                                                                                    DataCell(
                                                                                      Text(
                                                                                        NumberFormat
                                                                                            .currency(
                                                                                          symbol: '₹ ',
                                                                                          locale: "HI",
                                                                                          decimalDigits: 2,
                                                                                        )
                                                                                            .format(
                                                                                            data[i]
                                                                                                .balance),
                                                                                      ),
                                                                                    ),

                                                                                    // DataCell(Text("${data[i].balance}")),
                                                                                  ]),
                                                                            ]),
                                                                      ),
                                                                      SizedBox(
                                                                        height: sHeight(
                                                                            1.5,
                                                                            context),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ) : new Container(),
                                                              for (int i = feedata.length - 1; i >= 0; i--)
                                                                mainf == true ? Container(
                                                                  width: sWidth(90, context),
                                                                  margin: const EdgeInsets.only(
                                                                      bottom: 10),
                                                                  decoration: const BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    borderRadius:
                                                                    BorderRadius.all(
                                                                      Radius.circular(
                                                                          15),
                                                                    ),
                                                                  ),
                                                                  child: Column(
                                                                    children: [
                                                                      SizedBox(
                                                                        height: sHeight(
                                                                            1.5,
                                                                            context),
                                                                      ),
                                                                      Container(
                                                                          width: sWidth(
                                                                              80,
                                                                              context),
                                                                          decoration:
                                                                          const BoxDecoration(
                                                                            color: Colors
                                                                                .green,
                                                                            borderRadius:
                                                                            BorderRadius
                                                                                .all(
                                                                              Radius
                                                                                  .circular(
                                                                                  5),
                                                                            ),
                                                                          ),
                                                                          child: Column(
                                                                            children: [
                                                                              const SizedBox(
                                                                                height: 10,
                                                                              ),
                                                                              Center(
                                                                                  child:
                                                                                  Text(
                                                                                      "${feedata[i]
                                                                                          .feeMain}",
                                                                                      style: const TextStyle(
                                                                                          fontWeight: FontWeight
                                                                                              .w600,
                                                                                          color: Colors
                                                                                              .white))),
                                                                              const SizedBox(
                                                                                height: 10,
                                                                              ),
                                                                            ],
                                                                          )),
                                                                      SizedBox(
                                                                        height: sHeight(
                                                                            1.5,
                                                                            context),
                                                                      ),
                                                                      Container(
                                                                        width: sWidth(
                                                                            80,
                                                                            context),
                                                                        child: DataTable(
                                                                            border:
                                                                            TableBorder
                                                                                .all(
                                                                              //style: BorderStyle.solid,
                                                                              width: 1,
                                                                            ),
                                                                            showBottomBorder:
                                                                            true,
                                                                            showCheckboxColumn:
                                                                            true,
                                                                            sortAscending:
                                                                            true,
                                                                            dividerThickness:
                                                                            2,
                                                                            columns: [
                                                                              const DataColumn(
                                                                                label: Text(
                                                                                    "Detail"),
                                                                              ),
                                                                              const DataColumn(
                                                                                label: Text(
                                                                                    'Amount'),
                                                                              ),
                                                                              /* DataColumn(
                                                        label: Text('Amount'),
                                                      ),*/
                                                                            ],
                                                                            rows: [
                                                                              DataRow(
                                                                                  cells: [
                                                                                    const DataCell(
                                                                                        Text(
                                                                                            "Demand")),
                                                                                    DataCell(
                                                                                      Text(
                                                                                        NumberFormat
                                                                                            .currency(
                                                                                          symbol: '₹ ',
                                                                                          locale: "HI",
                                                                                          decimalDigits: 2,
                                                                                        )
                                                                                            .format(
                                                                                            feedata[i]
                                                                                                .demand),
                                                                                      ),
                                                                                    ),
                                                                                  ]),
                                                                              DataRow(
                                                                                  cells: [
                                                                                    const DataCell(
                                                                                        Text(
                                                                                            "Collection")),
                                                                                    DataCell(
                                                                                      Text(
                                                                                        NumberFormat
                                                                                            .currency(
                                                                                          symbol: '₹ ',
                                                                                          locale: "HI",
                                                                                          decimalDigits: 2,
                                                                                        )
                                                                                            .format(
                                                                                            feedata[i]
                                                                                                .collection),
                                                                                      ),
                                                                                    ),
                                                                                  ]),
                                                                              DataRow(
                                                                                  cells: [
                                                                                    const DataCell(
                                                                                        Text(
                                                                                            "Concession")),
                                                                                    DataCell(
                                                                                      Text(
                                                                                        NumberFormat
                                                                                            .currency(
                                                                                          symbol: '₹ ',
                                                                                          locale: "HI",
                                                                                          decimalDigits: 2,
                                                                                        )
                                                                                            .format(
                                                                                            feedata[i]
                                                                                                .concession),
                                                                                      ),
                                                                                    ),
                                                                                    // DataCell(Text("${data[i].balance}")),
                                                                                  ]),
                                                                              DataRow(
                                                                                  cells: [
                                                                                    const DataCell(
                                                                                        Text(
                                                                                            "Balance")),
                                                                                    DataCell(
                                                                                      Text(
                                                                                        NumberFormat
                                                                                            .currency(
                                                                                          symbol: '₹ ',
                                                                                          locale: "HI",
                                                                                          decimalDigits: 2,
                                                                                        )
                                                                                            .format(
                                                                                            feedata[i]
                                                                                                .balance),
                                                                                      ),

                                                                                    ),

                                                                                    // DataCell(Text("${data[i].balance}")),
                                                                                  ]),
                                                                            ]),
                                                                      ),
                                                                      SizedBox(
                                                                        height: sHeight(
                                                                            1.5,
                                                                            context),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ) : new Container(),
                                                            ],
                                                          );
                                                        }
                                                      },
                                                    ) : new Container(
                                                      child: Image.asset(
                                                          "images/Dataimg/data_not_found.png"),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                    );
                                  } else {
                                    return Container(
                                      child: Center(
                                          child: StudentsSearching(context)),
                                      color: Colors.white,
                                    );
                                  }
                                });
                          } else {
                            return Container(
                              child: Center(child: StudentsSearching(context)),
                              color: Colors.white,
                            );
                          }
                        });
                  } else {
                    return Container(
                      child: Center(child: StudentsSearching(context)),
                      color: Colors.white,
                    );
                  }
                });
  }
}

//Admin Hostel Data
class Hostel_Data extends StatefulWidget {
  const Hostel_Data({Key? key, required this.username, required this.password})
      : super(key: key);
  final String username;
  final String password;

  @override
  State<Hostel_Data> createState() => _Hostel_DataState();
}

class _Hostel_DataState extends State<Hostel_Data> {
  late Future<Host_DataList> APID_Data;

  void initState() {
    // TODO: implement initState
    super.initState();
    Hostel_Network hostel_network = Hostel_Network(
        "HostelDistrics?StaffCode=${widget.username}&Password=${widget.password}");
    APID_Data = hostel_network.Hos_loadData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: APID_Data,
        builder: (context, AsyncSnapshot<Host_DataList> snapshot) {
          if (snapshot.hasError) {
            ErrorShowingWidget(context);
          }
          List<Host_Cdata> data;
          if (snapshot.hasData) {
            data = snapshot.data!.dep_list;
            if (data.length > 0) {
              return Scaffold(
                backgroundColor: const Color.fromRGBO(242, 249, 255, 0.9),
                appBar: AppBar(
                  title: Text("Hostel Details", style: PrimaryText(context)),
                  backgroundColor: const Color(0xFF6762FF),
                ),
                body: Builder(
                    builder: (BuildContext context) => SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Center(
                            child: Column(
                              children: [
                                for (int i = data.length - 1; i >= 0; i--)
                                  Container(
                                    margin: const EdgeInsets.only(
                                      top: 8,
                                    ),
                                    width: sWidth(90, context),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: sWidth(1, context),
                                              ),
                                              Image.asset(
                                                "images/admin_image/hostel.png",
                                                scale: 1.5,
                                              ),
                                              SizedBox(
                                                width: sWidth(2, context),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: sHeight(2, context),
                                                  ),
                                                  const Text(
                                                    "Hostel Name : ",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    "${data[i].hostelName}",
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  const Text(
                                                    "District  : ",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    "${data[i].district}",
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                  const Text(
                                                    "Total Student  :",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    "${data[i].count}",
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                  SizedBox(
                                                    height: sHeight(2, context),
                                                  ),
                                                ],
                                              ),
                                            ],
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                              ],
                            ),
                          ),
                        )),
              );
            } else {
              return Scaffold(
                backgroundColor: const Color.fromRGBO(242, 249, 255, 0.9),
                appBar: AppBar(
                  title: Text("Hostel Strength", style: PrimaryText(context)),
                  backgroundColor: const Color(0xFF6762FF),
                ),
                body: Center(
                  child: Image.asset("images/Dataimg/data_not_found.png"),
                ),
              );
            }
          } else {
            return Container(
              child: Center(child: StudentsSearching(context)),
              color: Colors.white,
            );
          }
        });
  }
}

//Admin Transport Screen Data
class TransRoute extends StatefulWidget {
  const TransRoute({Key? key, required this.username, required this.password})
      : super(key: key);
  final String username;
  final String password;

  @override
  State<TransRoute> createState() => _TransRouteState();
}

class _TransRouteState extends State<TransRoute> {
  late Future<Trans_DataList> APID_Data;
  void initState() {
    // TODO: implement initState
    super.initState();
    Trans_Network trans_network = Trans_Network(
        "TransportRoute?StaffCode=${widget.username}&Password=${widget.password}");
    APID_Data = trans_network.Trans_loadData();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: APID_Data,
        builder: (context, AsyncSnapshot<Trans_DataList> snapshot) {
          if (snapshot.hasError) {
            ErrorShowingWidget(context);
          }
          List<Trans_Cdata> data;
          if (snapshot.hasData) {
            data = snapshot.data!.dep_list;
            if (data.length > 0) {
              return Scaffold(
                backgroundColor: const Color.fromRGBO(242, 249, 255, 0.9),
                appBar: AppBar(
                  title: Text("Transport Route", style: PrimaryText(context)),
                  backgroundColor: const Color(0xFF6762FF),
                ),
                body: Builder(
                    builder: (BuildContext context) => SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Center(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: sHeight(0.5, context),
                                ),
                                for (int i = data.length - 1; i >= 0; i--)
                                  Container(
                                    margin: const EdgeInsets.only(top: 8,),
                                    width: sWidth(90, context),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(Radius.circular(10),),
                                    ),
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 10,),
                                        Row(
                                          children: [
                                            SizedBox(width: sWidth(1, context),),
                                            Image.asset("images/admin_image/bus.png", scale: 1.5,),
                                            SizedBox(width: sWidth(2, context),),
                                            Container(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(height: 10,),
                                                  Container(
                                                      width: sWidth(65, context),
                                                      child: const Text("Route Name :", style: TextStyle(fontWeight: FontWeight.w600),)),
                                                  const SizedBox(height: 10,),
                                                  Container(
                                                      width: sWidth(65, context),
                                                      child: Text("${data[i].routeName}",
                                                          style: const TextStyle(fontWeight: FontWeight.w400),
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                          textAlign: TextAlign.left)),
                                                  const SizedBox(height: 10,),
                                                  Container(
                                                      width: sWidth(65, context),
                                                      child: const Text("Short Name  : ", style: TextStyle(fontWeight: FontWeight.w600),)),
                                                  const SizedBox(height: 10,),
                                                  Container(
                                                      width: sWidth(65, context),
                                                      child: Text("${data[i].routeShortName}", style: const TextStyle(fontWeight: FontWeight.w400),
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                          textAlign: TextAlign.left)),
                                                  const SizedBox(height: 10),
                                                  const Text("Count :", style: TextStyle(fontWeight: FontWeight.w600),
                                                  ),
                                                  const SizedBox(height: 10,),
                                                  Text(
                                                    "${data[i].count}", style: const TextStyle(fontWeight: FontWeight.w400),),
                                                  const SizedBox(height: 10,),
                                                ],
                                              ),
                                            ),
                                          ],
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                        ),
                                      ],
                                    ),
                                  )
                              ],
                            ),
                          ),
                        )),
              );
            } else {
              return Scaffold(
                appBar: AppBar(
                  title: Text("Transport Route", style: PrimaryText(context)),
                  backgroundColor: const Color(0xFF6762FF),
                ),
                body: Center(
                    child: Image.asset("images/Dataimg/data_not_found.png")),
              );
            }
          } else {
            return Container(
              child: Center(child: StudentsSearching(context)),
              color: Colors.white,
            );
          }
        });
  }
}

//Admission Report
class Admission_Report extends StatefulWidget {
  const Admission_Report({Key? key, required this.username, required this.password})
      : super(key: key);
  final String username;
  final String password;
  @override
  State<Admission_Report> createState() => _Admission_ReportState();
}

class _Admission_ReportState extends State<Admission_Report> {
  late Future<Admin_ReportList> APIAdminrepData;
  void initState() {
    // TODO: implement initState
    super.initState();
    AdminReport_Network adminreport_network = AdminReport_Network(
        "AdmissionReport?InstId=1&StaffCode=${widget.username}&Password=${widget.password}");
    APIAdminrepData = adminreport_network.AdminRep_loadData();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: APIAdminrepData,
        builder: (context, AsyncSnapshot<Admin_ReportList> snapshot) {
          if (snapshot.hasError) {
            ErrorShowingWidget(context);
          }
          List<Admin_Rdata> AdminR;
          if (snapshot.hasData) {
            AdminR = snapshot.data!.AdminReport_list;
            if (snapshot.hasData) {
              return Scaffold(
                backgroundColor: const Color.fromRGBO(242, 249, 255, 0.9),
                appBar: AppBar(
                  title: Text("Admission Report", style: PrimaryText(context)),
                  backgroundColor: const Color(0xFF6762FF),
                ),
                body: Builder(
                    builder: (BuildContext context) => SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Center(
                        child: Column(
                          children: [
                            SizedBox(
                              height: sHeight(2, context),
                            ),
                            for (int i = AdminR.length - 1; i >= 0; i--)
                              Container(
                                width: sWidth(90, context),
                                margin: const EdgeInsets.only(
                                    bottom: 10),
                                decoration: const BoxDecoration(
                                  color: Colors
                                      .white,
                                  borderRadius:
                                  BorderRadius.all(
                                    Radius.circular(
                                        15),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      width: sWidth(90, context),
                                      margin: const EdgeInsets.only(
                                          bottom: 10),
                                      decoration: const BoxDecoration(
                                        color: Colors
                                            .white,
                                        borderRadius:
                                        BorderRadius.all(
                                          Radius.circular(
                                              15),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          SizedBox(height: sHeight(0.8, context),),
                                          Text("COURSE : ${AdminR[i].course}",style: TextStyle(fontWeight: FontWeight.w900,color: Colors.green.shade400,fontSize: 18),),
                                          SizedBox(height: sHeight(0.3, context),),
                                          const Divider(thickness: 0.5,color: Colors.black,),
                                          SizedBox(height: sHeight(0.3, context),),
                                          Container(
                                            margin: const EdgeInsets.only(left: 10),
                                            child: Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const Text("TOTAL SANCTIONED SEATS",style: TextStyle(fontWeight: FontWeight.w900,color: Color(0xFF6762FF),fontSize: 16),),
                                                    SizedBox(height: sHeight(0.5, context),),
                                                    Text("${AdminR[i].totalseats}",style: const TextStyle(fontWeight: FontWeight.w700,),),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Divider(thickness: 0.1,color: Colors.black,),
                                          Container(
                                            margin: const EdgeInsets.only(left: 10),
                                            child: Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const Text("ADDITIONAL SEATS",style: TextStyle(fontWeight: FontWeight.w900,color: Color(0xFF6762FF),fontSize: 16),),
                                                    SizedBox(height: sHeight(0.5, context),),
                                                    Text("${AdminR[i].additionalseats}",style: const TextStyle(fontWeight: FontWeight.w700,),),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Divider(thickness: 0.1,color: Colors.black,),
                                          Container(
                                            margin: const EdgeInsets.only(left: 10),
                                            child: Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const Text("ENQUIRY",style: TextStyle(fontWeight: FontWeight.w900,color: Color(0xFF6762FF),fontSize: 16),),
                                                    SizedBox(height: sHeight(0.5, context),),
                                                  Row(
                                                    children: [
                                                      Text("MALE : ${AdminR[i].enquirymale}",style: const TextStyle(fontWeight: FontWeight.w700,),),
                                                      SizedBox(width: sWidth(5, context),),
                                                      Text("FEMALE : ${AdminR[i].enquiryfemale}",style: const TextStyle(fontWeight: FontWeight.w700,),),
                                                      SizedBox(width: sWidth(5, context),),
                                                      Text("TOTAL : ${AdminR[i].totalenquiry}",style: const TextStyle(fontWeight: FontWeight.w700,),),
                                                    ],
                                                  ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Divider(thickness: 0.1,color: Colors.black,),
                                          Container(
                                            margin: const EdgeInsets.only(left: 10),
                                            child: Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const Text("APPLICATION & ADMITTED",style: TextStyle(fontWeight: FontWeight.w900,color: Color(0xFF6762FF),fontSize: 16),),
                                                    SizedBox(height: sHeight(0.5, context),),
                                                    Row(
                                                      children: [
                                                        Text("MALE : ${AdminR[i].admissionmale}",style: const TextStyle(fontWeight: FontWeight.w700,),),
                                                        SizedBox(width: sWidth(5, context),),
                                                        Text("FEMALE : ${AdminR[i].admissionfemale}",style: const TextStyle(fontWeight: FontWeight.w700,),),
                                                        SizedBox(width: sWidth(5, context),),
                                                        Text("TOTAL : ${AdminR[i].totaladmission}",style: const TextStyle(fontWeight: FontWeight.w700,),),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Divider(thickness: 0.1,color: Colors.black,),
                                          Container(
                                            margin: const EdgeInsets.only(left: 10),
                                            child: Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const Text("DISCONTINUED",style: TextStyle(fontWeight: FontWeight.w900,color: Color(0xFF6762FF),fontSize: 16),),
                                                    SizedBox(height: sHeight(0.5, context),),
                                                    Row(
                                                      children: [
                                                        Text("MALE : ${AdminR[i].disconmale}",style: const TextStyle(fontWeight: FontWeight.w700,),),
                                                        SizedBox(width: sWidth(5, context),),
                                                        Text("FEMALE : ${AdminR[i].disconfemale}",style: const TextStyle(fontWeight: FontWeight.w700,),),
                                                        SizedBox(width: sWidth(5, context),),
                                                        Text("TOTAL : ${AdminR[i].totaldiscon}",style: const TextStyle(fontWeight: FontWeight.w700,),),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Divider(thickness: 0.1,color: Colors.black,),
                                          Container(
                                            margin: const EdgeInsets.only(left: 10),
                                            child: Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const Text("GRAND TOTAL",style: TextStyle(fontWeight: FontWeight.w900,color: Color(0xFF6762FF),fontSize: 16),),
                                                    SizedBox(height: sHeight(0.5, context),),
                                                    Row(
                                                      children: [
                                                        Text("MALE : ${AdminR[i].grandmale}",style: const TextStyle(fontWeight: FontWeight.w700,),),
                                                        SizedBox(width: sWidth(5, context),),
                                                        Text("FEMALE : ${AdminR[i].grandfemale}",style: const TextStyle(fontWeight: FontWeight.w700,),),
                                                        SizedBox(width: sWidth(5, context),),
                                                        Text("TOTAL : ${AdminR[i].grandtotal}",style: const TextStyle(fontWeight: FontWeight.w700,),),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Divider(thickness: 0.1,color: Colors.black,),
                                          Container(
                                            margin: const EdgeInsets.only(left: 10),
                                            child: Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const Text("VACANCY",style: TextStyle(fontWeight: FontWeight.w900,color: Color(0xFF6762FF),fontSize: 16),),
                                                    SizedBox(height: sHeight(0.5, context),),
                                                    Text("${AdminR[i].vacancy}",style: const TextStyle(fontWeight: FontWeight.w700,),),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            SizedBox(height: sHeight(5, context),),
                          ],
                        ),
                      ),
                    )),
              );
            } else {
              return Scaffold(
                appBar: AppBar(
                  title: Text("Admission Report", style: PrimaryText(context)),
                  backgroundColor: const Color(0xFF6762FF),
                ),
                body: Center(child: Image.asset('images/Dataimg/data_not_found.png')),
              );
            }
          } else {
            return Container(
              child: Center(child: StudentsSearching(context)),
              color: Colors.white,
            );
          }
        });
  }
}

