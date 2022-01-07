import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wedding_mobile_app/models/confirmation_type.dart';
import 'package:wedding_mobile_app/models/guest.dart';
import 'package:wedding_mobile_app/models/pair.dart';
import 'package:wedding_mobile_app/screens/add_guest.dart';
import 'package:wedding_mobile_app/service.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  HomeWidgetState createState() => HomeWidgetState();
}

class HomeWidgetState extends State<HomeWidget> {
  List<Guest> guests = [];
  List<Guest> filteredGuests = [];

  @override
  void initState() {
    super.initState();
    fetchData().then((List<Guest> temp) {
      setState(() => guests = temp);
      setState(() => filteredGuests = temp);
    });
  }

  Pair<Widget, Color> getIconAndColor(
      BuildContext context, ConfirmationType confirmationType) {
    // Switch Icon and color based on confirmation type
    Map<ConfirmationType, Pair<IconData, Color>> dictionary = {
      ConfirmationType.Confirmed:
          Pair(Icons.face_retouching_natural, Colors.green),
      ConfirmationType.Invited: Pair(Icons.face, Colors.blueAccent),
      ConfirmationType.NotComing: Pair(Icons.face_retouching_off, Colors.red),
      ConfirmationType.NotInvited: Pair(Icons.face_retouching_off, Colors.red)
    };

    var iconAndColor = dictionary[confirmationType] as Pair<IconData, Color>;

    return Pair(Icon(iconAndColor.first), iconAndColor.second);
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
                          Guest guest = filteredGuests[index];
                          final iconAndColor =
                              getIconAndColor(context, guest.confirmationType);

                          return ListTile(
                            leading: iconAndColor.first,
                            title: Text(guest.name),
                            iconColor: iconAndColor.second,
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
