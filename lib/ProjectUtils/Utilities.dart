// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inter_business_comm_system/screens/EmployeeDashboard.dart';

class Utility {
  Widget textfeildUtil(TextEditingController controller, String label,
      String hint, IconData icon, BuildContext context,
      {bool isSuffix = false}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: TextFormField(
        controller: controller,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Theme.of(context).primaryColor),
            suffixIcon: isSuffix ? Icon(Icons.remove_red_eye) : null,
            focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(width: 2, color: Theme.of(context).primaryColor),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            label: Text(label),
            hintText: hint,
            hintStyle: TextStyle(color: Theme.of(context).primaryColor)),
        validator: (value) {
          if (value!.isEmpty) {
            return "Please Enter the $label";
          }
          return null;
        },
      ),
    );
  }

  Widget socialButtonUtil(BuildContext context, IconData icon) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
      child: SizedBox(
        height: 100,
        width: 100,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            elevation: 5,
            backgroundColor: Color(0xFFFFFFFF), // White
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(200),
              ),
            ),
            side: BorderSide(
                color: Theme.of(context).primaryColor), // Pigment Green border
          ),
          child: FaIcon(icon,
              size: 30, color: Theme.of(context).primaryColor), // Pigment Green
        ),
      ),
    );
  }

  showSnackbarUtil(BuildContext context, String text,
      {bool isActionButton = false, VoidCallback? onPressed, String? label}) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 5,
        behavior: SnackBarBehavior.floating,
        content: Text(text),
        backgroundColor: Colors.red,
        action: isActionButton
            ? SnackBarAction(
                label: label!, textColor: Colors.black, onPressed: onPressed!)
            : null,
      ),
    );
  }

  Widget taskContainerUtil(
    BuildContext context,
    String taskTitle,
    String taskDes,
  ) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, left: 15),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.43,
        height: MediaQuery.of(context).size.height * 0.1,
        margin: EdgeInsets.only(top: 5, bottom: 15),
        decoration: BoxDecoration(
          color: Colors.lightBlueAccent,
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 8,
              offset: Offset(-2, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 18, 12, 0),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Text(
                  taskTitle,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Positioned(
                bottom: 10,
                right: 15,
                child: IconButton(
                  onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PendingScreen(id: "emp_id024",)));
                  },
                  icon: CircleAvatar(
                    radius: 15,
                    backgroundColor: Theme.of(context).secondaryHeaderColor,
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 15,
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
