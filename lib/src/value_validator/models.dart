import "package:dart_iconica_utilities/src/value_validator/exception.dart";
import "package:dart_iconica_utilities/src/value_validator/extension.dart";

///
class ValueValidator {
  ///
  ValueValidator({
    required this.validator,
    this.optional = false,
    this.jsonRepresentation,
  });

  ///
  ValueValidator.map({
    this.optional = false,
    CustomValidator? validator,
    SerializedObjectValidator validators = const {},
  }) {
    jsonRepresentation = validators.asJson();
    this.validator = (value) {
      if (value is! Map) {
        return "This field requires a map";
      }
      if (value.keys.any((element) => element is! String)) {
        return "The keys of this map are required to be strings";
      }
      try {
        validators.validate(Map<String, dynamic>.from(value));
      } on ValidationException catch (e) {
        return e.validationMessages;
      }
      return validator?.call(value);
    };
  }

  ///
  ValueValidator.bool({
    this.optional = false,
    this.jsonRepresentation = "Boolean",
    CustomValidator? validator,
  }) {
    this.validator = (value) {
      if (value is! bool) {
        return "This field requires a Boolean";
      }
      return validator?.call(value);
    };
  }

  ///
  ValueValidator.list({
    this.optional = false,
    CustomValidator? validator,
    ValueValidator? childValidator,
  }) {
    jsonRepresentation = [
      childValidator?.asJson() ?? "any",
    ];
    this.validator = (value) {
      if (value is! List) {
        return "This field requires a List";
      }
      var error = value
          .map((e) => childValidator?.validate(e))
          .where((element) => element != null)
          .firstOrNull;
      if (error != null) {
        return [error];
      }
      return validator?.call(value);
    };
  }

  ///
  ValueValidator.string({
    this.optional = false,
    this.jsonRepresentation = "String",
    CustomValidator? validator,
  }) {
    this.validator = (value) {
      if (value is! String) {
        return "This field requires a String";
      }
      return validator?.call(value);
    };
  }

  ///
  ValueValidator.double({
    this.optional = false,
    this.jsonRepresentation = "double",
    CustomValidator? validator,
  }) {
    this.validator = (value) {
      if (value is! num) {
        var parsed = num.tryParse(value.toString());
        if (parsed == null) {
          return "This value requires a double";
        }
      }
      return validator?.call((value! as num).toDouble());
    };
  }

  ///
  ValueValidator.int({
    this.optional = false,
    this.jsonRepresentation = "int",
    CustomValidator? validator,
  }) {
    this.validator = (value) {
      if (value is! num && value is! double && value is! int) {
        var parsed = num.tryParse(value.toString());
        if (parsed == null) {
          return "This field requires an Integer";
        }
        if (parsed.roundToDouble() != parsed) {
          return "This field requires an Integer";
        }
        return validator?.call(value);
      }

      var correctNumber = value! as num;

      if (correctNumber.roundToDouble() != correctNumber.toDouble()) {
        return "This field requires an Integer";
      }
      return validator?.call(value);
    };
  }

  /// Creates a ValueValidator that validates a string to be a validate time
  /// stamp in the format of HH:mm:ss or HH:mm
  ///
  /// Note that if [acceptSeconds] is true the inputted value can still ommit
  /// the seconds. In that case the seconds should be considered set to 0.
  ValueValidator.time({
    this.optional = false,
    this.jsonRepresentation = "String",
    CustomValidator? validator,
    bool acceptSeconds = true,
  }) {
    this.validator = validator ??
        (value) {
          if (value is! String) {
            return "This field requires a String";
          }

          var splittedValues = value.split(":");

          // First validate if the string is xx:xx:xx
          if (splittedValues.length < 2) {
            if (acceptSeconds) {
              return "The value should be in the HH:mm or HH:mm:ss format";
            }

            return "The value should be in the HH:mm format";
          }

          if (acceptSeconds && splittedValues.length > 3) {
            return "The value should be in the HH:mm:ss format";
          }

          // Secondly validate if the strings contains valid hours, minutes and
          // optionally seconds
          var hours = int.tryParse(splittedValues[0]);
          var minutes = int.tryParse(splittedValues[1]);
          if (hours == null || minutes == null) {
            return "The value contains no valid hours or minutes";
          }

          if (hours >= 24 || hours < 0) {
            return "There are only 24 hours in a day";
          }

          if (minutes >= 60 || minutes < 0) {
            return "There are only 60 minutes in an hour";
          }

          if (splittedValues.length == 3 && acceptSeconds) {
            var seconds = int.tryParse(splittedValues[2]);
            if (seconds == null) {
              return "The value contains no valid seconds";
            }

            if (seconds >= 60 || seconds < 0) {
              return "There are only 60 seconds in a second";
            }
          }

          return null;
        };
  }

  ///
  final bool optional;

  ///
  late final CustomValidator validator;

  ///
  late final dynamic jsonRepresentation;

  ///
  dynamic asJson() => jsonRepresentation ?? "json";

  ///
  // ignore: avoid_annotating_with_dynamic
  dynamic validate(dynamic value) {
    if (value == null) {
      if (optional) return null;

      return "This field is required!";
    }

    return validator(value);
  }

  ///
  ValueValidator get asOptional => ValueValidator(
        optional: true,
        validator: validator,
        jsonRepresentation: jsonRepresentation,
      );
}

///
// ignore: avoid_annotating_with_dynamic
typedef CustomValidator = dynamic Function(dynamic value);

///
typedef SerializedObjectValidator = Map<String, ValueValidator>;

///
extension OptionalObjectValidator on SerializedObjectValidator {
  ///
  SerializedObjectValidator get optional =>
      map((key, value) => MapEntry(key, value.asOptional));
}
