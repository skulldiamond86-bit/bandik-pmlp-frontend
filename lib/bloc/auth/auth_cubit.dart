import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authRepository) : super(const AuthState());

  final AuthRepository _authRepository;

  Future<void> checkAuth() async {
    final isLoggedIn = await _authRepository.hasToken();
    emit(
      AuthState(
        status: isLoggedIn
            ? AuthStatus.authenticated
            : AuthStatus.unauthenticated,
      ),
    );
  }

  Future<void> login(String email, String password) async {
    emit(const AuthState(status: AuthStatus.loading));
    try {
      await _authRepository.login(email: email, password: password);
      emit(const AuthState(status: AuthStatus.authenticated));
    } catch (error) {
      emit(AuthState(status: AuthStatus.failure, message: _message(error)));
    }
  }

  Future<void> register(String name, String email, String password) async {
    emit(const AuthState(status: AuthStatus.loading));
    try {
      await _authRepository.register(
        name: name,
        email: email,
        password: password,
      );
      emit(const AuthState(status: AuthStatus.authenticated));
    } catch (error) {
      emit(AuthState(status: AuthStatus.failure, message: _message(error)));
    }
  }

  Future<void> logout() async {
    emit(const AuthState(status: AuthStatus.loading));
    await _authRepository.logout();
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }

  String _message(Object error) {
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map<String, dynamic> && data['message'] != null) {
        return data['message'].toString();
      }
      if (error.type == DioExceptionType.connectionError ||
          error.type == DioExceptionType.connectionTimeout) {
        return 'Tidak bisa terhubung ke backend. Pastikan Laravel sudah berjalan.';
      }
    }
    return 'Terjadi kesalahan. Coba lagi.';
  }
}
