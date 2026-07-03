import 'package:equatable/equatable.dart';

import '../../models/dashboard_model.dart';

enum DashboardStatus { initial, loading, success, failure }

class DashboardState extends Equatable {
  const DashboardState({
    this.status = DashboardStatus.initial,
    this.dashboard,
    this.message,
  });

  final DashboardStatus status;
  final DashboardModel? dashboard;
  final String? message;

  DashboardState copyWith({
    DashboardStatus? status,
    DashboardModel? dashboard,
    String? message,
  }) {
    return DashboardState(
      status: status ?? this.status,
      dashboard: dashboard ?? this.dashboard,
      message: message,
    );
  }

  @override
  List<Object?> get props => [status, dashboard, message];
}
