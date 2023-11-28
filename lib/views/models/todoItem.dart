class ToDo {
  String task;
  bool isDone;

  ToDo({ required this.task, this.isDone = false, });

  Map<String, dynamic> toMap() {
    return {
      'task': task,
      'isDone': isDone,
    };
  }

  static ToDo fromMap(Map<String, dynamic> map) {
    return ToDo(
      task: map['task'],
      isDone: map['isDone'],
    );
  }
}

