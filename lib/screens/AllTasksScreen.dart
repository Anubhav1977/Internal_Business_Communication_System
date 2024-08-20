import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../Database/Database.dart';
import '../ProjectUtils/Utilities.dart';
import '../services/taskservice.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  String? id;
  List<Task> taskDataList = [];
  List<dynamic> taskId = [];
  bool isLoading = true;

  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final routeargs = ModalRoute.of(context)!.settings.arguments;
      if (routeargs is String) {
        id = routeargs;
        fetchData();
      } else {
        print("$id");
      }
    });
  }

  // Method to update the task status in the database
  updateTaskStatus(int taskId) async {
    print("Updating task with ID: $taskId");
    Database _db = await AppDataBase().getDatabase();

    // Perform the update
    int count = await _db.rawUpdate(
      'UPDATE TASK SET status = ? WHERE id = ?',
      ['completed', taskId],
    );

    // Check how many rows were updated
    print("$count rows updated");

    // Fetch data again to ensure it's updated
    await fetchData();
  }

  fetchData() async {
    print(id);
    taskDataList = await AppDataBase().getTaskdbInfo(id!);
    print(taskDataList);
    taskId = await AppDataBase().getTaskId(id!);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("All Tasks"),
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/EmployeeDashboard',
                arguments: id);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              width: MediaQuery.of(context).size.width,
              // height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                itemCount: taskDataList.length,
                itemBuilder: (context, index) {
                  final taskList =
                      taskDataList.isNotEmpty ? taskDataList[index] : null;
                  final id = taskId.isNotEmpty ? taskId[index] as int : null;

                  if (taskList == null || id == null) {
                    return SizedBox
                        .shrink(); // Return an empty widget if data is null
                  }

                  return Utility().totalContainerUtil(
                    context,
                    taskList.title ?? 'No Title',
                    taskList.description ?? 'No Description',
                    taskList.status ?? 'No Status',
                    taskList.assigned_by ?? 'Unknown',
                    () async {
                      print("$id status ${taskList.status}");
                      await updateTaskStatus(id);
                      print("$id status ${taskList.status}");
                      setState(() {});
                      print("REBUILD");
                      // Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ),
    );
  }
}
