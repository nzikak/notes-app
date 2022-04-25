import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/views/verify_email_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
          centerTitle: true,
        ),
        body: Container(
          child: _isUserEmailVerified() ? const Text("Email verified") :
          const VerifyEmail(),
        ));
  }

  bool _isUserEmailVerified() {
    return FirebaseAuth.instance.currentUser?.emailVerified ?? false;
  }
}



