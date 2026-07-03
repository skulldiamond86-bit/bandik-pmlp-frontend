import 'category_model.dart';

class TransactionModel {
  const TransactionModel({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.amount,
    this.note,
    required this.transactionDate,
    this.category,
  });

  final int id;
  final int categoryId;
  final String title;
  final double amount;
  final String? note;
  final DateTime transactionDate;
  final CategoryModel? category;

  bool get isIncome => category?.type == 'income';

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    final categoryJson = json['category'];

    return TransactionModel(
      id: json['id'] as int,
      categoryId: json['category_id'] as int,
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      note: json['note'] as String?,
      transactionDate: DateTime.parse(json['transaction_date'] as String),
      category: categoryJson is Map<String, dynamic>
          ? CategoryModel.fromJson(categoryJson)
          : null,
    );
  }
}
