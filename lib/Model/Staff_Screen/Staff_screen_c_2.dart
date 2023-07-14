import 'package:add_dev_dolphin/Data/Staff_Data.dart';
import 'package:add_dev_dolphin/Model/Staff_Screen/staff_screen_c_1.dart';
import 'package:add_dev_dolphin/Style_font/designs.dart';
import 'package:flutter/material.dart';


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
        backgroundColor: Color.fromRGBO(255, 98, 118, 1),
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
                          return Color.fromRGBO(255, 52, 62, 1);
                        }
                        return Color.fromRGBO(255, 52, 62, 1);
                      }),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)))),
                  child: Text(
                    'APPLY FOR LEAVE',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              )),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Leave Apply Status",style: TextStyle(color: Colors.black54,fontSize: 18,),
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
                  List<Leave_Status_Data> Leave_data;
                  if (Leavesnapshot.hasData) {
                    Leave_data = Leavesnapshot.data!.Leave_sts_List;
                    if (Leave_data.length > 0) {
                      return Container(
                        //height: MediaQuery.of(context).size.height,
                        height: sHeight(70, context),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                for (int i = Leave_data.length - 1; i >= 0; i--)
                                  Leave_data[i].Status == "Approved".toString() ?
                                  Column(
                                    children: [
                                      InkWell(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              color: Color(0xFFECFFF4),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(13.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Container(
                                                      height: sHeight(2.5, context),
                                                      width: sWidth(60, context),
                                                      child: FittedBox(
                                                        fit: BoxFit.contain,
                                                          child: Text(" ${Leave_data[i].LeaveApplied}".toUpperCase(),style: TextStyle(color: Color(0xFF141414),),))
                                                    ),
                                                    Container(
                                                      height: sHeight(3.5, context),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                        color: Color(0xFFD1FFF1)
                                                      ),
                                                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Icon(Icons.timelapse,color: Color(0xFF01BE84),size: 15,),
                                                          FittedBox(
                                                              fit: BoxFit.contain,
                                                              child: Text("${Leave_data[i].Status}",style: TextStyle(color: Color(0xFF01BE84)),)),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(height: sHeight(2, context),),
                                                Row(
                                                  children: [
                                                    Container(
                                                        height: sHeight(2.5, context),
                                                        width: sWidth(85, context),
                                                        child: FittedBox(
                                                            fit: BoxFit.contain,
                                                            child: Text("${Leave_data[i].Reason}",maxLines: 2,)
                                                        )
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: sHeight(2, context),),
                                                Row(
                                                  children: [
                                                    CircleAvatar(
                                                      child: Icon(Icons.calendar_today,color: Colors.white,size: 15,),backgroundColor: Color(0xFF01BE84),radius: 13,
                                                    ),
                                                    Text(" Leave Date : ",style: TextStyle(color: Colors.black54)),
                                                    Text("${Leave_data[i].Date}")
                                                  ],
                                                ),
                                                SizedBox(height: sHeight(2, context),),
                                                Row(
                                                  children: [
                                                    CircleAvatar(
                                                      child: Icon(Icons.calendar_today,color: Colors.white,size: 15,),backgroundColor: Color(0xFFE23F8B),radius: 13,
                                                    ),
                                                    Text(" Applied Date : ",style: TextStyle(color: Colors.black54),),
                                                    Text("${Leave_data[i].Forword}")
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        onTap: (){
                                          //print("${Leave_data[i].Approved}");
                                        },
                                      ),
                                      SizedBox(height: sHeight(2, context),)
                                    ],
                                  ) :
                                  InkWell(
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Color(0xFFFFF1F0)
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(13.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Container(
                                                        height: sHeight(2.5, context),
                                                        width: sWidth(60, context),
                                                        child: FittedBox(
                                                            fit: BoxFit.contain,
                                                            child: Text("${Leave_data[i].Reason}".toUpperCase(),style: TextStyle(color: Color(0xFF141414),),textAlign: TextAlign.start,))
                                                    ),
                                                    Container(
                                                      height: sHeight(3.5, context),
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(5),
                                                          color: Color(0xFFFCDEE2)
                                                      ),
                                                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Icon(Icons.timelapse,color: Color(0xFFFF343E),size: 15,),
                                                          Text("${Leave_data[i].Status}",style: TextStyle(color: Color(0xFFFF343E)),),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(height: sHeight(2, context),),
                                                Row(
                                                  children: [
                                                    Text("${Leave_data[i].LeaveApplied}")
                                                  ],
                                                ),
                                                SizedBox(height: sHeight(2, context),),
                                                Row(
                                                  children: [
                                                    CircleAvatar(
                                                      child: Icon(Icons.calendar_today,color: Colors.white,size: 15,),backgroundColor: Color(0xFF01BE84),radius: 13,
                                                    ),
                                                    Text(" Leave Date : "),
                                                    FittedBox(
                                                        fit:  BoxFit.contain,
                                                        child: Text("${Leave_data[i].Date}"))
                                                  ],
                                                ),
                                                SizedBox(height: sHeight(2, context),),
                                                Row(
                                                  children: [
                                                    CircleAvatar(
                                                      child: Icon(Icons.calendar_today,color: Colors.white,size: 15,),backgroundColor: Color(0xFFE23F8B),radius: 13,
                                                    ),
                                                    FittedBox(
                                                        fit:  BoxFit.contain,
                                                        child: Text(" Applied Date : ")),
                                                    Text("${Leave_data[i].Forword}")
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: sHeight(2, context),)
                                      ],
                                    ),
                                    onTap: (){},
                                  )
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Container(
                          child: Center(
                              child: Image.asset(
                                  "images/Dataimg/data_not_found.png")),
                          color: Colors.white,
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
