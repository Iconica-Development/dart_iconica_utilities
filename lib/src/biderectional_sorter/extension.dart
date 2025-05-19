import "package:dart_iconica_utilities/src/biderectional_sorter/enum.dart";
import "package:dart_iconica_utilities/src/biderectional_sorter/functions.dart"
    as sorting;
import "package:dart_iconica_utilities/src/biderectional_sorter/sorter.dart";

/// Extension on list for bidirectional sorting
extension BidirectionalSorting<T> on List<T> {
  /// Method on List<T> to sort bidirectionally.
  List<T> bidirectionalSort({
    SortFieldGetter<T>? sortValueCallback,
    SortDirection sortDirection = SortDirection.ascending,
  }) {
    var value = this;

    sorting.sort(
      sortDirection,
      value,
      sortValueCallback,
    );

    return value;
  }

  /// Method on List<T> to sort bidirectionally with multiple sorting
  /// instructions.
  List<T> bidirectionalMultiSort(List<SortInstruction<T>> sortValueCallbacks) {
    var value = this;
    sorting.sortMulti(value, sortValueCallbacks);
    return value;
  }
}
