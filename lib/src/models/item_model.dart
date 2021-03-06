import 'dart:convert';

class ItemModel {
  final int id;
  final bool deleted;
  final String type;
  final String by;
  final int time;
  final String text;
  final bool dead;
  final int parent;
  final List<dynamic> kids;
  final String url;
  final int score;
  final String title;
  final int descendants;

  // Initializer list: shorthand for initialization

  // The reason why we used Dart's if-null ?? operator (a null-aware operator) is
  // because the HackerNews API lacks a 'deleted' and 'dead' field for Stories, which
  // means these fields would have been set to null, causing unintended behavior

  // Adding these makes them have a default value for safety and convenience so we don't have
  // to write this whole ItemModel from scratch
  ItemModel.fromJson(Map<String, dynamic> parsedJson)
    : id = parsedJson['id'],
      deleted = parsedJson['deleted'] ?? false,   // If parsedJson['deleted'] is null, set deleted to false
      type = parsedJson['type'],
      by = parsedJson['by'] ?? '',
      time = parsedJson['time'],
      text = parsedJson['text'] ?? '',
      dead = parsedJson['dead'] ?? false,
      parent = parsedJson['parent'],
      kids = parsedJson['kids'] ?? [],
      url = parsedJson['url'],
      score = parsedJson['score'],
      title = parsedJson['title'],
      descendants = parsedJson['descendants'];

  ItemModel.fromDb(Map<String, dynamic> parsedJson)
    : id = parsedJson['id'],
      deleted = parsedJson['deleted'] == 1,
      type = parsedJson['type'],
      by = parsedJson['by'],
      time = parsedJson['time'],
      text = parsedJson['text'],
      dead = parsedJson['dead'] == 1,
      parent = parsedJson['parent'],
      kids = jsonDecode(parsedJson['kids']), // shorthand for json.decode()
      url = parsedJson['url'],
      score = parsedJson['score'],
      title = parsedJson['title'],
      descendants = parsedJson['descendants'];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "deleted": deleted ? 1 : 0,
      "type": type,
      "by": by,
      "time": time,
      "text": text,
      "dead": dead ? 1 : 0,
      "parent": parent,
      "kids": jsonEncode(kids),
      "url": url,
      "score": score,
      "title": title,
      "descendants": descendants
    };
  }
}