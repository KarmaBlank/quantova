import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastos_mensuales/i18n/strings.g.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/database/entities/transaction.dart';
import '../../../../core/providers/theme_provider.dart';
import '../../../../core/utils/date_filter_helper.dart';
import '../../../../core/widgets/transaction_card.dart';
import '../../../expenses/presentation/pages/expenses_page.dart';
import '../../../income/presentation/pages/income_page.dart';
import '../../../reports/presentation/pages/charts_page.dart';
import '../../../transactions/presentation/pages/transactions_page.dart';
import '../bloc/transaction_bloc.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  TransactionType? _filterType;
  DateTime _selectedDate = DateTime.now();

  void _changeMonth(int months) {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + months);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text('Dashboard'),
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
            // Filter by date first
            final dateFilteredTransactions = state.transactions.where((t) {
              return DateFilterType.customMonth.includes(t.date, customDate: _selectedDate);
            }).toList();

            // Then apply type filter if any
            final displayTransactions = dateFilteredTransactions.where((t) {
              if (_filterType != null && t.transactionType != _filterType) return false;
              return true;
            }).toList();

            // Calculate totals for the selected month
            double monthIncome = 0;
            double monthExpenses = 0;
            for (var t in dateFilteredTransactions) {
              if (t.transactionType == TransactionType.income) {
                monthIncome += t.amount;
              } else {
                monthExpenses += t.amount;
              }
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderCard(context, state, monthIncome, monthExpenses), // Balance global, Savings monthly
                  const SizedBox(height: 24),
                  _buildMonthSelector(isDark),
                  const SizedBox(height: 16),
                  _buildFinancialSummary(context, monthIncome, monthExpenses),
                  const SizedBox(height: 24),
                  _buildMiniChart(context, dateFilteredTransactions),
                  const SizedBox(height: 24),
                  // Filter Section
                  Row(
                    children: [
                      const Text(
                        'Filter',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF9E9E9E),
                        ),
                      ),
                      const SizedBox(width: 16),
                      _buildFilterButton('All', _filterType == null, () {
                        setState(() => _filterType = null);
                      }),
                      const SizedBox(width: 8),
                      _buildFilterButton('Income', _filterType == TransactionType.income, () {
                        setState(() => _filterType = TransactionType.income);
                      }),
                      const SizedBox(width: 8),
                      _buildFilterButton('Expenses', _filterType == TransactionType.expense, () {
                        setState(() => _filterType = TransactionType.expense);
                      }),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Transactions',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const TransactionsPage()),
                          );
                        },
                        child: const Text('See all'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildTransactionList(displayTransactions.take(5).toList()),
                ],
              ),
            );
          }
          return const Center(child: Text('Error loading transactions'));
        },
      ),
    );
  }

  Widget _buildMonthSelector(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => _changeMonth(-1),
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
            DateFormat('MMMM yyyy').format(_selectedDate),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: () => _changeMonth(1),
          color: isDark ? Colors.white70 : Colors.black54,
        ),
      ],
    );
  }

  Widget _buildHeaderCard(BuildContext context, TransactionLoaded state, double monthIncome, double monthExpenses) {
    final t = Translations.of(context);
    // Calculate savings for the selected period
    final monthSavings = monthIncome - monthExpenses;
    final periodSavingsPercentage = monthIncome > 0 ? ((monthSavings / monthIncome) * 100) : 0.0;

    // Calculate global savings
    final globalSavingsPercentage = state.totalIncome > 0 ? ((state.balance / state.totalIncome) * 100) : 0.0;

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
            '\$${state.balance.toStringAsFixed(2)}',
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
                child: _buildSavingsIndicator(
                  context,
                  t.dashboard.globalSavings,
                  globalSavingsPercentage,
                  Icons.public,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSavingsIndicator(
                  context,
                  t.dashboard.monthlySavings,
                  periodSavingsPercentage,
                  Icons.calendar_today,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSavingsIndicator(BuildContext context, String label, double percentage, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white70, size: 14),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${percentage.toStringAsFixed(0)}%',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialSummary(BuildContext context, double income, double expenses) {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            t.dashboard.income,
            income,
            Icons.arrow_downward,
            const Color(0xFF2196F3),
            onAdd: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const IncomePage())),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSummaryCard(
            t.dashboard.expenses,
            expenses,
            Icons.arrow_upward,
            const Color(0xFF78909C),
            onAdd: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ExpensesPage())),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String label, double amount, IconData icon, Color color, {required VoidCallback onAdd}) {
    final t = Translations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              TextButton(
                onPressed: onAdd,
                style: TextButton.styleFrom(
                  backgroundColor: color.withOpacity(0.1),
                  foregroundColor: color,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  label == t.dashboard.income ? t.dashboard.addIncome : t.dashboard.addExpense,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              color: isDark ? Colors.white54 : Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniChart(BuildContext context, List<ExpenseTransaction> transactions) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Get days in selected month
    final daysInMonth = DateUtils.getDaysInMonth(_selectedDate.year, _selectedDate.month);
    final days = List.generate(daysInMonth, (index) => DateTime(_selectedDate.year, _selectedDate.month, index + 1));

    // Calculate daily totals for income and expenses
    final dailyIncome = days.map((day) {
      final dayTransactions = transactions.where((t) {
        return t.transactionType == TransactionType.income &&
            t.date.year == day.year &&
            t.date.month == day.month &&
            t.date.day == day.day;
      });
      return dayTransactions.fold<double>(0, (sum, t) => sum + t.amount);
    }).toList();

    final dailyExpenses = days.map((day) {
      final dayTransactions = transactions.where((t) {
        return t.transactionType == TransactionType.expense &&
            t.date.year == day.year &&
            t.date.month == day.month &&
            t.date.day == day.day;
      });
      return dayTransactions.fold<double>(0, (sum, t) => sum + t.amount);
    }).toList();

    double maxIncome =
        dailyIncome.isEmpty || dailyIncome.every((v) => v == 0) ? 0.0 : dailyIncome.reduce((a, b) => a > b ? a : b);
    double maxExpense = dailyExpenses.isEmpty || dailyExpenses.every((v) => v == 0)
        ? 0.0
        : dailyExpenses.reduce((a, b) => a > b ? a : b);

    double maxValue = (maxIncome > maxExpense ? maxIncome : maxExpense);
    if (maxValue == 0) maxValue = 100.0;
    maxValue *= 1.2; // Add 20% buffer

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                t.dashboard.dailyTrend,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Line chart
          SizedBox(
            height: 120,
            child: CustomPaint(
              size: const Size(double.infinity, 120),
              painter: _LineChartPainter(
                incomePoints: dailyIncome,
                expensePoints: dailyExpenses,
                maxValue: maxValue,
                isDark: isDark,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // X-axis labels (Show every 5 days to avoid clutter)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (index) {
              final dayIndex = (index * 5);
              if (dayIndex >= days.length) return const SizedBox();
              final day = days[dayIndex];
              return Text(
                '${day.day}',
                style: TextStyle(
                  fontSize: 10,
                  color: isDark ? Colors.white38 : Colors.grey[500],
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildChartLegend(t.dashboard.income, const Color(0xFF2196F3)),
              _buildChartLegend(t.dashboard.expenses, const Color(0xFFEF5350)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartLegend(String label, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: isDark ? Colors.white70 : Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildFilterButton(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF212121) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF212121) : const Color(0xFFE0E0E0),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF757575),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionList(List<ExpenseTransaction> transactions) {
    if (transactions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text(t.dashboard.noTransactions),
        ),
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: transactions.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          color: isDark ? Colors.white10 : Colors.grey[200],
        ),
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return TransactionCard(
            transaction: transaction,
            onTap: () {
              // TODO: Navigate to transaction detail
            },
          );
        },
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> incomePoints;
  final List<double> expensePoints;
  final double maxValue;
  final bool isDark;

  _LineChartPainter({
    required this.incomePoints,
    required this.expensePoints,
    required this.maxValue,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = (isDark ? Colors.white : Colors.grey).withOpacity(0.1)
      ..strokeWidth = 1;

    // Draw horizontal grid lines
    for (int i = 0; i <= 4; i++) {
      final y = (size.height / 4) * i;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }

    // Draw Income Line (Blue)
    _drawLine(canvas, size, incomePoints, const Color(0xFF2196F3), true // fill
        );

    // Draw Expense Line (Red)
    _drawLine(canvas, size, expensePoints, const Color(0xFFEF5350), false // no fill to avoid clutter
        );
  }

  void _drawLine(Canvas canvas, Size size, List<double> points, Color color, bool withFill) {
    if (points.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();
    final chartPoints = <Offset>[];

    // Calculate points
    for (int i = 0; i < points.length; i++) {
      final x = (size.width / (points.length - 1)) * i;
      final normalizedValue = maxValue > 0 ? points[i] / maxValue : 0;
      final y = size.height - (normalizedValue * size.height * 0.85);
      chartPoints.add(Offset(x, y));
    }

    if (chartPoints.isNotEmpty) {
      path.moveTo(chartPoints[0].dx, chartPoints[0].dy);
      if (withFill) {
        fillPath.moveTo(chartPoints[0].dx, size.height);
        fillPath.lineTo(chartPoints[0].dx, chartPoints[0].dy);
      }

      for (int i = 0; i < chartPoints.length - 1; i++) {
        final p0 = i > 0 ? chartPoints[i - 1] : chartPoints[i];
        final p1 = chartPoints[i];
        final p2 = chartPoints[i + 1];
        final p3 = i < chartPoints.length - 2 ? chartPoints[i + 2] : p2;

        final cp1x = p1.dx + (p2.dx - p0.dx) / 6;
        final cp1y = p1.dy + (p2.dy - p0.dy) / 6;
        final cp2x = p2.dx - (p3.dx - p1.dx) / 6;
        final cp2y = p2.dy - (p3.dy - p1.dy) / 6;

        path.cubicTo(cp1x, cp1y, cp2x, cp2y, p2.dx, p2.dy);
        if (withFill) {
          fillPath.cubicTo(cp1x, cp1y, cp2x, cp2y, p2.dx, p2.dy);
        }
      }

      if (withFill) {
        fillPath.lineTo(chartPoints.last.dx, size.height);
        fillPath.close();

        final fillPaint = Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              color.withOpacity(0.15),
              color.withOpacity(0.0),
            ],
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
          ..style = PaintingStyle.fill;

        canvas.drawPath(fillPath, fillPaint);
      }

      canvas.drawPath(path, paint);

      // Draw dots
      for (final point in chartPoints) {
        canvas.drawCircle(point, 4, dotPaint);
        canvas.drawCircle(point, 2, Paint()..color = isDark ? const Color(0xFF1E1E1E) : Colors.white);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
