import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import "./pages/login_page.dart";
import './pages/registration_page.dart';
import './pages/home_page.dart';

/// import 'package:firebase_analytics/firebase_analytics.dart';
/// import './services/navigation_service.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    runApp(const MyApp());
  } catch (e) {
    print('Firebase initialization error: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Echo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color.fromRGBO(42, 117, 188, 1),
        colorScheme: ColorScheme.fromSwatch(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
        ).copyWith(
          primary: const Color.fromRGBO(42, 117, 188, 1),
          secondary:
              const Color.fromRGBO(42, 117, 188, 1), // Used to be accentColor
          surface: const Color.fromRGBO(28, 27, 27, 1),
        ),
      ),
      initialRoute: "login",
      routes: {
        "login": (BuildContext context) => const LoginPage(),
        "register": (BuildContext context) => const RegistrationPage(),
        "home": (BuildContext context) => const HomePage(),
      },
    );
  }
}

/**import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import "./pages/login_page.dart";
import './pages/registration_page.dart';
import './pages/home_page.dart';
import './services/navigation_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Echo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color.fromRGBO(42, 117, 188, 1),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Color.fromRGBO(42, 117, 188, 1),
          secondary: Color.fromRGBO(42, 117, 188, 1), // Used to be accentColor
          surface: Color.fromRGBO(28, 27, 27, 1),
        ),
      ),
      initialRoute: "login",
      routes: {
        "login": (BuildContext _context) => LoginPage(),
        "register": (BuildContext _context) => RegistrationPage(),
        "home": (BuildContext _context) => HomePage(),
      },
    );
  }
} */
