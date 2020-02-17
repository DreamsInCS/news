import 'package:flutter/material.dart';
import 'stories_bloc.dart';

// If stories_provider is imported, now stories_bloc is, too!
// Using a StoriesBloc instance from the StoriesProvider requires that the bloc be imported
export 'stories_bloc.dart';

class StoriesProvider extends InheritedWidget {
  final StoriesBloc bloc;

  StoriesProvider({Key key, Widget child})
    : bloc = StoriesBloc(),
      super(key: key, child: child);
    
  bool updateShouldNotify(_) => true;

  static StoriesBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<StoriesProvider>().bloc;
  }
}