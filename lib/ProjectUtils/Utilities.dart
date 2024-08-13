import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            label: Text(label),
            hintText: hint),
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
            ? SnackBarAction(label: label!,textColor: Colors.black, onPressed: onPressed!)
            : null,
      ),
    );
  }
}
