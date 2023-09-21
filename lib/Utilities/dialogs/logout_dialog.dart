import 'package:flutter/material.dart';
import 'package:fristapp/Utilities/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Log out',
    content: 'Are you sure want to log out ',
    optionBuilder: () => {
      'cancel': false,
      'Log out': true,
    },
  ).then((value) => value ?? false);
}
