import 'package:flutter/material.dart';
import 'package:listako/views/theme/app_colors.dart';

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.totalSpent,
    required this.totalItems,
    required this.listCount,
    required this.currencySymbol,
  });

  final double totalSpent;
  final int totalItems;
  final int listCount;
  final String currencySymbol;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // total spent banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 203, 255, 197),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // amount
                    Text(
                      '$currencySymbol${totalSpent.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: Color.fromARGB(255, 5, 44, 0),
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    // title
                    const Text(
                      'Total Spent',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color.fromARGB(255, 5, 44, 0),
                      ),
                    ),
                    const SizedBox(height: 2),
                    // subtitle
                    Text(
                      listCount == 0
                          ? 'No lists yet'
                          : 'Across your shopping list${listCount == 1 ? '' : 's'}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color.fromARGB(255, 5, 44, 0),
                      ),
                    ),
                  ],
                ),
              ),
              // wallet icon
              const Icon(
                Icons.account_balance_wallet_rounded,
                color: Color.fromARGB(255, 5, 44, 0),
                size: 57,
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // mini cards
        Row(
          children: [
            // items card
            Expanded(
              child: _MiniCard(
                value: totalItems.toString(),
                label: 'Total Items',
                icon: Icons.inventory_2_rounded,
              ),
            ),
            const SizedBox(width: 12),
            // lists card
            Expanded(
              child: _MiniCard(
                value: listCount.toString(),
                label: 'List${listCount == 1 ? '' : 's'}',
                icon: Icons.menu_book_rounded,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MiniCard extends StatelessWidget {
  const _MiniCard({
    required this.value,
    required this.label,
    required this.icon,
  });

  final String value;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    // card box
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.yellowLight,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // value
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 2),
                // label
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black45,
                  ),
                ),
              ],
            ),
          ),
          // icon
          Icon(
            icon,
            color: const Color.fromARGB(255, 48, 43, 0),
            size: 40,
          ),
        ],
      ),
    );
  }
}
