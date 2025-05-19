import "package:dart_iconica_utilities/src/serialization/double_from_map.dart";
import "package:test/test.dart";

void main() {
  group("JsonDoubleParsing", () {
    group("getAsDoubleOr", () {
      var sut = <String, dynamic>{
        "value": 1.0,
      };
      test("should return value if value exists", () {
        expect(sut.getAsDoubleOr("value"), equals(1.0));
      });
      test(
        "should return 0.0 if no value exists while no default is provided",
        () {
          expect(sut.getAsDoubleOr("no_value"), equals(0.0));
        },
      );
      test("should return defaultvalue if no value exists", () {
        expect(sut.getAsDoubleOr("no_value", defaultValue: 2.0), equals(2.0));
      });
    });

    group("(maybe)GetAsDouble", () {
      var sut = <String, dynamic>{
        "string": "1.0",
        "string_int": "1",
        "int": 1,
        "empty_string": "",
        "object": {},
        "null": null,
        "double": 1.0,
      };

      test(
        "should properly parse strings to doubles",
        () {
          expect(sut.getAsDouble("string"), equals(1.0));
          expect(sut.getAsDouble("string_int"), equals(1.0));
          expect(sut.maybeGetAsDouble("empty_string"), isNull);
        },
      );

      test(
        "should properly parse ints to doubles",
        () {
          expect(sut.getAsDouble("int"), equals(1.0));
        },
      );

      test(
        "should properly retrieve doubles",
        () {
          expect(sut.getAsDouble("double"), equals(1.0));
        },
      );

      test(
        "should return null if result does not exist",
        () {
          expect(sut.maybeGetAsDouble("does_not_exist"), isNull);
          expect(sut.maybeGetAsDouble("null"), isNull);
        },
      );

      test(
        "should return null if result is not parseable",
        () {
          expect(sut.maybeGetAsDouble("object"), isNull);
        },
      );
    });
  });
}
