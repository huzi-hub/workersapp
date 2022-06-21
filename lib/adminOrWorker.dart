// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:workersapp/Logo.dart';
import 'package:workersapp/adminDashboard.dart';

class AdminOrWorker extends StatefulWidget {
  const AdminOrWorker({Key? key}) : super(key: key);

  @override
  _AdminOrWorkerState createState() => _AdminOrWorkerState();
}

class _AdminOrWorkerState extends State<AdminOrWorker> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "assets/aamaadmi.png",
                  height: 400,
                  fit: BoxFit.cover,
                ),
                Column(
                  children: <Widget>[
                    // the login button
                    MaterialButton(
                      minWidth: double.infinity,
                      height: 60,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SplashScreen()));
                      },
                      // defining the shape
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.teal),
                          borderRadius: BorderRadius.circular(50)),
                      child: Text(
                        "Worker",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                    ),
                    // the signup button
                    SizedBox(height: 20),
                    Container(
                      child: MaterialButton(
                        minWidth: double.infinity,
                        height: 60,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdminDashboard()));
                        },

                        // defining the shape
                        color: Colors.teal[500],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                        child: Text(
                          "Admin",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 18),
                        ),
                      ),
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 10,
                          offset: Offset(2, 2),
                        ),
                      ]),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}




// class welcomepage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Container(
//           width: double.infinity,
//           height: MediaQuery.of(context).size.height,
//           padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               Column(
//                 children: <Widget>[
//                   Text(
//                     "Welcome",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 30,
//                     ),
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   Text(
//                     "All you need now on your finger tips! ",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: Colors.grey[700],
//                       fontSize: 15,
//                     ),
//                   )
//                 ],
//               ),
//               Image.asset(
//                 "assets/aamaadmi.png",
//                 height: 400,
//                 fit: BoxFit.cover,
//               ),
//               Column(
//                 children: <Widget>[
//                   // the login button
//                   MaterialButton(
//                     minWidth: double.infinity,
//                     height: 60,
//                     onPressed: () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => LoginScreen()));
//                     },
//                     // defining the shape
//                     shape: RoundedRectangleBorder(
//                         side: BorderSide(color: Colors.teal),
//                         borderRadius: BorderRadius.circular(50)),
//                     child: Text(
//                       "Login",
//                       style:
//                           TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
//                     ),
//                   ),
//                   // the signup button
//                   SizedBox(height: 20),
//                   Container(
//                     child: MaterialButton(
//                       minWidth: double.infinity,
//                       height: 60,
//                       onPressed: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => RegistrationScreen()));
//                       },

//                       // defining the shape
//                       color: Colors.teal[500],
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(50)),
//                       child: Text(
//                         "Sign up",
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.w600,
//                             fontSize: 18),
//                       ),
//                     ),
//                     decoration: BoxDecoration(boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.5),
//                         spreadRadius: 3,
//                         blurRadius: 10,
//                         offset: Offset(2, 2),
//                       ),
//                     ]),
//                   )
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
