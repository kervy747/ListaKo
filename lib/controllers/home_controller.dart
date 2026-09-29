import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:listako/controllers/currency_controller.dart';
import 'package:listako/models/grocery_list.dart';

class HomeController extends ChangeNotifier {
  final List<GroceryList> lists = [];
  bool isLoading = true;

  // profile photo
  String? get photoUrl => FirebaseAuth.instance.currentUser?.photoURL;

  // stats
  double get totalSpent => lists.fold(0.0, (sum, l) => sum + l.total);
  int get totalItems => lists.fold(0, (sum, l) => sum + l.itemCount);

  // lists path
  CollectionReference<Map<String, dynamic>> get _listsRef {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('lists');
  }

  // load all
  Future<void> loadData() async {
    await CurrencyController.instance.loadFromFirestore();
    await loadLists();
  }

  // load lists
  Future<void> loadLists() async {
    try {
      final snap = await _listsRef.orderBy('createdAt').get();
      final loaded = snap.docs
          .map((doc) => GroceryList.fromMap(doc.data()))
          .toList();
      lists
        ..clear()
        ..addAll(loaded);
    } catch (_) {
      // stays empty
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // create list
  Future<void> createList(String name) async {
    final list = GroceryList(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name.trim(),
    );
    lists.add(list);
    notifyListeners();
    await _saveList(list, isNew: true);
  }

  // save list
  Future<void> saveList(GroceryList list) async {
    await _saveList(list);
    notifyListeners();
  }

  // delete list
  Future<void> deleteList(String id) async {
    lists.removeWhere((l) => l.id == id);
    notifyListeners();
    await _listsRef.doc(id).delete();
  }

  // refresh user info
  void refreshUser() => notifyListeners();

  // logout
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  // firestore write
  Future<void> _saveList(GroceryList list, {bool isNew = false}) async {
    await _listsRef.doc(list.id).set({
      ...list.toMap(),
      if (isNew) 'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}