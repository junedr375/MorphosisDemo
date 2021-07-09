import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:morphosis_flutter_demo/non_ui/modal/task.dart';

class FirebaseManager {
  static FirebaseManager _one;

  static FirebaseManager get shared =>
      (_one == null ? (_one = FirebaseManager._()) : _one);
  FirebaseManager._();

  Future<void> initialise() => Firebase.initializeApp();

  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  //TODO: change collection name to something unique or your name
  CollectionReference get tasksRef =>
      FirebaseFirestore.instance.collection('tasks375');

  CollectionReference get tasksRefCompleted =>
      FirebaseFirestore.instance.collection('tasks375');

  //TODO: replace mock data. Remember to set the task id to the firebase object id
  List<Task> get tasks => mockData.map((t) => Task.fromJson(t)).toList();

  //TODO: implement firestore CRUD functions here
  void addTask(Task task) {
    tasksRef.doc(task.id).set((task.toJson())).then((value) {
      print('Task Added to Firebase Succesfully');
    });
  }

  void updateTask(Task task) {
    tasksRef
        .doc(task.id)
        .set(task.toJson(), SetOptions(merge: true))
        .then((value) {
      print('Task Updated in firebase Succesfully');
    });
  }

  void deleteTask(Task task) {
    tasksRef.doc(task.id).delete().then((value) {
      print('Task Deleted from firebase Successfull');
    });
  }
}

List<Map<String, dynamic>> mockData = [];
