import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes_app/constants/routes.dart';
import 'package:notes_app/utils/show_error_dialog.dart';

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
    return Scaffold(
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
                  _createNewUser(context, email, password);
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
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        loginRoute,
                        (route) => false,
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
    );
  }

  void _createNewUser(
      BuildContext context, String email, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();
      Navigator.of(context).pushNamed(verifyEmailRoute);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "weak-password":
          await showErrorDialog(context, "Weak password");
          break;
        case "email-already-in-use":
          await showErrorDialog(context, "Account already exists");
          break;
        case "invalid-email":
          await showErrorDialog(context, "Invalid email");
          break;
        default:
          await showErrorDialog(context, "Error: ${e.message}");
      }
    } catch (e) {
      await showErrorDialog(context, e.toString());
    }
  }

}
