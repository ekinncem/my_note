import 'dart:ui';

class Note {
  String title;
  String content;
  DateTime dateCreated;
  String category;
  String priority;
  bool isCompleted;
  Color color;

  Note({
    required this.title,
    required this.content,
    required this.dateCreated,
    required this.category,
    required this.priority,
    this.isCompleted = false,
    required this.color,
  });
}
