//Custom Exception called Server Exception to catch any server-side errors
class ServerException implements Exception {
  final String message;

  const ServerException({
    required this.message,
  });

  @override
  String toString() {
    return 'ServerException{message: $message}';
  }
}
