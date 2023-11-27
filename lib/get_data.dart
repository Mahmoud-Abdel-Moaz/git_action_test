import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'user_data.dart';

Future<UserData> getData() async {
  try {
    String url = dotenv.env['BASE_URL']!;
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return UserData.fromJson(jsonDecode(response.body));
    } else {
      throw 'connection error';
    }
  } catch (e) {
    rethrow;
  }
}
