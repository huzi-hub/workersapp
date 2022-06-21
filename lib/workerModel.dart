// ignore_for_file: file_names
// Pehla email pass wala kam hai yh
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WorkerModel {
  String? uid;
  String? email;
  String? experience;
  String? fullName;
  String? phoneNumber;
  String? description;
  String? password;
  String? cnic;
  String? verification;
  String? category;
  String? rating;
  String? noOfRating;

  WorkerModel({
    this.uid,
    this.email,
    this.experience,
    this.fullName,
    this.phoneNumber,
    this.description,
    this.password,
    this.cnic,
    this.verification,
    this.category,
    this.rating,
    this.noOfRating,
  });

  // receiving data from server
  factory WorkerModel.fromMap(map) {
    return WorkerModel(
      uid: map['uid'],
      email: map['email'],
      experience: map['experience'],
      fullName: map['fullName'],
      phoneNumber: map['phoneNumber'],
      description: map['description'],
      password: map['password'],
      cnic: map['cnic'],
      verification: map['verification'],
      category: map['category'],
      rating: map['rating'],
      noOfRating: map['noOfRating'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'experience': experience,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'description': description,
      'password': password,
      'cnic': cnic,
      'verification': verification,
      'category': category,
      'rating': rating,
      'noOfRating': noOfRating,
    };
  }
}
