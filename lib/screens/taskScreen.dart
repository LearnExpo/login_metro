import 'package:flutter/material.dart';
import 'package:login_metro/helper/databaseHelper.dart';
import 'package:login_metro/helper/taskModel.dart';
import 'package:login_metro/helper/userModelClass.dart';
import 'package:login_metro/main.dart';
import 'package:login_metro/screens/createTask.dart';
import 'package:login_metro/widgets/menuWidget.dart';

import 'edit_task_screen.dart';

class TaskListScreen extends StatefulWidget {
  final Users user;

  TaskListScreen({required this.user});

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await DatabaseHelper()
        .getTasks(widget.user.id!.toString(), widget.user.isAdmin!);
    setState(() {
      _tasks = tasks.map((task) => Task.fromMap(task)).toList();
    });
  }

  Future<void> _navigateToAddTaskScreen() async {
    bool taskAdded = await Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => AddTaskScreen(userId: widget.user.id!)),
    );

    if (taskAdded == true) {
      _loadTasks(); // Reload the tasks if a new task was added
    }
  }

  Future<void> _navigateToEditTaskScreen(Task task) async {
    bool taskUpdated = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => EditTaskScreen(task: task)),
    );

    if (taskUpdated == true) {
      _loadTasks(); // Reload the tasks if a task was updated
    }
  }

  Future<void> _deleteTask(int id) async {
    await DatabaseHelper().deleteTask(id);
    _loadTasks(); // Reload the tasks after deletion
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const customWidget(),
      appBar: AppBar(title: Text('Task List')),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), border: Border.all()),
            child: ListTile(
              title: Text(
                task.title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              subtitle: Text(task.description),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => _navigateToEditTaskScreen(task),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteTask(task.id!),
                  ),
                  Theme(
                    data: Theme.of(context).copyWith(
                      checkboxTheme: CheckboxThemeData(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20), // Rounded corners
                        ),
                        checkColor: MaterialStateProperty.all(
                            Colors.grey), // Tick color
                      ),
                    ),
                    child: Checkbox(
                      value: task.isComplete,
                      onChanged: (value) {
                        setState(() {
                          task.isComplete = value!;
                        });
                        DatabaseHelper().updateTask(task.toMap());
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddTaskScreen,
        child: Icon(Icons.add),
      ),
    );
  }
}
