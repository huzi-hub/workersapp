// ignore_for_file: file_names
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as Firebase_Storage;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workersapp/bottomnav.dart';
import 'package:workersapp/Dashboard.dart';
import 'package:workersapp/Login.dart';
import 'package:workersapp/workerModel.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // firebase_storage.FirebaseStorage storage =
  //     firebase_storage.FirebaseStorage.instance;

  // for password visible or not
  late bool _passwordVisible;
  @override
  void initState() {
    _passwordVisible = false;
  }
  // for password visible or not

  bool isLoading = false;
  File? dp = null;
  File? cnicFront = null;
  File? cnicBack = null;
  bool userLogin = false;

  String? dpurl = null;
  String? cfronturl = null;
  String? cbackurl = null;

  final _auth = FirebaseAuth.instance;

  signUp(emailtxt, passtxt, context) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(
        email: emailtxt,
        password: passtxt,
      )
          .then((value) {
        postDetailsToFirestore(emailtxt, passtxt);
      }).catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
      print("done");
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-email":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "wrong-password":
          errorMessage = "Your password is wrong.";
          break;
        case "user-not-found":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "user-disabled":
          errorMessage = "User with this email has been disabled.";
          break;
        case "too-many-requests":
          errorMessage = "Too many requests";
          break;
        case "operation-not-allowed":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
      Fluttertoast.showToast(msg: errorMessage!);
      print(e.code);
    }

    setState(() {
      userLogin = true;
    });
  }

  postDetailsToFirestore(emailtxt, passtxt) async {
    _auth.signInWithEmailAndPassword(email: emailtxt, password: passtxt);
    // calling our firestore
    // calling our worker model
    // sedning these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    WorkerModel workerModel = WorkerModel();

    // writing all the values
    workerModel.email = user!.email;
    workerModel.uid = user.uid;
    workerModel.experience = experienceEditingController.text;
    workerModel.fullName = fullNameEditingController.text;
    workerModel.phoneNumber = phoneNumberEditingController.text;
    workerModel.description = descriptionEditingController.text;
    workerModel.password = passwordEditingController.text;
    workerModel.cnic = cnicEditingController.text;
    workerModel.verification = 'Not Verified';
    workerModel.category = dropdownValue!;
    workerModel.rating = '0';
    workerModel.noOfRating = '0';

    // saving data to firebase
    await firebaseFirestore
        .collection("employeesDetails")
        .doc(user.uid)
        .set(workerModel.toMap());

    await firebaseFirestore
        .collection("workers")
        .doc(user.uid)
        .set(workerModel.toMap());
    Fluttertoast.showToast(msg: "Account created successfully");

    Navigator.pushAndRemoveUntil(
        (this.context),
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false);
  }

  Future logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future uploadFile(
      email, pass, File dp, File cfrnt, File cback, context) async {
    // logout();
    await signUp(email, pass, context);
    userLogin == true
        ? Firebase_Storage.FirebaseStorage.instance
            .ref()
            .child('userProfiles/$email/')
            .child("DP.jpg")
            .putFile(dp)
            .then((p0) async {
            await Firebase_Storage.FirebaseStorage.instance
                .ref()
                .child('userProfiles/$email/')
                .child("CNIC FRONT.jpg")
                .putFile(cfrnt)
                .then((p0) async {
              await Firebase_Storage.FirebaseStorage.instance
                  .ref()
                  .child('userProfiles/$email/')
                  .child("CNIC BACK.jpg")
                  .putFile(cback)
                  .then((p0) {
                Fluttertoast.showToast(msg: "CNIC BACK Upload Sucessfull");
              });
              Fluttertoast.showToast(msg: "CNIC FRONT Upload Sucessfull");
            });
            Fluttertoast.showToast(msg: "DP Upload Sucessfull");
          })
        : print("Working");
  }

  _getFromGallery({dpimg = false, cfrontimg = false, cbackimg = false}) async {
    // ignore: deprecated_member_use
    // gallery kholy ga or image pick kryfga
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        if (dpimg == true) {
          dp = File(pickedFile.path);
        } else if (cfrontimg == true) {
          cnicFront = File(pickedFile.path);
        } else {
          cnicBack = File(pickedFile.path);
        }
      });
    }
  }

  // string for displaying the error Message
  String? errorMessage;

  // string for dropdown menu
  String? dropdownValue = 'Electrician';

  // our form key
  // final _formKey = GlobalKey<FormState>();
  // editing Controller
  final fullNameEditingController = TextEditingController();
  final phoneNumberEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  final experienceEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final descriptionEditingController = TextEditingController();
  final cnicEditingController = TextEditingController();

  //password widget
  var clrpass = Colors.red;
  Widget passwordField() {
    return TextFormField(
      autofocus: false,
      controller: passwordEditingController,
      obscureText: !_passwordVisible,
      validator: (value) {
        // reg expression for password validation
        RegExp regex = RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Password is required for login");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid Password(Min. 6 Character)");
        }
      },
      onSaved: (value) {
        passwordEditingController.text = value!;
      },
      onChanged: (value) {
        RegExp regex = RegExp(r'^.{6,}$');
        if (value == "") {
          clrpass = Colors.red;
        } else if (value.length < 6) {
          print("Change kro");
          setState(() {
            clrpass = Colors.red;
          });
        } else {
          setState(() {
            print("Sahi hai pass");
            clrpass = Colors.teal;
          });
        }
      },
      // textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: clrpass),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: clrpass)),
        prefixIcon: Icon(Icons.vpn_key),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Password",
        suffixIcon: IconButton(
          icon: Icon(
            // Based on passwordVisible state choose the icon
            _passwordVisible ? Icons.visibility : Icons.visibility_off,
            color: Theme.of(this.context).primaryColor,
          ),
          onPressed: () {
            // Update the state i.e. toogle the state of passwordVisible variable
            setState(() {
              _passwordVisible = !_passwordVisible;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    //full name field
    final fullNameFiled = TextFormField(
        autofocus: false,
        controller: fullNameEditingController,
        keyboardType: TextInputType.name,
        onSaved: (value) {
          fullNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Full Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //phone number field
    final phoneNumberField = TextFormField(
        autofocus: false,
        controller: phoneNumberEditingController,
        keyboardType: TextInputType.number,
        onSaved: (value) {
          phoneNumberEditingController.text = value!;
        },
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(11)
        ],
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
          prefixIcon: Icon(Icons.phone),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "03331234567",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //email field
    final emailField = TextFormField(
        autofocus: false,
        controller: emailEditingController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Your Email");
          }
          // reg expression for email validation
          if (!RegExp(
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              .hasMatch(value)) {
            return ("Please Enter a valid email");
          }
          return null;
        },
        onSaved: (value) {
          emailEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    // experience Field
    final experienceField = TextFormField(
        autofocus: false,
        controller: experienceEditingController,
        keyboardType: TextInputType.number,
        onSaved: (value) {
          experienceEditingController.text = value!;
        },
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(2),
        ],
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
          prefixIcon: Icon(Icons.explore),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Experience e.g: 2 years",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    // description Field
    final descriptionField = TextFormField(
        autofocus: false,
        controller: descriptionEditingController,
        keyboardType: TextInputType.name,
        onSaved: (value) {
          descriptionEditingController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
          prefixIcon: Icon(Icons.description),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Describe your experience",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    // cnic Field
    final cnicfield = TextFormField(
        autofocus: false,
        controller: cnicEditingController,
        keyboardType: TextInputType.number,
        onSaved: (value) {
          cnicEditingController.text = value!;
        },
        inputFormatters: [LengthLimitingTextInputFormatter(13)],
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
          prefixIcon: Icon(Icons.info_outline_rounded),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "CNIC (4444433333332)",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //signup button
    final signUpButton = Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(10), boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 3,
          blurRadius: 10,
          offset: Offset(2, 2),
        )
      ]),
      child: MaterialButton(
        onPressed: () {
          // isko call krwaya isliye hai q k neechy jo ismai code hua wa hai wo firebase mai save wala hai
          if (fullNameEditingController.text.isEmpty &&
              phoneNumberEditingController.text.isEmpty &&
              experienceEditingController.text.isEmpty &&
              descriptionEditingController.text.isEmpty &&
              cnicEditingController.text.isEmpty &&
              dp == null &&
              cnicFront == null &&
              cnicBack == null) {
            Fluttertoast.showToast(msg: "All fields are empty");
          } else if (fullNameEditingController.text.isEmpty) {
            Fluttertoast.showToast(msg: "Full name is empty");
          } else if (phoneNumberEditingController.text.isEmpty) {
            Fluttertoast.showToast(msg: "Phone number is empty");
          } else if (phoneNumberEditingController.text.length < 11) {
            Fluttertoast.showToast(msg: "Phone number is invalid");
          } else if (experienceEditingController.text.isEmpty) {
            Fluttertoast.showToast(msg: "Experience is empty");
          }
          // else if (experienceEditingController.text ) {
          //   Fluttertoast.showToast(msg: "");
          else if (descriptionEditingController.text.isEmpty) {
            Fluttertoast.showToast(msg: "Description is empty");
          } else if (cnicEditingController.text.isEmpty) {
            Fluttertoast.showToast(msg: "CNIC is empty");
          } else if (cnicEditingController.text.length < 13) {
            Fluttertoast.showToast(msg: "CNIC is invalid");
          } else if (dp == null) {
            Fluttertoast.showToast(msg: "Profile image is empty");
          } else if (cnicFront == null) {
            Fluttertoast.showToast(msg: "CNIC front image is empty");
          } else if (cnicBack == null) {
            Fluttertoast.showToast(msg: "CNIC back image is empty");
          } else {
            uploadFile(
                emailEditingController.text,
                passwordEditingController.text,
                dp!,
                cnicFront!,
                cnicBack!,
                context);
          }
        },
        minWidth: double.infinity,
        color: Colors.teal[500],
        height: 50,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          "SignUp",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Icon(
          Icons.arrow_back,
          color: Colors.teal[500],
        ),
        title: Center(child: Text('Signup')),
        actions: [
          Icon(Icons.arrow_back_ios_new_sharp, color: Colors.teal[500]),
          Icon(Icons.arrow_back_ios_new_sharp, color: Colors.teal[500]),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          width: double.infinity,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                height: 200,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/aamaadmi.png"),
                      fit: BoxFit.fitHeight),
                ),
              ),
              const Text(
                "Create an Account",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              fullNameFiled,
              SizedBox(
                height: height * 0.02,
              ),
              phoneNumberField,
              SizedBox(
                height: height * 0.02,
              ),
              emailField,
              SizedBox(
                height: height * 0.02,
              ),
              // Categories DropDownValue
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          left: BorderSide(color: Colors.teal),
                          right: BorderSide(color: Colors.teal),
                          top: BorderSide(color: Colors.teal),
                          bottom: BorderSide(color: Colors.teal))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      // isDense reduce the button height
                      isDense: true,
                      icon:
                          const Icon(Icons.arrow_downward, color: Colors.teal),
                      elevation: 16,
                      alignment: AlignmentDirectional.center,
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                      },
                      dropdownColor: Colors.white,
                      items: <String>[
                        'Electrician',
                        'Plumber',
                        'Painter',
                        'Builder',
                        'Carpenter',
                        'Ac Repair',
                        'Geyser',
                        'Washing Machine Repair',
                        'Stove Repair',
                        'Generator'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              experienceField,
              SizedBox(
                height: height * 0.02,
              ),
              passwordField(),
              SizedBox(
                height: height * 0.02,
              ),
              cnicfield,
              SizedBox(
                height: height * 0.02,
              ),
              descriptionField,
              SizedBox(
                height: height * 0.02,
              ),
              Row(
                children: [
                  Text(
                    "Profile Picture: ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  dp == null
                      ? IconButton(
                          onPressed: () {
                            _getFromGallery(dpimg: true);
                          },
                          icon: Icon(Icons.add_a_photo_outlined))
                      : Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  _getFromGallery(dpimg: true);
                                },
                                icon: Icon(Icons.restore)),
                            Container(
                              color: Colors.teal,
                              width: 50,
                              height: 50,
                              child: Image.file(
                                dp!,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ],
                        ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "CNIC Front:       ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  cnicFront == null
                      ? IconButton(
                          onPressed: () {
                            _getFromGallery(cfrontimg: true);
                          },
                          icon: Icon(Icons.add_a_photo_outlined))
                      : Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  _getFromGallery(cfrontimg: true);
                                },
                                icon: Icon(Icons.restore)),
                            Container(
                              color: Colors.teal,
                              width: 50,
                              height: 50,
                              child: Image.file(
                                cnicFront!,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ],
                        ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "CNIC Back:       ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  cnicBack == null
                      ? IconButton(
                          onPressed: () {
                            _getFromGallery(cbackimg: true);
                          },
                          icon: Icon(Icons.add_a_photo_outlined))
                      : Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  _getFromGallery(cbackimg: true);
                                },
                                icon: Icon(Icons.restore)),
                            Container(
                              color: Colors.teal,
                              width: 50,
                              height: 50,
                              child: Image.file(
                                cnicBack!,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ],
                        ),
                ],
              ),
              SizedBox(
                height: height * 0.02,
              ),
              signUpButton,
              SizedBox(
                height: height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Already have an account?"),
                  InkWell(
                    child: Text(
                      " Login",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                  )
                ],
              ),
              SizedBox(
                height: height * 0.02,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
