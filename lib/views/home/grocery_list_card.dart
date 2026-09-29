import 'package:flutter/material.dart';
import 'package:listako/views/theme/app_colors.dart';
import 'package:listako/models/grocery_item.dart';
import 'package:listako/models/grocery_list.dart';

class GroceryListCard extends StatelessWidget {
  const GroceryListCard({
    super.key,
    required this.list,
    required this.index,
    required this.headerColor,
    required this.badgeColor,
    required this.currencySymbol,
    required this.onTap,
    required this.onDelete,
  });

  final GroceryList list;
  final int index;
  final Color headerColor;
  final Color badgeColor;
  final String currencySymbol;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final previewItems = list.previewItems();
    final extraCount = list.extraItemCount();

    // list card
    return GestureDetector(
      onTap: onTap,
      onLongPress: onDelete,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // header
            _buildHeaderStrip(),
            // items preview
            Expanded(child: _buildItemPreview(previewItems, extraCount)),
            // total row
            _buildTotal(),
          ],
        ),
      ),
    );
  }

  // header box
  Widget _buildHeaderStrip() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
      decoration: BoxDecoration(
        color: headerColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // list name
                Text(
                  list.name,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                // item count
                Text(
                  '${list.itemCount} item${list.itemCount == 1 ? '' : 's'}',
                  style: const TextStyle(fontSize: 11, color: Colors.black54),
                ),
              ],
            ),
          ),
          // number badge
          CircleAvatar(
            radius: 12,
            backgroundColor: badgeColor,
            child: Text(
              '${index + 1}',
              style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }

  // items box
  Widget _buildItemPreview(List<GroceryItem> previewItems, int extraCount) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: previewItems.isEmpty
            ? [
                // empty text
                const Text('No items yet',
                    style: TextStyle(fontSize: 12, color: Colors.black38)),
              ]
            : [
                // item row
                ...previewItems.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        // bullet
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                              color: badgeColor, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            item.name,
                            style: const TextStyle(
                                fontSize: 12, color: AppColors.textDark),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // more items
                if (extraCount > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      '+ $extraCount more item${extraCount == 1 ? '' : 's'}',
                      style: const TextStyle(
                          fontSize: 11,
                          color: Colors.black38,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
              ],
      ),
    );
  }

  // total box
  Widget _buildTotal() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFE0E0E0))),
      ),
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
      child: Row(
        children: [
          // total icon
          Icon(Icons.list_alt_rounded, size: 14, color: Colors.grey.shade500),
          const SizedBox(width: 6),
          const Text(
            'Total',
            style: TextStyle(fontSize: 12, color: Colors.black45),
          ),
          const Spacer(),
          // total amount
          Text(
            '$currencySymbol${list.total.toStringAsFixed(2)}',
            style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
                fontSize: 13),
          ),
        ],
      ),
    );
  }
}