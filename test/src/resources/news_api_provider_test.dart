// Importing from outside of lib? Use package!
import 'package:news/src/resources/news_api_provider.dart';
import 'dart:convert';
import 'package:test/test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

import 'package:news/src/models/item_model.dart';

void main() {
  // This is an example of how a test is written
  test('FetchTopIds correctly returns a list of ids.', () async {
    // Set up test
    final newsApi = NewsApiProvider();
    newsApi.client = MockClient((request) async {
      return Response(json.encode([1, 2, 3, 4]), 200);
    });

    final ids = await newsApi.fetchTopIds();

    // Expect a result, think 'assert'
    expect(ids, [1, 2, 3, 4]);
  });

  test('FetchItem correctly fetches an item with a particular id.', () async {
    final newsApi = NewsApiProvider();
    newsApi.client = MockClient((request) async {

      // Rather than testing EVERY ItemModel field, we'll just test the id
      final jsonToParse = {'id': 123};
      return Response(json.encode(jsonToParse), 200);
    });

    final item = await newsApi.fetchItem(999);
    expect(item.id, 123);
  });
}