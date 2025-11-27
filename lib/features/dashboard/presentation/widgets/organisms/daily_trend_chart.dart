import 'package:flutter/material.dart';

import '../../../../../../core/database/entities/transaction.dart';
import '../../../../../../i18n/strings.g.dart';
import '../../../../reports/presentation/pages/charts_page.dart';
import '../atoms/chart_legend.dart';

class DailyTrendChart extends StatelessWidget {
  final List<ExpenseTransaction> transactions;
  final DateTime selectedDate;

  const DailyTrendChart({
    super.key,
    required this.transactions,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Get days in selected month
    final daysInMonth = DateUtils.getDaysInMonth(selectedDate.year, selectedDate.month);
    final days = List.generate(daysInMonth, (index) => DateTime(selectedDate.year, selectedDate.month, index + 1));

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
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ChartsPage()),
                  );
                },
                child: Text(t.dashboard.seeMoreCharts),
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
              ChartLegend(label: t.dashboard.income, color: const Color(0xFF2196F3)),
              ChartLegend(label: t.dashboard.expenses, color: const Color(0xFFEF5350)),
            ],
          ),
        ],
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
      final y = size.height * (i / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    if (incomePoints.isEmpty || expensePoints.isEmpty) return;

    final incomePaint = Paint()
      ..color = const Color(0xFF2196F3)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final expensePaint = Paint()
      ..color = const Color(0xFFEF5350)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final incomeAreaPaint = Paint()
      ..color = const Color(0xFF2196F3).withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final expenseAreaPaint = Paint()
      ..color = const Color(0xFFEF5350).withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final incomePath = Path();
    final incomeAreaPath = Path();
    final expensePath = Path();
    final expenseAreaPath = Path();

    final pointWidth = size.width / (incomePoints.length - 1);

    // Income line
    for (int i = 0; i < incomePoints.length; i++) {
      final x = i * pointWidth;
      final y = size.height - (incomePoints[i] / maxValue) * size.height;

      if (i == 0) {
        incomePath.moveTo(x, y);
        incomeAreaPath.moveTo(x, size.height);
        incomeAreaPath.lineTo(x, y);
      } else {
        incomePath.lineTo(x, y);
        incomeAreaPath.lineTo(x, y);
      }
    }

    incomeAreaPath.lineTo(size.width, size.height);
    incomeAreaPath.close();

    // Expense line
    for (int i = 0; i < expensePoints.length; i++) {
      final x = i * pointWidth;
      final y = size.height - (expensePoints[i] / maxValue) * size.height;

      if (i == 0) {
        expensePath.moveTo(x, y);
        expenseAreaPath.moveTo(x, size.height);
        expenseAreaPath.lineTo(x, y);
      } else {
        expensePath.lineTo(x, y);
        expenseAreaPath.lineTo(x, y);
      }
    }

    expenseAreaPath.lineTo(size.width, size.height);
    expenseAreaPath.close();

    // Draw areas first, then lines
    canvas.drawPath(incomeAreaPath, incomeAreaPaint);
    canvas.drawPath(expenseAreaPath, expenseAreaPaint);
    canvas.drawPath(incomePath, incomePaint);
    canvas.drawPath(expensePath, expensePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
