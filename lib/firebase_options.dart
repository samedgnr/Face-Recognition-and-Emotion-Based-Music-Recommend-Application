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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDIZ_r_lnJuw0LVwGovqVgfGtvg0DYTBpU',
    appId: '1:824783595424:android:4854a4ef74c5ba4aef26c5',
    messagingSenderId: '824783595424',
    projectId: 'spocv-61876',
    databaseURL: 'https://spocv-61876-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'spocv-61876.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCw0KDeMHktGEKAhbw81Gt_FfXwu_axTNM',
    appId: '1:824783595424:ios:efb00047b8f1e7c4ef26c5',
    messagingSenderId: '824783595424',
    projectId: 'spocv-61876',
    databaseURL: 'https://spocv-61876-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'spocv-61876.appspot.com',
    iosBundleId: 'com.example.musicRecommendationWithEmotionalAnalysiss',
  );
}
