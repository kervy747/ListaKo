import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:listako/models/grocery_item.dart';
import 'package:listako/models/grocery_list.dart';

class ListDetailController extends ChangeNotifier {
  final GroceryList list;

  ListDetailController({required this.list});

  // unchecked first
  List<GroceryItem> get sortedItems => [
        ...list.items.where((i) => !i.isChecked),
        ...list.items.where((i) => i.isChecked),
      ];

  // budget text
  String get budgetText =>
      list.budget != null ? list.budget!.toStringAsFixed(2) : '';

  // list doc
  DocumentReference<Map<String, dynamic>> get _listDoc {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('lists')
        .doc(list.id);
  }

  // build item from form
  GroceryItem buildItem({
    GroceryItem? existing,
    required String name,
    required String quantity,
    required String price,
    required GroceryCategory category,
  }) {
    final qty = quantity.trim();
    return GroceryItem(
      id: existing?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      name: name.trim(),
      category: category,
      quantity: qty.isEmpty ? '1' : qty,
      price: double.tryParse(price.trim()) ?? 0,
      isChecked: existing?.isChecked ?? false,
    );
  }

  // add item
  Future<void> addItem(GroceryItem item) async {
    list.items.add(item);
    notifyListeners();
    await _persist();
  }

  // update item
  Future<void> updateItem(GroceryItem existing, GroceryItem updated) async {
    final index = list.items.indexWhere((i) => i.id == existing.id);
    if (index != -1) {
      list.items[index] = updated;
      notifyListeners();
      await _persist();
    }
  }

  // delete item
  Future<void> deleteItem(GroceryItem item) async {
    list.items.removeWhere((i) => i.id == item.id);
    notifyListeners();
    await _persist();
  }

  // check item
  Future<void> toggleChecked(GroceryItem item) async {
    item.isChecked = !item.isChecked;
    notifyListeners();
    await _persist();
  }

  // set budget
  Future<void> setBudget(double? budget) async {
    list.budget = budget;
    notifyListeners();
    await _persist();
  }

  // set budget from text
  Future<void> setBudgetFromText(String text) {
    final value = text.trim();
    return setBudget(value.isEmpty ? null : double.tryParse(value));
  }

  // firestore write
  Future<void> _persist() async {
    await _listDoc.update(list.toMap());
  }
}