// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:inter_business_comm_system/ProjectUtils/Utilities.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sqflite/sqflite.dart';

import '../Database/Database.dart';
import '../Database/SharedPref.dart';
import '../services/taskservice.dart';

class ManagerDashboard extends StatefulWidget {
  String? id;

  ManagerDashboard(this.id);

  @override
  State<ManagerDashboard> createState() => _ManagerDashboardState();
}

class _ManagerDashboardState extends State<ManagerDashboard> {
  String _managerName = '';
  String _managerContact = '';
  String _managerEmail = '';
  String _managerPassword = '';
  String _managerImage = '';
  List<Map<String, dynamic>> _edata = [];
  String _id = '';
  List<Task> taskData = [];
  int totalTasks = 0;
  int pendingTasks = 0;
  int completedTasks = 0;
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _id = widget.id ?? ModalRoute.of(context)!.settings.arguments as String;
    if (_id != null) {
      _loadEmployeeData();
      _loadManagerData();
      setState(() {
        isLoading = false;
      });
    } else {
      print("ID not Avaliable");
    }
  }

  _loadManagerData() async {
    if (_id != null) {
      Database _db = await AppDataBase().getDatabase();

      List<Map<String, dynamic>> taskDbData =
          await _db.rawQuery("SELECT * FROM TASK");
      taskData = taskDbData.map((task) => Task.fromJson(task)).toList();
      totalTasks = taskData.length;
      pendingTasks = taskData.where((task) => task.status == 'pending').length;
      completedTasks =
          taskData.where((task) => task.status == 'completed').length;

      List<Map<String, dynamic>> dbData =
          await _db.rawQuery('SELECT * FROM MANAGER WHERE mid = ?', [_id]);

      if (dbData.isNotEmpty) {
        setState(() {
          _managerName = dbData[0]['mname'];
          _managerContact = dbData[0]['mcontact'];
          _managerEmail = dbData[0]['memail'];
          _managerPassword = dbData[0]['mpassword'];
          _managerImage = dbData[0]['mimage'] ?? "No image";
        });
      }
    }
  }

  _loadEmployeeData() async {
    Database _db = await AppDataBase().getDatabase();
    List<Map<String, dynamic>> Edata = await _db.rawQuery('SELECT * FROM EMP');
    setState(() {
      _edata = Edata;
    });
  }

  _addTask(
      String title, String description, String empId, String managerId) async {
    try {
      Database _db = await AppDataBase().getDatabase();
      await _db.transaction((txn) async {
        await txn.rawInsert(
            'INSERT INTO TASK (targetId, taskName, taskDescription, status, assigned_by) VALUES (?, ?, ?, ?, ?)',
            [empId, title, description, "pending", managerId]);
      });
    } catch (e) {
      print("Error adding task: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        title: Text(_managerName),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.all(0),
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ), //BoxDecoration
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Color.fromARGB(255, 165, 255, 137),
                    backgroundImage: _managerImage != null
                        ? FileImage(File(_managerImage))
                        : NetworkImage(
                            "https://img.freepik.com/free-psd/3d-illustration-person-with-sunglasses_23-2149436188.jpg?size=338&ext=jpg&ga=GA1.1.2008272138.1723593600&semt=ais_hybrid"),
                    child: _managerImage != null
                        ? Icon(Icons.person)
                        : Image.network(
                            "https://img.freepik.com/free-psd/3d-illustration-person-with-sunglasses_23-2149436188.jpg?size=338&ext=jpg&ga=GA1.1.2008272138.1723593600&semt=ais_hybrid"),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    _managerName,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  // UserAccountsDrawerHeader(
                  //   decoration: BoxDecoration(color: Colors.green),
                  //   accountName: Text(
                  //     _managerName,
                  //     style: TextStyle(fontSize: 15),
                  //   ),
                  //   accountEmail: Text(_managerEmail),
                  //   currentAccountPictureSize: Size.square(70),
                  //   currentAccountPicture: CircleAvatar(
                  //     backgroundColor: Color.fromARGB(255, 165, 255, 137),
                  //     backgroundImage: _managerImage != null
                  //         ? FileImage(File(_managerImage))
                  //         : NetworkImage(
                  //             "https://img.freepik.com/free-psd/3d-illustration-person-with-sunglasses_23-2149436188.jpg?size=338&ext=jpg&ga=GA1.1.2008272138.1723593600&semt=ais_hybrid"),
                  //   ),
                  // ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.mail),
              title: Text(
                _managerEmail,
                style: TextStyle(fontSize: 14),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: Text(_managerContact),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.password),
              title: Text(_managerPassword),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Divider(
              color: Colors.black,
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('LogOut'),
              onTap: () async {
                await SharedPref().removeData('role');
                await SharedPref().removeData('id');
                await SharedPref().removeData('isLoggedIn');
                // Navigate back to HomeScreen and remove all previous routes
                Navigator.pushNamedAndRemoveUntil(
                    context, '/LoginScreen', (route) => false);
              },
            ),
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: Divider(color: Colors.black,),
            //   ),
            // )
          ],
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.grey.shade100,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.24,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 20, 10, 30),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Task Overview",
                                style: TextStyle(
                                  fontSize: 22,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              MngUtilties().taskInfoConatainersUtil(
                                  context,
                                  Colors.deepPurpleAccent,
                                  "$completedTasks",
                                  "Completed Tasks"),
                              MngUtilties().taskInfoConatainersUtil(
                                  context,
                                  Colors.deepOrangeAccent,
                                  "$pendingTasks",
                                  "Ongoing Tasks"),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Assign Tasks",
                              style: TextStyle(
                                fontSize: 22,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            // shrinkWrap: true,
                            itemCount: _edata.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.fromLTRB(15, 0, 15, 20),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              Colors.black.withOpacity(0.3),
                                          spreadRadius: 2,
                                          blurRadius: 8,
                                          offset: Offset(-2, 4),
                                        ),
                                      ],
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.green,
                                        backgroundImage: _edata[index]
                                                    ['image'] !=
                                                null
                                            ? FileImage(
                                                File(_edata[index]['image']))
                                            : NetworkImage(
                                                "https://img.freepik.com/free-photo/3d-illustration-business-man-with-glasses-grey-background-front-view_1142-39089.jpg?size=338&ext=jpg&ga=GA1.1.2008272138.1720569600&semt=ais_user"),
                                      ),
                                      title: Text(_edata[index]['name'],
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                      subtitle: Text(_edata[index]['email'],
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold)),
                                      trailing: GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              String title = '';
                                              String description = '';
                                              String empId =
                                                  _edata[index]['emp_id'];
                                              String managerId = _id;
                                              return AlertDialog(
                                                title: Text(
                                                  'Add Task',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    TextField(
                                                      style: TextStyle(
                                                          color:
                                                              Colors.black),
                                                      decoration: InputDecoration(
                                                          labelText: 'Title',
                                                          labelStyle: TextStyle(
                                                              color: Colors
                                                                  .black)),
                                                      onChanged: (value) {
                                                        title = value;
                                                      },
                                                    ),
                                                    TextField(
                                                      style: TextStyle(
                                                          color:
                                                              Colors.black),
                                                      decoration: InputDecoration(
                                                          labelText:
                                                              'Description',
                                                          labelStyle: TextStyle(
                                                              color: Colors
                                                                  .black)),
                                                      onChanged: (value) {
                                                        description = value;
                                                      },
                                                    ),
                                                    TextField(
                                                      style: TextStyle(
                                                          color:
                                                              Colors.black),
                                                      decoration: InputDecoration(
                                                          labelText:
                                                              'Employee ID',
                                                          labelStyle: TextStyle(
                                                              color: Colors
                                                                  .black)),
                                                      controller:
                                                          TextEditingController(
                                                              text: empId),
                                                      readOnly: true,
                                                    ),
                                                    TextField(
                                                      style: TextStyle(
                                                          color:
                                                              Colors.black),
                                                      decoration:
                                                          InputDecoration(
                                                        labelText:
                                                            'Manager ID',
                                                        labelStyle: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      controller:
                                                          TextEditingController(
                                                              text:
                                                                  managerId),
                                                      readOnly: true,
                                                    )
                                                  ],
                                                ),
                                                actions: [
                                                  ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                Colors.red),
                                                    child: Text(
                                                      'Cancel',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.white),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                  ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                Colors.green),
                                                    child: Text('Add',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .white)),
                                                    onPressed: () async {
                                                      await _addTask(
                                                          title,
                                                          description,
                                                          empId,
                                                          managerId);
                                                      Navigator.of(context)
                                                          .pop();
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              SnackBar(
                                                        content: Text(
                                                            "Task Added Successfully...."),
                                                        elevation: 20,
                                                        backgroundColor:
                                                            Colors.green,
                                                      ));
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: CircleAvatar(
                                          radius: 20,
                                          backgroundColor: Colors.greenAccent,
                                          child: Icon(
                                            Icons.add,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: 100,
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
