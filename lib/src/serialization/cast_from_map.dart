/// Extension on Map that allows for (nullable) casting.
extension CastFromMap on Map<dynamic, dynamic> {
  /// Cast the value for accessor `key` to [T].
  T cast<T>(String key) => this[key] as T;

  /// Cast the value for accessor `key` to [T] or return `null`.
  T? castOrNull<T>(String key) {
    var value = this[key];

    if (value is T) return value;

    return null;
  }
}
