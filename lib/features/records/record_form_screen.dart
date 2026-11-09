import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/format/date_format.dart';
import '../../data/models/daily_record.dart';
import '../../l10n/app_localizations.dart';
import '../../state/records_controller.dart';

class RecordFormScreen extends StatefulWidget {
  const RecordFormScreen({super.key, this.existing});

  final DailyRecord? existing;

  @override
  State<RecordFormScreen> createState() => _RecordFormScreenState();
}

class _RecordFormScreenState extends State<RecordFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late DateTime _date;
  late final TextEditingController _saleController;
  late final TextEditingController _fuelController;
  late final TextEditingController _expenseController;
  late final TextEditingController _noteController;
  bool _saving = false;
  bool _dateConflict = false;
  DailyRecord? _conflictRecord;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _date = existing == null
        ? AppDateFormat.dateOnly(DateTime.now())
        : AppDateFormat.fromStorage(existing.date);
    _saleController = TextEditingController(
      text: existing == null ? '' : _amountText(existing.sale),
    );
    _fuelController = TextEditingController(
      text: existing == null ? '' : _amountText(existing.fuel),
    );
    _expenseController = TextEditingController(
      text: existing == null ? '' : _amountText(existing.expense),
    );
    _noteController = TextEditingController(
      text: existing?.expenseDescription ?? '',
    );
    if (existing == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _checkDateConflict());
    }
  }

  String _amountText(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toString();
  }

  @override
  void dispose() {
    _saleController.dispose();
    _fuelController.dispose();
    _expenseController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    setState(() => _date = AppDateFormat.dateOnly(picked));
    await _checkDateConflict();
  }

  Future<void> _checkDateConflict() async {
    if (widget.existing != null) {
      setState(() {
        _dateConflict = false;
        _conflictRecord = null;
      });
      return;
    }
    final iso = AppDateFormat.toStorage(_date);
    final existing =
        await context.read<RecordsController>().findByDate(iso);
    if (!mounted) return;
    if (existing != null) {
      setState(() {
        _dateConflict = true;
        _conflictRecord = existing;
        _saleController.text = _amountText(existing.sale);
        _fuelController.text = _amountText(existing.fuel);
        _expenseController.text = _amountText(existing.expense);
        _noteController.text = existing.expenseDescription ?? '';
      });
    } else {
      setState(() {
        _dateConflict = false;
        _conflictRecord = null;
      });
    }
  }

  double? _parseAmount(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return 0;
    return double.tryParse(text.replaceAll(',', ''));
  }

  String? _validateAmount(String? value) {
    final l10n = AppLocalizations.of(context);
    final parsed = _parseAmount(value ?? '');
    if (parsed == null) return l10n.invalidAmount;
    if (parsed < 0) return l10n.amountCannotBeNegative;
    return null;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context);
    final sale = _parseAmount(_saleController.text)!;
    final fuel = _parseAmount(_fuelController.text)!;
    final expense = _parseAmount(_expenseController.text)!;
    final note = _noteController.text.trim();

    setState(() => _saving = true);
    try {
      final record = DailyRecord(
        id: widget.existing?.id ?? _conflictRecord?.id,
        date: AppDateFormat.toStorage(_date),
        sale: sale,
        fuel: fuel,
        expense: expense,
        expenseDescription: note.isEmpty ? null : note,
      );
      final isUpdate = widget.existing != null || _conflictRecord != null;
      await context.read<RecordsController>().save(record);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isUpdate ? l10n.recordUpdated : l10n.recordSaved),
        ),
      );
      Navigator.of(context).pop(true);
    } catch (e) {
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
    final isUpdate = widget.existing != null || _dateConflict;

    return Scaffold(
      appBar: AppBar(
        title: Text(isUpdate ? l10n.editDailyRecord : l10n.addDailyRecord),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (_dateConflict)
                Card(
                  color: Theme.of(context).colorScheme.errorContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      l10n.dateAlreadyExists,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              if (_dateConflict) const SizedBox(height: 12),
              Text(l10n.date, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _pickDate,
                icon: const Icon(Icons.calendar_today),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(54),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                label: Text(
                  AppDateFormat.display(_date),
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _saleController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
                style: const TextStyle(fontSize: 22),
                decoration: InputDecoration(
                  labelText: l10n.sale,
                  prefixText: 'Rs. ',
                ),
                validator: _validateAmount,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _fuelController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
                style: const TextStyle(fontSize: 22),
                decoration: InputDecoration(
                  labelText: l10n.fuel,
                  prefixText: 'Rs. ',
                ),
                validator: _validateAmount,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _expenseController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
                style: const TextStyle(fontSize: 22),
                decoration: InputDecoration(
                  labelText: l10n.expense,
                  prefixText: 'Rs. ',
                ),
                validator: _validateAmount,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _noteController,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(labelText: l10n.optionalNote),
                maxLines: 2,
              ),
              const SizedBox(height: 28),
              FilledButton(
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(isUpdate ? l10n.updateRecord : l10n.saveRecord),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
