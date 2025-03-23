import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyDeWMSOUz66zBUbwPoYIyP8RSy1K3dRNVQ",
            authDomain: "feel-mate-01niw2.firebaseapp.com",
            projectId: "feel-mate-01niw2",
            storageBucket: "feel-mate-01niw2.appspot.com",
            messagingSenderId: "980946708000",
            appId: "1:980946708000:web:7ae871a569e913fb387e45"));
  } else {
    await Firebase.initializeApp();
  }
}
