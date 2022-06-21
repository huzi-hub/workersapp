// ignore_for_file: file_names
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as Firebase_Storage;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workersapp/Login.dart';
import 'package:workersapp/accountDetails.dart';
import 'package:workersapp/approvedOrders.dart';
import 'package:workersapp/bottomnav.dart';
import 'package:workersapp/Termsandconditions.dart';
import 'package:workersapp/completedOrders.dart';
import 'package:workersapp/orderHistory.dart';
import 'package:workersapp/orders.dart';
import 'package:workersapp/userReviews.dart';
import 'package:workersapp/welcomepage.dart';

// var name = "Hassan";
// var spec = "Electrician";
// var revw = 4;
// var desc =
//     "Lorem Ipsum is simply dummy text \nof the printing and typesetting industry. \nLorem Ipsum is simply dummy text \nof the printing and typesetting industry.";

class Dashboard extends StatefulWidget {
  // final String documentId;
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String documentID = " ";
  final auth = FirebaseAuth.instance.currentUser!;

  var size, height, width;

  bool isLoading = false;

  String? urlfinal = null;
  String? name = null;
  String? email = null;

  get_image(email) async {
    final ref = Firebase_Storage.FirebaseStorage.instance
        .ref()
        .child('userProfiles/')
        .child(email)
        .child('DP.jpg');
    var url = await ref.getDownloadURL();
    print(url);
    User auth = FirebaseAuth.instance.currentUser!;
    auth.updatePhotoURL(url);
    setState(() {
      urlfinal = url;
    });
    return "Done";
  }

  // method for logging out a current user
  Future logout() async {
    await FirebaseAuth.instance.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("email");
    prefs.remove("pass");
  }

  void initState() {
    super.initState();

    // name = auth.displayName;
    email = auth.email;
    documentID = auth.uid;
    get_image(email);
  }

  @override
  Widget build(BuildContext context) {
    // CollectionReference for worker drawer and dashboard single data
    CollectionReference workers =
        FirebaseFirestore.instance.collection('employeesDetails');
    // .doc(cat)
    // .collection(cat);
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Center(child: Text("AAM AADMI")),
          actions: [
            IconButton(
                onPressed: () {
                  logout();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                      (Route<dynamic> route) => false);
                },
                icon: Icon(Icons.logout))
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: FutureBuilder<DocumentSnapshot>(
                    future: workers.doc(documentID).get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text("Something Went wrong");
                      }
                      if (snapshot.hasData && !snapshot.data!.exists) {
                        return ListView(
                          shrinkWrap: true,
                          children: [
                            // Text(this.documentId),
                            Text("Data does not exists"),
                          ],
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.done) {
                        Map<String, dynamic> data =
                            snapshot.data!.data() as Map<String, dynamic>;
                        return ListView(
                          shrinkWrap: true,
                          children: [
                            ListTile(
                              title: Text(
                                "Hello,",
                                style:
                                    TextStyle(fontSize: 25, color: Colors.grey),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${data['fullName']}",
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(10),
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12.0),
                                  border: Border.all(color: Colors.teal),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        blurRadius: 5,
                                        offset: const Offset(0, 2),
                                        spreadRadius: 4)
                                  ]),
                              child: Column(
                                children: [
                                  urlfinal != null
                                      ? CircleAvatar(
                                          radius: 50.0,
                                          backgroundImage:
                                              NetworkImage(urlfinal!),
                                          backgroundColor: Colors.transparent,
                                        )
                                      : CircleAvatar(
                                          radius: 20.0,
                                          backgroundColor: Colors.transparent,
                                          child: CircularProgressIndicator(),
                                        ),
                                  SizedBox(height: 25),
                                  Center(
                                    child: Text(
                                      "Ratings: ${double.parse(data['rating']).toStringAsFixed(2)} / ${double.parse(data['noOfRating'])}",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  color: Colors.teal[500],
                                  borderRadius: BorderRadius.circular(12.0),
                                  border: Border.all(color: Colors.tealAccent),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        blurRadius: 5,
                                        offset: const Offset(0, 2),
                                        spreadRadius: 1)
                                  ]),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text("Description",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25,
                                          fontWeight: FontWeight.w700)),
                                  const SizedBox(height: 5),
                                  const Divider(color: Colors.tealAccent),
                                  Container(
                                    width: width * 0.8,
                                    child: Text(
                                      ("${data['description']}"),
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 3,
                                        blurRadius: 10,
                                        offset: Offset(2, 2),
                                      )
                                    ]),
                                child: MaterialButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                UserReviews()));
                                  },
                                  minWidth: double.infinity,
                                  color: Colors.teal[500],
                                  height: 50,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    "Customer Reviews",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        drawer: Drawer(
          child: FutureBuilder<DocumentSnapshot>(
            future: workers.doc(documentID).get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text("Something Went wrong");
              }
              if (snapshot.hasData && !snapshot.data!.exists) {
                return ListView(
                  children: [
                    UserAccountsDrawerHeader(
                      accountName: Text("Data does not exists"),
                      accountEmail: Text("Data does not exists"),
                    )
                  ],
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;
                return ListView(
                  children: [
                    InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Dashboard())).then((value) {
                        urlfinal = null;
                        setState(() {
                          get_image(email);
                        });
                      }),
                      child: urlfinal != null
                          ? UserAccountsDrawerHeader(
                              decoration:
                                  BoxDecoration(color: Colors.teal[500]),
                              currentAccountPicture: CircleAvatar(
                                backgroundImage: NetworkImage(urlfinal!),
                                backgroundColor: Colors.transparent,
                              ),
                              accountName: Text("${data['fullName']}",
                                  style: TextStyle(color: Colors.black)),
                              accountEmail: Text("${data['email']}",
                                  style: TextStyle(color: Colors.black)),
                            )
                          : UserAccountsDrawerHeader(
                              decoration:
                                  BoxDecoration(color: Colors.teal[500]),
                              currentAccountPicture: CircleAvatar(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                                backgroundColor: Colors.transparent,
                              ),
                              accountName: Text("${data['fullName']}",
                                  style: TextStyle(color: Colors.black)),
                              accountEmail: Text("${data['email']}",
                                  style: TextStyle(color: Colors.black)),
                            ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.person,
                        color: Colors.teal[500],
                      ),
                      title: Text("Account"),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.teal[500],
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Accountdetails(
                                      documentId: user!.uid,
                                    )));
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.history, color: Colors.teal[500]),
                      title: Text("Orders History"),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.teal[500],
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OrderHistoryList()));
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.history, color: Colors.teal[500]),
                      title: const Text("Approved Orders"),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.teal[500],
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ApprovedOrders()));
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.history, color: Colors.teal[500]),
                      title: Text("Completed Orders"),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.teal[500],
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CompletedOrders()));
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.pending_actions_outlined,
                        color: Colors.teal[500],
                      ),
                      title: Text("Terms & Conditions"),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.teal[500],
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TermsAndConditions()));
                      },
                    ),
                    ListTile(
                      leading:
                          Icon(Icons.announcement, color: Colors.teal[500]),
                      title: Text("About Us"),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.teal[500],
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TermsAndConditions()));
                      },
                    ),
                    ListTile(
                        leading: Icon(
                          Icons.logout_rounded,
                          color: Colors.teal,
                        ),
                        title: Text("Log Out"),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.teal[500],
                        ),
                        onTap: () {
                          logout();
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                              (Route<dynamic> route) => false);
                        })
                  ],
                );
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white,
            // fixedColor: Colors.teal,
            selectedItemColor: Colors.teal,
            unselectedItemColor: Colors.black,
            currentIndex: 0,
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
                label: 'Orders',
              ),
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
