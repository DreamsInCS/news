import 'package:http/http.dart' show Client;
import '../models/item_model.dart';
import 'repository.dart';
import 'dart:convert';
import 'dart:async';

final _root = 'https://hacker-news.firebaseio.com/v0';

class NewsApiProvider implements Source {
  Client client = Client();

  // Type annotation, quality of life is much better with them!
  Future<List<int>> fetchTopIds() async {
    final response = await client.get('$_root/topstories.json');
    final ids = json.decode(response.body);

    // Dart does not realize this is a List of integers (seen as dynamic), we must typecast it!
    return ids.cast<int>();
  }

  Future<ItemModel> fetchItem(int id) async {
    final response = await client.get('$_root/item/$id.json');
    final parsedJson = json.decode(response.body);

    return ItemModel.fromJson(parsedJson);
  }
}