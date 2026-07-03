import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'token_storage_service.dart';

class ApiService {
  ApiService(this._tokenStorage)
    : dio = Dio(
        BaseOptions(
          baseUrl: _baseUrl,
          connectTimeout: const Duration(seconds: 20),
          receiveTimeout: const Duration(seconds: 20),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _tokenStorage.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );
  }

  static String get _baseUrl {
    const definedUrl = String.fromEnvironment('WA_API_BASE_URL');
    if (definedUrl.isNotEmpty) {
      return definedUrl;
    }

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8000/api';
    }

    return 'http://127.0.0.1:8000/api';
  }

  final TokenStorageService _tokenStorage;
  final Dio dio;
}
