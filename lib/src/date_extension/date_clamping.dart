// SPDX-FileCopyrightText: 2025 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

/// Extension on DateTime used for clamping a [DateTime]
/// between two other [DateTime]s
extension DateTimeClamping on DateTime {
  /// Clamps 2 dates between the given [start] and [end] dates.
  ///
  /// if [this] date is before [start], [start] is returned.
  /// Similar, if [this] is after [end], end is returned.
  ///
  /// The main purpose of this method is to coerce invalid input within the
  /// ranges that are needed, for example for a datetime picker.
  DateTime clamp(DateTime start, DateTime end) {
    if (isAfter(end)) return end;
    if (isBefore(start)) return start;

    return this;
  }
}
