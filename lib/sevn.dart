library sevn;

export 'cache.dart';
export 'error.dart';
export 'exception.dart';
export 'field.dart';
export 'list.dart';
export 'loader.dart';
export 'model.dart';
export 'nav.dart';
export 'service.dart';
export 'tab.dart';

import 'service/provider.dart';
import 'service/service.dart';

class Sevn {
  /// Register multiple [SevnService]s at time
  ///
  /// This is very useful when adding booting an application which has many
  /// services to be registered
  ///
  /// See:
  ///
  ///  * [SevnServiceProvider.register]
  ///  * [SevnServiceFactory]
  ///
  static void registerServices<S extends SevnService>(
      List<SevnServiceFactory<S>> serviceFactories) {
    serviceFactories.forEach((SevnServiceFactory<S> serviceFactory) =>
        SevnServiceProvider.register(serviceFactory));
  }
}
