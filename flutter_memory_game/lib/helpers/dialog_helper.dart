import 'package:flutter/material.dart';

class DialogHelper {
  static Future<bool> showAlertDialog(BuildContext context, String title, String message, String ok, String cancel) async {
    bool result = false;

    await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(cancel),
              onPressed: () {
                result = false;
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(ok),
              onPressed: () {
                result = true;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

    return result;
  }
}
