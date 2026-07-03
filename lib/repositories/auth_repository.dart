import '../models/auth_response_model.dart';
import '../services/api_service.dart';
import '../services/token_storage_service.dart';

class AuthRepository {
  const AuthRepository(this._apiService, this._tokenStorage);

  final ApiService _apiService;
  final TokenStorageService _tokenStorage;

  Future<AuthResponseModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _apiService.dio.post(
      '/register',
      data: {'name': name, 'email': email, 'password': password},
    );
    final auth = AuthResponseModel.fromJson(response.data);
    await _tokenStorage.saveToken(auth.token);
    return auth;
  }

  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiService.dio.post(
      '/login',
      data: {'email': email, 'password': password},
    );
    final auth = AuthResponseModel.fromJson(response.data);
    await _tokenStorage.saveToken(auth.token);
    return auth;
  }

  Future<bool> hasToken() async {
    final token = await _tokenStorage.getToken();
    return token != null;
  }

  Future<void> logout() async {
    try {
      await _apiService.dio.post('/logout');
    } finally {
      await _tokenStorage.clearToken();
    }
  }
}
