import 'package:hive/hive.dart';

part 'todo_model.g.dart';

@HiveType(typeId: 0)
class TodoModel extends HiveObject {
  @HiveField(0)
  String title;
  @HiveField(1)
  String description;
  @HiveField(3)
  bool complete;

  TodoModel({
    required this.title,
    required this.description,
    required this.complete,
  });
}
