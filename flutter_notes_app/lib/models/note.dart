import 'package:flutter/material.dart';

class Note {
  int? id;
  String title;
  String description;
  DateTime createdAt;
  DateTime updatedAt;
  bool isPinned;
  Color color;

  Note({
    this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    this.isPinned = false,
    this.color = Colors.white,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isPinned': isPinned ? 1 : 0,
      'color': color.value,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      isPinned: map['isPinned'] == 1,
      color: Color(map['color']),
    );
  }
}
