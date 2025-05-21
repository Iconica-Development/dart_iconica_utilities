/// Extension on Map<String, dynamic> for the select method.
extension SelectFields on Map<String, dynamic> {
  /// Selects values in a map, if any match the given [paths].
  ///
  /// [paths] needs to be a list of strings with a . delimiter. The delimiter
  /// can be changed, if the keys also contain the delimiter.
  ///
  /// Selecting a child value from an inner map will automatically include the
  /// property that contains the full map, but only the inner map.
  ///
  /// Even for lists, you can select the objects internally if those objects
  /// are included. If the selector results in an empty list or empty map, it
  /// will automatically remove those from the returned value.
  ///
  Map<String, dynamic> select(
    List<String> paths, {
    String delimiter = ".",
    Map<String, List<String>>? preCalculatedSeparated,
  }) {
    var propertyJoinedPaths =
        preCalculatedSeparated ?? _seperateCurrent(paths, delimiter);

    var createdMap = {
      for (final entry in propertyJoinedPaths.entries)
        if (this[entry.key] != null)
          entry.key:
              _handleChildrenSelect(this, delimiter, entry.key, entry.value),
    };

    return createdMap;
  }
}

/// Extension on Map<String, dynamic> for the omit method.
extension OmitFields on Map<String, dynamic> {
  /// Omits values in a map, if any match the given [paths].
  ///
  /// [paths] needs to be a list of strings with a . delimiter. The delimiter
  /// can be changed, if the keys also contain the delimiter.
  ///
  Map<String, dynamic> omit(
    List<String> paths, {
    String delimiter = ".",
    Map<String, List<String>>? preCalculatedSeparated,
  }) {
    var separated =
        preCalculatedSeparated ?? _seperateCurrent(paths, delimiter);

    return {
      for (final entry in entries)
        if (!_isOmitted(separated, entry))
          entry.key: _handleChildrenOmit(separated, delimiter, entry),
    };
  }
}

dynamic _handleChildrenSelect(
  Map<String, dynamic> map,
  String delimiter,
  String key,
  List<String> remainingPaths,
) {
  var value = map[key];

  if (remainingPaths.isEmpty) {
    return value;
  }

  if (value is Map<String, dynamic>) {
    var selected = value.select(
      remainingPaths,
    );
    if (selected.isEmpty) {
      return null;
    }

    return selected;
  }

  if (value is List) {
    var preCalculatedSeparated = _seperateCurrent(remainingPaths, delimiter);
    return value
        .whereType<Map<String, dynamic>>()
        .map(
          (item) => item.select(
            remainingPaths,
            preCalculatedSeparated: preCalculatedSeparated,
          ),
        )
        .where((item) => item.isNotEmpty)
        .toList();
  }

  return value;
}

dynamic _handleChildrenOmit(
  Map<String, List<String>> separated,
  String delimiter,
  MapEntry<String, dynamic> entry,
) {
  var paths = separated[entry.key];
  var value = entry.value;

  if (paths == null || paths.isEmpty) {
    return entry.value;
  }

  if (value is Map<String, dynamic>) {
    return value.omit(paths);
  }

  if (value is List) {
    var preCalculatedSeparated = _seperateCurrent(paths, delimiter);
    return value
        .whereType<Map<String, dynamic>>()
        .map(
          (item) => item.omit(
            paths,
            preCalculatedSeparated: preCalculatedSeparated,
          ),
        )
        .where((item) => item.isNotEmpty)
        .toList();
  }
  return value;
}

bool _isOmitted(
  Map<String, List<String>> separated,
  MapEntry<String, dynamic> entry,
) {
  var paths = separated[entry.key];

  if (paths == null) return false;
  if (paths.isNotEmpty) return false;
  return true;
}

Map<String, List<String>> _seperateCurrent(
  List<String> paths,
  String delimiter,
) {
  var splitPaths = paths.map((item) => item.split(delimiter));
  return splitPaths.fold(<String, List<String>>{}, (map, split) {
    if (split.isEmpty) return map;
    var current = split.first;

    var remaining = split.sublist(1).join(delimiter);
    var currentMap = map[current] ??= [];
    if (remaining.isNotEmpty) {
      currentMap.add(remaining);
    }
    return map;
  });
}
