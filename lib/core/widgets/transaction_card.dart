import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../i18n/strings.g.dart';
import '../database/entities/transaction.dart';
import '../utils/category_helper.dart';

class TransactionCard extends StatelessWidget {
  final ExpenseTransaction transaction;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const TransactionCard({
    super.key,
    required this.transaction,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.transactionType == TransactionType.income;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFEF5350),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.delete_outline,
          color: Colors.white,
          size: 24,
        ),
      ),
      confirmDismiss: (direction) async {
        final bool? result = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(t.transactions.deleteTransaction),
              content: Text('${t.common.delete}?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(t.common.cancel),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFFEF5350),
                  ),
                  child: Text(t.common.delete),
                ),
              ],
            );
          },
        );

        if (result == true && onDelete != null) {
          onDelete!();
          return true;
        }
        return result;
      },
      onDismissed: (direction) {},
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:
                        isIncome ? const Color(0xFF2196F3).withOpacity(0.1) : const Color(0xFF78909C).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                    color: isIncome ? const Color(0xFF2196F3) : const Color(0xFF78909C),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction.description ?? t.common.noDescription,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            DateFormat.yMMMd().format(transaction.date),
                            style: TextStyle(
                              color: isDark ? Colors.white54 : Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: (isIncome ? const Color(0xFF2196F3) : const Color(0xFF78909C)).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                transaction.category != null
                                    ? CategoryHelper.getLocalizedCategoryName(transaction.category!)
                                    : (isIncome ? t.transactions.income : t.transactions.expense),
                                style: TextStyle(
                                  color: isIncome ? const Color(0xFF2196F3) : const Color(0xFF78909C),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  '${isIncome ? '+' : '-'}\$${transaction.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: isIncome ? const Color(0xFF2196F3) : const Color(0xFF78909C),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
