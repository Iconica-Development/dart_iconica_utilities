/// Extension for parsing
extension MapDoubleParsing on Map<dynamic, dynamic> {
  /// Method on [Map] to parse value to [double].
  // ignore: type_annotate_public_apis
  double getAsDouble(key) => double.parse("${this[key]}");

  /// Method on [Map] to parse value to [double] or [null].
  // ignore: type_annotate_public_apis
  double? maybeGetAsDouble(key) => double.tryParse("${this[key]}");

  /// Method on [Map] to parse value to [double] or some default.
  // ignore: type_annotate_public_apis
  double getAsDoubleOr(key, {double defaultValue = 0.0}) =>
      maybeGetAsDouble(key) ?? defaultValue;
}
