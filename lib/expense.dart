import 'package:flutter/material.dart';
import 'expense_item.dart';

class ExpenseTrackerHome extends StatefulWidget {
  const ExpenseTrackerHome({super.key});

  @override
  State<ExpenseTrackerHome> createState() => _ExpenseTrackerHomeState();
}

class _ExpenseTrackerHomeState extends State<ExpenseTrackerHome> {
  final List<Expense> _expenses = [];
  double _totalExpenses = 0.0;

  void _addExpense(String title, double amount, DateTime date, String category) {
    setState(() {
      _expenses.add(Expense(
        description: title,
        amount: amount,
        date: date,
        category: category,
      ));
      _totalExpenses += amount;
    });
  }

  void _navigateToAddExpense() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ExpenseItemScreen(),
      ),
    );
    
    if (result != null) {
      _addExpense(
        result['title'],
        result['amount'],
        result['date'],
        result['category'],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Expense Tracker'),
        actions: [
          IconButton(
            onPressed: _navigateToAddExpense,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Total expenses card
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text(
                    'Total Expenses',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₱${_totalExpenses.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            
            // Expenses list
            if (_expenses.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Recent Expenses',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _expenses.length,
                itemBuilder: (context, index) {
                  final expense = _expenses[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Icon(_getCategoryIcon(expense.category)),
                      ),
                      title: Text(expense.description),
                      subtitle: Text(
                        '${expense.category} • ${expense.date.day}/${expense.date.month}/${expense.date.year}',
                      ),
                      trailing: Text(
                        '₱${expense.amount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ] else
              const Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  'No expenses yet!\nTap the + button to add your first expense.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Icons.restaurant;
      case 'travel':
        return Icons.directions_car;
      case 'leisure':
        return Icons.sports_esports;
      case 'work':
        return Icons.work;
      default:
        return Icons.attach_money;
    }
  }
}

class Expense {
  final String description;
  final double amount;
  final DateTime date;
  final String category;

  Expense({
    required this.description,
    required this.amount,
    required this.date,
    required this.category,
  });
}