import 'package:bloc/bloc.dart';
import 'package:notes_app/services/auth/auth_provider.dart';
import 'package:notes_app/services/auth/bloc/auth_event.dart';
import 'package:notes_app/services/auth/bloc/auth_state.dart';
import 'dart:developer' as devtools show log;

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthStateNotInitialized()) {
    //Register event
    on<AuthEventRegister>((event, emit) async {
      emit(const AuthStateRegistering(null));
      try {
        await provider.createUser(
          email: event.email,
          password: event.password,
        );
        await provider.sendEmailVerification();
        emit(const AuthStateNotVerified());
      } on Exception catch (e) {
        emit(AuthStateRegistering(e));
      }
    });

    //SendEmailVerificationEvent
    on<AuthEventSendVerificationEmail>((event, emit) async {
      await provider.sendEmailVerification();
      emit(state);
    });

    //Firebase init event
    on<AuthEventInitialize>((event, emit) async {
      await provider.initializeFirebase();
      final user = provider.currentUser;
      if (user == null) {
        emit(const AuthStateLoggedOut(
          exception: null,
          isLoading: false,
        ));
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNotVerified());
      } else {
        emit(AuthStateLoggedIn(user));
      }
    });

    //Login event
    on<AuthEventLogIn>((event, emit) async {
      emit(const AuthStateLoggedOut(
        exception: null,
        isLoading: true,
      ));
      final email = event.email;
      final password = event.password;
      try {
        final user = await provider.loginUser(
          email: email,
          password: password,
        );

        emit(
          const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
          ),
        );
        if (user.isEmailVerified) {
          emit(AuthStateLoggedIn(user));
        } else {
          emit(const AuthStateNotVerified());
        }
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(
          exception: e,
          isLoading: false,
        ));
      }
    });

    //Logout Event
    on<AuthEventLogOut>((event, emit) async {
      emit(
        const AuthStateLoggedOut(
          exception: null,
          isLoading: true,
        ),
      );
      try {
        await provider.logOutUser();
        emit(
          const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
          ),
        );
      } on Exception catch (e) {
        emit(
          AuthStateLoggedOut(
            exception: e,
            isLoading: false,
          ),
        );
      }
    });
  }

  @override
  void onChange(Change<AuthState> change) {
    devtools.log(change.toString());
    super.onChange(change);
  }
}
