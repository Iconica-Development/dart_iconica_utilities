// SPDX-FileCopyrightText: 2025 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import "package:dart_iconica_utilities/src/biderectional_sorter/enum.dart";

/// A function to get the field to sort on.
typedef SortFieldGetter<T> = Comparable Function(T sortable);

/// Instruction of how to sort and in what direction.
class SortInstruction<T> {
  ///  SortInstruction constructor
  const SortInstruction(
    this.getSortValue,
    this.sortDirection,
  );

  /// Direction in which the sorting happens (ascending or descending).
  final SortDirection sortDirection;

  /// A function that returns a comparable.
  final SortFieldGetter<T> getSortValue;
}

/// A sorter class that takes sorting instructions.
class BidirectionalSorter<T> {
  ///  BidirectionalSorter constructor
  const BidirectionalSorter({
    required this.sortInstructions,
  });

  /// A list of sorting instructions
  final List<SortInstruction<T>> sortInstructions;

  /// Method that receives a list of items to sort.
  void sort(List<T> toSort) {
    toSort.sort((a, b) {
      for (var sortInstruction in sortInstructions) {
        var sortInstructionCallback = sortInstruction.getSortValue;
        var aSortValue = sortInstructionCallback(a);
        var bSortValue = sortInstructionCallback(b);

        if (aSortValue == bSortValue) continue;

        return switch (sortInstruction.sortDirection) {
          SortDirection.ascending => aSortValue.compareTo(bSortValue),
          SortDirection.descending => bSortValue.compareTo(aSortValue),
        };
      }

      return 0;
    });
  }
}
