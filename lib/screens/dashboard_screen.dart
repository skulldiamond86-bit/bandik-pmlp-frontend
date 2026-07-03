import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth/auth_cubit.dart';
import '../bloc/auth/auth_state.dart';
import '../bloc/dashboard/dashboard_cubit.dart';
import '../bloc/dashboard/dashboard_state.dart';
import '../widgets/money_formatter.dart';
import 'category_list_screen.dart';
import 'login_screen.dart';
import 'transaction_list_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardCubit>().loadDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.unauthenticated) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (_) => false,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
          actions: [
            IconButton(
              tooltip: 'Refresh',
              onPressed: () => context.read<DashboardCubit>().loadDashboard(),
              icon: const Icon(Icons.refresh),
            ),
            IconButton(
              tooltip: 'Logout',
              onPressed: () => context.read<AuthCubit>().logout(),
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () => context.read<DashboardCubit>().loadDashboard(),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              BlocBuilder<DashboardCubit, DashboardState>(
                builder: (context, state) {
                  if (state.status == DashboardStatus.loading &&
                      state.dashboard == null) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final dashboard = state.dashboard;
                  return Column(
                    children: [
                      _SummaryCard(
                        title: 'Saldo',
                        value: rupiahFormatter.format(dashboard?.balance ?? 0),
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _SummaryCard(
                              title: 'Pemasukan',
                              value: rupiahFormatter.format(
                                dashboard?.totalIncome ?? 0,
                              ),
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _SummaryCard(
                              title: 'Pengeluaran',
                              value: rupiahFormatter.format(
                                dashboard?.totalExpense ?? 0,
                              ),
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              _MenuTile(
                title: 'Category',
                subtitle: 'Kelola kategori income dan expense',
                icon: Icons.category,
                onTap: () {
                  final dashboardCubit = context.read<DashboardCubit>();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CategoryListScreen(),
                    ),
                  ).then((_) => dashboardCubit.loadDashboard());
                },
              ),
              const SizedBox(height: 12),
              _MenuTile(
                title: 'Transaction',
                subtitle: 'Kelola catatan transaksi harian',
                icon: Icons.receipt_long,
                onTap: () {
                  final dashboardCubit = context.read<DashboardCubit>();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TransactionListScreen(),
                    ),
                  ).then((_) => dashboardCubit.loadDashboard());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.value,
    required this.color,
  });

  final String title;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Theme.of(context).dividerColor),
      ),
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
