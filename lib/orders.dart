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

// var names = ["Hassan", "Hyder", "Zaheer", "Afifa", "Rao"];
// var revws = [5, 4, 3, 2, 1];
// var age = [21, 25, 30, 35, 40];
// var experience = [10, 12, 5, 3, 6];
// var pics = ["painter1.jpg", "carpenter.jpg", "Null", "plumberr1.jpg", "Null"];

class orderDetails extends StatefulWidget {
  const orderDetails({Key? key}) : super(key: key);

  @override
  _orderDetailsState createState() => _orderDetailsState();
}

class _orderDetailsState extends State<orderDetails> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // get_image();
  }

  var size, height, width;

  final Stream<QuerySnapshot> OrderHistoryList = FirebaseFirestore.instance
      .collection('Orders')
      .where('workerUid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .where('status', isEqualTo: 'Pending')
      .orderBy('date', descending: false)
      .snapshots();

  FirebaseAuth auth = FirebaseAuth.instance;

  String? urlfinal;

  get_image(email) async {
    final ref = Firebase_Storage.FirebaseStorage.instance
        .ref()
        .child('userAAMProfiles/')
        .child(email)
        .child('DP.jpg');
    var url = await ref.getDownloadURL();
    print(url);
    User auth = FirebaseAuth.instance.currentUser!;
    auth.updatePhotoURL(url);
    setState(() {
      email = urlfinal;
      urlfinal = url;
    });
    return "done";
  }

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
          title: Text("Orders"),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: OrderHistoryList,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.data!.size == 0) {
              return Center(child: Text('You have no orders yet!'));
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
                              // leading:
                              //     urlfinal != null
                              //         ? CircleAvatar(
                              //             radius: 50.0,
                              //             backgroundImage:
                              //                 NetworkImage(urlfinal!),
                              //             backgroundColor: Colors.transparent,
                              //           )
                              //         : CircleAvatar(
                              //             radius: 20.0,
                              //             backgroundColor: Colors.transparent,
                              //             child: CircularProgressIndicator(),
                              //           ),
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
                                          "Name",
                                        ),
                                        Text(
                                          "${data['userName']}",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(color: Colors.grey),
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 8.0, right: 8.0),
                                    child: Text(
                                        "Descrition: ${data['work description']}"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 5.0),
                                    child: Text("Rs: ${data['work demand']}"),
                                  ),
                                ],
                              ),
                              trailing: Text(data['status'])),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrderDetails(
                                    documentId: document.id,
                                  )));
                    },
                  ),
                );
              }).toList(),
            );
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white,
            // fixedColor: Colors.teal,
            selectedItemColor: Colors.teal,
            unselectedItemColor: Colors.black,
            currentIndex: 1,
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
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Dashboard()));
  } else if (i == 1) {
  } else {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Accountdetails(documentId: user!.uid)));
  }
}
