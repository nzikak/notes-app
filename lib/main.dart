import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/constants/routes.dart';
import 'package:notes_app/services/auth/auth_service.dart';
import 'package:notes_app/services/auth/bloc/auth_bloc.dart';
import 'package:notes_app/services/auth/firebase_auth_provider.dart';
import 'package:notes_app/views/home_page.dart';
import 'package:notes_app/views/login_view.dart';
import 'package:notes_app/views/notes/create_update_notes_view.dart';
import 'package:notes_app/views/notes/note_view.dart';
import 'package:notes_app/views/register_view.dart';
import 'package:notes_app/views/verify_email_view.dart';
import 'package:path/path.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 // await AuthService.firebase().initializeFirebase();
  runApp(MaterialApp(
    title: 'Notes App',
    debugShowCheckedModeBanner: false,
    home: BlocProvider(
      create: (context) => AuthBloc(FirebaseAuthProvider()),
      child: const HomePage(),
    ),
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    routes: {
      createUpdateNoteRoute: (context) => const CreateUpdateNotesView()
    },
  ));
}
