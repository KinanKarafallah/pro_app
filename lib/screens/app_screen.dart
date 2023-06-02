import 'package:flutter/material.dart';
import 'package:pro_app/screens/d_screen.dart';
import 'package:pro_app/widgets/auth/new.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
              title: Text(
                'Damascus Uni App',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              actions: [
                DropdownButton(
                  icon: Icon(Icons.more_vert),
                  items: [
                    DropdownMenuItem(
                      child: Container(
                        child: Row(
                          children: [
                            Icon(Icons.exit_to_app),
                            SizedBox(
                              width: 8,
                            ),
                            Text('Log Out'),
                          ],
                        ),
                      ),
                      value: 'Log Out',
                    ),
                  ],
                  onChanged: (itemIdentifier) {
                    if (itemIdentifier == 'Log Out') {
                      FirebaseAuth.instance.signOut();
                    }
                  },
                )
              ],
              bottom: TabBar(
                tabs: [
                  Tab(
                    icon: Icon(Icons.camera),
                    text: 'Diagnosis',
                  ),
                  Tab(
                    icon: Icon(Icons.person),
                    text: 'Patient Information',
                  )
                ],
              )),
          body: TabBarView(children: [
            ImageUpload(),
            NameAgeList(),
          ]),
        ));
  }
}
