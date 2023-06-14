import 'package:add_dev_dolphin/Data/Staff_Data.dart';
import 'package:add_dev_dolphin/UI/main_ui.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';

//Colors Custom
Color PrimaryColor() => Colors.blue.shade900;

Color SecondaryColor() => Colors.blue;

Color ErrorColor() => Colors.red;

Color WarningColor() => Colors.yellow.shade900;

Color PhotoColor() => Colors.black;

Color LineColor1() => Colors.white;

Color LineColor2() => Colors.black54;

Color CardColor() => Colors.black12;

LinearGradient LineColorGradient() => LinearGradient(
    colors: [
      Colors.transparent,
      LineColor2(),
      Colors.transparent,
      Colors.transparent
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.9, 0.91, 0.94, 1]);

// Style Custom
TextStyle PrimaryText(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
  if (screenWidth <500)
    {
      return const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      );
  }
  else{
    return const TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
    }
}
Widget AttendanceProfile10(String content, double topMar, double leftMar) =>
    Container(
        margin: EdgeInsets.only(top: topMar, left: leftMar),
        height: 25.0,
        child: SizedBox(child: Text(content, style: PrimaryText6())));
TextStyle  PrimaryText5() =>TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.w700,
  color: Colors.black,
);
TextStyle PrimaryText6() => TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.w700,
  color: Colors.green,
);
TextStyle PrimaryText01() {
  return const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
}
TextStyle SecondaryText() => TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: Colors.black54,
    );
TextStyle SecondaryText4() => TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w900,
      color: Colors.black54,
    );
TextStyle SecondaryText1() => const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w900,
      color: Colors.black,
    );

TextStyle SecondaryTextSmall01() => const TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w500,
  color: Colors.white,
);

TextStyle ErrorText() => const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    );

TextStyle PrimaryText2() => TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    );
TextStyle PrimaryText4() => TextStyle(
  fontSize: 13,
  fontWeight: FontWeight.w700,
  color: Colors.black,
);
TextStyle PrimaryText7() => TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w700,
  color: Color.fromRGBO(0, 51, 153,1),
);
TextStyle PrimaryText3() => const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: Color.fromRGBO(214, 111, 26, 1),
  fontFamily: "Yaahowu",

    );

TextStyle PrimaryText2Big() => TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    );

TextStyle PrimaryText2Small() => const TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w700,
  color: Colors.black,
);
TextStyle PrimaryText3Small() => const TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w400,
  color: Colors.black,
);

TextStyle ErrorText2Big() => const TextStyle(
  fontSize: 25,
  fontWeight: FontWeight.w700,
  color: Colors.red,
);

TextStyle SecondaryText2() => const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: Colors.black54,
    );
 TextStyle SecondaryText3() => TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w600,
    );

TextStyle SecondaryTextSmall() => const TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w700,
  color: Colors.black54,
);

TextStyle SecondaryTextSmall1() => const TextStyle(
  fontSize: 10,
  fontWeight: FontWeight.w700,
  color: Colors.black54,
);

TextStyle ColorText(String text) {
  if (text.toLowerCase() == "pass" || text.toLowerCase() == 'p' || text.toLowerCase() == 'od')
    {return const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w700,
      color: Colors.green,
    );}
  else if (text.toLowerCase() == "fail" || text.toLowerCase() == 'a' || text.toLowerCase() == 'l' || text.toLowerCase() == 'c')
  {return const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: Colors.red,
  );}
  else
    {
      return const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: Colors.black54,
      );
    }
}
TextStyle ColorText1(String text) {
  if (text.toLowerCase() == "pass" || text.toLowerCase() == 'p' || text.toLowerCase() == 'od')
  {return  TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: Colors.green,
  );}
  else if (text.toLowerCase() == "fail" || text.toLowerCase() == 'a' || text.toLowerCase() == 'l' || text.toLowerCase() == 'c')
  {return  TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: Colors.red,
  );}
  else
  {
    return const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w700,
      fontFamily: "Yaahowu",
      color: Colors.black54,
    );
  }
}


//decoration custom
BoxDecoration PrimaryRoundBox() => BoxDecoration(
      borderRadius: BorderRadius.circular(20.0),
      color: PrimaryColor(),
    );
BoxDecoration PrimaryRoundBox1() => BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),

  color:Color.fromRGBO(247, 252, 252, 0.8),
    );

BoxDecoration SecondaryRoundBox() => BoxDecoration(
      borderRadius: BorderRadius.circular(20.0),
      color: SecondaryColor(),
    );
BoxDecoration CircularContainer() => BoxDecoration(
      borderRadius: BorderRadius.circular(20.0),
  gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Colors.purple,Colors.orangeAccent],
  )
    );

BoxDecoration LeaveBalanceRoundBox(double balance) {
  if(balance == 0)
    {
      return BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: ErrorColor(),
      );
    }
  else{
    if(balance <=5)
      {
        return BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: WarningColor()
        );
      }
    else{
      return BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: SecondaryColor(),
      );
    }
  }

}
BoxDecoration LeadingCircleBox(String status) {
  if (status == '0' || status.toLowerCase() == 't')
  {
    return BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(60.0)),
      color: LineColor2(),
    );
  }
  else
  {
    return BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(60.0)),
      color: PrimaryColor(),
    );
  }

}

BoxDecoration LeadingCircleBox1(String status) {
  if (status == '0' || status.toLowerCase() == 't')
    {
      return BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(60.0)),
        color:  Color.fromRGBO(255, 98, 118, 1),
      );
    }
  else
    {
      return BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(60.0)),
        color:  Color.fromRGBO(255, 98, 118, 1),
      );
    }

}

BoxDecoration ColorRoundBox2(double per) {
  if (per <= 75.00)
    {
      return BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.red,
      );
    }
  else
    {
      return BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: SecondaryColor(),
      );
    }

}

BoxDecoration ColorRoundBox3(double per) {
  if (per <= 75.00)
    {
      return BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.red,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.topRight,
          colors: [Colors.orangeAccent,Colors.purpleAccent],
        )
      );
    }
  else
    {
      return BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.topRight,
            colors: [Colors.orangeAccent,Colors.purpleAccent],
          )
      );
    }

}

InputDecoration PrimaryInputDecor(String content) => InputDecoration(
      labelText: content,
      labelStyle: PrimaryText2(),
    );

InputDecoration PrimaryInputDecorCV(String content) => InputDecoration(
  labelText: content,
  labelStyle: PrimaryText2(),
);

InputDecoration PassWordInputDecor(String content) => InputDecoration(
    labelText: content,
    labelStyle: PrimaryText2(),
    suffixIcon: Icon(Icons.lock_outline,color: Colors.purple,)
);

InputDecoration UserInputDecor(String content) => InputDecoration(
    labelText: content,
    labelStyle: PrimaryText2(),
    suffixIcon: Icon(Icons.person,color: Colors.purple,)
);

Widget BackArrow()=> Container(
  child: Icon(
    Icons.arrow_back,
    color: LineColor1(),
  ),
);

Scaffold ErrorShowingWidget(BuildContext context)=> Scaffold(
  appBar: AppBar(
    title: Text(
      "Error",
      style: PrimaryText(context),
    ),
    centerTitle: true,
    backgroundColor: PrimaryColor(),
    elevation: 20.0,
  ),
  body: Builder(
      builder: (BuildContext context) => ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Center(
                    child: Text(
                      "Oops!!! Something went Wrong\nPlease try again later",
                      style: ErrorText2Big(),
                      textAlign: TextAlign.center,
                    )),
              )
            ],
          )
        ],
      )),
);

//Image Display Custom
// String ImageIPAddress = 'http://121.200.54.217/impresvcet/';
String ImageIPAddress = StudentImageIP.toString();

Widget Imagedisplay(String image, double Width, double Height) => Stack(
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(top: 175),
            child: Center(
              child: CircularProgressIndicator(strokeWidth: 10),
            )),
        Container(
          width: Width,
          height: Height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage("${ImageIPAddress}${image}"), fit: BoxFit.contain)),
        )
      ],
    );

Widget ShortImagedisplay(String image, double Width, double Height) => Stack(
      children: <Widget>[

        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(image), fit: BoxFit.contain)),
        )
      ],
    );

Widget LeedingProfile(String image) => Stack(
      children: <Widget>[
        Container(child: Center(child: CircularProgressIndicator(strokeWidth: 4,)), padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 25.0),),
        Container(
          margin: EdgeInsets.all(2.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(60.0)),
              image: DecorationImage(
                  image: NetworkImage("${ImageIPAddress}${image}"), fit: BoxFit.cover)),
        ),
      ],
    );

Widget LeadingCircleBoxContent(String content, String status) => CircleAvatar(
  radius: 25,
  child: Center(child: SizedBox(child: Text(content, style: TextStyle(color: Colors.white,fontSize: 15),))),
);

Widget LeadingCircleImageContent(String image) => Stack(
  children: <Widget>[
    Container(child: Center(child: CircularProgressIndicator(strokeWidth: 1,)),
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 25.0),),
    Container(
      margin: EdgeInsets.all(2.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(60.0)),
          image: DecorationImage(
              image: NetworkImage("${ImageIPAddress}${image}"), fit: BoxFit.cover)),
    )
  ],
);
Widget LeadingCircleImageContent1(String image) => Stack(
  children: <Widget>[
    Container(child: Center(child: CircularProgressIndicator(strokeWidth: 1,)),
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 25.0),),
    Container(
      margin: EdgeInsets.all(2.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(60.0)),
          image: DecorationImage(
              image: NetworkImage("${StudentImageIP}Resx/StudImages/${image}"), fit: BoxFit.cover)),
    )
  ],
);
Widget LeadingCircleImageContent2(String image) => Stack(
  children: <Widget>[
    Container(child: Center(child: CircularProgressIndicator(strokeWidth: 1,)),
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 25.0),),
    Container(
      margin: EdgeInsets.all(2.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(60.0)),
          image: DecorationImage(
              image: NetworkImage("${StudentImageIP}Resx/StudImages/${image}"), fit: BoxFit.cover)),
    )
  ],
);

void SetImageIPAddress(String value) {
  ImageIPAddress = value;
}

String GetImageIPAddress(){
  return ImageIPAddress;
}

void LaunchTheFile(String file){
  launch(
    "${StudentImageIP}Resx/Uploads/$file",
  );
}

void Launchstudimage(String file){
  launch(
      "${StudentImageIP}Resx/StudImages/$file"
  );
}

void LaunchUniversityMarkFile(String file){
  launch(
    "${StudentImageIP}Resx/UnivCertUpload/$file",
  );
}

Widget Credits (BuildContext context)=> Container(
  width: MediaQuery.of(context).size.width,
  margin: EdgeInsets.only(right: 10, bottom: 5),
  child: Text("Designed and developed by\nAnnamalai Selvarajan (NTU ID: N0881865)\nNTU, Nottingham, UK", style: TextStyle(color: Colors.black, fontSize: 5), textAlign: TextAlign.right,),
);

Widget WrongDataLottie(BuildContext context)=>Lottie.asset("images/lotties/error.json",
height: sHeight(100, context),width: sWidth(100, context),
);

Widget SearchingDataLottie(BuildContext context)=>Lottie.asset("images/introscreen/Impress_logo1.json",height: 160);
Widget MainScreenSearchinLottie(BuildContext context)=> Lottie.asset("images/introscreen/Impress_logo1.json",height: 160);
Widget EnterScreenLoadLottie(BuildContext context)=>Lottie.asset("images/introscreen/Impress_logo1.json",height: 160);
Widget StaffMainError(BuildContext context)=>Lottie.asset("images/lotties/staff_main_error.json");
Widget StaffMainLoading(BuildContext context)=>Lottie.asset("images/introscreen/Impress_logo1.json",height: 160);
Widget StudentsSearching(BuildContext context)=>Lottie.asset("images/introscreen/Impress_logo1.json",height: 160);
Widget ImpLogo_Load(BuildContext context)=>Lottie.asset("images/introscreen/Impress_logo1.json",height: 160);


double sHeight(double per, BuildContext context){
  double h = MediaQuery.of(context).size.height;
  return h * per / 100;
}

double sWidth(double per, BuildContext context){
  double w = MediaQuery.of(context).size.width;
  return w * per / 100;
}