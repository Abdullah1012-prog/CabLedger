import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/format/date_format.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/vehicle.dart';
import '../../l10n/app_localizations.dart';
import '../../state/records_controller.dart';
import '../../state/settings_controller.dart';
import '../../state/vehicle_controller.dart';
import '../shared/stat_card.dart';

class VehicleScreen extends StatefulWidget {
  const VehicleScreen({super.key});

  @override
  State<VehicleScreen> createState() => _VehicleScreenState();
}

class _VehicleScreenState extends State<VehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _regController;
  late final TextEditingController _priceController;
  DateTime? _purchaseDate;
  bool _saving = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _regController = TextEditingController();
    _priceController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    final vehicle = context.read<VehicleController>().vehicle;
    if (vehicle != null) {
      _nameController.text = vehicle.vehicleName;
      _regController.text = vehicle.registrationNumber ?? '';
      if (vehicle.purchasePrice != null) {
        final price = vehicle.purchasePrice!;
        _priceController.text = price == price.roundToDouble()
            ? price.toInt().toString()
            : price.toString();
      }
      if (vehicle.purchaseDate != null) {
        _purchaseDate = AppDateFormat.fromStorage(vehicle.purchaseDate!);
      }
    }
    _initialized = true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _regController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickPurchaseDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _purchaseDate ?? DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    setState(() => _purchaseDate = AppDateFormat.dateOnly(picked));
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context);
    final priceText = _priceController.text.trim();
    final price = priceText.isEmpty
        ? null
        : double.tryParse(priceText.replaceAll(',', ''));
    if (priceText.isNotEmpty && (price == null || price < 0)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.invalidAmount)),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      await context.read<VehicleController>().save(
            Vehicle(
              vehicleName: _nameController.text.trim(),
              registrationNumber: _regController.text.trim().isEmpty
                  ? null
                  : _regController.text.trim(),
              purchaseDate: _purchaseDate == null
                  ? null
                  : AppDateFormat.toStorage(_purchaseDate!),
              purchasePrice: price,
            ),
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.vehicleSaved)),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.errorGeneric)),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final records = context.watch<RecordsController>();
    final vehicleCtrl = context.watch<VehicleController>();
    final money = context.watch<SettingsController>().money;
    final investment = vehicleCtrl.investmentFor(records.records);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.vehicleInvestment)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SectionHeader(l10n.investmentRecovery),
          if (!investment.hasPurchasePrice)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  vehicleCtrl.vehicle == null
                      ? l10n.noVehicleYet
                      : (investment.purchasePrice == 0
                          ? l10n.purchasePriceZero
                          : l10n.purchasePriceMissing),
                ),
              ),
            )
          else ...[
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.35,
              children: [
                StatCard(
                  label: l10n.originalPurchasePrice,
                  value: money.format(investment.purchasePrice!),
                  color: AppColors.navy,
                ),
                StatCard(
                  label: l10n.totalOperatingProfit,
                  value: money.formatSigned(investment.cumulativeProfit),
                  color: AppColors.profit,
                ),
                StatCard(
                  label: investment.hasSurplus
                      ? l10n.surplusBeyondInvestment
                      : l10n.remainingInvestment,
                  value: money.format(investment.remainingInvestment!.abs()),
                  color: investment.hasSurplus
                      ? AppColors.profit
                      : AppColors.expense,
                ),
                StatCard(
                  label: l10n.recoveryPercentage,
                  value:
                      '${investment.recoveryPercent!.toStringAsFixed(1)}%',
                  color: AppColors.profit,
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: investment.progressFraction,
                minHeight: 14,
                backgroundColor: AppColors.border,
                color: AppColors.profit,
              ),
            ),
          ],
          const SizedBox(height: 24),
          SectionHeader(l10n.editVehicle),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(labelText: l10n.vehicleName),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.requiredField;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _regController,
                  textCapitalization: TextCapitalization.characters,
                  decoration:
                      InputDecoration(labelText: l10n.registrationNumber),
                ),
                const SizedBox(height: 14),
                OutlinedButton.icon(
                  onPressed: _pickPurchaseDate,
                  icon: const Icon(Icons.calendar_today),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(54),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  label: Text(
                    _purchaseDate == null
                        ? l10n.purchaseDate
                        : AppDateFormat.display(_purchaseDate!),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _priceController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  decoration: InputDecoration(labelText: l10n.purchasePrice),
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: _saving ? null : _save,
                  child: _saving
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.saveVehicle),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
