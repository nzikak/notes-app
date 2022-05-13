import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/helpers/loading/loading_screen.dart';
import 'package:notes_app/services/auth/bloc/auth_bloc.dart';
import 'package:notes_app/services/auth/bloc/auth_event.dart';
import 'package:notes_app/services/auth/bloc/auth_state.dart';
import 'package:notes_app/views/login_view.dart';
import 'package:notes_app/views/notes/note_view.dart';
import 'package:notes_app/views/register_view.dart';
import 'package:notes_app/views/verify_email_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
      if (state.isLoading) {
        LoadingScreen().show(
          context: context,
          text: state.loadingText ?? "Please wait a moment...",
        );
      } else {
        LoadingScreen().hide();
      }
    }, builder: (context, state) {
      if (state is AuthStateLoggedIn) {
        return const NotesView();
      } else if (state is AuthStateNotVerified) {
        return const VerifyEmail();
      } else if (state is AuthStateLoggedOut) {
        return const LoginView();
      } else if (state is AuthStateRegistering) {
        return const RegisterView();
      } else {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
    });
  }

// Widget getCurrentScreen() {
//   final user = AuthService
//       .firebase()
//       .currentUser;
//   if (user != null) {
//     if (user.isEmailVerified) {
//       return const NotesView();
//     } else {
//       return const VerifyEmail();
//     }
//   } else {
//     return const LoginView();
//   }
// }
}
