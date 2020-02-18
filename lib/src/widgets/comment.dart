import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../widgets/loading_container.dart';

class Comment extends StatelessWidget {
  final int itemId;
  final int depth;
  final Map<int, Future<ItemModel>> itemMap;

  Comment({this.itemId, this.itemMap, this.depth});
  
  Widget build(context) {
    return FutureBuilder(
      future: itemMap[itemId],
      builder: (context, AsyncSnapshot<ItemModel> snapshot) {
        if (!snapshot.hasData) {
          return LoadingContainer();
        }

        final item = snapshot.data;
        final children = <Widget>[
          ListTile(
            contentPadding: EdgeInsets.only(
              right: 16.0,
              left: (16.0 * depth)
            ),
            title: buildText(item),
            subtitle: (item.by == '' ? Text('Comment was deleted.') : Text(item.by))
          ),
          Divider()
        ];

        item.kids.forEach((kidId) {
          children.add(
            Comment(itemId: kidId, itemMap: itemMap, depth: depth + 1)
          );
        });

        return Column(
          children: children
        );
      }
    );
  }

  Widget buildText(ItemModel item) {
    final text = item.text
      .replaceAll(RegExp(r'<a href(.*)"nofollow">'), '')
      .replaceAll('&#x27;', "'")
      .replaceAll('<p>', '\n\n')
      .replaceAll('</p>', '')
      .replaceAll('<i>', '')
      .replaceAll('</i>', '')
      .replaceAll('<a>', '\n')
      .replaceAll('</a>', '')
      .replaceAll('&#x2F;', '/')
      .replaceAll('&gt;', '>')
      .replaceAll('&lt;', '<')
      .replaceAll('&quot;', '"');

    return Text(text);
  }
}