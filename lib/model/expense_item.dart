import 'package:flutter/material.dart';

// Expense model class
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

// Expense category enum
enum ExpenseCategory {
  food('Food', Icons.restaurant, Colors.orange),
  travel('Travel', Icons.directions_car, Colors.blue),
  leisure('Leisure', Icons.sports_esports, Colors.purple),
  work('Work', Icons.work, Colors.teal);

  const ExpenseCategory(this.name, this.icon, this.color);

  final String name;
  final IconData icon;
  final Color color;

  static List<String> get categoryNames => ExpenseCategory.values.map((e) => e.name).toList();
  
  static ExpenseCategory fromName(String name) {
    return ExpenseCategory.values.firstWhere(
      (category) => category.name.toLowerCase() == name.toLowerCase(),
      orElse: () => ExpenseCategory.food,
    );
  }
}

// Expense bucket for chart data grouping
class ExpenseBucket {
  final ExpenseCategory category;
  final List<Expense> expenses;

  ExpenseBucket({
    required this.category,
    required List<Expense> allExpenses,
  }) : expenses = allExpenses
            .where((expense) => expense.category == category.name)
            .toList();

  // Calculate total expenses for this category
  double get totalExpenses {
    double sum = 0.0;
    for (final expense in expenses) {
      sum += expense.amount;
    }
    return sum;
  }

  // Get expense count for this category
  int get expenseCount => expenses.length;
}

// Constants for expense management
class ExpenseConstants {
  static const String currency = '₱';
  static const String currencyName = 'Philippine Peso';
  static const double minAmount = 0.01;
  static const int maxTitleLength = 100;
  
  // Date range constants
  static DateTime get minDate => DateTime(2020);
  static DateTime get maxDate => DateTime.now();
}
