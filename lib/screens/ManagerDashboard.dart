import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManagerDashboard extends StatefulWidget {
  const ManagerDashboard({super.key});

  @override
  State<ManagerDashboard> createState() => _ManagerDashboardState();
}

class _ManagerDashboardState extends State<ManagerDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manager Dashoard"),
      ),
      body: BlocProvider<MngDashBloc>(
        create: (context) => MngDashBloc(),
        child: BlocBuilder<MngDashBloc, MngDashState>(
          builder: (context, state) {
            return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Card(

              ),
            );
          },
        ),
      ),
    );
  }
}

class MngDashBloc extends Bloc<MngDashEvent, MngDashState> {
  MngDashBloc() : super(InitialState());
}

abstract class MngDashState {}

class InitialState extends MngDashState {}

abstract class MngDashEvent {}
