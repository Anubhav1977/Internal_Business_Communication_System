// ignore_for_file: no_leading_underscores_for_local_identifiers, avoid_function_literals_in_foreach_calls

import 'dart:io';
import 'package:inter_business_comm_system/services/Employeeservice.dart';
import 'package:inter_business_comm_system/services/Managerservice.dart';
import 'package:inter_business_comm_system/services/taskservice.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

const String userDbFileName = "Internal_Communication";

class AppDataBase {
  Future createDbPath() async {
    final String databaseFilePath;
    Directory databasePath = await getApplicationDocumentsDirectory();
    databaseFilePath = join(databasePath.path, userDbFileName);
    return databaseFilePath;
  }

  Future getDataBaseFile() async {
    final File file = File(await createDbPath());
    return file.path;
  }

  initializeDatabase() async {
    Database db = await openDatabase(
      await getDataBaseFile(),
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''CREATE TABLE EMP(
          id INTEGER PRIMARY KEY, 
          emp_id VARCHAR(10),
          name VARCHAR(50), 
          contact VARCHAR(10),
          email VARCHAR(50),
          designation VARCHAR(20),
          image VARCHAR(200),
          password VARCHAR(80)
          )
          ''');
        print("Employees Table Created");
        await db.execute('''CREATE TABLE MANAGER(
          id INTEGER PRIMARY KEY, 
          mid VARCHAR(10),
          mname VARCHAR(50),
          mcontact VARCHAR(10),
          memail VARCHAR(50),
          mimage VARCHAR(200),
          mpassword VARCHAR(80)
          )
          ''');
        print("Manager Table Created");
        await db.execute('''CREATE TABLE TASK(
          id INTEGER PRIMARY KEY,
          targetId VARCHAR(10),
          taskName VARCHAR(20),
          taskDescription VARCHAR(300),
          status VARCHAR(50),
          assigned_by VARCHAR(50)
          )
          ''');
        print("Tasks Table Created");
      },
    );
    return db;
  }

  Future<Database> getDatabase() async {
    Database db = await initializeDatabase();
    return db;
  }

  Future resetDatabase() async {
    Database _db = await getDatabase();
    String path = await getDataBaseFile();
    _db.close();
    deleteDatabase(path);
    print("Database reset completed.");
  }

  Future addempData(List<Employee> e) async {
    Database _dbClient = await getDatabase();
    Batch _batch = _dbClient.batch();
    e.forEach((emp) {
      Map<String, dynamic> _map = {
        "emp_id": emp.empId,
        "name": emp.name,
        "contact": emp.contact,
        "email": emp.email,
        "designation": emp.designation,
        "image": emp.image,
        "password": emp.password,
      };
      _batch.insert("EMP", _map);
    });

    _batch.commit();
  }

  Future addmanagerData(List<Manager> m) async {
    Database _dbClient = await getDatabase();
    Batch _batch = _dbClient.batch();
    m.forEach((man) {
      Map<String, dynamic> _map = {
        "mid": man.mId,
        "mname": man.mname,
        "mcontact": man.mcontact,
        "memail": man.memail,
        "mimage": man.mimage,
        "mpassword": man.mpassword,
      };
      _batch.insert("MANAGER", _map);
    });

    _batch.commit();
  }

  Future addtaskData(List<Task> t) async {
    Database _dbClient = await getDatabase();
    Batch _batch = _dbClient.batch();
    t.forEach((task) {
      Map<String, dynamic> _map = {
        "targetId": task.tId,
        "taskName": task.title,
        "taskDescription": task.description,
        "status": task.status,
        "assigned_by": task.assigned_by
      };
      _batch.insert("TASK", _map);
    });

    _batch.commit();
  }

  //TODO this is local function for saving employee data
  Future addEmployeeData(String empId, String name, String contact,
      String email, String designation, String image, String password) async {
    Database _dbClient = await getDatabase();
    Map<String, dynamic> _map = {
      "emp_id": empId,
      "name": name,
      "contact": contact,
      "email": email,
      "designation": designation,
      "image": image,
      "password": password,
    };
    await _dbClient.insert("EMP", _map);
  }

  //TODO this is local function for saving Manager data
  Future addManagerData(String mid, String mname, String mcontact,
      String memail, String mimage, String mpassword) async {
    Database _dbClient = await getDatabase();
    Map<String, dynamic> _map = {
      "mid": mid,
      "mname": mname,
      "mcontact": mcontact,
      "memail": memail,
      "mimage": mimage,
      "mpassword": mpassword,
    };
    await _dbClient.insert("MANAGER", _map);
  }

  //TODO this is local function for saving Task data
  Future addTaskData(String targetId, String taskName, String taskDescription,
      String status) async {
    Database _dbClient = await getDatabase();
    Map<String, dynamic> _map = {
      "targetId": targetId,
      "taskName": taskName,
      "taskDescription": taskDescription,
      "status": status,
    };
    await _dbClient.insert("TASK", _map);
  }

  Future uniqueIdCheck(String id) async {
    Database _dbClient = await getDatabase();

    List<Map<String, dynamic>> empResult = await _dbClient
        .rawQuery("SELECT emp_id FROM EMP WHERE emp_id = ?", [id]);
    List<Map<String, dynamic>> managerResult =
        await _dbClient.rawQuery("SELECT mid FROM MANAGER WHERE mid = ?", [id]);

    bool isIdUnique = empResult.isEmpty && managerResult.isEmpty;
    return isIdUnique;
  }

  Future getEmpdbInfo(String id) async {
    Database _db = await getDatabase();
    List<Employee> empList = [];
    List<Map<String, dynamic>> dbData =
        await _db.rawQuery("SELECT * FROM EMP where emp_id = ?", [id]);
    empList = dbData.map((item) => Employee.fromJson(item)).toList();
    return empList;
  }
}
