
import 'package:flutter/material.dart';

class Task {
  String title;
  bool isDone;

  Task(this.title, {this.isDone = false});
}

class TaskManagerScreen extends StatefulWidget {
  const TaskManagerScreen({super.key});

  @override
  State<TaskManagerScreen> createState() => _TaskManagerScreenState();
}

class _TaskManagerScreenState extends State<TaskManagerScreen> {
  final List<Task> _tasks = [
    Task("Complete Flutter assignment"),
    Task("Review Clean Architecture", isDone: true),
    Task("Practice widget catalog"),
  ];

  void _deleteTask(int index) async {
    final bool? confirm = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirm Deletion"),
        content: const Text("Are you sure you want to delete this task?"),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.of(ctx).pop(false),
          ),
          TextButton(
            child: const Text("Delete"),
            onPressed: () => Navigator.of(ctx).pop(true),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final removedTask = _tasks[index];
      setState(() {
        _tasks.removeAt(index);
      });

      // Show snackbar with undo
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Task '${removedTask.title}' deleted"),
          action: SnackBarAction(
            label: "Undo",
            onPressed: () {
              setState(() {
                _tasks.insert(index, removedTask);
              });
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Manager"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ReorderableListView.builder(
        itemCount: _tasks.length,
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (newIndex > oldIndex) newIndex -= 1;
            final task = _tasks.removeAt(oldIndex);
            _tasks.insert(newIndex, task);
          });
        },
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return Dismissible(
            key: ValueKey(task.title),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(left: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            direction: DismissDirection.endToStart,
            confirmDismiss: (_) async {
              _deleteTask(index);
              return false; // handled manually
            },
            child: Card(
              key: ValueKey("task_$index"),
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: ListTile(
                leading: const Icon(Icons.drag_handle),
                title: Text(
                  task.title,
                  style: TextStyle(
                    decoration: task.isDone
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                trailing: Checkbox(
                  value: task.isDone,
                  onChanged: (val) {
                    setState(() {
                      task.isDone = val ?? false;
                    });
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
