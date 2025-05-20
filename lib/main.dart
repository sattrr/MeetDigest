import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() => runApp(MeetDigestApp());

class MeetDigestApp extends StatelessWidget {
  const MeetDigestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MeetDigest',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          surface: Colors.white,
        ),
      ),
      home: SplashScreen(),
    );
  }
}