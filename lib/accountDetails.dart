// ignore_for_file: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:workersapp/Dashboard.dart';
import 'package:workersapp/orders.dart';

class Accountdetails extends StatefulWidget {
  final String documentId;
  Accountdetails({Key? key, required this.documentId}) : super(key: key);

  @override
  State<Accountdetails> createState() => _AccountdetailsState();
}

class _AccountdetailsState extends State<Accountdetails> {
  var size, height, width;
  final TextEditingController updateEditingController =
      new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final updateNameField = TextFormField(
        autofocus: false,
        controller: updateEditingController,
        keyboardType: TextInputType.name,
        onSaved: (value) {
          updateEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Update your name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    CollectionReference users =
        FirebaseFirestore.instance.collection('employeesDetails');
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
          title: Text("Account Details"),
        ),
        body: FutureBuilder<DocumentSnapshot>(
          future: users.doc(widget.documentId).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.hasData && !snapshot.data!.exists) {
              return Text("Document does not exist");
            }

            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              return Container(
                child: Card(
                  child: Column(
                    children: [
                      SizedBox(height: height * 0.001),
                      ListTile(
                        title: Text("Name"),
                        subtitle: Text("${data['fullName']}"),
                        trailing: InkWell(
                          child: Icon(
                            Icons.edit_outlined,
                            color: Colors.teal[500],
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: Text("Update Name"),
                                content: updateNameField,
                                actions: <Widget>[
                                  MaterialButton(
                                    onPressed: () {
                                      if (updateEditingController
                                          .text.isEmpty) {
                                        Navigator.pushAndRemoveUntil(
                                            (this.context),
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Accountdetails(
                                                      documentId: FirebaseAuth
                                                          .instance
                                                          .currentUser!
                                                          .uid,
                                                    )),
                                            (route) => false);
                                      } else if (updateEditingController
                                          .text.isNotEmpty) {
                                        update(updateEditingController.text);
                                        Fluttertoast.showToast(
                                            msg: 'Name updated successfully');
                                        Navigator.of(ctx).pop();
                                      }
                                    },
                                    child: Text("Ok"),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Divider(color: Colors.grey[500]),
                      ),
                      ListTile(
                        title: Text("Phone Number"),
                        subtitle: Text("${data['phoneNumber']}"),
                        onTap: () {},
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Divider(color: Colors.grey[500]),
                      ),
                      ListTile(
                        title: Text("Email"),
                        subtitle: Text("${data['email']}"),
                        onTap: () {},
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Divider(color: Colors.grey[500]),
                      ),
                      ListTile(
                        title: Text("Password"),
                        subtitle: Text("******"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Divider(color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(70),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 35,
                        blurRadius: 10,
                        offset: Offset(4, 4),
                      ),
                    ]),
              );
            }

            return Center(child: CircularProgressIndicator());
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white,
            // fixedColor: Colors.teal,
            currentIndex: 2,
            selectedItemColor: Colors.teal,
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

  Future update(updatename) async {
    FirebaseFirestore.instance
        .collection('employeesDetails')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'fullName': updatename}).then((value) => print('success'));
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
  } else {}
}
