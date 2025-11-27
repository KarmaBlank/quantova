import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastos_mensuales/core/utils/category_helper.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../core/database/database_service.dart';
import '../../../../core/database/entities/category.dart';
import '../../../../core/database/entities/transaction.dart';
import '../../../../i18n/strings.g.dart';
import '../../../dashboard/presentation/bloc/transaction_bloc.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String? _receiptPath;
  List<Category> _categories = [];
  int? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final dbService = context.read<DatabaseService>();
    final allCategories = dbService.categoryBox.getAll();
    setState(() {
      // Exclude Salary category for expenses
      _categories = allCategories.where((cat) => cat.name != 'Salary').toList();
      if (_categories.isNotEmpty) {
        _selectedCategoryId = _categories.first.id;
      }
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _scanReceipt() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                t.expenses.selectImageSource,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Color(0xFF2196F3)),
                title: Text(t.expenses.camera),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Color(0xFF78909C)),
                title: Text(t.expenses.gallery),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _receiptPath = pickedFile.path;
      });
      _processImage(pickedFile.path);
    }
  }

  Future<void> _processImage(String path) async {
    final inputImage = InputImage.fromFilePath(path);
    final textRecognizer = TextRecognizer();

    try {
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

      final totalKeywords = ['total', 'amount due', 'balance', 'grand total', 'suma', 'importe', 'pagar'];
      double? detectedAmount;
      String? merchantName;

      // Detect merchant name from first few blocks
      if (recognizedText.blocks.isNotEmpty) {
        for (int i = 0; i < recognizedText.blocks.length.clamp(0, 3); i++) {
          final block = recognizedText.blocks[i];
          if (block.lines.isNotEmpty) {
            final firstLine = block.lines[0].text.trim();
            if (firstLine.isNotEmpty &&
                !firstLine.toLowerCase().contains('receipt') &&
                !firstLine.toLowerCase().contains('invoice') &&
                !firstLine.toLowerCase().contains('store') &&
                !firstLine.toLowerCase().contains('factura') &&
                firstLine.length > 3 &&
                firstLine.length < 50) {
              merchantName = firstLine;
              break;
            }
          }
        }
      }

      // Find amount near TOTAL keyword
      for (TextBlock block in recognizedText.blocks) {
        for (int i = 0; i < block.lines.length; i++) {
          final line = block.lines[i];
          final lineText = line.text.toLowerCase();

          bool hasKeyword = totalKeywords.any((keyword) => lineText.contains(keyword));

          if (hasKeyword) {
            for (int j = i; j < (i + 3).clamp(0, block.lines.length); j++) {
              final searchLine = block.lines[j].text;
              final numberPattern = RegExp(r'\$?\s*(\d{1,3}(?:[.,]\d{3})*(?:[.,]\d{2})?)');
              final matches = numberPattern.allMatches(searchLine);

              for (final match in matches) {
                String? numberStr = match.group(1);
                if (numberStr != null) {
                  if (numberStr.contains(',') && numberStr.indexOf(',') == numberStr.length - 3) {
                    numberStr = numberStr.replaceAll('.', '').replaceAll(',', '.');
                  } else {
                    numberStr = numberStr.replaceAll(',', '');
                  }

                  final amount = double.tryParse(numberStr);
                  if (amount != null && amount > 0 && amount < 100000) {
                    if (detectedAmount == null || (hasKeyword && j == i)) {
                      detectedAmount = amount;
                    }
                  }
                }
              }
            }
          }
        }
      }

      // Fallback: look for $ symbol
      if (detectedAmount == null) {
        for (TextBlock block in recognizedText.blocks) {
          for (TextLine line in block.lines) {
            if (line.text.contains('\$')) {
              final numberPattern = RegExp(r'\$\s*(\d{1,3}(?:[.,]\d{3})*(?:[.,]\d{2})?)');
              final match = numberPattern.firstMatch(line.text);
              if (match != null) {
                String? numberStr = match.group(1);
                if (numberStr != null) {
                  if (numberStr.contains(',') && numberStr.indexOf(',') == numberStr.length - 3) {
                    numberStr = numberStr.replaceAll('.', '').replaceAll(',', '.');
                  } else {
                    numberStr = numberStr.replaceAll(',', '');
                  }
                  final amount = double.tryParse(numberStr);
                  if (amount != null && amount > 0 && amount < 100000) {
                    detectedAmount = amount;
                  }
                }
              }
            }
          }
        }
      }

      if (detectedAmount != null || merchantName != null) {
        if (mounted) {
          setState(() {
            if (detectedAmount != null) {
              _amountController.text = detectedAmount.toStringAsFixed(2);
            }
            if (merchantName != null && _descriptionController.text.isEmpty) {
              _descriptionController.text = merchantName;
            }
          });

          String message = '';
          if (detectedAmount != null && merchantName != null) {
            message = '${t.expenses.detected}: $merchantName - \$${detectedAmount.toStringAsFixed(2)}';
          } else if (detectedAmount != null) {
            message = '${t.expenses.detectedAmount}: \$${detectedAmount.toStringAsFixed(2)}';
          } else if (merchantName != null) {
            message = '${t.expenses.detectedMerchant}: $merchantName';
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(t.expenses.noInfoDetected)),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${t.expenses.scanError}: $e')),
        );
      }
    } finally {
      textRecognizer.close();
    }
  }

  Future<void> _showCreateCategoryDialog() async {
    final nameController = TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Custom Category'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Category Name'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Create'),
          ),
        ],
      ),
    );

    if (result == true && nameController.text.isNotEmpty) {
      final dbService = context.read<DatabaseService>();
      final newCategory = Category(
        name: nameController.text,
        iconName: 'category',
        colorValue: 0xFF9E9E9E,
        isDefault: false,
      );
      dbService.categoryBox.put(newCategory);
      await _loadCategories();
      setState(() {
        _selectedCategoryId = newCategory.id;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final amount = double.parse(_amountController.text);
      final description = _descriptionController.text;

      final transaction = ExpenseTransaction(
        type: 1, // expense
        amount: amount,
        date: _selectedDate,
        description: description,
        category: _selectedCategoryId != null ? _categories.firstWhere((c) => c.id == _selectedCategoryId).name : null,
        receiptPath: _receiptPath,
        categoryId: _selectedCategoryId,
      );

      context.read<TransactionBloc>().add(AddTransaction(transaction));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: Text(t.expenses.addExpense),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: _scanReceipt,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? Colors.white24 : Colors.grey.shade300,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.camera_alt_rounded,
                          size: 32,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        t.expenses.scanReceipt,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (_receiptPath != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(t.expenses.receiptScanned, style: const TextStyle(color: Colors.green)),
                ),
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: t.expenses.amount,
                  prefixText: '\$ ',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return t.expenses.enterAmount;
                  }
                  if (double.tryParse(value) == null) {
                    return t.expenses.validNumber;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: t.expenses.description,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int?>(
                      value: _selectedCategoryId,
                      decoration: InputDecoration(
                        labelText: t.expenses.categoryOptional,
                      ),
                      items: [
                        DropdownMenuItem<int?>(
                          value: null,
                          child: Text(t.common.none),
                        ),
                        ..._categories.map((category) {
                          return DropdownMenuItem<int?>(
                            value: category.id,
                            child: Text(CategoryHelper.getLocalizedCategoryName(category.name)),
                          );
                        }),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedCategoryId = value;
                        });
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: _showCreateCategoryDialog,
                    tooltip: 'Create Custom Category',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text('${t.expenses.date}: ${DateFormat.yMMMd().format(_selectedDate)}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                ),
                child: Text(t.expenses.saveExpense),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
