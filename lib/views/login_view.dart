import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:notes_app/constants/routes.dart';

import '../utils/show_error_dialog.dart';

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
    return Scaffold(
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
                  _loginUser(context, email, password);
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
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        registerRoute,
                        (route) => false,
                      );
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
    );
  }

  void _loginUser(BuildContext context, String email, String password) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final isEmailVerified = userCredential.user?.emailVerified ?? false;

      Navigator.of(context).pushNamedAndRemoveUntil(
        isEmailVerified ? notesRoute : verifyEmailRoute,
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "user-not-found":
          await showErrorDialog(context, "User does not exist");
          break;
        case "wrong-password":
          await showErrorDialog(context, "Invalid password");
          break;
        default:
          await showErrorDialog(context, "Error: ${e.message}");
      }
    } catch (e) {
      await showErrorDialog(context, e.toString());
    }
  }
}
