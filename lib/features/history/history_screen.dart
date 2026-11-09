import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/format/date_format.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/daily_record.dart';
import '../../l10n/app_localizations.dart';
import '../../state/records_controller.dart';
import '../../state/settings_controller.dart';
import '../records/record_form_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final records = context.watch<RecordsController>();
    final money = context.watch<SettingsController>().money;
    final items = records.filteredRecords;
    final nested = ModalRoute.of(context)?.canPop ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.history),
        automaticallyImplyLeading: nested,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const RecordFormScreen()),
        ),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked == null) return;
                      if (!context.mounted) return;
                      context.read<RecordsController>().setSearchDate(
                            AppDateFormat.toStorage(picked),
                          );
                    },
                    icon: const Icon(Icons.search),
                    label: Text(
                      records.searchDate == null
                          ? l10n.searchByDate
                          : AppDateFormat.displayStorage(records.searchDate!),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  tooltip: l10n.filterMonth,
                  onPressed: () => _pickMonthFilter(context),
                  icon: Icon(
                    Icons.filter_alt_outlined,
                    color: records.filterMonth != null ||
                            records.filterYear != null
                        ? AppColors.navy
                        : null,
                  ),
                ),
                if (records.searchDate != null ||
                    records.filterMonth != null ||
                    records.filterYear != null)
                  IconButton(
                    onPressed: () =>
                        context.read<RecordsController>().clearFilters(),
                    icon: const Icon(Icons.clear),
                  ),
              ],
            ),
          ),
          Expanded(
            child: records.loading
                ? const Center(child: CircularProgressIndicator())
                : items.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                l10n.noRecords,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                l10n.noRecordsHint,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                        itemCount: items.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final record = items[index];
                          return _HistoryCard(
                            record: record,
                            sale: money.format(record.sale),
                            fuel: money.format(record.fuel),
                            expense: money.format(record.expense),
                            net: money.formatSigned(record.net),
                            onOpen: () => _open(context, record),
                            onEdit: () => _open(context, record),
                            onDelete: () => _confirmDelete(context, record),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickMonthFilter(BuildContext context) async {
    final records = context.read<RecordsController>();
    final now = DateTime.now();
    final year = records.filterYear ?? now.year;
    final month = records.filterMonth ?? now.month;
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(year, month),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: AppLocalizations.of(context).filterMonth,
    );
    if (picked == null) return;
    if (!context.mounted) return;
    context.read<RecordsController>().setMonthFilter(
          year: picked.year,
          month: picked.month,
        );
  }

  Future<void> _open(BuildContext context, DailyRecord record) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RecordFormScreen(existing: record),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, DailyRecord record) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteRecord),
        content: Text(l10n.deleteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await context.read<RecordsController>().delete(record.id!);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.recordDeleted)),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({
    required this.record,
    required this.sale,
    required this.fuel,
    required this.expense,
    required this.net,
    required this.onOpen,
    required this.onEdit,
    required this.onDelete,
  });

  final DailyRecord record;
  final String sale;
  final String fuel;
  final String expense;
  final String net;
  final VoidCallback onOpen;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      AppDateFormat.displayStorage(record.date),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  IconButton(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined),
                  ),
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  _chip(l10n.sale, sale, AppColors.profit),
                  _chip(l10n.fuel, fuel, AppColors.fuel),
                  _chip(l10n.expense, expense, AppColors.expense),
                  _chip(
                    l10n.net,
                    net,
                    record.net >= 0 ? AppColors.profit : AppColors.expense,
                  ),
                ],
              ),
              if (record.expenseDescription != null &&
                  record.expenseDescription!.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  record.expenseDescription!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.muted,
                      ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _chip(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}
