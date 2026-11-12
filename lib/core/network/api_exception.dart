/// Thrown by [ApiClient] for any failed request - network errors, non-2xx
/// responses, or unparseable bodies. `message` is safe to show directly
/// in an [ErrorView].
class ApiException implements Exception {
  final String message;
  const ApiException(this.message);

  @override
  String toString() => message;
}
