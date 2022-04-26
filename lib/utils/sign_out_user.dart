import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void signOutUser(BuildContext context, String navRoute) async {
  await FirebaseAuth.instance.signOut();
  Navigator.pushNamedAndRemoveUntil(
    context,
    navRoute,
        (route) => false,
  );
}