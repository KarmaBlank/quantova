import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/database/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository _repository;

  TransactionBloc(this._repository) : super(TransactionInitial()) {
    on<LoadTransactions>(_onLoadTransactions);
    on<AddTransaction>(_onAddTransaction);
    on<DeleteTransaction>(_onDeleteTransaction);
  }

  Future<void> _onLoadTransactions(LoadTransactions event, Emitter<TransactionState> emit) async {
    emit(TransactionLoading());
    try {
      await emit.forEach(
        _repository.watchTransactions(),
        onData: (transactions) {
          double income = 0;
          double expenses = 0;
          for (var t in transactions) {
            if (t.transactionType == TransactionType.income) {
              income += t.amount;
            } else {
              expenses += t.amount;
            }
          }
          return TransactionLoaded(transactions, income, expenses, income - expenses);
        },
        onError: (error, stackTrace) => TransactionError(error.toString()),
      );
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  Future<void> _onAddTransaction(AddTransaction event, Emitter<TransactionState> emit) async {
    try {
      await _repository.addTransaction(event.transaction);
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  Future<void> _onDeleteTransaction(DeleteTransaction event, Emitter<TransactionState> emit) async {
    final currentState = state;
    if (currentState is TransactionLoaded) {
      // Optimistic update: Remove item immediately from state
      final updatedTransactions = currentState.transactions.where((t) => t.id != event.id).toList();

      double income = 0;
      double expenses = 0;
      for (var t in updatedTransactions) {
        if (t.transactionType == TransactionType.income) {
          income += t.amount;
        } else {
          expenses += t.amount;
        }
      }

      emit(TransactionLoaded(updatedTransactions, income, expenses, income - expenses));
    }

    try {
      await _repository.deleteTransaction(event.id);
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }
}
