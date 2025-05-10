import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:shared_preferences/shared_preferences.dart';

// const BASE_URL = "10.0.2.2:3000";
const BASE_URL = "13.213.206.120:3000";

dynamic loginUser(username, password) async {
  var client = http.Client();
  try {
    print(Uri.http(BASE_URL, "/users/login"));
    var response = await client.post(Uri.http(BASE_URL, "/users/login"),
        body: {'username': username, 'password': password});
    print(response);
    var decodedResponse =
        convert.jsonDecode(convert.utf8.decode(response.bodyBytes)) as Map;
    return decodedResponse['data'];
  } finally {
    client.close();
  }
}

dynamic getSurveys(username) async {
  var client = http.Client();
  try {
    var response = await client.get(Uri.http(BASE_URL, "/surveys"));
    var decodedResponse =
        convert.jsonDecode(convert.utf8.decode(response.bodyBytes)) as Map;
    return decodedResponse['data'];
  } finally {
    client.close();
  }
}

dynamic getSurvey(id) async {
  print(id);
  var client = http.Client();
  try {
    Map<String, String> queryParameters = {'id': id.toString()};
    var uri = Uri.http(BASE_URL, "/surveys/survey", queryParameters);
    var response = await client.get(uri);
    var decodedResponse =
        convert.jsonDecode(convert.utf8.decode(response.bodyBytes)) as Map;
    return decodedResponse['data'];
  } finally {
    client.close();
  }
}

dynamic getMeta() async {
  var client = http.Client();
  try {
    var response = await client.get(Uri.http(BASE_URL, "/meta"));
    var decodedResponse =
        convert.jsonDecode(convert.utf8.decode(response.bodyBytes)) as Map;
    return decodedResponse['data'];
  } finally {
    client.close();
  }
}

dynamic fetchSurveys(technique) async {
  var client = http.Client();
  try {
    Map<String, String> queryParameters = {
      'survey_technique': technique.toString()
    };
    var uri = Uri.http(BASE_URL, "/sync/surveys", queryParameters);
    var response = await client.get(uri);
    var decodedResponse =
        convert.jsonDecode(convert.utf8.decode(response.bodyBytes)) as Map;
    return decodedResponse['data'];
  } finally {
    client.close();
  }
}

dynamic upsyncSurvey(obj) async {
  var client = http.Client();
  try {
    final prefs = await SharedPreferences.getInstance();
    obj['session'] = prefs.getString("token");
    var response =
        await client.post(Uri.http(BASE_URL, "/sync/update"), body: obj);
    var decodedResponse =
        convert.jsonDecode(convert.utf8.decode(response.bodyBytes)) as Map;
    print(decodedResponse);
    return decodedResponse['data'];
  } finally {
    client.close();
  }
}

dynamic createNewSurvey(obj) async {
  var client = http.Client();
  try {
    final prefs = await SharedPreferences.getInstance();
    obj['session'] = prefs.getString("token");
    var response =
        await client.post(Uri.http(BASE_URL, "/sync/new"), body: obj);
    var decodedResponse =
        convert.jsonDecode(convert.utf8.decode(response.bodyBytes)) as Map;
    print(decodedResponse);
    return decodedResponse['data'];
  } finally {
    client.close();
  }
}
