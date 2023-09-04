import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gardening_app/main.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigateToNextScreen();
  }

  void navigateToNextScreen() {
    Timer(Duration(seconds: 3), () {
      // Navigasi ke layar berikutnya di sini
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Color(0xFF417C51),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: MediaQuery.of(context).size.width * 0.3, // Adjust the logo size
              height: MediaQuery.of(context).size.width * 0.3, // Adjust the logo size
              fit: BoxFit.contain,
            ),
            SizedBox(width: 20),
            Text(
              'Smart\nGardening',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Overlock',
                fontSize: MediaQuery.of(context).size.width * 0.06,
                fontWeight: FontWeight.w900,
                height: 1.22,
                color: Color(0xFFFFFFFF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
