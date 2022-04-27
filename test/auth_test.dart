import 'package:notes_app/services/auth/auth_exceptions.dart';
import 'package:test/test.dart';

import 'exceptions.dart';
import 'test_auth_provider.dart';

void main() {
  group("Mock Authentication", () {
    final provider = TestAuthProvider();
    test("not initialized on start", () {
      expect(provider.isInitialized, false);
    });

    test("Cannot logout if not initialized", () {
      expect(
        provider.logOutUser(),
        throwsA(const TypeMatcher<NotInitializedException>()),
      );
    });

    test("should be able to initialize", () async {
      await provider.initializeFirebase();
      expect(provider.isInitialized, true);
    });

    test("User should be null after initialization", () {
      expect(provider.currentUser, null);
    });

    test("Should be able to initialize in 3 seconds", () async {
      await provider.initializeFirebase();
      expect(provider.isInitialized, true);
    }, timeout: const Timeout(Duration(seconds: 3)));

    test("createUser should delegate to login", () async {
      final badUserEmail =
          provider.createUser(email: "foo@bar.com", password: "password");
      expect(badUserEmail,
          throwsA(const TypeMatcher<UserNotFoundAuthException>()));

      final badUserPassword =
          provider.createUser(email: "foooo@bar.com", password: "foobar");
      expect(badUserPassword,
          throwsA(const TypeMatcher<WrongPasswordAuthException>()));

      final user = await provider.createUser(
        email: "foo",
        password: "bar",
      );
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });

    test("Logged in user should be able to get verified", () async {
      await provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test("Should be able to log out and log in again", () async {
      await provider.logOutUser();
      expect(provider.currentUser, isNull);
      await provider.loginUser(email: "email", password: "pass");
      expect(provider.currentUser, isNotNull);
    });
  });
}
