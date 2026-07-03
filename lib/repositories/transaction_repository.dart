import '../models/transaction_model.dart';
import '../services/api_service.dart';

class TransactionRepository {
  const TransactionRepository(this._apiService);

  final ApiService _apiService;

  Future<List<TransactionModel>> getTransactions() async {
    final response = await _apiService.dio.get('/transactions');
    final items = response.data['data'] as List<dynamic>;
    return items
        .map((item) => TransactionModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> createTransaction({
    required int categoryId,
    required String title,
    required double amount,
    required String? note,
    required String transactionDate,
  }) async {
    await _apiService.dio.post(
      '/transactions',
      data: {
        'category_id': categoryId,
        'title': title,
        'amount': amount,
        'note': note,
        'transaction_date': transactionDate,
      },
    );
  }

  Future<void> updateTransaction({
    required int id,
    required int categoryId,
    required String title,
    required double amount,
    required String? note,
    required String transactionDate,
  }) async {
    await _apiService.dio.put(
      '/transactions/$id',
      data: {
        'category_id': categoryId,
        'title': title,
        'amount': amount,
        'note': note,
        'transaction_date': transactionDate,
      },
    );
  }

  Future<void> deleteTransaction(int id) async {
    await _apiService.dio.delete('/transactions/$id');
  }
}
