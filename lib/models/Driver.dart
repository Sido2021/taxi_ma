import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Driver{
  String full_name ;
  int gender ;
  String date_of_birth ;
  String phone_number ;
  String email;
  GeoPoint position ;

  Driver({this.full_name,this.gender,this.date_of_birth,this.phone_number,this.email,this.position});
  Driver.fromJson(Map<String, dynamic> json)
      : full_name = json['full_name'],
        gender = json['gender'],
        email = json['email'],
        phone_number = json['phone_number'],
        date_of_birth = json['date_of_birth'],
        position = json['position'];

  Map<String, dynamic> toJson() => {
    'full_name': full_name,
    'email': email,
    'phone_number' : phone_number,
    'gender' : gender,
    'date_of_birth' : date_of_birth,
    'position' : position
  };
}