// ignore_for_file: file_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workersapp/Login.dart';
import 'package:workersapp/adminUnverifiedWorkers.dart';
import 'package:workersapp/bottomnav.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  Future logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.teal[500],
          leading: IconButton(
            onPressed: () {
              logout();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (Route<dynamic> route) => false);
            },
            icon: Icon(
              Icons.logout_rounded,
              size: 20,
              color: Colors.white,
            ),
          ),
          title: Text("Admin Dashboard"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: MaterialButton(
                minWidth: double.infinity,
                height: 45,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => workerscategories()));
                },
                // defining the shape
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.teal),
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  "Unverified Users",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
