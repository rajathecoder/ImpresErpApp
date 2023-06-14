// To parse this JSON data, do
//
//     final adminYear = adminYearFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<AdminYear> adminYearFromJson(String str) =>
    List<AdminYear>.from(json.decode(str).map((x) => AdminYear.fromJson(x)));

String adminYearToJson(List<AdminYear> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AdminYear {
  AdminYear({
    required this.acadYear,
  });

  String acadYear;

  factory AdminYear.fromJson(Map<String, dynamic> json) => AdminYear(
    acadYear: json["AcadYear"],
  );

  Map<String, dynamic> toJson() => {
    "AcadYear": acadYear,
  };
}

// To parse this JSON data, do
//
//     final departCollection = departCollectionFromJson(jsonString);


