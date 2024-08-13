// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:math';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inter_business_comm_system/Database.dart';
import 'package:inter_business_comm_system/ProjectUtils/Utilities.dart';
import 'package:shimmer/shimmer.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _key = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPassController = TextEditingController();
  final designationController = TextEditingController();
  bool isManager = false;
  List<String> designation = ["Management", "Business Analyst", "Tech"];
  var currentValue = "Select Designation";

  Future<String> generateEmployeeId(bool isManager) async {
    String prefix = isManager ? "manager_id0" : "emp_id0";
    String? id;
    bool isUnique = false;

    while (!isUnique) {
      const int min = 10;
      const int max = 99;
      int randomnum = min + Random().nextInt(max - min + 1);
      id = "$prefix$randomnum";

      isUnique = await AppDataBase().uniqueIdCheck(id);
    }
    return id!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider<SignBloc>(
          create: (context) => SignBloc(),
          child: BlocListener<SignBloc, SignupState>(
            listener: (context, state) async {
              if (state is SignFailure) {
                Utility().showSnackbarUtil(context, "Enter Valid Details");
              }
              if (state is LoginState) {
                Navigator.pushNamed(context, "/LoginScreen");
              }
              if (state is SignSuccess) {
                if (isManager) {
                  String manager_id = await generateEmployeeId(isManager);
                  AppDataBase().addManagerData(
                      manager_id,
                      nameController.text,
                      phoneController.text,
                      emailController.text,
                      "path",
                      confirmPassController.text);
                  Utility().showSnackbarUtil(
                      context, "Your Unique Employee id : $manager_id",
                      isActionButton: true, label: "Copy", onPressed: () {
                    Clipboard.setData(ClipboardData(text: manager_id))
                        .then((_) {
                      Utility().showSnackbarUtil(context, "Copied");
                    });
                  });
                  Navigator.pushNamed(context, "/LoginScreen");
                } else {
                  String emp_id = await generateEmployeeId(isManager);
                  AppDataBase().addEmployeeData(
                      emp_id,
                      nameController.text,
                      phoneController.text,
                      emailController.text,
                      currentValue,
                      "path",
                      confirmPassController.text);
                  Utility().showSnackbarUtil(
                      context, "Your Unique Employee id : $emp_id",
                      isActionButton: true, label: "Copy", onPressed: () {
                    Clipboard.setData(ClipboardData(text: emp_id)).then((_) {
                      Utility().showSnackbarUtil(context, "Copied");
                    });
                  });
                  Navigator.pushNamed(context, "/LoginScreen");
                }
              }
            },
            child: BlocBuilder<SignBloc, SignupState>(
              builder: (context, state) {
                return NestedScrollView(
                  headerSliverBuilder: (context, innerboxisSelected) => [
                    SliverAppBar(
                      flexibleSpace: FlexibleSpaceBar(
                        background: Image.network(
                          "https://img.freepik.com/premium-vector/obile-registration-profile-verification-login-password-concept-flat-graphic-design_133260-3577.jpg",
                          fit: BoxFit.contain,
                        ),
                      ),
                      pinned: true,
                      forceElevated: innerboxisSelected,
                      backgroundColor: Colors.white,
                      expandedHeight: 350,
                    )
                  ],
                  body: Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.white,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Please Register to Continue",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Form(
                                key: _key,
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 50,
                                      backgroundColor: Theme.of(context)
                                          .secondaryHeaderColor,
                                      child: Icon(Icons.camera),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Utility().textfeildUtil(
                                        nameController,
                                        "Name",
                                        "Enter your Full Name",
                                        Icons.person,
                                        context),
                                    Utility().textfeildUtil(
                                        emailController,
                                        "Email Id",
                                        "Enter your Email",
                                        Icons.email,
                                        context),
                                    Utility().textfeildUtil(
                                        phoneController,
                                        "Contact",
                                        "Enter your Contact Number",
                                        Icons.call,
                                        context),
                                    Utility().textfeildUtil(
                                        passwordController,
                                        "Password",
                                        "Enter your Password",
                                        Icons.key_outlined,
                                        context,
                                        isSuffix: true),
                                    Utility().textfeildUtil(
                                        confirmPassController,
                                        "Password",
                                        "Re-enter your Password",
                                        Icons.key_outlined,
                                        context,
                                        isSuffix: true),
                                    DropdownButtonFormField<String>(
                                      value: currentValue,
                                      items: [
                                        DropdownMenuItem<String>(
                                          value: "Select Designation",
                                          child: Text("Select Designation"),
                                        ),
                                        ...designation.map((String desig) {
                                          return DropdownMenuItem<String>(
                                            value: desig,
                                            child: Text(desig),
                                          );
                                        }).toList(),
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          currentValue =
                                              value ?? "Select Designation";
                                        });
                                      },
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.business,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        label: Text("Designation"),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Divider(
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text("Enter via Socials",
                                            style: TextStyle(fontSize: 16)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                          child: Divider(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Utility().socialButtonUtil(
                                            context, FontAwesomeIcons.google),
                                        SizedBox(width: 20),
                                        Utility().socialButtonUtil(
                                            context, FontAwesomeIcons.twitter),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 200,
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          padding: EdgeInsets.all(15),
                          width: MediaQuery.of(context).size.width,
                          // height: 80,
                          color: Colors.white,
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  height: 30,
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: AnimatedToggleSwitch.dual(
                                    current: isManager,
                                    first: false,
                                    second: true,
                                    onChanged: (value) {
                                      setState(() {
                                        isManager = value;
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
                              Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (!_key.currentState!.validate()) {
                                      context
                                          .read<SignBloc>()
                                          .add(SignFailureEvent());
                                    } else {
                                      context
                                          .read<SignBloc>()
                                          .add(SignSuccessEvent());
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      )),
                                  child: Center(
                                    child: Text(
                                      "Sign Up",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Don't have an account?",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      context
                                          .read<SignBloc>()
                                          .add(LoginEvent());
                                    },
                                    child: Text(
                                      "Log in",
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
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
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class SignBloc extends Bloc<SignupEvent, SignupState> {
  SignBloc() : super(InitialState()) {
    // on<TogglePasswordVisibilityEvent>(_onTogglePasswordVisibilityEvent);
    on<SignSuccessEvent>(_onSignSuccessEvent);
    on<SignFailureEvent>(_onSignFailureEvent);
    on<LoginEvent>(_onLoginEvent);
  }
}

abstract class SignupState {}

abstract class SignupEvent {}

class InitialState extends SignupState {}

class SignSuccess extends SignupState {}

class SignFailure extends SignupState {}

class LoginState extends SignupState {}

// class PasswordVisibilityState extends SignupState {
//   bool isObscure = true;
//
//   PasswordVisibilityState({required this.isObscure});
// }

class SignSuccessEvent extends SignupEvent {}

class SignFailureEvent extends SignupEvent {}

class LoginEvent extends SignupEvent {}

// class TogglePasswordVisibilityEvent extends LoginEvent {
//   bool isObscure = true;
//   TogglePasswordVisibilityEvent({required this.isObscure});
// }

// void _onTogglePasswordVisibilityEvent(
//     TogglePasswordVisibilityEvent event, Emitter<LoginState> emit) {
//   emit(PasswordVisibilityState(isObscure: !event.isObscure));
// }

void _onSignSuccessEvent(SignSuccessEvent event, Emitter<SignupState> emit) {
  emit(SignSuccess());
}

void _onSignFailureEvent(SignFailureEvent event, Emitter<SignupState> emit) {
  emit(SignFailure());
}

void _onLoginEvent(LoginEvent event, Emitter<SignupState> emit) {
  emit(LoginState());
}
