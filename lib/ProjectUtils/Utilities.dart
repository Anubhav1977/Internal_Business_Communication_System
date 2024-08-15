// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inter_business_comm_system/screens/EmployeeDashboard.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../Database.dart';

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
    String taskStatus,
    String taskAssigedby,
  ) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, left: 15),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.43,
        height: MediaQuery.of(context).size.height * 0.1,
        margin: EdgeInsets.only(top: 5, bottom: 15),
        decoration: BoxDecoration(
          color: Color(0xFF789FCB),
          border: Border.all(width: 2, color: Colors.blue.shade200),
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
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Update Task Status"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 15),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xFFD8E7F8),
                                      border: Border.all(
                                          width: 1,
                                          color: Colors.blueAccent.shade200),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                    ),
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      "Title : $taskTitle",
                                      style: TextStyle(),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 15),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xFFD8E7F8),
                                      border: Border.all(
                                          width: 1,
                                          color: Colors.blueAccent.shade200),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                    ),
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      "Desciption : $taskDes",
                                      style: TextStyle(),
                                    ),
                                  ),
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.only(bottom: 15),
                                //   child: Container(
                                //     decoration: BoxDecoration(
                                //       color: Color(0xFFD8E7F8),
                                //       border: Border.all(
                                //           width: 1,
                                //           color: Colors.blueAccent.shade200),
                                //       borderRadius:
                                //           BorderRadius.all(Radius.circular(20)),
                                //     ),
                                //     padding: EdgeInsets.all(10),
                                //     child: Text(
                                //       "Status : $taskStatus",
                                //       style: TextStyle(),
                                //     ),
                                //   ),
                                // ),
                                // Container(
                                //   child: Dismissible(
                                //     key: ObjectKey(item),
                                //     // Unique key for each item
                                //     onDismissed: (direction) async {
                                //       // Update the status of the item in the database
                                //       Database _db =
                                //           await AppDataBase().getDatabase();
                                //       await _db.rawUpdate(
                                //         'UPDATE TASK SET status = ? WHERE id = ?',
                                //         ['completed', item['id']],
                                //       );
                                //
                                //       // Remove the item from the list
                                //       setState(() {
                                //         elist.removeAt(index);
                                //       });
                                //     },
                                //     background: Container(
                                //       margin: EdgeInsets.all(10),
                                //       height:
                                //           MediaQuery.of(context).size.height *
                                //               0.08,
                                //       width: MediaQuery.of(context).size.width *
                                //           0.86,
                                //       color: Colors.green,
                                //       alignment: Alignment.centerRight,
                                //       // Background color when swiping
                                //       child: CircleAvatar(
                                //         radius: 20,
                                //         backgroundColor:
                                //             Color.fromARGB(55, 76, 175, 80),
                                //         child: Icon(
                                //           Icons.done_outlined,
                                //           color: Colors.white,
                                //           size: 36,
                                //         ),
                                //       ),
                                //       //padding: EdgeInsets.only(right: 20),
                                //     ),
                                //     child: Container(
                                //       margin: EdgeInsets.all(10),
                                //       decoration: BoxDecoration(
                                //           border:
                                //               Border.all(color: Colors.black)),
                                //       //padding: EdgeInsets.all(20),
                                //       height:
                                //           MediaQuery.of(context).size.height *
                                //               0.08,
                                //       width: MediaQuery.of(context).size.width *
                                //           0.94,
                                //       child: Text(task
                                //           .toString()), // Convert item to string
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          );
                        });
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => PendingScreen(id: "emp_id024",)));
                  },
                  icon: CircleAvatar(
                    radius: 15,
                    backgroundColor: Color(0xFFD8E7F8),
                    child: Icon(
                      // color: ,
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

  Widget mngContainerUtil(
    BuildContext context,
    String mngName,
    String mngEmail,
    String mngContact,
    String mngImage,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.1,
        // width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Color(0xFFD8E7F8),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width * 0.16,
              decoration: BoxDecoration(
                // color: Colors.blue,
                borderRadius: BorderRadius.all(Radius.circular(8)),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: mngImage == null
                      ? NetworkImage(
                          "https://img.freepik.com/free-psd/3d-illustration-person-with-sunglasses_23-2149436188.jpg?size=338&ext=jpg&ga=GA1.1.2008272138.1723593600&semt=ais_hybrid")
                      : NetworkImage(mngImage),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mngName,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    mngEmail,
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () async {
                String phoneNumber = mngContact;
                String message = "Hi $mngName";
                final url =
                    "whatsapp://send?phone=$phoneNumber&text=${Uri.encodeComponent(message)}";

                final uri = Uri.parse(url);

                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                } else {
                  print('Could not launch $url');
                }
              },
              icon: FaIcon(FontAwesomeIcons.whatsapp),
            ),
            IconButton(
                onPressed: () => launchUrlString("tel://$mngContact"),
                icon: Icon(Icons.phone)),
          ],
        ),
      ),
    );
  }
}
