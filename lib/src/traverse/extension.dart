// SPDX-FileCopyrightText: 2025 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import "package:dart_iconica_utilities/src/traverse/exception.dart";

/// Extension for traversing through a map
extension MapTraversal on Map<dynamic, dynamic> {
  /// Traverse a Map returning the entry found if it has type [R].
  R traverse<R>(List<dynamic> path) {
    dynamic value = this;

    // Used for TraversalException
    ({dynamic step, dynamic value}) previous = (step: null, value: null);

    try {
      for (var (index, step) in path.indexed) {
        var isFinal = (index == path.length - 1);
        previous = (step: step, value: value);

        // Only allow null when it is the very final item
        // ignore: avoid_dynamic_calls
        value = value[step] ?? (!isFinal ? throw Exception() : null);
      }
    } catch (e) {
      throw TraversalException(
        currentValue: previous.value,
        accessor: previous.step,
        replacing: e,
      );
    }

    return value as R;
  }

  /// Traverse a Map returning the entry found if it has type [R].
  /// On error returns _null_
  R? maybeTraverse<R>(List<dynamic> path) {
    try {
      return traverse<R>(path);
      // ignore: avoid_catches_without_on_clauses
    } catch (_) {
      return null;
    }
  }

  /// Traverse a Map passing the found value of type [V] through to
  /// the _then_ function, and returning type [R].
  R traverseThen<V, R>(List<dynamic> path, R Function(V value) then) =>
      then(traverse<V>(path));

  /// Traverse a Map passing the found value of type [V] or _null_ through to
  /// the _then_ function, and returning type [R] or _null_.
  R? maybeTraverseThen<V, R>(List<dynamic> path, R? Function(V? value) then) =>
      then(maybeTraverse<V?>(path));
}
