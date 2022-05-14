import 'package:notes_app/services/auth/firebase_auth_provider.dart';

import 'auth_provider.dart';
import 'auth_user.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;

  const AuthService._(this.provider);

  factory AuthService.firebase() =>
      AuthService._(FirebaseAuthProvider());

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) =>
      provider.createUser(email: email, password: password);

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<void> logOutUser() => provider.logOutUser();

  @override
  Future<AuthUser> loginUser({
    required String email,
    required String password,
  }) =>
      provider.loginUser(email: email, password: password);

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<void> initializeFirebase() => provider.initializeFirebase();

  @override
  Future<void> sendPasswordResetMail(String email) =>
      provider.sendPasswordResetMail(email);
}
