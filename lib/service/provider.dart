import 'container.dart';
import 'errors.dart';
import 'service.dart';

typedef SevnServiceFactory<T extends SevnService> = T Function();

class SevnServiceProvider {
  static SevnServiceContainer _container = SevnServiceContainer();
  static final Map<Type, SevnServiceFactory> _registry =
      <Type, SevnServiceFactory>{};

  const SevnServiceProvider();

  static S provide<S extends SevnService>(Type type) {
    try {
      return _container.$get(type);
    } on SevnServiceNotFoundError {
      S service = _registry[type]();
      _container.$set(type, service);
      return SevnServiceProvider.provide(type);
    } on TypeError {
      throw SevnServiceRegistrationError(
        'The ${type.toString()} service has been requested but has not been registered with the provider.',
      );
    }
  }

  static void register<S extends SevnService>(
      SevnServiceFactory<S> serviceFactory) {
    if (_registry.containsKey(S)) {
      throw SevnServiceRegistrationError(
        'Skipping service registration for ${S.toString()}. Registration is allowed only once',
      );
    }
    _registry[S] = serviceFactory;
  }
}
