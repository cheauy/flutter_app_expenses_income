import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phoneNumber;
  final String? imageUrl;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.imageUrl,
  });

  // Convert a UserModel into a Map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'image_url': imageUrl,
    };
  }

  // Create a UserModel from a Map
  // factory UserModel.fromFirestore(Map<String, dynamic> map, String uid) {
  //   return UserModel(
  //     uid: uid ,
  //     name: map['name'] ?? "",
  //     email: map['email']?? "",
  //     phoneNumber: map['phoneNumber']?? "",
  //     imageUrl: map['image_url']??"",
  //   );
  // }
  factory UserModel.fromFirestore(DocumentSnapshot<Object?> doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id ,
      name: map['name'] ?? "",
      email: map['email']?? "",
      phoneNumber: map['phoneNumber']?? "",
      imageUrl: map['image_url']??"",
    );
  }

}
