import 'package:add_dev_dolphin/Style_font/designs.dart';
import 'package:flutter/material.dart';

Widget StudentLoginButton(BuildContext context) => Container(
  margin: EdgeInsets.only(top: 20.0),
  width: 200,
  height: 70,
  decoration: PrimaryRoundBox(),
  child: Center(
    child: Text("Login", style: SecondaryText()),
  ),
);

