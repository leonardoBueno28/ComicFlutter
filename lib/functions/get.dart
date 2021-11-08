import 'dart:convert';
import 'dart:io';
import 'package:comic_app/assets/constants/constants.dart';
import 'package:comic_app/models/issue_model.dart';
import 'package:comic_app/models/issues_model.dart';
import 'package:http/http.dart' as http;

Future<List<Issues>> getIssues(fields) async {
  Uri url = Uri.parse(Constants.api_url +
      'issues/?api_key=' +
      Constants.api_key +
      '&format=json' +
      fields);
  final response = await http.get(
    url,
    headers: {
      HttpHeaders.authorizationHeader: Constants.api_key,
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Methods": "POST, GET, OPTIONS, PUT, DELETE, HEAD",
    },
  );
  final responseJson = json.decode(response.body);
  List<Issues> res = [];
  for (var item in responseJson['results']) {
    res.add(Issues.fromJson(item));
  }
  return res;
}

Future<List<Issue>> getIssue(String apiUrl, fields) async {
  Uri url = Uri.parse(apiUrl +
      '?api_key=' +
      Constants.api_key +
      '&format=json' +
      '&field_list=' +
      fields);
  final response = await http.get(
    url,
    headers: {
      HttpHeaders.authorizationHeader: Constants.api_key,
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Methods": "POST, GET, OPTIONS, PUT, DELETE, HEAD",
    },
  );
  final responseJson = json.decode(response.body);
  Issue res;

  var prueba = responseJson['results'];

  prueba = Issue.fromJson(prueba);
  res = prueba;
  return [res];
}
