import 'package:flutter/material.dart';
import 'package:notes_app/constants/routes.dart';
import 'package:notes_app/services/auth/auth_service.dart';
import 'package:notes_app/views/home_page.dart';
import 'package:notes_app/views/login_view.dart';
import 'package:notes_app/views/notes/new_notes_view.dart';
import 'package:notes_app/views/notes/notes_view.dart';
import 'package:notes_app/views/register_view.dart';
import 'package:notes_app/views/verify_email_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.firebase().initializeFirebase();
  runApp(MaterialApp(
    title: 'Notes App',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    routes: {
      homeRoute: (context) {
        return const HomePage();
      },
      loginRoute: (context) {
        return const LoginView();
      },
      registerRoute: (context) {
        return const RegisterView();
      },
      verifyEmailRoute: (context) {
        return const VerifyEmail();
      },
      notesRoute: (context) => const NotesView(),
      newNotesRoute: (context) => const NewNotesView()
    },
    initialRoute: homeRoute,
  ));
}
