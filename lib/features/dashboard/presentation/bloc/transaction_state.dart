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
  final double totalIncome;
  final double totalExpenses;
  final double balance;

  const TransactionLoaded(this.transactions, this.totalIncome, this.totalExpenses, this.balance);

  @override
  List<Object> get props => [transactions, totalIncome, totalExpenses, balance];
}

class TransactionError extends TransactionState {
  final String message;

  const TransactionError(this.message);

  @override
  List<Object> get props => [message];
}
