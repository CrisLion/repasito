import "package:drift/drift.dart";
import 'package:path/path.dart' as p;
import "package:drift/native.dart";
import 'package:path_provider/path_provider.dart';
import 'dart:io';

part 'database.g.dart';

class Favorites extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get gender => text()();
  TextColumn get city => text()();
  TextColumn get photo => text()();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'favorites.sqlite'));
    return NativeDatabase(file);
  });
}

@DriftDatabase(tables: [Favorites])
class Database extends _$Database {
  Database() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<Favorite>> getAllFavorites() => select(favorites).get();

  Future<int> insertFavorite(FavoritesCompanion favorite) =>
      into(favorites).insert(favorite);

  Future<int> deleteFavorite(FavoritesCompanion favorite) =>
      delete(favorites).delete(favorite);

  Future<bool> updateFavorite(FavoritesCompanion favorite) =>
      update(favorites).replace(favorite);
}
