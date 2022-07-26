import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Todo List",
      home: TodoList(),
    );
  }
}

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  createState() => TodoListState();
}

class TodoListState extends State<TodoList> {
  final List<String> _todoItems = [];

  String? gottenString = "";

  @override
  void initState() {
    super.initState();
    getString();
  }

  // void addingGottenString() {
  //   setState(() {});
  // }

  // void _addTodoItem(text) {
  //   if (text.isNotEmpty) {
  //     setState(
  //       () {
  //         _todoItems.add(text);
  //       },
  //     );
  //   }
  // }

  Widget _buildTodoItem(String todoText, int indexno) {
    return ListTile(
      title: Text(todoText),
      onTap: () => _promptRemoveTodoItem(indexno),
    );
  }

  Widget _buildTodoList() {
    return ListView.builder(
      itemCount: _todoItems.length,
      itemBuilder: (context, index) {
        return _buildTodoItem(_todoItems[index], index);
      },
    );
  }

  void _removeTodoItem(int index) {
    setState(
      () {
        _todoItems.removeAt(index);
      },
    );
  }

  void _promptRemoveTodoItem(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Done? Remove "${_todoItems[index]}" '),
          actions: [
            TextButton(
              onPressed: () {
                _removeTodoItem(index);
                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  void _pushAddTodoScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Add a new task'),
            ),
            body: TextField(
              autofocus: true,
              onSubmitted: (val) {
                setTheString(val);
                getString();
                // addingGottenString();
                //_addTodoItem(val);
                Navigator.pop(context);
              },
              decoration: const InputDecoration(
                hintText: "Enter something to do..",
                contentPadding: EdgeInsets.all(16.0),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> setTheString(theString) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('todoString', theString);
  }

  Future<void> getString() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(
      () {
        gottenString = pref.getString("todoString");
        if (gottenString != null && gottenString!.isNotEmpty) {
          _todoItems.add(gottenString!);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo List"),
      ),
      body: _buildTodoList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _pushAddTodoScreen,
        tooltip: "Add task",
        child: const Icon(Icons.add),
      ),
    );
  }
}
