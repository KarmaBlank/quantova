import 'package:flutter/material.dart';

import '../../../../../../i18n/strings.g.dart';
import '../molecules/summary_card.dart';

class FinancialSummary extends StatelessWidget {
  final double monthIncome;
  final double monthExpenses;
  final VoidCallback onIncomeTap;
  final VoidCallback onExpenseTap;
  final VoidCallback onAddIncome;
  final VoidCallback onAddExpense;

  const FinancialSummary({
    super.key,
    required this.monthIncome,
    required this.monthExpenses,
    required this.onIncomeTap,
    required this.onExpenseTap,
    required this.onAddIncome,
    required this.onAddExpense,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SummaryCard(
            title: t.dashboard.income,
            amount: '\$${monthIncome.toStringAsFixed(2)}',
            icon: Icons.arrow_downward,
            color: const Color(0xFF2196F3),
            onTap: onIncomeTap,
            onAddTap: onAddIncome,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: SummaryCard(
            title: t.dashboard.expenses,
            amount: '\$${monthExpenses.toStringAsFixed(2)}',
            icon: Icons.arrow_upward,
            color: const Color(0xFF78909C),
            onTap: onExpenseTap,
            onAddTap: onAddExpense,
          ),
        ),
      ],
    );
  }
}
