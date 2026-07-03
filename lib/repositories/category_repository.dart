import '../models/category_model.dart';
import '../services/api_service.dart';

class CategoryRepository {
  const CategoryRepository(this._apiService);

  final ApiService _apiService;

  Future<List<CategoryModel>> getCategories() async {
    final response = await _apiService.dio.get('/categories');
    final items = response.data['data'] as List<dynamic>;
    return items
        .map((item) => CategoryModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> createCategory({
    required String name,
    required String type,
  }) async {
    await _apiService.dio.post(
      '/categories',
      data: {'name': name, 'type': type},
    );
  }

  Future<void> updateCategory({
    required int id,
    required String name,
    required String type,
  }) async {
    await _apiService.dio.put(
      '/categories/$id',
      data: {'name': name, 'type': type},
    );
  }

  Future<void> deleteCategory(int id) async {
    await _apiService.dio.delete('/categories/$id');
  }
}
