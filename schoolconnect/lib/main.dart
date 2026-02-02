import 'package:schoolconnect/Screens/login.dart';
import 'package:flutter/material.dart';
import 'package:schoolconnect/export.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:schoolconnect/Screens/dashboard.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final hasToken = prefs.getString('auth_token') != null;
  runApp(
    AppProviders.init(
      child: MyApp(initialRoute: hasToken ? '/dashboard' : '/login'),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'School Connect',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: initialRoute,
      routes: {
        '/login': (_) => const LoginScreen(),
        '/dashboard': (_) => const TeacherBottomNav(),
      },
    );
  }
}
