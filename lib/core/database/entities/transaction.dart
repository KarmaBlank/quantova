import 'package:objectbox/objectbox.dart';

enum TransactionType { income, expense }

@Entity()
class ExpenseTransaction {
  @Id()
  int id = 0;

  int type; // 0 = income, 1 = expense

  double amount;

  @Property(type: PropertyType.date)
  DateTime date;

  String? description;

  String? category;

  String? receiptPath; // For expenses

  int? categoryId; // Foreign key to Category

  ExpenseTransaction({
    this.id = 0,
    required this.type,
    required this.amount,
    required this.date,
    this.description,
    this.category,
    this.receiptPath,
    this.categoryId,
  });

  TransactionType get transactionType => type == 0 ? TransactionType.income : TransactionType.expense;

  set transactionType(TransactionType value) {
    type = value == TransactionType.income ? 0 : 1;
  }
}
