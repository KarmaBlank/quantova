import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/database/entities/transaction.dart';
import '../../../../core/utils/date_filter_helper.dart';
import '../../domain/repositories/transaction_repository.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository _repository;

  TransactionBloc(this._repository) : super(TransactionInitial()) {
    on<LoadTransactions>(_onLoadTransactions);
    on<AddTransaction>(_onAddTransaction);
    on<DeleteTransaction>(_onDeleteTransaction);
    on<ChangeDateFilter>(_onChangeDateFilter);
    on<ChangeTypeFilter>(_onChangeTypeFilter);
  }

  Future<void> _onLoadTransactions(LoadTransactions event, Emitter<TransactionState> emit) async {
    emit(TransactionLoading());
    try {
      await emit.forEach(
        _repository.watchTransactions(),
        onData: (transactions) {
          // Default to current month if no state exists, otherwise keep existing selection
          final currentDate = state is TransactionLoaded ? (state as TransactionLoaded).selectedDate : DateTime.now();

          final currentFilter = state is TransactionLoaded ? (state as TransactionLoaded).filterType : null;

          return _calculateState(transactions, currentDate, currentFilter);
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
    try {
      await _repository.deleteTransaction(event.id);
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  void _onChangeDateFilter(ChangeDateFilter event, Emitter<TransactionState> emit) {
    if (state is TransactionLoaded) {
      final currentState = state as TransactionLoaded;
      emit(_calculateState(
        currentState.transactions,
        event.date,
        currentState.filterType,
      ));
    }
  }

  void _onChangeTypeFilter(ChangeTypeFilter event, Emitter<TransactionState> emit) {
    if (state is TransactionLoaded) {
      final currentState = state as TransactionLoaded;
      emit(_calculateState(
        currentState.transactions,
        currentState.selectedDate,
        event.type,
      ));
    }
  }

  TransactionLoaded _calculateState(
    List<ExpenseTransaction> transactions,
    DateTime selectedDate,
    TransactionType? filterType,
  ) {
    // Filter by date
    final dateFiltered = transactions.where((t) {
      return DateFilterType.customMonth.includes(t.date, customDate: selectedDate);
    }).toList();

    // Filter by type
    final typeFiltered = dateFiltered.where((t) {
      if (filterType != null && t.transactionType != filterType) return false;
      return true;
    }).toList();

    // Calculate totals based on date filtered transactions (for the month)
    double income = 0;
    double expenses = 0;
    for (var t in dateFiltered) {
      if (t.transactionType == TransactionType.income) {
        income += t.amount;
      } else {
        expenses += t.amount;
      }
    }

    return TransactionLoaded(
      transactions: transactions,
      filteredTransactions: typeFiltered,
      totalIncome: income,
      totalExpenses: expenses,
      balance: income - expenses,
      selectedDate: selectedDate,
      filterType: filterType,
    );
  }
}
