import 'dart:convert';

import 'package:coronatracker/models/corona_model.dart';
import 'package:http/http.dart' as http;

class StatServices {
  Future<CoronaModel> getstatsapi() async {
    final response =
        await http.get(Uri.parse("https://disease.sh/v3/covid-19/all"));
    var data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return CoronaModel.fromJson(data);
    } else {
      throw Exception("Error");
    }
  }
}
