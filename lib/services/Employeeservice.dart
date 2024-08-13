import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

import '../Database.dart';

class Employee {
  String? empId;
  String? name;
  String? contact;
  String? email;
  String? designation;
  String? image;
  String? password;

  Employee(
      {this.empId,
      this.name,
      this.contact,
      this.email,
      this.designation,
      this.image,
      this.password});

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      empId: json['emp_id'],
      name: json['name'],
      contact: json['contact'],
      email: json['email'],
      designation: json['designation'],
      image: json['image'],
      password: json['password'],
    );
  }

  Future saveemp() async {
    try {
      String empjson = await rootBundle.loadString('assets/json/employee.json');
      List<dynamic> empData = json.decode(empjson);
      List<Employee> empDataList = [];
      empData.forEach((element) {
        Employee emp = Employee.fromJson(element);
        empDataList.add(emp);
      });
      print("Employee data added");
      AppDataBase().addempData(empDataList);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<int> countEmployees() async {
    final db = await AppDataBase().getDatabase();
    final count =
        Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM EMP'));
    return count ?? 0;
  }
}
