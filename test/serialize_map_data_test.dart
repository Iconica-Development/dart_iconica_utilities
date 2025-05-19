import "package:dart_iconica_utilities/src/serialization/serialization.dart";
import "package:meta/meta.dart";
import "package:test/test.dart";

@immutable
class TestModel {
  const TestModel({
    required this.number,
    required this.text,
  });

  factory TestModel.fromMap(Map<String, dynamic> map) => TestModel(
        number: (map["number"] ?? 0) as int,
        text: (map["text"] ?? "") as String,
      );

  final int number;
  final String text;

  @override
  bool operator ==(covariant TestModel other) {
    if (identical(this, other)) return true;

    return other.number == number && other.text == text;
  }

  @override
  int get hashCode => number.hashCode ^ text.hashCode;
}

void main() {
  group("MapOrNull", () {
    group("getMappedOrNull", () {
      var sut = <String, dynamic>{
        "map": {
          "text": "some text",
          "number": 1,
        },
        "invalid_type": "test",
      };

      test("should return an object if a map exists", () {
        expect(
          sut.getMappedOrNull("map", TestModel.fromMap),
          equals(
            const TestModel(
              number: 1,
              text: "some text",
            ),
          ),
        );
      });

      test("should return null if the value is not a map", () {
        expect(sut.getMappedOrNull("invalid_type", TestModel.fromMap), isNull);
      });

      test("should return null if the value does not exist", () {
        expect(sut.getMappedOrNull("invalid_key", TestModel.fromMap), isNull);
      });
    });
  });
}
