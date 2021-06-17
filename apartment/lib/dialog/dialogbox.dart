import 'package:flutter/material.dart';

Future<Null> dialogmsg(BuildContext context, String head, String msg) async {
  showDialog(
      context: context,
      builder: (context) => SimpleDialog(
            title: ListTile(
              title: Text(head),
              subtitle: Text(msg),
            ),
            children: [
              TextButton(
                  onPressed: () => Navigator.pop(context), child: Text('OK'))
            ],
          ));
}

// ignore: missing_return
// Future<Null> snackbar(BuildContext context, String msg) {
//   showsnackbar(String msg) =>
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
// }
