import 'package:drift/drift.dart';
import 'local/app_database.dart';

abstract interface class DraftRepositoryContract {
  Stream<List<DraftInvoice>> watchDrafts();
  Future<int> createDraft({
    required String customerName,
    required String description,
    required String currencyCode,
    required String quantity,
    required String unitPrice,
  });
  Future<int> deleteDraft(int id);
}

class DraftRepository implements DraftRepositoryContract {
  const DraftRepository(this._db);
  final AppDatabase _db;

  @override
  Stream<List<DraftInvoice>> watchDrafts() => (_db.select(_db.draftInvoices)
        ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
      .watch();

  @override
  Future<int> createDraft({
    required String customerName,
    required String description,
    required String currencyCode,
    required String quantity,
    required String unitPrice,
  }) =>
      _db.into(_db.draftInvoices).insert(
            DraftInvoicesCompanion.insert(
              customerName: customerName.trim(),
              description: description.trim(),
              currencyCode: currencyCode,
              quantity: quantity,
              unitPrice: unitPrice,
              updatedAt: DateTime.now().toUtc(),
            ),
          );

  @override
  Future<int> deleteDraft(int id) =>
      (_db.delete(_db.draftInvoices)..where((t) => t.id.equals(id))).go();
}
