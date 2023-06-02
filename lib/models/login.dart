import 'dart:io' as f;

class Info {
  final String firstName;
  final String secondName;
  final int age;
  final DateTime date;
  f.File image;

  Info({this.firstName, this.secondName, this.age, this.date, this.image});
}
