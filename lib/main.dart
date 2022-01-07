import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wedding_mobile_app/screens/add_guest.dart';
import 'package:wedding_mobile_app/service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Guest> guests = [];
  List<Guest> filteredGuests = [];
  TextEditingController editingController = TextEditingController();
  final duplicateItems = List<String>.generate(10000, (i) => "Item $i");

  @override
  void initState() {
    super.initState();
    fetchData().then((List<Guest> temp) {
      setState(() => guests = temp);
      setState(() => filteredGuests = temp);
    });
  }

  @override
  Widget build(BuildContext context) {
    const title = 'Wedding App';

    return MaterialApp(
        title: title,
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: Builder(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: const Text(title),
            ),
            body: ListView(
              // This next line does the trick.
              scrollDirection: Axis.vertical,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (value) {
                      setState(() => {
                            filteredGuests = guests
                                .where((guest) =>
                                    guest.name.contains(value) || value == "")
                                .toList()
                          });
                    },
                    controller: editingController,
                    decoration: const InputDecoration(
                        labelText: "Search",
                        hintText: "Search",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)))),
                  ),
                ),
                Center(
                    child: ListView.builder(
                        // Let the ListView know how many items it needs to build.
                        itemCount: filteredGuests.length,
                        shrinkWrap: true,
                        // Provide a builder function. This is where the magic happens.
                        // Convert each item into a widget based on the type of item it is.
                        itemBuilder: (context, index) {
                          Guest item = filteredGuests[index];

                          return ListTile(
                            leading: item.chooseIcon(context),
                            title: item.buildTitle(context),
                            iconColor: item.chooseIconColor(context),
                          );
                        }))
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddGuest()),
                );
              },
              child: Icon(Icons.add),
            ),
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
