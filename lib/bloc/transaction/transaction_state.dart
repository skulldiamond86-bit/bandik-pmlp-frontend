import 'package:equatable/equatable.dart';

import '../../models/transaction_model.dart';

enum TransactionStatus { initial, loading, success, failure }

class TransactionState extends Equatable {
  const TransactionState({
    this.status = TransactionStatus.initial,
    this.transactions = const [],
    this.message,
  });

  final TransactionStatus status;
  final List<TransactionModel> transactions;
  final String? message;

  TransactionState copyWith({
    TransactionStatus? status,
    List<TransactionModel>? transactions,
    String? message,
  }) {
    return TransactionState(
      status: status ?? this.status,
      transactions: transactions ?? this.transactions,
      message: message,
    );
  }

  @override
  List<Object?> get props => [status, transactions, message];
}
