import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app_expenses_income/Authentication/fire_service.dart';
import 'package:flutter_app_expenses_income/Authentication/user_model.dart';
import 'package:get/get.dart';

class UserController extends GetxController{
  final FirestoreService firebaseService = FirestoreService();
  late UserModel userModel;
  bool isLoading = false;


  void updateState(bool state) {
    isLoading = state;
    update();
  }

  Future<void> fetchUserData() async {
    try{
      User? user = FirebaseAuth.instance.currentUser;
      updateState(true);
      if (user != null) {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (doc.exists) {
          userModel = UserModel.fromFirestore(doc);
        } else {
          throw Exception('User not found in Firestore');
        }
      } else {
        throw Exception('No user is signed in');
      }
    }catch(e){
      print(e);
    }finally{
      updateState(false);
    }

  }
}