import 'package:flutter/material.dart';
import 'package:pro_app/models/login.dart';
import 'package:pro_app/patient_data.dart';
import 'package:pro_app/widgets/patient_item.dart';

class PatientScreen extends StatefulWidget {
  @override
  _PatientScreenState createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  final firstnamecontroller = TextEditingController();

  final secondnamecontroller = TextEditingController();
  final agecontroller = TextEditingController();
  void saveInfo(String firstName, String lastName, int age) {
    final pList = Info(
      firstName: firstName,
      secondName: lastName,
      age: age,
      date: DateTime.now(),
    );
    setState(() {
      patient_data.add(pList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: double.infinity,
      width: double.infinity,
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10),
              labelText: 'First Name',
            ),
            controller: firstnamecontroller,
          ),
          TextField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10),
              labelText: 'Second Name',
            ),
            controller: secondnamecontroller,
          ),
          TextField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10),
              labelText: 'Age',
            ),
            keyboardType: TextInputType.number,
            controller: agecontroller,
          ),
          TextButton(
            onPressed: () {
              saveInfo(
                firstnamecontroller.text.trim(),
                secondnamecontroller.text.trim(),
                int.parse(agecontroller.text),
              );
            },
            child: Text('Save'),
          ),
          SizedBox(
            height: 5,
          ),
          PatientInfo(),
        ],
      ),
    ));
  }
}
