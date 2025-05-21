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
    Map<String, List<String>>? preCalculatedSeperated,
  }) {
    Map<String, List<String>> seperateCurrent(List<String> paths) {
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

    var propertyJoinedPaths = preCalculatedSeperated ?? seperateCurrent(paths);

    dynamic handleChildren(String key, List<String> remainingPaths) {
      var value = this[key];

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
        var preCalculatedSeperated = seperateCurrent(remainingPaths);
        return value
            .whereType<Map<String, dynamic>>()
            .map(
              (item) => item.select(
                remainingPaths,
                preCalculatedSeperated: preCalculatedSeperated,
              ),
            )
            .where((item) => item.isNotEmpty)
            .toList();
      }

      return value;
    }

    var createdMap = {
      for (final entry in propertyJoinedPaths.entries)
        if (this[entry.key] != null)
          entry.key: handleChildren(entry.key, entry.value),
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
    Map<String, List<String>>? preCalculatedSeperated,
  }) {
    Map<String, List<String>> seperateCurrent(List<String> paths) {
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

    var separated = preCalculatedSeperated ?? seperateCurrent(paths);

    bool isOmitted(MapEntry<String, dynamic> entry) {
      var paths = separated[entry.key];

      if (paths == null) return false;
      if (paths.isNotEmpty) return false;
      return true;
    }

    dynamic handleChildren(MapEntry<String, dynamic> entry) {
      var paths = separated[entry.key];
      var value = entry.value;

      if (paths == null || paths.isEmpty) {
        return entry.value;
      }

      if (value is Map<String, dynamic>) {
        return value.omit(paths);
      }

      if (value is List) {
        var preCalculatedSeperated = seperateCurrent(paths);
        return value
            .whereType<Map<String, dynamic>>()
            .map(
              (item) => item.omit(
                paths,
                preCalculatedSeperated: preCalculatedSeperated,
              ),
            )
            .where((item) => item.isNotEmpty)
            .toList();
      }
      return value;
    }

    return {
      for (final entry in entries)
        if (!isOmitted(entry)) entry.key: handleChildren(entry),
    };
  }
}
