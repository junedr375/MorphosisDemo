import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:morphosis_flutter_demo/main.dart';
import 'package:morphosis_flutter_demo/non_ui/modal/task.dart';
import 'package:morphosis_flutter_demo/non_ui/repo/firebase_manager.dart';
import 'package:morphosis_flutter_demo/ui/widgets/error_widget.dart';

class TaskNotifier extends ChangeNotifier {
  void addTaskProvider(
      {Task task, BuildContext context, String title, String description}) {
    try {
      task.id = DateTime.now()
          .millisecondsSinceEpoch
          .toString(); //TO generate Unique Id;
      task.title = title;
      task.description = description;
      task.completedAt = task.isCompleted ? DateTime.now() : null;
      FirebaseManager.shared.addTask(task);
      _showMessage(context, 'Task added Successfully');
      notifyListeners();
    } catch (e) {
      _showErrorMessage(
          context, e.toString(), 'Back', () => Navigator.pop(context));
      _showMessage(context, 'error in adding task');
    }
  }

  void updateTask(Task task, BuildContext context) {
    try {
      FirebaseManager.shared.updateTask(task);
      _showMessage(context, 'Task updated Successfully');
      notifyListeners();
    } catch (e) {
      _showErrorMessage(
          context, e.toString(), 'Back', () => Navigator.pop(context));
      _showMessage(context, 'error in updating task');
    }
  }

  void deleteTask(Task task, BuildContext context) {
    try {
      FirebaseManager.shared.deleteTask(task);
      _showMessage(context, 'Task deleted Successfully');
      notifyListeners();
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
}
