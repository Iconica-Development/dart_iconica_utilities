// SPDX-FileCopyrightText: 2025 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

/// Exception thrown when the traversal fails
class TraversalException implements Exception {
  /// TraversalException constructor
  const TraversalException({this.currentValue, this.accessor, this.replacing});

  /// The value for which exception was thrown.
  final dynamic currentValue;

  /// The accessor used when the exception was thrown.
  final dynamic accessor;

  /// The Error or Exception it's replacing.
  final dynamic replacing;

  @override
  String toString() => """
TraversalException: Accessor [$accessor] does not exist in value ($currentValue).
\t|--> Replacing: ${replacing.runtimeType}<$replacing>
""";
}
