import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_expenses_income/Authentication/Authen_Controller/authentication.dart';
import 'package:flutter_app_expenses_income/Authentication/fire_service.dart';

import 'package:flutter_app_expenses_income/Authentication/login_screen.dart';
import 'package:flutter_app_expenses_income/Authentication/user_model.dart';
import 'package:flutter_app_expenses_income/Screen/Tabbar/tabbar.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';

class AuthenController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final FirestoreService firebaseService = FirestoreService();
  final TextEditingController passwordController = TextEditingController();

  final formkey = GlobalKey<FormState>();

  var errorMessage = '';
  bool isLoading = false;




  void updateState(bool state) {
    isLoading = state;
    update();
  }




  Future<void> signIn(
      String email, String password, BuildContext context) async {
    if (formkey.currentState!.validate()) {
      try {
        updateState(true);
        UserCredential userCredential =  await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found' || e.code == 'invalid-email') {
          errorMessage = 'The email have not registered ';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Incorrect Password';
        } else {
          errorMessage = 'Failed to sign in: ${e.message}';
        }
        // Update UI with error message
        _showErrorDialog(context, errorMessage);
      } catch (e) {
        errorMessage = 'Hi: $e';
        _showErrorDialog(context, errorMessage);
      }finally{
        updateState(false);
      }
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Login failed'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
  void alertSignout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('You\'re leaving...'),
        content: Text('Are you sure to sign out ?'),
        actions: <Widget>[
          TextButton(
            child: Text('Yes'),
            onPressed: () => signOut(),
          ),
          TextButton(
            child: Text('No'),
            onPressed: () => Get.back(),
          ),
        ],
      ),
    );
  }

  void setLoading(bool value) {
    isLoading = value;
    if (value) {
      EasyLoading.show(status: 'loading...');
    } else {
      EasyLoading.dismiss();
    }
  }
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    Get.back();
  }
  Future<void> deleteUser(String password) async {
    try{
      setLoading(true);
      User? user = FirebaseAuth.instance.currentUser!;
       await firebaseService.reauthenticateUser(password);
        await firebaseService.deleteUserData(user.uid);
        await user.delete();
      setLoading(false);

      signOut();
    }catch(e){
      setLoading(false);
      EasyLoading.showError('Failed to delete account');
    }
  }


  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }
}
