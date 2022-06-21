// // ignore_for_file: file_names
// // import 'dart:html';
// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:workersapp/bottomnav.dart';
// import 'package:workersapp/Dashboard.dart';
// import 'package:workersapp/Login.dart';
// import 'package:workersapp/workerModel.dart';

// class RegistrationScreen extends StatefulWidget {
//   const RegistrationScreen({Key? key}) : super(key: key);

//   @override
//   _RegistrationScreenState createState() => _RegistrationScreenState();
// }

// class _RegistrationScreenState extends State<RegistrationScreen> {
//   firebase_storage.FirebaseStorage storage =
//       firebase_storage.FirebaseStorage.instance;

//   File? _photo;
//   final ImagePicker _picker = ImagePicker();

//   Future imgFromGallery() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

//     setState(() {
//       if (pickedFile != null) {
//         _photo = File(pickedFile.path);
//         uploadFile();
//       } else {
//         print('No image selected.');
//       }
//     });
//   }

//   Future imgFromCamera() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.camera);

//     setState(() {
//       if (pickedFile != null) {
//         _photo = File(pickedFile.path);
//         uploadFile();
//       } else {
//         print('No image selected.');
//       }
//     });
//   }

//   Future uploadFile() async {
//     if (_photo == null) return;
//     final fileName = basename(_photo!.path);
//     final destination = 'files/$fileName';

//     try {
//       final ref = firebase_storage.FirebaseStorage.instance
//           .ref(destination)
//           .child('file/');
//       await ref.putFile(_photo!);
//     } catch (e) {
//       print('error occured');
//     }
//   }

//   final _auth = FirebaseAuth.instance;

//   // string for displaying the error Message
//   String? errorMessage;

//   // string for dropdown menu
//   String? dropdownValue = 'Electrician';
//   // for profile picture
//   // var results;

//   // our form key
//   final _formKey = GlobalKey<FormState>();
//   // editing Controller
//   final fullNameEditingController = new TextEditingController();
//   final phoneNumberEditingController = new TextEditingController();
//   final emailEditingController = new TextEditingController();
//   final experienceEditingController = new TextEditingController();
//   final passwordEditingController = new TextEditingController();
//   final confirmPasswordEditingController = new TextEditingController();
//   final descriptionEditingController = new TextEditingController();
//   final cnicEditingController = new TextEditingController();

//   //password widget
//   var clrpass = Colors.red;
//   Widget passwordField() {
//     return TextFormField(
//         autofocus: false,
//         controller: passwordEditingController,
//         obscureText: true,
//         validator: (value) {
//           // reg expression for password validation
//           RegExp regex = new RegExp(r'^.{6,}$');
//           if (value!.isEmpty) {
//             return ("Password is required for login");
//           }
//           if (!regex.hasMatch(value)) {
//             return ("Enter Valid Password(Min. 6 Character)");
//           }
//         },
//         onSaved: (value) {
//           fullNameEditingController.text = value!;
//         },
//         onChanged: (value) {
//           RegExp regex = new RegExp(r'^.{6,}$');
//           if (value == "") {
//             clrpass = Colors.red;
//           } else if (value.length < 6) {
//             print("Change kro");
//             setState(() {
//               clrpass = Colors.red;
//             });
//           } else {
//             setState(() {
//               print("Sahi hai pass");
//               clrpass = Colors.teal;
//             });
//           }
//         },
//         // textInputAction: TextInputAction.next,
//         decoration: InputDecoration(
//           focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: clrpass),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           enabledBorder:
//               OutlineInputBorder(borderSide: BorderSide(color: clrpass)),
//           prefixIcon: Icon(Icons.vpn_key),
//           contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
//           hintText: "Password",
//         ));
//   }

//   @override
//   Widget build(BuildContext context) {
//     //full name field
//     final fullNameFiled = TextFormField(
//         autofocus: false,
//         controller: fullNameEditingController,
//         keyboardType: TextInputType.name,
//         onSaved: (value) {
//           fullNameEditingController.text = value!;
//         },
//         textInputAction: TextInputAction.next,
//         decoration: InputDecoration(
//           enabledBorder:
//               OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
//           prefixIcon: Icon(Icons.account_circle),
//           contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
//           hintText: "Full Name",
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//         ));

//     //phone number field
//     final phoneNumberField = TextFormField(
//         autofocus: false,
//         controller: phoneNumberEditingController,
//         keyboardType: TextInputType.number,
//         onSaved: (value) {
//           phoneNumberEditingController.text = value!;
//         },
//         textInputAction: TextInputAction.next,
//         decoration: InputDecoration(
//           enabledBorder:
//               OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
//           prefixIcon: Icon(Icons.phone),
//           contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
//           hintText: "03331234567",
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//         ));

//     //email field
//     final emailField = TextFormField(
//         autofocus: false,
//         controller: emailEditingController,
//         keyboardType: TextInputType.emailAddress,
//         validator: (value) {
//           if (value!.isEmpty) {
//             return ("Please Enter Your Email");
//           }
//           // reg expression for email validation
//           if (!RegExp(
//                   r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
//               .hasMatch(value)) {
//             return ("Please Enter a valid email");
//           }
//           return null;
//         },
//         onSaved: (value) {
//           emailEditingController.text = value!;
//         },
//         textInputAction: TextInputAction.next,
//         decoration: InputDecoration(
//           enabledBorder:
//               OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
//           prefixIcon: Icon(Icons.mail),
//           contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
//           hintText: "Email",
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//         ));

//     // experience Field
//     final experienceField = TextFormField(
//         autofocus: false,
//         controller: experienceEditingController,
//         keyboardType: TextInputType.number,
//         onSaved: (value) {
//           experienceEditingController.text = value!;
//         },
//         inputFormatters: [
//           FilteringTextInputFormatter.digitsOnly,
//         ],
//         textInputAction: TextInputAction.next,
//         decoration: InputDecoration(
//           enabledBorder:
//               OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
//           prefixIcon: Icon(Icons.explore),
//           contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
//           hintText: "Experience e.g: 2 years",
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//         ));

//     // description Field
//     final descriptionField = TextFormField(
//         autofocus: false,
//         controller: descriptionEditingController,
//         keyboardType: TextInputType.name,
//         onSaved: (value) {
//           descriptionEditingController.text = value!;
//         },
//         textInputAction: TextInputAction.done,
//         decoration: InputDecoration(
//           enabledBorder:
//               OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
//           prefixIcon: Icon(Icons.description),
//           contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
//           hintText: "Describe your experience",
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//         ));

//     // cnic Field
//     final cnicfield = TextFormField(
//         autofocus: false,
//         controller: cnicEditingController,
//         keyboardType: TextInputType.number,
//         onSaved: (value) {
//           descriptionEditingController.text = value!;
//         },
//         textInputAction: TextInputAction.done,
//         decoration: InputDecoration(
//           enabledBorder:
//               OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
//           prefixIcon: Icon(Icons.info_outline_rounded),
//           contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
//           hintText: "Enter CNIC number",
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//         ));

//     //signup button
//     final signUpButton = Container(
//       decoration:
//           BoxDecoration(borderRadius: BorderRadius.circular(50), boxShadow: [
//         BoxShadow(
//           color: Colors.grey.withOpacity(0.5),
//           spreadRadius: 3,
//           blurRadius: 10,
//           offset: Offset(2, 2),
//         )
//       ]),
//       child: MaterialButton(
//         onPressed: () {
//           // isko call krwaya isliye hai q k neechy jo ismai code hua wa hai wo firebase mai save wala hai
//           if (fullNameEditingController.text != '' &&
//               phoneNumberEditingController.text != '' &&
//               experienceEditingController.text != '' &&
//               descriptionEditingController.text != '' &&
//               _photo != null) {
//             signUp();
//           } else {
//             Fluttertoast.showToast(msg: "Information is not completed");
//           }
//         },
//         minWidth: double.infinity,
//         color: Colors.teal[500],
//         height: 60,
//         elevation: 0,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(50),
//         ),
//         child: Text(
//           "SignUp",
//           style: TextStyle(
//               color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
//         ),
//       ),
//     );

//     // final profilePictureButton = MaterialButton(
//     //     onPressed: () async {
//     //       results = await FilePicker.platform.pickFiles(
//     //         // single file allow krta hai wese be default single he allow krrha hai
//     //         allowMultiple: false,
//     //         // custom extension lagane k liye filetype btana prta hai
//     //         type: FileType.custom,
//     //         // validations laga di hain yh srf isi extensions ko uplaod krwayega
//     //         allowedExtensions: ['pdf', 'jpeg', 'png', 'jpg'],
//     //       );
//     //       setState(() {
//     //         results = results;
//     //       });
//     //       if (results == null) {
//     //         ScaffoldMessenger.of(context).showSnackBar(
//     //           SnackBar(
//     //             content: Text("No Files Selected"),
//     //           ),
//     //         );
//     //       } else {
//     //         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//     //           content: Text("File Added"),
//     //         ));
//     //       }
//     //       final path = results.files.single.path;
//     //       final file = results.files.single.name;
//     //       storage.uploadFile(path, file);
//     //     },
//     //     minWidth: double.infinity,
//     //     color: Colors.white,
//     //     height: 60,
//     //     elevation: 0,
//     //     shape: RoundedRectangleBorder(
//     //       side: BorderSide(color: Colors.teal),
//     //       borderRadius: BorderRadius.circular(50),
//     //     ),
//     //     child: Text(
//     //       "Add Profile Photo",
//     //       style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//     //     ));
//     // if (results != null)
//     //   // ignore: curly_braces_in_flow_control_structures
//     //   Image.file(
//     //     File(results.files.single.path),
//     //   );

//     // Jawan Tech wali class
//     // final profilePictureButton = MaterialButton(
//     //     onPressed: () async {
//     //       final results = await FilePicker.platform.pickFiles(
//     //         allowMultiple: false,
//     //         type: FileType.custom,
//     //         allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
//     //       );
//     //       if (results == null) {
//     //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//     //           // backgroundColor: Colors.white70,
//     //           content: Text(
//     //             'No File Selected',
//     //             style: TextStyle(color: Colors.white),
//     //           ),
//     //           duration: Duration(seconds: 2),
//     //         ));

//     //         return null;
//     //       }
//     //       final pathname = results.files.single.path;
//     //       // File Name
//     //       // final filename = textcontroller.text.trim();
//     //       final filename = results.files.single.name;
//     //       storage.uploadFile(pathname, filename).then((value) => print("Done"));
//     //     },
//     //     child: const Text("Upload File"));
//     // Jawan Tech Wali class

//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       backgroundColor: Colors.white,
//       appBar: appbarpop(context, "Signup"),
//       body: SingleChildScrollView(
//         child: Container(
//           padding: EdgeInsets.symmetric(horizontal: 40),
//           height: MediaQuery.of(context).size.height - 120,
//           width: double.infinity,
//           color: Colors.white,
//           child: Form(
//             key: _formKey,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: <Widget>[
//                 fullNameFiled,
//                 phoneNumberField,
//                 emailField,
//                 // Categories DropDownValue
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 40),
//                   child: Container(
//                     decoration: BoxDecoration(
//                         border: Border(
//                             left: BorderSide(color: Colors.teal),
//                             right: BorderSide(color: Colors.teal),
//                             top: BorderSide(color: Colors.teal),
//                             bottom: BorderSide(color: Colors.teal))),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 10, vertical: 9),
//                       child: DropdownButton<String>(
//                         value: dropdownValue,
//                         // isDense reduce the button height
//                         isDense: true,
//                         icon: const Icon(Icons.arrow_downward,
//                             color: Colors.teal),
//                         elevation: 16,
//                         alignment: AlignmentDirectional.center,
//                         onChanged: (String? newValue) {
//                           setState(() {
//                             dropdownValue = newValue!;
//                           });
//                         },
//                         dropdownColor: Colors.white,
//                         items: <String>[
//                           'Electrician',
//                           'Plumber',
//                           'Painter',
//                           'Builder',
//                           'Carpenter',
//                           'Ac Repair',
//                           'Geyser',
//                           'Washing Machine Repair',
//                           'Stove Repair',
//                           'Carpenter1'
//                         ].map<DropdownMenuItem<String>>((String value) {
//                           return DropdownMenuItem<String>(
//                             value: value,
//                             child: Text(value),
//                           );
//                         }).toList(),
//                       ),
//                     ),
//                   ),
//                 ),
//                 experienceField,
//                 passwordField(),
//                 descriptionField,
//                 cnicfield,
//                 GestureDetector(
//                   onTap: () {
//                     _showPicker(context);
//                   },
//                   child: Column(
//                     children: [
//                       Text("Upload Image Of Your CNIC"),
//                       SizedBox(
//                         height: 15,
//                       ),
//                       CircleAvatar(
//                         radius: 28,
//                         backgroundColor: Colors.teal,
//                         child: _photo != null
//                             ? ClipRRect(
//                                 borderRadius: BorderRadius.circular(50),
//                                 child: Image.file(
//                                   _photo!,
//                                   width: 50,
//                                   height: 50,
//                                   fit: BoxFit.fitHeight,
//                                 ),
//                               )
//                             : Container(
//                                 decoration: BoxDecoration(
//                                     color: Colors.grey[200],
//                                     borderRadius: BorderRadius.circular(50)),
//                                 width: 50,
//                                 height: 50,
//                                 child: Icon(
//                                   Icons.camera_alt,
//                                   color: Colors.grey[800],
//                                 ),
//                               ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 // Jawan Tech Wali class Wala code Try krna hai yhan profile picture k liye
//                 // TextField(
//                 //   controller: textcontroller,
//                 // ),
//                 // profilePictureButton,
//                 signUpButton,
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     Text("Already have an account?"),
//                     InkWell(
//                       child: Text(
//                         " Login",
//                         style: TextStyle(
//                             fontWeight: FontWeight.w600, fontSize: 18),
//                       ),
//                       onTap: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => LoginScreen()));
//                       },
//                     )
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void _showPicker(context) {
//     showModalBottomSheet(
//         context: context,
//         builder: (BuildContext bc) {
//           return SafeArea(
//             child: Container(
//               child: new Wrap(
//                 children: <Widget>[
//                   new ListTile(
//                       leading: new Icon(Icons.photo_library),
//                       title: new Text('Gallery'),
//                       onTap: () {
//                         imgFromGallery();
//                         Navigator.of(context).pop();
//                       }),
//                   new ListTile(
//                     leading: new Icon(Icons.photo_camera),
//                     title: new Text('Camera'),
//                     onTap: () {
//                       imgFromCamera();
//                       Navigator.of(context).pop();
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           );
//         });
//   }

//   Future signUp() async {
//     try {
//       await _auth
//           .createUserWithEmailAndPassword(
//             email: emailEditingController.text,
//             password: passwordEditingController.text,
//           )
//           .then((value) => postDetailsToFirestore())
//           .catchError((e) {
//         Fluttertoast.showToast(msg: e!.message);
//       });
//       print("done");
//     } on FirebaseAuthException catch (e) {
//       switch (e.code) {
//         case "invalid-email":
//           errorMessage = "Your email address appears to be malformed.";
//           break;
//         case "wrong-password":
//           errorMessage = "Your password is wrong.";
//           break;
//         case "user-not-found":
//           errorMessage = "User with this email doesn't exist.";
//           break;
//         case "user-disabled":
//           errorMessage = "User with this email has been disabled.";
//           break;
//         case "too-many-requests":
//           errorMessage = "Too many requests";
//           break;
//         case "operation-not-allowed":
//           errorMessage = "Signing in with Email and Password is not enabled.";
//           break;
//         default:
//           errorMessage = "An undefined Error happened.";
//       }
//       Fluttertoast.showToast(msg: errorMessage!);
//       print(e.code);
//     }
//   }

//   // void signUp(String email, String password) async {
//   //   if (_formKey.currentState!.validate()) {
//   //     try {
//   //       await _auth
//   //           .createUserWithEmailAndPassword(email: email, password: password)
//   //           .then((value) => {postDetailsToFirestore()})
//   //           .catchError((e) {
//   //         Fluttertoast.showToast(msg: e!.message);
//   //       });
//   //     } on FirebaseAuthException catch (error) {
//   //       switch (error.code) {
//   //         case "invalid-email":
//   //           errorMessage = "Your email address appears to be malformed.";
//   //           break;
//   //         case "wrong-password":
//   //           errorMessage = "Your password is wrong.";
//   //           break;
//   //         case "user-not-found":
//   //           errorMessage = "User with this email doesn't exist.";
//   //           break;
//   //         case "user-disabled":
//   //           errorMessage = "User with this email has been disabled.";
//   //           break;
//   //         case "too-many-requests":
//   //           errorMessage = "Too many requests";
//   //           break;
//   //         case "operation-not-allowed":
//   //           errorMessage = "Signing in with Email and Password is not enabled.";
//   //           break;
//   //         default:
//   //           errorMessage = "An undefined Error happened.";
//   //       }
//   //       Fluttertoast.showToast(msg: errorMessage!);
//   //       print(error.code);
//   //     }
//   //   }
//   // }

//   postDetailsToFirestore() async {
//     await _auth.signInWithEmailAndPassword(
//         email: emailEditingController.text,
//         password: passwordEditingController.text);
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString("email", emailEditingController.text);
//     prefs.setString("pass", passwordEditingController.text);
//     // calling our firestore
//     // calling our worker model
//     // sedning these values

//     FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
//     User? user = _auth.currentUser;

//     WorkerModel workerModel = WorkerModel();

//     // writing all the values
//     workerModel.email = user!.email;
//     workerModel.uid = user.uid;
//     workerModel.experience = experienceEditingController.text;
//     workerModel.fullName = fullNameEditingController.text;
//     workerModel.phoneNumber = phoneNumberEditingController.text;
//     workerModel.description = descriptionEditingController.text;
//     workerModel.password = passwordEditingController.text;
//     workerModel.cnic = cnicEditingController.text;

//     // saving data to firebase
//     await firebaseFirestore
//         .collection(dropdownValue!)
//         .doc(user.uid)
//         .set(workerModel.toMap());
//     Fluttertoast.showToast(msg: "Account created successfully :) ");

//     await firebaseFirestore
//         .collection("workers")
//         .doc(user.uid)
//         .set(workerModel.toMap());
//     Fluttertoast.showToast(msg: "Account created successfully :) ");

//     await firebaseFirestore
//         .collection("unverified workers")
//         .doc(user.uid)
//         .set(workerModel.toMap());
//     Fluttertoast.showToast(msg: "Account created successfully :) ");

//     Navigator.pushAndRemoveUntil((this.context),
//         MaterialPageRoute(builder: (context) => Dashboard()), (route) => false);
//   }
// }

// //confirm password widget
// // var clrCpass = Colors.red;
// // Widget confirmPasswordField() {
// //   return TextFormField(
// //       autofocus: false,
// //       controller: confirmPasswordEditingController,
// //       obscureText: true,
// //       validator: (value) {
// //         if (passwordEditingController.text != value) {
// //           return errorMessage = "Wrong Password";
// //         }
// //         if (passwordEditingController.text == value) {
// //           return errorMessage = "Same";
// //         }
// //       },
// //       onSaved: (value) {
// //         confirmPasswordEditingController.text = value!;
// //       },
// //       onChanged: (value) {
// //         if (value == passwordEditingController.text) {
// //           setState(() {
// //             clrCpass = Colors.teal;
// //           });
// //         }
// //       },
// //       textInputAction: TextInputAction.next,
// //       decoration: InputDecoration(
// //         enabledBorder:
// //             OutlineInputBorder(borderSide: BorderSide(color: clrCpass)),
// //         prefixIcon: Icon(Icons.vpn_key),
// //         contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
// //         hintText: "Confirm Password",
// //         focusedBorder: OutlineInputBorder(
// //           borderSide: BorderSide(color: clrCpass),
// //           borderRadius: BorderRadius.circular(10),
// //         ),
// //       ));
// // }


// // validator: (val) =>
//     //     val!.isEmpty || val.length != 11 ? 'Enter Valid Contact No' : null,
//     // validator: (value) {

//     // },

//     // ignore: prefer_function_declarations_over_variables
//   // String? Function(String?)? phoneNumberValidator = (String? value) {
//   //   if (value!.length != 11) {
//   //     return 'Please Enter Complete Phone Number';
//   //   } else if (value.isEmpty) {
//   //     return "Phone Number Can't be Empty";
//   //   }
//   // };
  
//         // validator: (value) {
//         //   // reg expression for phone number validation
//         //   // RegExp regex = new RegExp(r'(^(?:[+0]9)?[0-9]{11}$)');
//         //   // RegExp regex = RegExp('^((\+92)|(0092))-{0,1}\d{3}-{0,1}\d{7}$|^\d{11}$|^\d{4}-\d{7}$');
//         //   RegExp regex = new RegExp(r'^[0-9]{11}$');
//         //   if (value!.isEmpty) {
//         //     return ("Phone Number cannot be Empty");
//         //   }
//         //   if (!regex.hasMatch(value)) {
//         //     return ("Enter Valid Phone Number");
//         //   }
//         //   return null;
//         // },
//         // validator: (value) => value!.isNotEmpty || value.length != 11
//         //     ? 'Enter Valid Contact No'
//         //     : null,
//         // validator: (value) {

//         // },
//         // validator: (value) {
//         //   if (value!.length != 11) {
//         //     return 'Please Enter Complete Phone Number';
//         //   } else if (value.isEmpty) {
//         //     return "Phone Number Can't be Empty";
//         //   } else {
//         //     return null;
//         //   }
//         // },
//         // validator: phoneNumberValidator,


  
//         // validator: (value) {
//         //   if (value!.isNotEmpty) {
//         //     return ("Please Enter Your Name");
//         //   }
//         //   if (RegExp(r'^.{3,}$').hasMatch(value)) {
//         //     return null;
//         //   } else {
//         //     return ("Please enter valid name");
//         //   }
//         // },
        
//         // validator: (value) {
//         //   RegExp regex = RegExp(r'^.{3,}$');
//         //   if (value!.isEmpty) {
//         //     return ("First Name cannot be Empty");
//         //   }
//         //   if (!regex.hasMatch(value)) {
//         //     return ("Enter Valid name(Min. 3 Character)");
//         //   }
//         //   return null;
//         // },