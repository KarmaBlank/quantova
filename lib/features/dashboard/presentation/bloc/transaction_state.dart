part of 'transaction_bloc.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object> get props => [];
}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionLoaded extends TransactionState {
  final List<ExpenseTransaction> transactions;
  final List<ExpenseTransaction> filteredTransactions;
  final double totalIncome;
  final double totalExpenses;
  final double balance;
  final DateTime selectedDate;
  final TransactionType? filterType;

  const TransactionLoaded({
    required this.transactions,
    required this.filteredTransactions,
    required this.totalIncome,
    required this.totalExpenses,
    required this.balance,
    required this.selectedDate,
    this.filterType,
  });

  TransactionLoaded copyWith({
    List<ExpenseTransaction>? transactions,
    List<ExpenseTransaction>? filteredTransactions,
    double? totalIncome,
    double? totalExpenses,
    double? balance,
    DateTime? selectedDate,
    TransactionType? filterType,
  }) {
    return TransactionLoaded(
      transactions: transactions ?? this.transactions,
      filteredTransactions: filteredTransactions ?? this.filteredTransactions,
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpenses: totalExpenses ?? this.totalExpenses,
      balance: balance ?? this.balance,
      selectedDate: selectedDate ?? this.selectedDate,
      filterType: filterType ?? this.filterType,
    );
  }

  @override
  List<Object> get props => [
        transactions,
        filteredTransactions,
        totalIncome,
        totalExpenses,
        balance,
        selectedDate,
        filterType ?? '',
      ];
}

class TransactionError extends TransactionState {
  final String message;

  const TransactionError(this.message);

  @override
  List<Object> get props => [message];
}
