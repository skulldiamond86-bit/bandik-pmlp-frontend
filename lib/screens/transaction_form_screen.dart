import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../bloc/category/category_cubit.dart';
import '../bloc/category/category_state.dart';
import '../bloc/transaction/transaction_cubit.dart';
import '../models/transaction_model.dart';
import '../widgets/app_text_field.dart';
import '../widgets/primary_button.dart';

class TransactionFormScreen extends StatefulWidget {
  const TransactionFormScreen({super.key, this.transaction});

  final TransactionModel? transaction;

  @override
  State<TransactionFormScreen> createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends State<TransactionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  DateTime _date = DateTime.now();
  int? _categoryId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    context.read<CategoryCubit>().loadCategories();
    final transaction = widget.transaction;
    if (transaction != null) {
      _titleController.text = transaction.title;
      _amountController.text = transaction.amount.toStringAsFixed(0);
      _noteController.text = transaction.note ?? '';
      _date = transaction.transactionDate;
      _categoryId = transaction.categoryId;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.transaction == null
              ? 'Tambah Transaction'
              : 'Edit Transaction',
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<CategoryCubit, CategoryState>(
          builder: (context, state) {
            final categories = state.categories;
            if (_categoryId == null && categories.isNotEmpty) {
              _categoryId = categories.first.id;
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    DropdownButtonFormField<int>(
                      initialValue: _categoryId,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                      items: categories
                          .map(
                            (category) => DropdownMenuItem(
                              value: category.id,
                              child: Text(
                                '${category.name} (${category.type})',
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) => setState(() => _categoryId = value),
                      validator: (value) =>
                          value == null ? 'Category wajib dipilih' : null,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _titleController,
                      label: 'Judul',
                      validator: (value) => value == null || value.isEmpty
                          ? 'Judul wajib diisi'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _amountController,
                      label: 'Amount',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        final amount = double.tryParse(value ?? '');
                        if (amount == null || amount <= 0) {
                          return 'Amount harus lebih dari 0';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _noteController,
                      label: 'Note',
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Theme.of(context).dividerColor),
                      ),
                      title: const Text('Tanggal'),
                      subtitle: Text(DateFormat('yyyy-MM-dd').format(_date)),
                      trailing: const Icon(Icons.calendar_month),
                      onTap: _pickDate,
                    ),
                    const SizedBox(height: 24),
                    PrimaryButton(
                      label: 'Simpan',
                      isLoading: _isLoading,
                      onPressed: _save,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await context.read<TransactionCubit>().saveTransaction(
        id: widget.transaction?.id,
        categoryId: _categoryId!,
        title: _titleController.text,
        amount: double.parse(_amountController.text),
        note: _noteController.text.isEmpty ? null : _noteController.text,
        transactionDate: DateFormat('yyyy-MM-dd').format(_date),
      );
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
