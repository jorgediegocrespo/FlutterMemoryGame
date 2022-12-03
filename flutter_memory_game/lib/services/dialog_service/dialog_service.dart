import 'package:flutter/material.dart';

import 'package:flutter_memory_game/main.dart';
import 'package:flutter_memory_game/services/services.dart';

class DialogService implements DialogServiceBase {
  
  @override
  Future<bool> showAlertDialog(String title, String message, String ok, String cancel) async {
    bool result = false;

    await showDialog(
      context: navigatorKey.currentContext!,
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