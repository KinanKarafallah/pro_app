import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class NameAgeList extends StatefulWidget {
  @override
  _NameAgeListState createState() => _NameAgeListState();
}

class _NameAgeListState extends State<NameAgeList> {
 
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _ageController = TextEditingController();

  List<Map<String, dynamic>> _nameAgeList = [];

  final String _key = 'name_age_list';

  @override
  void initState() {
    super.initState();
    _loadList();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _loadList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameAgeList = (prefs.getString(_key) as List)
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    });
  }
  Future<void> _saveList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(_nameAgeList));
  }


  void _addToList() {
    setState(() {
      
      String name = _nameController.text;
      int age = int.parse(_ageController.text);
      Map<String , dynamic> nameAge = {'name': name, 'age': age};
      _nameAgeList.add(nameAge);
      _saveList();
      _nameController.clear();
      _ageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _ageController,
                  decoration: InputDecoration(
                    labelText: 'Age',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: _addToList,
                child: Text('Add'),
              ),
            ],
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: _nameAgeList.length,
              itemBuilder: (context, index) {
                String name = _nameAgeList[index]['name'];
                int age = _nameAgeList[index]['age'];
                return ListTile(
                  title: Text(name),
                  subtitle: Text(age.toString()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
