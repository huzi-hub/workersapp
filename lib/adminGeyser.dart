// ignore_for_file: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:workersapp/adminUnverifiedWorkers.dart';
import 'package:workersapp/adminWorkerDetails.dart';
import 'package:workersapp/bottomnav.dart';

class Geyser extends StatefulWidget {
  const Geyser({Key? key}) : super(key: key);

  @override
  _GeyserState createState() => _GeyserState();
}

class _GeyserState extends State<Geyser> {
  var size, height, width;
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('employeesDetails')
      .where('category', isEqualTo: 'Geyser')
      .where('verification', isEqualTo: 'Not Verified')
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
        title: Text("Geyser"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.size == 0) {
            return Center(child: Text('Not verified workers list is empty'));
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  // height: 120,
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 5,
                        offset: const Offset(0, 5),
                        spreadRadius: 1)
                  ]),
                  child: InkWell(
                    child: ListTile(
                      leading: Image(
                        image: AssetImage('assets/electriciann1.jpg'),
                      ),
                      title: Text(data['fullName']),
                      subtitle: Text(data['phoneNumber']),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WorkerrDetails(
                                    documentId: document.id,
                                  )));
                    },
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
