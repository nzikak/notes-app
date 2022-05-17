import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/services/auth/auth_exceptions.dart';
import 'package:notes_app/services/auth/bloc/auth_bloc.dart';
import 'package:notes_app/services/auth/bloc/auth_event.dart';
import 'package:notes_app/services/auth/bloc/auth_state.dart';
import 'package:notes_app/extensions/build_context/localization.dart';
import '../utils/dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(
              context,
              context.loc.register_error_weak_password,
            );
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(
                context, context.loc.register_error_email_already_in_use);
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(
              context,
              context.loc.register_error_invalid_email,
            );
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(
              context,
              context.loc.register_error_generic,
            );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            context.loc.register,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                TextField(
                  maxLines: 1,
                  controller: _emailTextController,
                  keyboardType: TextInputType.emailAddress,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: context.loc.email_text_field_placeholder,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  maxLines: 1,
                  controller: _passwordTextController,
                  obscureText: true,
                  autocorrect: false,
                  enableSuggestions: false,
                  decoration: InputDecoration(
                    hintText: context.loc.password_text_field_placeholder,
                  ),
                  //      keyboardType: TextInputType.,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                    onPressed: () {
                      final email = _emailTextController.text;
                      final password = _passwordTextController.text;
                      context
                          .read<AuthBloc>()
                          .add(AuthEventRegister(email, password));
                    },
                    child: Text(context.loc.register)),

                    TextButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(
                                const AuthEventLogOut(),
                              );
                        },
                        child: Text(
                          context.loc.register_view_already_registered,
                          style: const TextStyle(fontSize: 16),
                        ))

              ],
            ),
          ),
        ),
      ),
    );
  }

// void _createNewUser(BuildContext context, String email,
//     String password) async {
//   final authService = AuthService.firebase();
//   try {
//     await authService.createUser(
//       email: email,
//       password: password,
//     );
//     await authService.sendEmailVerification();
//     Navigator.of(context).pushNamed(verifyEmailRoute);
//   } on WeakPasswordAuthException {
//     await showErrorDialog(context, "Weak password");
//   } on EmailAlreadyInUseAuthException {
//     await showErrorDialog(context, "Account already exists");
//   } on InvalidEmailAuthException {
//     await showErrorDialog(context, "Invalid email");
//   } on GenericAuthException {
//     await showErrorDialog(context, "Registration error");
//   }
// }
}
