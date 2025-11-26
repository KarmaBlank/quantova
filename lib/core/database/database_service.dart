import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../objectbox.g.dart'; // Generated ObjectBox code
import 'entities/category.dart';
import 'entities/transaction.dart';

class DatabaseService {
  late final Store store;
  late final Box<ExpenseTransaction> transactionBox;
  late final Box<Category> categoryBox;

  DatabaseService._create(this.store) {
    transactionBox = Box<ExpenseTransaction>(store);
    categoryBox = Box<Category>(store);
  }

  static Future<DatabaseService> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store = await openStore(directory: p.join(docsDir.path, 'objectbox'));
    return DatabaseService._create(store);
  }

  void close() {
    store.close();
  }
}
