import "package:dart_iconica_utilities/dart_iconica_utilities.dart";
import "package:test/test.dart";

void main() {
  var now = DateTime.now();
  var now8601 = now.toIso8601String();
  var someMap = {
    "A": {
      "C": "Y",
      "D": [
        {
          "E": now8601,
        }
      ],
    },
    "B": "X",
  };

  group("traverse", () {
    test("valid traversal path succeeds", () {
      expect(someMap.traverse(["A", "D", 0, "E"]), now8601);
    });

    test("invalid traversal path fails", () {
      void callback() => someMap.traverse(["A", "D", 1, "E"]);

      expect(
        callback,
        throwsA(const TypeMatcher<TraversalException>()),
      );
    });
  });

  group("traverseThen", () {
    test("valid traversal path succeeds", () {
      expect(someMap.traverseThen(["A", "D", 0, "E"], DateTime.parse), now);
    });

    test("invalid traversal path fails", () {
      void callback() =>
          someMap.traverseThen(["A", "D", 1, "E"], DateTime.parse);

      expect(
        callback,
        throwsA(const TypeMatcher<TraversalException>()),
      );
    });
  });

  group("maybeTraverse", () {
    test("valid traversal path succeeds", () {
      expect(someMap.maybeTraverse(["A", "D", 0, "E"]), now8601);
    });

    test("invalid traversal path returns null", () {
      expect(someMap.maybeTraverse(["A", "D", 1, "E"]), null);
    });
  });

  group("maybeTraverseThen", () {
    DateTime? dateTimeMaybeParse(String? value) =>
        value != null ? DateTime.parse(value) : null;

    test("valid traversal path succeeds", () {
      expect(
        someMap.maybeTraverseThen(["A", "D", 0, "E"], dateTimeMaybeParse),
        now,
      );
    });

    test("invalid traversal path returns null", () {
      expect(
        someMap.maybeTraverseThen(["A", "D", 1, "E"], dateTimeMaybeParse),
        null,
      );
    });
  });
}
