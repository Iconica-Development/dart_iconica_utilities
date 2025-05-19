import "package:dart_iconica_utilities/src/traverse/traverse.dart";

/// Extension on Map
extension GetDateTime on Map<dynamic, dynamic> {
  /// Method on Map to access a DateTime
  // ignore: type_annotate_public_apis
  DateTime getDateTime(key) =>
      traverseThen<String, DateTime>([key], DateTime.parse);

  /// Method on Map to access a DateTime or else return null
  // ignore: type_annotate_public_apis
  DateTime? maybeGetDateTime(key) => maybeTraverseThen<String, DateTime>(
        [key],
        (value) => DateTime.tryParse(value ?? ""),
      );
}
