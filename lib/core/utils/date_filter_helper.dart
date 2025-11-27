import '../../i18n/strings.g.dart';

enum DateFilterType {
  currentMonth,
  lastMonth,
  last3Months,
  last6Months,
  lastYear,
  allTime,
  customMonth, // For dashboard specific month selection
}

extension DateFilterExtension on DateFilterType {
  String get label {
    switch (this) {
      case DateFilterType.currentMonth:
        return t.filters.currentMonth;
      case DateFilterType.lastMonth:
        return t.filters.lastMonth;
      case DateFilterType.last3Months:
        return t.filters.last3Months;
      case DateFilterType.last6Months:
        return t.filters.last6Months;
      case DateFilterType.lastYear:
        return t.filters.lastYear;
      case DateFilterType.allTime:
        return t.filters.allTime;
      case DateFilterType.customMonth:
        return t.filters.custom;
    }
  }

  bool includes(DateTime date, {DateTime? customDate}) {
    final now = DateTime.now();
    switch (this) {
      case DateFilterType.currentMonth:
        return date.year == now.year && date.month == now.month;
      case DateFilterType.lastMonth:
        final lastMonth = DateTime(now.year, now.month - 1);
        return date.year == lastMonth.year && date.month == lastMonth.month;
      case DateFilterType.last3Months:
        final threeMonthsAgo = DateTime(now.year, now.month - 3);
        return date.isAfter(threeMonthsAgo);
      case DateFilterType.last6Months:
        final sixMonthsAgo = DateTime(now.year, now.month - 6);
        return date.isAfter(sixMonthsAgo);
      case DateFilterType.lastYear:
        final oneYearAgo = DateTime(now.year - 1, now.month, now.day);
        return date.isAfter(oneYearAgo);
      case DateFilterType.allTime:
        return true;
      case DateFilterType.customMonth:
        if (customDate == null) return true;
        return date.year == customDate.year && date.month == customDate.month;
    }
  }
}
