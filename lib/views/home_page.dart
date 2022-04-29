import 'package:flutter/material.dart';
import 'package:notes_app/services/auth/auth_service.dart';
import 'package:notes_app/views/login_view.dart';
import 'package:notes_app/views/notes/notes_view.dart';
import 'package:notes_app/views/verify_email_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return getCurrentScreen();
  }

  Widget getCurrentScreen() {
    final user = AuthService.firebase().currentUser;
    if(user != null) {
      if(user.isEmailVerified) {
        return const NotesView();
      } else {
        return const VerifyEmail();
      }
    } else {
      return const LoginView();
    }
  }
}



