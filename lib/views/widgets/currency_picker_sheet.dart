import 'package:flutter/material.dart';
import 'package:listako/views/theme/app_colors.dart';
import 'package:listako/models/currency.dart';
import 'package:listako/controllers/currency_controller.dart';

class CurrencyPickerSheet extends StatelessWidget {
  const CurrencyPickerSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final current = CurrencyController.instance.currency;

    // currency sheet
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // drag handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Select Currency',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(height: 4),
            // currency list
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: AppCurrencies.all.map((currency) {
                  final isSelected = currency.code == current.code;
                  // currency tile
                  return ListTile(
                    // symbol
                    leading: CircleAvatar(
                      backgroundColor: isSelected ? AppColors.green : const Color(0xFFF0F0F0),
                      child: Text(
                        currency.symbol,
                        style: TextStyle(
                          color: isSelected ? AppColors.white : Colors.black54,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    title: Text(currency.code, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(currency.name),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle, color: AppColors.green)
                        : null,
                    // select currency
                    onTap: () {
                      CurrencyController.instance.setCurrency(currency);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}