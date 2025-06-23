///
class ValidationException implements Exception {
  ///
  ValidationException({
    required this.validationMessages,
  });

  ///
  final Map<String, dynamic> validationMessages;
}
