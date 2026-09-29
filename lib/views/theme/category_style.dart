import 'package:flutter/material.dart';
import 'package:listako/models/grocery_item.dart';

// category look
extension GroceryCategoryStyle on GroceryCategory {
  // name
  String get label {
    switch (this) {
      case GroceryCategory.fruitsVeggies:
        return 'Fruits & Vegetables';
      case GroceryCategory.meatPoultry:
        return 'Meat & Poultry';
      case GroceryCategory.dairyEggs:
        return 'Dairy & Eggs';
      case GroceryCategory.bakery:
        return 'Bakery';
      case GroceryCategory.beverages:
        return 'Beverages';
      case GroceryCategory.snacks:
        return 'Snacks & Sweets';
      case GroceryCategory.household:
        return 'Household';
      case GroceryCategory.others:
        return 'Others';
    }
  }

  // icon
  IconData get icon {
    switch (this) {
      case GroceryCategory.fruitsVeggies:
        return Icons.eco;
      case GroceryCategory.meatPoultry:
        return Icons.set_meal;
      case GroceryCategory.dairyEggs:
        return Icons.egg;
      case GroceryCategory.bakery:
        return Icons.bakery_dining;
      case GroceryCategory.beverages:
        return Icons.local_drink;
      case GroceryCategory.snacks:
        return Icons.icecream;
      case GroceryCategory.household:
        return Icons.cleaning_services;
      case GroceryCategory.others:
        return Icons.shopping_bag;
    }
  }

  // color
  Color get accentColor {
    switch (this) {
      case GroceryCategory.fruitsVeggies:
        return const Color.fromARGB(255, 39, 156, 45);
      case GroceryCategory.meatPoultry:
        return const Color.fromARGB(255, 196, 95, 2);
      case GroceryCategory.dairyEggs:
        return const Color.fromARGB(255, 152, 231, 255);
      case GroceryCategory.bakery:
        return const Color.fromARGB(255, 252, 243, 116);
      case GroceryCategory.beverages:
        return const Color.fromARGB(255, 48, 79, 255);
      case GroceryCategory.snacks:
        return const Color.fromARGB(255, 253, 150, 53);
      case GroceryCategory.household:
        return const Color.fromARGB(255, 173, 113, 189);
      case GroceryCategory.others:
        return const Color.fromARGB(255, 119, 105, 105);
    }
  }
}