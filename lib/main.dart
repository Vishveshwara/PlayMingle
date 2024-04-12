import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:playmingle/screens/splash.dart';
import 'package:playmingle/screens/tabs.dart';
import 'firebase_options.dart';
import 'package:playmingle/screens/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class App extends StatelessWidget {
  
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    String email = '';
    return MaterialApp(
      title: 'PlayMingle',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 63, 17, 177)),
      ),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SplashScreen();
            }

            if (snapshot.hasData) {
              print("Email in snapshot: $email");
              return TabsScreen(email);
              
            } else {
              return AuthScreen(email, ChangedEmail: (value) {
                email = value;
              });
              
              
            }
          }),
    );
  }
}
