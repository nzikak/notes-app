import 'package:flutter/material.dart';
import 'package:notes_app/services/auth/auth_service.dart';

void signOutUser(BuildContext context, String navRoute) async {
  await AuthService.firebase().logOutUser();
  Navigator.pushNamedAndRemoveUntil(
    context,
    navRoute,
    (route) => false,
  );
}
