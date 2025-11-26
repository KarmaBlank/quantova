import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/database/database_service.dart';
import '../../../../core/database/entities/category.dart' as db;
import '../../../../core/database/entities/transaction.dart';
import '../../../../core/widgets/transaction_card.dart';
import '../../../../i18n/strings.g.dart';
import '../../../dashboard/presentation/bloc/transaction_bloc.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  TransactionType? _filterType;
  int? _filterCategoryId;
  DateTimeRange? _dateRange;
  List<db.Category> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final dbService = context.read<DatabaseService>();
    final categories = dbService.categoryBox.getAll();
    setState(() {
      _categories = categories;
    });
  }

  void _clearFilters() {
    setState(() {
      _filterType = null;
      _filterCategoryId = null;
      _dateRange = null;
    });
  }

  Future<void> _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDateRange: _dateRange,
    );
    if (picked != null) {
      setState(() {
        _dateRange = picked;
      });
    }
  }

  List<ExpenseTransaction> _applyFilters(List<ExpenseTransaction> transactions) {
    var filtered = transactions;

    if (_filterType != null) {
      filtered = filtered.where((t) => t.transactionType == _filterType).toList();
    }

    if (_filterCategoryId != null) {
      filtered = filtered.where((t) => t.categoryId == _filterCategoryId).toList();
    }

    if (_dateRange != null) {
      filtered = filtered.where((t) {
        return t.date.isAfter(_dateRange!.start.subtract(const Duration(days: 1))) &&
            t.date.isBefore(_dateRange!.end.add(const Duration(days: 1)));
      }).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text('All Transactions'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          if (state is TransactionLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TransactionLoaded) {
            final filteredTransactions = _applyFilters(state.transactions);

            return Column(
              children: [
                // Filters Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDark ? 0.3 : 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Filters',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Type Filter
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<TransactionType?>(
                              value: _filterType,
                              decoration: InputDecoration(
                                labelText: 'Type',
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                fillColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                                filled: true,
                              ),
                              dropdownColor: isDark ? const Color(0xFF2C2C2C) : null,
                              items: [
                                const DropdownMenuItem(value: null, child: Text('All')),
                                DropdownMenuItem(
                                  value: TransactionType.income,
                                  child: Text(t.transactions.income),
                                ),
                                DropdownMenuItem(
                                  value: TransactionType.expense,
                                  child: Text(t.transactions.expense),
                                ),
                              ],
                              onChanged: (value) => setState(() => _filterType = value),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Category Filter
                          Expanded(
                            child: DropdownButtonFormField<int?>(
                              value: _filterCategoryId,
                              decoration: InputDecoration(
                                labelText: 'Category',
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                fillColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                                filled: true,
                              ),
                              dropdownColor: isDark ? const Color(0xFF2C2C2C) : null,
                              items: [
                                const DropdownMenuItem(value: null, child: Text('All')),
                                ..._categories.map((cat) => DropdownMenuItem(
                                      value: cat.id,
                                      child: Text(cat.name ?? 'Unnamed'),
                                    )),
                              ],
                              onChanged: (value) => setState(() => _filterCategoryId = value),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Date Range and Clear
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _selectDateRange,
                              icon: const Icon(Icons.date_range),
                              label: Text(
                                _dateRange == null
                                    ? 'Select Date Range'
                                    : '${DateFormat.MMMd().format(_dateRange!.start)} - ${DateFormat.MMMd().format(_dateRange!.end)}',
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          OutlinedButton.icon(
                            onPressed: _clearFilters,
                            icon: const Icon(Icons.clear),
                            label: const Text('Clear'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Results Count
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    '${filteredTransactions.length} transactions',
                    style: TextStyle(
                      color: isDark ? Colors.white54 : Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                // Transactions List
                Expanded(
                  child: filteredTransactions.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.receipt_long, size: 64, color: isDark ? Colors.white24 : Colors.grey[300]),
                              const SizedBox(height: 16),
                              Text(
                                'No transactions found',
                                style: TextStyle(color: isDark ? Colors.white54 : Colors.grey[600], fontSize: 16),
                              ),
                            ],
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          child: ListView.separated(
                            padding: EdgeInsets.zero,
                            itemCount: filteredTransactions.length,
                            separatorBuilder: (context, index) => Divider(
                              height: 1,
                              color: isDark ? Colors.white10 : Colors.grey[200],
                            ),
                            itemBuilder: (context, index) {
                              final transaction = filteredTransactions[index];
                              return TransactionCard(
                                transaction: transaction,
                                onLongPress: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text('Delete Transaction'),
                                      content: const Text('Are you sure you want to delete this transaction?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(ctx),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            context.read<TransactionBloc>().add(DeleteTransaction(transaction.id));
                                            Navigator.pop(ctx);
                                          },
                                          child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                ),
              ],
            );
          }
          return const Center(child: Text('Error loading transactions'));
        },
      ),
    );
  }
}
