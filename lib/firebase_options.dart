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
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyBxcHTUqDh9Fy8JCYxepnxpV891boFUvhc',
    appId: '1:355327449986:web:c7864eb5bf04c4464b8d9b',
    messagingSenderId: '355327449986',
    projectId: 'lista-ko',
    authDomain: 'lista-ko.firebaseapp.com',
    storageBucket: 'lista-ko.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCfCMQmQKYppM3xn7jVl1bnIvOoCqyxrNg',
    appId: '1:355327449986:android:95ca1e47394dd5154b8d9b',
    messagingSenderId: '355327449986',
    projectId: 'lista-ko',
    storageBucket: 'lista-ko.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCIiyW4LtASZIJLp7-BmGg7mmCOKSuDDs8',
    appId: '1:355327449986:ios:26350dbb18b1117a4b8d9b',
    messagingSenderId: '355327449986',
    projectId: 'lista-ko',
    storageBucket: 'lista-ko.firebasestorage.app',
    iosBundleId: 'com.example.listako',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCIiyW4LtASZIJLp7-BmGg7mmCOKSuDDs8',
    appId: '1:355327449986:ios:26350dbb18b1117a4b8d9b',
    messagingSenderId: '355327449986',
    projectId: 'lista-ko',
    storageBucket: 'lista-ko.firebasestorage.app',
    iosBundleId: 'com.example.listako',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBxcHTUqDh9Fy8JCYxepnxpV891boFUvhc',
    appId: '1:355327449986:web:c57732c5a263b5134b8d9b',
    messagingSenderId: '355327449986',
    projectId: 'lista-ko',
    authDomain: 'lista-ko.firebaseapp.com',
    storageBucket: 'lista-ko.firebasestorage.app',
  );
}
