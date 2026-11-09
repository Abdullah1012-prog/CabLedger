import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/format/money_format.dart';
import '../../data/db/app_database.dart';
import '../../export/backup_service.dart';
import '../../l10n/app_localizations.dart';
import '../../state/records_controller.dart';
import '../../state/settings_controller.dart';
import '../../state/vehicle_controller.dart';
import '../vehicle/vehicle_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settings = context.watch<SettingsController>();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.directions_car_outlined),
            title: Text(l10n.editVehicle),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const VehicleScreen()),
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.currency_exchange),
            title: Text(l10n.currencyDisplay),
            subtitle: Text(
              settings.currencyStyle == CurrencyStyle.rs
                  ? l10n.currencyRs
                  : l10n.currencyPkr,
            ),
            onTap: () => _pickCurrency(context),
          ),
          ListTile(
            leading: const Icon(Icons.brightness_6_outlined),
            title: Text(l10n.theme),
            subtitle: Text(_themeLabel(l10n, settings.themeMode)),
            onTap: () => _pickTheme(context),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.download_outlined),
            title: Text(l10n.exportAllData),
            onTap: () => _exportAll(context),
          ),
          ListTile(
            leading: const Icon(Icons.backup_outlined),
            title: Text(l10n.backupDatabase),
            onTap: () => _backup(context),
          ),
          ListTile(
            leading: const Icon(Icons.restore_outlined),
            title: Text(l10n.restoreDatabase),
            onTap: () => _restore(context),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.about),
            onTap: () => _about(context),
          ),
          ListTile(
            leading: Icon(
              Icons.delete_forever_outlined,
              color: Theme.of(context).colorScheme.error,
            ),
            title: Text(
              l10n.resetData,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            onTap: () => _reset(context),
          ),
        ],
      ),
    );
  }

  String _themeLabel(AppLocalizations l10n, ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return l10n.themeLight;
      case ThemeMode.dark:
        return l10n.themeDark;
      case ThemeMode.system:
        return l10n.themeSystem;
    }
  }

  Future<void> _pickCurrency(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final current = context.read<SettingsController>().currencyStyle;
    final selected = await showModalBottomSheet<CurrencyStyle>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(l10n.currencyRs),
              trailing: current == CurrencyStyle.rs
                  ? const Icon(Icons.check)
                  : null,
              onTap: () => Navigator.pop(context, CurrencyStyle.rs),
            ),
            ListTile(
              title: Text(l10n.currencyPkr),
              trailing: current == CurrencyStyle.pkr
                  ? const Icon(Icons.check)
                  : null,
              onTap: () => Navigator.pop(context, CurrencyStyle.pkr),
            ),
          ],
        ),
      ),
    );
    if (selected == null || !context.mounted) return;
    await context.read<SettingsController>().setCurrencyStyle(selected);
  }

  Future<void> _pickTheme(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final current = context.read<SettingsController>().themeMode;
    final selected = await showModalBottomSheet<ThemeMode>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(l10n.themeSystem),
              trailing:
                  current == ThemeMode.system ? const Icon(Icons.check) : null,
              onTap: () => Navigator.pop(context, ThemeMode.system),
            ),
            ListTile(
              title: Text(l10n.themeLight),
              trailing:
                  current == ThemeMode.light ? const Icon(Icons.check) : null,
              onTap: () => Navigator.pop(context, ThemeMode.light),
            ),
            ListTile(
              title: Text(l10n.themeDark),
              trailing:
                  current == ThemeMode.dark ? const Icon(Icons.check) : null,
              onTap: () => Navigator.pop(context, ThemeMode.dark),
            ),
          ],
        ),
      ),
    );
    if (selected == null || !context.mounted) return;
    await context.read<SettingsController>().setThemeMode(selected);
  }

  Future<void> _exportAll(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    try {
      final records = context.read<RecordsController>().records;
      final file =
          await context.read<BackupService>().exportAllRecordsCsv(records);
      await SharePlus.instance.share(
        ShareParams(files: [XFile(file.path)], text: 'CabLedger data export'),
      );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.exportSuccess)),
      );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.errorGeneric)),
      );
    }
  }

  Future<void> _backup(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    try {
      final file = await context.read<BackupService>().backupDatabase();
      await SharePlus.instance.share(
        ShareParams(files: [XFile(file.path)], text: 'CabLedger database backup'),
      );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.backupCreated)),
      );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.errorGeneric)),
      );
    }
  }

  Future<void> _restore(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
      );
      if (result == null || result.files.single.path == null) return;
      final path = result.files.single.path!;
      final backup = context.read<BackupService>();
      final recordsController = context.read<RecordsController>();
      final vehicleController = context.read<VehicleController>();
      await backup.restoreDatabase(path);
      await Future.wait([
        recordsController.load(),
        vehicleController.load(),
      ]);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.restoreSuccess)),
      );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.errorGeneric)),
      );
    }
  }

  void _about(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showAboutDialog(
      context: context,
      applicationName: l10n.appName,
      applicationVersion: l10n.version,
      children: [Text(l10n.aboutBody)],
    );
  }

  Future<void> _reset(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.resetTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.resetBody),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: l10n.resetConfirmWord,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              if (controller.text.trim() == l10n.resetConfirmWord) {
                Navigator.pop(context, true);
              }
            },
            child: Text(l10n.resetData),
          ),
        ],
      ),
    );
    controller.dispose();
    if (confirmed != true || !context.mounted) return;

    final database = context.read<AppDatabase>();
    final recordsController = context.read<RecordsController>();
    final vehicleController = context.read<VehicleController>();
    try {
      await database.resetAllData();
      await Future.wait([
        recordsController.load(),
        vehicleController.load(),
      ]);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.resetSuccess)),
      );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.errorGeneric)),
      );
    }
  }
}
