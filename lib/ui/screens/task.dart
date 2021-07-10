import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:morphosis_flutter_demo/non_ui/Utils/AppThemeData.dart';
import 'package:morphosis_flutter_demo/non_ui/modal/task.dart';
import 'package:morphosis_flutter_demo/non_ui/provider/TaskProvider.dart';

import 'package:morphosis_flutter_demo/non_ui/repo/firebase_manager.dart';
import 'package:morphosis_flutter_demo/ui/widgets/error_widget.dart';
import 'package:provider/provider.dart';

class TaskPage extends StatelessWidget {
  TaskPage({this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    final theme = getThemeData(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: theme.iconTheme,
        title: Text(
          task == null ? 'New Task' : 'Edit Task',
          key: Key('TitleKey'),
          style: theme.textTheme.headline1,
        ),
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

  //Task addiing and Updating Functions
  void _save(BuildContext context) {
    Provider.of<TaskNotifier>(context, listen: false).addTaskProvider(
        task: task,
        context: context,
        title: _titleController.text,
        description: _descriptionController.text);

    Navigator.of(context).pop();
  }

  void _update(BuildContext context) {
    task.title = _titleController.text;
    task.description = _descriptionController.text;
    task.completedAt = task.completedAt;
    Provider.of<TaskNotifier>(context, listen: false).updateTask(task, context);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = getThemeData(context);
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
                          labelStyle: theme.textTheme.bodyText1),
                    ),
                    SizedBox(height: _padding),
                    TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Description',
                          labelStyle: theme.textTheme.bodyText1),
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
