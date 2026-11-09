import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../../state/records_controller.dart';
import '../../state/settings_controller.dart';
import '../../state/vehicle_controller.dart';
import '../history/history_screen.dart';
import '../records/record_form_screen.dart';
import '../reports/reports_screen.dart';
import '../shared/stat_card.dart';
import '../vehicle/vehicle_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final records = context.watch<RecordsController>();
    final vehicle = context.watch<VehicleController>();
    final settings = context.watch<SettingsController>();
    final money = settings.money;

    final today = records.todayTotals;
    final month = records.currentMonthTotals();
    final investment = vehicle.investmentFor(records.records);

    final String recoveryLabel;
    if (!investment.hasPurchasePrice) {
      recoveryLabel = '—';
    } else {
      recoveryLabel = '${investment.recoveryPercent!.toStringAsFixed(1)}%';
    }

    final String recoverySubtitle;
    if (vehicle.vehicle == null) {
      recoverySubtitle = l10n.noVehicleYet;
    } else if (!investment.hasPurchasePrice) {
      recoverySubtitle = l10n.purchasePriceMissing;
    } else if (investment.hasSurplus) {
      recoverySubtitle =
          '${l10n.surplusBeyondInvestment}: ${money.format(investment.remainingInvestment!.abs())}';
    } else {
      recoverySubtitle =
          '${l10n.remainingInvestment}: ${money.format(investment.remainingInvestment!)}';
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.appName)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openRecordForm(context),
        icon: const Icon(Icons.add),
        label: Text(l10n.addDailyRecord),
      ),
      body: records.loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                await Future.wait([
                  context.read<RecordsController>().load(),
                  context.read<VehicleController>().load(),
                ]);
              },
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                children: [
                  SectionHeader(l10n.today),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.35,
                    children: [
                      StatCard(
                        label: l10n.todaysSales,
                        value: money.format(today.sales),
                        color: AppColors.profit,
                        icon: Icons.payments_outlined,
                      ),
                      StatCard(
                        label: l10n.todaysFuel,
                        value: money.format(today.fuel),
                        color: AppColors.fuel,
                        icon: Icons.local_gas_station_outlined,
                      ),
                      StatCard(
                        label: l10n.todaysExpenses,
                        value: money.format(today.expenses),
                        color: AppColors.expense,
                        icon: Icons.build_outlined,
                      ),
                      StatCard(
                        label: l10n.todaysNet,
                        value: money.formatSigned(today.netProfit),
                        color: today.netProfit >= 0
                            ? AppColors.profit
                            : AppColors.expense,
                        icon: Icons.account_balance_wallet_outlined,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SectionHeader(l10n.thisMonth),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.35,
                    children: [
                      StatCard(
                        label: l10n.monthSales,
                        value: money.format(month.sales),
                        color: AppColors.profit,
                      ),
                      StatCard(
                        label: l10n.monthFuel,
                        value: money.format(month.fuel),
                        color: AppColors.fuel,
                      ),
                      StatCard(
                        label: l10n.monthExpenses,
                        value: money.format(month.expenses),
                        color: AppColors.expense,
                      ),
                      StatCard(
                        label: l10n.monthProfit,
                        value: money.formatSigned(month.netProfit),
                        color: month.netProfit >= 0
                            ? AppColors.profit
                            : AppColors.expense,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SectionHeader(l10n.investmentRecovery),
                  InvestmentProgressCard(
                    title: l10n.investmentRecovery,
                    subtitle: recoverySubtitle,
                    percentLabel: recoveryLabel,
                    progress: investment.progressFraction,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const VehicleScreen()),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SectionHeader('Quick Actions'),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.6,
                    children: [
                      QuickActionButton(
                        icon: Icons.add_circle_outline,
                        label: l10n.addDailyRecord,
                        onTap: () => _openRecordForm(context),
                      ),
                      QuickActionButton(
                        icon: Icons.history,
                        label: l10n.viewHistory,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const Scaffold(
                              body: HistoryScreen(),
                            ),
                          ),
                        ),
                      ),
                      QuickActionButton(
                        icon: Icons.bar_chart,
                        label: l10n.monthlyReports,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const Scaffold(
                              body: ReportsScreen(),
                            ),
                          ),
                        ),
                      ),
                      QuickActionButton(
                        icon: Icons.directions_car_outlined,
                        label: l10n.vehicleSettings,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const VehicleScreen(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> _openRecordForm(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const RecordFormScreen()),
    );
  }
}
