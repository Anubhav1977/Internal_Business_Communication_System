// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inter_business_comm_system/ProjectUtils/Utilities.dart';
import 'package:inter_business_comm_system/services/Employeeservice.dart';
import 'package:sqflite/sqflite.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../Database.dart';

class EmployeeDashboard extends StatefulWidget {
  String? id;

  EmployeeDashboard({this.id});

  @override
  State<EmployeeDashboard> createState() => _EmployeeDashboardState();
}

class _EmployeeDashboardState extends State<EmployeeDashboard> {
  List<Employee> empDataList = [];
  String empName = "";

  fetchData() async {
    print("Getting emp data from db");
    empDataList = await AppDataBase().getEmpdbInfo(widget.id!);
    print("Emp data fetched");
    empName = empDataList.first.name!;
    empDataList.forEach((ele) {
      print(ele.toString());
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // fetchData();
  }

  @override
  Widget build(BuildContext context) {
    // String? id = ModalRoute.of(context)?.settings.arguments as String;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Dashboard"),
        leading: Icon(Icons.menu),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(Icons.notifications_active_outlined)),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 20, 0),
            child: CircleAvatar(
              backgroundColor: Colors.blueAccent,
              radius: 20,
              child: Icon(Icons.person),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: BlocProvider<EmpDashBloc>(
          create: (context) => EmpDashBloc(),
          child: BlocBuilder<EmpDashBloc, EmpDashState>(
            builder: (context, state) {
              return Container(
                padding: EdgeInsets.fromLTRB(15, 20, 15, 0),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    EasyDateTimeLine(
                      initialDate: DateTime.now(),
                      headerProps: EasyHeaderProps(
                          selectedDateStyle: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          monthPickerType: MonthPickerType.switcher,
                          monthStyle: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      dayProps: EasyDayProps(
                          dayStructure: DayStructure.dayStrDayNumMonth,
                          activeDayStyle: DayStyle(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xff3371FF), Color(0xff8426D6)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                          todayHighlightColor: Color(0xffc8eccc),
                          todayHighlightStyle:
                              TodayHighlightStyle.withBackground),
                    ),
                    SizedBox(height: 15,),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Hello",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "$empName",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          fontSize: 26,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 10),
                      // color: Colors.red,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              IconButton(
                                onPressed: () {},
                                icon: CircleAvatar(
                                  backgroundColor:
                                      Theme.of(context).secondaryHeaderColor,
                                  child:
                                      Icon(Icons.arrow_circle_right_outlined),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Utility().taskContainerUtil(
                                    context, "taskTitle", "taskDes"),
                                Utility().taskContainerUtil(
                                    context, "taskTitle", "taskDes"),
                                Utility().taskContainerUtil(
                                    context, "taskTitle", "taskDes"),
                                Utility().taskContainerUtil(
                                    context, "taskTitle", "taskDes"),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Stack(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.25,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.greenAccent,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 20, 0, 20),
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
                                  Container(
                                    height: 30,
                                    width: 70,
                                    margin: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                    ),
                                    child: Center(child: Text("3/5")),
                                  ),
                                  Text("Task"),
                                ],
                              ),
                              Container(
                                height: 40,
                                width: 90,
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
                                child: Center(child: Text("All Tasks")),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 30,
                          right: 25,
                          child: SizedBox(
                            height: 150,
                            width: 150,
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
                                    value: 70,
                                    width: 14,
                                    color: Theme.of(context).primaryColor,
                                    cornerStyle: CornerStyle.bothCurve,
                                  )
                                ],
                                annotations: [
                                  GaugeAnnotation(
                                    widget: Text(
                                      "70%",
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
                    Container(),
                  ],
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

class PendingScreen extends StatefulWidget {
  String? id;

  PendingScreen({this.id});

  @override
  State<PendingScreen> createState() => _PendingScreenState();
}

class _PendingScreenState extends State<PendingScreen> {
  @override
  Widget build(BuildContext context) {
    employeedata() async {
      Database _db = await AppDataBase().getDatabase();
      List<Map<String, dynamic>> dbData = await _db.rawQuery(
          'SELECT * FROM TASK WHERE targetId = ? AND status = ?',
          [widget.id, "pending"]);
      return dbData;
    }

    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: employeedata(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Map<String, dynamic>> elist = snapshot.data!;
            if (elist.isEmpty) {
              // Show "No tasks assigned" message when data is empty
              return Center(
                child: Text(
                  'No tasks assigned',
                  style: TextStyle(fontSize: 24),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: elist.length,
                itemBuilder: (context, index) {
                  final item = elist[index];
                  return Dismissible(
                    key: ObjectKey(item), // Unique key for each item
                    onDismissed: (direction) async {
                      // Update the status of the item in the database
                      Database _db = await AppDataBase().getDatabase();
                      await _db.rawUpdate(
                        'UPDATE TASK SET status = ? WHERE id = ?',
                        ['completed', item['id']],
                      );

                      // Remove the item from the list
                      setState(() {
                        elist.removeAt(index);
                      });
                    },
                    background: Container(
                      margin: EdgeInsets.all(10),
                      height: MediaQuery.of(context).size.height * 0.08,
                      width: MediaQuery.of(context).size.width * 0.86,
                      color: Colors.green,
                      alignment: Alignment.centerRight,
                      // Background color when swiping
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Color.fromARGB(55, 76, 175, 80),
                        child: Icon(
                          Icons.done_outlined,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                      //padding: EdgeInsets.only(right: 20),
                    ),
                    child: Container(
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)),
                      //padding: EdgeInsets.all(20),
                      height: MediaQuery.of(context).size.height * 0.08,
                      width: MediaQuery.of(context).size.width * 0.94,
                      child: Text(item.toString()), // Convert item to string
                    ),
                  );
                },
              );
            }
          } else if (snapshot.hasError) {
            // Show error message when data loading fails
            return Center(
              child: Text(
                'Error loading data: ${snapshot.error}',
                style: TextStyle(fontSize: 24, color: Colors.red),
              ),
            );
          } else {
            // Show loading indicator when data is being loaded
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      // floatingActionButton: FloatingActionButton(onPressed: (){
      //   Navigator.push(context, MaterialPageRoute(builder: (context) => CompletedScreen(id: widget.id,)));
      // },),
    );
  }
}
