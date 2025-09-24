import 'package:flutter/material.dart';
import 'package:flutter_widget_exploration/physics_playground_screen.dart';
import 'package:flutter_widget_exploration/sequential_loading_dots.dart';
import 'package:flutter_widget_exploration/task_manager_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const HomeBody(),
    );
  }
}

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              child: ListTile(
                title: Text("Task Manager"),
                onTap: () {
                  // navigate to TaskManagerScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TaskManagerScreen(),
                    ),
                  );
                },
                trailing: Icon(Icons.task),
              ),
            ),
            SizedBox(height: 20),
            Card(
              child: ListTile(
                title: Text("Physics Playground"),
                onTap: () {
                  // navigate to PhysicsPlaygroundScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PhysicsPlaygroundScreen(),
                    ),
                  );
                },
                trailing: Icon(Icons.task),
              ),
            ),
            SizedBox(height: 20),
            Card(
              child: ListTile(
                title: Text("sequential Loading Dots"),
                onTap: () {
                  // navigate to SequentialLoadingDotsScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoadingAnimationApp(),
                    ),
                  );
                },
                trailing: Icon(Icons.task),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
