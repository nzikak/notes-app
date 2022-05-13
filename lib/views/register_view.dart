import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/constants/routes.dart';
import 'package:notes_app/services/auth/auth_exceptions.dart';
import 'package:notes_app/services/auth/auth_service.dart';
import 'package:notes_app/services/auth/bloc/auth_bloc.dart';
import 'package:notes_app/services/auth/bloc/auth_event.dart';
import 'package:notes_app/services/auth/bloc/auth_state.dart';

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
            await showErrorDialog(context, "Weak password");
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(context, "Account already exists");
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context, "Invalid email");
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, "Registration error");
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Create Account",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              TextField(
                maxLines: 1,
                controller: _emailTextController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(hintText: "Email"),
              ),
              const SizedBox(height: 10),
              TextField(
                maxLines: 1,
                controller: _passwordTextController,
                obscureText: true,
                autocorrect: false,
                enableSuggestions: false,
                decoration: const InputDecoration(hintText: "Password"),
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
                  child: const Text("Register")),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already registered?",
                      style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 5),
                  TextButton(
                      onPressed: () {
                        context
                            .read<AuthBloc>()
                            .add(
                              const AuthEventLogOut(),
                            );
                      },
                      child: const Text(
                        "Sign In",
                        style: TextStyle(fontSize: 16),
                      ))
                ],
              )
            ],
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
