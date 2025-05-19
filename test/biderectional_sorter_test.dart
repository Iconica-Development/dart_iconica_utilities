// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import "package:dart_iconica_utilities/src/biderectional_sorter/biderectional_sorter.dart";
import "package:test/test.dart";

class TestObject {
  TestObject({
    required this.name,
    required this.id,
  });

  final String name;
  final int id;
}

void main() {
  group("Bidirectional sorter", () {
    group("Primitives", () {
      test("Sort in descending order", () {
        var names = <String>[];
        for (var i = 0; i < 10; i++) {
          names.add("name$i");
        }

        sort<String>(SortDirection.descending, names);

        expect(names.first, equals("name9"));
        expect(names.last, equals("name0"));
      });

      test("Sort in ascending order", () {
        var names = <String>[];
        for (var i = 9; i >= 0; i--) {
          names.add("name$i");
        }

        sort<String>(SortDirection.ascending, names);

        expect(names.first, equals("name0"));
        expect(names.last, equals("name9"));
      });

      test("Sort with given comparable in descending order", () {
        var names = <String>[];
        for (var i = 0; i < 10; i++) {
          names.add("name$i");
        }

        sort<String>(SortDirection.descending, names, (name) => name);

        expect(names.first, equals("name9"));
        expect(names.last, equals("name0"));
      });

      test("Sort with given comparable in ascending order", () {
        var names = <String>[];
        for (var i = 9; i >= 0; i--) {
          names.add("name$i");
        }

        sort<String>(SortDirection.ascending, names, (name) => name);

        expect(names.first, equals("name0"));
        expect(names.last, equals("name9"));
      });

      test("Sort in descending order given an empty list should not throw", () {
        var names = <String>[];

        sort<String>(SortDirection.descending, names);

        expect(names, equals(names));
      });

      test("Sort in ascending order given an empty list should not throw", () {
        var names = <String>[];

        sort<String>(SortDirection.ascending, names);

        expect(names, equals(names));
      });

      test(
          """Sort with given comparable in descending order given an empty list should not throw""",
          () {
        var names = <String>[];

        sort<String>(SortDirection.descending, names);

        expect(names, equals(names));
      });

      test(
          """Sort with given comparable in ascending order given an empty list should throw""",
          () {
        var names = <String>[];

        sort<String>(SortDirection.ascending, names);

        expect(names, equals(names));
      });
    });
    group("Complex", () {
      test("Sort with given comparable in descending order", () {
        var objects = <TestObject>[];
        for (var i = 0; i < 10; i++) {
          objects.add(TestObject(name: "name", id: i));
        }

        sort<TestObject>(
          SortDirection.descending,
          objects,
          (object) => object.id,
        );

        expect("${objects.first.name}${objects.first.id}", equals("name9"));
        expect("${objects.last.name}${objects.last.id}", equals("name0"));
      });

      test("Sort with given comparable in ascending order", () {
        var objects = <TestObject>[];
        for (var i = 9; i >= 0; i--) {
          objects.add(TestObject(name: "name", id: i));
        }

        sort<TestObject>(
          SortDirection.ascending,
          objects,
          (object) => object.id,
        );

        expect("${objects.first.name}${objects.first.id}", equals("name0"));
        expect("${objects.last.name}${objects.last.id}", equals("name9"));
      });

      test(
          """Sort with given comparable in descending order given an empty list should not throw""",
          () {
        var objects = <TestObject>[];

        sort<TestObject>(SortDirection.descending, objects);

        expect(objects, equals(objects));
      });

      test(
          """Sort with given comparable in ascending order given an empty list should throw""",
          () {
        var objects = <TestObject>[];

        sort<TestObject>(SortDirection.ascending, objects);

        expect(objects, equals(objects));
      });

      test("Sort without comparable in descending order should throw", () {
        var objects = <TestObject>[];
        for (var i = 0; i < 10; i++) {
          objects.add(TestObject(name: "name", id: i));
        }

        expect(
          () => sort<TestObject>(SortDirection.descending, objects),
          throwsA(isA<AssertionError>()),
        );
      });

      test("Sort without comparable in ascending order should throw", () {
        var objects = <TestObject>[];
        for (var i = 9; i >= 0; i--) {
          objects.add(TestObject(name: "name", id: i));
        }

        expect(
          () => sort<TestObject>(SortDirection.ascending, objects),
          throwsA(isA<AssertionError>()),
        );
      });
    });
  });
}
