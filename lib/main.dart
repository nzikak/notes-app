import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:notes_app/views/home_page.dart';
import 'package:notes_app/views/login_view.dart';
import 'package:notes_app/views/register_view.dart';
import 'package:notes_app/views/verify_email_view.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(MaterialApp(
    title: 'Notes App',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    routes: {
      "/home": (context) {
        return const HomePage();
      },
      "/login_view": (context) {
        return const LoginView();
      },
      "/register_view": (context) {
        return const RegisterView();
      },
      "verify_email": (context) {
        return const VerifyEmail();
      }
    },
    initialRoute: "/login_view",
  ));
}

