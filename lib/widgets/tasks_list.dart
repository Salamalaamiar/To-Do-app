import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todolist_app/models/task.dart';
import 'package:todolist_app/services/firestore.dart';
import 'task_item.dart';

class TasksList extends StatelessWidget {
  final FirestoreService firestoreService = FirestoreService();

  TasksList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestoreService.getTasks(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final taskLists = snapshot.data!.docs;
        List<Task> taskItems = [];

        for (int index = 0; index < taskLists.length; index++) {
          DocumentSnapshot document = taskLists[index];
          Map<String, dynamic> data =
              document.data() as Map<String, dynamic>;

          String title = data['taskTitle'] ?? '';
          String description = data['taskDesc'] ?? '';
          String dateString = data['taskDate'] ?? DateTime.now().toIso8601String();
          DateTime date = DateTime.parse(dateString);
          String categoryString = data['taskCategory'];

          Category category;
          switch (categoryString) {
            case 'work':
              category = Category.work;
              break;
            case 'shopping':
              category = Category.shopping;
              break;
            case 'personal':
              category = Category.personal;
              break;
            default:
              category = Category.others;
          }

          Task task = Task(
            title: title,
            description: description,
            date: date,
            category: category,
          );

          taskItems.add(task);
        }

        return ListView.builder(
          itemCount: taskItems.length,
          itemBuilder: (context, index) {
            return TaskItem(taskItems[index]);
          },
        );
      },
    );
  }
}
