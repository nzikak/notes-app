import 'package:flutter/material.dart';
import 'package:notes_app/utils/dialogs/generic_dialogs.dart';
import 'package:notes_app/extensions/build_context/localization.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String content,
) {
  return showGenericDialog<void>(
    context: context,
    title: context.loc.generic_error_prompt,
    content: content,
    optionsBuilder: () => {
      context.loc.ok: null,
    },
  );
}
