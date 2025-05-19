// SPDX-FileCopyrightText: 55 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

/// Extension on DateTime which enables comparing dates to each
extension DateTimeComparison on DateTime {
  /// Strips the time element of a datetime.
  ///
  /// Returns a new datetime where all values smaller than a day are stripped
  DateTime get date => DateTime(year, month, day);

  /// Compares this date to other.
  ///
  /// Returns a negative number if this is less than other, zero if they are
  /// equal, and a positive number if this is greater than other.
  ///
  /// Examples:
  ///
  /// ```
  /// print(DateTime(2021, 5, 3).compareByDateTo(DateTime(2023, 12, 9))); // => -1
  /// print(DateTime(2023, 12, 9).compareByDateTo(DateTime(2021, 2, 4))); // => 1
  /// print(DateTime(2023, 12, 9).compareByDateTo(DateTime(2023, 12, 9))); // => 0
  /// ```
  int compareByDateTo(DateTime other) => date.compareTo(other.date);

  /// Checks if only the date (year, month, day) are equal to [other]
  ///
  /// Uses the [compareByDateTo] function to evaluate equality
  bool isDateEqual(DateTime other) => compareByDateTo(other) == 0;

  /// Compares the time of this [DateTime] to [other].
  ///
  /// Returns a negative number if this is less than other, zero if they are
  /// equal, and a positive number if this is greater than other.
  ///
  /// Examples:
  ///
  /// ```
  /// print(DateTime(2021, 5, 1, 12, 0, 0).compareByTimeTo(DateTime(1999, 12, 9, 13, 0, 0))); // => -1
  /// print(DateTime(2021, 12, 9, 14, 0, 1).compareByDateTo(DateTime(2021, 12, 9, 14, 0, 0))); // => 1
  /// print(DateTime(2023, 10, 9, 12, 12, 12).compareByDateTo(DateTime(2023, 12, 10, 12, 12, 12))); // => 0
  /// ```
  int compareByTimeTo(DateTime other) {
    var otherDuration = other.difference(other.date);
    var duration = difference(date);
    return duration.compareTo(otherDuration);
  }

  /// Checks if only the time, all but(year, month, day) are equal to the
  /// time given through [hour], [minute], [second]
  ///
  /// Uses the [compareByDateTo] function to evaluate equality
  bool isTimeEqual(int hour, int minute, int second) =>
      compareByTimeTo(DateTime(1970, 1, 1, hour, minute, second)) == 0;
}
