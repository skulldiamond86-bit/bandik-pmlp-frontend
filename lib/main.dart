import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/auth/auth_cubit.dart';
import 'bloc/category/category_cubit.dart';
import 'bloc/dashboard/dashboard_cubit.dart';
import 'bloc/transaction/transaction_cubit.dart';
import 'repositories/auth_repository.dart';
import 'repositories/category_repository.dart';
import 'repositories/dashboard_repository.dart';
import 'repositories/transaction_repository.dart';
import 'screens/splash_screen.dart';
import 'services/api_service.dart';
import 'services/token_storage_service.dart';

void main() {
  final tokenStorage = TokenStorageService();
  final apiService = ApiService(tokenStorage);

  runApp(
    MainApp(
      authRepository: AuthRepository(apiService, tokenStorage),
      categoryRepository: CategoryRepository(apiService),
      transactionRepository: TransactionRepository(apiService),
      dashboardRepository: DashboardRepository(apiService),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({
    super.key,
    required this.authRepository,
    required this.categoryRepository,
    required this.transactionRepository,
    required this.dashboardRepository,
  });

  final AuthRepository authRepository;
  final CategoryRepository categoryRepository;
  final TransactionRepository transactionRepository;
  final DashboardRepository dashboardRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepository),
        RepositoryProvider.value(value: categoryRepository),
        RepositoryProvider.value(value: transactionRepository),
        RepositoryProvider.value(value: dashboardRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AuthCubit(authRepository)),
          BlocProvider(create: (_) => CategoryCubit(categoryRepository)),
          BlocProvider(create: (_) => TransactionCubit(transactionRepository)),
          BlocProvider(create: (_) => DashboardCubit(dashboardRepository)),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Catatan Keuangan',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(),
            ),
          ),
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
