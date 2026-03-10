import "package:dart_iconica_utilities/src/value_validator/exception.dart";
import "package:dart_iconica_utilities/src/value_validator/models.dart";

///
extension MapValidator on SerializedObjectValidator {
  ///
  void validate(Map<String, dynamic> toValidate) {
    try {
      var issues = <String, dynamic>{};
      for (var fieldToValidate in keys) {
        var validator = this[fieldToValidate];
        var value = toValidate[fieldToValidate];
        var validatedResult = validator?.validate(value);
        if (validatedResult != null) {
          issues[fieldToValidate] = validatedResult;
        }
      }
      if (issues.isNotEmpty) {
        throw ValidationException(
          validationMessages: issues,
        );
      }
    } on ValidationException catch (e) {
      var newBody = {
        ...e.validationMessages,
        "expected": asJson(),
      };
      throw ValidationException(validationMessages: newBody);
    }
  }
}

///
extension ValidatorJsonRepresentation on SerializedObjectValidator {
  ///
  Map<String, dynamic> asJson() => map(
        (key, value) => MapEntry(
          key,
          value.asJson(),
        ),
      );
}
