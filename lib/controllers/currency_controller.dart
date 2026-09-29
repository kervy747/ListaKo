import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:listako/models/currency.dart';

class CurrencyController extends ChangeNotifier {
  CurrencyController._internal();
  static final CurrencyController instance = CurrencyController._internal();

  // default is PHP
  AppCurrency _currency = AppCurrencies.all.first;
  AppCurrency get currency => _currency;

  // user doc
  static DocumentReference<Map<String, dynamic>>? _userDoc() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;
    return FirebaseFirestore.instance.collection('users').doc(uid);
  }

  // load
  Future<void> loadFromFirestore() async {
    final doc = _userDoc();
    if (doc == null) return;
    final snap = await doc.get();
    final code = snap.data()?['currencyCode'] as String?;
    if (code != null) {
      final match = AppCurrencies.all.where((c) => c.code == code).firstOrNull;
      if (match != null) {
        _currency = match;
        notifyListeners();
      }
    }
  }

  // change
  void setCurrency(AppCurrency newCurrency) {
    if (newCurrency.code == _currency.code) return;
    _currency = newCurrency;
    notifyListeners();
    _persistCurrency(newCurrency.code);
  }

  // save
  Future<void> _persistCurrency(String code) async {
    final doc = _userDoc();
    if (doc == null) return;
    await doc.set({'currencyCode': code}, SetOptions(merge: true));
  }
}