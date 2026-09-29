import 'package:flutter/material.dart';
import 'package:listako/views/theme/app_colors.dart';

class ListSummaryCard extends StatelessWidget {
  const ListSummaryCard({
    super.key,
    required this.checkedCount,
    required this.totalCount,
    required this.total,
    required this.budget,
    required this.remaining,
    required this.isOverBudget,
    required this.currencySymbol,
    required this.onEditBudget,
  });

  final int checkedCount;
  final int totalCount;
  final double total;
  final double? budget;
  final double? remaining;
  final bool isOverBudget;
  final String currencySymbol;
  final VoidCallback onEditBudget;

  @override
  Widget build(BuildContext context) {
    // summary card
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.green,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: AppColors.green.withValues(alpha: 0.25), blurRadius: 16, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // items and total
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // items label
                    const Text('Items', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    const SizedBox(height: 2),
                    // checked count
                    Text(
                      '$checkedCount of $totalCount checked',
                      style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.w800, fontSize: 16),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // total label
                  const Text('Total', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  const SizedBox(height: 2),
                  // total amount
                  Text(
                    '$currencySymbol${total.toStringAsFixed(2)}',
                    style: const TextStyle(color: AppColors.yellow, fontWeight: FontWeight.w800, fontSize: 20),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          // budget row
          _buildBudgetRow(),
        ],
      ),
    );
  }

  // budget box
  Widget _buildBudgetRow() {
    final hasBudget = budget != null;
    final remainingValue = remaining ?? 0.0;

    return InkWell(
      onTap: onEditBudget,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            // wallet icon
            const Icon(Icons.account_balance_wallet_outlined, size: 16, color: AppColors.white),
            const SizedBox(width: 8),
            Expanded(
              // budget text
              child: hasBudget
                  ? Text(
                      'Budget $currencySymbol${budget!.toStringAsFixed(2)}',
                      style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.w700, fontSize: 13),
                    )
                  : const Text(
                      'No budget set — tap to add one',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
            ),
            // budget badge
            if (hasBudget) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isOverBudget ? AppColors.red : AppColors.yellow,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  isOverBudget
                      ? 'Over by $currencySymbol${(-remainingValue).toStringAsFixed(2)}'
                      : 'Left $currencySymbol${remainingValue.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: isOverBudget ? AppColors.white : AppColors.textDark,
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                  ),
                ),
              ),
              const SizedBox(width: 6),
            ],
            // edit icon
            const Icon(Icons.edit, size: 14, color: Colors.white70),
          ],
        ),
      ),
    );
  }
}