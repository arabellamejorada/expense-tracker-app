import 'package:flutter/material.dart';
import '../model/expense_item.dart';

class ExpenseItemWidget extends StatelessWidget {
  final Expense expense;

  const ExpenseItemWidget({
    super.key,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    final categoryEnum = ExpenseCategory.fromName(expense.category);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left side: Title and Amount
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    expense.description,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Amount
                  Text(
                    '${ExpenseConstants.currency}${expense.amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            
            // Right side: Category Icon and Date
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Category Icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: categoryEnum.color,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    categoryEnum.icon,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 8),
                // Date
                Text(
                  '${expense.date.day}/${expense.date.month}/${expense.date.year}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
