// To parse this JSON data, do
//
//     final covidInProvince = covidInProvinceFromJson(jsonString);

import 'dart:convert';

List<CovidInProvince> covidInProvinceFromJson(String dynamic) => List<CovidInProvince>.from(json.decode(dynamic).map((x) => CovidInProvince.fromJson(x)));

String covidInProvinceToJson(List<CovidInProvince> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CovidInProvince {
    CovidInProvince({
        required this.newCase,
        required this.province,
    });

    int newCase;
    String province;

    factory CovidInProvince.fromJson(Map<String, dynamic> json) => CovidInProvince(
        newCase: json["new_case"],
        province: json["province"],
    );

    Map<String, dynamic> toJson() => {
        "new_case": newCase,
        "province": province,
    };
}
