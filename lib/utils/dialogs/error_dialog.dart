import 'package:flutter/material.dart';
import 'package:notes_app/utils/dialogs/generic_dialogs.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String content,
) {
  return showGenericDialog<void>(
    context: context,
    title: "Error Occurred",
    content: content,
    optionsBuilder: () => {
      "OK!": null,
    },
  );
}
