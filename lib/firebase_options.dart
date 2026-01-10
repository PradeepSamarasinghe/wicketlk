import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return web;
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDummyApiKey123456789',
    appId: '1:123456789:web:abcdef123456',
    messagingSenderId: '123456789',
    projectId: 'wicket-lk',
    authDomain: 'wicket-lk.firebaseapp.com',
    storageBucket: 'wicket-lk.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDummyApiKey123456789',
    appId: '1:123456789:android:abcdef123456',
    messagingSenderId: '123456789',
    projectId: 'wicket-lk',
    storageBucket: 'wicket-lk.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDummyApiKey123456789',
    appId: '1:123456789:ios:abcdef123456',
    messagingSenderId: '123456789',
    projectId: 'wicket-lk',
    storageBucket: 'wicket-lk.appspot.com',
    iosBundleId: 'com.wicket.lk',
  );
}
