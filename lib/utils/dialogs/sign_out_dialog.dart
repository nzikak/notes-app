import 'package:flutter/material.dart';
import 'package:notes_app/utils/dialogs/generic_dialogs.dart';

Future<bool> showLogoutDialog(BuildContext context) {
  return showGenericDialog<bool>(
      context: context,
      title: "Sign Out",
      content: "Are you sure you want to sign out?",
      optionsBuilder: () => {
            "Cancel": false,
            "Yes": true,
          }).then((value) => value ?? false);
}
