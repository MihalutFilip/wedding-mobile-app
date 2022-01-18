import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:wedding_mobile_app/models/request_models/add_guest.dart';
import 'dart:convert';

import '../models/guest.dart';

class ApiCallService {
  static String _baseApi = 'http://192.168.0.130:3000/api/wedding-guests';

  static Future<List<Guest>> getGuests() async {
    try {
      final response = await http.get(Uri.parse(_baseApi));

      final body = await json.decode(response.body);

      List<Guest> temp = [];

      for (var item in body) {
        temp.add(Guest.fromJson(item));
      }

      return temp;
    } catch (e) {
      return [];
    }
  }

  static Future<Response> addGuest(AddGuest guest) async {
    return await http.post(Uri.parse(_baseApi),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(guest.toMap()));
  }

  static Future<Response> deleteGuest(String guestId) {
    return http.delete(Uri.parse(_baseApi + '/' + guestId));
  }
}
