import 'package:decimal/decimal.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import '../../../core/ui/screen_frame.dart';
import '../data/invoice_providers.dart';
import '../domain/invoice_calculator.dart';

class NewInvoiceScreen extends ConsumerStatefulWidget {
  const NewInvoiceScreen({super.key});
  @override
  ConsumerState<NewInvoiceScreen> createState() => _NewInvoiceScreenState();
}

class _NewInvoiceScreenState extends ConsumerState<NewInvoiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _client = TextEditingController();
  final _description = TextEditingController();
  final _quantity = TextEditingController(text: '1');
  final _price = TextEditingController(text: '0.00');
  String _currency = 'USD';
  bool _saving = false;

  @override
  void dispose() {
    _client.dispose();
    _description.dispose();
    _quantity.dispose();
    _price.dispose();
    super.dispose();
  }

  String? _positive(String? value, {bool allowZero = false}) {
    final parsed = Decimal.tryParse((value ?? '').trim());
    if (parsed == null || (allowZero ? parsed < Decimal.zero : parsed <= Decimal.zero)) {
      return allowZero ? 'Enter a non-negative number' : 'Enter a number above zero';
    }
    return null;
  }

  Future<void> _save() async {
    if (_saving || !_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await ref.read(draftRepositoryProvider).createDraft(
        customerName: _client.text,
        description: _description.text,
        currencyCode: _currency,
        quantity: _quantity.text.trim(),
        unitPrice: _price.text.trim(),
      );
      if (mounted) context.go('/invoices');
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to save draft. Try again.')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    Decimal? total;
    final quantity = Decimal.tryParse(_quantity.text.trim());
    final price = Decimal.tryParse(_price.text.trim());
    if (quantity != null && quantity > Decimal.zero && price != null && price >= Decimal.zero) {
      total = InvoiceCalculator.calculate(
        currencyCode: _currency,
        lines: [InvoiceLineInput(quantity: quantity, unitPrice: price)],
      ).total;
    }
    return Scaffold(
      appBar: AppBar(title: const Text('New draft')),
      body: SingleChildScrollView(
        child: ScreenFrame(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Foundation preview: one item only; not an issued invoice.'),
                const SizedBox(height: 18),
                TextFormField(
                  controller: _client,
                  maxLength: 150,
                  decoration: const InputDecoration(labelText: 'Client name'),
                  validator: (v) => (v ?? '').trim().isEmpty ? 'Client is required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _description,
                  maxLength: 300,
                  decoration: const InputDecoration(labelText: 'Item or service'),
                  validator: (v) => (v ?? '').trim().isEmpty ? 'Description is required' : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _currency,
                  decoration: const InputDecoration(labelText: 'Currency'),
                  items: ['USD', 'EUR', 'GBP', 'ZAR', 'INR', 'JPY', 'KWD']
                      .map((code) => DropdownMenuItem(value: code, child: Text(code)))
                      .toList(),
                  onChanged: (value) => setState(() => _currency = value ?? 'USD'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _quantity,
                  decoration: const InputDecoration(labelText: 'Quantity'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (_) => setState(() {}),
                  validator: _positive,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _price,
                  decoration: const InputDecoration(labelText: 'Unit price'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (_) => setState(() {}),
                  validator: (v) => _positive(v, allowZero: true),
                ),
                const SizedBox(height: 22),
                Card(child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    const Text('Draft subtotal'),
                    Text(
                      total == null ? '—' : '$_currency ${total.toStringAsFixed(InvoiceCalculator.fractionDigits(_currency))}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ]),
                )),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: _saving ? null : _save,
                  icon: const Icon(Icons.save_outlined),
                  label: Text(_saving ? 'Saving…' : 'Save offline draft'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
