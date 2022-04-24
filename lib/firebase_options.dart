// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC5y_eNxcnO6rFu-R9qD8fZrEV10hiOXcQ',
    appId: '1:551204154466:android:b4e80b0fc6b2c895e9353b',
    messagingSenderId: '551204154466',
    projectId: 'notes-app-flutter-proj',
    storageBucket: 'notes-app-flutter-proj.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDc2s6CkYAzRNYIHFZzjUnt2F_FB4WOPyU',
    appId: '1:551204154466:ios:d8108be34b141167e9353b',
    messagingSenderId: '551204154466',
    projectId: 'notes-app-flutter-proj',
    storageBucket: 'notes-app-flutter-proj.appspot.com',
    iosClientId: '551204154466-5tfrgk5lefqajrd7ec4dfhcaroa06eh6.apps.googleusercontent.com',
    iosBundleId: 'com.thedynamicdev.notesApp',
  );
}
