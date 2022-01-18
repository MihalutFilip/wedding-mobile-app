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
  List<Guest> filteredGuests = [];
  String searchKey = "";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    ApiCallService.getGuests().then((value) {
      setState(() {
        _isLoading = false;
        filteredGuests = value
            .where((guest) => guest.name.contains(searchKey) || searchKey == "")
            .toList();
      });
    });
  }

  Future<void> extractDataFromResult(Response response) async {
    final data = await json.decode(response.body);

    List<Guest> temp = [];

    for (var item in data) {
      temp.add(Guest.fromJson(item));
    }

    setState(() {});
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
            body: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25.0)))),
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
                  ),
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
                      itemCount: filteredGuests.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        Guest guest = filteredGuests[index];

                        if (guest.confirmationType != confirmationType)
                          return Container();

                        return Dismissible(
                            key: ValueKey(guest.id),
                            onDismissed: (_) async {
                              var response =
                                  await ApiCallService.deleteGuest(guest.id);

                              var message = "";

                              if (response.statusCode != 200) {
                                message = Utils.getDefaultErrorMessage();
                              } else {
                                setState(() {
                                  filteredGuests.removeWhere(
                                      (element) => element.id == guest.id);
                                });

                                message = "Guest " + guest.name + " removed";
                              }

                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(message)));
                            },
                            background: Container(color: Colors.red),
                            child: ListTile(
                              leading: Icon(guest.isChild
                                  ? Icons.child_care
                                  : Icons.face),
                              title: Text(guest.name),
                              iconColor: Colors.blueGrey,
                              visualDensity: const VisualDensity(
                                  horizontal: 0, vertical: -3),
                            ));
                      })),
            ],
          ),
        ),
      ),
    );
  }
}
