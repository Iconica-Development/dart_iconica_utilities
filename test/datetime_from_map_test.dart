import "package:dart_iconica_utilities/src/serialization/serialization.dart";
import "package:test/test.dart";

void main() {
  group("GetNullableDateTime", () {
    group("getDateTime", () {
      var sut = <String, dynamic>{
        "parseable": DateTime(2012, 12, 12).toIso8601String(),
        "incorrect": "incorrect",
        "wrong_type": 1,
      };

      test("should return a datetime if the datetime is parseable", () {
        var datetime = sut.getDateTime("parseable");

        expect(datetime, equals(DateTime(2012, 12, 12)));
      });
      test("should return null if the datetime is not parseable", () {
        expect(sut.maybeGetDateTime("incorrect"), null);
      });
      test("should return null if no value exists", () {
        expect(sut.maybeGetDateTime("wrong_key"), null);
      });
    });
  });
}
