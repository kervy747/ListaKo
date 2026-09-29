import 'package:listako/models/grocery_item.dart';

class GroceryList {
  GroceryList({
    required this.id,
    required this.name,
    List<GroceryItem>? items,
    this.budget,
  }) : items = items ?? [];

  final String id;
  String name;
  final List<GroceryItem> items;
  double? budget;

  // counts
  int get itemCount => items.length;
  int get checkedCount => items.where((item) => item.isChecked).length;

  // totals
  double get total => items.fold(0.0, (sum, item) => sum + item.totalPrice);

  // budget
  double? get remaining => budget == null ? null : budget! - total;
  bool get isOverBudget => remaining != null && remaining! < 0;

  // card preview
  List<GroceryItem> previewItems([int count = 6]) => items.take(count).toList();
  int extraItemCount([int count = 6]) =>
      items.length > count ? items.length - count : 0;

  // to firestore
  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'budget': budget,
        'items': items.map((i) => i.toMap()).toList(),
      };

  // from firestore
  factory GroceryList.fromMap(Map<String, dynamic> map) => GroceryList(
        id: map['id'] as String,
        name: map['name'] as String,
        budget: (map['budget'] as num?)?.toDouble(),
        items: (map['items'] as List<dynamic>?)
                ?.map((e) => GroceryItem.fromMap(Map<String, dynamic>.from(e as Map)))
                .toList() ??
            [],
      );
}