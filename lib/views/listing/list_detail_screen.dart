import 'package:flutter/material.dart';
import 'package:listako/controllers/currency_controller.dart';
import 'package:listako/controllers/list_detail_controller.dart';
import 'package:listako/models/grocery_item.dart';
import 'package:listako/models/grocery_list.dart';
import 'package:listako/views/listing/add_item_sheet.dart';
import 'package:listako/views/listing/budget_dialog.dart';
import 'package:listako/views/listing/grocery_item_tile.dart';
import 'package:listako/views/listing/list_summary_card.dart';
import 'package:listako/views/theme/app_colors.dart';
import 'package:listako/views/widgets/empty_state.dart';

class ListDetailScreen extends StatefulWidget {
  const ListDetailScreen({super.key, required this.list});

  final GroceryList list;

  @override
  State<ListDetailScreen> createState() => _ListDetailScreenState();
}

class _ListDetailScreenState extends State<ListDetailScreen> {
  late final ListDetailController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ListDetailController(list: widget.list);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // open add / edit item
  Future<void> _openItemSheet({GroceryItem? existingItem}) async {
    final result = await showModalBottomSheet<GroceryItem>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => AddItemSheet(
        controller: _controller,
        existingItem: existingItem,
        onDelete: existingItem == null
            ? null
            : () => _controller.deleteItem(existingItem),
      ),
    );

    if (result == null) return;

    if (existingItem != null) {
      await _controller.updateItem(existingItem, result);
    } else {
      await _controller.addItem(result);
    }
  }

  // open budget dialog
  Future<void> _editBudget() async {
    final result = await showDialog<String>(
      context: context,
      builder: (_) => BudgetDialog(
        initialText: _controller.budgetText,
        hasBudget: widget.list.budget != null,
      ),
    );

    if (result == null) return;
    await _controller.setBudgetFromText(result);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([_controller, CurrencyController.instance]),
      builder: (context, _) {
        final currencySymbol = CurrencyController.instance.currency.symbol;
        final items = _controller.sortedItems;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                // top bar
                _buildTopBar(),
                // summary card
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
                  child: ListSummaryCard(
                    checkedCount: widget.list.checkedCount,
                    totalCount: widget.list.itemCount,
                    total: widget.list.total,
                    budget: widget.list.budget,
                    remaining: widget.list.remaining,
                    isOverBudget: widget.list.isOverBudget,
                    currencySymbol: currencySymbol,
                    onEditBudget: _editBudget,
                  ),
                ),
                // item list
                Expanded(
                  child: items.isEmpty
                      // empty state
                      ? const EmptyState(
                          icon: Icons.shopping_basket_outlined,
                          title: 'No items yet',
                          message: 'Tap "Add Item" to add something to this list.',
                          iconBackground: Color(0x1A2E7D32),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
                          itemCount: items.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          // item tile
                          itemBuilder: (context, index) => GroceryItemTile(
                            key: ValueKey(items[index].id),
                            item: items[index],
                            currencySymbol: currencySymbol,
                            onToggle: () => _controller.toggleChecked(items[index]),
                            onEdit: () => _openItemSheet(existingItem: items[index]),
                          ),
                        ),
                ),
              ],
            ),
          ),
          // add item button
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _openItemSheet(),
            backgroundColor: AppColors.red,
            foregroundColor: AppColors.white,
            icon: const Icon(Icons.add),
            label: const Text('Add Item'),
          ),
        );
      },
    );
  }

  // top bar
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 6, 16, 0),
      child: Row(
        children: [
          // back button
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
            onPressed: () => Navigator.of(context).pop(),
          ),
          // list name
          Expanded(
            child: Text(
              widget.list.name,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
