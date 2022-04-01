import 'package:canary_chat/screens/home_page.dart';
import 'package:canary_chat/screens/login_screen.dart';
import 'package:canary_chat/services/auth_service.dart';
import 'package:canary_chat/services/firestore_service.dart';
import 'package:canary_chat/services/notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      lazy: false,
      create: (_) => FireStoreService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthService _auth = AuthService();

    return StreamBuilder(
      stream: _auth.userState,
      builder: (context, snapshot) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Canary Chat",
          home: snapshot.hasData ? const HomePage() : const LogInScreen(),
        );
      },
    );
  }
}
