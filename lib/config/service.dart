import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:wedding_mobile_app/models/request_models/add_guest.dart';
import 'dart:convert';

import '../models/guest.dart';

class ApiCallService {
  static String _baseApi = 'http://192.168.0.130:3000/api/wedding-guests';

  static Future<Response> getGuests() async {
    return await http
        .get(Uri.parse(_baseApi))
        .timeout(const Duration(seconds: 10));
  }

  static Future<Response> addGuest(AddGuest guest) async {
    return await http.post(Uri.parse(_baseApi),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(guest.toMap()));
  }
}
