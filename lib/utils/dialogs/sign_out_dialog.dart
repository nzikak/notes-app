import 'package:flutter/material.dart';
import 'package:notes_app/utils/dialogs/generic_dialogs.dart';
import 'package:notes_app/extensions/build_context/localization.dart';

Future<bool> showLogoutDialog(BuildContext context) {
  return showGenericDialog<bool>(
      context: context,
      title: context.loc.logout,
      content: context.loc.logout_dialog_prompt,
      optionsBuilder: () => {
            context.loc.cancel: false,
            context.loc.yes: true,
          }).then((value) => value ?? false);
}
