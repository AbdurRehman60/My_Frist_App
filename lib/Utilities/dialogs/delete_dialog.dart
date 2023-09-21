import 'package:flutter/material.dart';
import 'package:fristapp/Utilities/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Log out',
    content: 'Are you sure want to delete this item',
    optionBuilder: () => {
      'cancel': false,
      'yes': true,
    },
  ).then((value) => value ?? false);
}
