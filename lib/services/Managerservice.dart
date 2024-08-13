import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

import '../Database.dart';

class Manager {
  String? mId;
  String? mname;
  String? mcontact;
  String? memail;
  String? mimage;
  String? mpassword;

  Manager(
      {this.mId,
      this.mname,
      this.mcontact,
      this.memail,
      this.mimage,
      this.mpassword});

  factory Manager.fromJson(Map<String, dynamic> json) {
    return Manager(
      mId: json['mid'],
      mname: json['mname'],
      mcontact: json['mcontact'],
      memail: json['memail'],
      mimage: json['mimage'],
      mpassword: json['mpassword'],
    );
  }

  Future savemanager() async {
    try {
      String managerjson =
          await rootBundle.loadString('assets/json/manager.json');
      List<dynamic> managerData = json.decode(managerjson);
      List<Manager> managerDataList = [];
      managerData.forEach((element) {
        Manager manager = Manager.fromJson(element);
        managerDataList.add(manager);
      });
      print("MAnager data added");

      AppDataBase().addmanagerData(managerDataList);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<int> countManagers() async {
    final db = await AppDataBase().getDatabase();
    final count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM MANAGER'));
    return count ?? 0;
  }
}
