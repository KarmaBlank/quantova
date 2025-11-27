part of 'transaction_bloc.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object> get props => [];
}

class LoadTransactions extends TransactionEvent {}

class AddTransaction extends TransactionEvent {
  final ExpenseTransaction transaction;

  const AddTransaction(this.transaction);

  @override
  List<Object> get props => [transaction];
}

class DeleteTransaction extends TransactionEvent {
  final int id;

  const DeleteTransaction(this.id);

  @override
  List<Object> get props => [id];
}

class ChangeDateFilter extends TransactionEvent {
  final DateTime date;

  const ChangeDateFilter(this.date);

  @override
  List<Object> get props => [date];
}

class ChangeTypeFilter extends TransactionEvent {
  final TransactionType? type;

  const ChangeTypeFilter(this.type);

  @override
  List<Object> get props => [type ?? ''];
}
