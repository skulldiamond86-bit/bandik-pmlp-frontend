import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/category_repository.dart';
import 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit(this._categoryRepository) : super(const CategoryState());

  final CategoryRepository _categoryRepository;

  Future<void> loadCategories() async {
    emit(state.copyWith(status: CategoryStatus.loading));
    try {
      final categories = await _categoryRepository.getCategories();
      emit(
        state.copyWith(status: CategoryStatus.success, categories: categories),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: CategoryStatus.failure,
          message: 'Gagal memuat kategori',
        ),
      );
    }
  }

  Future<void> saveCategory({
    int? id,
    required String name,
    required String type,
  }) async {
    if (id == null) {
      await _categoryRepository.createCategory(name: name, type: type);
    } else {
      await _categoryRepository.updateCategory(id: id, name: name, type: type);
    }
    await loadCategories();
  }

  Future<void> deleteCategory(int id) async {
    await _categoryRepository.deleteCategory(id);
    await loadCategories();
  }
}
