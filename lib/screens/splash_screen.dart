import 'package:flutter/material.dart';
import 'main_page.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Selamat Datang di MeetDigest', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => MainPage()));
              },
              child: Text('Lanjut'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => MainPage()));
              },
              child: Text('Lewati'),
            ),
          ],
        ),
      ),
    );
  }
}