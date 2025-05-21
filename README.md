# Dart Iconica utilities

Small package that can be included in your app to access regularly used utility functions.

## Content

This package contains:

- [Bidirectional Sorter](#bidirectional-sorter)
- [Date Extension](#date-extension)
- [Serialization](#serialization)
- [Traversal](#traversal)
- [Select and Omit Maps](#select-and-omit-maps)

## Installation

To add this package in your project, add to your pubspec.yaml:

```yaml
dart_iconica_utilities:
  hosted: https://forgejo.internal.iconica.nl/api/packages/internal/pub
  version: ...
```

## Bidirectional Sorter

Generic implementation of sorter for lists. It can sort primitive and complex objects, Both in descendig and ascending order. Can also sort multiple fields at the same time for complex objects using sortMulti

### Usage

```dart
import 'package:dart_iconica_utilities/dart_iconica_utilities.dart';

// Creating list of Strings
List<String> listToSort = [];
for (int i = 0; i < 10; i++) {
    listToSort.add("name$i");
}

// Calling the sort method
sort<String>(SortDirection.descending, listToSort);

print(listToSort)

// Returns
[name9, name8, name7, name6, name5, name4, name3, name2, name1, name0]
```

## Date Extension

Extension on date for clamping and comparing dates.

```dart
import 'package:dart_iconica_utilities/dart_iconica_utilities.dart';

// DateTime clamping
var someDate = DateTime(2021, 5, 3);
var startDate = DateTime(2023,5,3);
var endDate = DateTime.now();

someDate.clamp(startDate, endDate);

// DateTime comparison
print(DateTime(2021, 5, 3).compareByDateTo(DateTime(2023, 12, 9))); // => -1
print(DateTime(2023, 12, 9).compareByDateTo(DateTime(2021, 2, 4))); // => 1
print(DateTime(2023, 12, 9).compareByDateTo(DateTime(2023, 12, 9))); // => 0

```

## Serialization

Serialization helper functions.

```dart
// Cast(OrNull)

Map<String,dynamic> someMap={"a":3};

someMap.cast<int>("a"); // => 3
someMap.castOrNull<String>("a"); // => null

// GetDateTime

Map<String,dynamic> someMap2={"a":"2023-12-05"};

someMap2.getDateTime("a"); // => DateTime(2023,12,5)
someMap.maybeGetDateTime("a"); // => null

// MapDoubleParsing

Map<String,dynamic> someMap3={"a":"0.03","b":0.03};

someMap3.getAsDouble("a"); // => 0.03
someMap3.getAsDouble("b"); // => 0.03
someMap.maybeGetAsDouble("a"); // => null
someMap.getAsDoubleOr("a",defaultValue: 1.0); // => 1.0

// MappedOrNull 

Map<String,dynamic> someJson={"tuna":{"name":"tuna","email":"john@west.com"}};
someJson.getMapped("tuna",(map)=>FishUser.fromMap(map)); // => FishUser(name:"tuna",email:"john@west.com")
someJson.getMappedOrNull("salmon",(map)=>FishUser.fromMap(map)); // => null

```

## Traversal

Functions for retrieving values from (deep)maps

```dart

// Traverse

Map<String,dynamic> someMap={"a":{"b":{"c":{"d":3}}}};

someMap.traverse<int>(["a","b","c","d"]); // => 3
someMap.traverseThen<double,int>(["a","b","c","d"],(int value)=>value * 1.2); // => 3.6
someMap.traverseThen(["a","b","c","d"],(int value)=>value * 1.2); // => 3.6 (Identical to previous)

someMap.maybeTraverse<String>(["a","b","c","d"]); // => null
someMap.maybeTraverseThen<String,double>(["a","b","c","f"],(value)=>double.tryParse('$value')); // => null

```

## Select and Omit Maps

Functions for selecting and omiting (deep)maps

### Select

```dart

// Select

Map<String,dynamic> data = {
  "user": {
    "name": "Alice",
    "address": {
      "city": "Amsterdam",
      "zip": "1234AB"
    },
    "roles": [
      {"type": "admin", "active": true},
      {"type": "user", "active": false},
    ]
  },
  "meta": {"version": "1.0"}
};

data.select(["user.name", "user.address.city", "user.roles.type"]);

//This results in:
{
  "user": {
    "name": "Alice",
    "address": {"city": "Amsterdam"},
    "roles": [
      {"type": "admin"},
      {"type": "user"}
    ]
  }
}

```

### Select

```dart

// Select

Map<String,dynamic> data = {
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
    ]
  },
  "meta": {"version": "1.0", "env": "production"}
};

data.omit([
  "user.email",
  "user.address.zip",
  "user.roles.active",
  "meta.env"
]);

// This results in:
{
  "user": {
    "name": "Alice",
    "address": {
      "city": "Amsterdam"
    },
    "roles": [
      {"type": "admin"},
      {"type": "user"}
    ]
  },
  "meta": {
    "version": "1.0"
  }
}

```