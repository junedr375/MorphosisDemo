import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:morphosis_flutter_demo/non_ui/modal/task.dart';

import 'package:morphosis_flutter_demo/non_ui/repo/firebase_manager.dart';
import 'package:morphosis_flutter_demo/ui/screens/task.dart';

class TasksPage extends StatelessWidget {
  TasksPage(
      {@required this.title, @required this.tasks, @required this.stream});

  final String title;
  final List<Task> tasks;
  Stream<QuerySnapshot<Object>> stream;

  void addTask(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => addTask(context),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child:
                    CircularProgressIndicator(), // Showing Loaded untill stream loads
              );
            } else {
              return snapshot.data.docs.isEmpty
                  ? Center(
                      child: Text(title == 'Completed Tasks'
                          ? 'No Task completed yet'
                          : 'Add your first task'),
                    )
                  : ListView.builder(
                      itemCount: snapshot.data.docs.length, //tasks.length,
                      itemBuilder: (context, index) {
                        //     String docId = snapshot.data.docs[index].id ?? '';

                        return _Task(
                          task: Task.fromJson(snapshot.data.docs[index].data()),
                        );
                      },
                    );
            }
          }),
    );
  }
}

class _Task extends StatelessWidget {
  _Task({this.task});

  final Task task;

  void _delete() {
    FirebaseManager.shared.deleteTask(task);
  }

  void _toggleComplete() {
    task.toggleComplete();
    FirebaseManager.shared.updateTask(task);
  }

  void _view(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => TaskPage(
                task: task,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: IconButton(
        icon: Icon(
          task.isCompleted ? Icons.check_box : Icons.check_box_outline_blank,
        ),
        onPressed: _toggleComplete,
      ),
      title: Text(task.title),
      subtitle: Text(task.description),
      trailing: IconButton(
        icon: Icon(
          Icons.delete,
        ),
        onPressed: _delete,
      ),
      onTap: () => _view(context),
    );
  }
}
