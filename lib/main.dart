import 'package:flutter/material.dart';
import 'package:inter_business_comm_system/Database/SharedPref.dart';
import 'package:inter_business_comm_system/screens/AllTasksScreen.dart';
import 'package:inter_business_comm_system/screens/EmployeeDashboard.dart';
import 'package:inter_business_comm_system/screens/HomeScreen.dart';
import 'package:inter_business_comm_system/screens/LoginScreen.dart';
import 'package:inter_business_comm_system/screens/ManagerDashboard.dart';
import 'package:inter_business_comm_system/screens/SignupScreen.dart';
import 'package:inter_business_comm_system/services/Employeeservice.dart';
import 'package:inter_business_comm_system/services/Managerservice.dart';
import 'package:inter_business_comm_system/services/taskservice.dart';
import 'Database/Database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isLoggedIn = await SharedPref().getData('isLoggedIn') ?? false;
  final role = await SharedPref().getData('role');
  final id = await SharedPref().getData('id');
  runApp(MyApp(
    isLoggedIn: isLoggedIn,
    role: role,
    id: id,
  ));
}

class MyApp extends StatefulWidget {
  bool? isLoggedIn;
  String? role;
  String? id;

  MyApp({required this.isLoggedIn, required this.id, this.role});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    loaddb();
  }

  loaddb() async {
    await AppDataBase().getDatabase();
    int employeeCount = await Employee().countEmployees();
    int managerCount = await Manager().countManagers();
    int taskCount = await Task().countTasks();

    if (employeeCount == 0 && managerCount == 0 && taskCount == 0) {
      await Employee().saveemp();
      await Manager().savemanager();
      await Task().savetask();
    }
  }

  @override
  Widget build(BuildContext context) {
    final lightTheme = ThemeData(
      primaryColor: Color(0xFF03A855),
      primaryColorLight: Color(0xFFEBF8F1),
      primaryColorDark: Color(0xFF212B35),
      secondaryHeaderColor: Color(0xFFC9FACD),
      scaffoldBackgroundColor: Color(0xFFEBF8F1),
      cardColor: Color(0xFF785B53),
    );

    Widget initialScreen;
    if (widget.isLoggedIn!) {
      if (widget.role == 'Manager') {
        initialScreen = ManagerDashboard(widget.id);
      } else if (widget.role == 'Employee') {
        initialScreen = EmployeeDashboard(widget.id);
      } else {
        initialScreen = HomeScreen();
      }
    } else {
      initialScreen = HomeScreen();
    }

    return MaterialApp(
      theme: lightTheme,
      routes: {
        "/HomeScreen": (context) => HomeScreen(),
        "/LoginScreen": (context) => LoginScreen(),
        "/SignupScreen": (context) => SignupScreen(),
        "/EmployeeDashboard": (context) => EmployeeDashboard(widget.id),
        "/ManagerDashboard": (context) => ManagerDashboard(widget.id),
        "/TasksScreen": (context) => TasksScreen(),
      },
      debugShowCheckedModeBanner: false,
      home: initialScreen,
    );
  }
}
