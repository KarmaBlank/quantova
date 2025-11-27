import 'dart:io';

import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../database/entities/transaction.dart';

class ReportGenerator {
  static Future<void> generatePdf(List<ExpenseTransaction> transactions) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text('Monthly Expense Report', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                context: context,
                data: <List<String>>[
                  <String>['Date', 'Type', 'Category', 'Description', 'Amount'],
                  ...transactions.map((t) => [
                        DateFormat.yMMMd().format(t.date),
                        t.transactionType.name.toUpperCase(),
                        t.category ?? '',
                        t.description ?? '',
                        '\$${t.amount.toStringAsFixed(2)}',
                      ]),
                ],
              ),
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/expense_report_${DateTime.now().millisecondsSinceEpoch}.pdf");
    await file.writeAsBytes(await pdf.save());

    // Share the file
    await Share.shareXFiles(
      [XFile(file.path)],
      subject: 'Expense Report',
      text: 'Monthly expense report generated on ${DateFormat.yMMMd().format(DateTime.now())}',
    );
  }

  static Future<void> generateExcel(List<ExpenseTransaction> transactions) async {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];

    sheetObject.appendRow([
      TextCellValue('Date'),
      TextCellValue('Type'),
      TextCellValue('Category'),
      TextCellValue('Description'),
      TextCellValue('Amount'),
    ]);

    for (var t in transactions) {
      sheetObject.appendRow([
        TextCellValue(DateFormat.yMMMd().format(t.date)),
        TextCellValue(t.transactionType.name.toUpperCase()),
        TextCellValue(t.category ?? ''),
        TextCellValue(t.description ?? ''),
        DoubleCellValue(t.amount),
      ]);
    }

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/expense_report_${DateTime.now().millisecondsSinceEpoch}.xlsx");
    final fileBytes = excel.save();
    if (fileBytes != null) {
      await file.writeAsBytes(fileBytes);
    }

    // Share the file
    await Share.shareXFiles(
      [XFile(file.path)],
      subject: 'Expense Report',
      text: 'Monthly expense report generated on ${DateFormat.yMMMd().format(DateTime.now())}',
    );
  }
}
