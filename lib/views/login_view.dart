import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/services/auth/auth_exceptions.dart';
import 'package:notes_app/services/auth/bloc/auth_bloc.dart';
import 'package:notes_app/services/auth/bloc/auth_event.dart';
import 'package:notes_app/services/auth/bloc/auth_state.dart';
import '../utils/dialogs/error_dialog.dart';
import 'package:notes_app/extensions/build_context/localization.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _emailTextController;
  late final TextEditingController _passwordTextController;

  @override
  void initState() {
    _emailTextController = TextEditingController();
    _passwordTextController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(context, context.loc.login_error_cannot_find_user,);
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(context, context.loc.login_error_wrong_credentials);
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, context.loc.login_error_auth_error);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            context.loc.login,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  context.loc.login_view_prompt,
                  style: const TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                TextField(
                  maxLines: 1,
                  controller: _emailTextController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(hintText: context.loc.email_text_field_placeholder),
                ),
                const SizedBox(height: 10),
                TextField(
                  maxLines: 1,
                  controller: _passwordTextController,
                  obscureText: true,
                  autocorrect: false,
                  enableSuggestions: false,
                  decoration: InputDecoration(hintText: context.loc.password_text_field_placeholder),
                  //      keyboardType: TextInputType.,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                    onPressed: () {
                      final email = _emailTextController.text;
                      final password = _passwordTextController.text;
                      context
                          .read<AuthBloc>()
                          .add(AuthEventLogIn(email, password));
                    },
                    child: Text(context.loc.login)),
                TextButton(
                    onPressed: () {
                      context
                          .read<AuthBloc>()
                          .add(const AuthEventForgotPassword());
                    },
                    child: Text(
                      context.loc.login_view_forgot_password,
                      style: const TextStyle(fontSize: 16),
                    )),

                    TextButton(
                        onPressed: () {
                          context
                              .read<AuthBloc>()
                              .add(const AuthEventNavigateToRegister());
                        },
                        child: Text(
                          context.loc.login_view_not_registered_yet,
                          style: const TextStyle(fontSize: 16),
                        ))
              ],
            ),
          ),
        ),
      ),
    );
  }

// void _loginUser(BuildContext context, String email, String password) async {
//   try {
//     final user = await AuthService.firebase()
//         .loginUser(email: email, password: password);
//
//     Navigator.of(context).pushNamedAndRemoveUntil(
//       user.isEmailVerified ? notesRoute : verifyEmailRoute,
//       (route) => false,
//     );
//   } on UserNotFoundAuthException {
//     await showErrorDialog(context, "User does not exist");
//   } on WrongPasswordAuthException {
//     await showErrorDialog(context, "Incorrect password");
//   } on GenericAuthException {
//     await showErrorDialog(context, "Authentication error");
//   }
// }
}
