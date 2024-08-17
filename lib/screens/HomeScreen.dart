import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inter_business_comm_system/Database/SharedPref.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isChecking = false;
  bool _isLoggedIn = false;
  bool _isManager = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    setState(() {
      _isChecking = true;
    });
    final prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLogin') ?? false;
    bool isManager = prefs.getBool('isManager') ?? false;

    setState(() {
      _isLoggedIn = isLoggedIn;
      _isManager = isManager;
      _isChecking = false;
    });

    if (_isLoggedIn) {
      // Navigate to the appropriate dashboard
      if (_isManager) {
        Navigator.pushReplacementNamed(context, "/ManagerDashboard");
      } else {
        Navigator.pushReplacementNamed(context, "/EmployeeDashboard");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Mint Cream background color
      body: _isChecking
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: BlocProvider<HomeBloc>(
                create: (context) => HomeBloc(),
                child: Container(
                  padding: EdgeInsets.fromLTRB(20, 50, 20, 0),
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: BlocListener<HomeBloc, HomeState>(
                    listener: (context, state) {
                      if (state is LoginSuccess) {
                        Navigator.pushNamed(context, "/LoginScreen");
                      }
                      if (state is SignSuccess) {
                        Navigator.pushNamed(context, "/SignupScreen");
                      }
                    },
                    child: BlocBuilder<HomeBloc, HomeState>(
                      builder: (context, state) {
                        return Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Welcome",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 26,
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Please Login or Signup to Continue",
                                style: TextStyle(
                                    fontSize: 16, color: Color(0xFF1C232B)),
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.3,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.contain,
                                  image: NetworkImage(
                                      "https://img.freepik.com/free-vector/hand-drawn-business-communication-concept_23-2149167947.jpg"),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Text(
                              "Enter Via Socials",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF1C232B)), // Gunmetal 2
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      elevation: 5,
                                      backgroundColor:
                                          Color(0xFFFFFFFF), // White
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(200),
                                        ),
                                      ),
                                      side: BorderSide(
                                          color: Theme.of(context)
                                              .primaryColor), // Pigment Green border
                                    ),
                                    child: FaIcon(FontAwesomeIcons.google,
                                        size: 30,
                                        color: Theme.of(context)
                                            .primaryColor), // Pigment Green
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      elevation: 5,
                                      backgroundColor:
                                          Color(0xFFFFFFFF), // White
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(200),
                                        ),
                                      ),
                                      side: BorderSide(
                                          color: Theme.of(context)
                                              .primaryColor), // Pigment Green border
                                    ),
                                    child: FaIcon(FontAwesomeIcons.twitter,
                                        size: 30,
                                        color: Theme.of(context)
                                            .primaryColor), // Pigment Green
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                height: 30,
                                width: MediaQuery.of(context).size.width * 0.4,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: AnimatedToggleSwitch.dual(
                                  current: _isManager,
                                  first: false,
                                  second: true,
                                  onChanged: (value) {
                                    setState(() {
                                      _isManager = value;
                                    });
                                  },
                                  styleBuilder: (value) => ToggleStyle(
                                      backgroundColor: Color(0xFFEBF8F1),
                                      indicatorColor: value
                                          ? Colors.greenAccent
                                          : Colors.redAccent),
                                  iconBuilder: (value) => value
                                      ? Icon(Icons.person)
                                      : Icon(Icons.business_center_outlined),
                                  textBuilder: (value) => value
                                      ? Text(
                                          "As Employee",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )
                                      : Text(
                                          "As Manager",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: Color(0xFF1C232B), // Gunmetal 2
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "or Enter using",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF1C232B)), // Gunmetal 2
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: Divider(
                                    color: Color(0xFF1C232B), // Gunmetal 2
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 60,
                              child: ElevatedButton(
                                onPressed: () {
                                  context
                                      .read<HomeBloc>()
                                      .add(LoginSuccessEvent());
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 5,
                                  backgroundColor: Theme.of(context)
                                      .primaryColor, // Pigment Green
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  "Log In",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFFFFFFF)),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 60,
                              child: ElevatedButton(
                                onPressed: () {
                                  context
                                      .read<HomeBloc>()
                                      .add(SignupSuccessEvent());
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 5,
                                  backgroundColor: Theme.of(context)
                                      .primaryColor, // Pigment Green
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFFFFFFF)),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(InitialState()) {
    on<LoginSuccessEvent>(_onLoginSuccessEvent);
    on<SignupSuccessEvent>(_onSignupSuccessEvent);
  }
}

abstract class HomeState {}

abstract class HomeEvent {}

class InitialState extends HomeState {}

class LoginSuccess extends HomeState {}

class SignSuccess extends HomeState {}

class LoginSuccessEvent extends HomeEvent {}

class SignupSuccessEvent extends HomeEvent {}

void _onLoginSuccessEvent(LoginSuccessEvent event, Emitter<HomeState> emit) {
  emit(LoginSuccess());
}

void _onSignupSuccessEvent(SignupSuccessEvent event, Emitter<HomeState> emit) {
  emit(SignSuccess());
}
