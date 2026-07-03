import '../models/dashboard_model.dart';
import '../services/api_service.dart';

class DashboardRepository {
  const DashboardRepository(this._apiService);

  final ApiService _apiService;

  Future<DashboardModel> getDashboard() async {
    final response = await _apiService.dio.get('/dashboard');
    return DashboardModel.fromJson(response.data as Map<String, dynamic>);
  }
}
