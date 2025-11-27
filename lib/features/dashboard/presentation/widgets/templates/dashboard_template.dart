import 'package:flutter/material.dart';
import 'package:gastos_mensuales/i18n/strings.g.dart';

import '../../../../../core/database/entities/transaction.dart';
import '../atoms/filter_button.dart';
import '../molecules/month_selector.dart';
import '../organisms/daily_trend_chart.dart';
import '../organisms/dashboard_header.dart';
import '../organisms/financial_summary.dart';

class DashboardTemplate extends StatelessWidget {
  final double balance;
  final double globalSavingsPercentage;
  final double monthlySavingsPercentage;
  final double monthIncome;
  final double monthExpenses;
  final DateTime selectedDate;
  final ValueChanged<int> onMonthChange;
  final VoidCallback onIncomeTap;
  final VoidCallback onExpenseTap;
  final VoidCallback onAddIncome;
  final VoidCallback onAddExpense;
  final List<ExpenseTransaction> chartTransactions;
  final TransactionType? filterType;
  final ValueChanged<TransactionType?> onFilterChange;
  final Widget transactionsList;
  final VoidCallback onSeeAllTap;

  const DashboardTemplate({
    super.key,
    required this.balance,
    required this.globalSavingsPercentage,
    required this.monthlySavingsPercentage,
    required this.monthIncome,
    required this.monthExpenses,
    required this.selectedDate,
    required this.onMonthChange,
    required this.onIncomeTap,
    required this.onExpenseTap,
    required this.onAddIncome,
    required this.onAddExpense,
    required this.chartTransactions,
    required this.filterType,
    required this.onFilterChange,
    required this.transactionsList,
    required this.onSeeAllTap,
  });

  @override
  Widget build(BuildContext context) {
    // final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DashboardHeader(
            balance: balance,
            globalSavingsPercentage: globalSavingsPercentage,
            monthlySavingsPercentage: monthlySavingsPercentage,
          ),
          const SizedBox(height: 24),
          MonthSelector(
            selectedDate: selectedDate,
            onMonthChange: onMonthChange,
          ),
          const SizedBox(height: 16),
          FinancialSummary(
            monthIncome: monthIncome,
            monthExpenses: monthExpenses,
            onIncomeTap: onIncomeTap,
            onExpenseTap: onExpenseTap,
            onAddIncome: onAddIncome,
            onAddExpense: onAddExpense,
          ),
          const SizedBox(height: 24),
          DailyTrendChart(
            transactions: chartTransactions,
            selectedDate: selectedDate,
          ),
          const SizedBox(height: 24),
          // Filter Section
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilterButton(
                label: t.common.all,
                isSelected: filterType == null,
                onTap: () => onFilterChange(null),
              ),
              const SizedBox(width: 8),
              FilterButton(
                label: t.dashboard.income,
                isSelected: filterType == TransactionType.income,
                onTap: () => onFilterChange(TransactionType.income),
              ),
              const SizedBox(width: 8),
              FilterButton(
                label: t.dashboard.expenses,
                isSelected: filterType == TransactionType.expense,
                onTap: () => onFilterChange(TransactionType.expense),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                t.dashboard.recentTransactions,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: onSeeAllTap,
                child: Text(t.dashboard.seeAll),
              ),
            ],
          ),
          const SizedBox(height: 16),
          transactionsList,
        ],
      ),
    );
  }
}
