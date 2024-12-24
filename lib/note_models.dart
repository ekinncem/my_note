import 'dart:ui';

class Note {
  int? id;
  String title;
  String content;
  DateTime dateCreated;
  String category;
  String priority;
  bool isCompleted;
  Color color;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.dateCreated,
    required this.category,
    required this.priority,
    this.isCompleted = false,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'dateCreated': dateCreated.toIso8601String(),
      'category': category,
      'priority': priority,
      'isCompleted': isCompleted ? 1 : 0,
      'color': color.value.toString(),
    };
  }

  static Note fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      dateCreated: DateTime.parse(map['dateCreated']),
      category: map['category'],
      priority: map['priority'],
      isCompleted: map['isCompleted'] == 1,
      color: Color(int.parse(map['color'])),
    );
  }
}
