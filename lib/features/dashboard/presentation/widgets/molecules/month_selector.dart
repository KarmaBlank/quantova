import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../i18n/strings.g.dart';

class MonthSelector extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<int> onMonthChange;

  const MonthSelector({
    super.key,
    required this.selectedDate,
    required this.onMonthChange,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => onMonthChange(-1),
          color: isDark ? Colors.white70 : Colors.black54,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? Colors.white10 : Colors.grey[300]!,
            ),
          ),
          child: Text(
            DateFormat('MMMM yyyy', LocaleSettings.currentLocale.languageCode).format(selectedDate),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: () => onMonthChange(1),
          color: isDark ? Colors.white70 : Colors.black54,
        ),
      ],
    );
  }
}
