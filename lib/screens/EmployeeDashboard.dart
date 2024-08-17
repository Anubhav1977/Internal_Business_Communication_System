// ignore_for_file: prefer_const_literals_to_create_immutables, avoid_print, avoid_function_literals_in_foreach_calls

import 'dart:io';

import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inter_business_comm_system/ProjectUtils/Utilities.dart';
import 'package:inter_business_comm_system/services/Employeeservice.dart';
import 'package:inter_business_comm_system/services/Managerservice.dart';
import 'package:sqflite/sqflite.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Database.dart';
import '../services/taskservice.dart';

class EmployeeDashboard extends StatefulWidget {
  @override
  State<EmployeeDashboard> createState() => _EmployeeDashboardState();
}

class _EmployeeDashboardState extends State<EmployeeDashboard> {
  // Lists to store data fetched from the database
  List<Employee> empDataList = [];
  List<Task> taskDataList = [];
  List<Task> pendingTaskList = [];
  List<Manager> mngDataList = [];
  List<String?> managerIds = [];

  // Variables to store employee details
  String empName = "";
  String taskTitle = "";
  int totalTasks = 0;
  int completedTasks = 0;
  List<dynamic> taskId = [];
  String? id;
  bool isLogin = true; // Show loader initially

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

  // Method to fetch data from the database
  fetchData() async {
    print("Fetching data for employee ID: $id");

    // Fetch employee data
    empDataList = await AppDataBase().getEmpdbInfo(id!);

    // Fetch task data
    taskDataList = await AppDataBase().getTaskdbInfo(id!);

    // Fetch pending task data
    pendingTaskList = await AppDataBase().getPendingTaskdbInfo(id!);

    // Fetch task IDs
    taskId = await AppDataBase().getTaskId(id!);
    print("Data fetched, total tasks: ${taskDataList.length}");

    // Safeguard against empty lists
    if (empDataList.isNotEmpty) {
      empName = empDataList.first.name!;
    }

    if (taskDataList.isNotEmpty) {
      taskTitle = taskDataList.first.title!;
    }

    totalTasks = taskDataList.length;

    print("Fetching manager data");

    // Fetch manager IDs from tasks
    managerIds = taskDataList.map((task) => task.assigned_by).toList();

    // Fetch manager data based on manager IDs
    mngDataList = await AppDataBase().getManagerdbInfo(managerIds);
    print("Fetched manager data");

    // Calculate completed tasks
    completedTasks =
        taskDataList.where((task) => task.status == 'completed').length;
    print("Completed tasks: $completedTasks");

    // Disable loader and update UI
    setState(() {
      isLogin = false;
    });
  }

  @override
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

  @override
  Widget build(BuildContext context) {
    double taskProgress =
    totalTasks > 0 ? (completedTasks / totalTasks) * 100 : 0;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(empName),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(Icons.notifications_active_outlined)),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 20, 0),
            child: CircleAvatar(
              backgroundColor: Colors.blueAccent,
              radius: 20,
              child: empDataList.first.image == null ?Icon(Icons.person,color: Colors.white,): null,
              backgroundImage: empDataList.first.image != null ? FileImage(File(empDataList.first.image!)): null,
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.all(0),
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ), //BoxDecoration
              child: Center(
                child: UserAccountsDrawerHeader(
                  decoration: BoxDecoration(color: Colors.green),
                  accountName: Text(
                    empName,
                    style: TextStyle(fontSize: 15),
                  ),
                  accountEmail: Text(empDataList.first.email!),
                  currentAccountPictureSize: Size.square(50),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 165, 255, 137),
                    child: empDataList.first.image == null ?Icon(Icons.person,color: Colors.white,): null,
                    backgroundImage: empDataList.first.image != null ? FileImage(File(empDataList.first.image!)): null, //Text
                  ), //circleAvatar
                ),
              ), //UserAccountDrawerHeader
            ), //DrawerHeader
            ListTile(
              leading: const Icon(Icons.phone),
              title: Text(empDataList.first.contact!),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.password),
              title: Text(empDataList.first.designation!),
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
      body: SafeArea(
        child: isLogin
            ? Center(
          child: CircularProgressIndicator(),
        )
            : BlocProvider<EmpDashBloc>(
          create: (context) => EmpDashBloc(),
          child: BlocBuilder<EmpDashBloc, EmpDashState>(
            builder: (context, state) {
              return Container(
                // padding: EdgeInsets.fromLTRB(15, 20, 15, 0),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
                        child: EasyDateTimeLine(
                          initialDate: DateTime.now(),
                          headerProps: EasyHeaderProps(
                              selectedDateStyle: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                              monthPickerType: MonthPickerType.switcher,
                              monthStyle: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                          dayProps: EasyDayProps(
                              dayStructure:
                              DayStructure.dayStrDayNumMonth,
                              activeDayStyle: DayStyle(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xff3371FF),
                                      Color(0xff8426D6)
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(10)),
                                ),
                              ),
                              todayHighlightColor: Color(0xffc8eccc),
                              todayHighlightStyle:
                              TodayHighlightStyle.withBackground),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: Container(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Today's Tasks",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ),
                                  TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        "Show all",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15),
                                      ))
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height:
                                MediaQuery.of(context).size.height *
                                    0.2,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: taskDataList.length,
                                    itemBuilder: (context, index) {
                                      final taskList =
                                      taskDataList[index];
                                      final id = taskId[index] as int;
                                      return Utility().taskContainerUtil(
                                          context,
                                          taskList.title!,
                                          taskList.description!,
                                          taskList.status!,
                                          taskList.assigned_by!,
                                              () async {
                                            print(
                                                "$id status ${taskList.status}");
                                            await updateTaskStatus(id as int);
                                            print(
                                                "$id status ${taskList.status}");
                                            setState(() {});
                                            print("REBUILD");
                                            Navigator.of(context).pop();
                                          });
                                    }),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Stack(
                        children: [
                          Padding(
                            padding:
                            const EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: Container(
                              height: MediaQuery.of(context).size.height *
                                  0.25,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Color(0xFFADEDE3),
                                borderRadius:
                                BorderRadius.all(Radius.circular(20)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.4),
                                    spreadRadius: 2,
                                    blurRadius: 8,
                                    offset: Offset(-2, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        15, 20, 0, 20),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Today's Progress",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding:
                                        const EdgeInsets.fromLTRB(
                                            20, 0, 0, 0),
                                        child: Container(
                                          height: 30,
                                          width: 50,
                                          // margin: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Color(0xFF42F1A8),
                                            borderRadius:
                                            BorderRadius.all(
                                                Radius.circular(20)),
                                          ),
                                          child: Center(
                                              child: Text(
                                                  "$completedTasks/$totalTasks")),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10),
                                        child: Text(
                                          "Task",
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        35, 10, 0, 10),
                                    child: Text(
                                      "You have marked $completedTasks/$totalTasks\ncompleted 🎉",
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 0, 0, 0),
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        elevation: 10,
                                        backgroundColor:
                                        Color(0xFF42F1A8),
                                      ),
                                      child: Text(
                                        "All Tasks",
                                        style: TextStyle(
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 60,
                            right: 35,
                            child: SizedBox(
                              height: 120,
                              width: 120,
                              child: SfRadialGauge(axes: <RadialAxis>[
                                RadialAxis(
                                  minimum: 0,
                                  maximum: 100,
                                  showLabels: false,
                                  showTicks: false,
                                  axisLineStyle: AxisLineStyle(
                                    thickness: 0.2,
                                    cornerStyle: CornerStyle.bothCurve,
                                    color: Colors.white,
                                    thicknessUnit: GaugeSizeUnit.factor,
                                  ),
                                  pointers: [
                                    RangePointer(
                                      value: taskProgress,
                                      width: 14,
                                      color: Colors.lightBlueAccent,
                                      cornerStyle: CornerStyle.bothCurve,
                                    )
                                  ],
                                  annotations: [
                                    GaugeAnnotation(
                                      widget: Text(
                                        "${taskProgress.toStringAsFixed(0)}%",
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ]),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: Container(
                          // color: Colors.red,
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Tasks Assigned By",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: mngDataList.length,
                                itemBuilder: (context, index) {
                                  final mngList = mngDataList[index];
                                  return Utility().mngContainerUtil(
                                      context,
                                      mngList.mname!,
                                      mngList.memail!,
                                      mngList.mcontact!,
                                      mngList.mimage ?? ""
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class EmpDashBloc extends Bloc<EmpDashEvent, EmpDashState> {
  EmpDashBloc() : super(InitialState());
}

abstract class EmpDashState {}

class InitialState extends EmpDashState {}

abstract class EmpDashEvent {}
