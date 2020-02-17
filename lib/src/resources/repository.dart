import 'dart:async';
import '../models/item_model.dart';
import 'news_api_provider.dart';
import 'news_db_provider.dart';

class Repository {

  // As a last resort, use the API Provider to retrieve the data!
  List<Source> sources = <Source>[
    newsDbProvider,
    NewsApiProvider()
  ];

  List<Cache> caches = <Cache>[
    newsDbProvider
  ];

  Repository() {
    newsDbProvider.init();
  }

  Future<List<int>> fetchTopIds() {
    return sources[sources.length-1].fetchTopIds();
  }

  Future<ItemModel> fetchItem(int id) async {
    ItemModel item;
    var source;     // Left dynamic so that Dart can compare it to cache as needed

    for (source in sources) {
      item = await source.fetchItem(id);

      if (item != null) {
        break;
      }
    }
 
    for (var cache in caches) {
      // Don't re-insert the data, it'll cause an error in our database!
      if (cache != source) {
        cache.addItem(item);
      }
    }

    return item;
  }

  // Although we have no explicit return statement, the "await" keyword will
  // implicitly return a Future
  // The reason this is necessary is because our RefreshIndicator requires some Future
  // that, when resolved, can let the RefreshIndicator know when the cache is completely cleared
  clearCache() async {
    for (var cache in caches) {
      await cache.clear();
    }
  }
}

// Is a source of information
abstract class Source {
  Future<List<int>> fetchTopIds();
  Future<ItemModel> fetchItem(int id);
}

// Is storage for information
abstract class Cache {
  Future<int> addItem(ItemModel item);
  Future<int> clear();
}