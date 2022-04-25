import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/views/login_view.dart';
import 'package:notes_app/views/notes_view.dart';
import 'package:notes_app/views/verify_email_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return getCurrentScreen();
  }

  // bool _isUserEmailVerified() {
  //   return FirebaseAuth.instance.currentUser?.emailVerified ?? false;
  // }

  Widget getCurrentScreen() {
    final user = FirebaseAuth.instance.currentUser;
    if(user != null) {
      if(user.emailVerified) {
        return const NotesView();
      } else {
        return const VerifyEmail();
      }
    } else {
      return const LoginView();
    }
  }
}



