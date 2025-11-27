import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastos_mensuales/i18n/strings.g.dart';

import '../../../../../../core/database/entities/transaction.dart';
import '../../../../../../core/widgets/transaction_card.dart';
import '../../bloc/transaction_bloc.dart';

class TransactionList extends StatefulWidget {
  final List<ExpenseTransaction> transactions;
  final bool isDark;
  final VoidCallback onSeeAllTap;

  const TransactionList({
    super.key,
    required this.transactions,
    required this.isDark,
    required this.onSeeAllTap,
  });

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  List<ExpenseTransaction> _localTransactions = [];

  @override
  void initState() {
    super.initState();
    _localTransactions = List.from(widget.transactions);
  }

  @override
  void didUpdateWidget(TransactionList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.transactions != oldWidget.transactions) {
      _localTransactions = List.from(widget.transactions);
    }
  }

  void _removeTransactionLocally(int transactionId) {
    setState(() {
      _localTransactions.removeWhere((t) => t.id == transactionId);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_localTransactions.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(48),
        decoration: BoxDecoration(
          color: widget.isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.receipt_long, size: 48, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                t.dashboard.noTransactions,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: widget.isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _localTransactions.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          color: widget.isDark ? Colors.white10 : Colors.grey[200],
        ),
        itemBuilder: (context, index) {
          final transaction = _localTransactions[index];
          return TransactionCard(
            transaction: transaction,
            onTap: () {
              // TODO: Navigate to transaction detail
            },
            onDelete: () {
              // Remove locally first (synchronously)
              _removeTransactionLocally(transaction.id);
              // Then remove from database via BLoC
              context.read<TransactionBloc>().add(DeleteTransaction(transaction.id));
            },
          );
        },
      ),
    );
  }
}
