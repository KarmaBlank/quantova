import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../core/providers/theme_provider.dart';
import '../../../../core/utils/date_filter_helper.dart';
import '../../../../i18n/strings.g.dart';
import '../../../expenses/presentation/pages/expenses_page.dart';
import '../../../income/presentation/pages/income_page.dart';
import '../../../reports/presentation/pages/charts_page.dart';
import '../../../transactions/presentation/pages/transactions_page.dart';
import '../bloc/transaction_bloc.dart';
import '../widgets/organisms/transaction_list.dart';
import '../widgets/templates/dashboard_template.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: Text(t.dashboard.title),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.wb_sunny_outlined,
                    size: 20,
                    color: !themeProvider.isDarkMode ? const Color(0xFF2196F3) : Colors.grey,
                  ),
                  Switch(
                    value: themeProvider.isDarkMode,
                    onChanged: (_) => themeProvider.toggleTheme(),
                    thumbColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return const Color(0xFF2196F3);
                      }
                      return Colors.grey[400];
                    }),
                    trackColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return const Color(0xFF2196F3).withOpacity(0.5);
                      }
                      return Colors.grey[600];
                    }),
                  ),
                  Icon(
                    Icons.nightlight_round,
                    size: 20,
                    color: themeProvider.isDarkMode ? const Color(0xFF2196F3) : Colors.grey,
                  ),
                  const SizedBox(width: 8),
                ],
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChartsPage()),
              );
            },
            tooltip: 'Charts',
          ),
        ],
      ),
      body: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          if (state is TransactionLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TransactionLoaded) {
            // Calculate savings percentages
            final monthSavings = state.totalIncome - state.totalExpenses;
            final monthlySavingsPercentage = state.totalIncome > 0 ? ((monthSavings / state.totalIncome) * 100) : 0.0;
            final globalSavingsPercentage = state.totalIncome > 0 ? ((state.balance / state.totalIncome) * 100) : 0.0;

            return DashboardTemplate(
              balance: state.balance,
              globalSavingsPercentage: globalSavingsPercentage,
              monthlySavingsPercentage: monthlySavingsPercentage,
              monthIncome: state.totalIncome,
              monthExpenses: state.totalExpenses,
              selectedDate: state.selectedDate,
              onMonthChange: (months) {
                final newDate = DateTime(
                  state.selectedDate.year,
                  state.selectedDate.month + months,
                );
                context.read<TransactionBloc>().add(ChangeDateFilter(newDate));
              },
              onIncomeTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const IncomePage()),
                );
              },
              onExpenseTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ExpensesPage()),
                );
              },
              onAddIncome: () {
                // Navigate to IncomePage which has the form
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const IncomePage()),
                );
              },
              onAddExpense: () {
                // Navigate to ExpensesPage which has the form
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ExpensesPage()),
                );
              },
              chartTransactions: state.transactions.where((t) {
                return DateFilterType.customMonth.includes(t.date, customDate: state.selectedDate);
              }).toList(),
              filterType: state.filterType,
              onFilterChange: (type) {
                context.read<TransactionBloc>().add(ChangeTypeFilter(type));
              },
              transactionsList: TransactionList(
                transactions: state.filteredTransactions.take(5).toList(),
                isDark: isDark,
                onSeeAllTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TransactionsPage()),
                  );
                },
              ),
              onSeeAllTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TransactionsPage()),
                );
              },
            );
          }
          return Center(child: Text(t.common.errorLoadingData));
        },
      ),
    );
  }
}
