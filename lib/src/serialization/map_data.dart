import "package:dart_iconica_utilities/src/traverse/traverse.dart";

/// Transforms a Map value into [T].
typedef MapValueTransformer<T> = T Function(Map<String, dynamic> value);

/// Extension on [Map] to immediately transform the value.
extension MappedOrNull on Map<dynamic, dynamic> {
  /// Get value and transform it to [T].
  // ignore: type_annotate_public_apis
  T? getMapped<T>(key, MapValueTransformer<T> transform) =>
      traverseThen<Map<String, dynamic>, T>([key], transform);

  /// Get value and transform it to [T] or `null`.
  // ignore: type_annotate_public_apis
  T? getMappedOrNull<T>(key, MapValueTransformer<T> transform) =>
      maybeTraverseThen<Map<String, dynamic>, T>(
        [key],
        (value) => (value is Map<String, dynamic>) ? transform(value) : null,
      );
}
