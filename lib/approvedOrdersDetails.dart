// ignore_for_file: camel_case_types, must_be_immutable
// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ApprovedOrderDetails extends StatefulWidget {
  final String documentId;
  ApprovedOrderDetails({Key? key, required this.documentId}) : super(key: key);

  @override
  State<ApprovedOrderDetails> createState() => _ApprovedOrderDetailsState();
}

class _ApprovedOrderDetailsState extends State<ApprovedOrderDetails> {
  var size, height, width;

  bool isLoading = false;

  String? urlfinal = null;

  String? name = null;
  // String? email = null;

  get_image(email) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('userAAMProfiles/')
        .child(email)
        .child('DP.jpg');
    var url = await ref.getDownloadURL();
    print(url);
    // User auth = FirebaseAuth.instance.currentUser!;
    // auth.updatePhotoURL(url);
    setState(() {
      urlfinal = url;
    });
    return "Done";
  }

  @override
  Widget build(BuildContext context) {
    // CollectionReference for worker drwaer single data
    CollectionReference users = FirebaseFirestore.instance.collection('Orders');
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
        title: Text("Profile"),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10),
                child: FutureBuilder<DocumentSnapshot>(
                  future: users.doc(widget.documentId).get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text("Something Went wrong");
                    }
                    if (snapshot.hasData && !snapshot.data!.exists) {
                      return ListView(
                        shrinkWrap: true,
                        children: [
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
                          Container(
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.0),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      blurRadius: 5,
                                      offset: const Offset(0, 2),
                                      spreadRadius: 4)
                                ]),
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      get_image(data['userEmail']);
                                    });
                                  },
                                  child: Center(
                                    child: Column(
                                      children: [
                                        urlfinal != null
                                            ? CircleAvatar(
                                                radius: 50.0,
                                                backgroundImage:
                                                    NetworkImage(urlfinal!),
                                                backgroundColor:
                                                    Colors.transparent,
                                              )
                                            : Text('View Profile..'),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Center(
                                  child: Text(
                                    "${data['userName']}",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black),
                                  ),
                                ),
                                Divider(color: Colors.grey),
                                Center(
                                  child: Text(
                                    "Work status: ${data['status']}",
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
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
                                      spreadRadius: 1)
                                ]),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ListTile(
                                  leading: Icon(Icons.description,
                                      color: Colors.teal),
                                  title: Text("Work description"),
                                  subtitle: Text("${data['work description']}"),
                                ),
                                Divider(color: Colors.grey[500]),
                                ListTile(
                                  leading: Icon(Icons.euro, color: Colors.teal),
                                  title: Text("Work Demand"),
                                  subtitle: Text("Rs: ${data['work demand']}"),
                                ),
                                Divider(color: Colors.grey[500]),
                                ListTile(
                                  leading: Icon(Icons.phone_android_outlined,
                                      color: Colors.teal),
                                  title: Text(
                                    "User Contact",
                                  ),
                                  subtitle: Text("${data['userContact']}"),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
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
                                    update();
                                    Navigator.pop(context);
                                  },
                                  color: Colors.teal[500],
                                  height: 45,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    "Completed",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 3),
                                  ),
                                ),
                              ),
                              Container(
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
                                    cancelledByWorker();
                                    Navigator.pop(context);
                                  },
                                  color: Colors.red,
                                  height: 45,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    "Cancel Order",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 3),
                                  ),
                                ),
                              ),
                            ],
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
    );
  }

  Future update() async {
    FirebaseFirestore.instance
        .collection('Orders')
        .doc(widget.documentId)
        .update({"status": "Completed"}).then((value) => print('Success'));
  }

  Future cancelledByWorker() async {
    FirebaseFirestore.instance
        .collection('Orders')
        .doc(widget.documentId)
        .update({"status": "Cancelled by worker"}).then(
            (value) => print("Success"));
  }
}
