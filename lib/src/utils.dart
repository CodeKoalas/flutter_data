part of flutter_data;

class DataHelpers {
  static final uuid = Uuid();

  static String getType<T>([String type]) {
    if (T == dynamic && type == null) {
      return null;
    }
    return (type ?? T.toString()).toLowerCase().pluralize();
  }

  static String generateKey<T>([String type]) {
    final ts = getType<T>(type);
    if (ts == null) {
      return null;
    }
    return '${getType<T>(type)}#${uuid.v1().substring(0, 8)}';
  }
}

// initialization helpers

/// For exclusive internal use of global service locator
/// integration such as `get_it`'s
dynamic debugGlobalServiceLocatorInstance;

class RepositoryInitializer {}

class RepositoryInitializerArgs {
  RepositoryInitializerArgs(this.remote, this.verbose, this.alsoInitialize);

  final bool remote;
  final bool verbose;
  final FutureProvider alsoInitialize;

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is RepositoryInitializerArgs &&
            other.remote == remote &&
            other.verbose == verbose &&
            other.alsoInitialize == alsoInitialize);
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      remote.hashCode ^
      verbose.hashCode ^
      alsoInitialize.hashCode;
}

@protected
mixin NothingMixin {}

// private utilities

abstract class _Lifecycle<T> {
  bool _isInit = false;

  @mustCallSuper
  // ignore: missing_return
  FutureOr<T> initialize() async {
    _isInit = true;
  }

  @protected
  bool get isInitialized => _isInit;

  @mustCallSuper
  Future<void> dispose() async {}
}

// misc extensions

extension _IterableX<T> on Iterable<T> {
  bool containsFirst(T model) => isNotEmpty ? first == model : false;
  Iterable<T> get filterNulls => where((elem) => elem != null);
  List<T> toImmutableList() => List.unmodifiable(this);
}

extension StringUtilsX on String {
  String capitalize() =>
      isEmpty ? '' : '${this[0].toUpperCase()}${substring(1)}';
  String pluralize() => inflection.pluralize(this);
  String singularize() => inflection.singularize(this);
}

extension _MapX<K, V> on Map<K, V> {
  Map<K, V> operator &(Map<K, V> more) => {...this, ...?more};
}

// state notifier utils

class ValueStateNotifier<E> extends StateNotifier<E> {
  ValueStateNotifier([E state]) : super(state);
  E get value => state;
  set value(E value) => state = value;
}
