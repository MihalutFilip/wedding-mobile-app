import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:wedding_mobile_app/config/utils.dart';
import 'package:wedding_mobile_app/models/confirmation_type.dart';
import 'package:wedding_mobile_app/models/guest.dart';
import 'package:wedding_mobile_app/models/pair.dart';
import 'package:wedding_mobile_app/screens/add_guest_screen.dart';
import 'package:wedding_mobile_app/config/service.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  HomeWidgetState createState() => HomeWidgetState();
}

class HomeWidgetState extends State<HomeWidget> {
  late Future<Object> getAllGuestsResponse;
  List<Guest> filteredGuests = [];
  String searchKey = "";

  @override
  void initState() {
    super.initState();

    getAllGuestsResponse = ApiCallService.getGuests();
  }

  Future<void> extractDataFromResult(Response response) async {
    final data = await json.decode(response.body);

    List<Guest> temp = [];

    for (var item in data) {
      temp.add(Guest.fromJson(item));
    }

    setState(() {
      filteredGuests = temp
          .where((guest) => guest.name.contains(searchKey) || searchKey == "")
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    const title = 'Wedding App';

    return MaterialApp(
        title: title,
        theme: ThemeData(
          primarySwatch: Colors.brown,
        ),
        home: Builder(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: const Text(title),
            ),
            body: FutureBuilder<Object>(
                future: getAllGuestsResponse,
                builder: (builderContext, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Text(
                                Utils.getDefaultErrorMessage() + '😭😭😭😭',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16))));
                  } else {
                    extractDataFromResult(snapshot.data as Response);

                    return ListView(
                      // This next line does the trick.
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            onChanged: (value) {
                              setState(() => {searchKey = value});
                            },
                            decoration: const InputDecoration(
                                labelText: "Search",
                                hintText: "Search",
                                prefixIcon: Icon(Icons.search),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(25.0)))),
                          ),
                        ),
                        getConfirmationTypeBox(
                            'Not Invited', ConfirmationType.NotInvited),
                        getConfirmationTypeBox(
                            'Invited', ConfirmationType.Invited),
                        getConfirmationTypeBox(
                            'Confirmed', ConfirmationType.Confirmed),
                        getConfirmationTypeBox(
                            'Not Coming', ConfirmationType.NotComing)
                      ],
                    );
                  }
                }),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddGuestWidget(
                          callback: (guest) => {
                                setState(() => {filteredGuests.add(guest)})
                              })),
                );
              },
              child: Icon(Icons.add),
            ),
          ),
        ),
        debugShowCheckedModeBanner: false);
  }

  Widget getConfirmationTypeBox(
      String boxTitle, ConfirmationType confirmationType) {
    List<Guest> guestsByType = filteredGuests
        .where((guest) => guest.confirmationType == confirmationType)
        .toList();

    if (guestsByType.isEmpty) return Container();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: Utils.getBoxDecoration(),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Column(
            children: [
              Utils.getBoxTitleWidget(boxTitle),
              Center(
                  child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: guestsByType.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        Guest guest = guestsByType[index];

                        return ListTile(
                          leading: Icon(
                              guest.isChild ? Icons.child_care : Icons.face),
                          title: Text(guest.name),
                          iconColor: Colors.blueGrey,
                          visualDensity:
                              VisualDensity(horizontal: 0, vertical: -4),
                        );
                      })),
            ],
          ),
        ),
      ),
    );
  }
}
