import 'package:http/http.dart' as http;
import 'dart:convert';

import 'models/guest.dart';

Future<List<Guest>> fetchData() async {
  final response =
      await http.get(Uri.parse('http://192.168.0.130:3000/api/wedding-guests'));
  final data = await json.decode(response.body);

  List<Guest> temp = [];

  for (var item in data) {
    temp.add(Guest.fromJson(item));
  }

  return temp;
}
