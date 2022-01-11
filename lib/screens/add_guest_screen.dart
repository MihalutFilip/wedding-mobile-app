import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wedding_mobile_app/config/utils.dart';
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
      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
    );
  }

  Widget getNameContainer() {
    return Container(
        decoration: Utils.getBoxDecoration(),
        margin: const EdgeInsets.all(10.0),
        child: Column(children: const <Widget>[
          Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: TextField(
                decoration: InputDecoration.collapsed(hintText: 'Name'),
              )),
        ]));
  }

  Widget getRadioButtonContainer() {
    return Container(
        decoration: Utils.getBoxDecoration(),
        margin: const EdgeInsets.all(10.0),
        child: Column(children: <Widget>[
          Utils.getBoxTitleWidget('Confirmation status'),
          getRadioButtonOption('Not Invited', ConfirmationType.NotInvited),
          getRadioButtonOption('Invited', ConfirmationType.Invited),
          getRadioButtonOption('Confirmed', ConfirmationType.Confirmed),
          getRadioButtonOption('Not coming', ConfirmationType.NotComing),
        ]));
  }

  Widget getCheckBoxContainer() {
    return Container(
        decoration: Utils.getBoxDecoration(),
        margin: const EdgeInsets.all(10.0),
        child: Column(children: <Widget>[
          Utils.getBoxTitleWidget('Age'),
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: CheckboxListTile(
              title: const Text("Child"),
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
          title: const Text("Add Guest"),
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
                    child: const Text('Add'),
                  ),
                ]),
          )
        ]));
  }
}
