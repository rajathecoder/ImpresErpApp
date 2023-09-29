import 'dart:convert';

import 'package:add_dev_dolphin/Data/Staff_Data.dart';
import 'package:add_dev_dolphin/Model/Staff_Screen/staff_screen_c_1.dart';
import 'package:add_dev_dolphin/Style_font/designs.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../../Data/Student_Data.dart';


double sHeight(double per, BuildContext context) {
  double h = MediaQuery.of(context).size.height;
  return h * per / 100;
}

double sWidth(double per, BuildContext context) {
  double w = MediaQuery.of(context).size.width;
  return w * per / 100;
}

class ApplyScreen extends StatefulWidget {
  const ApplyScreen({Key? key, required this.username, required this.password})
      : super(key: key);
  final String username;
  final String password;
  @override
  State<ApplyScreen> createState() => _ApplyScreenState();
}

class _ApplyScreenState extends State<ApplyScreen> {
  late Future<Leave_Status_List> Leave_status_api;

  String? LeaveId;
  late List Leave_Cancel_ID = [];
  String? Leave_Cancel_MSG;

  _submit()async{
    final resp = await http.get(Uri.parse("http://$IpAddress/api/LeaveCancel?StaffCode=${widget.username}&LeaveId=${LeaveId}&Password=${widget.password}"),);
    print("http://$IpAddress/api/LeaveCancel?StaffCode=${widget.username}&LeaveId=${LeaveId}&Password=${widget.password}");
    if (resp.statusCode == 200) {
      print(resp.statusCode);
      Leave_Cancel_ID = json.decode(resp.body);
      Leave_Cancel_MSG =(Leave_Cancel_ID[0]['msg']);
      print(Leave_Cancel_MSG);
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
          msg: "Your Leave Request Has Been Approved",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          textColor: Colors.white,
          fontSize: 16.0
      );
      Navigator.pop(context);
    }
    // Navigator.pop(context, _selectedItems);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Leave_Status_Network Leavestatusnetwork = Leave_Status_Network(
        "LeaveStatus?StaffCode=${widget.username}&Password=${widget.password}");
    Leave_status_api = Leavestatusnetwork.Leave_st_data();
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
      body: Column(
        children: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                margin: const EdgeInsets.fromLTRB(40, 10, 40, 20),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(30)),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Staff_Leave_Apply(
                                  username: widget.username,
                                  password: widget.password,
                                )));
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.pressed)) {
                          return const Color.fromRGBO(255, 52, 62, 1);
                        }
                        return const Color.fromRGBO(255, 52, 62, 1);
                      }),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)))),
                  child: const Text(
                    'APPLY FOR LEAVE',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              )),
          const Row(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Leave Apply Status",style: TextStyle(color: Colors.black54,fontSize: 18,),
                ),
              ),
            ],
          ),
          const Row(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "* Long press to cancel leave you proposed",style: TextStyle(color: Colors.red,fontSize: 10,),
                ),
              ),
            ],
          ),
          SingleChildScrollView(
            child: FutureBuilder(
                future: Leave_status_api,
                builder:
                    (context, AsyncSnapshot<Leave_Status_List> Leavesnapshot) {
                  if (Leavesnapshot.hasError) {
                    ErrorShowingWidget(context);
                  }
                  List<Leave_Status_Data> leaveData;
                  if (Leavesnapshot.hasData) {
                    leaveData = Leavesnapshot.data!.Leave_sts_List;
                    Leave_Cancel_ID = [
                      for (int i = leaveData.length - 1; i >= 0; i--) leaveData[i].LeaveId
                    ].reversed.toList();
                    if (leaveData.length > 0) {
                      return SizedBox(
                        //height: MediaQuery.of(context).size.height,
                        height: sHeight(65, context),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                for (int i = leaveData.length - 1; i >= 0; i--)
                                  leaveData[i].Status == "Proposal".toString() ?
                                  InkWell(
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color:  Colors.white
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(13.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    SizedBox(
                                                        height: sHeight(2.5, context),
                                                        width: sWidth(60, context),
                                                        child: FittedBox(
                                                            fit: BoxFit.contain,
                                                            child: Text(leaveData[i].Reason.toUpperCase(),style: const TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.start,))
                                                    ),
                                                    Container(
                                                      height: sHeight(3.5, context),
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(5),
                                                          color: Color.fromRGBO(66, 133, 244, 1)
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            const Icon(Icons.timelapse,color: Colors.white,size: 15,),
                                                            Text(leaveData[i].Status,style: const TextStyle(color: Colors.white),),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(height: sHeight(2, context),),
                                                Row(
                                                  children: [
                                                    Text(leaveData[i].LeaveApplied,style: const TextStyle(fontWeight: FontWeight.bold),)
                                                  ],
                                                ),
                                                SizedBox(height: sHeight(2, context),),
                                                Row(
                                                  children: [
                                                    const CircleAvatar(
                                                      backgroundColor: Color(0xFF01BE84),radius: 13,
                                                      child: Icon(Icons.calendar_today,color: Colors.white,size: 15,),
                                                    ),
                                                    const Text(" Leave Date : ", style: TextStyle( fontWeight: FontWeight.bold)),
                                                    FittedBox(
                                                        fit:  BoxFit.contain,
                                                        child: Text(leaveData[i].Date, style: TextStyle( fontWeight: FontWeight.bold)))
                                                  ],
                                                ),
                                                SizedBox(height: sHeight(2, context),),
                                                Row(
                                                  children: [
                                                    const CircleAvatar(
                                                      backgroundColor: Color(0xFFE23F8B),radius: 13,
                                                      child: Icon(Icons.calendar_today,color: Colors.white,size: 15,),
                                                    ),
                                                    const FittedBox(
                                                        fit:  BoxFit.contain,
                                                        child: Text(" Applied Date : ", style: TextStyle( fontWeight: FontWeight.bold))),
                                                    Text(leaveData[i].Forword, style: TextStyle( fontWeight: FontWeight.bold))
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: sHeight(2, context),)
                                      ],
                                    ),
                                    onLongPress: (){
                                      print("${leaveData[i].LeaveId}");
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
                                                        const Text("Do you want to Cancel Leave?"),
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
                                                                final resp = await http.get(Uri.parse("http://$IpAddress/api/LeaveCancel?StaffCode=${widget.username}&LeaveId=${leaveData[i].LeaveId}&Password=${widget.password}"),);
                                                                print("http://$IpAddress/api/LeaveCancel?StaffCode=${widget.username}&LeaveId=${leaveData[i].LeaveId}&Password=${widget.password}");
                                                                if (resp.statusCode == 200) {
                                                                  print(resp.statusCode);
                                                                  Leave_Cancel_ID = json.decode(resp.body);
                                                                  Leave_Cancel_MSG =(Leave_Cancel_ID[0]['msg']);
                                                                  print(Leave_Cancel_MSG);
                                                                  await Fluttertoast.showToast(
                                                                      backgroundColor: Colors.green,
                                                                      msg: "Your Request been Canceled Successfully!",
                                                                      toastLength: Toast.LENGTH_SHORT,
                                                                      gravity: ToastGravity.SNACKBAR,
                                                                      textColor: Colors.white,
                                                                      fontSize: 16.0
                                                                  );
                                                                  Navigator.pop(context);
                                                                  Navigator.pop(context);
                                                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> ApplyScreen
                                                                    (username: widget.username, password: widget.password,)));
                                                                } else {
                                                                  // print('Request failed with status: ${resp.statusCode}.');
                                                                  await Fluttertoast.showToast(
                                                                      backgroundColor: Colors.red,
                                                                      msg: "Leave Request Has Been Approved",
                                                                      toastLength: Toast.LENGTH_SHORT,
                                                                      gravity: ToastGravity.SNACKBAR,
                                                                      textColor: Colors.white,
                                                                      fontSize: 16.0
                                                                  );
                                                                  Navigator.pop(context);
                                                                }
                                                                // Navigator.pop(context, _selectedItems);
                                                              },
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  )));
                                    },
                                  ) :
                                  Container(),
                                for (int i = leaveData.length - 1; i >= 0; i--)
                                  leaveData[i].Status == "Escalated".toString() ?
                                  /*InkWell(
                                    child:*/
                                  Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                           color: Colors.white,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(13.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    SizedBox(
                                                        height: sHeight(2.5, context),
                                                        width: sWidth(60, context),
                                                        child: FittedBox(
                                                            fit: BoxFit.contain,
                                                            child: Text(leaveData[i].Reason.toUpperCase(), style: TextStyle( fontWeight: FontWeight.bold),textAlign: TextAlign.start,))
                                                    ),
                                                    Container(
                                                      height: sHeight(3.5, context),
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(5),
                                                          color: Color.fromRGBO(247,181,41,1)
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            const Icon(Icons.timelapse,color: Colors.white,size: 15,),
                                                            Text(leaveData[i].Status,style: const TextStyle(color: Colors.white),),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(height: sHeight(1.5, context),),
                                                Row(
                                                  children: [
                                                    Text(leaveData[i].LeaveApplied, style: TextStyle( fontWeight: FontWeight.bold))
                                                  ],
                                                ),
                                                SizedBox(height: sHeight(1.5, context),),
                                                Row(
                                                  children: [
                                                    const CircleAvatar(
                                                      backgroundColor: Color(0xFF01BE84),radius: 13,
                                                      child: Icon(Icons.calendar_today,color: Colors.white,size: 15,),
                                                    ),
                                                    const Text(" Leave Date : ", style: TextStyle( fontWeight: FontWeight.bold)),
                                                    FittedBox(
                                                        fit:  BoxFit.contain,
                                                        child: Text(leaveData[i].Date, style: TextStyle( fontWeight: FontWeight.bold)))
                                                  ],
                                                ),
                                                SizedBox(height: sHeight(2, context),),
                                                Row(
                                                  children: [
                                                    const CircleAvatar(
                                                      backgroundColor: Color(0xFFE23F8B),radius: 13,
                                                      child: Icon(Icons.calendar_today,color: Colors.white,size: 15,),
                                                    ),
                                                    const FittedBox(
                                                        fit:  BoxFit.contain,
                                                        child: Text(" Applied Date : ", style: TextStyle( fontWeight: FontWeight.bold))),
                                                    Text(leaveData[i].Forword, style: TextStyle( fontWeight: FontWeight.bold))
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: sHeight(2, context),)
                                      ],
                                    ):
                                    /*onLongPress: (){
                                      print("${leaveData[i].LeaveId}");
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
                                                        const Text("Do you want to Cancel Leave?"),
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
                                                                final resp = await http.get(Uri.parse("http://$IpAddress/api/LeaveCancel?StaffCode=${widget.username}&LeaveId=${leaveData[i].LeaveId}&Password=${widget.password}"),);
                                                                print("http://$IpAddress/api/LeaveCancel?StaffCode=${widget.username}&LeaveId=${leaveData[i].LeaveId}&Password=${widget.password}");
                                                                if (resp.statusCode == 200) {
                                                                  print(resp.statusCode);
                                                                  Leave_Cancel_ID = json.decode(resp.body);
                                                                  Leave_Cancel_MSG =(Leave_Cancel_ID[0]['msg']);
                                                                  print(Leave_Cancel_MSG);
                                                                  await Fluttertoast.showToast(
                                                                      backgroundColor: Colors.green,
                                                                      msg: "Your Request been Canceled Successfully!",
                                                                      toastLength: Toast.LENGTH_SHORT,
                                                                      gravity: ToastGravity.SNACKBAR,
                                                                      textColor: Colors.white,
                                                                      fontSize: 16.0
                                                                  );
                                                                  Navigator.pop(context);
                                                                  Navigator.pop(context);
                                                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> ApplyScreen
                                                                    (username: widget.username, password: widget.password,)));
                                                                } else {
                                                                  // print('Request failed with status: ${resp.statusCode}.');
                                                                  await Fluttertoast.showToast(
                                                                      backgroundColor: Colors.red,
                                                                      msg: "Leave Request Has Been Approved",
                                                                      toastLength: Toast.LENGTH_SHORT,
                                                                      gravity: ToastGravity.SNACKBAR,
                                                                      textColor: Colors.white,
                                                                      fontSize: 16.0
                                                                  );
                                                                  Navigator.pop(context);
                                                                }
                                                                // Navigator.pop(context, _selectedItems);
                                                              },
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  )));
                                    },
                                  ) */
                                  Container(),
                                for (int i = leaveData.length - 1; i >= 0; i--)
                                  leaveData[i].Status == "Approved".toString() ?
                                  Column(
                                    children: [
                                      /*InkWell(
                                        child:*/ Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              color: Colors.white
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(13.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    SizedBox(
                                                      height: sHeight(2.5, context),
                                                      width: sWidth(60, context),
                                                      child: FittedBox(
                                                        fit: BoxFit.contain,
                                                          child: Text(leaveData[i].Reason.toUpperCase(), style: TextStyle( fontWeight: FontWeight.bold),))
                                                    ),
                                                    Container(
                                                      height: sHeight(3.5, context),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(5),
                                                        color: Color.fromRGBO(51,182,121,1)
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            const Icon(Icons.timelapse,color: Colors.white,size: 15,),
                                                            FittedBox(
                                                                fit: BoxFit.contain,
                                                                child: Text(leaveData[i].Status,style: const TextStyle(color: Colors.white,),)),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(height: sHeight(1.5, context),),
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                        height: sHeight(2.5, context),
                                                        width: sWidth(85, context),
                                                        child: Text(" ${leaveData[i].LeaveApplied}",maxLines: 2, style: TextStyle( fontWeight: FontWeight.bold))
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: sHeight(1.5, context),),
                                                Row(
                                                  children: [
                                                    const CircleAvatar(
                                                      backgroundColor:  Color(0xFF01BE84),radius: 13,
                                                      child: Icon(Icons.calendar_today,color:  Colors.white,size: 15,),
                                                    ),
                                                    const Text(" Leave Date : ", style: TextStyle( fontWeight: FontWeight.bold)),
                                                    Text(leaveData[i].Date, style: TextStyle( fontWeight: FontWeight.bold))
                                                  ],
                                                ),
                                                SizedBox(height: sHeight(2, context),),
                                                Row(
                                                  children: [
                                                    const CircleAvatar(
                                                      backgroundColor: Color(0xFFE23F8B),radius: 13,
                                                      child: Icon(Icons.calendar_today,color: Colors.white,size: 15,),
                                                    ),
                                                    const Text(" Applied Date : ", style: TextStyle( fontWeight: FontWeight.bold)),
                                                    Text(leaveData[i].Forword, style: TextStyle( fontWeight: FontWeight.bold))
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        /*onLongPress: (){
                                          print("${leaveData[i].LeaveId}");
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
                                                            const Text("Do you want to Cancel Leave?"),
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
                                                                        _submit();
                                                                  },
                                                                )
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      )));
                                        },*/
                                      //),
                                      SizedBox(height: sHeight(2, context),)
                                    ],
                                  ) :
                                      Container(),
                                for (int i = leaveData.length - 1; i >= 0; i--)
                                  leaveData[i].Status == "Cancelled".toString() ?
                                  /*InkWell(
                                    child:*/ Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Colors.white

                                    /*gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment(0, 1),
                                    colors: [
                                      Color.fromRGBO(250,80,100,1),
                                      Color.fromRGBO(250,80,100,1),
                                    ], */// Gradient from https://learnui.design/tools/gradient-generator.html
                                    //tileMode: TileMode.mirror,
                                  //),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(13.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    SizedBox(
                                                        height: sHeight(2.5, context),
                                                        width: sWidth(60, context),
                                                        child: FittedBox(
                                                            fit: BoxFit.contain,
                                                            child: Text(leaveData[i].Reason.toUpperCase(),style: TextStyle( fontWeight: FontWeight.bold),textAlign: TextAlign.start,))
                                                    ),
                                                    Container(
                                                      height: sHeight(3.5, context),
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(5),
                                                          color: Color.fromRGBO(219,65,55,1)
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            const Icon(Icons.timelapse,color: Colors.white,size: 15,),
                                                            Text(leaveData[i].Status,style: const TextStyle(color: Colors.white),),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(height: sHeight(1.5, context),),
                                                Row(
                                                  children: [
                                                    Text(leaveData[i].LeaveApplied, style: TextStyle( fontWeight: FontWeight.bold))
                                                  ],
                                                ),
                                                SizedBox(height: sHeight(1.5, context),),
                                                Row(
                                                  children: [
                                                    const CircleAvatar(
                                                      backgroundColor: Color(0xFF01BE84),radius: 13,
                                                      child: Icon(Icons.calendar_today,color: Colors.white,size: 15,),
                                                    ),
                                                    const Text(" Leave Date : ", style: TextStyle( fontWeight: FontWeight.bold)),
                                                    FittedBox(
                                                        fit:  BoxFit.contain,
                                                        child: Text(leaveData[i].Date, style: TextStyle( fontWeight: FontWeight.bold),))
                                                  ],
                                                ),
                                                SizedBox(height: sHeight(2, context),),
                                                Row(
                                                  children: [
                                                    const CircleAvatar(
                                                      backgroundColor:  Colors.red,radius: 13,
                                                      child: Icon(Icons.calendar_today,color: Colors.white,size: 15,),
                                                    ),
                                                    const FittedBox(
                                                        fit:  BoxFit.contain,
                                                        child: Text(" Applied Date : ", style: TextStyle( fontWeight: FontWeight.bold))),
                                                    Text(leaveData[i].Forword, style: TextStyle( fontWeight: FontWeight.bold))
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: sHeight(2, context),)
                                      ],
                                    ) :
                                    /*onLongPress: (){
                                      print("${leaveData[i].LeaveId}");
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
                                                        const Text("Do you want to Cancel Leave?"),
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
                                                                final resp = await http.get(Uri.parse("http://$IpAddress/api/LeaveCancel?StaffCode=${widget.username}&LeaveId=${leaveData[i].LeaveId}&Password=${widget.password}"),);
                                                                print("http://$IpAddress/api/LeaveCancel?StaffCode=${widget.username}&LeaveId=${leaveData[i].LeaveId}&Password=${widget.password}");
                                                                if (resp.statusCode == 200) {
                                                                  print(resp.statusCode);
                                                                  Leave_Cancel_ID = json.decode(resp.body);
                                                                  Leave_Cancel_MSG =(Leave_Cancel_ID[0]['msg']);
                                                                  print(Leave_Cancel_MSG);
                                                                  await Fluttertoast.showToast(
                                                                      backgroundColor: Colors.green,
                                                                      msg: "Your Request been Canceled Successfully!",
                                                                      toastLength: Toast.LENGTH_SHORT,
                                                                      gravity: ToastGravity.SNACKBAR,
                                                                      textColor: Colors.white,
                                                                      fontSize: 16.0
                                                                  );
                                                                  Navigator.pop(context);
                                                                  Navigator.pop(context);
                                                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> ApplyScreen
                                                                    (username: widget.username, password: widget.password,)));
                                                                } else {
                                                                  // print('Request failed with status: ${resp.statusCode}.');
                                                                  await Fluttertoast.showToast(
                                                                      backgroundColor: Colors.red,
                                                                      msg: "Leave Request Has Been Approved",
                                                                      toastLength: Toast.LENGTH_SHORT,
                                                                      gravity: ToastGravity.SNACKBAR,
                                                                      textColor: Colors.white,
                                                                      fontSize: 16.0
                                                                  );
                                                                  Navigator.pop(context);
                                                                }
                                                                // Navigator.pop(context, _selectedItems);
                                                              },
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  )));
                                    },*/
                                  //) :
                                  Container(),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Container(
                          color: Colors.white,
                          child: Center(
                              child: Image.asset(
                                  "images/Dataimg/data_not_found.png")),
                      );
                    }
                  } else {
                    return Container(
                      /*child: Center(
                          child: Image.asset(
                              "images/Dataimg/data_not_found.png")),
                      color: Colors.white,*/
                    );
                  }
                }),
          )
        ],
      ),
    );
  }
}
