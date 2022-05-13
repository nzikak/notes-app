import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:notes_app/services/auth/auth_user.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

class AuthStateNotInitialized extends AuthState {
  const AuthStateNotInitialized();
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;

  const AuthStateLoggedIn(this.user);
}

class AuthStateNotVerified extends AuthState {
  const AuthStateNotVerified();
}

class AuthStateRegistering extends AuthState {
  final Exception? exception;

  const AuthStateRegistering(this.exception);
}

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final bool isLoading;
  final Exception? exception;

  const AuthStateLoggedOut({
    required this.exception,
    required this.isLoading,
  });

  @override
  List<Object?> get props => [isLoading, exception];
}
