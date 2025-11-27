import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/database/entities/transaction.dart';
import '../../../../core/utils/date_filter_helper.dart';
import '../../../../core/utils/report_generator.dart';
import '../../../../i18n/strings.g.dart';
import '../../../dashboard/presentation/bloc/transaction_bloc.dart';
import '../../../dashboard/presentation/widgets/atoms/filter_button.dart';

class ChartsPage extends StatefulWidget {
  const ChartsPage({super.key});

  @override
  State<ChartsPage> createState() => _ChartsPageState();
}

class _ChartsPageState extends State<ChartsPage> {
  DateFilterType _selectedFilter = DateFilterType.currentMonth;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: Text(t.dashboard.chartsAndAnalytics),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          const SizedBox(width: 8),
          PopupMenuButton<String>(
            onSelected: (value) async {
              final state = context.read<TransactionBloc>().state;
              if (state is TransactionLoaded) {
                if (value == 'pdf') {
                  await ReportGenerator.generatePdf(state.transactions);
                } else if (value == 'excel') {
                  await ReportGenerator.generateExcel(state.transactions);
                }
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(value: 'pdf', child: Text(t.dashboard.exportToPdf)),
                PopupMenuItem(value: 'excel', child: Text(t.dashboard.exportToExcel)),
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Sticky Filter Buttons
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF121212) : const Color(0xFFFAFAFA),
              border: Border(
                bottom: BorderSide(
                  color: isDark ? Colors.white10 : Colors.grey[200]!,
                ),
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: DateFilterType.values
                    .where((type) => type != DateFilterType.customMonth)
                    .map((type) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterButton(
                            label: type.label,
                            isSelected: _selectedFilter == type,
                            onTap: () => setState(() => _selectedFilter = type),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
          // Scrollable Content
          Expanded(
            child: BlocBuilder<TransactionBloc, TransactionState>(
              builder: (context, state) {
                if (state is TransactionLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TransactionLoaded) {
                  // Filter transactions based on selected period
                  final filteredTransactions = state.transactions.where((t) {
                    return _selectedFilter.includes(t.date);
                  }).toList();

                  if (filteredTransactions.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.bar_chart, size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            '${t.dashboard.noDataForPeriod}: ${_selectedFilter.label}',
                            style: TextStyle(color: Colors.grey[600], fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildExpensesByCategoryChart(filteredTransactions),
                        const SizedBox(height: 24),
                        _buildMonthlyTrendChart(filteredTransactions),
                        const SizedBox(height: 24),
                        _buildExpenseDistributionChart(filteredTransactions),
                      ],
                    ),
                  );
                }
                return Center(child: Text(t.common.errorLoadingData));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpensesByCategoryChart(List<ExpenseTransaction> transactions) {
    final expenses = transactions.where((t) => t.transactionType == TransactionType.expense).toList();

    final Map<String, double> categoryTotals = {};
    for (var expense in expenses) {
      final category = expense.category ?? t.common.uncategorized;
      categoryTotals[category] = (categoryTotals[category] ?? 0) + expense.amount;
    }

    final sortedCategories = categoryTotals.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final topCategories = sortedCategories.take(6).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.common.expensesByCategory,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 250,
              child: topCategories.isEmpty
                  ? Center(child: Text(t.common.noExpenseData))
                  : BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: topCategories.first.value * 1.2,
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              return BarTooltipItem(
                                '${topCategories[group.x.toInt()].key}\n\$${rod.toY.toStringAsFixed(2)}',
                                const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              );
                            },
                          ),
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                if (value.toInt() >= topCategories.length) return const Text('');
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    topCategories[value.toInt()].key.length > 8
                                        ? '${topCategories[value.toInt()].key.substring(0, 8)}...'
                                        : topCategories[value.toInt()].key,
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                );
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                return Text('\$${value.toInt()}', style: const TextStyle(fontSize: 10));
                              },
                            ),
                          ),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: List.generate(
                          topCategories.length,
                          (index) => BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: topCategories[index].value,
                                color: const Color(0xFF78909C),
                                width: 20,
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyTrendChart(List<ExpenseTransaction> transactions) {
    // Determine number of months based on filter or default to 6
    int monthsToShow = 6;
    if (_selectedFilter == DateFilterType.last3Months) monthsToShow = 3;
    if (_selectedFilter == DateFilterType.lastYear) monthsToShow = 12;
    if (_selectedFilter == DateFilterType.currentMonth) monthsToShow = 1;

    final now = DateTime.now();
    final months = List.generate(monthsToShow, (i) => DateTime(now.year, now.month - i, 1)).reversed.toList();

    final Map<String, double> monthlyIncome = {};
    final Map<String, double> monthlyExpenses = {};

    for (var month in months) {
      final monthKey = DateFormat('MMM').format(month);
      monthlyIncome[monthKey] = 0;
      monthlyExpenses[monthKey] = 0;
    }

    for (var transaction in transactions) {
      final monthKey = DateFormat('MMM').format(transaction.date);
      if (monthlyIncome.containsKey(monthKey)) {
        if (transaction.transactionType == TransactionType.income) {
          monthlyIncome[monthKey] = monthlyIncome[monthKey]! + transaction.amount;
        } else {
          monthlyExpenses[monthKey] = monthlyExpenses[monthKey]! + transaction.amount;
        }
      }
    }

    // Calculate maxY safely
    double maxY = 100.0;
    final allValues = [...monthlyIncome.values, ...monthlyExpenses.values];
    if (allValues.isNotEmpty && allValues.any((v) => v > 0)) {
      maxY = allValues.reduce((a, b) => a > b ? a : b) * 1.2;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${t.common.monthlyTrend} (${_selectedFilter.label})',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 250,
              child: LineChart(
                LineChartData(
                  maxY: maxY,
                  minY: 0,
                  lineBarsData: [
                    LineChartBarData(
                      spots: monthlyIncome.entries
                          .toList()
                          .asMap()
                          .entries
                          .map((e) => FlSpot(e.key.toDouble(), e.value.value))
                          .toList(),
                      isCurved: true,
                      color: const Color(0xFF2196F3),
                      barWidth: 3,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: const Color(0xFF2196F3).withOpacity(0.1),
                      ),
                    ),
                    LineChartBarData(
                      spots: monthlyExpenses.entries
                          .toList()
                          .asMap()
                          .entries
                          .map((e) => FlSpot(e.key.toDouble(), e.value.value))
                          .toList(),
                      isCurved: true,
                      color: const Color(0xFFEF5350),
                      barWidth: 3,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: const Color(0xFFEF5350).withOpacity(0.1),
                      ),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final months = monthlyIncome.keys.toList();
                          if (value.toInt() >= months.length) return const Text('');
                          return Text(months[value.toInt()], style: const TextStyle(fontSize: 10));
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text('\$${value.toInt()}', style: const TextStyle(fontSize: 10));
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: maxY / 5 > 0 ? maxY / 5 : 1,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem('Income', const Color(0xFF2196F3)),
                const SizedBox(width: 24),
                _buildLegendItem('Expenses', const Color(0xFFEF5350)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseDistributionChart(List<ExpenseTransaction> transactions) {
    final expenses = transactions.where((t) => t.transactionType == TransactionType.expense).toList();

    final Map<String, double> categoryTotals = {};
    for (var expense in expenses) {
      final category = expense.category ?? 'Uncategorized';
      categoryTotals[category] = (categoryTotals[category] ?? 0) + expense.amount;
    }

    final total = categoryTotals.values.fold<double>(0, (sum, val) => sum + val);
    if (total == 0) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                t.common.expenseDistribution,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              Text(t.common.noExpenseData),
            ],
          ),
        ),
      );
    }

    final colors = [
      const Color(0xFF2196F3),
      const Color(0xFFEF5350),
      const Color(0xFF4CAF50),
      const Color(0xFFFF9800),
      const Color(0xFF9C27B0),
      const Color(0xFF00BCD4),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Expense Distribution',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 250,
              child: PieChart(
                PieChartData(
                  sections: categoryTotals.entries.toList().asMap().entries.map((entry) {
                    final index = entry.key;
                    final category = entry.value;
                    final percentage = (category.value / total * 100);

                    return PieChartSectionData(
                      value: category.value,
                      title: '${percentage.toStringAsFixed(1)}%',
                      color: colors[index % colors.length],
                      radius: 100,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                  sectionsSpace: 2,
                  centerSpaceRadius: 0,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: categoryTotals.entries.toList().asMap().entries.map((entry) {
                final index = entry.key;
                final category = entry.value;
                return _buildLegendItem(category.key, colors[index % colors.length]);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
