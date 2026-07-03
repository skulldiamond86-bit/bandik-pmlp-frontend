import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/dashboard_repository.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(this._dashboardRepository) : super(const DashboardState());

  final DashboardRepository _dashboardRepository;

  Future<void> loadDashboard() async {
    emit(state.copyWith(status: DashboardStatus.loading));
    try {
      final dashboard = await _dashboardRepository.getDashboard();
      emit(
        state.copyWith(status: DashboardStatus.success, dashboard: dashboard),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: DashboardStatus.failure,
          message: 'Gagal memuat dashboard',
        ),
      );
    }
  }
}
