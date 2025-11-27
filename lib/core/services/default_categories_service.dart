import 'package:flutter/material.dart';

import '../database/database_service.dart';
import '../database/entities/category.dart';

class DefaultCategoriesService {
  static Future<void> initializeDefaultCategories(DatabaseService db) async {
    // Check if default categories already exist
    final existingCategories = db.categoryBox.getAll();
    if (existingCategories.isNotEmpty) {
      return; // Already initialized
    }

    // Default categories with icons and colors
    final defaultCategories = [
      // Income category
      Category(
        name: 'Salary',
        iconName: 'account_balance_wallet',
        colorValue: const Color(0xFF4CAF50).value, // Green
        isDefault: true,
      ),
      // Expense categories
      Category(
        name: 'Home',
        iconName: 'home',
        colorValue: const Color(0xFF607D8B).value, // Blue Grey
        isDefault: true,
      ),
      Category(
        name: 'Subscriptions',
        iconName: 'subscriptions',
        colorValue: const Color(0xFF9C27B0).value, // Purple
        isDefault: true,
      ),
      Category(
        name: 'Groceries',
        iconName: 'shopping_cart',
        colorValue: const Color(0xFF4CAF50).value, // Green
        isDefault: true,
      ),
      Category(
        name: 'Fast Food',
        iconName: 'fastfood',
        colorValue: const Color(0xFFFF9800).value, // Orange
        isDefault: true,
      ),
      Category(
        name: 'Restaurant',
        iconName: 'restaurant',
        colorValue: const Color(0xFFF44336).value, // Red
        isDefault: true,
      ),
      Category(
        name: 'Entertainment',
        iconName: 'movie',
        colorValue: const Color(0xFFE91E63).value, // Pink
        isDefault: true,
      ),
    ];

    // Insert all default categories
    db.categoryBox.putMany(defaultCategories);
  }
}
