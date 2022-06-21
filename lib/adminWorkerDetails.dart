// ignore_for_file: camel_case_types, must_be_immutable
// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workersapp/adminUnverifiedWorkers.dart';
import 'package:workersapp/bottomnav.dart';
import 'package:workersapp/workerModel.dart';

class WorkerrDetails extends StatefulWidget {
  final String documentId;
  WorkerrDetails({Key? key, required this.documentId}) : super(key: key);

  @override
  State<WorkerrDetails> createState() => _WorkerrDetailsState();
}

class _WorkerrDetailsState extends State<WorkerrDetails> {
  var size, height, width;

  bool isLoading = false;

  String? urlprofile = null;
  String? urlcnicfrnt = null;
  String? urlcnicback = null;

  String? name = null;

  Future get_profile(email) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('userProfiles/')
        .child(email)
        .child('DP.jpg');
    var url = await ref.getDownloadURL();
    print(url);
    setState(() {
      urlprofile = url;
    });
    return url;
  }

  Future get_cnicfrnt(email) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('userProfiles/')
        .child(email)
        .child('CNIC FRONT.jpg');
    var url = await ref.getDownloadURL();
    print(url);
    setState(() {
      urlcnicfrnt = url;
    });
    return url;
  }

  Future get_cnicback(email) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('userProfiles/')
        .child(email)
        .child('CNIC BACK.jpg');
    var url = await ref.getDownloadURL();
    print(url);
    setState(() {
      urlcnicback = url;
    });
    return url;
  }

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  // void intiState() {
  //   super.initState();

  //   users.doc(widget.documentId).get().then((value) {
  //     get_profile(value['email']).then((value) {
  //       setState(() {
  //         urlprofile = value;
  //       });
  //     });
  //     get_cnicfrnt(value['email']).then((value) {
  //       setState(() {
  //         urlcnicfrnt = value;
  //       });
  //     });
  //     get_cnicback(value['email']).then((value) {
  //       setState(() {
  //         urlcnicback = value;
  //       });
  //     });
  //   });
  // }

  CollectionReference users =
      FirebaseFirestore.instance.collection('employeesDetails');

  @override
  Widget build(BuildContext context) {
    // CollectionReference for worker drwaer single data

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

                      // get_profile(data['email']);

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
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        get_cnicfrnt(data['email']);
                                        get_profile(data['email']);
                                        get_cnicback(data['email']);
                                      },
                                      child: Center(
                                        child: Row(
                                          children: [
                                            urlcnicfrnt != null
                                                ? CircleAvatar(
                                                    radius: 50.0,
                                                    backgroundImage:
                                                        NetworkImage(
                                                            urlcnicfrnt!),
                                                    backgroundColor:
                                                        Colors.transparent,
                                                  )
                                                : Text('('),
                                            urlprofile != null
                                                ? CircleAvatar(
                                                    radius: 50.0,
                                                    backgroundImage:
                                                        NetworkImage(
                                                            urlprofile!),
                                                    backgroundColor:
                                                        Colors.transparent,
                                                  )
                                                : Text('View profile'),
                                            urlcnicback != null
                                                ? CircleAvatar(
                                                    radius: 50.0,
                                                    backgroundImage:
                                                        NetworkImage(
                                                            urlcnicback!),
                                                    backgroundColor:
                                                        Colors.transparent,
                                                  )
                                                : Text(')'),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Divider(color: Colors.grey[500]),
                                SizedBox(height: 5),
                                Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        "${data['fullName']}",
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.black),
                                      ),
                                      Text(
                                        "${data['category']}",
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                    ],
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
                                  leading: Icon(Icons.perm_identity_outlined,
                                      color: Colors.teal[500]),
                                  title: Text("${data['cnic']}"),
                                ),
                                Divider(color: Colors.grey[500]),
                                ListTile(
                                  leading: Icon(Icons.phone_android_outlined,
                                      color: Colors.teal[500]),
                                  title: Text("${data['phoneNumber']}"),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 3,
                                      blurRadius: 10,
                                      offset: Offset(2, 2),
                                    )
                                  ]),
                              child: MaterialButton(
                                onPressed: () async {
                                  update();
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              workerscategories()));
                                },
                                minWidth: double.infinity,
                                color: Colors.teal[500],
                                height: 50,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Text(
                                  "Verify Worker",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 3),
                                ),
                              ),
                            ),
                          ),
                          // const SizedBox(height: 10),
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(horizontal: 40),
                          //   child: MaterialButton(
                          //     minWidth: double.infinity,
                          //     height: 50,
                          //     onPressed: () {
                          //       ImageViewer.showImageSlider(
                          //         images: [
                          //           'https://cdn.eso.org/images/thumb300y/eso1907a.jpg',
                          //           'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__340.jpg',
                          //           'https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80',
                          //         ],
                          //         startingPosition: 1,
                          //       );
                          //     },
                          //     // defining the shape
                          //     shape: RoundedRectangleBorder(
                          //         side: BorderSide(color: Colors.teal),
                          //         borderRadius: BorderRadius.circular(50)),
                          //     child: Text(
                          //       "Images",
                          //       style: TextStyle(
                          //           color: Colors.black,
                          //           fontSize: 18,
                          //           fontWeight: FontWeight.w700,
                          //           letterSpacing: 3),
                          //     ),
                          //   ),
                          // ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
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
                                  delete();
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              workerscategories()));
                                },
                                minWidth: double.infinity,
                                color: Colors.red,
                                height: 50,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Text(
                                  "Reject",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 3),
                                ),
                              ),
                            ),
                          )
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
    // user = FirebaseAuth.instance.currentUser;
    var collection = FirebaseFirestore.instance.collection('employeesDetails');
    collection
        .doc(widget.documentId)
        .update({"verification": "Verified"}).then((value) => print('Success'));
  }

  Future delete() async {
    FirebaseFirestore.instance
        .collection('employeesDetails')
        .doc(widget.documentId)
        .delete();
  }

  Future readUser() async {
    var querySnapshot;
    try {
      querySnapshot = await FirebaseFirestore.instance
          .collection('employeesDetails')
          .doc(widget.documentId)
          .get();
      if (querySnapshot.isNotEmpty) {
        return querySnapshot;
      }
    } catch (e) {
      print(e);
    }
    return querySnapshot;
  }
}
