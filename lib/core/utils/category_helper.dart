import '../../i18n/strings.g.dart';

class CategoryHelper {
  static const List<String> defaultCategoryKeys = [
    'home',
    'subscriptions',
    'groceries',
    'fastFood',
    'restaurant',
    'entertainment',
    'salary',
  ];

  /// Returns the localized name for a default category
  static String getLocalizedCategoryName(String categoryKey) {
    switch (categoryKey.toLowerCase()) {
      case 'home':
        return t.categories.defaultCategories.home;
      case 'subscriptions':
        return t.categories.defaultCategories.subscriptions;
      case 'groceries':
        return t.categories.defaultCategories.groceries;
      case 'fastfood':
      case 'fast food':
        return t.categories.defaultCategories.fastFood;
      case 'restaurant':
        return t.categories.defaultCategories.restaurant;
      case 'entertainment':
        return t.categories.defaultCategories.entertainment;
      case 'salary':
        return t.categories.defaultCategories.salary;
      default:
        return categoryKey; // Return original if not found
    }
  }

  /// Returns all default categories with localized names
  static Map<String, String> getDefaultCategories() {
    return {
      'home': t.categories.defaultCategories.home,
      'subscriptions': t.categories.defaultCategories.subscriptions,
      'groceries': t.categories.defaultCategories.groceries,
      'fastFood': t.categories.defaultCategories.fastFood,
      'restaurant': t.categories.defaultCategories.restaurant,
      'entertainment': t.categories.defaultCategories.entertainment,
      'salary': t.categories.defaultCategories.salary,
    };
  }
}
