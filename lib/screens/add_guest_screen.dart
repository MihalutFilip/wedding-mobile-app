import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wedding_mobile_app/models/confirmation_type.dart';
import 'package:wedding_mobile_app/models/guest.dart';
import 'package:wedding_mobile_app/models/request_models/add_guest.dart';

class AddGuestWidget extends StatefulWidget {
  const AddGuestWidget({Key? key}) : super(key: key);

  @override
  AddGuestScreen createState() => AddGuestScreen();
}

class AddGuestScreen extends State<AddGuestWidget> {
  ConfirmationType? _confirmationType = ConfirmationType.NotInvited;
  bool? _isChild = false;

  @override
  void initState() {}

  BoxDecoration getBoxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10)),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 5,
          blurRadius: 7,
          offset: const Offset(0, 3), // changes position of shadow
        ),
      ],
    );
  }

  ListTile getRadioButtonOption(
      String title, ConfirmationType confirmationType) {
    return ListTile(
      title: Text(title),
      leading: Radio<ConfirmationType>(
        value: confirmationType,
        groupValue: _confirmationType,
        onChanged: (ConfirmationType? value) {
          setState(() {
            _confirmationType = value;
          });
        },
      ),
    );
  }

  Widget getNameContainer() {
    return Container(
        decoration: getBoxDecoration(),
        margin: const EdgeInsets.all(10.0),
        child: Column(children: const <Widget>[
          Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: TextField(
                decoration: InputDecoration.collapsed(hintText: 'Nume Invitat'),
              )),
        ]));
  }

  Widget getRadioButtonContainer() {
    return Container(
        decoration: getBoxDecoration(),
        margin: const EdgeInsets.all(10.0),
        child: Column(children: <Widget>[
          const Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Status confirmare",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
              )),
          getRadioButtonOption('Neinvitat', ConfirmationType.NotInvited),
          getRadioButtonOption('Invitat', ConfirmationType.Invited),
          getRadioButtonOption('Confirmat', ConfirmationType.Confirmed),
          getRadioButtonOption('Nu vine', ConfirmationType.NotComing),
        ]));
  }

  Widget getCheckBoxContainer() {
    return Container(
        decoration: getBoxDecoration(),
        margin: const EdgeInsets.all(10.0),
        child: Column(children: <Widget>[
          const Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Varsta",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
              )),
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: CheckboxListTile(
              title: const Text("Este copil"),
              value: _isChild,
              onChanged: (newValue) {
                setState(() {
                  _isChild = newValue;
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
          )
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Adauga invitat"),
        ),
        body: ListView(scrollDirection: Axis.vertical, children: <Widget>[
          getNameContainer(),
          getRadioButtonContainer(),
          getCheckBoxContainer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Salveaza'),
                  ),
                ]),
          )
        ]));
  }
}
