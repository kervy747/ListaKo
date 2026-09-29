import 'package:flutter/material.dart';
import 'package:listako/views/theme/app_colors.dart';

class BudgetDialog extends StatefulWidget {
  const BudgetDialog({
    super.key,
    required this.initialText,
    required this.hasBudget,
  });

  final String initialText;
  final bool hasBudget;

  @override
  State<BudgetDialog> createState() => _BudgetDialogState();
}

class _BudgetDialogState extends State<BudgetDialog> {
  late final TextEditingController _budgetController;

  @override
  void initState() {
    super.initState();
    _budgetController = TextEditingController(text: widget.initialText);
  }

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Set Budget'),
      // budget input
      content: TextField(
        controller: _budgetController,
        autofocus: true,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: const InputDecoration(
          labelText: 'Budget',
          hintText: 'e.g. 500 — leave empty for no budget',
        ),
      ),
      actions: [
        // remove button
        if (widget.hasBudget)
          TextButton(
            onPressed: () => Navigator.pop(context, ''),
            child: const Text('Remove Budget', style: TextStyle(color: AppColors.red)),
          ),
        // cancel button
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        // save button
        TextButton(
          onPressed: () => Navigator.pop(context, _budgetController.text.trim()),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
