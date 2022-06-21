// ignore_for_file: camel_case_types
// ignore_for_file: file_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workersapp/Dashboard.dart';
import 'package:workersapp/signup.dart';
import 'package:workersapp/welcomepage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    // Timer(Duration(seconds: 3), () async {
    //   Navigator.pushReplacement(context,
    //       MaterialPageRoute(builder: (context) => RegistrationScreen()));
    // });
    Timer(Duration(seconds: 3), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getString("email") != null && prefs.getString("pass") != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Dashboard()));
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => RegistrationScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          child: Image.asset(
            "assets/aamaadmi.png",
            height: 400,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
