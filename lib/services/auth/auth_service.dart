import 'auth_provider.dart';
import 'auth_user.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;

  const AuthService(this.provider);

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
}
