// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Utility {
  Widget textfeildUtil(
      TextEditingController controller,
      String label,
      String hint,
      IconData icon,
      BuildContext context,
      String errormsg,
      String exp,
      {bool isSuffix = false,
      TextInputType textinput = TextInputType.text}) {
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
            labelStyle: TextStyle(color: Colors.black),
            hintText: hint,
            hintStyle: TextStyle(color: Theme.of(context).primaryColor)),
        keyboardType: textinput,
        validator: (value) {
          if (value!.isEmpty) {
            return "Please Enter the $label";
          } else if (!RegExp(exp).hasMatch(value)) {
            return errormsg;
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
    VoidCallback onSubmit,
  ) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, left: 15),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.43,
        height: MediaQuery.of(context).size.height * 0.1,
        margin: EdgeInsets.only(top: 5, bottom: 15),
        decoration: BoxDecoration(
          color:
              taskStatus == "pending" ? Color(0xFF789FCB) : Color(0xFF42F1A8),
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
            Column(
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      taskStatus,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color:
                            taskStatus == "pending" ? Colors.red : Colors.green,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
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
                          title: Text(
                            "Update Task Status",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
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
                                      color: Colors.blueAccent.shade200,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                  ),
                                  padding: EdgeInsets.all(12),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Title: ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 16,
                                          ),
                                        ),
                                        TextSpan(
                                          text: taskTitle,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
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
                                      color: Colors.blueAccent.shade200,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                  ),
                                  padding: EdgeInsets.all(12),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Description: ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 16,
                                          ),
                                        ),
                                        TextSpan(
                                          text: taskDes,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: SlideAction(
                                    text: "   Mark as Completed",
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    innerColor: Colors.blueAccent,
                                    outerColor: Colors.blueAccent.shade100,
                                    sliderButtonIcon: Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                    ),
                                    submittedIcon: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    ),
                                    onSubmit: () async {
                                      try {
                                        print("Swipe action triggered");
                                        onSubmit(); // Call the provided onSubmit callback
                                        print("Status update requested");
                                      } catch (e) {
                                        print("Error in swipe action: $e");
                                      }
                                    }),
                              ),
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
              ),
            ),
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
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.1,
        // width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              spreadRadius: 2,
              blurRadius: 8,
              offset: Offset(-2, 4),
            ),
          ],
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
                border: Border.all(color: Colors.black),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(mngImage ??
                      "https://img.freepik.com/free-psd/3d-illustration-person-with-sunglasses_23-2149436188.jpg?size=338&ext=jpg&ga=GA1.1.2008272138.1723593600&semt=ais_hybrid"),
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

  Widget taskDetailsConatiner(String topic, String data) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFD8E7F8),
          border: Border.all(
            width: 1,
            color: Colors.blueAccent.shade200,
          ),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        padding: EdgeInsets.all(12),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "$topic: ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              TextSpan(
                text: data,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
