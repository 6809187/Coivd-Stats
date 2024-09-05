import 'dart:convert';

import 'package:covid_tracker/Models/world_states_model.dart';
//import 'package:covid_tracker/Services/Utilities/app_urls.dart';
import 'package:http/http.dart' as http;

class StatsServices {
  Future<WorldStatesModel> fetchWorldStatesRecords() async {
    final response =
        await http.get(Uri.parse('https://disease.sh/v3/covid-19/all'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return WorldStatesModel.fromJson(data);
    } else {
      throw Exception('Error');
    }
  }

  Future<List<dynamic>> countriesListApi() async {
    var data;
    final response =
        await http.get(Uri.parse('https://disease.sh/v3/covid-19/countries'));

    if (response.statusCode == 200) {
       data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Error');
    }
  }
}
