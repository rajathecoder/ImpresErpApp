import 'dart:async';
import 'dart:convert';
import 'package:add_dev_dolphin/Data/Student_Data.dart';
import 'package:add_dev_dolphin/Style_font/designs.dart';
import 'package:add_dev_dolphin/UI/main_ui.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../main.dart';
//Certificate request

class Student_C_Request extends StatefulWidget {
  const Student_C_Request({Key? key ,required this.username, required this.password}) : super(key: key);
  final String username;
  final String password;
  @override
  State<Student_C_Request> createState() => _Student_C_RequestState();
}

class _Student_C_RequestState extends State<Student_C_Request> {
  late ConnectivityResult results;
  late StreamSubscription subscription;
  checkInternet() async {
    results = await Connectivity().checkConnectivity();
    if (results != ConnectivityResult.none) {
      isConnected = true;
    }
    else {
      isConnected = false;
      showDialogbox();
    }
    setState(() {

    });
  }
  showDialogbox() {
    showDialog(
        barrierDismissible: false,
        context: context, builder: (context) =>
        CupertinoAlertDialog(
          title: const Text("No Internet"),
          content: const Text("Please check your Internet Connection and Try Again"),
          actions: [
            CupertinoButton.filled(child: const Text("OK"), onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            }),
          ],
        ));
  }
  startStreaming() {
    subscription = Connectivity().onConnectivityChanged.listen((event) async {
      checkInternet();
    });
  }
  late Future <Data_List> APIData;
  late Future <Cer_Req_List> Creq_API_Data;
  late  List<String> items = [];
  final List<String> _selectedItems = [];
  late List Cer_YrN = [];
  DateTime now = DateTime.now();
  String? CH_date = "Choose";
  String? CH_dateEntry;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Cer_Req_Network cer_req_network = Cer_Req_Network("CertificateRequest?StudentCode=${widget.username}&Password=${widget.password}");
    Creq_API_Data = cer_req_network.CerR_loadData();
  }
  bool isChecked = false;
   List<String> items1 = [];
  void _itemChange1(String itemvalue, bool isSele){
    setState(() {
      if(isSele){
        _selectedItems.add(itemvalue);
      }
      else{
        _selectedItems.remove(itemvalue);
      }
    });
  }
  _check()async{
    if(_selectedItems.map((e) => (e.replaceAll(RegExp(r'\D+'), ''))).join(",") == "".toString()){
      await Fluttertoast.showToast(
          backgroundColor: Colors.red,
          msg: "Sorry!Kindly Select Request Type",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
    else{
      await  _submit();
    }
  }
   _submit()async{
    final resp = await http.get(Uri.parse("http://$IpAddress/api/MergeCertificate?StudentCode=${widget.username}&Password=${widget.password}&NeedDate=${CH_dateEntry}&TypeId=${_selectedItems.map((e) => (e.replaceAll(RegExp(r'\D+'), ''))).join(",")}"),);
    if (resp.statusCode == 200) {
      print(resp.statusCode);
      Cer_YrN = json.decode(resp.body);
      Cer_MSG =(Cer_YrN[0]['msg']);
      print(Cer_MSG);
      await Fluttertoast.showToast(
          backgroundColor: Colors.green,
          msg: "Your Request been Send Successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          textColor: Colors.white,
          fontSize: 16.0
      );
      // Navigator.push(context, MaterialPageRoute(builder: (context)=>
      //     (username: widget.username, password: widget.password,)));
    } else {
      // print('Request failed with status: ${resp.statusCode}.');
      await Fluttertoast.showToast(
          backgroundColor: Colors.red,
          msg: "Sorry!Kindly Select Request Date",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,

          textColor: Colors.white,
          fontSize: 16.0
      );
    }
    // Navigator.pop(context, _selectedItems);
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Creq_API_Data,
        builder: (context, AsyncSnapshot<Cer_Req_List> snapshot) {
          if (snapshot.hasError) {
            ErrorShowingWidget(context);
          }
          List<Cer_Req_Data> data;
          if (snapshot.hasData) {
            data = snapshot.data!.Cer_RR_List;
            items = [for (int i = data.length - 1; i >= 0; i--)
              "${data[i].txt} ${data[i].id}"
            ];
            items1 = [for (int i = data.length - 1; i >= 0; i--)
              "${data[i].txt} ${data[i].id}"
            ];
            if (snapshot.hasData) {
              return Scaffold(
                body: SingleChildScrollView(
                     scrollDirection: Axis.vertical,
                     child: Column(
                      children: [
                      //   Text(Cer_MSG.toString()),
                        SizedBox(height: sHeight(1.5, context),),
                        Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: sWidth(45, context)),
                              child: const Text("Select Your Need Date",style: TextStyle(color: Colors.black45,fontWeight: FontWeight.w600),),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(width: sWidth(5, context),),
                                Card(
                                  elevation: 3,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white70,
                                      borderRadius: BorderRadius.all(Radius.circular(15))
                                    ),
                                    child: IconButton( onPressed: () {
                                      showDatePicker(
                                         context: context,
                                       initialDate: DateTime.now(),
                                       firstDate: DateTime.now(),
                                     lastDate: DateTime(2100),
                                        ).then((
                                        value) async {
                                        CH_date = DateFormat('EEEE, MMM d').format(value!) as String;
                                        CH_dateEntry = DateFormat('dd/MM/yyyy').format(value) as String;
                                        print(CH_dateEntry);
                                        setState(() {

                                        });
                                               });
                                       },icon: const Icon(Icons.calendar_month,color: Color.fromRGBO(31, 16, 148, 1.0),size: 25,)),
                                  ),
                                ),
                                SizedBox(width: sWidth(3, context),),
                                Text("${CH_date}",style: const TextStyle(color: Colors.black87,fontWeight: FontWeight.w600,fontSize: 15),),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: sHeight(1.5, context),),
                        Container(
                          height: sHeight(60, context),
                          width: sWidth(90, context),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey)
                          ),
                          child:
                          SingleChildScrollView(
                            child: ListBody(
                              children:
                              items1.map((item) => CheckboxListTile(
                                value: _selectedItems.contains(item),
                                title: Text(item.replaceAll(RegExp(r'\d+'), ''),
                                  style: const TextStyle(color: Colors.black87,fontSize: 15),),
                                controlAffinity: ListTileControlAffinity.leading,
                                onChanged: (isChecked) => _itemChange1(item, isChecked!),
                              )).toList(),
                            ),
                          ),
                        ),
                        SizedBox(height: sHeight(3, context),),
                        InkWell(
                          child: Container(
                            height: sHeight(6, context),
                            width: sWidth(90, context),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(11),
                              color: const Color.fromRGBO(31, 16, 148, 1.0),
                            ),
                            child: const Center(
                                child: Text(
                                  "Request Permission",
                                  style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.w600),
                                )),
                          ),
                          onTap: ()async {
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
                                              "Do you want to Submit?"),
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
                                                  await _check();
                                                  Navigator.pop(context);
                                                },
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    )));

                          },
                        ),
                        SizedBox(height: sHeight(10, context),),
                      ],
                  ),
                   ),
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
              child: Center(child: StudentsSearching(context)),
              color: Colors.white,
            );
          }
        });
  }
}

// Certificate Status
class Student_Certificate_Status extends StatefulWidget {
  const Student_Certificate_Status(
      {Key? key, required this.username, required this.password})
      : super(key: key);
  final String username;
  final String password;

  @override
  State<Student_Certificate_Status> createState() =>
      _Student_Certificate_StatusState();
}

class _Student_Certificate_StatusState extends State<Student_Certificate_Status> {
  late Future<Cer_Status_List> Cer_Status_API;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Cer_Status_Req_Network cer_status_req_network = Cer_Status_Req_Network(
        "CertificateStatus?StudentCode=${widget.username}&Password=${widget.password}");
    Cer_Status_API = cer_status_req_network.CerS_loadData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Cer_Status_API,
        builder: (context, AsyncSnapshot<Cer_Status_List> snapshot) {
          if (snapshot.hasError) {
            ErrorShowingWidget(context);
          }
          List<Cer_Status_Data> data_St;
          if (snapshot.hasData) {
            data_St = snapshot.data!.Cer_S_List;
            if (data_St.length > 0) {
              return Scaffold(
                backgroundColor:  const Color.fromRGBO(242, 249, 250, 0.9),
                body: Builder(
                    builder: (BuildContext context) => SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: sHeight(2, context),
                          ),
                          Column(
                            children: [
                              for (int i = data_St.length - 1; i >= 0; i--)
                                Column(
                                  children: [
                                    Container(
                                      width: sWidth(90, context),
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(15),
                                          )),
                                      padding: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                  height: sHeight(7, context),
                                                  width: sWidth(55, context),
                                                  child: Center(
                                                    child: FittedBox(
                                                        fit: BoxFit.cover,
                                                        child: Text(data_St[i].certificaterequest,maxLines: 2,softWrap: true,style: const TextStyle(fontWeight: FontWeight.bold),)
                                                    ),
                                                  ),),
                                              data_St[i].readydate == "".toString() ?
                                              Container(
                                                  height: sHeight(
                                                      4, context),
                                                  width: sWidth(18, context),
                                                  decoration:
                                                  const BoxDecoration(
                                                      color: Colors.red,
                                                      borderRadius:
                                                      BorderRadius
                                                          .all(
                                                        Radius
                                                            .circular(
                                                            15),
                                                      )),
                                                  child: const Center(child: Text("Pending",style: TextStyle(color: Colors.white),))):
                                              Container(
                                                  height: sHeight(4, context),
                                                  width: sWidth(18, context),
                                                  decoration:
                                                  const BoxDecoration(
                                                      color: Colors.green,
                                                      borderRadius:
                                                      BorderRadius
                                                          .all(
                                                        Radius
                                                            .circular(
                                                            15),
                                                      )),
                                                  child: const Center(child: Text("Approved",style: TextStyle(color: Colors.white)))),
                                            ],
                                          ),
                                          SizedBox(
                                            height: sHeight(2, context),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                  // height: sHeight(7, context),
                                                  width: sWidth(20, context),
                                                  decoration:
                                                  const BoxDecoration(
                                                      color: Color
                                                          .fromRGBO(
                                                          241,
                                                          133,
                                                          67,
                                                          0.9568627450980393),
                                                      borderRadius:
                                                      BorderRadius
                                                          .all(
                                                        Radius
                                                            .circular(
                                                            8),
                                                      )),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .center,
                                                    children: [
                                                      SizedBox(height: sHeight(0.5, context),),
                                                      const Text(
                                                        "Need in date",
                                                        style: TextStyle(
                                                            fontWeight:
                                                            FontWeight
                                                                .bold,
                                                            color: Colors
                                                                .white,fontSize: 10),
                                                      ),
                                                      Text(
                                                        data_St[i]
                                                            .needdate,
                                                        style: const TextStyle(
                                                            color: Colors
                                                                .white,fontSize: 10),
                                                      ),
                                                      SizedBox(height: sHeight(0.5, context),),
                                                    ],
                                                  )),
                                              Container(
                                                  width: sWidth(35, context),
                                                  decoration:
                                                  const BoxDecoration(
                                                      color: Color
                                                          .fromRGBO(38, 123, 183, 0.9607843137254902),
                                                      borderRadius:
                                                      BorderRadius
                                                          .all(
                                                        Radius
                                                            .circular(
                                                            8),
                                                      )),
                                                  child: Column(
                                                    children: [
                                                      SizedBox(height: sHeight(0.5, context),),
                                                      const Text(
                                                        "Requested Date",
                                                        style: TextStyle(
                                                            fontWeight:
                                                            FontWeight
                                                                .bold,color: Colors.white,fontSize: 10),
                                                      ),
                                                      Text(data_St[i].requestdate,style: const TextStyle(color: Colors.white,fontSize: 10),),
                                                      SizedBox(height: sHeight(0.5, context),),
                                                    ],
                                                  )),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: sHeight(1, context),
                                    ),
                                  ],
                                ),
                              Container(
                                margin: const EdgeInsets.only(top: 20.0),
                              )
                            ],
                          ),

                        ],
                      ),
                    )),
              );
            }
            else {
              return Container(
                child: Center(child: Image.asset(
                    "images/Dataimg/data_not_found.png")),
                color: Colors.white,
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

//Certifiacte Tabs
class Certificate_Request extends StatelessWidget {
  const Certificate_Request({Key? key,required this.username, required this.password}) : super(key: key);
  final String username;
  final String password;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Certificate Request'),
          backgroundColor: PrimaryColor(),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            TabBar(
              indicator: BoxDecoration(
                  color: const Color(0xFFF97A52),
                  borderRadius: BorderRadius.circular(10)),
              tabs: const [
                Tab(
                  child: Text(
                    'Request',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Tab(
                  child: Text(
                    'Status',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
            Expanded(
                child: TabBarView(children: [
                  Student_C_Request(username: username, password: password,),
                  Student_Certificate_Status(username: username, password: password,),
                ])),
          ],
        ),
      ),
    );
  }
}
