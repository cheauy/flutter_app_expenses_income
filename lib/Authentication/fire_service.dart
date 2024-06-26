import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_app_expenses_income/Authentication/user_model.dart';
import 'package:flutter_app_expenses_income/Screen/Setting/cate_model.dart';
import 'package:flutter_app_expenses_income/Screen/home/Controller/transation_model.dart';
import 'package:intl/intl.dart';

class FirestoreService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> createUser({
    required String uid,
    required String name,
    required String email,
    required String phoneNumber,
    String? imageUrl,
  }) async {
    await firestore.collection('users').doc(uid).set({
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'image_url': imageUrl,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> addCategory({
    required String name,
    required String namekh,
    required String type,
    required String icon,
  }) async {
    await firestore.collection('categories').add({
      'name': name,
      'name_kh': namekh,
      'type': type,
      'icon': icon,
      'createdBy': FirebaseAuth.instance.currentUser!.uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<TransactionModel> addTransaction({
    required double amount,
    required String currency,
    required String category,
    required String date,
    required String text,
  }) async {
    DocumentReference docRef = await firestore.collection('transaction').add({
      'amount': amount,
      'currency': currency,
      'category': category,
      'date': date,
      'text': text,
      'createdBy': FirebaseAuth.instance.currentUser!.uid,
    });
    return TransactionModel(
        id: docRef.id,
        amount: amount,
        currency: currency,
        category: category,
        date: date,
        text: text,
      transactionDate: DateFormat('yyyy-MM-dd').parse(date),
    );
  }

  Future<List<Category>> fetchCategories() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('No user logged in');
    }
    QuerySnapshot querySnapshot =
    await firestore.collection('categories').where('createdBy', isEqualTo: user.uid)
        .get();

    List<Category> categories = querySnapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      return Category.fromFirestore(data,doc.id);
    }).toList();
    categories.sort((a, b) => a.type.compareTo(b.type));
    return categories;
  }

  Future<List<TransactionModel>> fetchTransaction() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('No user logged in');
    }
    QuerySnapshot querySnapshot =
        await firestore.collection('transaction').where('createdBy', isEqualTo: user.uid)
            .get();
    List<TransactionModel> transaction = querySnapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      return TransactionModel.fromFirestore(data,doc.id);
    }).toList();
    transaction.sort((a, b) => a.date.compareTo(b.date));
    return transaction;
  }



  Future<void> reauthenticateUser(String password) async {
    User user = FirebaseAuth.instance.currentUser!;

    AuthCredential credential = EmailAuthProvider.credential(email: user.email!, password: password);
    try {
      await user.reauthenticateWithCredential(credential);
    } catch (e) {
      // Handle error
      print(e);
    }
  }



  Future<void> deleteTransaction(String id) async {
    await firestore.collection("transaction").doc(id).delete();
  }
  Future<void> deleteCategory(String id) async {
    await firestore.collection("categories").doc(id).delete();
  }
  Future<void> deleteUserData(String uid) async {
    try{
      // Delete user document from 'users' collection
      await firestore.collection("users").doc(uid).delete();

      // Delete user image from Firebase Storage
      await FirebaseStorage.instance.ref().child('user_images/$uid.jpg').delete();
      // Delete transactions where createdBy == uid
      QuerySnapshot transactions = await firestore
          .collection('transaction')
          .where('createdBy', isEqualTo: uid)
          .get();

      for (QueryDocumentSnapshot doc in transactions.docs) {
        await doc.reference.delete();
      }
      // Delete categories where createdBy == uid
      QuerySnapshot category = await firestore
          .collection('categories')
          .where('createdBy', isEqualTo: uid)
          .get();

      for (QueryDocumentSnapshot doc in category.docs) {
        await doc.reference.delete();
      }
    }catch(e){
      print('Error deleting user data: $e');
    }

  }

  Future<void> updateTransaction({
    required String id,
    required double amount,
    required String currency,
    required String category,
    required String date,
    required String text,
  }) async {
    DocumentReference docRef = firestore.collection('transaction').doc(id);

    // Check if document exists before attempting to update it
    DocumentSnapshot docSnapshot = await docRef.get();
    if (docSnapshot.exists) {
      await docRef.update({
        'amount': amount,
        'currency': currency,
        'category': category,
        'date': date,
        'text': text,
      });
    } else {
      throw Exception('Document not found');
    }
  }
}

