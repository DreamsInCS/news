import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'repository.dart';
import '../models/item_model.dart';

class NewsDbProvider implements Source, Cache {
  Database db;

  NewsDbProvider() {
    this.init();
  }

  // TODO: Add fetch and store functionality for top ids in database
  Future<List<int>> fetchTopIds() {
    return null;
  }

  void init() async {
    // Accesses local storage on device
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, "items.db");

    db = await openDatabase(
      path,
      version: 1,

      // If user installs app for the first time
      onCreate: (Database newDb, int version) {
        newDb.execute("""
          CREATE TABLE Items
            (
              id INTEGER PRIMARY KEY,
              type TEXT,
              by TEXT,
              time INTEGER,
              text TEXT,
              parent INTEGER,
              kids BLOB,
              dead INTEGER,
              deleted INTEGER,
              url TEXT,
              descendants INTEGER
            )
        """);
      }
    );
  }
  
  Future<ItemModel> fetchItem(int id) async {
    final maps = await db.query(
      'Items',
      columns: null,
      where: "id = ?",
      whereArgs: [id]  // Find an id equal to... whatever's in whereArgs
    );
    
    if (maps.length > 0) {
      return ItemModel.fromDb(maps.first);
    }

    return null;
  }

  // We do not mark this with async/await because we aren't expecting the result
  // of the insertion, we're not going to do anything with it. Just insert and move on!
  Future<int> addItem(ItemModel item) {
    return db.insert("Items", item.toMapForDb());
  }
}

final newsDbProvider = NewsDbProvider();