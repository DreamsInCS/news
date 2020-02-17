import 'package:rxdart/rxdart.dart';
import '../models/item_model.dart';
import '../resources/repository.dart';

class StoriesBloc {
  final _repository = Repository();
  final _topIds = PublishSubject<List<int>>();

  // Streams will execute multiple instances of stream subscriptions upon transformation (thereby making many API calls), 
  // having a controller dedicated to interacting with the transformer and giving the cache to another controller
  // circumvents this issue
  final _itemsOutput = BehaviorSubject<Map<int, Future<ItemModel>>>();
  final _itemsFetcher = PublishSubject<int>();

  // Getters to Streams
  Stream<List<int>> get topIds => _topIds.stream;
  Stream<Map<int, Future<ItemModel>>> get items => _itemsOutput.stream;

  // Getters to Sinks
  Function(int) get fetchItem => _itemsFetcher.sink.add;


  StoriesBloc() {
    // Transform our id into a cache map that can easily retrieve the relevant item model
    // We use pipe() as a convenient way to send the cache map directly to the itemsOutput controller
    _itemsFetcher.stream.transform(_itemsTransformer()).pipe(_itemsOutput);
  }

  fetchTopIds() async {
    final ids = await _repository.fetchTopIds();
    _topIds.sink.add(ids);
  }

  clearCache() async {
    return _repository.clearCache();
  }

  _itemsTransformer() {
    return ScanStreamTransformer(
      (Map<int, Future<ItemModel>> cache, int id, _) {
        cache[id] = _repository.fetchItem(id);
        return cache;
      },
      <int, Future<ItemModel>>{},

    );
  }

  dispose() {
    _topIds.close();
    _itemsFetcher.close();
    _itemsOutput.close();
  }
}