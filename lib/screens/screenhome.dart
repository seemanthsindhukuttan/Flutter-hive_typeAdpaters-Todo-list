import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_sample/db/todo_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box<TodoModel> todoBox;
  @override
  void initState() {
    //get box.
    todoBox = Hive.box<TodoModel>("TodoBox");
    super.initState();
  }
  
  // controllers textformfield
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
   // controllers textformfield

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showfelids(context, null),
      ),
      appBar: AppBar(
        elevation: 20,
        centerTitle: true,
        title: const Text("Todo"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ValueListenableBuilder(
              valueListenable: todoBox.listenable(),
              builder: (BuildContext context, Box<TodoModel> todos, _) {
                List<int> keys = todos.keys.cast<int>().toList();
                return ListView.builder(
                  itemCount: keys.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    final key = keys[index];
                    final TodoModel? _todos = todos.get(key);
                    return Card(
                      elevation: 5,
                      child: ListTile(
                        title: Text(
                          _todos!.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                        subtitle: Text(
                          _todos.description,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                        ),

                        //delete.
                        trailing: IconButton(
                          color: Colors.red,
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            todoBox.deleteAt(index);
                          },
                        ),
                        onTap: () {
                          // update.
                          _showfelids(context, key);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // add popup to textform field
  void _showfelids(BuildContext context, int? key) {
    if (key != null) {
      _titleController.text = todoBox.get(key)!.title;
      _descriptionController.text = todoBox.get(key)!.description;
    }
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              key == null
                  ? const Text(
                      'Add Todo',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    )
                  : const Text(
                      'Update Todo',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    ),
              const SizedBox(
                width: 100,
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                  color: Colors.red,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                ),
              ),
            ],
          ),
          actions: [
            _customFields(1, _titleController, 'Title'),
            const SizedBox(height: 10),
            _customFields(5, _descriptionController, 'Description'),
            Center(
              child: ElevatedButton(
                child: key == null ? const Text('Add') : const Text('Update'),
                onPressed: () {
                  TodoModel addvalue = TodoModel(
                    title: _titleController.text,
                    description: _descriptionController.text,
                    complete: false,
                  );
                  //if, to add db
                  if (key == null) {
                    todoBox.add(addvalue);
                  } //else , to update
                  else {
                    todoBox.put(key, addvalue);
                  }

                  // clear textform field.
                  _titleController.clear();
                  _descriptionController.clear();

                  Navigator.pop(context);
                },
              ),
            ),
          ],
        );
      },
    );
  }
  // add popup to textform field

// refactor textformfield
  TextFormField _customFields(
    int lines,
    TextEditingController _controller,
    String hintText,
  ) {
    return TextFormField(
      maxLines: lines,
      controller: _controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: hintText,
        label: Text(hintText),
      ),
    );
  }
  // refactor textformfield
}
