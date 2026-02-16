import 'package:schoolconnect/Screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:schoolconnect/export.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:schoolconnect/Screens/dashboard.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.dark,
  ));
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
      // Force a fixed textScaleFactor so system font scaling doesn't
      // affect the app's text styles.
      builder: (BuildContext context, Widget? child) {
        final mediaQuery = MediaQuery.of(context);
        return MediaQuery(
          data: mediaQuery.copyWith(textScaleFactor: 1.0),
          child: child ?? const SizedBox.shrink(),
        );
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: const Color(0xFFF5F9FF),
        cardColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 18),
          elevation: 0,
          centerTitle: true,
        ),
      ),
      initialRoute: initialRoute,
      routes: {
        '/login': (_) => const LoginScreen(),
        '/dashboard': (_) => const TeacherBottomNav(),
      },
    );
  }
}
