import "package:dart_iconica_utilities/src/select_map/select_map.dart";
import "package:test/test.dart";

void main() {
  group("Select", () {
    var data = {
      "user": {
        "name": "Alice",
        "address": {"city": "Amsterdam", "zip": "1234AB"},
        "roles": [
          {"type": "admin", "active": true},
          {"type": "user", "active": false},
        ],
      },
      "meta": {"version": "1.0"},
    };

    test("should return Map which include selected values", () {
      var selectedMap =
          data.select(["user.name", "user.address.city", "user.roles.type"]);

      expect(selectedMap, contains("user"));

      expect(selectedMap["user"], contains("name"));
      expect((selectedMap["user"] as Map<String, dynamic>)["name"], "Alice");

      expect(selectedMap["user"], contains("address"));
      expect(
        (selectedMap["user"] as Map<String, dynamic>)["address"],
        contains("city"),
      );
      expect(
        ((selectedMap["user"] as Map<String, dynamic>)["address"]
            as Map<String, dynamic>)["city"],
        "Amsterdam",
      );

      expect(
        (selectedMap["user"] as Map<String, dynamic>)["address"],
        isNot(contains("zip")),
      );

      expect(
        ((selectedMap["user"] as Map<String, dynamic>)["roles"] as List).length,
        2,
      );
      expect(
        ((selectedMap["user"] as Map<String, dynamic>)["roles"] as List).first,
        contains("type"),
      );
      expect(
        (((selectedMap["user"] as Map<String, dynamic>)["roles"] as List).first
            as Map<String, dynamic>)["type"],
        "admin",
      );
    });

    test("should return Map which exclude unselected values", () {
      var selectedMap =
          data.select(["user.name", "user.address.city", "user.roles.type"]);

      expect(selectedMap, contains("user"));
      expect(selectedMap["user"], contains("address"));
      expect(
        (selectedMap["user"] as Map<String, dynamic>)["address"],
        isNot(contains("zip")),
      );

      expect(
        ((selectedMap["user"] as Map<String, dynamic>)["roles"] as List).length,
        2,
      );
      expect(
        ((selectedMap["user"] as Map<String, dynamic>)["roles"] as List).first,
        isNot(contains("active")),
      );

      expect(
        selectedMap,
        isNot(contains("meta")),
      );
    });
  });

  group("Omit", () {
    var data = {
      "user": {
        "name": "Alice",
        "email": "alice@example.com",
        "address": {
          "city": "Amsterdam",
          "zip": "1234AB",
        },
        "roles": [
          {"type": "admin", "active": true},
          {"type": "user", "active": false},
        ],
      },
      "meta": {"version": "1.0"},
    };

    test("should return Map which exclude selected values", () {
      var selectedMap = data.omit(
        ["user.email", "user.address.zip", "user.roles.active", "meta"],
      );

      expect(selectedMap, contains("user"));
      expect(selectedMap["user"], contains("address"));
      expect(
        (selectedMap["user"] as Map<String, dynamic>)["address"],
        isNot(contains("zip")),
      );

      expect(
        ((selectedMap["user"] as Map<String, dynamic>)["roles"] as List).length,
        2,
      );
      expect(
        ((selectedMap["user"] as Map<String, dynamic>)["roles"] as List).first,
        isNot(contains("active")),
      );

      expect(
        selectedMap,
        isNot(contains("meta")),
      );
    });

    test("should return Map which include unselected values", () {
      var selectedMap = data.omit(
        ["user.email", "user.address.zip", "user.roles.active", "meta.env"],
      );

      expect(selectedMap, contains("user"));

      expect(selectedMap["user"], contains("name"));
      expect((selectedMap["user"] as Map<String, dynamic>)["name"], "Alice");

      expect(selectedMap["user"], contains("address"));
      expect(
        (selectedMap["user"] as Map<String, dynamic>)["address"],
        contains("city"),
      );
      expect(
        ((selectedMap["user"] as Map<String, dynamic>)["address"]
            as Map<String, dynamic>)["city"],
        "Amsterdam",
      );

      expect(
        (selectedMap["user"] as Map<String, dynamic>)["address"],
        isNot(contains("zip")),
      );

      expect(
        ((selectedMap["user"] as Map<String, dynamic>)["roles"] as List).length,
        2,
      );
      expect(
        ((selectedMap["user"] as Map<String, dynamic>)["roles"] as List).first,
        contains("type"),
      );
      expect(
        (((selectedMap["user"] as Map<String, dynamic>)["roles"] as List).first
            as Map<String, dynamic>)["type"],
        "admin",
      );
    });
  });
}
