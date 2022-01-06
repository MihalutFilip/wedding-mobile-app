import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List> fetchGuests() async {
  final response =
      await http.get(Uri.parse('http://192.168.0.130:3000/api/wedding-guests'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return jsonDecode(response.body);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<dynamic>> guests;

  @override
  void initState() {
    super.initState();
    guests = fetchGuests();
  }

  @override
  Widget build(BuildContext context) {
    const title = 'Wedding App';

    return MaterialApp(
        title: title,
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: const Text(title),
          ),
          body: Center(
            child: FutureBuilder<List<dynamic>>(
              future: guests,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data == null) {
                    return Text("No guest added");
                  } else {
                    List<dynamic> list = snapshot.data as List<dynamic>;
                    return ListView.builder(
                        // Let the ListView know how many items it needs to build.
                        itemCount: list.length,
                        // Provide a builder function. This is where the magic happens.
                        // Convert each item into a widget based on the type of item it is.
                        itemBuilder: (context, index) {
                          Guest item = Guest.fromJson(list[index]);

                          return ListTile(
                            leading: item.chooseIcon(context),
                            title: item.buildTitle(context),
                            iconColor: item.chooseIconColor(context),
                          );
                        });
                  }
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: Icon(Icons.add),
          ),
        ),
        debugShowCheckedModeBanner: false);
  }
}

enum ConfirmStatus { NotInvited, Invited, Confirmed, NotComing }

class Guest {
  final String id;
  final String name;
  final ConfirmStatus confirmStatus;

  Guest({required this.id, required this.name, required this.confirmStatus});

  factory Guest.fromJson(Map<String, dynamic> json) {
    return Guest(
        id: json['_id'],
        name: json['name'],
        confirmStatus: ConfirmStatus.values[json['confirmationType'] ?? 0]);
  }

  Widget chooseIcon(BuildContext context) {
    IconData iconData;

    switch (confirmStatus) {
      case ConfirmStatus.Confirmed:
        iconData = Icons.face_retouching_natural;
        break;

      case ConfirmStatus.Invited:
        iconData = Icons.face;
        break;

      case ConfirmStatus.NotComing:
        iconData = Icons.face_retouching_off;
        break;

      case ConfirmStatus.NotInvited:
        iconData = Icons.face_retouching_off;
        break;
    }

    return Icon(iconData);
  }

  Color chooseIconColor(BuildContext context) {
    Color color;

    switch (confirmStatus) {
      case ConfirmStatus.Confirmed:
        color = Colors.green;
        break;

      case ConfirmStatus.Invited:
        color = Colors.blueAccent;
        break;

      case ConfirmStatus.NotComing:
        color = Colors.red;
        break;

      case ConfirmStatus.NotInvited:
        color = Colors.red;
        break;
    }

    return color;
  }

  Widget buildTitle(BuildContext context) => Text(name);
}
