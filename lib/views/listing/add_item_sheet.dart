import 'package:flutter/material.dart';
import 'package:listako/controllers/list_detail_controller.dart';
import 'package:listako/models/grocery_item.dart';
import 'package:listako/views/theme/app_colors.dart';
import 'package:listako/views/theme/category_style.dart';

class AddItemSheet extends StatefulWidget {
  const AddItemSheet({
    super.key,
    required this.controller,
    this.existingItem,
    this.onDelete,
  });

  final ListDetailController controller;
  final GroceryItem? existingItem;
  final VoidCallback? onDelete;

  bool get isEditing => existingItem != null;

  @override
  State<AddItemSheet> createState() => _AddItemSheetState();
}

class _AddItemSheetState extends State<AddItemSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _quantityController;
  late final TextEditingController _priceController;
  late GroceryCategory _selectedCategory;

  @override
  void initState() {
    super.initState();
    final existing = widget.existingItem;
    _nameController = TextEditingController(text: existing?.name ?? '');
    _quantityController = TextEditingController(text: existing?.quantity ?? '1');
    _priceController = TextEditingController(text: existing != null ? existing.price.toString() : '');
    _selectedCategory = existing?.category ?? GroceryCategory.fruitsVeggies;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  // submit (returns item)
  void _submit() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop(
        widget.controller.buildItem(
          existing: widget.existingItem,
          name: _nameController.text,
          quantity: _quantityController.text,
          price: _priceController.text,
          category: _selectedCategory,
        ),
      );
    }
  }

  // delete
  void _delete() {
    widget.onDelete?.call();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            // title
            Text(
              widget.isEditing ? 'Edit Item' : 'Add Grocery Item',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textDark),
            ),
            const SizedBox(height: 20),
            // item name input
            TextFormField(
              controller: _nameController,
              autofocus: !widget.isEditing,
              decoration: const InputDecoration(labelText: 'Item name', hintText: 'e.g. Bananas'),
              validator: (value) => (value == null || value.trim().isEmpty) ? 'Enter an item name' : null,
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                // quantity input
                Expanded(
                  child: TextFormField(
                    controller: _quantityController,
                    decoration: const InputDecoration(labelText: 'Quantity', hintText: 'e.g. 2 pcs'),
                  ),
                ),
                const SizedBox(width: 12),
                // price input
                Expanded(
                  child: TextFormField(
                    controller: _priceController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Price', hintText: 'e.g. 50'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            // category filter
            DropdownButtonFormField<GroceryCategory>(
              initialValue: _selectedCategory,
              decoration: const InputDecoration(labelText: 'Category'),
              items: GroceryCategory.values
                  .map(
                    (cat) => DropdownMenuItem(
                      value: cat,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(cat.icon, size: 18, color: cat.accentColor),
                          const SizedBox(width: 8),
                          Text(cat.label),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _selectedCategory = value);
              },
            ),
            const SizedBox(height: 24),
            // save button
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.green,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              child: Text(
                widget.isEditing ? 'Save Changes' : 'Add to List',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            // delete button
            if (widget.isEditing) ...[
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: _delete,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.red,
                  side: const BorderSide(color: AppColors.red),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.delete_outline, size: 18),
                label: const Text('Delete Item', style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
