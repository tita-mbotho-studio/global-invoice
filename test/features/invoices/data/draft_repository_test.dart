import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:global_invoice/features/invoices/data/draft_repository.dart';
import 'package:global_invoice/features/invoices/data/local/app_database.dart';

void main() {
  late AppDatabase database;
  late DraftRepository repository;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    repository = DraftRepository(database);
  });
  tearDown(() async { await database.close(); });

  test('local draft can be saved and deleted', () async {
    final id = await repository.createDraft(
      customerName: 'ACME',
      description: 'Service',
      currencyCode: 'USD',
      quantity: '1',
      unitPrice: '99.99',
    );
    final items = await repository.watchDrafts().first;
    expect(items, hasLength(1));
    expect(items.first.id, id);
    await repository.deleteDraft(id);
    expect(await repository.watchDrafts().first, isEmpty);
  });
}
