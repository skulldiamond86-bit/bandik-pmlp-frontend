import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/transaction_repository.dart';
import 'transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  TransactionCubit(this._transactionRepository)
    : super(const TransactionState());

  final TransactionRepository _transactionRepository;

  Future<void> loadTransactions() async {
    emit(state.copyWith(status: TransactionStatus.loading));
    try {
      final transactions = await _transactionRepository.getTransactions();
      emit(
        state.copyWith(
          status: TransactionStatus.success,
          transactions: transactions,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: TransactionStatus.failure,
          message: 'Gagal memuat transaksi',
        ),
      );
    }
  }

  Future<void> saveTransaction({
    int? id,
    required int categoryId,
    required String title,
    required double amount,
    required String? note,
    required String transactionDate,
  }) async {
    if (id == null) {
      await _transactionRepository.createTransaction(
        categoryId: categoryId,
        title: title,
        amount: amount,
        note: note,
        transactionDate: transactionDate,
      );
    } else {
      await _transactionRepository.updateTransaction(
        id: id,
        categoryId: categoryId,
        title: title,
        amount: amount,
        note: note,
        transactionDate: transactionDate,
      );
    }
    await loadTransactions();
  }

  Future<void> deleteTransaction(int id) async {
    await _transactionRepository.deleteTransaction(id);
    await loadTransactions();
  }
}
