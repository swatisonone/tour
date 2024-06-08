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
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCfa69eHEC4nmxKkutwgPGEF8kKrFE45x8',
    appId: '1:924981877407:web:0c8a039a218c94b1bba0aa',
    messagingSenderId: '924981877407',
    projectId: 'classchat-befef',
    authDomain: 'classchat-befef.firebaseapp.com',
    storageBucket: 'classchat-befef.appspot.com',
    measurementId: 'G-CVD0SDPD3W',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBPIrqj2F3DYQvUBA-aFhTkHbKCUqvVnmg',
    appId: '1:924981877407:android:f8432db6148d7c21bba0aa',
    messagingSenderId: '924981877407',
    projectId: 'classchat-befef',
    storageBucket: 'classchat-befef.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBkUZXDP3IE3SCBRU5WjjCuuH30Ej2-6zc',
    appId: '1:924981877407:ios:815b4bbd5ee98f75bba0aa',
    messagingSenderId: '924981877407',
    projectId: 'classchat-befef',
    storageBucket: 'classchat-befef.appspot.com',
    androidClientId: '924981877407-injks4m7pmi5skl2ummtkcceingcietl.apps.googleusercontent.com',
    iosClientId: '924981877407-es093ph0vq3hmhqa1e5oo1ndertva678.apps.googleusercontent.com',
    iosBundleId: 'com.example.tour',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBkUZXDP3IE3SCBRU5WjjCuuH30Ej2-6zc',
    appId: '1:924981877407:ios:815b4bbd5ee98f75bba0aa',
    messagingSenderId: '924981877407',
    projectId: 'classchat-befef',
    storageBucket: 'classchat-befef.appspot.com',
    androidClientId: '924981877407-injks4m7pmi5skl2ummtkcceingcietl.apps.googleusercontent.com',
    iosClientId: '924981877407-es093ph0vq3hmhqa1e5oo1ndertva678.apps.googleusercontent.com',
    iosBundleId: 'com.example.tour',
  );
}