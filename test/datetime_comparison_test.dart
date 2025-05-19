import "package:dart_iconica_utilities/src/date_extension/date_extension.dart";
import "package:test/test.dart";

void main() {
  group("DatetimeComparison", () {
    group("compareByDateTo", () {
      /// print(DateTime(2021, 5, 3).compareByDateTo(DateTime(2022, 12, 9))); // => -1
      /// print(DateTime(2022, 12, 9).compareByDateTo(DateTime(2021, 2, 4))); // => 1
      /// print(DateTime(2022, 12, 9).compareByDateTo(DateTime(2022, 12, 9))); // => 0
      test(
        "should return -1 if the other date is greater than this date",
        () {
          expect(
            DateTime(2021, 5, 3).compareByDateTo(DateTime(2022, 12, 9)),
            equals(-1),
          );
        },
      );

      test(
        "should return 1 if the other date is lower than this date",
        () {
          expect(
            DateTime(2022, 12, 9).compareByDateTo(DateTime(2021, 2, 4)),
            equals(1),
          );
        },
      );

      test(
        """should return 0 if the other date is the same as this date, regardless of time""",
        () {
          expect(
            DateTime(2021, 12, 9, 0, 0, 0).compareByDateTo(
              DateTime(2021, 12, 9, 1, 1, 1),
            ),
            equals(0),
          );
        },
      );
    });

    group("isDateEqual", () {
      test("should return false if the dates are not the same", () {
        expect(DateTime(1, 1, 1).isDateEqual(DateTime(1, 1, 2)), isFalse);
        expect(
          DateTime(2020, 12, 31, 23, 59, 59).isDateEqual(DateTime(2021, 1, 1)),
          isFalse,
        );
        expect(DateTime(1, 1, 2).isDateEqual(DateTime(1, 1, 1)), isFalse);
      });

      test("should return true if the dates are the same", () {
        expect(DateTime(1, 1, 1).isDateEqual(DateTime(1, 1, 1)), isTrue);
        expect(
          DateTime(2020, 12, 31, 23, 59, 59)
              .isDateEqual(DateTime(2020, 12, 31)),
          isTrue,
        );
      });
    });

    group("date", () {
      test("should strip all time information from the date", () {
        expect(
            DateTime(2012, 12, 12, 1, 1, 1, 1, 1).date,
            // ignore: require_trailing_commas
            equals(DateTime(2012, 12, 12)));
      });
    });
  });
}
