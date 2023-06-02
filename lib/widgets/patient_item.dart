import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pro_app/patient_data.dart';

class PatientInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: patient_data.map((patient) {
        return Card(
            elevation: 10,
            child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              patient.firstName + ' ' + patient.secondName,
                              style:
                                  TextStyle(fontSize: 20, color: Colors.purple),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text('Age: ' + patient.age.toString())
                          ]),
                      Text(DateFormat.yMMMd().format(patient.date)),
                    ])));
      }).toList(),
    );
  }
}
