import 'errors.dart';
import 'service.dart';
import '../cache.dart';

class SevnServiceContainer implements SevnCache<Type, SevnService> {
  static final SevnServiceContainer _instance =
      SevnServiceContainer._internal();

  final Map<Type, SevnService> _services = <Type, SevnService>{};

  factory SevnServiceContainer() => _instance;

  SevnServiceContainer._internal();

  bool has(Type type) => _services.containsKey(type);

  void $set(Type type, SevnService value) {
    _services[type] = value;
  }

  SevnService $get(Type type) {
    if (_services.containsKey(type)) {
      return _services[type];
    } else {
      throw SevnServiceNotFoundError(
        'No service of type \'${type.toString()}\' could be found',
      );
    }
  }
}
