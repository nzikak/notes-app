import 'package:flutter/material.dart';
import 'package:notes_app/utils/dialogs/generic_dialogs.dart';
import 'package:notes_app/extensions/build_context/localization.dart';

Future<void> showPasswordResetMailSentDialog(
  BuildContext context,
) {
  return showGenericDialog(
      context: context,
      title: context.loc.password_reset,
      content: context.loc.password_reset_dialog_prompt,
      optionsBuilder: () => {context.loc.ok: null});
}
