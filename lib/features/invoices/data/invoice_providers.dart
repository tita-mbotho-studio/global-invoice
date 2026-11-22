import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'draft_repository.dart';
import 'local/app_database.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() { db.close(); });
  return db;
});

final draftRepositoryProvider = Provider<DraftRepositoryContract>(
  (ref) => DraftRepository(ref.watch(appDatabaseProvider)),
);

final draftInvoicesProvider = StreamProvider<List<DraftInvoice>>(
  (ref) => ref.watch(draftRepositoryProvider).watchDrafts(),
);
