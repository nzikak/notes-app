import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:notes_app/constants/routes.dart';
import 'package:notes_app/views/home_page.dart';
import 'package:notes_app/views/login_view.dart';
import 'package:notes_app/views/notes_view.dart';
import 'package:notes_app/views/register_view.dart';
import 'package:notes_app/views/verify_email_view.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
      notesRoute: (context) => const NotesView()
    },
    initialRoute: homeRoute,
  ));
}
