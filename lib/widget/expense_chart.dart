import 'package:flutter/material.dart';
import '../model/expense_item.dart';

class ExpenseChart extends StatelessWidget {
  final List<Expense> expenses;

  const ExpenseChart({
    super.key,
    required this.expenses,
  });

  List<ExpenseBucket> get buckets {
    return ExpenseCategory.values.map((category) {
      return ExpenseBucket(
        category: category,
        allExpenses: expenses,
      );
    }).toList();
  }

  double get maxTotalExpense {
    double maxAmount = 0;
    for (final bucket in buckets) {
      if (bucket.totalExpenses > maxAmount) {
        maxAmount = bucket.totalExpenses;
      }
    }
    return maxAmount;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: isDarkMode
              ? [
                  Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  Theme.of(context).colorScheme.primary.withOpacity(0.0)
                ]
              : [
                  Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  Theme.of(context).colorScheme.primary.withOpacity(0.0)
                ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: Column(
        children: [
          // Chart title
          Text(
            'Spending by Category',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 20),
          // Chart bars
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: buckets.map((bucket) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Amount text
                        FittedBox(
                          child: Text(
                            bucket.totalExpenses > 0
                                ? '${ExpenseConstants.currency}${bucket.totalExpenses.toStringAsFixed(0)}'
                                : '',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Bar
                        Container(
                          width: double.infinity,
                          height: maxTotalExpense == 0
                              ? 0
                              : (bucket.totalExpenses / maxTotalExpense) * 72,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: bucket.totalExpenses == 0
                                ? Theme.of(context).colorScheme.surfaceVariant
                                : bucket.category.color,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Category icon and name
                        Icon(
                          bucket.category.icon,
                          color: bucket.totalExpenses == 0
                              ? Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.6)
                              : bucket.category.color,
                          size: 16,
                        ),
                        const SizedBox(height: 4),
                        FittedBox(
                          child: Text(
                            bucket.category.name,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  fontSize: 10,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
