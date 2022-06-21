// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:workersapp/Dashboard.dart';
import 'package:workersapp/accountDetails.dart';
import 'package:workersapp/bottomnav.dart';
import 'package:workersapp/orderDetails.dart';
import 'package:firebase_storage/firebase_storage.dart' as Firebase_Storage;
import 'package:workersapp/orderHistory.dart';
import 'package:workersapp/orders.dart';

// var names = ["Hassan", "Hyder", "Zaheer", "Afifa", "Rao"];
// var revws = [5, 4, 3, 2, 1];
// var age = [21, 25, 30, 35, 40];
// var experience = [10, 12, 5, 3, 6];
// var pics = ["painter1.jpg", "carpenter.jpg", "Null", "plumberr1.jpg", "Null"];

class UserReviews extends StatefulWidget {
  const UserReviews({Key? key}) : super(key: key);

  @override
  _UserReviewsState createState() => _UserReviewsState();
}

class _UserReviewsState extends State<UserReviews> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // get_image();
  }

  var size, height, width;

  FirebaseAuth auth = FirebaseAuth.instance;

  final Stream<QuerySnapshot> reviewList = FirebaseFirestore.instance
      .collection('employeesDetails')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('reviews')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.teal[500],
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.white,
            ),
          ),
          title: Text("Reviews"),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: reviewList,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.data!.size == 0) {
              return Center(child: Text('You have no reviews yet!'));
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: InkWell(
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      decoration:
                          BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                            spreadRadius: 1)
                      ]),
                      child: Column(
                        children: [
                          ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "User review:",
                                      ),
                                      Text(
                                        "${data['reviews']}",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {},
                  ),
                );
              }).toList(),
            );
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white,
            currentIndex: 0,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.black,
            iconSize: 25,
            onTap: (int index) => btn(index, context),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home_outlined,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.notifications_active_outlined,
                  ),
                  label: 'Orders'),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person_outline,
                ),
                label: 'Settings',
              ),
            ]));
  }
}

final _auth = FirebaseAuth.instance;
User? user = _auth.currentUser;
btn(i, context) {
  if (i == 0) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Dashboard()));
  } else if (i == 1) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => orderDetails()));
  } else {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Accountdetails(documentId: user!.uid)));
  }
}
