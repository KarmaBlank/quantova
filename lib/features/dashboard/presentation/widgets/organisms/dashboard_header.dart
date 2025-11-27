import 'package:flutter/material.dart';

import '../../../../../../i18n/strings.g.dart';
import '../molecules/savings_indicator.dart';

class DashboardHeader extends StatelessWidget {
  final double balance;
  final double globalSavingsPercentage;
  final double monthlySavingsPercentage;

  const DashboardHeader({
    super.key,
    required this.balance,
    required this.globalSavingsPercentage,
    required this.monthlySavingsPercentage,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFF546E7A),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.dashboard.totalBalance,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '\$${balance.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: SavingsIndicator(
                  label: t.dashboard.globalSavings,
                  percentage: globalSavingsPercentage,
                  icon: Icons.savings_outlined,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SavingsIndicator(
                  label: t.dashboard.monthlySavings,
                  percentage: monthlySavingsPercentage,
                  icon: Icons.calendar_today,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
