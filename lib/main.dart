import 'dart:async';

import 'package:flutter/material.dart';
import 'package:grid/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isFirstTime = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    await SharedPreferences.getInstance().then((prefs) {
      isFirstTime = prefs.getBool('firstTime') ?? true;
    });
    setState(() {});
    if (isFirstTime) {
      Timer(
        const Duration(seconds: 1),
        () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        ),
      );
      await SharedPreferences.getInstance().then((prefs) {
        prefs.setBool('firstTime', false);
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isFirstTime
          ? const Center(
              child: FlutterLogo(
                size: 100,
              ),
            )
          : Container(),
    );
  }
}
