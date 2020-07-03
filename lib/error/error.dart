class SevnError extends Error {
  final String message;
  final String title;

  SevnError(this.message, [this.title = 'Error']);

  String toString() => '$title - $message';
}
