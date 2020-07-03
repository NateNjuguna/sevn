import '../error/error.dart';

class SevnServiceNotFoundError extends SevnError {
  SevnServiceNotFoundError(String message)
      : super(
          message,
          'Sevn::ServiceNotFoundError',
        );
}

class SevnServiceRegistrationError extends SevnError {
  SevnServiceRegistrationError(String message)
      : super(
          message,
          'Sevn::ServiceRegistrationError',
        );
}
