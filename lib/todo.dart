import 'dart:convert';

class Todo {
  int? id;
  String title;
  String todo;
  Todo({
    this.id,
    required this.title,
    required this.todo,
  });

  Todo copyWith({
    int? id,
    String? title,
    String? todo,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      todo: todo ?? this.todo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title':title,
      'body': todo,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id']?.toInt() ?? 0,
      title: map['title'] ?? '',
      todo: map['body'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Todo.fromJson(String source) => Todo.fromMap(json.decode(source));

  @override
  String toString() => 'Note(id: $id, title: $title,note: $todo)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Todo &&
      other.id == id &&
      other.title == title &&
      other.todo == todo;
  }

  @override
  int get hashCode => id.hashCode ^ todo.hashCode ^ title.hashCode;
}