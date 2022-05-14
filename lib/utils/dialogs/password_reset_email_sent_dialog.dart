import 'package:flutter/material.dart';
import 'package:notes_app/utils/dialogs/generic_dialogs.dart';

Future<void> showPasswordResetMailSentDialog(
  BuildContext context,
) {
  return showGenericDialog(
      context: context,
      title: "Password Reset",
      content: "Please check your mail to reset your password",
      optionsBuilder: () => {"Ok": null});
}
