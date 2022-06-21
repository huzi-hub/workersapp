// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:workersapp/adminACRepair.dart';
import 'package:workersapp/adminBuilder.dart';
import 'package:workersapp/adminCarpenter.dart';
import 'package:workersapp/adminDashboard.dart';
import 'package:workersapp/adminElectrcians.dart';
import 'package:workersapp/adminGeneratorRepair.dart';
import 'package:workersapp/adminGeyser.dart';
import 'package:workersapp/adminPainter.dart';
import 'package:workersapp/adminPlumber.dart';
import 'package:workersapp/adminStoveRepair.dart';
import 'package:workersapp/adminWashMech.dart';
import 'package:workersapp/bottomnav.dart';

class workerscategories extends StatelessWidget {
  workerscategories({Key? key}) : super(key: key);

  var size, height, width;

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
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AdminDashboard()));
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.white,
          ),
        ),
        title: Text("Services"),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: height,
          width: width,
          child: Column(
            children: [
              SizedBox(
                height: height * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  workersBTN(context, "assets/electriciann1.jpg",
                      "Electricians", Electricians()),
                  workersBTN(
                      context, "assets/plumberr1.jpg", "Plumbers", Plumbers()),
                ],
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  workersBTN(
                      context, "assets/painter1.jpg", "Painters", Painters()),
                  workersBTN(
                      context, "assets/builder1.jpg", "Builders", Builders()),
                ],
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  workersBTN(context, "assets/carpenter.jpg", "Carpenters",
                      Carpenters()),
                  workersBTN(context, "assets/airconditiono.jpg", "AC Repair",
                      Ac_Repair()),
                ],
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  workersBTN(context, "assets/geysero.jpg", "Geyser", Geyser()),
                  workersBTN(context, "assets/washingmachine.jpg", "Wash-Mech",
                      Washing_Machine()),
                ],
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  workersBTN(context, "assets/stove.png", "Stove Repair",
                      Stove_Repair()),
                  workersBTN(context, "assets/electriciann1.jpg", "Generator",
                      GeneratorRepair()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container workersBTN(BuildContext context, img, txt, page) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 5,
              offset: const Offset(0, 5),
              spreadRadius: 1)
        ],
      ),
      child: ElevatedButton(
        child: Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
          child: Column(
            children: [
              Image.asset(img, height: 90, width: 90),
              Text(txt, style: TextStyle(color: Colors.teal[500])),
            ],
          ),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
        ),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => page));
        },
      ),
    );
  }
}
