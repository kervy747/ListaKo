// sort options
enum ItemSort { oldest, newest, category }

enum GroceryCategory {
  fruitsVeggies,
  meatPoultry,
  dairyEggs,
  bakery,
  beverages,
  snacks,
  household,
  others,
}

// category key
extension GroceryCategoryX on GroceryCategory {
  String get key => name;

  static GroceryCategory fromKey(String key) {
    return GroceryCategory.values.firstWhere(
      (c) => c.name == key,
      orElse: () => GroceryCategory.others,
    );
  }
}

class GroceryItem {
  GroceryItem({
    required this.id,
    required this.name,
    required this.category,
    this.quantity = '1',
    this.price = 0,
    this.isChecked = false,
  });

  final String id;
  String name;
  GroceryCategory category;
  String quantity;
  double price;
  bool isChecked;

  // quantity number
  double get parsedQuantity {
    if (quantity.trim().isEmpty) return 1.0;
    final match = RegExp(r'^\d+(\.\d+)?').firstMatch(quantity.trim());
    return match != null ? double.parse(match.group(0)!) : 1.0;
  }

  // line total
  double get totalPrice => price * parsedQuantity;

  // time added (from id)
  DateTime get addedAt =>
      DateTime.fromMicrosecondsSinceEpoch(int.tryParse(id) ?? 0);

  // to firestore
  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'category': category.key,
        'quantity': quantity,
        'price': price,
        'isChecked': isChecked,
      };

  // from firestore
  factory GroceryItem.fromMap(Map<String, dynamic> map) => GroceryItem(
        id: map['id'] as String,
        name: map['name'] as String,
        category: GroceryCategoryX.fromKey(map['category'] as String),
        quantity: map['quantity'] as String? ?? '1',
        price: (map['price'] as num?)?.toDouble() ?? 0,
        isChecked: map['isChecked'] as bool? ?? false,
      );
}