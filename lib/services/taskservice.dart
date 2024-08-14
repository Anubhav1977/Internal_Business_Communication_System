import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:sqflite/sqflite.dart';

import '../Database.dart';

class Task {
  String? tId;
  String? title;
  String? description;
  String? status;
  String? assigned_by;

  Task({this.tId, this.title, this.description, this.status,this.assigned_by});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
        tId: json['targetId'],
        title: json['taskName'],
        description: json['taskDescription'],
        status: json['status'],
        assigned_by: json['assigned_by']);
  }

  Future savetask() async {
    try {
      String taskjson = await rootBundle.loadString('assets/json/task.json');
      List<dynamic> taskData = json.decode(taskjson);
      List<Task> taskDataList = [];
      taskData.forEach((element) {
        Task task = Task.fromJson(element);
        taskDataList.add(task);
      });
      print("Task data added");

      AppDataBase().addtaskData(taskDataList);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<int> countTasks() async {
    final db = await AppDataBase().getDatabase();
    final count =
    Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM TASK'));
    return count ?? 0;
  }
}
