// ignore_for_file: prefer_const_literals_to_create_immutables, avoid_print, avoid_function_literals_in_foreach_calls

import 'dart:io';

import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inter_business_comm_system/ProjectUtils/Utilities.dart';
import 'package:inter_business_comm_system/services/Employeeservice.dart';
import 'package:inter_business_comm_system/services/Managerservice.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sqflite/sqflite.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../Database/Database.dart';
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
  bool isLoading = true;

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

    try {
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
    } catch (error) {
      print("Error fetching data: $error");
    } finally {
      // Disable loader and update UI
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double taskProgress =
        totalTasks > 0 ? (completedTasks / totalTasks) * 100 : 0;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // Transparent background for the AppBar
        backgroundColor: Colors.transparent,

        // Title of the AppBar, defaults to 'Employee' if empName is null or empty
        title: Text(empName ?? 'Employee'),

        actions: [
          // Notification button with no action implemented
          IconButton(
            onPressed: () {
              // Add functionality here
            },
            icon: Icon(Icons.notifications_active_outlined),
          ),

          // Padding for the avatar to ensure it's spaced from the edge
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 20, 0),
            child: CircleAvatar(
              backgroundColor: Colors.blueAccent,
              radius: 20,

              // Conditionally set the background image of the avatar
              backgroundImage:
                  empDataList.isNotEmpty && empDataList.first.image != null
                      ? FileImage(File(empDataList.first.image!))
                      : null,

              // If there is no image, show a default icon
              child: empDataList.isNotEmpty && empDataList.first.image == null
                  ? Icon(
                      Icons.person,
                      color: Colors.white,
                    )
                  : null,
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.all(0),
          children: [
            // Drawer Header
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green, // Background color for DrawerHeader
              ),
              child: Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Color.fromARGB(255, 165, 255, 137),
                      backgroundImage: empDataList.isNotEmpty &&
                              empDataList.first.image != null
                          ? FileImage(File(empDataList.first.image!))
                          : null,
                      child: empDataList.isNotEmpty &&
                              empDataList.first.image == null
                          ? Icon(
                              size: 35,
                              Icons.person_outlined,
                              color: Colors.black,
                            )
                          : null,
                    ),
                    Text(
                      empName ?? 'Name Not Available',
                      // Fallback text if empName is null
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      empDataList.isNotEmpty && empDataList.first.email != null
                          ? empDataList.first.email!
                          : 'Email Not Available', // Fallback text if email is null or list is empty
                    ),
                  ],
                ),
                // child: UserAccountsDrawerHeader(
                //   decoration: BoxDecoration(color: Colors.green),
                //   // Background color for UserAccountsDrawerHeader
                //   accountName: Text(
                //     empName ?? 'Name Not Available',
                //     // Fallback text if empName is null
                //     style: TextStyle(fontSize: 15),
                //   ),
                //   accountEmail: Text(
                //     empDataList.isNotEmpty && empDataList.first.email != null
                //         ? empDataList.first.email!
                //         : 'Email Not Available', // Fallback text if email is null or list is empty
                //   ),
                //   currentAccountPictureSize: Size.square(50),
                //   // Size of the profile picture
                //   currentAccountPicture: CircleAvatar(
                //     backgroundColor: Color.fromARGB(255, 165, 255, 137),
                //     // Background color for the CircleAvatar
                //     backgroundImage: empDataList.isNotEmpty &&
                //             empDataList.first.image != null
                //         ? FileImage(File(empDataList.first.image!))
                //         : null,
                //     // Use FileImage if image is available
                //     child: empDataList.isNotEmpty &&
                //             empDataList.first.image == null
                //         ? Icon(
                //             Icons.person,
                //             color: Colors.white, // Default icon color
                //           )
                //         : null, // Use default icon if image is null
                //   ),
                // ),
              ),
            ),

            // Contact Information
            ListTile(
              leading: const Icon(Icons.phone),
              title: Text(
                empDataList.isNotEmpty && empDataList.first.contact != null
                    ? empDataList.first.contact!
                    : 'Contact Not Available', // Fallback text if contact is null or list is empty
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            // Designation Information
            ListTile(
              leading: const Icon(Icons.password),
              title: Text(
                empDataList.isNotEmpty && empDataList.first.designation != null
                    ? empDataList.first.designation!
                    : 'Designation Not Available', // Fallback text if designation is null or list is empty
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            // Logout Option
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('LogOut'),
              onTap: () async {
                // Clear user session data from SharedPreferences
                // final SharedPreferences prefs =
                //     await SharedPreferences.getInstance();
                // await prefs.setBool('isLogin', false);
                // await prefs.setBool('isManager', false);
                //
                // // Navigate back to HomeScreen and remove all previous routes
                Navigator.pushNamedAndRemoveUntil(
                    context, '/LoginScreen', (route) => false);
              },
            ),
          ],
        ),
      ),
      body: isLoading
          ? Center(
              child: SizedBox(
                height: 100,
                width: 100,
                child: LiquidCircularProgressIndicator(
                  value: 0.80,
                  valueColor: AlwaysStoppedAnimation(Colors.pink),
                  backgroundColor: Colors.white,
                  borderColor: Colors.black,
                  borderWidth: 5.0,
                  direction: Axis.vertical,
                  center: Text(
                    "Loading..",
                    style: TextStyle(color: Colors.cyanAccent),
                  ),
                ),
              ),
            )
          // ? Container(
          //     color: Colors.black.withOpacity(0.5),
          //     child: const Center(
          //       child: Align(
          //         alignment: Alignment.center,
          //         child: LinearProgressIndicator(
          //           backgroundColor: Colors.black,
          //           valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
          //         ),
          //       ),
          //     ),
          //   )
          // ? Shimmer.fromColors(
          //     baseColor: Colors.grey[300]!,
          //     highlightColor: Colors.grey[500]!,
          //     child: ListView.builder(
          //       itemCount: 5,
          //       itemBuilder: (context, index) {
          //         return ListTile(
          //           title: Container(
          //             height: MediaQuery.of(context).size.height * 0.2,
          //             width: MediaQuery.of(context).size.width,
          //             color: Colors.white,
          //           ),
          //         );
          //       },
          //     ),
          //   )
          : SafeArea(
              child: BlocProvider<EmpDashBloc>(
                create: (context) => EmpDashBloc(),
                child: BlocBuilder<EmpDashBloc, EmpDashState>(
                  builder: (context, state) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // Date Time Line
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
                              child: EasyDateTimeLine(
                                initialDate: DateTime.now(),
                                headerProps: EasyHeaderProps(
                                  selectedDateStyle: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  monthPickerType: MonthPickerType.switcher,
                                  monthStyle: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                dayProps: EasyDayProps(
                                  dayStructure: DayStructure.dayStrDayNumMonth,
                                  activeDayStyle: DayStyle(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xff3371FF),
                                          Color(0xff8426D6),
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                  ),
                                  todayHighlightColor: Color(0xffc8eccc),
                                  todayHighlightStyle:
                                      TodayHighlightStyle.withBackground,
                                ),
                              ),
                            ),
                            SizedBox(height: 20),

                            // Today's Tasks Section
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
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, '/TasksScreen',
                                                arguments: id);
                                          },
                                          child: Text(
                                            "Show all",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5),
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
                                              taskDataList.isNotEmpty
                                                  ? taskDataList[index]
                                                  : null;
                                          final id = taskId.isNotEmpty
                                              ? taskId[index] as int
                                              : null;

                                          if (taskList == null || id == null) {
                                            return SizedBox
                                                .shrink(); // Return an empty widget if data is null
                                          }

                                          return Utility().taskContainerUtil(
                                            context,
                                            taskList.title ?? 'No Title',
                                            taskList.description ??
                                                'No Description',
                                            taskList.status ?? 'No Status',
                                            taskList.assigned_by ?? 'Unknown',
                                            () async {
                                              print(
                                                  "$id status ${taskList.status}");
                                              await updateTaskStatus(id);
                                              print(
                                                  "$id status ${taskList.status}");
                                              setState(() {});
                                              print("REBUILD");
                                              Navigator.of(context).pop();
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 10),

                            // Today's Progress Section
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
                                                decoration: BoxDecoration(
                                                  color: Color(0xFF42F1A8),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20)),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    "$completedTasks/$totalTasks",
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                ),
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
                                              35, 10, 180, 10),
                                          child: Text(
                                            maxLines: 2,
                                            softWrap: true,
                                            "You have marked $completedTasks/$totalTasks completed 🎉",
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              20, 0, 0, 0),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                  context, '/TasksScreen',
                                                  arguments: id);
                                            },
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
                                    child: SfRadialGauge(
                                      axes: <RadialAxis>[
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
                                              value: taskProgress ?? 0,
                                              // Default to 0 if null
                                              width: 14,
                                              color: Colors.lightBlueAccent,
                                              cornerStyle:
                                                  CornerStyle.bothCurve,
                                            )
                                          ],
                                          annotations: [
                                            GaugeAnnotation(
                                              widget: Text(
                                                "${taskProgress?.toStringAsFixed(0) ?? '0'}%",
                                                // Default to '0%' if null
                                                style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 30),

                            // Tasks Assigned By Section
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                              child: Container(
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Tasks Assigned By",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 30),
                                    ListView.builder(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      itemCount: mngDataList.length,
                                      itemBuilder: (context, index) {
                                        final mngList = mngDataList.isNotEmpty
                                            ? mngDataList[index]
                                            : null;
                                        if (mngList == null) {
                                          return SizedBox
                                              .shrink(); // Return an empty widget if data is null
                                        }
                                        return Utility().mngContainerUtil(
                                          context,
                                          mngList.mname ?? 'No Name',
                                          mngList.memail ?? 'No Email',
                                          mngList.mcontact ?? 'No Contact',
                                          mngList.mimage ?? '',
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 40),
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

class LoadingState extends EmpDashState {}

class LoadedState extends EmpDashState {}

abstract class EmpDashEvent {}
