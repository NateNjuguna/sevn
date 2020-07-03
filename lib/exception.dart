class SevnException implements Exception {
  final String message;
  final String title;

  SevnException(this.message, [this.title = 'Error']);

  String toString() => '$title - $message';
}
