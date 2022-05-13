import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/services/auth/auth_exceptions.dart';
import 'package:notes_app/services/auth/bloc/auth_bloc.dart';
import 'package:notes_app/services/auth/bloc/auth_event.dart';
import 'package:notes_app/services/auth/bloc/auth_state.dart';
import '../utils/dialogs/error_dialog.dart';

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
            await showErrorDialog(context, "User does not exist");
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(context, "Incorrect password");
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, "Authentication error");
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Login",
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
                        .add(AuthEventLogIn(email, password));
                  },
                  child: const Text("Login")),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Not yet registered?",
                      style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 5),
                  TextButton(
                      onPressed: () {
                        context
                            .read<AuthBloc>()
                            .add(const AuthEventNavigateToRegister());
                      },
                      child: const Text(
                        "Register here",
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
