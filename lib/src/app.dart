import 'package:flutter/material.dart';
import 'blocs/stories_provider.dart';
import 'blocs/comments_provider.dart';
import 'screens/news_list.dart';
import 'screens/news_detail.dart';

class App extends StatelessWidget {
  Widget build (context) {
    return CommentsProvider(
      child: StoriesProvider(
        child: MaterialApp(
          title: 'Hacker News',
          onGenerateRoute: routes
        )
      )
    );
  }

  Route routes(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (context) {
            final storiesBloc = StoriesProvider.of(context);

            storiesBloc.fetchTopIds();

            return NewsList();
          }
        );
        break;

      default:
        return MaterialPageRoute(
          builder: (context) {
            final int itemId = int.parse(settings.name.replaceFirst('/', ''));
            final commentsBloc = CommentsProvider.of(context);

            commentsBloc.fetchItemWithComments(itemId);

            return NewsDetail(
              itemId: itemId
            );
          }
        );
    }
  }
}