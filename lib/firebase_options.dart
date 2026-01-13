import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD2MKUQgNrMPTirDqxfNzh1tFyPSQck9vs',
    appId: '1:834664689370:web:3c1c5bbbdd221887e33fe3',
    messagingSenderId: '834664689370',
    projectId: 'wicketlk-33a8c',
    authDomain: 'wicketlk-33a8c.firebaseapp.com',
    storageBucket: 'wicketlk-33a8c.firebasestorage.app',
    measurementId: 'G-B7SHZFG2NE',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBJh15l1f7xpYkNqwD-Qi1-3lfRhgqenCY',
    appId: '1:834664689370:android:43fd4a2fe5e102c2e33fe3',
    messagingSenderId: '834664689370',
    projectId: 'wicketlk-33a8c',
    storageBucket: 'wicketlk-33a8c.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCwcbY68mGfgc5VQ8l6KretVBwjycbGtCg',
    appId: '1:834664689370:ios:5fa4760237765e39e33fe3',
    messagingSenderId: '834664689370',
    projectId: 'wicketlk-33a8c',
    storageBucket: 'wicketlk-33a8c.firebasestorage.app',
    iosBundleId: 'com.example.wicketlk',
  );

}