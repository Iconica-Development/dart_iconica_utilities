import "package:dart_iconica_utilities/src/select_map/select_map.dart";
import "package:dart_iconica_utilities/src/value_validator/value_validator.dart";

///
class Serializer<T> {
  ///
  const Serializer({
    required this.fromMap,
    required this.toMap,
    this.validators = const {},
    this.fieldPaths = const [],
    this.data,
  });

  ///
  factory Serializer.readOnly({
    required Map<String, dynamic> Function(T object) toMap,
    required SerializedObjectValidator validators,
    List<String> fieldPaths = const [],
    Map<String, dynamic>? data,
  }) =>
      Serializer(
        fromMap: (_) => throw SerializerReadOnlyException(),
        toMap: toMap,
        validators: validators,
        fieldPaths: fieldPaths,
        data: data,
      );

  ///
  factory Serializer.writeOnly({
    required T Function(Map<String, dynamic> map) fromMap,
    required SerializedObjectValidator validators,
    List<String> fieldPaths = const [],
    Map<String, dynamic>? data,
  }) =>
      Serializer(
        fromMap: fromMap,
        toMap: (_) => throw SerializerWriteOnlyException(),
        validators: validators,
        fieldPaths: fieldPaths,
        data: data,
      );

  ///
  final SerializedObjectValidator validators;

  ///
  final T Function(Map<String, dynamic> map) fromMap;

  ///
  final Map<String, dynamic> Function(T object) toMap;

  ///
  final Map<String, dynamic>? data;

  ///
  final List<String> fieldPaths;

  ///
  bool validate({
    bool raiseException = false,
  }) {
    try {
      validators.validate(data ?? {});
      return true;
    } on ValidationException {
      if (raiseException) rethrow;
      return false;
    }
  }

  ///
  Serializer<T> withData(Map<String, dynamic> data) => Serializer(
        toMap: toMap,
        fromMap: fromMap,
        validators: validators,
        data: data,
        fieldPaths: fieldPaths,
      );

  ///
  Serializer<T> withObject(T object) => withData(toMap(object));

  ///
  Map<String, dynamic> serialize() {
    var data = this.data ?? {};
    if (fieldPaths.isEmpty) {
      return data;
    }

    return data.select(fieldPaths);
  }
}

///
class SerializerWriteOnlyException implements Exception {}

///
class SerializerReadOnlyException implements Exception {}
