import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../Database.dart';

class ManagerDashboard extends StatefulWidget {
  const ManagerDashboard({super.key});

  @override
  State<ManagerDashboard> createState() => _ManagerDashboardState();
}

class _ManagerDashboardState extends State<ManagerDashboard> {
  String _managerName = '';
  String _managerContact = '';
  String _managerEmail = '';
  String _managerPassword = '';
  List<Map<String, dynamic>> _edata = [];
  String _id = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _id = ModalRoute.of(context)!.settings.arguments as String;
    _loadEmployeeData();
    _loadManagerData();
  }

  _loadManagerData() async {
    if (_id != null) {
      Database _db = await AppDataBase().getDatabase();
      List<Map<String, dynamic>> dbData = await _db.rawQuery(
          'SELECT * FROM MANAGER WHERE mid = ?',
          [_id]);

      if (dbData.isNotEmpty) {
        setState(() {
          _managerName = dbData[0]['mname'];
          _managerContact = dbData[0]['mcontact'];
          _managerEmail = dbData[0]['memail'];
          _managerPassword = dbData[0]['mpassword'];
        });
      }
    }
  }

  _loadEmployeeData() async {
    Database _db = await AppDataBase().getDatabase();
    List<Map<String, dynamic>> Edata = await _db.rawQuery(
        'SELECT * FROM EMP'
    );
    setState(() {
      _edata = Edata;
    });
  }
  _addTask(String title, String description, String empId, String managerId) async {
    try {
      Database _db = await AppDataBase().getDatabase();
      await _db.transaction((txn) async {
        await txn.rawInsert('INSERT INTO TASK (targetId, taskName, taskDescription, status, assigned_by) VALUES (?, ?, ?, ?, ?)', [empId, title, description, "pending", managerId]);
      });
    } catch (e) {
      print("Error adding task: $e");
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Manager Dashboard"),
      ),
      drawer: Drawer(
        child: ListView(
          padding:  EdgeInsets.all(0),
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ), //BoxDecoration
              child: Center(
                child: UserAccountsDrawerHeader(
                  decoration: BoxDecoration(color: Colors.green),
                  accountName: Text(
                    _managerName,
                    style: TextStyle(fontSize: 15),
                  ),
                  accountEmail: Text(_managerEmail),
                  currentAccountPictureSize: Size.square(50),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 165, 255, 137),
                    child: const Icon(
                        Icons.person,
                        color: Colors.blue),//Text
                  ), //circleAvatar
                ),
              ), //UserAccountDrawerHeader
            ), //DrawerHeader
            ListTile(
              leading: const Icon(Icons.phone),
              title:  Text(_managerContact),
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
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('LogOut'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: _edata.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _edata.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.all(10),
            child: Card(
              color: Colors.white70,
              child: Container(
                decoration: BoxDecoration(border: Border.all(color: Colors.green,width: 5),borderRadius: BorderRadius.all(Radius.circular(10))),
                child: ListTile(
                  leading: Container(
                    decoration: BoxDecoration(border: Border.all(color: Colors.black),borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Icon(Icons.person,color: Colors.white,)),
                  ),
                  title: Text(_edata[index]['name'],style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold)),
                  subtitle: Text(_edata[index]['email'],style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold)),
                  trailing: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          String title = '';
                          String description = '';
                          String empId = _edata[index]['emp_id'];
                          String managerId = _id;

                          return AlertDialog(
                            title: Text('Add Employee',style: TextStyle(fontWeight: FontWeight.bold),),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                      labelText: 'Title',
                                      labelStyle: TextStyle(color: Colors.black)
                                  ),
                                  onChanged: (value) {
                                    title = value;
                                  },
                                ),
                                TextField(
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                      labelText: 'Description',
                                      labelStyle: TextStyle(color: Colors.black)
                                  ),
                                  onChanged: (value) {
                                    description = value;
                                  },
                                ),
                                TextField(
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                      labelText: 'Employee ID',
                                      labelStyle: TextStyle(color: Colors.black)
                                  ),
                                  controller: TextEditingController(text: empId),
                                  readOnly: true,
                                ),
                                TextField(
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    labelText: 'Manager ID',
                                    labelStyle: TextStyle(color: Colors.black),
                                  ),
                                  controller: TextEditingController(text: managerId),
                                  readOnly: true,
                                )
                              ],
                            ),
                            actions: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                child: Text('Cancel',style: TextStyle(color: Colors.white),),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                child: Text('Add', style: TextStyle(color: Colors.white)),
                                onPressed: () async {
                                  await _addTask(title, description, empId, managerId);
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Task Added Successfully...."),elevation: 20,backgroundColor: Colors.green,));
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.red,
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


