import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool loggedIn = prefs.getBool('loggedIn') ?? false;

  runApp(KoraTVApp(isLoggedIn: loggedIn));
}

class KoraTVApp extends StatelessWidget {
  final bool isLoggedIn;

  KoraTVApp({required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KORA TV PRO',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'Readex Pro',
      ),
      home: isLoggedIn ? HomeScreen() : LoginScreen(),
    );
  }
}
