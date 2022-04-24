import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
                  _createNewUser(email, password);
                },
                child: const Text("Register"))
          ],
        ),
      ),
    );
  }

  void _createNewUser(String email, String password) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      print(userCredential);
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }
}
