import 'package:rxdart/rxdart.dart';
import '../models/item_model.dart';
import '../resources/repository.dart';

class CommentsBloc {
  final _repository = Repository();
  final _commentsFetcher = PublishSubject<int>();
  final _commentsOutput = BehaviorSubject<Map<int, Future<ItemModel>>>();

  // Getters for Streams
  Stream<Map<int, Future<ItemModel>>> get itemWithComments => _commentsOutput.stream;

  // Getters for Sinks
  Function(int) get fetchItemWithComments => _commentsFetcher.sink.add;

  CommentsBloc() {
    _commentsFetcher.stream
      .transform(_commentsTransformer())
      .pipe(_commentsOutput);
  }

  _commentsTransformer() {
    // A more effective approach for this would use a transformer with fromHandlers() and write this whole process
    // without tinkering with data out of reach of this method

    return ScanStreamTransformer<int, Map<int, Future<ItemModel>>>(
      (cache, int id, int index) {
        cache[id] = _repository.fetchItem(id);
        cache[id].then((ItemModel item) {                               // When the Future in this data resolves...
          item.kids.forEach((kidId) => fetchItemWithComments(kidId));
        });   // Visit each kid and perform the process on them!
        return cache;
      },
      <int, Future<ItemModel>>{}    // Empty map to serve as our cache (remember that we use this as our accumulator to accumulate data)
    );
  }

  void dispose() {
    _commentsFetcher.close();
    _commentsOutput.close();
  }
}