import "package:dart_iconica_utilities/src/value_validator/exception.dart";
import "package:dart_iconica_utilities/src/value_validator/extension.dart";
import "package:dart_iconica_utilities/src/value_validator/models.dart";
import "package:test/test.dart";

void main() {
  group("ValueValidator.string", () {
    var validator = ValueValidator.string();

    test("Valid string passes", () {
      expect(validator.validate("hello"), isNull);
    });

    test("Invalid non-string fails", () {
      expect(validator.validate(123), "This field requires a String");
    });

    test("Null fails if not optional", () {
      expect(validator.validate(null), "This field is required!");
    });

    test("Null passes if optional", () {
      expect(ValueValidator.string(optional: true).validate(null), isNull);
    });
  });

  group("ValueValidator.int", () {
    var validator = ValueValidator.int();

    test("Valid integer passes", () {
      expect(validator.validate(42), isNull);
    });

    test("Stringified int passes", () {
      expect(validator.validate("42"), isNull);
    });

    test("Invalid double fails", () {
      expect(validator.validate(3.14), "This field requires an Integer");
    });

    test("Invalid string fails", () {
      expect(validator.validate("abc"), "This field requires an Integer");
    });
  });

  group("ValueValidator.double", () {
    var validator = ValueValidator.double();

    test("Valid double passes", () {
      expect(validator.validate(3.14), isNull);
    });

    test("Valid int passes", () {
      expect(validator.validate(10), isNull);
    });

    test("Stringified double passes", () {
      expect(validator.validate("2.718"), isNull);
    });

    test("Invalid string fails", () {
      expect(
        validator.validate("not-a-number"),
        "This value requires a double",
      );
    });
  });

  group("ValueValidator.bool", () {
    var validator = ValueValidator.bool();

    test("Valid bool passes", () {
      expect(validator.validate(true), isNull);
    });

    test("Invalid type fails", () {
      expect(validator.validate("true"), "This field requires a Boolean");
    });
  });

  group("ValueValidator.list", () {
    var validator = ValueValidator.list(childValidator: ValueValidator.int());

    test("Valid list passes", () {
      expect(validator.validate([1, 2, 3]), isNull);
    });

    test("Invalid type fails", () {
      expect(validator.validate("not-a-list"), "This field requires a List");
    });

    test("Invalid child value fails", () {
      expect(
        validator.validate([1, "a"]),
        isA<List>().having(
          (e) => e.first,
          "first error",
          "This field requires an Integer",
        ),
      );
    });
  });

  group("ValueValidator.map", () {
    var validator = {
      "name": ValueValidator.string(),
      "age": ValueValidator.int(),
    };
    test("Valid map passes", () {
      validator.validate({"name": "John", "age": 30});
    });

    test("Invalid inner value throws ValidationException", () {
      expect(
        () => validator.validate({"name": 123, "age": "thirty"}),
        throwsA(isA<ValidationException>()),
      );
    });
  });

  group("ValueValidator.time", () {
    var validator = ValueValidator.time();

    test("Valid HH:mm passes", () {
      expect(validator.validate("12:34"), isNull);
    });

    test("Valid HH:mm:ss passes", () {
      expect(validator.validate("12:34:56"), isNull);
    });

    test("Invalid format fails", () {
      expect(
        validator.validate("not-a-time"),
        "The value should be in the HH:mm or HH:mm:ss format",
      );
    });

    test("Invalid hours fails", () {
      expect(validator.validate("25:00"), "There are only 24 hours in a day");
    });

    test("Invalid minutes fails", () {
      expect(
        validator.validate("23:60"),
        "There are only 60 minutes in an hour",
      );
    });

    test("Invalid seconds fails", () {
      expect(
        validator.validate("12:30:70"),
        "There are only 60 seconds in a second",
      );
    });

    test("Null value fails if not optional", () {
      expect(validator.validate(null), "This field is required!");
    });

    test("Null value passes if optional", () {
      expect(ValueValidator.time(optional: true).validate(null), isNull);
    });
  });
}
