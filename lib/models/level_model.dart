import 'dart:convert';

import 'package:flutter/material.dart';

class LevelModel {
  String id;
  String name;
  int number;
  LevelModel({
    @required this.name,
    @required this.number,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'number': number,
    };
  }

  factory LevelModel.fromMap(Map<String, dynamic> map, String id) {
    return LevelModel(
      name: map['name'],
      number: map['number'],
      id: id,
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'Level( name: $name,number:$number)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LevelModel && other.name == name && other.number == number;
  }

  @override
  int get hashCode => name.hashCode ^ number.hashCode;
}
