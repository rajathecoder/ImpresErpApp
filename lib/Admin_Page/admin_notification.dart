import 'package:add_dev_dolphin/Local_Data/notification_database.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Style_font/designs.dart';
import '../main.dart';

class Admin_Notification_screen extends StatefulWidget {
  @override
  State<Admin_Notification_screen> createState() => _Admin_Notification_screenState();
}

class _Admin_Notification_screenState extends State<Admin_Notification_screen> {
  late DatabaseHandler handler;
  late Future<List<todo>> _todo;
  @override
  void initState() {
    super.initState();
    _todo = getList();
    handler = DatabaseHandler();
    handler.initializeDB().whenComplete(() async {
      setState(() {
        _todo = getList();
      });
      await refreshNotes();
    });

  }

  Future<List<todo>> getList() async {
    return await handler.todos();
  }

  Future<void> _onRefresh() async {
    setState(() {
      _todo = getList();
    });
    await refreshNotes();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications",
            style: PrimaryText(context)),
        backgroundColor: Color(0xFF6762FF),
      ),
      body: FutureBuilder<List<todo>>(
        future: _todo,
        builder: (BuildContext context, AsyncSnapshot<List<todo>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return new Center(
              child: new CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return new Text('Error: ${snapshot.error}');
          } else {
            final items = snapshot.data ?? <todo>[];
            return Scrollbar(
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Dismissible(
                      direction: DismissDirection.startToEnd,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: const Icon(Icons.delete_forever,color: Colors.black,),
                      ),
                      key: ValueKey<int>(items[index].id),
                      onDismissed: (DismissDirection direction) async {
                        await handler.deletetodo(items[index].id);
                        setState(() {
                          items.remove(items[index]);
                        });
                        await refreshNotes();
                      },
                      child: InkWell(
                        onTap: ()async{
                          if (!await launchUrl(Uri.parse("${items[index].URL}"),mode: LaunchMode.externalApplication));
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 10),
                          width: 400,
                          color: index % 2 == 0 ? Colors.white70 : Colors.black12,
                          child: Column(
                            children: [
                              SizedBox(height: 10,),
                              Text("Title :  ${items[index].title}"),
                              SizedBox(height: 10,),
                              Text("Description :  ${items[index].description.toString()}"),
                              SizedBox(height: 10,),
                              Text("Date & Time :  ${items[index].Date}"),
                              SizedBox(height: 10,),
                              items[index].URL.toString() == ''.toString() ? Text("") : Text("Click to Redirect :  ${items[index].URL}") ,
                              SizedBox(height: 10,),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }
}