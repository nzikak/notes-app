import 'package:notes_app/services/auth/auth_exceptions.dart';
import 'package:notes_app/services/auth/auth_provider.dart';
import 'package:notes_app/services/auth/auth_user.dart';

import 'exceptions.dart';

class TestAuthProvider implements AuthProvider {
  var _isInitialized = false;

  bool get isInitialized => _isInitialized;

  AuthUser? _user;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 2));
    return loginUser(email: email, password: password);
  }

  @override
  AuthUser? get currentUser {
    if (!isInitialized) throw NotInitializedException();
    return _user;
  }

  @override
  Future<void> initializeFirebase() async {
    await Future.delayed(const Duration(seconds: 2));
    _isInitialized = true;
  }

  @override
  Future<void> logOutUser() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotLoggedInException();

    await Future.delayed(const Duration(seconds: 2));
    _user = null;
  }

  @override
  Future<AuthUser> loginUser({
    required String email,
    required String password,
  }) {
    if (!isInitialized) throw NotInitializedException();
    if (email == "foo@bar.com") throw UserNotFoundAuthException();
    if (password == "foobar") throw WrongPasswordAuthException();

    final user = AuthUser(
      email: email,
      isEmailVerified: false,
    );
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotLoggedInException();
    _user = const AuthUser(
      email: null,
      isEmailVerified: true,
    );
  }
}
