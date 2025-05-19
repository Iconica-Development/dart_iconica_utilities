// SPDX-FileCopyrightText: 2025 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import "package:dart_iconica_utilities/src/biderectional_sorter/enum.dart";
import "package:dart_iconica_utilities/src/biderectional_sorter/sorter.dart";

/// Generic sort method, allow sorting of list with primitives or complex types.
/// Uses [SortDirection] to determine the direction, either Ascending or
/// Descending.
/// Gets called on [List] toSort of type [T] which cannot be shorter than 2.
/// Optionally for complex types a [Comparable] [Function] can be given to
/// compare complex types.
/// ```
/// List<TestObject> objects = [];
///   for (int i = 0; i < 10; i++) {
///     objects.add(TestObject(name: "name", id: i));
///   }
///
/// sort<TestObject>(
///   SortDirection.descending, objects, (object) => object.id);
///
/// ```
/// In the above example a list of TestObjects is created
/// and then sorted in descending order.
///
/// If the implementation of TestObject is as following:
/// ```
/// class TestObject {
///  final String name;
///  final int id;
///
///  TestObject({required this.name, required this.id});
/// }
/// ```
/// And the list is logged to the console, the following will appear:
/// ```
/// [name9, name8, name7, name6, name5, name4, name3, name2, name1, name0]
/// ```
void sort<T>(
  /// Determines the sorting direction, can be either Ascending or Descending
  SortDirection sortDirection,

  /// Incoming list, which gets sorted
  List<T> toSort, [
  /// Optional comparable, which is only necessary for complex types
  SortFieldGetter<T>? sortValueCallback,
]) {
  if (toSort.length < 2) return;
  assert(
    toSort.whereType<Comparable>().isNotEmpty || sortValueCallback != null,
    "",
  );
  BidirectionalSorter<T>(
    sortInstructions: [
      SortInstruction<T>(
        sortValueCallback ?? (t) => t as Comparable,
        sortDirection,
      ),
    ],
  ).sort(toSort);
}

/// same functionality as [sort] but with the added functionality
/// of sorting multiple values
void sortMulti<T>(
  /// Incoming list, which gets sorted
  List<T> toSort,

  /// list of comparables to sort multiple values at once,
  /// priority based on index
  List<SortInstruction<T>> sortValueCallbacks,
) {
  if (toSort.length < 2) return;

  assert(
    sortValueCallbacks.isNotEmpty,
    "sortValueCallbacks should not be empty",
  );

  BidirectionalSorter<T>(
    sortInstructions: sortValueCallbacks,
  ).sort(toSort);
}
