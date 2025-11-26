import '../../../../core/database/database_service.dart';
import '../../../../core/database/entities/transaction.dart';

abstract class TransactionRepository {
  Future<void> addTransaction(ExpenseTransaction transaction);
  Future<List<ExpenseTransaction>> getTransactions();
  Future<void> deleteTransaction(int id);
  Stream<List<ExpenseTransaction>> watchTransactions();
}

class TransactionRepositoryImpl implements TransactionRepository {
  final DatabaseService _databaseService;

  TransactionRepositoryImpl(this._databaseService);

  @override
  Future<void> addTransaction(ExpenseTransaction transaction) async {
    _databaseService.transactionBox.put(transaction);
  }

  @override
  Future<List<ExpenseTransaction>> getTransactions() async {
    return _databaseService.transactionBox.getAll();
  }

  @override
  Future<void> deleteTransaction(int id) async {
    _databaseService.transactionBox.remove(id);
  }

  @override
  Stream<List<ExpenseTransaction>> watchTransactions() {
    // ObjectBox doesn't have built-in reactive streams like Isar
    // We'll need to implement a simple polling or use a StreamController
    // For now, return a stream that emits the current list
    return Stream.periodic(const Duration(milliseconds: 500), (_) {
      return _databaseService.transactionBox.getAll();
    });
  }
}
