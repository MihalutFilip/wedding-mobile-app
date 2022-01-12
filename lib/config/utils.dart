import 'package:flutter/material.dart';

class Utils {
  static BoxDecoration getBoxDecoration() {
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

  static Widget getBoxTitleWidget(String title) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 0, 2),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ));
  }

  static showErrorSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      content: Text(getDefaultErrorMessage()),
      action: SnackBarAction(
        label: '',
        onPressed: () {},
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static bool isStatusOk(int status) {
    return 200 <= status && status < 300;
  }

  static String getDefaultErrorMessage() {
    return 'Something happened. Check your internet connection and try again';
  }
}
