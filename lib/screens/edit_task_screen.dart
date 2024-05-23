import 'package:flutter/material.dart';
import 'package:login_metro/helper/databaseHelper.dart';
import 'package:login_metro/helper/taskModel.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;

  EditTaskScreen({required this.task});

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _title;
  String? _description;
  bool? _isComplete;
  var _userId;
  var _id;

  @override
  void initState() {
    super.initState();
    _id = widget.task.id;
    _title = widget.task.title;
    _description = widget.task.description;
    _isComplete = widget.task.isComplete;
    _userId = widget.task.userId;
  }

  Future<void> _saveTask() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Task updatedTask = Task(
        id: widget.task.id,
        title: _title!,
        description: _description!,
        isComplete: _isComplete!,
        userId: _userId!,
      );
      await DatabaseHelper().updateTask(updatedTask.toMap());

      Navigator.of(context).pop(
          true); // Return to the previous screen and indicate the task was updated
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value!;
                },
              ),
              CheckboxListTile(
                title: Text('Complete?'),
                value: _isComplete,
                onChanged: (value) {
                  setState(() {
                    _isComplete = value!;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveTask,
                child: Text('Save Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
