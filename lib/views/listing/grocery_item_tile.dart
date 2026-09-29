import 'package:flutter/material.dart';
import 'package:listako/views/theme/app_colors.dart';
import 'package:listako/models/grocery_item.dart';
import 'package:listako/views/theme/category_style.dart';

class GroceryItemTile extends StatelessWidget {
  const GroceryItemTile({
    super.key,
    required this.item,
    required this.currencySymbol,
    required this.onToggle,
    required this.onEdit,
  });

  final GroceryItem item;
  final String currencySymbol;
  final VoidCallback onToggle;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    // item tile
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 3)),
            ],
          ),
          child: Row(
            children: [
              // checkbox
              _buildCheckbox(),
              const SizedBox(width: 12),
              // category icon
              _buildCategoryBadge(),
              const SizedBox(width: 12),
              // name and qty
              Expanded(child: _buildNameAndMeta()),
              const SizedBox(width: 8),
              // line total
              Text(
                '$currencySymbol${item.totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                    fontSize: 13),
              ),
              const SizedBox(width: 4),
              // arrow
              const Icon(Icons.chevron_right, size: 18, color: Colors.black26),
            ],
          ),
        ),
      ),
    );
  }

  // checkbox box
  Widget _buildCheckbox() {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onToggle,
        customBorder: const CircleBorder(),
        child: Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: item.isChecked ? AppColors.green : Colors.transparent,
            border: Border.all(
                color: item.isChecked ? AppColors.green : Colors.black26,
                width: 1.6),
          ),
          child: item.isChecked
              ? const Icon(Icons.check, size: 16, color: AppColors.white)
              : null,
        ),
      ),
    );
  }

  // category box
  Widget _buildCategoryBadge() {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: item.category.accentColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(item.category.icon, size: 18, color: item.category.accentColor),
    );
  }

  // name and meta
  Widget _buildNameAndMeta() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // item name
        Text(
          item.name,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            decoration: item.isChecked ? TextDecoration.lineThrough : null,
            color: item.isChecked ? Colors.black38 : AppColors.textDark,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 3),
        Row(
          children: [
            // category label
            Text(
              item.category.label,
              style: TextStyle(
                  fontSize: 11,
                  color: item.category.accentColor,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 8),
            // quantity
            Text('Qty: ${item.quantity}',
                style: const TextStyle(fontSize: 11, color: Colors.black45)),
          ],
        ),
      ],
    );
  }
}