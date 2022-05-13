import 'package:flutter/foundation.dart' show immutable;
import 'package:notes_app/services/auth/auth_user.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

class AuthStateLoading extends AuthState {
  const AuthStateLoading();
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;

  const AuthStateLoggedIn(this.user);
}


class AuthStateNotVerified extends AuthState {
  const AuthStateNotVerified();
}

class AuthStateLoggedOut extends AuthState {
  final Exception? exception;
  const AuthStateLoggedOut(this.exception);
}

class AuthStateLogoutFailed extends AuthState {
  final Exception exception;

  const AuthStateLogoutFailed(this.exception);
}
