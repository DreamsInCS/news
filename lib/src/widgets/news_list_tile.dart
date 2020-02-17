import 'package:flutter/material.dart';
import 'dart:async';
import '../models/item_model.dart';
import '../blocs/stories_provider.dart';
import '../widgets/loading_list_tile.dart';

class NewsListTile extends StatelessWidget {
  final int itemId;

  NewsListTile({this.itemId});

  Widget build(context) {
    final bloc = StoriesProvider.of(context);

    return StreamBuilder(
      stream: bloc.items,
      builder: (context, AsyncSnapshot<Map<int, Future<ItemModel>>> snapshot) {
        if (!snapshot.hasData) {
          return LoadingListTile();
        }
        
        return FutureBuilder(
          future: snapshot.data[itemId],
          builder: (context, AsyncSnapshot<ItemModel> itemSnapshot) {
            if (!itemSnapshot.hasData) {
              return LoadingListTile();
            }

            return buildTile(context, itemSnapshot.data);
          }
        );
      }
    );
  }

  Widget buildTile(BuildContext context, ItemModel item) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(item.title),
          onTap: () => Navigator.pushNamed(context, '/${item.id}'),     // Flutter gives you the navigator thanks to material.dart
          subtitle: Text('${item.score} votes'),
          trailing: Column(
            children: <Widget>[
              Icon(Icons.comment),
              Text('${item.descendants}')
            ]
          )
        ),
        Divider(
          height: 8.0
        ),
      ]);
  }
}