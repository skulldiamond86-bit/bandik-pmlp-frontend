import 'package:equatable/equatable.dart';

import '../../models/category_model.dart';

enum CategoryStatus { initial, loading, success, failure }

class CategoryState extends Equatable {
  const CategoryState({
    this.status = CategoryStatus.initial,
    this.categories = const [],
    this.message,
  });

  final CategoryStatus status;
  final List<CategoryModel> categories;
  final String? message;

  CategoryState copyWith({
    CategoryStatus? status,
    List<CategoryModel>? categories,
    String? message,
  }) {
    return CategoryState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      message: message,
    );
  }

  @override
  List<Object?> get props => [status, categories, message];
}
