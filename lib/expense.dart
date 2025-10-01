import 'package:flutter/material.dart';
import 'new_expense.dart';
import 'model/expense_item.dart';
import 'widget/chart.dart';

class ExpenseTrackerHome extends StatefulWidget {
  const ExpenseTrackerHome({super.key});

  @override
  State<ExpenseTrackerHome> createState() => _ExpenseTrackerHomeState();
}

class _ExpenseTrackerHomeState extends State<ExpenseTrackerHome> {
  final List<Expense> _expenses = [];

  void _addExpense(String title, double amount, DateTime date, String category) {
    setState(() {
      _expenses.add(Expense(
        description: title,
        amount: amount,
        date: date,
        category: category,
      ));
    });
  }

  void _deleteExpense(int index) {
    final deletedExpense = _expenses[index];
    setState(() {
      _expenses.removeAt(index);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${deletedExpense.description} deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _expenses.insert(index, deletedExpense);
            });
          },
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _navigateToAddExpense() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => NewExpenseModal(onExpenseAdded: _addExpense),
    );
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
            // Expense Chart
            Chart(expenses: _expenses),
            
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
                  return Dismissible(
                    key: Key(expense.description + expense.date.toString()),
                    background: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 20),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    secondaryBackground: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    confirmDismiss: (direction) async {
                      return await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete Expense'),
                          content: Text('Are you sure you want to delete "${expense.description}"?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('Delete', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      ) ?? false;
                    },
                    onDismissed: (direction) {
                      _deleteExpense(index);
                    },
                    child: Card(
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
                          '${ExpenseConstants.currency}${expense.amount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
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
    return ExpenseCategory.fromName(category).icon;
  }
}