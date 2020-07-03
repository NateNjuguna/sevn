import 'service.dart';
import 'provider.dart';

mixin SevnInjectable {
  ///
  ///Retrieve a service from the injected service cache
  ///
  ///@return SevnService
  ///
  S $sevn<S extends SevnService>() => SevnServiceProvider.provide(S);
}
