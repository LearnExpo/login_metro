class Task {
  var id;
  final String title;
  final String description;
  bool isComplete;
  var userId;

  Task({
    this.id,
    required this.title,
    required this.description,
    this.isComplete = false,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isComplete': isComplete ? 1 : 0,
      'userId': userId,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isComplete: map['isComplete'] == 1,
      userId: map['userId'],
    );
  }
}
