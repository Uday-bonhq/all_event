import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBtoKXOWMo0_0SlLqvIi0bqrKQNVlAdNMI',
    appId: '1:730535221949:android:6b7501841873c3ce25b5d4',
    messagingSenderId: '730535221949',
    projectId: 'allevent-9f255',
    storageBucket: 'allevent-9f255.firebasestorage.app',
  );
}
