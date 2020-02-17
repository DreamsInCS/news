import 'package:flutter/material.dart';
import '../blocs/stories_provider.dart';

class Refresh extends StatelessWidget {
  final Widget child;

  Refresh({this.child});

  Widget build(context) {
    final bloc = StoriesProvider.of(context);

    return RefreshIndicator(
      child: this.child,
      onRefresh: () async {
        await bloc.clearCache();
        await bloc.fetchTopIds();
      }
    );
  }
}