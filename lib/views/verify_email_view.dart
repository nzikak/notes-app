import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/constants/routes.dart';
import 'package:notes_app/services/auth/auth_service.dart';
import 'package:notes_app/services/auth/bloc/auth_bloc.dart';
import 'package:notes_app/services/auth/bloc/auth_event.dart';
import 'package:notes_app/utils/sign_out_user.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({Key? key}) : super(key: key);

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify Email"),
        centerTitle: true,
      ),
      body: Center(
          child: Container(
        padding: const EdgeInsets.only(top: 100, left: 16, right: 16),
        child: Column(
          children: [
            const Text(
              "We've sent you a verification email. "
              "Please, check your mail to verify your account.",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              "If you haven't received a verification email yet, "
              "click on the button below to resend it.",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 250,
              child: ElevatedButton(
                  onPressed: () {
                    _sendEmailVerification();
                  },
                  child: const Text(
                    "Send Email Verification",
                    style: TextStyle(fontSize: 18),
                  )),
            ),
            SizedBox(
              width: 250,
              child: ElevatedButton(
                  onPressed: () {
                    context.read<AuthBloc>()
                        .add(const AuthEventLogOut());
                  },
                  child: const Text(
                    "Sign Out",
                    style: TextStyle(fontSize: 18),
                  )),
            ),
          ],
        ),
      )),
    );
  }

  void _sendEmailVerification() async {
    await AuthService.firebase().sendEmailVerification();
  }
}
