import 'package:flutter/material.dart';
import 'package:notes_app/utils/dialogs/generic_dialogs.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) async {
  return showGenericDialog<void>(context: context,
    title: "Empty Note",
    content: "You can't share an empty note",
    optionsBuilder: () =>
    {
      "Ok": null
    },
  );
}