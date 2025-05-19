import "package:dart_iconica_utilities/src/serialization/serialization.dart";
import "package:test/test.dart";

void main() {
  group("MapOrNull", () {
    group("getMappedOrNull", () {
      var sut = <String, dynamic>{
        "text": "some text",
        "number": 1,
        "bool": true,
      };

      test("should return value if valid", () {
        expect(sut.castOrNull<int>("number"), isA<int>());
        expect(sut.castOrNull<int>("number"), equals(1));
        expect(sut.castOrNull<String>("text"), isA<String>());
        expect(sut.castOrNull<String>("text"), equals("some text"));
        expect(sut.castOrNull<bool>("bool"), isA<bool>());
        expect(sut.castOrNull<bool>("bool"), equals(true));
      });

      test("should return null if the value is not the correct type", () {
        expect(sut.castOrNull<String>("number"), isNull);
        expect(sut.castOrNull<int>("text"), isNull);
        expect(sut.castOrNull<String>("bool"), isNull);
      });
    });
  });
}
