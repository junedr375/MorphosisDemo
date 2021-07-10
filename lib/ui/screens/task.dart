import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:morphosis_flutter_demo/non_ui/modal/task.dart';

import 'package:morphosis_flutter_demo/non_ui/repo/firebase_manager.dart';
import 'package:morphosis_flutter_demo/ui/widgets/error_widget.dart';

class TaskPage extends StatelessWidget {
  TaskPage({this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(task == null ? 'New Task' : 'Edit Task'),
      ),
      body: _TaskForm(task),
    );
  }
}

class _TaskForm extends StatefulWidget {
  _TaskForm(this.task);

  final Task task;
  @override
  __TaskFormState createState() => __TaskFormState(task);
}

class __TaskFormState extends State<_TaskForm> {
  static const double _padding = 16;

  __TaskFormState(this.task);

  Task task;

  TextEditingController _titleController;
  TextEditingController _descriptionController;

  void init() {
    if (task == null) {
      task = Task();
      _titleController = TextEditingController();
      _descriptionController = TextEditingController();
    } else {
      _titleController = TextEditingController(text: task.title);
      _descriptionController = TextEditingController(text: task.description);
    }
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  void _save(BuildContext context) {
    try {
      task.id = DateTime.now()
          .millisecondsSinceEpoch
          .toString(); //TO generate Unique Id;
      task.title = _titleController.text;
      task.description = _descriptionController.text;
      task.completedAt = task.isCompleted ? DateTime.now() : null;
      FirebaseManager.shared.addTask(task);
      _showMessage(context, 'Task Added Successfully');

      Navigator.of(context).pop();
    } catch (e) {
      _showErrorMessage(
          context, e.toString(), 'Back', () => Navigator.pop(context));
      _showMessage(context, 'Error in Adding Task');
    }
  }

  void _update(BuildContext context) {
    try {
      task.title = _titleController.text;
      task.description = _descriptionController.text;
      task.completedAt = task.completedAt;
      FirebaseManager.shared.updateTask(task);
      _showMessage(context, 'Task Updated Successfully');
      Navigator.of(context).pop();
    } catch (e) {
      _showErrorMessage(
          context, e.toString(), 'Back', () => Navigator.pop(context));
      _showMessage(context, 'error in updating task');
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: 500),
        content: new Text(message),
      ),
    );
  }

  void _showErrorMessage(BuildContext context, String message,
      String buttonTiltle, Function() onTap) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ErrorMessage(
                  message: message,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  buttonTitle: 'Back',
                )));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Container(
                padding: const EdgeInsets.all(_padding),
                child: Column(
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Title',
                      ),
                    ),
                    SizedBox(height: _padding),
                    TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Description',
                      ),
                      minLines: 5,
                      maxLines: 10,
                    ),
                    SizedBox(height: _padding),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Completed ?'),
                        CupertinoSwitch(
                          value: task.isCompleted,
                          onChanged: (_) {
                            setState(() {
                              task.toggleComplete();
                            });
                          },
                        ),
                      ],
                    ),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        if (task.id == null)
                          _save(context);
                        else
                          _update(context);
                      },
                      child: Container(
                        width: double.infinity,
                        child: Center(
                            child: Text(task.isNew ? 'Create' : 'Update')),
                      ),
                    )
                  ],
                ))));
  }
}
