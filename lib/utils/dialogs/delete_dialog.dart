import 'package:flutter/material.dart';
import 'package:notes_app/utils/dialogs/generic_dialogs.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
      context: context,
      title: "Delete Note",
      content: "Are you sure you want delete this note?",
      optionsBuilder: () => {
        "Cancel": false,
        "Yes": true,
      }).then((value) => value ?? false);
}