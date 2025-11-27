import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastos_mensuales/core/utils/category_helper.dart';
import 'package:intl/intl.dart';

import '../../../../core/database/database_service.dart';
import '../../../../core/database/entities/category.dart';
import '../../../../core/database/entities/transaction.dart';
import '../../../../i18n/strings.g.dart';
import '../../../dashboard/presentation/bloc/transaction_bloc.dart';

class IncomePage extends StatefulWidget {
  const IncomePage({super.key});

  @override
  State<IncomePage> createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
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
      // Only show Salary category for income
      _categories = allCategories.where((cat) => cat.name == 'Salary').toList();
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
        type: 0, // income
        amount: amount,
        date: _selectedDate,
        description: description,
        category: _selectedCategoryId != null ? _categories.firstWhere((c) => c.id == _selectedCategoryId).name : null,
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
        title: Text(t.transactions.addIncome),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: t.transactions.amount,
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
                  labelText: t.transactions.description,
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
                title: Text('${t.transactions.date}: ${DateFormat.yMMMd().format(_selectedDate)}'),
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
                  backgroundColor: const Color(0xFF2196F3),
                  foregroundColor: Colors.white,
                ),
                child: Text(t.transactions.saveIncome),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
