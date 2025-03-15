import 'dart:convert';

import 'package:http/http.dart' as http;

Future<dynamic> request(String url) async {
  final response = await http.get(Uri.parse(url));
  final status = response.statusCode;
  if (status == 200) {
    return jsonDecode(response.body);
  } else if (status == 400 || status == 404 || status == 408) {
    throw Exception('Please,check your request or try later!');
  } else {
    throw Exception('Something went wrong,we are working on it!');
  }
}
