import 'package:decimal/decimal.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import '../../../core/ui/screen_frame.dart';
import '../data/invoice_providers.dart';
import '../domain/invoice_calculator.dart';

class InvoicesScreen extends ConsumerWidget {
  const InvoicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drafts = ref.watch(draftInvoicesProvider);
    return ScreenFrame(child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Draft invoices', style: Theme.of(context).textTheme.headlineSmall),
          IconButton(
            tooltip: 'New draft',
            onPressed: () => context.push('/new-invoice'),
            icon: const Icon(Icons.add_circle_outline),
          ),
        ]),
        const SizedBox(height: 8),
        Expanded(child: drafts.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('Unable to load drafts: $error')),
          data: (items) => items.isEmpty
              ? const Center(child: Text('No drafts yet. Create your first one.'))
              : ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final total = InvoiceCalculator.calculate(
                      currencyCode: item.currencyCode,
                      lines: [InvoiceLineInput(
                        quantity: Decimal.parse(item.quantity),
                        unitPrice: Decimal.parse(item.unitPrice),
                      )],
                    ).total;
                    return Card(child: ListTile(
                      title: Text(item.customerName),
                      subtitle: Text('${item.description} · Draft'),
                      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                        Text('${item.currencyCode} ${total.toStringAsFixed(InvoiceCalculator.fractionDigits(item.currencyCode))}'),
                        IconButton(
                          tooltip: 'Delete draft',
                          onPressed: () async {
                            await ref.read(draftRepositoryProvider).deleteDraft(item.id);
                          },
                          icon: const Icon(Icons.delete_outline),
                        ),
                      ]),
                    ));
                  },
                ),
        )),
      ],
    ));
  }
}
