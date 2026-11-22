import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

// Deliberately narrow schema for the first offline draft vertical slice.
class DraftInvoices extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get customerName => text().withLength(min: 1, max: 150)();
  TextColumn get description => text().withLength(min: 1, max: 300)();
  TextColumn get currencyCode => text().withLength(min: 3, max: 3)();
  TextColumn get quantity => text()();
  TextColumn get unitPrice => text()();
  DateTimeColumn get updatedAt => dateTime()();
}

@DriftDatabase(tables: [DraftInvoices])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openDatabase());
  AppDatabase.forTesting(QueryExecutor executor) : super(executor);

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openDatabase() => LazyDatabase(() async {
      final directory = await getApplicationDocumentsDirectory();
      final file = File(p.join(directory.path, 'invoice_app.sqlite'));
      return NativeDatabase.createInBackground(file);
    });
