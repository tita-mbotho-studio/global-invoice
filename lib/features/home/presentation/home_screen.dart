import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import '../../../core/ui/screen_frame.dart';
import '../../invoices/data/invoice_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drafts = ref.watch(draftInvoicesProvider);
    return SingleChildScrollView(
      child: ScreenFrame(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 14),
            Text('Welcome back', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text('Keep invoicing simple.', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 24),
            Card(child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Icon(Icons.receipt_long_outlined, size: 35),
                const SizedBox(height: 14),
                Text('Your invoices, your workflow', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                const Text('Create and save a draft completely offline. Issued invoices and PDFs come later.'),
                const SizedBox(height: 18),
                FilledButton.icon(
                  onPressed: () => context.push('/new-invoice'),
                  icon: const Icon(Icons.add),
                  label: const Text('New draft'),
                ),
              ]),
            )),
            const SizedBox(height: 16),
            Card(child: ListTile(
              title: const Text('Saved drafts'),
              subtitle: const Text('Stored on this device'),
              trailing: drafts.when(
                data: (items) => Text('${items.length}'),
                error: (_, __) => const Icon(Icons.error_outline),
                loading: () => const CircularProgressIndicator(),
              ),
              onTap: () => context.go('/invoices'),
            )),
            const SizedBox(height: 12),
            const Text('Milestone 01 - foundation preview'),
          ],
        ),
      ),
    );
  }
}
